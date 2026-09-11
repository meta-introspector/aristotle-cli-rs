import RequestProject.Nix.NixWars.Monster.Irreps

/-!
# The voxel world

The world is a nested family of grids over one fixed map — the universe map of
NixWars.  Grid `d` is a `d`-dimensional box whose axes are the fifteen primes
dividing the order of the Monster, taken from the top down:

```
level 1 : 71                                 = 71 cells
level 2 : 71 × 59                            = 4189 cells
level 3 : 71 × 59 × 47                       = 196883 cells
…
level 15: 71 × 59 × 47 × … × 5 × 3 × 2       = 1618964990108856390 cells
```

Each level is laid *over* the previous one: level `d+1` is level `d` with every
cell cut into `axisAt d` slices along the new axis (`cells_succ`,
`parent_eq_iff`), so the address of a coarse cell is a prefix of the address of
each of the fine cells inside it (`encode_child`), and a single natural number
addresses a cell at each level (`encode`/`decode` are mutually inverse on valid
addresses).  A cell of level `d` occupies the fraction `1 / cells d` of the
whole map, and that fraction strictly decreases with every level (`vol_lt`):
adding a dimension adds resolution.

The three-dimensional level is the one the world is built around: `71 · 59 · 47
= 196883` cells (`cells_three`).
-/

namespace NixWars

namespace Monster

/-! ## Axes and levels -/

/-- The world's axes, coarsest (largest prime) first. -/
def worldAxes : List Nat := monsterPrimes.reverse

/-- The axis added when passing from level `d` to level `d+1`; `1` past the top
level, where refinement stops. -/
def axisAt (d : Nat) : Nat := worldAxes.getD d 1

/-- The axes of level `d`: the `d` coarsest ones. -/
def level (d : Nat) : List Nat := worldAxes.take d

/-- The number of cells of level `d`. -/
def cells (d : Nat) : Nat := (level d).prod

theorem worldAxes_eq : worldAxes = [71, 59, 47, 41, 31, 29, 23, 19, 17, 13, 11, 7, 5, 3, 2] := by
  decide

theorem worldAxes_length : worldAxes.length = 15 := by decide

/-- A one-dimensional world is a line of `71` cells. -/
theorem cells_one : cells 1 = 71 := by decide

/-- The three-dimensional world `71 × 59 × 47` has `196883` cells. -/
theorem cells_three : cells 3 = 196883 := by decide

/-- The finest world, all fifteen primes at once. -/
theorem cells_fifteen : cells 15 = 1618964990108856390 := by decide

theorem cells_zero : cells 0 = 1 := by decide

/-- The one-dimensional world is the 71-shard ring the rest of NixWars runs on. -/
theorem cells_one_eq_numShards : cells 1 = numShards := by decide

/-! ## One level refines the previous one -/

theorem prod_take_succ (l : List Nat) (d : Nat) :
    (l.take (d + 1)).prod = (l.take d).prod * l.getD d 1 := by
  induction l generalizing d with
  | nil => simp
  | cons a t ih =>
    cases d with
    | zero => simp
    | succ e => simp [ih e, Nat.mul_assoc]

/-- Level `d+1` is level `d` cut along one more axis. -/
theorem cells_succ (d : Nat) : cells (d + 1) = cells d * axisAt d :=
  prod_take_succ worldAxes d

theorem getD_pos {l : List Nat} (hl : ∀ x ∈ l, 0 < x) (n : Nat) {dflt : Nat} (hd : 0 < dflt) :
    0 < l.getD n dflt := by
  induction l generalizing n with
  | nil => simpa using hd
  | cons a t ih =>
    cases n with
    | zero => simpa using hl a (by simp)
    | succ m => simpa using ih (fun x hx => hl x (by simp [hx])) m

theorem axisAt_pos (d : Nat) : 0 < axisAt d := getD_pos (by decide) d (by decide)

theorem cells_pos (d : Nat) : 0 < cells d := by
  induction d with
  | zero => decide
  | succ e ih => rw [cells_succ]; exact Nat.mul_pos ih (axisAt_pos e)

/-- Below the top level every new axis is a prime, so at least `2`. -/
theorem two_le_axisAt {d : Nat} (h : d < 15) : 2 ≤ axisAt d := by
  interval_cases d <;> decide

/-- Every cell of level `d` is a union of cells of level `d+1`: the coarse grid
divides the fine one. -/
theorem cells_dvd_succ (d : Nat) : cells d ∣ cells (d + 1) := ⟨axisAt d, cells_succ d⟩

theorem cells_le_succ (d : Nat) : cells d ≤ cells (d + 1) := by
  rw [cells_succ]
  exact Nat.le_mul_of_pos_right _ (axisAt_pos d)

theorem cells_le_of_le {d e : Nat} (h : d ≤ e) : cells d ≤ cells e := by
  induction h with
  | refl => exact Nat.le_refl _
  | step _ ih => exact le_trans ih (cells_le_succ _)

/-- The grids get strictly finer for as long as there are axes left. -/
theorem cells_lt_succ {d : Nat} (h : d < 15) : cells d < cells (d + 1) := by
  have hp := cells_pos d
  have hm : cells d * 2 ≤ cells d * axisAt d := Nat.mul_le_mul_left _ (two_le_axisAt h)
  rw [cells_succ]
  omega

/-- Refinement stops at fifteen axes: there is nothing left to cut. -/
theorem cells_stable {d : Nat} (h : 15 ≤ d) : cells d = cells 15 := by
  have h1 : worldAxes.take d = worldAxes := List.take_of_length_le (by rw [worldAxes_length]; omega)
  have h2 : worldAxes.take 15 = worldAxes := List.take_of_length_le (by rw [worldAxes_length])
  simp only [cells, level, h1, h2]

/-! ## Cell volume -/

/-- The volume of one cell of level `d`, as a fraction of the whole map. -/
def vol (d : Nat) : ℚ := 1 / (cells d : ℚ)

theorem vol_pos (d : Nat) : 0 < vol d := by
  have h : (0 : ℚ) < (cells d : ℚ) := by exact_mod_cast cells_pos d
  simpa [vol] using one_div_pos.mpr h

/-- One cell of level `d` is exactly `axisAt d` cells of level `d+1`. -/
theorem vol_succ (d : Nat) : vol (d + 1) * (axisAt d : ℚ) = vol d := by
  have hc : ((cells d : ℚ)) ≠ 0 := Nat.cast_ne_zero.mpr (cells_pos d).ne'
  have hq : ((axisAt d : ℚ)) ≠ 0 := Nat.cast_ne_zero.mpr (axisAt_pos d).ne'
  rw [vol, vol, cells_succ]
  push_cast
  field_simp

/-- Cells shrink with every level. -/
theorem vol_lt {d : Nat} (h : d < 15) : vol (d + 1) < vol d := by
  have h1 : (0 : ℚ) < (cells d : ℚ) := by exact_mod_cast cells_pos d
  have h2 : ((cells d : ℚ)) < (cells (d + 1) : ℚ) := by exact_mod_cast cells_lt_succ h
  exact one_div_lt_one_div_of_lt h1 h2

/-! ## Addresses -/

/-- The mixed-radix index of a voxel address, coarsest axis most significant.
`L` is the list of axes of the level and `a` the coordinate along each. -/
def encode : List Nat → List Nat → Nat
  | _ :: ps, c :: cs => c * ps.prod + encode ps cs
  | _, _ => 0

/-- The voxel address of an index, coarsest axis first: inverse to `encode`. -/
def decode : List Nat → Nat → List Nat
  | [], _ => []
  | _ :: ps, n => (n / ps.prod) :: decode ps (n % ps.prod)

@[simp] theorem encode_nil_left (a : List Nat) : encode [] a = 0 := by cases a <;> rfl

@[simp] theorem encode_nil_right (L : List Nat) : encode L [] = 0 := by cases L <;> rfl

@[simp] theorem encode_cons (p c : Nat) (ps cs : List Nat) :
    encode (p :: ps) (c :: cs) = c * ps.prod + encode ps cs := rfl

@[simp] theorem decode_nil (n : Nat) : decode [] n = [] := rfl

@[simp] theorem decode_cons (p n : Nat) (ps : List Nat) :
    decode (p :: ps) n = (n / ps.prod) :: decode ps (n % ps.prod) := rfl

/-- An address is *valid* for a level when each coordinate lies inside its axis. -/
abbrev Valid (L a : List Nat) : Prop := List.Forall₂ (· < ·) a L

theorem decode_length (L : List Nat) (n : Nat) : (decode L n).length = L.length := by
  induction L generalizing n with
  | nil => simp
  | cons p ps ih => simp [ih]

/-- Decoding an index below the cell count gives a valid address. -/
theorem decode_valid : ∀ (L : List Nat) {n : Nat}, n < L.prod → Valid L (decode L n) := by
  intro L
  induction L with
  | nil => intro n h; simp at h; simp [h]
  | cons p ps ih =>
    intro n h
    have hP : 0 < ps.prod := by
      rcases Nat.eq_zero_or_pos ps.prod with h0 | h0
      · rw [List.prod_cons, h0, Nat.mul_zero] at h; omega
      · exact h0
    refine List.Forall₂.cons ?_ (ih (Nat.mod_lt _ hP))
    refine Nat.div_lt_of_lt_mul ?_
    rw [List.prod_cons, Nat.mul_comm] at h
    exact h

/-- Every index below the cell count is the index of its own address. -/
theorem encode_decode : ∀ (L : List Nat) {n : Nat}, n < L.prod → encode L (decode L n) = n := by
  intro L
  induction L with
  | nil => intro n h; simp at h; simp [h]
  | cons p ps ih =>
    intro n h
    have hP : 0 < ps.prod := by
      rcases Nat.eq_zero_or_pos ps.prod with h0 | h0
      · rw [List.prod_cons, h0, Nat.mul_zero] at h; omega
      · exact h0
    rw [decode_cons, encode_cons, ih (Nat.mod_lt _ hP), Nat.div_add_mod']

/-- A valid address gets an index inside the level. -/
theorem encode_lt {L a : List Nat} (h : Valid L a) : encode L a < L.prod := by
  induction h with
  | nil => simp
  | @cons x y xs ys hc _ ih =>
    have hP : 0 < ys.prod := lt_of_le_of_lt (Nat.zero_le _) ih
    rw [encode_cons, List.prod_cons]
    calc x * ys.prod + encode ys xs < x * ys.prod + ys.prod := by omega
      _ = (x + 1) * ys.prod := by ring
      _ ≤ y * ys.prod := Nat.mul_le_mul_right _ hc

/-- … and the address can be read back off the index. -/
theorem decode_encode {L a : List Nat} (h : Valid L a) : decode L (encode L a) = a := by
  induction h with
  | nil => simp
  | @cons x y xs ys _ hrest ih =>
    have hlt := encode_lt hrest
    have hP : 0 < ys.prod := lt_of_le_of_lt (Nat.zero_le _) hlt
    rw [encode_cons, decode_cons, Nat.mul_comm x ys.prod, Nat.mul_add_div hP,
      Nat.div_eq_of_lt hlt, Nat.add_zero, Nat.mul_add_mod, Nat.mod_eq_of_lt hlt, ih]

/-! ## Overlaying: the parent of a fine cell -/

/-- The level-`d` cell containing the level-`(d+1)` cell `n`. -/
def parent (d n : Nat) : Nat := n / axisAt d

/-- The `c`-th level-`(d+1)` cell inside the level-`d` cell `m`. -/
def child (d m c : Nat) : Nat := m * axisAt d + c

theorem parent_child (d m : Nat) {c : Nat} (h : c < axisAt d) : parent d (child d m c) = m := by
  have hq := axisAt_pos d
  simp only [parent, child]
  rw [Nat.mul_comm, Nat.mul_add_div hq, Nat.div_eq_of_lt h, Nat.add_zero]

theorem child_lt {d m c : Nat} (hm : m < cells d) (hc : c < axisAt d) :
    child d m c < cells (d + 1) := by
  have h1 : (m + 1) * axisAt d ≤ cells d * axisAt d := Nat.mul_le_mul_right _ hm
  have h2 : (m + 1) * axisAt d = m * axisAt d + axisAt d := by ring
  rw [cells_succ]
  simp only [child]
  omega

/-- Each cell of level `d` is subdivided into exactly `axisAt d` cells of level
`d+1`: the fine cells over `m` form the consecutive block
`m·q, …, m·q + q - 1`, where `q = axisAt d`. -/
theorem parent_eq_iff (d m n : Nat) :
    parent d n = m ↔ m * axisAt d ≤ n ∧ n < m * axisAt d + axisAt d := by
  have hq := axisAt_pos d
  have h1 : n / axisAt d * axisAt d + n % axisAt d = n := Nat.div_add_mod' n (axisAt d)
  have h2 : n % axisAt d < axisAt d := Nat.mod_lt _ hq
  constructor
  · rintro rfl
    simp only [parent]
    omega
  · rintro ⟨ha, hb⟩
    simp only [parent]
    refine Nat.div_eq_of_lt_le ?_ ?_
    · exact ha
    · rw [Nat.succ_mul]; exact hb

/-! ## Addresses across levels -/

theorem level_length {d : Nat} (h : d ≤ 15) : (level d).length = d := by
  simp only [level, List.length_take, worldAxes_length]
  omega

theorem level_succ {d : Nat} (h : d < 15) : level (d + 1) = level d ++ [axisAt d] := by
  interval_cases d <;> decide

theorem encode_append : ∀ {L a : List Nat}, a.length = L.length → ∀ q c : Nat,
    encode (L ++ [q]) (a ++ [c]) = encode L a * q + c := by
  intro L
  induction L with
  | nil =>
    intro a h q c
    cases a with
    | nil => simp
    | cons _ _ => simp at h
  | cons p ps ih =>
    intro a h q c
    cases a with
    | nil => simp at h
    | cons x xs =>
      simp only [List.cons_append, encode_cons, List.prod_append, List.prod_cons, List.prod_nil,
        Nat.mul_one]
      rw [ih (by simpa using h) q c]
      ring

/-- The fine address of a cell is the coarse address of the cell containing it
with one more coordinate appended, and the indices match: overlaying level
`d+1` on level `d` is Horner's rule. -/
theorem encode_child {d : Nat} (h : d < 15) {a : List Nat} (ha : a.length = d) (c : Nat) :
    encode (level (d + 1)) (a ++ [c]) = child d (encode (level d) a) c := by
  rw [level_succ h, encode_append (by rw [ha, level_length (le_of_lt h)]), child]

/-- Dropping the last coordinate of a fine address is exactly taking the parent
cell of its index. -/
theorem parent_encode {d : Nat} (h : d < 15) {a : List Nat} (ha : a.length = d) {c : Nat}
    (hc : c < axisAt d) :
    parent d (encode (level (d + 1)) (a ++ [c])) = encode (level d) a := by
  rw [encode_child h ha c, parent_child _ _ hc]

end Monster

end NixWars
