import Mathlib
import RequestProject.Motion.Anim.WGSL

/-!
# Running the shader: the WebGPU dispatch

`RequestProject/Anim/WGSL.lean` shows that the *expression* the generator emits
means the same thing as the formula.  This file covers the other half of the
question — the *program* around it.  The compute kernel that `wgsl.js` emits and
`web/js/webgpu.js` dispatches is

```wgsl
@compute @workgroup_size(8, 8, 1)
fn main(@builtin(global_invocation_id) gid : vec3u) {
  if (gid.x >= U.size.x || gid.y >= U.size.y) { return; }
  let uv = (vec2f(f32(gid.x), f32(gid.y)) + vec2f(0.5)) / vec2f(f32(U.size.x), f32(U.size.y));
  let p  = mix(U.lo, U.hi, uv);
  field[gid.y * U.size.x + gid.x] = hs_field(p);
}
```

dispatched over `⌈w/8⌉ × ⌈h/8⌉` workgroups.  Modelled here:

* `Grid` — the dispatch geometry, and `samplePoint`, the point a thread reads;
* `Dispatch.threads` — every invocation the dispatch launches, including the
  padding invocations that the bounds check turns into no-ops;
* `Dispatch.run` — the effect of the invocations on the storage buffer, applied
  in an arbitrary order, so a schedule is just a list of the threads.

The results are the three things one wants of a GPU port:

* `Dispatch.run_perm` — the buffer does not depend on the order in which the
  threads run, so the kernel is deterministic no matter how the device
  schedules it;
* `Dispatch.result_pixel` / `Dispatch.result_outside` — the buffer holds the
  field at every pixel, and nothing outside the image is touched;
* `gpu_eq_cpu` — with the compiler correctness theorem: dispatching the
  generated shader reproduces, cell for cell, the field the CPU evaluator
  produces from the same formula.
-/

namespace Hesper.Anim

/-- The geometry of one field evaluation: a `width × height` image covering the
view rectangle `[x0, x1] × [y0, y1]`. -/
structure Grid where
  /-- Image width in pixels. -/
  width : ℕ
  /-- Image height in pixels. -/
  height : ℕ
  /-- Left edge of the view window. -/
  x0 : ℝ
  /-- Right edge of the view window. -/
  x1 : ℝ
  /-- Bottom edge of the view window. -/
  y0 : ℝ
  /-- Top edge of the view window. -/
  y1 : ℝ

namespace Grid

variable (G : Grid)

/-- The point sampled by the thread at pixel `(i, j)`: the pixel centre mapped
into the view window, exactly the `mix(U.lo, U.hi, uv)` of the kernel. -/
noncomputable def samplePoint (i j : ℕ) : ℝ × ℝ :=
  (G.x0 + (G.x1 - G.x0) * ((i + 1/2) / G.width),
   G.y0 + (G.y1 - G.y0) * ((j + 1/2) / G.height))

/-- Linear index of pixel `(i, j)` in the storage buffer. -/
def index (i j : ℕ) : ℕ := j * G.width + i

/-- Number of buffer slots the dispatch fills. -/
def size : ℕ := G.width * G.height

theorem index_lt_size {i j : ℕ} (hi : i < G.width) (hj : j < G.height) :
    G.index i j < G.size := by
  have h1 : G.index i j < j * G.width + G.width := by
    unfold index; omega
  calc G.index i j < j * G.width + G.width := h1
    _ = (j + 1) * G.width := by ring
    _ ≤ G.height * G.width := Nat.mul_le_mul_right _ hj
    _ = G.size := by simp [size, Nat.mul_comm]

/-- The linear index determines the pixel: two in-range threads never write to
the same slot of the storage buffer. -/
theorem index_injective {i j i' j' : ℕ} (hi : i < G.width) (hi' : i' < G.width)
    (h : G.index i j = G.index i' j') : i = i' ∧ j = j' := by
  unfold index at h
  have hw : 0 < G.width := lt_of_le_of_lt (Nat.zero_le i) hi
  have hij : i = i' := by
    have h1 : (j * G.width + i) % G.width = i := by
      simp [Nat.mod_eq_of_lt hi]
    have h2 : (j' * G.width + i') % G.width = i' := by
      simp [Nat.mod_eq_of_lt hi']
    rw [← h1, ← h2, h]
  subst hij
  have : j * G.width = j' * G.width := by omega
  exact ⟨rfl, Nat.eq_of_mul_eq_mul_right hw this⟩

end Grid

/-! ## The dispatch -/

/-- Workgroup size of the generated kernel (`@workgroup_size(8, 8, 1)`). -/
def workgroupSize : ℕ := 8

/-- Number of workgroups needed to cover `n` pixels: `⌈n / 8⌉`, which is what
the host code computes before `dispatchWorkgroups`. -/
def workgroupCount (n : ℕ) : ℕ := (n + workgroupSize - 1) / workgroupSize

/-- The lanes of the dispatch cover the image in each direction. -/
theorem lt_workgroup_lanes {n m : ℕ} (h : m < n) : m < workgroupSize * workgroupCount n := by
  unfold workgroupCount workgroupSize
  omega

namespace Dispatch

/-- The global invocation ids the dispatch launches: one per lane of every
workgroup, so `8 * ⌈w/8⌉` by `8 * ⌈h/8⌉` of them — the image plus, in general, a
strip of padding threads that the bounds check discards. -/
def threads (G : Grid) : List (ℕ × ℕ) :=
  (List.range (workgroupSize * workgroupCount G.width)) ×ˢ
    (List.range (workgroupSize * workgroupCount G.height))

/-- The dispatch launches a thread for every pixel of the image. -/
theorem mem_threads {G : Grid} {i j : ℕ} (hi : i < G.width) (hj : j < G.height) :
    (i, j) ∈ threads G := by
  simp [threads, List.mem_product, lt_workgroup_lanes hi, lt_workgroup_lanes hj]

/-- No invocation id occurs twice. -/
theorem threads_nodup (G : Grid) : (threads G).Nodup :=
  List.Nodup.product List.nodup_range List.nodup_range

/-- A thread's effect on the storage buffer: the in-range ones store the field
value in their own slot, the padding ones return without writing. -/
noncomputable def step (G : Grid) (field : ℕ → ℕ → ℝ) (buf : ℕ → ℝ) (th : ℕ × ℕ) : ℕ → ℝ :=
  if th.1 < G.width ∧ th.2 < G.height then
    Function.update buf (G.index th.1 th.2) (field th.1 th.2)
  else buf

/-- Running a list of threads in the order given: one possible schedule. -/
noncomputable def run (G : Grid) (field : ℕ → ℕ → ℝ) (buf : ℕ → ℝ) :
    List (ℕ × ℕ) → ℕ → ℝ
  | [] => buf
  | th :: rest => run G field (step G field buf th) rest

@[simp] theorem run_nil (G : Grid) (field : ℕ → ℕ → ℝ) (buf : ℕ → ℝ) :
    run G field buf [] = buf := rfl

theorem run_cons (G : Grid) (field : ℕ → ℕ → ℝ) (buf : ℕ → ℝ) (th : ℕ × ℕ)
    (rest : List (ℕ × ℕ)) :
    run G field buf (th :: rest) = run G field (step G field buf th) rest := rfl

/-- A thread leaves every slot but its own alone. -/
theorem step_of_ne (G : Grid) (field : ℕ → ℕ → ℝ) (buf : ℕ → ℝ) (th : ℕ × ℕ) {k : ℕ}
    (h : th.1 < G.width → th.2 < G.height → k ≠ G.index th.1 th.2) :
    step G field buf th k = buf k := by
  unfold step
  by_cases hin : th.1 < G.width ∧ th.2 < G.height
  · rw [if_pos hin]
    exact Function.update_of_ne (h hin.1 hin.2) _ _
  · rw [if_neg hin]

/-- A slot no in-range thread of the schedule owns keeps its initial value. -/
theorem run_untouched (G : Grid) (field : ℕ → ℕ → ℝ) (l : List (ℕ × ℕ)) (buf : ℕ → ℝ)
    {k : ℕ} (h : ∀ th ∈ l, th.1 < G.width → th.2 < G.height → k ≠ G.index th.1 th.2) :
    run G field buf l k = buf k := by
  induction l generalizing buf with
  | nil => rfl
  | cons th rest ih =>
    rw [run_cons, ih _ (fun t ht => h t (List.mem_cons_of_mem _ ht)),
      step_of_ne G field buf th (h th List.mem_cons_self)]

/-- Whatever the schedule, the slot of an in-range pixel ends up holding the
field value at that pixel. -/
theorem run_of_mem (G : Grid) (field : ℕ → ℕ → ℝ) (l : List (ℕ × ℕ)) (buf : ℕ → ℝ)
    (hnd : l.Nodup) {i j : ℕ} (hi : i < G.width) (hj : j < G.height)
    (hmem : (i, j) ∈ l) : run G field buf l (G.index i j) = field i j := by
  induction l generalizing buf with
  | nil => simp at hmem
  | cons th rest ih =>
    rcases List.mem_cons.mp hmem with h | h
    · subst h
      have hstep : step G field buf (i, j) (G.index i j) = field i j := by
        unfold step
        rw [if_pos ⟨hi, hj⟩]
        simp
      have hnot : (i, j) ∉ rest := (List.nodup_cons.mp hnd).1
      rw [run_cons, run_untouched G field rest _ ?_, hstep]
      rintro ⟨a, b⟩ hmem' ha hb hEq
      obtain ⟨rfl, rfl⟩ := G.index_injective hi ha hEq
      exact hnot hmem'
    · rw [run_cons]
      exact ih _ (List.nodup_cons.mp hnd).2 h

/-- **Race freedom.**  Two schedules of the same threads leave the same buffer:
the dispatch is deterministic, whatever order the device runs its invocations
in. -/
theorem run_perm (G : Grid) (field : ℕ → ℕ → ℝ) (buf : ℕ → ℝ) {l l' : List (ℕ × ℕ)}
    (hp : l.Perm l') (hnd : l.Nodup) : run G field buf l = run G field buf l' := by
  funext k
  by_cases hk : ∃ th ∈ l, th.1 < G.width ∧ th.2 < G.height ∧ k = G.index th.1 th.2
  · obtain ⟨⟨i, j⟩, hmem, hi, hj, rfl⟩ := hk
    rw [run_of_mem G field l buf hnd hi hj hmem,
      run_of_mem G field l' buf (hp.nodup_iff.mp hnd) hi hj (hp.mem_iff.mp hmem)]
  · push_neg at hk
    have h1 : ∀ th ∈ l, th.1 < G.width → th.2 < G.height → k ≠ G.index th.1 th.2 :=
      fun th ht hi hj => hk th ht hi hj
    rw [run_untouched G field l buf h1,
      run_untouched G field l' buf (fun th ht => h1 th (hp.mem_iff.mpr ht))]

/-- The storage buffer after the whole dispatch. -/
noncomputable def result (G : Grid) (field : ℕ → ℕ → ℝ) (buf : ℕ → ℝ) : ℕ → ℝ :=
  run G field buf (threads G)

/-- Every pixel of the image ends up holding its field value. -/
theorem result_pixel (G : Grid) (field : ℕ → ℕ → ℝ) (buf : ℕ → ℝ) {i j : ℕ}
    (hi : i < G.width) (hj : j < G.height) :
    result G field buf (G.index i j) = field i j :=
  run_of_mem G field _ buf (threads_nodup G) hi hj (mem_threads hi hj)

/-- Nothing past the end of the image is written: the padding invocations of the
last workgroups really are no-ops. -/
theorem result_outside (G : Grid) (field : ℕ → ℕ → ℝ) (buf : ℕ → ℝ) {k : ℕ}
    (hk : G.size ≤ k) : result G field buf k = buf k := by
  refine run_untouched G field _ buf ?_
  rintro ⟨a, b⟩ _ ha hb hEq
  exact absurd (hEq ▸ G.index_lt_size ha hb) (by omega)

end Dispatch

/-! ## The two backends agree -/

/-- The per-thread assignment of the shader's lvalues: `p.x` and `p.y` are the
thread's sample point, everything else (`U.time`, the parameter slots `P[k]`)
comes from the uniform and storage buffers the host filled in. -/
noncomputable def threadEnv (σ₀ : String → ℝ) (p : ℝ × ℝ) : String → ℝ :=
  fun s => if s = "p.x" then p.1 else if s = "p.y" then p.2 else σ₀ s

/-- The corresponding CPU environment: `x` and `y` are the sample point, the
other variables are the animated parameter values at this frame. -/
noncomputable def cpuEnv (env₀ : String → ℝ) (p : ℝ × ℝ) : String → ℝ :=
  fun s => if s = "x" then p.1 else if s = "y" then p.2 else env₀ s

/-- **A shader equivalent to the GPU program.**  Take a formula `e`, lower it
with a binding `ρ` that sends `x` and `y` to the fragment coordinates and every
other variable to a buffer slot holding its value at this frame.  Then
dispatching the generated compute kernel over the grid leaves, in the slot of
each pixel, exactly the number the CPU evaluator computes for that pixel — for
every schedule of the dispatch, and without disturbing any other memory. -/
theorem gpu_eq_cpu (G : Grid) (e : Expr) (he : e.Lowerable) (ρ : String → WExpr)
    (σ₀ env₀ : String → ℝ) (buf : ℕ → ℝ)
    (hx : ρ "x" = .ref "p.x") (hy : ρ "y" = .ref "p.y")
    (hother : ∀ s, s ≠ "x" → s ≠ "y" → ∀ p : ℝ × ℝ,
      WExpr.eval wgslInterp (threadEnv σ₀ p) (ρ s) = env₀ s)
    {i j : ℕ} (hi : i < G.width) (hj : j < G.height) :
    Dispatch.result G
        (fun i j => WExpr.eval wgslInterp (threadEnv σ₀ (G.samplePoint i j)) (compile ρ e))
        buf (G.index i j)
      = Expr.eval studioInterp (cpuEnv env₀ (G.samplePoint i j)) e := by
  rw [Dispatch.result_pixel G _ buf hi hj]
  refine eval_compile_studio ρ _ _ ?_ e he
  intro s
  by_cases hsx : s = "x"
  · subst hsx; simp [hx, WExpr.eval, threadEnv, cpuEnv]
  · by_cases hsy : s = "y"
    · subst hsy; simp [hy, WExpr.eval, threadEnv, cpuEnv]
    · simp [cpuEnv, hsx, hsy, hother s hsx hsy]

/-! ## Plot layers: the same kernel over a single row

A curve layer draws `n + 1` samples of `f` spanning `[a, b]`.  Rather than a
second shader, the studio dispatches the *same* field kernel over a grid one
pixel high whose window is widened by half a step at each end; the pixel centres
the kernel samples are then exactly the abscissae of the curve. -/

/-- The one-row grid a plot layer is dispatched over: `n + 1` threads whose
pixel centres are the sample abscissae `a + (b - a) * i / n`. -/
noncomputable def curveWindow (a b : ℝ) (n : ℕ) : Grid where
  width := n + 1
  height := 1
  x0 := a - (b - a) / (2 * n)
  x1 := b + (b - a) / (2 * n)
  y0 := 0
  y1 := 0

/-- The half-step widening is exactly right: thread `i` of the curve window
samples the `i`-th abscissa of the curve, on the line `y = 0`. -/
theorem samplePoint_curveWindow (a b : ℝ) {n : ℕ} (hn : 0 < n) (i : ℕ) :
    (curveWindow a b n).samplePoint i 0 = (a + (b - a) * (i / n), 0) := by
  have hn' : (n : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr hn.ne'
  have hn1 : ((n : ℝ) + 1) ≠ 0 := by positivity
  have hx : (curveWindow a b n).x0
      + ((curveWindow a b n).x1 - (curveWindow a b n).x0)
        * ((i + 1/2) / ((curveWindow a b n).width : ℝ))
      = a + (b - a) * (i / n) := by
    simp only [curveWindow, Nat.cast_add, Nat.cast_one]
    field_simp
    ring
  simp only [Grid.samplePoint, Prod.mk.injEq]
  exact ⟨hx, by norm_num [curveWindow]⟩

/-- **The curve path is the same theorem.**  Dispatching the generated kernel
over the one-row window leaves, in slot `i`, the value the CPU evaluator gives
the `i`-th sample of the curve. -/
theorem curve_gpu_eq_cpu (a b : ℝ) {n : ℕ} (hn : 0 < n) (e : Expr) (he : e.Lowerable)
    (ρ : String → WExpr) (σ₀ env₀ : String → ℝ) (buf : ℕ → ℝ)
    (hx : ρ "x" = .ref "p.x") (hy : ρ "y" = .ref "p.y")
    (hother : ∀ s, s ≠ "x" → s ≠ "y" → ∀ p : ℝ × ℝ,
      WExpr.eval wgslInterp (threadEnv σ₀ p) (ρ s) = env₀ s)
    {i : ℕ} (hi : i ≤ n) :
    Dispatch.result (curveWindow a b n)
        (fun i j => WExpr.eval wgslInterp
          (threadEnv σ₀ ((curveWindow a b n).samplePoint i j)) (compile ρ e))
        buf ((curveWindow a b n).index i 0)
      = Expr.eval studioInterp (cpuEnv env₀ (a + (b - a) * (i / n), 0)) e := by
  have h := gpu_eq_cpu (curveWindow a b n) e he ρ σ₀ env₀ buf hx hy hother
    (i := i) (j := 0) (by simp [curveWindow]; omega) (by simp [curveWindow])
  rwa [samplePoint_curveWindow a b hn i] at h

end Hesper.Anim
