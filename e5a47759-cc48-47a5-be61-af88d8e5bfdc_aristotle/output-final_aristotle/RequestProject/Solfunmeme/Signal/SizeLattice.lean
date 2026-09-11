/-
  SizeLattice.lean — the lattice of sizes.

  `ConformalEmbedding.lean` solved the conformal field of the recorded
  continuum and found thirteen scales,

      1, 2, 3, 4, 6, 8, 12, 24, 48, 96, 144, 192, 1152,

  one at each strand, determined up to a single overall factor.  This module
  takes those thirteen numbers as an object in their own right: ordered by
  divisibility they form a **bounded lattice**, with

  * `smeet a b` — the largest recorded size dividing both, and
  * `sjoin a b` — the smallest recorded size that both divide.

  Everything is proved: the two operations stay inside the thirteen sizes, they
  really are the greatest lower and least upper bounds for divisibility, and
  the resulting structure is a `Lattice` with bottom `1` and top `1152`
  (instances on the subtype `Size`).  The meet is the ordinary `gcd`, but the
  join is *not* the ordinary `lcm`: `96 ⊔ 144 = 1152` while `lcm 96 144 = 288`,
  because 288 is not one of the recorded sizes.  That coarsening is what makes
  the lattice interesting — it is not distributive, and not even modular, and
  explicit witnesses to both failures are given.

  The lattice is the state space of the artificial-life simulation in
  `AlifeLattice.lean`, which is hosted on the very web whose conformal solution
  produced these sizes.
-/
import RequestProject.Solfunmeme.Signal.ConformalEmbedding

namespace Mycelium

/-! ## The thirteen sizes -/

/-- The sizes of the recorded continuum, in increasing order: the values of the
    conformal solution `continuumField`, normalised to `1` at the 2002 root. -/
def sizes : List ℕ := [1, 2, 3, 4, 6, 8, 12, 24, 48, 96, 144, 192, 1152]

/-- The size of a strand: the conformal solution, read as a natural number. -/
def strandSize : Strand → ℕ
  | .gccIntrospector => 1
  | .owlTreeOntology => 2
  | .semanticGraphStore => 3
  | .escapedRDFa => 6
  | .zkShardedSemantics => 12
  | .metamemeVerses => 4
  | .sCombinatorRewriting => 8
  | .introspectiveAgents => 24
  | .leanFormalLayer => 48
  | .multipolarProofPooling => 96
  | .upperOntologyMerge => 192
  | .solfunmemeZOS => 144
  | .mycelialContinuum => 1152

/-- The sizes really are the conformal solution. -/
theorem strandSize_eq_continuumField (x : Strand) : (strandSize x : ℚ) = continuumField x := by
  cases x <;> norm_num [strandSize, continuumField]

/-- Every strand's size is one of the thirteen. -/
theorem strandSize_mem (x : Strand) : strandSize x ∈ sizes := by cases x <;> decide

/-- …and every one of the thirteen is the size of a strand. -/
theorem sizes_attained_list : ∀ s ∈ sizes, s ∈ allStrands.map strandSize := by decide

/-- …and every one of the thirteen is the size of a strand. -/
theorem sizes_attained : ∀ s ∈ sizes, ∃ x : Strand, strandSize x = s := by
  intro s hs
  obtain ⟨x, -, hx⟩ := List.mem_map.mp (sizes_attained_list s hs)
  exact ⟨x, hx⟩

/-- Distinct strands have distinct sizes, so `strandSize` identifies the
    thirteen sizes with the thirteen strands. -/
theorem strandSize_injective : Function.Injective strandSize := by
  intro a b hab
  cases a <;> cases b <;> first | rfl | (exact absurd hab (by decide))

/-! ## Meet and join inside the sizes -/

/-- The join of two sizes: the smallest recorded size that both divide.  (The
    list `sizes` is increasing, so folding `min` picks the least candidate;
    `1152` is the top, and is a candidate for every pair.) -/
def sjoin (a b : ℕ) : ℕ :=
  (sizes.filter (fun s => decide (a ∣ s) && decide (b ∣ s))).foldr min 1152

/-- The meet of two sizes: the largest recorded size dividing both. -/
def smeet (a b : ℕ) : ℕ :=
  (sizes.filter (fun s => decide (s ∣ a) && decide (s ∣ b))).foldr max 1

/-! ### The defining properties, checked on all 13 × 13 (and 13³) cases -/

theorem sjoin_mem : ∀ a ∈ sizes, ∀ b ∈ sizes, sjoin a b ∈ sizes := by decide

theorem smeet_mem : ∀ a ∈ sizes, ∀ b ∈ sizes, smeet a b ∈ sizes := by decide

theorem left_dvd_sjoin : ∀ a ∈ sizes, ∀ b ∈ sizes, a ∣ sjoin a b := by decide

theorem right_dvd_sjoin : ∀ a ∈ sizes, ∀ b ∈ sizes, b ∣ sjoin a b := by decide

theorem smeet_dvd_left : ∀ a ∈ sizes, ∀ b ∈ sizes, smeet a b ∣ a := by decide

theorem smeet_dvd_right : ∀ a ∈ sizes, ∀ b ∈ sizes, smeet a b ∣ b := by decide

/-- `sjoin` is a least upper bound for divisibility. -/
theorem sjoin_dvd : ∀ a ∈ sizes, ∀ b ∈ sizes, ∀ c ∈ sizes, a ∣ c → b ∣ c → sjoin a b ∣ c := by
  decide

/-- `smeet` is a greatest lower bound for divisibility. -/
theorem dvd_smeet : ∀ a ∈ sizes, ∀ b ∈ sizes, ∀ c ∈ sizes, c ∣ a → c ∣ b → c ∣ smeet a b := by
  decide

theorem sjoin_comm : ∀ a ∈ sizes, ∀ b ∈ sizes, sjoin a b = sjoin b a := by decide

theorem sjoin_assoc : ∀ a ∈ sizes, ∀ b ∈ sizes, ∀ c ∈ sizes,
    sjoin (sjoin a b) c = sjoin a (sjoin b c) := by decide

/-- The medial law: joining two mixtures is mixing two joins. -/
theorem sjoin_medial {a b u v : ℕ} (ha : a ∈ sizes) (hb : b ∈ sizes) (hu : u ∈ sizes)
    (hv : v ∈ sizes) : sjoin (sjoin a b) (sjoin u v) = sjoin (sjoin a u) (sjoin b v) := by
  rw [sjoin_assoc a ha b hb _ (sjoin_mem u hu v hv),
    ← sjoin_assoc b hb u hu v hv, sjoin_comm b hb u hu,
    sjoin_assoc u hu b hb v hv, ← sjoin_assoc a ha u hu _ (sjoin_mem b hb v hv)]

/-- Joining with something already below changes nothing. -/
theorem sjoin_of_dvd : ∀ a ∈ sizes, ∀ b ∈ sizes, a ∣ b → sjoin a b = b := by decide

/-- `1` is the bottom: it divides every size. -/
theorem one_dvd_size : ∀ a ∈ sizes, 1 ∣ a := by decide

/-- `1152` is the top: every size divides it. -/
theorem dvd_top_size : ∀ a ∈ sizes, a ∣ 1152 := by decide

theorem one_mem_sizes : (1 : ℕ) ∈ sizes := by decide

theorem top_mem_sizes : (1152 : ℕ) ∈ sizes := by decide

/-! ## The lattice -/

/-- A size: one of the thirteen scales of the recorded continuum. -/
def Size : Type := {n : ℕ // n ∈ sizes}

namespace Size

instance : DecidableEq Size := fun a b =>
  decidable_of_iff (a.1 = b.1) (by cases a; cases b; simp [Size])

instance : LE Size := ⟨fun a b => a.1 ∣ b.1⟩

instance : DecidableRel (α := Size) (· ≤ ·) := fun a b => Nat.decidable_dvd a.1 b.1

theorem le_def {a b : Size} : a ≤ b ↔ a.1 ∣ b.1 := Iff.rfl

instance : PartialOrder Size where
  le_refl a := dvd_refl a.1
  le_trans _ _ _ hab hbc := dvd_trans hab hbc
  le_antisymm a b hab hba := Subtype.ext (Nat.dvd_antisymm hab hba)

instance : Lattice Size where
  sup a b := ⟨sjoin a.1 b.1, sjoin_mem a.1 a.2 b.1 b.2⟩
  inf a b := ⟨smeet a.1 b.1, smeet_mem a.1 a.2 b.1 b.2⟩
  le_sup_left a b := left_dvd_sjoin a.1 a.2 b.1 b.2
  le_sup_right a b := right_dvd_sjoin a.1 a.2 b.1 b.2
  sup_le a b c hac hbc := sjoin_dvd a.1 a.2 b.1 b.2 c.1 c.2 hac hbc
  inf_le_left a b := smeet_dvd_left a.1 a.2 b.1 b.2
  inf_le_right a b := smeet_dvd_right a.1 a.2 b.1 b.2
  le_inf a b c hab hac := dvd_smeet b.1 b.2 c.1 c.2 a.1 a.2 hab hac

instance : OrderBot Size where
  bot := ⟨1, one_mem_sizes⟩
  bot_le a := one_dvd_size a.1 a.2

instance : OrderTop Size where
  top := ⟨1152, top_mem_sizes⟩
  le_top a := dvd_top_size a.1 a.2

instance : BoundedOrder Size := ⟨⟩

@[simp] theorem sup_val (a b : Size) : (a ⊔ b).1 = sjoin a.1 b.1 := rfl

@[simp] theorem inf_val (a b : Size) : (a ⊓ b).1 = smeet a.1 b.1 := rfl

@[simp] theorem bot_val : (⊥ : Size).1 = 1 := rfl

@[simp] theorem top_val : (⊤ : Size).1 = 1152 := rfl

/-- The size of a strand, as an element of the lattice. -/
def ofStrand (x : Strand) : Size := ⟨strandSize x, strandSize_mem x⟩

/-- The thirteen strands are exactly the thirteen sizes. -/
theorem ofStrand_bijective : Function.Bijective ofStrand := by
  constructor
  · intro a b hab
    exact strandSize_injective (congrArg Subtype.val hab)
  · rintro ⟨s, hs⟩
    obtain ⟨x, hx⟩ := sizes_attained s hs
    exact ⟨x, Subtype.ext hx⟩

end Size

/-! ## How the lattice differs from the divisibility lattice of all naturals -/

/-- The meet is the ordinary greatest common divisor: the sizes are closed
    under `gcd`. -/
theorem smeet_eq_gcd : ∀ a ∈ sizes, ∀ b ∈ sizes, smeet a b = Nat.gcd a b := by decide

/-- The join, however, is *not* the least common multiple: the sizes are not
    closed under `lcm`.  `96` and `144` join to the top, `1152`, because their
    lcm `288` is not a recorded size. -/
theorem sjoin_ne_lcm : sjoin 96 144 = 1152 ∧ Nat.lcm 96 144 = 288 ∧ (288 : ℕ) ∉ sizes := by
  refine ⟨by decide, by decide, by decide⟩

/-- Consequently the lattice of sizes is **not distributive**: with
    `a = 192, b = 96, c = 144`,

      a ⊓ (b ⊔ c) = 192   but   (a ⊓ b) ⊔ (a ⊓ c) = 96. -/
theorem not_distributive :
    ∃ a b c : Size, a ⊓ (b ⊔ c) ≠ (a ⊓ b) ⊔ (a ⊓ c) := by
  refine ⟨⟨192, by decide⟩, ⟨96, by decide⟩, ⟨144, by decide⟩, ?_⟩
  intro h
  exact absurd (congrArg Subtype.val h) (by decide)

/-- It is not even **modular**: with `a = 96 ≤ c = 192` and `b = 144`,

      a ⊔ (b ⊓ c) = 96   but   (a ⊔ b) ⊓ c = 192. -/
theorem not_modular :
    ∃ a b c : Size, a ≤ c ∧ a ⊔ (b ⊓ c) ≠ (a ⊔ b) ⊓ c := by
  refine ⟨⟨96, by decide⟩, ⟨144, by decide⟩, ⟨192, by decide⟩, by decide, ?_⟩
  intro h
  exact absurd (congrArg Subtype.val h) (by decide)

/-! ## Axiom audit -/

#print axioms strandSize_eq_continuumField
#print axioms sjoin_dvd
#print axioms dvd_smeet
#print axioms Size.ofStrand_bijective
#print axioms smeet_eq_gcd
#print axioms sjoin_ne_lcm
#print axioms not_distributive
#print axioms not_modular

end Mycelium
