import Mathlib

/-!
# The shader-golf dialect

The formal counterpart of `web/js/shader.js`, the little GLSL-like language
behind the `shader` / `frag` / `golf` playbook statement.  A value is either a
float or a vector of two to four floats; operators apply componentwise and
broadcast a float against a vector; a swizzle picks lanes; the result of a
fragment is either a float (shaded through the layer's palette) or a vector
(used as a colour).

Two things matter for the studio and are proved here.

*Values.* Broadcasting has the width one expects and computes componentwise,
swizzles have the width of their field and read the lanes they name, and the
colour conversion always produces bytes — a fragment can return anything at
all (including a value far out of range, or a vector of the wrong width) and
the frame still receives numbers in `0 … 255`.

*Fuel.* A playbook travels inside a share link, so a shader is untrusted code
that runs per pixel, and the runtime evaluates it on a fuel budget.  `eval`
here is the same fuelled evaluator: every node costs one unit, evaluation
always answers (with a value, with "out of fuel", or with a well-formedness
error), it never hands back more fuel than it was given, and giving it more
fuel never changes an answer it has already produced.  Together these say the
guard is safe — the studio cannot be hung by a shader — and honest — the guard
never alters the picture of a shader that fits in its budget.

The expression language modelled here is the runtime's expression core
(literals, names, unary and binary builtins, swizzles, vector constructors and
the ternary operator); its statements, loops and assignments are the part
guarded by the same fuel counter and by `MAX_LOOP`.

`tests/node/test_shader.mjs` checks the shipped JavaScript against the same
statements.
-/

namespace Hesper.Shader

/-! ## Values -/

/-- A value of the dialect: a float, or a vector of lanes. -/
inductive Val where
  /-- A float. -/
  | num : ℝ → Val
  /-- A vector (the runtime only builds these with 2 to 4 lanes). -/
  | vec : List ℝ → Val

namespace Val

/-- The lanes of a value; a float is a single lane. -/
def comps : Val → List ℝ
  | .num x => [x]
  | .vec xs => xs

/-- How many lanes a value has. -/
def width (v : Val) : ℕ := v.comps.length

/-- Rebuild a value from lanes: one lane is a float, as in the runtime's
`pack`. -/
def pack : List ℝ → Val
  | [x] => .num x
  | xs => .vec xs

@[simp] theorem comps_num (x : ℝ) : (Val.num x).comps = [x] := rfl
@[simp] theorem comps_vec (xs : List ℝ) : (Val.vec xs).comps = xs := rfl
@[simp] theorem width_num (x : ℝ) : (Val.num x).width = 1 := rfl
@[simp] theorem width_vec (xs : List ℝ) : (Val.vec xs).width = xs.length := rfl

/-- `pack` keeps the lanes it was given. -/
@[simp] theorem comps_pack (xs : List ℝ) : (pack xs).comps = xs := by
  match xs with
  | [] => rfl
  | [_] => rfl
  | _ :: _ :: _ => rfl

@[simp] theorem width_pack (xs : List ℝ) : (pack xs).width = xs.length := by
  simp [width]

end Val

open Val

/-- Componentwise application with broadcasting, the runtime's `zip`: equal
widths pair up lane by lane, and a float is repeated against a vector.  Widths
that cannot be combined (a `vec2` with a `vec3`) are a runtime error, reported
here as `none`. -/
noncomputable def zip (f : ℝ → ℝ → ℝ) (a b : Val) : Option Val :=
  if a.width = b.width then
    some (pack (List.zipWith f a.comps b.comps))
  else if a.width = 1 then
    some (pack (b.comps.map (fun y => f a.comps.headI y)))
  else if b.width = 1 then
    some (pack (a.comps.map (fun x => f x b.comps.headI)))
  else none

/-- Componentwise application of a unary function, the runtime's `map1`. -/
def map1 (f : ℝ → ℝ) (a : Val) : Val := pack (a.comps.map f)

@[simp] theorem width_map1 (f : ℝ → ℝ) (a : Val) : (map1 f a).width = a.width := by
  simp [map1, Val.width]

@[simp] theorem comps_map1 (f : ℝ → ℝ) (a : Val) : (map1 f a).comps = a.comps.map f := by
  simp [map1]

/-- Two values of the same width combine lane by lane. -/
theorem zip_same {f : ℝ → ℝ → ℝ} {a b : Val} (h : a.width = b.width) :
    zip f a b = some (pack (List.zipWith f a.comps b.comps)) := by
  simp [zip, h]

/-- A float broadcasts over a vector. -/
theorem zip_left_scalar {f : ℝ → ℝ → ℝ} {x : ℝ} {b : Val} (h : b.width ≠ 1) :
    zip f (.num x) b = some (pack (b.comps.map (fun y => f x y))) := by
  rw [zip, if_neg (by simpa [Val.width] using fun hc => h hc.symm),
    if_pos (show (Val.num x).width = 1 from rfl)]
  simp

/-- And a vector broadcasts against a float. -/
theorem zip_right_scalar {f : ℝ → ℝ → ℝ} {a : Val} {y : ℝ} (h : a.width ≠ 1) :
    zip f a (.num y) = some (pack (a.comps.map (fun x => f x y))) := by
  rw [zip, if_neg (by simpa [Val.width] using h), if_neg h,
    if_pos (show (Val.num y).width = 1 from rfl)]
  simp

/-- Broadcasting produces the wider of the two widths (values the dialect
builds always have at least one lane). -/
theorem zip_width {f : ℝ → ℝ → ℝ} {a b v : Val} (ha : 1 ≤ a.width) (hb : 1 ≤ b.width)
    (h : zip f a b = some v) : v.width = max a.width b.width := by
  unfold zip at h
  split at h
  · rename_i he
    have he' : a.comps.length = b.comps.length := he
    simp only [Option.some.injEq] at h
    subst h
    rw [width_pack, List.length_zipWith, he', min_self]
    simp [Val.width, he']
  · split at h
    · rename_i he1 he2
      simp only [Option.some.injEq] at h
      subst h
      rw [width_pack, List.length_map, he2, max_eq_right hb]
      rfl
    · split at h
      · rename_i he1 he2 he3
        simp only [Option.some.injEq] at h
        subst h
        rw [width_pack, List.length_map, he3, max_eq_left ha]
        rfl
      · exact absurd h (by simp)

/-- A swizzle: read the lanes a field names, in the order it names them.  Out
of range is a runtime error, reported here as `none`. -/
def swizzle (v : Val) (idx : List ℕ) : Option Val :=
  if idx.all (fun i => i < v.width) then some (pack (idx.map (fun i => v.comps.getD i 0)))
  else none

/-- A swizzle has the width of its field. -/
theorem swizzle_width {v w : Val} {idx : List ℕ} (h : swizzle v idx = some w) :
    w.width = idx.length := by
  unfold swizzle at h
  split at h
  · simp only [Option.some.injEq] at h; subst h; simp
  · exact absurd h (by simp)

/-- And it reads the lanes it names. -/
theorem swizzle_comps {v w : Val} {idx : List ℕ} (h : swizzle v idx = some w) :
    w.comps = idx.map (fun i => v.comps.getD i 0) := by
  unfold swizzle at h
  split at h
  · simp only [Option.some.injEq] at h; subst h; simp
  · exact absurd h (by simp)

/-- A swizzle is defined exactly when every lane it names exists. -/
theorem swizzle_isSome {v : Val} {idx : List ℕ} :
    (swizzle v idx).isSome ↔ ∀ i ∈ idx, i < v.width := by
  unfold swizzle
  split <;> rename_i h <;> simp_all

/-! ## Colours -/

/-- One colour channel: clamp to `[0, 1]` and round to a byte. -/
noncomputable def channel (x : ℝ) : ℕ := ⌊255 * max 0 (min 1 x) + 1 / 2⌋₊

/-- A channel is a byte. -/
theorem channel_le (x : ℝ) : channel x ≤ 255 := by
  have h1 : max 0 (min 1 x) ≤ 1 := max_le zero_le_one (min_le_left _ _)
  have h0 : (0:ℝ) ≤ max 0 (min 1 x) := le_max_left _ _
  have hle : (255 : ℝ) * max 0 (min 1 x) + 1 / 2 ≤ 255 + 1 / 2 := by nlinarith
  calc channel x ≤ ⌊(255 : ℝ) + 1 / 2⌋₊ := Nat.floor_le_floor hle
    _ = 255 := by norm_num

/-- Anything at or below `0` is black. -/
theorem channel_of_nonpos {x : ℝ} (h : x ≤ 0) : channel x = 0 := by
  have hm : max 0 (min 1 x) = 0 := max_eq_left (le_trans (min_le_right _ _) h)
  rw [channel, hm]
  norm_num

/-- Anything at or above `1` is full. -/
theorem channel_of_one_le {x : ℝ} (h : 1 ≤ x) : channel x = 255 := by
  have hm : max 0 (min 1 x) = 1 := by rw [min_eq_left h, max_eq_right zero_le_one]
  rw [channel, hm]
  norm_num

/-- A colour: four bytes.  A float result is not a colour — the studio shades
it through the layer's palette instead — so `toColor` only answers for a
vector, exactly as the runtime's `toColor` splits its two cases. -/
noncomputable def toColor (v : Val) : Option (ℕ × ℕ × ℕ × ℕ) :=
  match v with
  | .num _ => none
  | .vec [a, b] => some (channel a, channel b, 0, 255)
  | .vec [a, b, c] => some (channel a, channel b, channel c, 255)
  | .vec [a, b, c, d] => some (channel a, channel b, channel c, channel d)
  | .vec _ => none

/-- A `vec3` is opaque. -/
@[simp] theorem toColor_vec3 (x y z : ℝ) :
    toColor (.vec [x, y, z]) = some (channel x, channel y, channel z, 255) := rfl

/-- A `vec4` keeps its alpha. -/
@[simp] theorem toColor_vec4 (x y z w : ℝ) :
    toColor (.vec [x, y, z, w]) = some (channel x, channel y, channel z, channel w) := rfl

/-- A float is shaded through the palette, not used as a colour. -/
@[simp] theorem toColor_num (x : ℝ) : toColor (.num x) = none := rfl

/-- Whatever a fragment returns, the frame receives bytes. -/
theorem toColor_bytes {v : Val} {r g b a : ℕ} (h : toColor v = some (r, g, b, a)) :
    r ≤ 255 ∧ g ≤ 255 ∧ b ≤ 255 ∧ a ≤ 255 := by
  match v, h with
  | .vec [x, y], h =>
      rw [toColor] at h
      simp only [Option.some.injEq, Prod.mk.injEq] at h
      obtain ⟨h1, h2, h3, h4⟩ := h
      exact ⟨h1 ▸ channel_le x, h2 ▸ channel_le y, by omega, by omega⟩
  | .vec [x, y, z], h =>
      rw [toColor] at h
      simp only [Option.some.injEq, Prod.mk.injEq] at h
      obtain ⟨h1, h2, h3, h4⟩ := h
      exact ⟨h1 ▸ channel_le x, h2 ▸ channel_le y, h3 ▸ channel_le z, by omega⟩
  | .vec [x, y, z, w], h =>
      rw [toColor] at h
      simp only [Option.some.injEq, Prod.mk.injEq] at h
      obtain ⟨h1, h2, h3, h4⟩ := h
      exact ⟨h1 ▸ channel_le x, h2 ▸ channel_le y, h3 ▸ channel_le z, h4 ▸ channel_le w⟩

/-! ## The fuelled evaluator -/

/-- Expressions of the dialect, in the shape the runtime compiles.  A vector
constructor is the concatenation of its arguments' lanes, which is exactly how
the runtime flattens `vec3(v2, x)`. -/
inductive Expr where
  /-- A literal. -/
  | lit : ℝ → Expr
  /-- A name: a per-pixel input, an animated parameter or a declared local. -/
  | var : String → Expr
  /-- A unary builtin, applied componentwise. -/
  | un : (ℝ → ℝ) → Expr → Expr
  /-- A binary builtin, applied componentwise with broadcasting. -/
  | bin : (ℝ → ℝ → ℝ) → Expr → Expr → Expr
  /-- A swizzle. -/
  | swiz : Expr → List ℕ → Expr
  /-- A vector constructor: the lanes of the first argument followed by those
  of the second. -/
  | cat : Expr → Expr → Expr
  /-- The ternary operator. -/
  | sel : Expr → Expr → Expr → Expr

/-- What evaluating an expression can produce. -/
inductive Outcome where
  /-- A value, and the fuel left over. -/
  | ok : Val → ℕ → Outcome
  /-- The fuel budget ran out. -/
  | outOfFuel : Outcome
  /-- The program is not well formed here: an unknown name, a swizzle that
  reaches past its vector, widths that cannot be combined, or a constructor
  with more than four lanes. -/
  | error : Outcome

/-- The environment a fragment is evaluated in: the per-pixel inputs, the
animated parameters and the locals declared so far. -/
abbrev Env := String → Option Val

/-- Truthiness, as in the runtime: a value is true when some lane is
non-zero. -/
noncomputable def truthy (v : Val) : Bool := decide (∃ x ∈ v.comps, x ≠ 0)

/-- Evaluate an expression on a fuel budget: every node costs one unit, and
the answer carries the fuel left over. -/
noncomputable def eval (env : Env) : Expr → ℕ → Outcome
  | _, 0 => .outOfFuel
  | .lit x, fuel + 1 => .ok (.num x) fuel
  | .var name, fuel + 1 =>
    match env name with
    | some v => .ok v fuel
    | none => .error
  | .un f a, fuel + 1 =>
    match eval env a fuel with
    | .ok v k => .ok (map1 f v) k
    | .outOfFuel => .outOfFuel
    | .error => .error
  | .bin f a b, fuel + 1 =>
    match eval env a fuel with
    | .ok va k =>
      match eval env b k with
      | .ok vb k' =>
        match zip f va vb with
        | some v => .ok v k'
        | none => .error
      | .outOfFuel => .outOfFuel
      | .error => .error
    | .outOfFuel => .outOfFuel
    | .error => .error
  | .swiz a idx, fuel + 1 =>
    match eval env a fuel with
    | .ok v k =>
      match swizzle v idx with
      | some w => .ok w k
      | none => .error
    | .outOfFuel => .outOfFuel
    | .error => .error
  | .cat a b, fuel + 1 =>
    match eval env a fuel with
    | .ok va k =>
      match eval env b k with
      | .ok vb k' =>
        if (va.comps ++ vb.comps).length ≤ 4 then .ok (pack (va.comps ++ vb.comps)) k'
        else .error
      | .outOfFuel => .outOfFuel
      | .error => .error
    | .outOfFuel => .outOfFuel
    | .error => .error
  | .sel c a b, fuel + 1 =>
    match eval env c fuel with
    | .ok v k => if truthy v then eval env a k else eval env b k
    | .outOfFuel => .outOfFuel
    | .error => .error

/-- With no fuel nothing is evaluated. -/
@[simp] theorem eval_zero (env : Env) (e : Expr) : eval env e 0 = .outOfFuel := by
  cases e <;> rfl

section
variable {env : Env}

@[simp] theorem eval_lit (x : ℝ) (n : ℕ) : eval env (.lit x) (n + 1) = .ok (.num x) n := rfl

theorem eval_un (f : ℝ → ℝ) (a : Expr) (n : ℕ) :
    eval env (.un f a) (n + 1) =
      match eval env a n with
      | .ok v k => .ok (map1 f v) k
      | .outOfFuel => .outOfFuel
      | .error => .error := rfl

theorem eval_bin (f : ℝ → ℝ → ℝ) (a b : Expr) (n : ℕ) :
    eval env (.bin f a b) (n + 1) =
      match eval env a n with
      | .ok va k =>
        match eval env b k with
        | .ok vb k' =>
          match zip f va vb with
          | some v => .ok v k'
          | none => .error
        | .outOfFuel => .outOfFuel
        | .error => .error
      | .outOfFuel => .outOfFuel
      | .error => .error := rfl

theorem eval_swiz (a : Expr) (idx : List ℕ) (n : ℕ) :
    eval env (.swiz a idx) (n + 1) =
      match eval env a n with
      | .ok v k =>
        match swizzle v idx with
        | some w => .ok w k
        | none => .error
      | .outOfFuel => .outOfFuel
      | .error => .error := rfl

theorem eval_cat (a b : Expr) (n : ℕ) :
    eval env (.cat a b) (n + 1) =
      match eval env a n with
      | .ok va k =>
        match eval env b k with
        | .ok vb k' =>
          if (va.comps ++ vb.comps).length ≤ 4 then .ok (pack (va.comps ++ vb.comps)) k'
          else .error
        | .outOfFuel => .outOfFuel
        | .error => .error
      | .outOfFuel => .outOfFuel
      | .error => .error := rfl

theorem eval_sel (c a b : Expr) (n : ℕ) :
    eval env (.sel c a b) (n + 1) =
      match eval env c n with
      | .ok v k => if truthy v then eval env a k else eval env b k
      | .outOfFuel => .outOfFuel
      | .error => .error := rfl

/-- Evaluation never hands back more fuel than it was given: every node costs
at least one unit, so a fragment always makes progress and the budget really
is a bound on the work one pixel can ask for. -/
theorem eval_fuel_lt : ∀ (e : Expr) {fuel : ℕ} {v : Val} {k : ℕ},
    eval env e fuel = .ok v k → k < fuel := by
  intro e
  induction e with
  | lit x =>
    intro fuel v k h
    cases fuel with
    | zero => simp at h
    | succ n => simp only [eval_lit, Outcome.ok.injEq] at h; omega
  | var name =>
    intro fuel v k h
    cases fuel with
    | zero => simp at h
    | succ n =>
      cases hv : env name with
      | some w => simp only [eval, hv, Outcome.ok.injEq] at h; omega
      | none => simp [eval, hv] at h
  | un f a ih =>
    intro fuel v k h
    cases fuel with
    | zero => simp at h
    | succ n =>
      cases ha : eval env a n with
      | ok w j =>
        simp only [eval_un, ha, Outcome.ok.injEq] at h
        obtain ⟨-, rfl⟩ := h
        exact lt_trans (ih ha) (by omega)
      | outOfFuel => simp [eval_un, ha] at h
      | error => simp [eval_un, ha] at h
  | bin f a b iha ihb =>
    intro fuel v k h
    cases fuel with
    | zero => simp at h
    | succ n =>
      cases ha : eval env a n with
      | ok va j =>
        cases hb : eval env b j with
        | ok vb j' =>
          cases hz : zip f va vb with
          | some w =>
            simp only [eval_bin, ha, hb, hz, Outcome.ok.injEq] at h
            obtain ⟨-, rfl⟩ := h
            exact lt_trans (ihb hb) (lt_trans (iha ha) (by omega))
          | none => simp [eval_bin, ha, hb, hz] at h
        | outOfFuel => simp [eval_bin, ha, hb] at h
        | error => simp [eval_bin, ha, hb] at h
      | outOfFuel => simp [eval_bin, ha] at h
      | error => simp [eval_bin, ha] at h
  | swiz a idx ih =>
    intro fuel v k h
    cases fuel with
    | zero => simp at h
    | succ n =>
      cases ha : eval env a n with
      | ok w j =>
        cases hs : swizzle w idx with
        | some u =>
          simp only [eval_swiz, ha, hs, Outcome.ok.injEq] at h
          obtain ⟨-, rfl⟩ := h
          exact lt_trans (ih ha) (by omega)
        | none => simp [eval_swiz, ha, hs] at h
      | outOfFuel => simp [eval_swiz, ha] at h
      | error => simp [eval_swiz, ha] at h
  | cat a b iha ihb =>
    intro fuel v k h
    cases fuel with
    | zero => simp at h
    | succ n =>
      cases ha : eval env a n with
      | ok va j =>
        cases hb : eval env b j with
        | ok vb j' =>
          by_cases hlen : (va.comps ++ vb.comps).length ≤ 4
          · simp only [eval_cat, ha, hb, if_pos hlen, Outcome.ok.injEq] at h
            obtain ⟨-, rfl⟩ := h
            exact lt_trans (ihb hb) (lt_trans (iha ha) (by omega))
          · simp only [eval_cat, ha, hb, if_neg hlen] at h
            exact absurd h (by simp)
        | outOfFuel => simp [eval_cat, ha, hb] at h
        | error => simp [eval_cat, ha, hb] at h
      | outOfFuel => simp [eval_cat, ha] at h
      | error => simp [eval_cat, ha] at h
  | sel c a b ihc iha ihb =>
    intro fuel v k h
    cases fuel with
    | zero => simp at h
    | succ n =>
      cases hc : eval env c n with
      | ok w j =>
        by_cases ht : truthy w
        · simp only [eval_sel, hc, if_pos ht] at h
          exact lt_trans (iha h) (lt_trans (ihc hc) (by omega))
        · simp only [eval_sel, hc, if_neg ht] at h
          exact lt_trans (ihb h) (lt_trans (ihc hc) (by omega))
      | outOfFuel => simp [eval_sel, hc] at h
      | error => simp [eval_sel, hc] at h

/-- More fuel never changes an answer: a fragment that fits in its budget
computes the same value however generous the budget is, and simply hands back
the surplus.  The guard is therefore invisible to a shader that fits. -/
theorem eval_add_fuel : ∀ (e : Expr) {fuel : ℕ} {v : Val} {k : ℕ},
    eval env e fuel = .ok v k → ∀ d : ℕ, eval env e (fuel + d) = .ok v (k + d) := by
  intro e
  induction e with
  | lit x =>
    intro fuel v k h d
    cases fuel with
    | zero => simp at h
    | succ n =>
      simp only [eval_lit, Outcome.ok.injEq] at h
      obtain ⟨rfl, rfl⟩ := h
      rw [show n + 1 + d = (n + d) + 1 by omega, eval_lit]
  | var name =>
    intro fuel v k h d
    cases fuel with
    | zero => simp at h
    | succ n =>
      cases hv : env name with
      | some w =>
        simp only [eval, hv, Outcome.ok.injEq] at h
        obtain ⟨rfl, rfl⟩ := h
        rw [show n + 1 + d = (n + d) + 1 by omega]
        simp [eval, hv]
      | none => simp [eval, hv] at h
  | un f a ih =>
    intro fuel v k h d
    cases fuel with
    | zero => simp at h
    | succ n =>
      cases ha : eval env a n with
      | ok w j =>
        simp only [eval_un, ha, Outcome.ok.injEq] at h
        obtain ⟨rfl, rfl⟩ := h
        rw [show n + 1 + d = (n + d) + 1 by omega]
        simp [eval_un, ih ha d]
      | outOfFuel => simp [eval_un, ha] at h
      | error => simp [eval_un, ha] at h
  | bin f a b iha ihb =>
    intro fuel v k h d
    cases fuel with
    | zero => simp at h
    | succ n =>
      cases ha : eval env a n with
      | ok va j =>
        cases hb : eval env b j with
        | ok vb j' =>
          cases hz : zip f va vb with
          | some w =>
            simp only [eval_bin, ha, hb, hz, Outcome.ok.injEq] at h
            obtain ⟨rfl, rfl⟩ := h
            rw [show n + 1 + d = (n + d) + 1 by omega]
            simp [eval_bin, iha ha d, ihb hb d, hz]
          | none => simp [eval_bin, ha, hb, hz] at h
        | outOfFuel => simp [eval_bin, ha, hb] at h
        | error => simp [eval_bin, ha, hb] at h
      | outOfFuel => simp [eval_bin, ha] at h
      | error => simp [eval_bin, ha] at h
  | swiz a idx ih =>
    intro fuel v k h d
    cases fuel with
    | zero => simp at h
    | succ n =>
      cases ha : eval env a n with
      | ok w j =>
        cases hs : swizzle w idx with
        | some u =>
          simp only [eval_swiz, ha, hs, Outcome.ok.injEq] at h
          obtain ⟨rfl, rfl⟩ := h
          rw [show n + 1 + d = (n + d) + 1 by omega]
          simp [eval_swiz, ih ha d, hs]
        | none => simp [eval_swiz, ha, hs] at h
      | outOfFuel => simp [eval_swiz, ha] at h
      | error => simp [eval_swiz, ha] at h
  | cat a b iha ihb =>
    intro fuel v k h d
    cases fuel with
    | zero => simp at h
    | succ n =>
      cases ha : eval env a n with
      | ok va j =>
        cases hb : eval env b j with
        | ok vb j' =>
          by_cases hlen : (va.comps ++ vb.comps).length ≤ 4
          · simp only [eval_cat, ha, hb, if_pos hlen, Outcome.ok.injEq] at h
            obtain ⟨rfl, rfl⟩ := h
            rw [show n + 1 + d = (n + d) + 1 by omega]
            simp only [eval_cat, iha ha d, ihb hb d, if_pos hlen]
          · simp only [eval_cat, ha, hb, if_neg hlen] at h
            exact absurd h (by simp)
        | outOfFuel => simp [eval_cat, ha, hb] at h
        | error => simp [eval_cat, ha, hb] at h
      | outOfFuel => simp [eval_cat, ha] at h
      | error => simp [eval_cat, ha] at h
  | sel c a b ihc iha ihb =>
    intro fuel v k h d
    cases fuel with
    | zero => simp at h
    | succ n =>
      cases hc : eval env c n with
      | ok w j =>
        by_cases ht : truthy w
        · simp only [eval_sel, hc, if_pos ht] at h
          rw [show n + 1 + d = (n + d) + 1 by omega]
          simp only [eval_sel, ihc hc d, if_pos ht]
          exact iha h d
        · simp only [eval_sel, hc, if_neg ht] at h
          rw [show n + 1 + d = (n + d) + 1 by omega]
          simp only [eval_sel, ihc hc d, if_neg ht]
          exact ihb h d
      | outOfFuel => simp [eval_sel, hc] at h
      | error => simp [eval_sel, hc] at h

/-- The same, phrased with an inequality. -/
theorem eval_mono {e : Expr} {fuel fuel' : ℕ} {v : Val} {k : ℕ}
    (h : eval env e fuel = .ok v k) (hle : fuel ≤ fuel') :
    eval env e fuel' = .ok v (k + (fuel' - fuel)) := by
  obtain ⟨d, rfl⟩ := Nat.exists_eq_add_of_le hle
  simpa using eval_add_fuel e h d

end

end Hesper.Shader
