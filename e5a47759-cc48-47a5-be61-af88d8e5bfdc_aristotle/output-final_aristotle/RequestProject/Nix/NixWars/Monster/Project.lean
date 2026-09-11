import RequestProject.Nix.NixWars.Monster.Place
import RequestProject.Nix.NixWars.Cans

set_option maxRecDepth 100000
set_option maxHeartbeats 4000000

/-!
# Projecting everything into the current irrep

The world of `World.lean` is a box of cells cut by primes.  This file says what
it means to *put something in it*: an atom, a voxel, a can — anything carrying a
number — is projected into the current irrep by taking its number modulo each
axis, and the resulting address names the cell it occupies.

* An `Irrep` is just the list of its axes (its primes).  The one we start in is
  `irrep3 = [71, 59, 47]`, the three-dimensional grid with
  `71 * 59 * 47 = 196883` cells.
* `Irrep.coords I n` is the residue vector of `n`, `Irrep.cell I n` the index of
  the cell it lands in, so projecting is one modulo per axis and nothing else.
* Because the axes are pairwise coprime, the projection is a *bijection* between
  the numbers below `I.size` and the cells (`cell_injOn`, `cell_surjective`):
  **each cell is a different can**, and none is left empty.  `Irrep.lift` reads
  the can back off the cell.
* `Irrep.contents` is the content array the projection populates: one slot per
  cell, holding whatever was projected into it.  `contents_full` says that
  projecting the numbers `0, …, size-1` leaves no slot empty and that the slot
  then holds exactly the can the cell names, and `contents_getElem_of_mem` that
  any can whose residues no other can shares is found in the slot its moduli
  name.
* **Moving objects.** `Irrep.shift I d` moves everything `d` along; it is a
  permutation of the cells (`shift_injOn`, `shift_surjOn`), it composes
  (`shift_shift`), and on addresses it is the componentwise translation
  `(x + d) % p` (`coords_add`).  One object on its own is moved by `Irrep.slide`,
  which adds a vector to its address and wraps: an object slid this way never
  leaves the box (`slide_valid`), sliding by nothing does nothing
  (`slide_zero`), and sliding by the address of `d` is exactly moving that
  object's number on by `d` (`slide_coords`).
* **Changing irrep.** `Irrep.transfer I J` carries a cell of `I` to the cell of
  `J` holding the same can; between irreps of the same size it is a bijection
  with `transfer J I` for inverse (`transfer_transfer`).  Adding axes — going up
  in dimension — refines rather than moves: the coarse address of a can is
  recovered from the fine one by a single division (`cell_of_refine`).
-/

namespace NixWars

namespace Monster

/-! ## Irreps -/

/-- An irrep of the world: the list of its axes, coarsest first.  The axes of
the irrep we start in are the primes `71, 59, 47`. -/
structure Irrep where
  /-- The axes (the primes) of this irrep, coarsest first. -/
  axes : List Nat
deriving DecidableEq, Repr

namespace Irrep

/-- The number of axes: the dimension of the grid. -/
def dim (I : Irrep) : Nat := I.axes.length

/-- The number of cells: the product of the axes. -/
def size (I : Irrep) : Nat := I.axes.prod

/-- An irrep is *legit* when its axes are positive and pairwise coprime — the
hypothesis that makes the projection a bijection. -/
structure Legit (I : Irrep) : Prop where
  /-- Every axis has at least one cell along it. -/
  pos : ∀ p ∈ I.axes, 0 < p
  /-- Distinct axes share no factor. -/
  coprime : I.axes.Pairwise Nat.Coprime

theorem size_pos {I : Irrep} (h : ∀ p ∈ I.axes, 0 < p) : 0 < I.size :=
  List.prod_pos h

theorem axis_dvd_size {I : Irrep} {p : Nat} (hp : p ∈ I.axes) : p ∣ I.size :=
  List.dvd_prod hp

/-! ## The projection -/

/-- The address of `n` in `I`: its residue modulo each axis. -/
def coords (I : Irrep) (n : Nat) : List Nat := I.axes.map (fun p => n % p)

/-- The cell of `I` that `n` lands in: the mixed-radix index of its address. -/
def cell (I : Irrep) (n : Nat) : Nat := encode I.axes (I.coords n)

/-- The can a cell names: the unique number below `I.size` projecting to it. -/
def lift (I : Irrep) (c : Nat) : Nat :=
  ((List.range I.size).find? (fun n => I.cell n == c)).getD 0

theorem coords_length (I : Irrep) (n : Nat) : (I.coords n).length = I.dim := by
  simp [coords, dim]

/-- A residue vector is always a valid address: `n % p` is a cell along the
axis `p`. -/
theorem valid_map_mod : ∀ {L : List Nat}, (∀ p ∈ L, 0 < p) → ∀ n : Nat,
    Valid L (L.map (fun p => n % p))
  | [], _, _ => by simp
  | p :: ps, h, n => by
      refine List.Forall₂.cons (Nat.mod_lt _ (h p (List.mem_cons_self ..))) ?_
      exact valid_map_mod (fun q hq => h q (List.mem_cons_of_mem _ hq)) n

theorem coords_valid {I : Irrep} (h : ∀ p ∈ I.axes, 0 < p) (n : Nat) :
    Valid I.axes (I.coords n) := valid_map_mod h n

theorem cell_lt {I : Irrep} (h : ∀ p ∈ I.axes, 0 < p) (n : Nat) : I.cell n < I.size :=
  encode_lt (coords_valid h n)

/-- The projection only sees `n` modulo the number of cells. -/
theorem coords_mod_size (I : Irrep) (n : Nat) : I.coords (n % I.size) = I.coords n := by
  simp only [coords]
  refine List.map_congr_left ?_
  intro p hp
  exact Nat.mod_mod_of_dvd n (axis_dvd_size hp)

theorem cell_mod_size (I : Irrep) (n : Nat) : I.cell (n % I.size) = I.cell n := by
  simp [cell, coords_mod_size]

theorem cell_congr {I : Irrep} {m n : Nat} (h : m % I.size = n % I.size) :
    I.cell m = I.cell n := by
  rw [← cell_mod_size I m, ← cell_mod_size I n, h]

/-! ## Chinese remaindering: each cell is a different can -/

/-- A number coprime to every entry of a list is coprime to their product. -/
theorem coprime_list_prod : ∀ {p : Nat} {L : List Nat}, (∀ q ∈ L, Nat.Coprime p q) →
    Nat.Coprime p L.prod
  | _, [], _ => by simp [Nat.Coprime]
  | p, q :: qs, h => by
      rw [List.prod_cons]
      exact Nat.Coprime.mul_right (h q (List.mem_cons_self ..))
        (coprime_list_prod (fun r hr => h r (List.mem_cons_of_mem _ hr)))

/-- Pairwise coprime moduli that all divide a number: their product divides it. -/
theorem prod_dvd_of_forall_dvd :
    ∀ {L : List Nat}, L.Pairwise Nat.Coprime → ∀ {k : Nat}, (∀ p ∈ L, p ∣ k) → L.prod ∣ k := by
  intro L
  induction L with
  | nil => intro _ k _; simp
  | cons p ps ih =>
      intro hpair k hdvd
      rw [List.pairwise_cons] at hpair
      have hrest : ps.prod ∣ k := ih hpair.2 (fun q hq => hdvd q (List.mem_cons_of_mem _ hq))
      have hcop : Nat.Coprime p ps.prod := coprime_list_prod (fun q hq => hpair.1 q hq)
      rw [List.prod_cons]
      exact Nat.Coprime.mul_dvd_of_dvd_of_dvd hcop (hdvd p (List.mem_cons_self ..)) hrest

/-- Two numbers with the same residue vector have the same residue along every
axis. -/
theorem mod_eq_of_map_mod_eq : ∀ {L : List Nat} {m n : Nat},
    L.map (fun p => m % p) = L.map (fun p => n % p) → ∀ p ∈ L, m % p = n % p
  | [], _, _, _, _, hp => absurd hp (by simp)
  | q :: qs, _, _, h, p, hp => by
      simp only [List.map_cons, List.cons.injEq] at h
      rcases List.mem_cons.1 hp with rfl | hp'
      · exact h.1
      · exact mod_eq_of_map_mod_eq h.2 p hp'

theorem coords_inj {I : Irrep} (hI : I.Legit) {m n : Nat} (hm : m < I.size) (hn : n < I.size)
    (h : I.coords m = I.coords n) : m = n := by
  have hmod : ∀ p ∈ I.axes, m % p = n % p := mod_eq_of_map_mod_eq h
  rcases Nat.le_total m n with hmn | hmn
  · have hdvd : ∀ p ∈ I.axes, p ∣ n - m := fun p hp => (Nat.modEq_iff_dvd' hmn).1 (hmod p hp)
    have hdd : I.size ∣ n - m := prod_dvd_of_forall_dvd hI.coprime hdvd
    rcases Nat.eq_zero_or_pos (n - m) with h0 | h0
    · omega
    · have := Nat.le_of_dvd h0 hdd
      omega
  · have hdvd : ∀ p ∈ I.axes, p ∣ m - n := fun p hp => (Nat.modEq_iff_dvd' hmn).1 (hmod p hp).symm
    have hdd : I.size ∣ m - n := prod_dvd_of_forall_dvd hI.coprime hdvd
    rcases Nat.eq_zero_or_pos (m - n) with h0 | h0
    · omega
    · have := Nat.le_of_dvd h0 hdd
      omega

/-- **Each cell is a different can.**  Below the number of cells, no two numbers
project to the same cell. -/
theorem cell_injOn {I : Irrep} (hI : I.Legit) {m n : Nat} (hm : m < I.size) (hn : n < I.size)
    (h : I.cell m = I.cell n) : m = n := by
  refine coords_inj hI hm hn ?_
  have hvm := coords_valid hI.pos m
  have hvn := coords_valid hI.pos n
  have := congrArg (decode I.axes) h
  rwa [cell, cell, decode_encode hvm, decode_encode hvn] at this

/-- **Nothing is left empty.**  Every cell of a legit irrep is the cell of some
can below the number of cells. -/
theorem cell_surjective {I : Irrep} (hI : I.Legit) {c : Nat} (hc : c < I.size) :
    ∃ n, n < I.size ∧ I.cell n = c := by
  classical
  have hpos : 0 < I.size := size_pos hI.pos
  set f : Fin I.size → Fin I.size := fun n => ⟨I.cell n.1, cell_lt hI.pos n.1⟩ with hf
  have hinj : Function.Injective f := by
    intro a b hab
    have : I.cell a.1 = I.cell b.1 := congrArg Fin.val hab
    exact Fin.ext (cell_injOn hI a.2 b.2 this)
  have hsurj : Function.Surjective f := Finite.surjective_of_injective hinj
  obtain ⟨n, hn⟩ := hsurj ⟨c, hc⟩
  exact ⟨n.1, n.2, congrArg Fin.val hn⟩

theorem lift_spec {I : Irrep} (hI : I.Legit) {c : Nat} (hc : c < I.size) :
    I.lift c < I.size ∧ I.cell (I.lift c) = c := by
  obtain ⟨n, hn, hcn⟩ := cell_surjective hI hc
  have hmem : n ∈ (List.range I.size).filter (fun m => I.cell m == c) := by
    simp [List.mem_filter, List.mem_range, hn, hcn]
  have hfind : ((List.range I.size).find? (fun m => I.cell m == c)).isSome := by
    rcases h : (List.range I.size).find? (fun m => I.cell m == c) with _ | v
    · exfalso
      have := List.find?_eq_none.1 h n (by simp [List.mem_range, hn])
      simp [hcn] at this
    · simp
  rcases h : (List.range I.size).find? (fun m => I.cell m == c) with _ | v
  · rw [h] at hfind; simp at hfind
  · have hv := List.find?_some h
    have hmem' := List.mem_of_find?_eq_some h
    simp only [beq_iff_eq] at hv
    simp only [List.mem_range] at hmem'
    refine ⟨?_, ?_⟩ <;> simp [lift, h, hv, hmem']

theorem lift_lt {I : Irrep} (hI : I.Legit) {c : Nat} (hc : c < I.size) : I.lift c < I.size :=
  (lift_spec hI hc).1

theorem cell_lift {I : Irrep} (hI : I.Legit) {c : Nat} (hc : c < I.size) :
    I.cell (I.lift c) = c := (lift_spec hI hc).2

theorem lift_cell {I : Irrep} (hI : I.Legit) (n : Nat) : I.lift (I.cell n) = n % I.size := by
  have hpos : 0 < I.size := size_pos hI.pos
  have hc : I.cell n < I.size := cell_lt hI.pos n
  have h1 : I.cell (I.lift (I.cell n)) = I.cell n := cell_lift hI hc
  have h2 : I.cell (n % I.size) = I.cell n := cell_mod_size I n
  exact cell_injOn hI (lift_lt hI hc) (Nat.mod_lt _ hpos) (by rw [h1, h2])

/-! ## The content array -/

/-- A search that can only succeed in one place finds it. -/
theorem find?_eq_some_of_unique {α : Type} {f : α → Bool} : ∀ {L : List α} {k : α},
    k ∈ L → f k = true → (∀ a ∈ L, f a = true → a = k) → L.find? f = some k
  | [], _, hk, _, _ => absurd hk (by simp)
  | a :: as, k, hk, hfk, huniq => by
      by_cases hfa : f a = true
      · have hak : a = k := huniq a (List.mem_cons_self ..) hfa
        rw [List.find?_cons_of_pos hfa, hak]
      · have hk' : k ∈ as := by
          rcases List.mem_cons.1 hk with rfl | h
          · exact absurd hfk hfa
          · exact h
        rw [List.find?_cons_of_neg (by simpa using hfa)]
        exact find?_eq_some_of_unique hk' hfk (fun b hb => huniq b (List.mem_cons_of_mem _ hb))

/-- Where each can goes: its number modulo each axis, read as a cell index.
This is the whole projection — one pass over whatever is in the game. -/
def placements {α : Type} (I : Irrep) (val : α → Nat) (cans : List α) : List (Nat × α) :=
  cans.map (fun a => (I.cell (val a), a))

theorem placements_lt {α : Type} {I : Irrep} (h : ∀ p ∈ I.axes, 0 < p) (val : α → Nat)
    (cans : List α) : ∀ q ∈ I.placements val cans, q.1 < I.size := by
  intro q hq
  simp only [placements, List.mem_map] at hq
  obtain ⟨a, _, rfl⟩ := hq
  exact cell_lt h (val a)

/-- The content array the projection populates: one slot per cell of `I`,
holding the first of `cans` that was projected into that cell. -/
def contents {α : Type} (I : Irrep) (val : α → Nat) (cans : List α) : List (Option α) :=
  (List.range I.size).map (fun c => cans.find? (fun a => I.cell (val a) == c))

theorem contents_length {α : Type} (I : Irrep) (val : α → Nat) (cans : List α) :
    (I.contents val cans).length = I.size := by
  simp [contents]

theorem contents_getElem {α : Type} (I : Irrep) (val : α → Nat) (cans : List α) {c : Nat}
    (hc : c < I.size) :
    (I.contents val cans)[c]?
      = some (cans.find? (fun a => I.cell (val a) == c)) := by
  simp [contents, hc]

/-- **Every can lands in its own cell.**  A can whose residues no other can
shares is found in the slot its moduli name. -/
theorem contents_getElem_of_mem {α : Type} {I : Irrep} (h : ∀ p ∈ I.axes, 0 < p)
    (val : α → Nat) {cans : List α} {a : α} (ha : a ∈ cans)
    (huniq : ∀ b ∈ cans, I.cell (val b) = I.cell (val a) → b = a) :
    (I.contents val cans)[I.cell (val a)]? = some (some a) := by
  rw [contents_getElem I val cans (cell_lt h (val a))]
  congr 1
  refine find?_eq_some_of_unique ha (by simp) ?_
  intro b hb hfb
  exact huniq b hb (by simpa using hfb)

/-- **The world is populated.**  Project the cans numbered `0, …, size-1` into a
legit irrep and no slot is left empty. -/
theorem contents_full {I : Irrep} (hI : I.Legit) {c : Nat} (hc : c < I.size) :
    (I.contents id (List.range I.size))[c]? = some (some (I.lift c)) := by
  rw [contents_getElem I id (List.range I.size) hc]
  congr 1
  refine find?_eq_some_of_unique (by simpa using lift_lt hI hc) ?_ ?_
  · simpa using cell_lift hI hc
  · intro a ha hfa
    simp only [List.mem_range] at ha
    simp only [id, beq_iff_eq] at hfa
    exact cell_injOn hI ha (lift_lt hI hc) (by rw [hfa, cell_lift hI hc])

/-! ## Moving objects -/

/-- Moving everything `d` along: the can in cell `c` moves to cell `shift d c`. -/
def shift (I : Irrep) (d c : Nat) : Nat := I.cell (I.lift c + d)

/-- Translating a can translates its address componentwise, one axis at a time. -/
theorem coords_add (I : Irrep) (n d : Nat) :
    I.coords (n + d) = I.axes.map (fun p => (n % p + d) % p) := by
  simp only [coords]
  refine List.map_congr_left ?_
  intro p _
  exact (Nat.mod_add_mod n p d).symm

theorem shift_cell {I : Irrep} (hI : I.Legit) (n d : Nat) :
    I.shift d (I.cell n) = I.cell (n + d) := by
  rw [shift, lift_cell hI n]
  exact cell_congr (Nat.mod_add_mod n I.size d)

theorem shift_lt {I : Irrep} (hI : I.Legit) (d c : Nat) : I.shift d c < I.size :=
  cell_lt hI.pos _

theorem shift_zero {I : Irrep} (hI : I.Legit) {c : Nat} (hc : c < I.size) : I.shift 0 c = c := by
  simp [shift, cell_lift hI hc]

theorem shift_shift {I : Irrep} (hI : I.Legit) (d e c : Nat) :
    I.shift e (I.shift d c) = I.shift (d + e) c := by
  show I.cell (I.lift (I.cell (I.lift c + d)) + e) = I.cell (I.lift c + (d + e))
  rw [lift_cell hI]
  refine cell_congr ?_
  rw [Nat.mod_add_mod, Nat.add_assoc]

/-- Moving everything along is a permutation of the cells: nothing is lost and
nothing is doubled up. -/
theorem shift_injOn {I : Irrep} (hI : I.Legit) {d b c : Nat} (hb : b < I.size) (hc : c < I.size)
    (h : I.shift d b = I.shift d c) : b = c := by
  have hbb : I.lift b < I.size := lift_lt hI hb
  have hcc : I.lift c < I.size := lift_lt hI hc
  have hpos : 0 < I.size := size_pos hI.pos
  have h' : (I.lift b + d) % I.size = (I.lift c + d) % I.size := by
    refine cell_injOn hI (Nat.mod_lt _ hpos) (Nat.mod_lt _ hpos) ?_
    rw [cell_mod_size, cell_mod_size]
    exact h
  have hlift : I.lift b = I.lift c := by
    have h2 : I.lift b % I.size = I.lift c % I.size := Nat.ModEq.add_right_cancel' d h'
    rwa [Nat.mod_eq_of_lt hbb, Nat.mod_eq_of_lt hcc] at h2
  rw [← cell_lift hI hb, ← cell_lift hI hc, hlift]

theorem shift_surjOn {I : Irrep} (hI : I.Legit) {d c : Nat} (hc : c < I.size) :
    ∃ b, b < I.size ∧ I.shift d b = c := by
  obtain ⟨n, hn, hcn⟩ := cell_surjective hI hc
  refine ⟨I.cell (n + (I.size - d % I.size)), cell_lt hI.pos _, ?_⟩
  rw [shift_cell hI]
  rw [← hcn]
  refine cell_congr ?_
  have hpos : 0 < I.size := size_pos hI.pos
  have hle : d % I.size ≤ I.size := Nat.le_of_lt (Nat.mod_lt _ hpos)
  have : (n + (I.size - d % I.size) + d) % I.size = n % I.size := by
    have hd : d % I.size + (I.size - d % I.size) = I.size := by omega
    calc (n + (I.size - d % I.size) + d) % I.size
        = (n + ((I.size - d % I.size) + d % I.size)) % I.size := by
          conv_lhs => rw [Nat.add_assoc, Nat.add_mod, Nat.add_mod (I.size - d % I.size) d]
          conv_rhs => rw [Nat.add_mod, Nat.add_mod (I.size - d % I.size) (d % I.size)]
          simp
      _ = (n + I.size) % I.size := by rw [Nat.add_comm (I.size - d % I.size) (d % I.size), hd]
      _ = n % I.size := by simp
  exact this

/-! ## Moving one object -/

/-- Sliding an address by a vector: add along each axis and wrap.  This is how a
single object is moved about the box, one axis at a time or several at once. -/
def slide (I : Irrep) (v a : List Nat) : List Nat :=
  List.zipWith (fun x p => x % p) (List.zipWith (· + ·) a v) I.axes

theorem slide_length (I : Irrep) (v a : List Nat) :
    (I.slide v a).length = min (min a.length v.length) I.axes.length := by
  simp [slide]

/-- Sliding a valid address gives a valid address: an object never leaves the
box. -/
theorem valid_zipWith_mod : ∀ {L a v : List Nat}, (∀ p ∈ L, 0 < p) → a.length = L.length →
    v.length = L.length →
    Valid L (List.zipWith (fun x p => x % p) (List.zipWith (· + ·) a v) L)
  | [], a, v, _, _, _ => by cases a <;> cases v <;> simp
  | p :: ps, a, v, h, ha, hv => by
      cases a with
      | nil => simp at ha
      | cons x xs =>
        cases v with
        | nil => simp at hv
        | cons y ys =>
            simp only [List.zipWith_cons_cons]
            refine List.Forall₂.cons (Nat.mod_lt _ (h p (List.mem_cons_self ..))) ?_
            exact valid_zipWith_mod (fun q hq => h q (List.mem_cons_of_mem _ hq))
              (by simpa using ha) (by simpa using hv)

theorem slide_valid {I : Irrep} (h : ∀ p ∈ I.axes, 0 < p) {v a : List Nat}
    (ha : a.length = I.axes.length) (hv : v.length = I.axes.length) :
    Valid I.axes (I.slide v a) := valid_zipWith_mod h ha hv

/-- **Moving an object is moving its number.**  Sliding a can's address by the
address of `d` is the address of the can `d` further on, so moving objects about
the box and moving the world along are the same operation. -/
theorem slide_coords (I : Irrep) (n d : Nat) :
    I.slide (I.coords d) (I.coords n) = I.coords (n + d) := by
  simp only [slide, coords]
  induction I.axes with
  | nil => simp
  | cons p ps ih =>
      simp only [List.map_cons, List.zipWith_cons_cons, List.cons.injEq]
      refine ⟨?_, ih⟩
      rw [Nat.add_mod (n % p) (d % p) p, Nat.mod_mod, Nat.mod_mod, ← Nat.add_mod]

theorem zipWith_mod_replicate_zero : ∀ {L a : List Nat}, Valid L a →
    List.zipWith (fun x p => x % p) (List.zipWith (· + ·) a (List.replicate L.length 0)) L = a
  | _, _, List.Forall₂.nil => by simp
  | _, _, @List.Forall₂.cons _ _ _ x p xs ps hx hrest => by
      simp only [List.length_cons, List.replicate_succ, List.zipWith_cons_cons,
        List.cons.injEq]
      exact ⟨by simpa using Nat.mod_eq_of_lt hx, zipWith_mod_replicate_zero hrest⟩

/-- Sliding by nothing leaves an address where it was. -/
theorem slide_zero {I : Irrep} {a : List Nat} (ha : Valid I.axes a) :
    I.slide (List.replicate I.axes.length 0) a = a := zipWith_mod_replicate_zero ha

/-! ## Changing irrep -/

/-- The cell of `J` holding the can that cell `c` of `I` holds. -/
def transfer (I J : Irrep) (c : Nat) : Nat := J.cell (I.lift c)

theorem transfer_lt {I J : Irrep} (hJ : J.Legit) (c : Nat) : I.transfer J c < J.size :=
  cell_lt hJ.pos _

/-- Between irreps with the same number of cells, changing irrep is a bijection:
the cans are the same cans, differently addressed. -/
theorem transfer_transfer {I J : Irrep} (hI : I.Legit) (hJ : J.Legit) (hsize : I.size = J.size)
    {c : Nat} (hc : c < I.size) : J.transfer I (I.transfer J c) = c := by
  rw [transfer, transfer, lift_cell hJ, ← hsize, Nat.mod_eq_of_lt (lift_lt hI hc),
    cell_lift hI hc]

/-! ## Going up in dimension -/

theorem encode_append_gen : ∀ {A a : List Nat}, a.length = A.length → ∀ B b : List Nat,
    encode (A ++ B) (a ++ b) = encode A a * B.prod + encode B b := by
  intro A
  induction A with
  | nil => intro a h B b; cases a with
    | nil => simp
    | cons _ _ => simp at h
  | cons p ps ih =>
      intro a h B b
      cases a with
      | nil => simp at h
      | cons x xs =>
          simp only [List.cons_append, encode_cons, List.prod_append]
          rw [ih (by simpa using h) B b]
          ring

/-- Adding axes refines: the coarse cell of a can is one division away from its
fine cell, so going up in dimension does not move anything. -/
theorem cell_of_refine {I J : Irrep} {E : List Nat} (hJ : J.axes = I.axes ++ E)
    (hE : ∀ p ∈ E, 0 < p) (n : Nat) : J.cell n / E.prod = I.cell n := by
  have hco : J.coords n = I.coords n ++ E.map (fun p => n % p) := by
    simp [coords, hJ]
  have hlen : (I.coords n).length = I.axes.length := by simp [coords]
  have hEv : Valid E (E.map (fun p => n % p)) := valid_map_mod hE n
  have hlt : encode E (E.map (fun p => n % p)) < E.prod := encode_lt hEv
  have hEpos : 0 < E.prod := lt_of_le_of_lt (Nat.zero_le _) hlt
  have hsplit : J.cell n = E.prod * I.cell n + encode E (E.map (fun p => n % p)) := by
    rw [cell, hJ, hco, encode_append_gen hlen, Nat.mul_comm]
    rfl
  rw [hsplit, Nat.mul_add_div hEpos, Nat.div_eq_of_lt hlt, Nat.add_zero]

theorem size_of_refine {I J : Irrep} {E : List Nat} (hJ : J.axes = I.axes ++ E) :
    J.size = I.size * E.prod := by
  simp [size, hJ]

/-! ## The irreps we play in -/

/-- The irrep we start in: the three-dimensional grid `71 × 59 × 47`. -/
def irrep3 : Irrep := ⟨[71, 59, 47]⟩

/-- One axis up: `71 × 59 × 47 × 41`. -/
def irrep4 : Irrep := ⟨[71, 59, 47, 41]⟩

/-- A different irrep of the same size: the same three primes, reordered, so the
same cans in different cells. -/
def irrep3' : Irrep := ⟨[47, 71, 59]⟩

/-- A different irrep with different primes: `73 × 67 × 61`. -/
def irrepOther : Irrep := ⟨[73, 67, 61]⟩

/-- The irrep of the `d`-dimensional level of the Monster world. -/
def ofLevel (d : Nat) : Irrep := ⟨level d⟩

theorem irrep3_size : irrep3.size = 196883 := by decide
theorem irrep4_size : irrep4.size = 8072203 := by decide
theorem irrep3'_size : irrep3'.size = 196883 := by decide
theorem irrepOther_size : irrepOther.size = 298351 := by decide

theorem irrep3_dim : irrep3.dim = 3 := by decide
theorem irrep4_dim : irrep4.dim = 4 := by decide

theorem irrep3_legit : irrep3.Legit := ⟨by decide, by decide⟩
theorem irrep4_legit : irrep4.Legit := ⟨by decide, by decide⟩
theorem irrep3'_legit : irrep3'.Legit := ⟨by decide, by decide⟩
theorem irrepOther_legit : irrepOther.Legit := ⟨by decide, by decide⟩

/-- The irrep we start in is the three-dimensional level of the Monster world. -/
theorem irrep3_eq_level : irrep3 = ofLevel 3 := by decide

/-- … and its cell count is the one `World.lean` computed. -/
theorem irrep3_size_eq_cells : irrep3.size = cells 3 := by decide

theorem irrep4_refines : irrep4.axes = irrep3.axes ++ [41] := by decide

theorem ofLevel_legit {d : Nat} : (ofLevel d).Legit := by
  refine ⟨?_, ?_⟩
  · intro p hp
    exact worldAxes_pos p (List.mem_of_mem_take hp)
  · exact (by decide : worldAxes.Pairwise Nat.Coprime).sublist (List.take_sublist d worldAxes)

end Irrep

end Monster

end NixWars
