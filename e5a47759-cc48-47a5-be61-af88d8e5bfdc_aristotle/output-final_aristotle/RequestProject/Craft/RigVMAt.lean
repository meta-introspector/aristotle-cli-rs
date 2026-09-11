import RequestProject.Craft.RigVM

/-!
# Expressions that are only honest over one memory

`RequestProject/RigVM.lean` gives `Pushes is f` and `Runs is f`: an instruction
list means `f` *whatever* the store happens to be.  That is the right notion for
almost everything, but it is too strong for the one place where the kernel divides
by a number it read out of memory: `i32.div_u` **traps** on a zero divisor, so
`op .divu a (wLoad pMass)` means anything at all only over memories whose `pMass`
word is not zero.

This file adds the relative notions

* `PushesAt m is f` — over any store whose memory is `m`, `is` is an expression
  leaving `f`'s value on the stack;
* `RunsAt m is f` — over any store whose memory is `m`, `is` is a statement that
  changes the store by `f`,

together with the same combinators as the absolute versions.  Anything absolute is
relative (`Pushes.at`, `Runs.at`), a relative statement whose memory is untouched
composes with another relative one (`RunsAt.seq`), and a relative statement
composes with an absolute one on the right (`RunsAt.seqR`) — which is exactly the
shape of the kernel's `tick`: it works out its locals over the memory it was
handed, and only then starts writing.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace RigVM

/-- A word of memory is an `i32`. -/
theorem Mem.word_lt (m : Mem) (a : Nat) : m.word a < W32 := by
  have h : ∀ b, m.byte b < 256 := fun b => Nat.mod_lt _ (by decide)
  have h0 := h a
  have h1 := h (a + 1)
  have h2 := h (a + 2)
  have h3 := h (a + 3)
  simp only [Mem.word, W32]
  omega

/-- A byte of memory is a byte. -/
theorem Mem.byte_lt (m : Mem) (a : Nat) : m.byte a < 256 := Nat.mod_lt _ (by decide)

/-- `is` is an expression pushing `f`'s value, over any store whose memory is `m`. -/
def PushesAt (m : Mem) (is : List Instr) (f : Store → Nat) : Prop :=
  ∀ (c : Cfg) (fuel : Nat), c.st.mem = m →
    exec is c fuel = .normal ⟨f c.st :: c.stack, c.st⟩

/-- `is` is a statement changing the store by `f`, over any store whose memory
is `m`. -/
def RunsAt (m : Mem) (is : List Instr) (f : Store → Store) : Prop :=
  ∀ (c : Cfg) (fuel : Nat), c.st.mem = m → exec is c fuel = .normal ⟨c.stack, f c.st⟩

theorem Pushes.at {is : List Instr} {f : Store → Nat} (m : Mem) (h : Pushes is f) :
    PushesAt m is f := fun c fuel _ => h c fuel

theorem Runs.at {is : List Instr} {f : Store → Store} (m : Mem) (h : Runs is f) :
    RunsAt m is f := fun c fuel _ => h c fuel

theorem PushesAt.congr {m : Mem} {is : List Instr} {f g : Store → Nat} (h : PushesAt m is f)
    (e : ∀ st : Store, st.mem = m → f st = g st) : PushesAt m is g := by
  intro c fuel hc
  rw [h c fuel hc, e c.st hc]

theorem RunsAt.congr {m : Mem} {is : List Instr} {f g : Store → Store} (h : RunsAt m is f)
    (e : ∀ st : Store, st.mem = m → f st = g st) : RunsAt m is g := by
  intro c fuel hc
  rw [h c fuel hc, e c.st hc]

/-! ### Expressions -/

theorem PushesAt.load {m : Mem} {a : List Instr} {fa : Store → Nat} (ha : PushesAt m a fa)
    (off : Nat) : PushesAt m (a ++ [.load off]) (fun st => st.mem.word (fa st + off)) := by
  intro c fuel hc
  rw [exec_append, ha c fuel hc]
  simp [exec, step1]

theorem PushesAt.load8 {m : Mem} {a : List Instr} {fa : Store → Nat} (ha : PushesAt m a fa)
    (off : Nat) : PushesAt m (a ++ [.load8 off]) (fun st => st.mem.byte (fa st + off)) := by
  intro c fuel hc
  rw [exec_append, ha c fuel hc]
  simp [exec, step1]

theorem PushesAt.bin {m : Mem} {a b : List Instr} {fa fb : Store → Nat} (o : Bin)
    (ha : PushesAt m a fa) (hb : PushesAt m b fb)
    (hz : ∀ st : Store, st.mem = m → o.divides = true → fb st ≠ 0) :
    PushesAt m (a ++ b ++ [.bin o]) (fun st => o.eval (fa st) (fb st)) := by
  intro c fuel hc
  rw [List.append_assoc, exec_append, ha c fuel hc]
  simp only []
  rw [exec_append, hb ⟨fa c.st :: c.stack, c.st⟩ fuel hc]
  simp only [exec, step1]
  cases hd : o.divides
  · simp
  · simp [hz c.st hc hd]

theorem PushesAt.select {m : Mem} {x y k : List Instr} {fx fy fk : Store → Nat}
    (hx : PushesAt m x fx) (hy : PushesAt m y fy) (hk : PushesAt m k fk) :
    PushesAt m (x ++ y ++ k ++ [.select]) (fun st => if fk st = 0 then fy st else fx st) := by
  intro c fuel hc
  rw [List.append_assoc, List.append_assoc, exec_append, hx c fuel hc]
  simp only []
  rw [exec_append, hy ⟨fx c.st :: c.stack, c.st⟩ fuel hc]
  simp only []
  rw [exec_append, hk ⟨fy c.st :: fx c.st :: c.stack, c.st⟩ fuel hc]
  simp [exec, step1]

/-! ### Statements -/

theorem RunsAt.localSet {m : Mem} {a : List Instr} {fa : Store → Nat} (ha : PushesAt m a fa)
    (i : Nat) : RunsAt m (a ++ [.localSet i]) (fun st => st.set i (fa st)) := by
  intro c fuel hc
  rw [exec_append, ha c fuel hc]
  simp [exec, step1]

theorem RunsAt.store {m : Mem} {a v : List Instr} {fa fv : Store → Nat}
    (ha : PushesAt m a fa) (hv : PushesAt m v fv) (off : Nat) :
    RunsAt m (a ++ v ++ [.store off])
      (fun st => { st with mem := st.mem.setWord (fa st + off) (fv st) }) := by
  intro c fuel hc
  rw [List.append_assoc, exec_append, ha c fuel hc]
  simp only []
  rw [exec_append, hv ⟨fa c.st :: c.stack, c.st⟩ fuel hc]
  simp [exec, step1]

/-- Two relative statements compose, provided the first leaves the memory alone. -/
theorem RunsAt.seq {m : Mem} {a b : List Instr} {fa fb : Store → Store}
    (ha : RunsAt m a fa) (hb : RunsAt m b fb)
    (hm : ∀ st : Store, st.mem = m → (fa st).mem = m) :
    RunsAt m (a ++ b) (fun st => fb (fa st)) := by
  intro c fuel hc
  rw [exec_append, ha c fuel hc]
  simpa using hb ⟨c.stack, fa c.st⟩ fuel (hm c.st hc)

/-- A relative statement followed by an absolute one. -/
theorem RunsAt.seqR {m : Mem} {a b : List Instr} {fa : Store → Store} {fb : Store → Store}
    (ha : RunsAt m a fa) (hb : Runs b fb) : RunsAt m (a ++ b) (fun st => fb (fa st)) := by
  intro c fuel hc
  rw [exec_append, ha c fuel hc]
  simpa using hb ⟨c.stack, fa c.st⟩ fuel

theorem RunsAt.ifte {m : Mem} {k t e : List Instr} {fk : Store → Nat} {ft fe : Store → Store}
    (hk : PushesAt m k fk) (ht : RunsAt m t ft) (he : RunsAt m e fe) :
    RunsAt m (k ++ [.ifElse t e]) (fun st => if fk st = 0 then fe st else ft st) := by
  intro c fuel hc
  rw [exec_append, hk c fuel hc]
  simp only [exec, step1]
  by_cases h : fk c.st = 0 <;> simp only [h, if_true, if_false] <;>
    simp [ht ((⟨c.stack, c.st⟩ : Cfg)) fuel hc, he ((⟨c.stack, c.st⟩ : Cfg)) fuel hc]

theorem RunsAt.nil (m : Mem) : RunsAt m [] id := Runs.at m Runs.nil

end RigVM
