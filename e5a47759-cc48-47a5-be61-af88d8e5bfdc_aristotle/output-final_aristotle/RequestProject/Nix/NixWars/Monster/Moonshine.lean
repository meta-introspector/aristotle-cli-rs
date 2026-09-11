import RequestProject.Nix.NixWars.Monster.Project

set_option maxRecDepth 100000
set_option maxHeartbeats 4000000

/-!
# The paths between the irrep worlds: dividing, multiplying, and the q-expansion

`Project.lean` puts everything in the game into one irrep — a box of cells cut
by primes, the one we start in being `71 × 59 × 47 = 196883`.  This file says how
to *walk between* those worlds, and why the walks are the moonshine data.

**A path is a word in "divide by `p`" and "multiply by `p`".**  `Step` is one
such move, `Path` a list of them, `runPath` its effect on a number and `walk` its
effect on a box (multiplying puts a new axis on, dividing takes one off).  Paths
compose by concatenation (`runPath_append`, `walk_append`), every path has an
inverse path that undoes it (`runPath_inv`, `walk_inv`), and — the bridge between
the two pictures — the number of cells of the box you arrive in is the path
applied to the number of cells you set out from (`walk_size`).

**Between any two worlds there is a canonical path.**  `bridge a b` divides out
what `a` does not share with `b` and multiplies in what `b` does not share with
`a`: `bridge_run` says it really does carry `a` to `b`, `bridge_div_mul_coprime`
that the two moves have nothing in common (so the path is the shortest one of
this shape), and `bridge_inv_run` that reading it backwards returns you.

**The concrete path the game walks.**  From `196883 = 71 · 59 · 47` to
`21296876 = 2² · 31 · 41 · 59 · 71` — the first two non-trivial irreducible
representations of the Monster — you divide by `47` and multiply by `41`, `31`
and `4`, keeping the shared `71 · 59 = 4189`.  That is `ladder`, and
`ladder_run`, `ladder_eq_bridge` and `walk_ladder_axes` do it to the number and
to the box: `irrep3 = [71, 59, 47]` becomes `irrepNext = [4, 31, 41, 71, 59]`,
again with positive pairwise coprime axes (`irrepNext_legit`), so the projection
of `Project.lean` is again a bijection between the cans below `21296876` and the
cells of the new box (`irrepNext_cells_distinct`, `irrepNext_cells_filled`).

**Why those two numbers.**  The dimensions of the irreducible representations of
the Monster are the numbers the coefficients of the q-expansion of the modular
function `J` are built out of:

```
J(q) = q⁻¹ + 196884 q + 21493760 q² + 864299970 q³ + 20245856256 q⁴ + …
```

with `196884 = 1 + 196883`, `21493760 = 1 + 196883 + 21296876`, and so on
(`jCoeffs_eq_head_characters`, and one theorem per coefficient).  So the worlds
the game can be in are the graded pieces of moonshine, the q-expansion is what
says which worlds appear in which grade and how often, and the divide/multiply
paths of this file are how you get from one to the next: `dimLadder_bridges`
walks the whole list of dimensions, `coeff2_as_boxes` reads the third
coefficient of `J` off the cell counts of the boxes themselves.
-/

namespace NixWars

namespace Monster

namespace Moonshine

/-! ## The dimensions of the Monster's irreducible representations -/

/-- The first seven irreducible character degrees of the Monster, ascending. -/
def monsterDims : List Nat :=
  [1, 196883, 21296876, 842609326, 18538750076, 19360062527, 293553734298]

/-- The dimension of the smallest faithful representation: the number of cells of
the box we start in. -/
theorem monsterDims_get_one : monsterDims.getD 1 0 = 196883 := by decide

/-- `196883 = 47 · 59 · 71`: the axes of the box we start in. -/
theorem dim1_factors : 47 * 59 * 71 = 196883 := by decide

/-- `21296876 = 4 · 31 · 41 · 59 · 71`: the axes of the box next door.  The two
share `59 · 71`; the move is `÷ 47` then `× 41 × 31 × 4`. -/
theorem dim2_factors : 4 * 31 * 41 * 59 * 71 = 21296876 := by decide

/-- What the two boxes share is `71 · 59 = 4189`. -/
theorem dim_gcd : Nat.gcd 196883 21296876 = 71 * 59 := by decide

/-! ## Paths: words in "divide by p" and "multiply by p" -/

/-- One move between irrep worlds: put an axis on, or take one off. -/
inductive Step where
  /-- Multiply in a new axis `p`. -/
  | mul (p : Nat) : Step
  /-- Divide the axis `p` out. -/
  | div (p : Nat) : Step
deriving DecidableEq, Repr

/-- A path between irrep worlds: a word of moves, read left to right. -/
abbrev Path := List Step

/-- The effect of one move on a number of cells. -/
def Step.run : Step → Nat → Nat
  | Step.mul p, n => p * n
  | Step.div p, n => n / p

/-- The move that undoes a move. -/
def Step.inv : Step → Step
  | Step.mul p => Step.div p
  | Step.div p => Step.mul p

/-- The effect of a path on a number of cells: its moves, in order. -/
def runPath (P : Path) (n : Nat) : Nat := P.foldl (fun m s => s.run m) n

/-- The path that undoes a path: its moves reversed and each one undone. -/
def invPath (P : Path) : Path := (P.map Step.inv).reverse

@[simp] theorem runPath_nil (n : Nat) : runPath [] n = n := rfl

@[simp] theorem runPath_cons (s : Step) (P : Path) (n : Nat) :
    runPath (s :: P) n = runPath P (s.run n) := rfl

/-- **Paths compose.**  Walking `P` and then `Q` is walking `P ++ Q`. -/
theorem runPath_append (P Q : Path) (n : Nat) :
    runPath (P ++ Q) n = runPath Q (runPath P n) := by
  induction P generalizing n with
  | nil => simp
  | cons s P ih => simp [ih]

@[simp] theorem invPath_nil : invPath [] = [] := rfl

theorem invPath_cons (s : Step) (P : Path) :
    invPath (s :: P) = invPath P ++ [s.inv] := by
  simp [invPath]

/-- A path is *walkable* from `n` when every axis it puts on or takes off is
positive and every division it asks for is exact. -/
def okPath : Path → Nat → Prop
  | [], _ => True
  | Step.mul p :: P, n => 0 < p ∧ okPath P (p * n)
  | Step.div p :: P, n => 0 < p ∧ p ∣ n ∧ okPath P (n / p)

/-- Undoing a move undoes it. -/
theorem Step.inv_run_mul {p n : Nat} (hp : 0 < p) :
    (Step.mul p).inv.run ((Step.mul p).run n) = n := by
  simp [Step.run, Step.inv, Nat.mul_div_cancel_left n hp]

theorem Step.inv_run_div {p n : Nat} (hdvd : p ∣ n) :
    (Step.div p).inv.run ((Step.div p).run n) = n := by
  simpa [Step.run, Step.inv] using Nat.mul_div_cancel' hdvd

/-- **Every path can be walked back.**  A walkable path followed by its inverse
path leaves the number of cells where it was. -/
theorem runPath_inv : ∀ (P : Path) {n : Nat}, okPath P n →
    runPath (P ++ invPath P) n = n := by
  intro P
  induction P with
  | nil => intro n _; simp
  | cons s P ih =>
      intro n h
      rw [invPath_cons, List.cons_append, ← List.append_assoc, runPath_cons, runPath_append]
      cases s with
      | mul p =>
          obtain ⟨hp, hrest⟩ := h
          simp only [Step.run]
          rw [ih hrest]
          exact Step.inv_run_mul hp
      | div p =>
          obtain ⟨_, hdvd, hrest⟩ := h
          simp only [Step.run]
          rw [ih hrest]
          exact Step.inv_run_div hdvd

/-! ## The canonical path between two worlds -/

/-- The canonical path from a world of `a` cells to a world of `b` cells: divide
out what `a` does not share with `b`, multiply in what `b` does not share with
`a`. -/
def bridge (a b : Nat) : Path :=
  [Step.div (a / Nat.gcd a b), Step.mul (b / Nat.gcd a b)]

/-- **Any two worlds are one divide and one multiply apart.** -/
theorem bridge_run {a b : Nat} (ha : 0 < a) : runPath (bridge a b) a = b := by
  have hself : a / (a / Nat.gcd a b) = Nat.gcd a b :=
    Nat.div_div_self (Nat.gcd_dvd_left a b) (by omega)
  simp only [bridge, runPath_cons, runPath_nil, Step.run, hself]
  exact Nat.div_mul_cancel (Nat.gcd_dvd_right a b)

theorem gcd_pos {a b : Nat} (ha : 0 < a) : 0 < Nat.gcd a b := by
  rcases Nat.eq_zero_or_pos (Nat.gcd a b) with h | h
  · rw [Nat.gcd_eq_zero_iff] at h
    omega
  · exact h

/-- The canonical path is walkable. -/
theorem bridge_ok {a b : Nat} (ha : 0 < a) (hb : 0 < b) : okPath (bridge a b) a := by
  have hg : 0 < Nat.gcd a b := gcd_pos ha
  exact ⟨Nat.div_pos (Nat.le_of_dvd ha (Nat.gcd_dvd_left a b)) hg,
    Nat.div_dvd_of_dvd (Nat.gcd_dvd_left a b),
    Nat.div_pos (Nat.le_of_dvd hb (Nat.gcd_dvd_right a b)) hg, trivial⟩

/-- What the canonical path divides out and what it multiplies in have nothing in
common: the shared part `gcd a b` is exactly what stays. -/
theorem bridge_div_mul_coprime {a b : Nat} (hg : 0 < Nat.gcd a b) :
    Nat.Coprime (a / Nat.gcd a b) (b / Nat.gcd a b) :=
  Nat.coprime_div_gcd_div_gcd hg

/-- Reading the canonical path backwards returns you to where you started. -/
theorem bridge_inv_run {a b : Nat} (ha : 0 < a) (hb : 0 < b) :
    runPath (bridge a b ++ invPath (bridge a b)) a = a :=
  runPath_inv _ (bridge_ok ha hb)

/-! ## Paths act on the boxes themselves -/

/-- The effect of one move on a box: multiplying puts an axis on, dividing takes
one off. -/
def Step.onIrrep : Step → Irrep → Irrep
  | Step.mul p, I => ⟨p :: I.axes⟩
  | Step.div p, I => ⟨I.axes.erase p⟩

/-- The effect of a path on a box. -/
def walk (P : Path) (I : Irrep) : Irrep := P.foldl (fun J s => s.onIrrep J) I

@[simp] theorem walk_nil (I : Irrep) : walk [] I = I := rfl

@[simp] theorem walk_cons (s : Step) (P : Path) (I : Irrep) :
    walk (s :: P) I = walk P (s.onIrrep I) := rfl

/-- **Paths compose on boxes too.** -/
theorem walk_append (P Q : Path) (I : Irrep) : walk (P ++ Q) I = walk Q (walk P I) := by
  induction P generalizing I with
  | nil => simp
  | cons s P ih => simp [ih]

/-- A path is *walkable on a box* when every axis it multiplies in is positive
and every axis it divides out is positive and actually there. -/
def axesOk : Path → Irrep → Prop
  | [], _ => True
  | Step.mul p :: P, I => 0 < p ∧ axesOk P ((Step.mul p).onIrrep I)
  | Step.div p :: P, I => 0 < p ∧ p ∈ I.axes ∧ axesOk P ((Step.div p).onIrrep I)

theorem size_onIrrep_mul (p : Nat) (I : Irrep) :
    ((Step.mul p).onIrrep I).size = p * I.size := by
  simp [Step.onIrrep, Irrep.size]

theorem size_onIrrep_div {p : Nat} {I : Irrep} (hp : 0 < p) (hmem : p ∈ I.axes) :
    ((Step.div p).onIrrep I).size = I.size / p := by
  have h : p * (I.axes.erase p).prod = I.axes.prod := List.prod_erase hmem
  simp only [Step.onIrrep, Irrep.size]
  rw [← h, Nat.mul_div_cancel_left _ hp]

/-- Walking on a box divides and multiplies its axes; walking on a number
divides and multiplies the number.  **The two agree**: the box you arrive in has
as many cells as the path says. -/
theorem walk_size : ∀ (P : Path) {I : Irrep}, axesOk P I → (walk P I).size = runPath P I.size := by
  intro P
  induction P with
  | nil => intro I _; simp
  | cons s P ih =>
      intro I h
      cases s with
      | mul p =>
          obtain ⟨_, hrest⟩ := h
          rw [walk_cons, ih hrest, size_onIrrep_mul]
          rfl
      | div p =>
          obtain ⟨hp, hmem, hrest⟩ := h
          rw [walk_cons, ih hrest, size_onIrrep_div hp hmem]
          rfl

/-- Walking a box and walking it back leaves the cell count where it was. -/
theorem walk_inv_size {P : Path} {I : Irrep} (hA : axesOk P I)
    (hA' : axesOk (invPath P) (walk P I)) (hn : okPath P I.size) :
    (walk (P ++ invPath P) I).size = I.size := by
  rw [walk_append, walk_size _ hA', walk_size _ hA, ← runPath_append]
  exact runPath_inv _ hn

/-! ## The path the game walks: `196883 → 21296876` -/

/-- The move from the world we start in to the world next door: divide out the
`47`, multiply in `41`, `31` and `4`. -/
def ladder : Path := [Step.div 47, Step.mul 41, Step.mul 31, Step.mul 4]

/-- **`÷47 ×41 ×31 ×4` carries `196883` to `21296876`**: the two smallest
non-trivial irreducible representations of the Monster, one path apart. -/
theorem ladder_run : runPath ladder 196883 = 21296876 := by decide

/-- The path the game walks is the canonical one, with the multiplication split
into its prime factors. -/
theorem ladder_eq_bridge : bridge 196883 21296876 = [Step.div 47, Step.mul 5084] := by decide

theorem bridge_run_dims : runPath (bridge 196883 21296876) 196883 = 21296876 := by decide

theorem ladder_mul_split : 41 * 31 * 4 = 5084 := by decide

/-- The whole ladder of dimensions is walked by canonical paths: from each
dimension in the list, the canonical path lands on the next. -/
theorem dimLadder_bridges :
    (monsterDims.zip monsterDims.tail).all
      (fun ab => runPath (bridge ab.1 ab.2) ab.1 == ab.2) = true := by
  decide

/-! ## The box next door -/

/-- The box the game walks into: `4 × 31 × 41 × 71 × 59`. -/
def irrepNext : Irrep := walk ladder Irrep.irrep3

theorem walk_ladder_axes : irrepNext.axes = [4, 31, 41, 71, 59] := by decide

/-- The new box has `21296876` cells — the next irreducible representation. -/
theorem irrepNext_size : irrepNext.size = 21296876 := by decide

/-- Its axes are positive and pairwise coprime, so everything `Project.lean`
proves about a box holds of it. -/
theorem irrepNext_legit : irrepNext.Legit := ⟨by decide, by decide⟩

/-- The path is walkable on the box we start in … -/
theorem ladder_axesOk : axesOk ladder Irrep.irrep3 :=
  ⟨by decide, by decide, by decide, by decide, by decide, trivial⟩

/-- … and the cell count of the box you arrive in is the path applied to the cell
count you set out from: the geometry and the arithmetic agree. -/
theorem irrepNext_size_eq_runPath : irrepNext.size = runPath ladder Irrep.irrep3.size :=
  walk_size ladder ladder_axesOk

/-- **Each cell of the new world is a different can.** -/
theorem irrepNext_cells_distinct {m n : Nat} (hm : m < 21296876) (hn : n < 21296876)
    (h : irrepNext.cell m = irrepNext.cell n) : m = n :=
  Irrep.cell_injOn irrepNext_legit (irrepNext_size ▸ hm) (irrepNext_size ▸ hn) h

/-- **… and no cell of the new world is left empty.** -/
theorem irrepNext_cells_filled {c : Nat} (hc : c < 21296876) :
    ∃ n, n < 21296876 ∧ irrepNext.cell n = c := by
  obtain ⟨n, hn, hcn⟩ := Irrep.cell_surjective irrepNext_legit (irrepNext_size ▸ hc)
  exact ⟨n, irrepNext_size ▸ hn, hcn⟩

/-- **Everything in the game moves along the path.**  Changing irrep along
`ladder` carries the cells of the world we start in into the world next door
without ever putting two cans in one cell: the path moves the whole population,
not just the box. -/
theorem transfer_along_ladder_injective {c d : Nat} (hc : c < 196883) (hd : d < 196883)
    (h : Irrep.irrep3.transfer irrepNext c = Irrep.irrep3.transfer irrepNext d) : c = d := by
  have h3 : Irrep.irrep3.size = 196883 := Irrep.irrep3_size
  have hlc : Irrep.irrep3.lift c < 196883 :=
    h3 ▸ Irrep.lift_lt Irrep.irrep3_legit (h3 ▸ hc)
  have hld : Irrep.irrep3.lift d < 196883 :=
    h3 ▸ Irrep.lift_lt Irrep.irrep3_legit (h3 ▸ hd)
  have hlift : Irrep.irrep3.lift c = Irrep.irrep3.lift d :=
    irrepNext_cells_distinct (by omega) (by omega) h
  calc c = Irrep.irrep3.cell (Irrep.irrep3.lift c) :=
        (Irrep.cell_lift Irrep.irrep3_legit (h3 ▸ hc)).symm
    _ = Irrep.irrep3.cell (Irrep.irrep3.lift d) := by rw [hlift]
    _ = d := Irrep.cell_lift Irrep.irrep3_legit (h3 ▸ hd)

/-- The two worlds share the axes `71` and `59` — the `gcd` of their sizes — so a
can keeps those two of its coordinates as it moves between them. -/
theorem shared_axes :
    Irrep.irrep3.axes.filter (fun p => irrepNext.axes.contains p) = [71, 59] := by decide

theorem shared_axes_prod : 71 * 59 = Nat.gcd 196883 21296876 := by decide

/-! ## The q-expansion: which worlds appear in which grade -/

/-- The first five non-trivial coefficients of the q-expansion of the modular
function `J = j - 744`:
`J(q) = q⁻¹ + 196884 q + 21493760 q² + 864299970 q³ + 20245856256 q⁴ + 333202640600 q⁵ + …` -/
def jCoeffs : List Nat := [196884, 21493760, 864299970, 20245856256, 333202640600]

/-- How many copies of each irreducible representation the graded pieces of the
moonshine module are built from — one row per coefficient of `jCoeffs`, one
column per entry of `monsterDims`. -/
def headMults : List (List Nat) :=
  [[1, 1, 0, 0, 0, 0, 0],
   [1, 1, 1, 0, 0, 0, 0],
   [2, 2, 1, 1, 0, 0, 0],
   [3, 3, 1, 2, 1, 0, 0],
   [4, 5, 3, 2, 1, 1, 1]]

/-- The dimension of a graded piece: the multiplicities against the dimensions. -/
def combine (m : List Nat) : Nat := ((m.zip monsterDims).map (fun x => x.1 * x.2)).sum

/-- **Moonshine, as arithmetic.**  Each coefficient of the q-expansion of `J` is
the total dimension of a sum of irreducible representations of the Monster. -/
theorem jCoeffs_eq_head_characters : headMults.map combine = jCoeffs := by decide

/-- `196884 = 1 + 196883`. -/
theorem coeff1 : 1 + 196883 = 196884 := by decide

/-- `21493760 = 1 + 196883 + 21296876`: the trivial world, the world we start in,
and the world one path away. -/
theorem coeff2 : 1 + 196883 + 21296876 = 21493760 := by decide

/-- `864299970 = 2·1 + 2·196883 + 21296876 + 842609326`. -/
theorem coeff3 : 2 * 1 + 2 * 196883 + 21296876 + 842609326 = 864299970 := by decide

/-- `20245856256 = 3·1 + 3·196883 + 21296876 + 2·842609326 + 18538750076`. -/
theorem coeff4 :
    3 * 1 + 3 * 196883 + 21296876 + 2 * 842609326 + 18538750076 = 20245856256 := by decide

/-- `333202640600 = 4·1 + 5·196883 + 3·21296876 + 2·842609326 + 18538750076 +
19360062527 + 293553734298`. -/
theorem coeff5 :
    4 * 1 + 5 * 196883 + 3 * 21296876 + 2 * 842609326 + 18538750076 + 19360062527
      + 293553734298 = 333202640600 := by decide

/-- **The geometry of the game is the moonshine coefficient.**  The third
coefficient of `J` is one cell of the point, plus a cell for every cell of the
world we start in, plus a cell for every cell of the world one divide and three
multiplies away. -/
theorem coeff2_as_boxes : 1 + Irrep.irrep3.size + irrepNext.size = 21493760 := by decide

/-- Every dimension in the ladder divides into the next one after the shared part
is divided out — the paths of this file are the only thing needed to move along
the q-expansion. -/
theorem dimLadder_walkable :
    (monsterDims.zip monsterDims.tail).all
      (fun ab => decide (0 < ab.1) && decide (0 < Nat.gcd ab.1 ab.2)) = true := by
  decide

end Moonshine

end Monster

end NixWars
