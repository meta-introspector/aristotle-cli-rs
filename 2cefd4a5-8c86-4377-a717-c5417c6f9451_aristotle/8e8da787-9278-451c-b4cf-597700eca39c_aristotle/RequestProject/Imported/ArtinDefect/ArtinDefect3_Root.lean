/-
  ArtinDefect3.lean
  -----------------
  Deriving the icosahedral certificate data FROM THE GROUP.

  Files 1 and 2 tabulate the relevant character values of `SL(2,5)` and the two
  monomial characters `Ind_{C₁₀}λ`, `Ind_{C₆}μ`, and verify the certificate
  `2χ = 2·Ind_{C₁₀}λ − Ind_{C₆}μ` as an identity of tabulated data.  Both files
  explicitly leave open the claim

     (a) that the listed vectors really are induced from linear characters of
         the named cyclic subgroups — they are tabulated, not derived.

  This file removes that gap.  Everything below is about the concrete group

        G := SL(2, ℤ/5) = Matrix.SpecialLinearGroup (Fin 2) (ZMod 5),

  no character table is assumed, and the two monomial characters are honestly
  constructed as traces of explicit induced representations.

  Section 1  General theory: a linear character of a subgroup `H ≤ G`
             (a function `G → ℂ` supported on `H` and multiplicative there),
             the induced matrix representation on `ℂ[G/H]`, the proof that it
             is a monoid homomorphism, and the induced character formula
                 |H| · χ_Ind(g) = Σ_{x ∈ G} λ(x⁻¹ g x).
             (Mathlib has induced representations but no character formula.)

  Section 2  Linear characters of a cyclic subgroup `⟨a⟩` given by a root of
             unity.

  Section 3  The group `SL(2,5)`: order, an explicit set of nine conjugacy
             class representatives, their orders and class sizes.

  Section 4  The two monomial characters: explicit `a` of order 10, `b` of
             order 6, the induced characters of faithful linear characters of
             `⟨a⟩`, `⟨b⟩`, and their values on the nine classes.

  Section 5  The certificate, derived: `2·Ind_{C₁₀}λ − Ind_{C₆}μ` is a class
             function whose values are those of `X = 2χ₂` from file 1.

  Section 6  The Frobenius inner products of file 1, re-derived as sums over
             the group; in particular the class function cut out by the
             certificate has norm one.

  ONE CORRECTION TO FILE 1.  The negative term `B` is NOT induced from a
  faithful linear character of `C₆`, as its header states, but from the
  order-two linear character of `C₆` (kernel of order 3); a faithful one gives
  the values `1, -1` (not `-2, 2`) on the classes of order `6, 3`.  This does
  not affect anything downstream: `B` is a monomial character either way.

  WHAT IS STILL NOT DERIVED HERE.  That `χ₂ := (2·Ind λ − Ind μ)/2` is an
  irreducible *character* (rather than a norm-one class function which is a
  half-integral combination of characters) is not proved; nor is the LP lower
  bound `def(χ₂) ≥ 1/2`.  Neither is needed for the pole theorems of file 1,
  which use only the existence of the certificate.
-/

import Mathlib
import RequestProject.Imported.ArtinDefect.ArtinDefect_Root

namespace ArtinDefect3

open Finset

/-! ## Section 1.  Induced representations of linear characters -/

section General

variable {G : Type*} [Group G]

/-- A *linear character of the subgroup `H`*, packaged as a function on all of
`G` which is extended by zero outside `H`.  This is exactly the data of a
homomorphism `H →* ℂˣ`, in a form convenient for the induction formula. -/
structure LinChar (G : Type*) [Group G] (H : Subgroup G) where
  /-- The underlying function, zero off `H`. -/
  toFun : G → ℂ
  /-- The support of the function is exactly `H`. -/
  supp : ∀ x, toFun x ≠ 0 ↔ x ∈ H
  /-- Multiplicativity when the left factor lies in `H`. -/
  mul_left : ∀ x ∈ H, ∀ y, toFun (x * y) = toFun x * toFun y
  /-- Multiplicativity when the right factor lies in `H`. -/
  mul_right : ∀ x, ∀ y ∈ H, toFun (x * y) = toFun x * toFun y

namespace LinChar

variable {H : Subgroup G} (L : LinChar G H)

theorem eq_zero_of_notMem {x : G} (hx : x ∉ H) : L.toFun x = 0 := by
  by_contra h
  exact hx ((L.supp x).1 h)

theorem ne_zero_of_mem {x : G} (hx : x ∈ H) : L.toFun x ≠ 0 := (L.supp x).2 hx

@[simp] theorem map_one : L.toFun 1 = 1 := by
  have h1 : L.toFun (1 * 1) = L.toFun 1 * L.toFun 1 := L.mul_left 1 H.one_mem 1
  simp only [one_mul] at h1
  have hne : L.toFun 1 ≠ 0 := L.ne_zero_of_mem H.one_mem
  field_simp at h1
  tauto

theorem inv_mul_self {x : G} (hx : x ∈ H) : L.toFun x⁻¹ * L.toFun x = 1 := by
  have h := L.mul_left x⁻¹ (H.inv_mem hx) x
  simp only [inv_mul_cancel, L.map_one] at h
  exact h.symm

/-- A linear character is invariant under conjugation by elements of `H`. -/
theorem conj_invariant {h : G} (hh : h ∈ H) (y : G) :
    L.toFun (h⁻¹ * y * h) = L.toFun y := by
  by_cases hy : y ∈ H
  · have h1 : L.toFun (h⁻¹ * (y * h)) = L.toFun h⁻¹ * L.toFun (y * h) :=
      L.mul_left h⁻¹ (H.inv_mem hh) _
    have h2 : L.toFun (y * h) = L.toFun y * L.toFun h := L.mul_right y h hh
    have h3 := L.inv_mul_self hh
    rw [mul_assoc, h1, h2]
    calc L.toFun h⁻¹ * (L.toFun y * L.toFun h)
        = (L.toFun h⁻¹ * L.toFun h) * L.toFun y := by ring
      _ = L.toFun y := by rw [h3, one_mul]
  · have hny : h⁻¹ * y * h ∉ H := by
      intro hmem
      apply hy
      have hcy : y = h * (h⁻¹ * y * h) * h⁻¹ := by group
      rw [hcy]
      exact H.mul_mem (H.mul_mem hh hmem) (H.inv_mem hh)
    rw [L.eq_zero_of_notMem hny, L.eq_zero_of_notMem hy]

end LinChar

variable [Fintype G] {H : Subgroup G} [DecidablePred (· ∈ H)]

/-- The matrix of the induced representation `Ind_H^G L` in the basis of
cosets, using the canonical set of coset representatives `Quotient.out`. -/
noncomputable def indMat (L : LinChar G H) (g : G) : Matrix (G ⧸ H) (G ⧸ H) ℂ :=
  Matrix.of fun q p => L.toFun ((Quotient.out q)⁻¹ * g * Quotient.out p)

omit [Fintype G] [DecidablePred (· ∈ H)] in
@[simp] theorem indMat_apply (L : LinChar G H) (g : G) (q p : G ⧸ H) :
    indMat L g q p = L.toFun ((Quotient.out q)⁻¹ * g * Quotient.out p) := rfl

omit [Fintype G] [DecidablePred (· ∈ H)] in
/-- Two coset representatives lie in the same coset iff the cosets agree. -/
theorem out_inv_mul_mem_iff {q p : G ⧸ H} :
    (Quotient.out q : G)⁻¹ * Quotient.out p ∈ H ↔ q = p := by
  constructor
  · intro hmem
    have h := QuotientGroup.eq.2 hmem
    rwa [QuotientGroup.out_eq', QuotientGroup.out_eq'] at h
  · rintro rfl
    simp

omit [Fintype G] in
theorem indMat_one (L : LinChar G H) : indMat L 1 = 1 := by
  ext q p
  by_cases h : q = p
  · subst h
    simp [Matrix.one_apply_eq]
  · rw [indMat_apply, Matrix.one_apply_ne h, mul_one]
    exact L.eq_zero_of_notMem (fun hmem => h (out_inv_mul_mem_iff.1 hmem))

theorem indMat_mul (L : LinChar G H) (g g' : G) :
    indMat L (g * g') = indMat L g * indMat L g' := by
  classical
  ext q p
  set r₀ : G ⧸ H := ((g⁻¹ * Quotient.out q : G) : G ⧸ H) with hr₀
  have hmem₀ : (Quotient.out q : G)⁻¹ * g * Quotient.out r₀ ∈ H := by
    have h1 : ((g⁻¹ * Quotient.out q : G) : G ⧸ H) = ((Quotient.out r₀ : G) : G ⧸ H) := by
      rw [QuotientGroup.out_eq']
    have h2 := QuotientGroup.eq.1 h1
    have h3 : (g⁻¹ * Quotient.out q : G)⁻¹ * Quotient.out r₀
        = (Quotient.out q : G)⁻¹ * g * Quotient.out r₀ := by group
    rwa [h3] at h2
  have key : ∀ r : G ⧸ H, r ≠ r₀ →
      L.toFun ((Quotient.out q : G)⁻¹ * g * Quotient.out r) = 0 := by
    intro r hr
    apply L.eq_zero_of_notMem
    intro hmem
    apply hr
    have h4 : (g⁻¹ * Quotient.out q : G)⁻¹ * Quotient.out r ∈ H := by
      have he : (g⁻¹ * Quotient.out q : G)⁻¹ * Quotient.out r
          = (Quotient.out q : G)⁻¹ * g * Quotient.out r := by group
      rwa [he]
    have h5 := QuotientGroup.eq.2 h4
    rw [QuotientGroup.out_eq'] at h5
    exact h5.symm
  rw [Matrix.mul_apply, Finset.sum_eq_single r₀]
  · rw [indMat_apply, indMat_apply, indMat_apply, ← L.mul_left _ hmem₀]
    congr 1
    group
  · intro r _ hr
    rw [indMat_apply, key r hr, zero_mul]
  · intro h
    exact absurd (Finset.mem_univ r₀) h

/-- The induced representation of a linear character, as a monoid
homomorphism into matrices — i.e. an honest representation of `G` of degree
`[G : H]`. -/
noncomputable def indRep (L : LinChar G H) : G →* Matrix (G ⧸ H) (G ⧸ H) ℂ where
  toFun := indMat L
  map_one' := indMat_one L
  map_mul' := indMat_mul L

/-- The induced character: the trace of the induced representation. -/
noncomputable def indChar (L : LinChar G H) (g : G) : ℂ := Matrix.trace (indMat L g)

/-- `indChar` really is the character of the representation `indRep`. -/
theorem indChar_eq_trace_indRep (L : LinChar G H) (g : G) :
    indChar L g = Matrix.trace (indRep L g) := rfl

theorem indChar_eq_sum_diag (L : LinChar G H) (g : G) :
    indChar L g = ∑ q : G ⧸ H, L.toFun ((Quotient.out q : G)⁻¹ * g * Quotient.out q) := rfl

/-- The induced character is a class function. -/
theorem indChar_conj (L : LinChar G H) (g c : G) :
    indChar L (c⁻¹ * g * c) = indChar L g := by
  have h1 : indMat L (c⁻¹ * g * c) = indMat L c⁻¹ * (indMat L g * indMat L c) := by
    rw [indMat_mul, indMat_mul, Matrix.mul_assoc]
  have h3 : indMat L c * indMat L c⁻¹ = 1 := by
    rw [← indMat_mul, mul_inv_cancel, indMat_one]
  rw [indChar, indChar, h1, Matrix.trace_mul_comm, Matrix.mul_assoc, h3, Matrix.mul_one]

/-- Auxiliary equivalence `(G ⧸ H) × H ≃ G`, `(q, h) ↦ out q * h`. -/
noncomputable def cosetEquiv (H : Subgroup G) : (G ⧸ H) × H ≃ G where
  toFun := fun p => (Quotient.out p.1 : G) * (p.2 : G)
  invFun := fun x => (((x : G) : G ⧸ H),
    ⟨(Quotient.out ((x : G) : G ⧸ H) : G)⁻¹ * x, by
      have h : ((Quotient.out ((x : G) : G ⧸ H) : G) : G ⧸ H) = ((x : G) : G ⧸ H) :=
        Quotient.out_eq _
      exact QuotientGroup.eq.1 h⟩)
  right_inv := fun x => by simp
  left_inv := by
    rintro ⟨q, h⟩
    have hq : ((Quotient.out q * (h : G) : G) : G ⧸ H) = q := by
      have h1 : ((Quotient.out q * (h : G) : G) : G ⧸ H)
          = ((Quotient.out q : G) : G ⧸ H) := by
        refine (QuotientGroup.eq.2 ?_).symm
        simp
      rw [h1, QuotientGroup.out_eq']
    refine Prod.ext hq ?_
    apply Subtype.ext
    simp only [hq]
    group

/-- **The induced character formula** for a linear character:
`|H| · Ind(L)(g) = Σ_{x ∈ G} L(x⁻¹ g x)`.  In particular the right-hand side,
divided by `|H|`, is the character of an honest representation of `G`. -/
theorem card_mul_indChar (L : LinChar G H) (g : G) :
    (Nat.card H : ℂ) * indChar L g = ∑ x : G, L.toFun (x⁻¹ * g * x) := by
  classical
  have hre : ∑ x : G, L.toFun (x⁻¹ * g * x)
      = ∑ p : (G ⧸ H) × H, L.toFun ((cosetEquiv H p)⁻¹ * g * (cosetEquiv H p)) :=
    (Fintype.sum_equiv (cosetEquiv H) _ _ (fun _ => rfl)).symm
  have hterm : ∀ q : G ⧸ H, ∀ h : H,
      L.toFun ((cosetEquiv H (q, h))⁻¹ * g * (cosetEquiv H (q, h)))
        = L.toFun ((Quotient.out q : G)⁻¹ * g * Quotient.out q) := by
    intro q h
    have he : ((cosetEquiv H (q, h))⁻¹ * g * (cosetEquiv H (q, h)))
        = (h : G)⁻¹ * ((Quotient.out q : G)⁻¹ * g * Quotient.out q) * (h : G) := by
      show ((Quotient.out q : G) * (h : G))⁻¹ * g * ((Quotient.out q : G) * (h : G)) = _
      group
    rw [he, L.conj_invariant h.2]
  rw [hre, Fintype.sum_prod_type]
  simp only [hterm, Finset.sum_const, Finset.card_univ, nsmul_eq_mul]
  rw [indChar_eq_sum_diag, Finset.mul_sum]
  refine Finset.sum_congr rfl (fun q _ => ?_)
  congr 1
  simp [Nat.card_eq_fintype_card]

end General

/-! ## Section 2.  Linear characters of a cyclic subgroup -/

section Cyclic

variable {G : Type*} [Group G] [DecidableEq G]

/-- The linear character of `⟨a⟩` (with `a` of order `n`) sending `a` to a
chosen `n`-th root of unity `z`. -/
noncomputable def cycFun (a : G) (n : ℕ) (z : ℂ) : G → ℂ :=
  fun x => ∑ k ∈ Finset.range n, if x = a ^ k then z ^ k else 0

theorem cycFun_pow {a : G} {n : ℕ} (hn : orderOf a = n) (z : ℂ) {i : ℕ} (hi : i < n) :
    cycFun a n z (a ^ i) = z ^ i := by
  rw [cycFun, Finset.sum_eq_single i]
  · simp
  · intro k hk hki
    have hne : a ^ i ≠ a ^ k := by
      intro h
      apply hki
      have hlt : k < orderOf a := by rw [hn]; exact Finset.mem_range.1 hk
      have hlt' : i < orderOf a := by rw [hn]; exact hi
      exact pow_injOn_Iio_orderOf (by simpa using hlt) (by simpa using hlt') h.symm
    simp [hne]
  · intro h
    exact absurd (Finset.mem_range.2 hi) h

theorem cycFun_eq_zero_of_notMem {a : G} {n : ℕ} {z : ℂ} {x : G}
    (hx : x ∉ Subgroup.zpowers a) : cycFun a n z x = 0 := by
  rw [cycFun]
  apply Finset.sum_eq_zero
  intro k _
  have hne : x ≠ a ^ k := by
    intro h
    exact hx (h ▸ Subgroup.mem_zpowers_iff.2 ⟨k, by simp⟩)
  simp [hne]

omit [DecidableEq G] in
/-- Every element of `⟨a⟩` is `a ^ i` for some `i < n`, when `a` has order `n > 0`. -/
theorem exists_pow_lt {a : G} {n : ℕ} (hn : orderOf a = n) (hn0 : 0 < n) {x : G}
    (hx : x ∈ Subgroup.zpowers a) : ∃ i < n, x = a ^ i := by
  obtain ⟨m, hm⟩ := Subgroup.mem_zpowers_iff.1 hx
  have hpos : (0 : ℤ) < (n : ℤ) := by exact_mod_cast hn0
  refine ⟨(m % (n : ℤ)).toNat, ?_, ?_⟩
  · have h1 : 0 ≤ m % (n : ℤ) := Int.emod_nonneg _ (by omega)
    have h2 : m % (n : ℤ) < (n : ℤ) := Int.emod_lt_of_pos _ hpos
    omega
  · rw [← hm, ← zpow_natCast a, Int.toNat_of_nonneg (Int.emod_nonneg _ (by omega)),
      zpow_eq_zpow_iff_modEq, hn]
    simp [Int.ModEq, Int.emod_emod_of_dvd]

/-- The value of `cycFun` at an arbitrary power of `a`. -/
theorem cycFun_pow_gen {a : G} {n : ℕ} (hn : orderOf a = n) (hn0 : 0 < n) {z : ℂ}
    (hz : z ^ n = 1) (m : ℕ) : cycFun a n z (a ^ m) = z ^ m := by
  have h1 : a ^ m = a ^ (m % n) := by
    conv_lhs => rw [← Nat.div_add_mod m n]
    rw [pow_add, pow_mul, ← hn, pow_orderOf_eq_one, one_pow, one_mul]
  have h2 : z ^ m = z ^ (m % n) := by
    conv_lhs => rw [← Nat.div_add_mod m n]
    rw [pow_add, pow_mul, hz, one_pow, one_mul]
  rw [h1, h2, cycFun_pow hn z (Nat.mod_lt _ hn0)]

/-- The cyclic linear character as a `LinChar`. -/
noncomputable def cycLinChar {a : G} {n : ℕ} (hn : orderOf a = n) (hn0 : 0 < n) {z : ℂ}
    (hz : z ^ n = 1) : LinChar G (Subgroup.zpowers a) where
  toFun := cycFun a n z
  supp := by
    have hz0 : z ≠ 0 := by
      intro h
      rw [h, zero_pow hn0.ne'] at hz
      exact zero_ne_one hz
    intro x
    constructor
    · intro h
      by_contra hx
      exact h (cycFun_eq_zero_of_notMem hx)
    · intro hx
      obtain ⟨i, hi, rfl⟩ := exists_pow_lt hn hn0 hx
      rw [cycFun_pow hn z hi]
      exact pow_ne_zero _ hz0
  mul_left := by
    intro x hx y
    obtain ⟨i, hi, rfl⟩ := exists_pow_lt hn hn0 hx
    by_cases hy : y ∈ Subgroup.zpowers a
    · obtain ⟨j, hj, rfl⟩ := exists_pow_lt hn hn0 hy
      rw [← pow_add, cycFun_pow_gen hn hn0 hz, cycFun_pow hn z hi, cycFun_pow hn z hj,
        pow_add]
    · have hxy : a ^ i * y ∉ Subgroup.zpowers a := by
        intro hmem
        apply hy
        have hy' : y = (a ^ i)⁻¹ * (a ^ i * y) := by group
        rw [hy']
        exact Subgroup.mul_mem _ (Subgroup.inv_mem _ (Subgroup.pow_mem _
          (Subgroup.mem_zpowers a) i)) hmem
      rw [cycFun_eq_zero_of_notMem hxy, cycFun_eq_zero_of_notMem hy, mul_zero]
  mul_right := by
    intro x y hy
    obtain ⟨j, hj, rfl⟩ := exists_pow_lt hn hn0 hy
    by_cases hx : x ∈ Subgroup.zpowers a
    · obtain ⟨i, hi, rfl⟩ := exists_pow_lt hn hn0 hx
      rw [← pow_add, cycFun_pow_gen hn hn0 hz, cycFun_pow hn z hi, cycFun_pow hn z hj,
        pow_add]
    · have hxy : x * a ^ j ∉ Subgroup.zpowers a := by
        intro hmem
        apply hx
        have hx' : x = (x * a ^ j) * (a ^ j)⁻¹ := by group
        rw [hx']
        exact Subgroup.mul_mem _ hmem (Subgroup.inv_mem _ (Subgroup.pow_mem _
          (Subgroup.mem_zpowers a) j))
      rw [cycFun_eq_zero_of_notMem hxy, cycFun_eq_zero_of_notMem hx, zero_mul]

@[simp] theorem cycLinChar_toFun {a : G} {n : ℕ} (hn : orderOf a = n) (hn0 : 0 < n)
    {z : ℂ} (hz : z ^ n = 1) : (cycLinChar hn hn0 hz).toFun = cycFun a n z := rfl

end Cyclic

/-! ## Section 3.  The group `SL(2,5)` and its nine conjugacy classes -/

section SL25

/-- `G₅ = SL(2, ℤ/5)`, the binary icosahedral group. -/
abbrev G5 := Matrix.SpecialLinearGroup (Fin 2) (ZMod 5)

instance : DecidableEq G5 := fun x y => decidable_of_iff (x.1 = y.1) ⟨Subtype.ext, congrArg _⟩

/-- Shorthand for an element of `SL(2,5)` given by its four entries. -/
def mkG (a b c d : ZMod 5) (h : a * d - b * c = 1 := by decide) : G5 :=
  ⟨!![a, b; c, d], by simpa using h⟩

/-- An element of order 10 generating the cyclic subgroup `C₁₀`. -/
def aa : G5 := mkG 4 4 0 4
/-- An element of order 6 generating the cyclic subgroup `C₆`. -/
def bb : G5 := mkG 0 1 4 1
/-- A unipotent element of order 5. -/
def uu : G5 := mkG 1 1 0 1
/-- The square of `uu`; it is of order 5 but not conjugate to `uu`. -/
def uu2 : G5 := mkG 1 2 0 1
/-- The central element `-I`, the unique element of order 2. -/
def negI : G5 := mkG 4 0 0 4
/-- An element of order 4. -/
def jj : G5 := mkG 0 4 1 0

theorem card_G5 : Fintype.card G5 = 120 := by native_decide

/-- The nine conjugacy class representatives, in the order used in
`ArtinDefect.lean`: orders `1, 5, 5, 4, 2, 10, 10, 6, 3`. -/
def rep : Fin 9 → G5 := ![1, uu, uu2, jj, negI, negI * uu, negI * uu2, bb, negI * bb]

theorem orderOf_aa : orderOf aa = 10 := by
  refine orderOf_eq_of_pow_and_pow_div_prime (by norm_num) (by decide) ?_
  intro p hp hdvd
  have h2 := hp.two_le
  have hle : p ≤ 10 := Nat.le_of_dvd (by norm_num) hdvd
  have hp5 : p = 2 ∨ p = 5 := by interval_cases p <;> revert hp hdvd <;> decide
  rcases hp5 with rfl | rfl
  · decide
  · decide

theorem orderOf_bb : orderOf bb = 6 := by
  refine orderOf_eq_of_pow_and_pow_div_prime (by norm_num) (by decide) ?_
  intro p hp hdvd
  have h2 := hp.two_le
  have hle : p ≤ 6 := Nat.le_of_dvd (by norm_num) hdvd
  have hp3 : p = 2 ∨ p = 3 := by interval_cases p <;> revert hp hdvd <;> decide
  rcases hp3 with rfl | rfl
  · decide
  · decide

/-- The orders of the nine class representatives. -/
def repOrder : Fin 9 → ℕ := ![1, 5, 5, 4, 2, 10, 10, 6, 3]

theorem pow_repOrder (i : Fin 9) : rep i ^ repOrder i = 1 := by
  revert i; decide

theorem repOrder_le_ten (i : Fin 9) : repOrder i ≤ 10 := by
  revert i; decide

theorem pow_repOrder_ne_one_fin :
    ∀ i : Fin 9, ∀ m : Fin 10, 0 < (m : ℕ) → (m : ℕ) < repOrder i → rep i ^ (m : ℕ) ≠ 1 := by
  decide

theorem pow_repOrder_ne_one (i : Fin 9) (m : ℕ) (hm : 0 < m) (hlt : m < repOrder i) :
    rep i ^ m ≠ 1 := by
  have h10 : m < 10 := lt_of_lt_of_le hlt (repOrder_le_ten i)
  exact pow_repOrder_ne_one_fin i ⟨m, h10⟩ hm hlt

/-- The nine representatives have the stated orders. -/
theorem orderOf_rep (i : Fin 9) : orderOf (rep i) = repOrder i := by
  have hpos : 0 < repOrder i := by fin_cases i <;> decide
  have hdvd : orderOf (rep i) ∣ repOrder i := orderOf_dvd_of_pow_eq_one (pow_repOrder i)
  have hne : orderOf (rep i) ≠ 0 := by
    intro h
    have := orderOf_eq_zero_iff.1 h
    exact this (isOfFinOrder_of_finite _)
  rcases Nat.lt_or_ge (orderOf (rep i)) (repOrder i) with hlt | hge
  · exact absurd (pow_orderOf_eq_one (rep i))
      (pow_repOrder_ne_one i _ (Nat.pos_of_ne_zero hne) hlt)
  · exact Nat.le_antisymm (Nat.le_of_dvd hpos hdvd) hge

/-- The nine class sizes: `1, 12, 12, 30, 1, 12, 12, 20, 20`. -/
def classSize : Fin 9 → ℕ := ![1, 12, 12, 30, 1, 12, 12, 20, 20]

theorem card_conjClass (i : Fin 9) :
    (Finset.univ.filter (fun y : G5 => ∃ x : G5, x⁻¹ * rep i * x = y)).card = classSize i := by
  revert i
  native_decide

/-- Every element of `SL(2,5)` is conjugate to one of the nine representatives. -/
theorem rep_covers (g : G5) : ∃ i : Fin 9, ∃ x : G5, x⁻¹ * rep i * x = g := by
  revert g
  native_decide

/-- No two representatives are conjugate: the nine classes are distinct. -/
theorem rep_not_conj (i j : Fin 9) (hij : i ≠ j) :
    ¬ ∃ x : G5, x⁻¹ * rep i * x = rep j := by
  revert hij
  revert i j
  native_decide

end SL25

/-! ## Section 4.  The two monomial characters of `SL(2,5)` -/

section Monomial

open Real Complex

/-- The primitive 10th root of unity used for the linear character of `C₁₀`. -/
noncomputable def zA : ℂ := Complex.exp (2 * Real.pi * Complex.I / 10)

theorem zA_pow_eq (k : ℕ) :
    zA ^ k = Real.cos (k * Real.pi / 5) + Real.sin (k * Real.pi / 5) * Complex.I := by
  have h : zA = Complex.exp ((Real.pi / 5 : ℝ) * Complex.I) := by
    unfold zA; congr 1; push_cast; ring
  rw [h, ← Complex.exp_nat_mul,
    show ((k : ℂ)) * ((Real.pi / 5 : ℝ) * Complex.I) = ((k * Real.pi / 5 : ℝ) : ℂ) * Complex.I by
      push_cast; ring,
    Complex.exp_mul_I]
  simp

theorem zA_pow_ten : zA ^ 10 = 1 := (Complex.isPrimitiveRoot_exp 10 (by norm_num)).pow_eq_one

theorem zA_pow_five : zA ^ 5 = -1 := by
  rw [zA_pow_eq]
  norm_num

/-- `zA ^ k + zA ^ m = 2 cos (kπ/5)` when `k + m = 10`. -/
theorem zA_pair (k m : ℕ) (h : k + m = 10) :
    zA ^ k + zA ^ m = 2 * (Real.cos (k * Real.pi / 5) : ℂ) := by
  have hm : (m : ℝ) * Real.pi / 5 = 2 * Real.pi - (k * Real.pi / 5) := by
    have hkm : (k : ℝ) + m = 10 := by exact_mod_cast congrArg (Nat.cast : ℕ → ℝ) h
    have hmm : (m : ℝ) = 10 - k := by linarith
    rw [hmm]; ring
  rw [zA_pow_eq, zA_pow_eq, hm,
    show (2 * Real.pi - (k * Real.pi / 5)) = -(k * Real.pi / 5) + 2 * Real.pi by ring,
    Real.cos_add_two_pi, Real.sin_add_two_pi, Real.cos_neg, Real.sin_neg]
  push_cast
  ring

theorem cos_two_pi_div_five : Real.cos (2 * Real.pi / 5) = (√5 - 1) / 4 := by
  rw [show (2 : ℝ) * Real.pi / 5 = 2 * (Real.pi / 5) by ring, Real.cos_two_mul,
    Real.cos_pi_div_five]
  have h5 : (√5) ^ 2 = 5 := Real.sq_sqrt (by norm_num)
  nlinarith [h5]

theorem cos_three_pi_div_five : Real.cos (3 * Real.pi / 5) = (1 - √5) / 4 := by
  rw [show (3 : ℝ) * Real.pi / 5 = Real.pi - 2 * Real.pi / 5 by ring, Real.cos_pi_sub,
    cos_two_pi_div_five]
  ring

theorem cos_four_pi_div_five : Real.cos (4 * Real.pi / 5) = -(1 + √5) / 4 := by
  rw [show (4 : ℝ) * Real.pi / 5 = Real.pi - Real.pi / 5 by ring, Real.cos_pi_sub,
    Real.cos_pi_div_five]
  ring

noncomputable instance : DecidablePred (· ∈ Subgroup.zpowers aa) := Classical.decPred _
noncomputable instance : DecidablePred (· ∈ Subgroup.zpowers bb) := Classical.decPred _

/-- The faithful linear character `λ` of `C₁₀ = ⟨aa⟩` sending `aa` to a primitive
10th root of unity. -/
noncomputable def lamA : LinChar G5 (Subgroup.zpowers aa) :=
  cycLinChar orderOf_aa (by norm_num) zA_pow_ten

@[simp] theorem lamA_toFun : lamA.toFun = cycFun aa 10 zA := rfl

/-- The order-two linear character `μ` of `C₆ = ⟨bb⟩`, with kernel the cyclic
subgroup of order 3.  (Note: this is *not* a faithful character of `C₆`; the
description "faithful" in `ArtinDefect.lean` is inaccurate.  A faithful `μ`
would give the values `1, -1` on the classes of order `6, 3` instead of the
tabulated `-2, 2`.) -/
noncomputable def muB : LinChar G5 (Subgroup.zpowers bb) :=
  cycLinChar orderOf_bb (by norm_num) (show ((-1 : ℂ)) ^ 6 = 1 by norm_num)

@[simp] theorem muB_toFun : muB.toFun = cycFun bb 6 (-1) := rfl

/-- Summing a cyclic linear character over a conjugacy orbit, in terms of the
number of conjugates landing on each power of the generator. -/
theorem sum_cycFun_conj (a : G5) (n : ℕ) (z : ℂ) (g : G5) :
    ∑ x : G5, cycFun a n z (x⁻¹ * g * x)
      = ∑ k ∈ Finset.range n,
          ((Finset.univ.filter (fun x : G5 => x⁻¹ * g * x = a ^ k)).card : ℂ) * z ^ k := by
  simp only [cycFun]
  rw [Finset.sum_comm]
  refine Finset.sum_congr rfl (fun k _ => ?_)
  rw [Finset.sum_ite, Finset.sum_const, Finset.sum_const_zero, add_zero, nsmul_eq_mul]

/-- Number of `x` conjugating `rep i` to `aa ^ k`. -/
def countA : Fin 9 → Fin 10 → ℕ := ![
  ![120, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  ![0, 0, 0, 0, 10, 0, 10, 0, 0, 0],
  ![0, 0, 10, 0, 0, 0, 0, 0, 10, 0],
  ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  ![0, 0, 0, 0, 0, 120, 0, 0, 0, 0],
  ![0, 10, 0, 0, 0, 0, 0, 0, 0, 10],
  ![0, 0, 0, 10, 0, 0, 0, 10, 0, 0],
  ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]

/-- Number of `x` conjugating `rep i` to `bb ^ k`. -/
def countB : Fin 9 → Fin 6 → ℕ := ![
  ![120, 0, 0, 0, 0, 0],
  ![0, 0, 0, 0, 0, 0],
  ![0, 0, 0, 0, 0, 0],
  ![0, 0, 0, 0, 0, 0],
  ![0, 0, 0, 120, 0, 0],
  ![0, 0, 0, 0, 0, 0],
  ![0, 0, 0, 0, 0, 0],
  ![0, 6, 0, 0, 0, 6],
  ![0, 0, 6, 0, 6, 0]]

theorem countA_eq (i : Fin 9) (k : Fin 10) :
    (Finset.univ.filter (fun x : G5 => x⁻¹ * rep i * x = aa ^ (k : ℕ))).card = countA i k := by
  revert i k
  native_decide

theorem countB_eq (i : Fin 9) (k : Fin 6) :
    (Finset.univ.filter (fun x : G5 => x⁻¹ * rep i * x = bb ^ (k : ℕ))).card = countB i k := by
  revert i k
  native_decide

theorem card_zpowers_aa : Nat.card (Subgroup.zpowers aa) = 10 := by
  rw [Nat.card_zpowers, orderOf_aa]

theorem card_zpowers_bb : Nat.card (Subgroup.zpowers bb) = 6 := by
  rw [Nat.card_zpowers, orderOf_bb]

theorem ten_mul_indChar_lamA (i : Fin 9) :
    (10 : ℂ) * indChar lamA (rep i) = ∑ k : Fin 10, (countA i k : ℂ) * zA ^ (k : ℕ) := by
  have h := card_mul_indChar lamA (rep i)
  rw [card_zpowers_aa] at h
  rw [show ((10 : ℕ) : ℂ) = (10 : ℂ) by norm_num] at h
  rw [h, lamA_toFun, sum_cycFun_conj, ← Fin.sum_univ_eq_sum_range]
  exact Finset.sum_congr rfl (fun k _ => by rw [countA_eq i k])

theorem six_mul_indChar_muB (i : Fin 9) :
    (6 : ℂ) * indChar muB (rep i) = ∑ k : Fin 6, (countB i k : ℂ) * (-1 : ℂ) ^ (k : ℕ) := by
  have h := card_mul_indChar muB (rep i)
  rw [card_zpowers_bb] at h
  rw [show ((6 : ℕ) : ℂ) = (6 : ℂ) by norm_num] at h
  rw [h, muB_toFun, sum_cycFun_conj, ← Fin.sum_univ_eq_sum_range]
  exact Finset.sum_congr rfl (fun k _ => by rw [countB_eq i k])

end Monomial

/-! ## Section 5.  The certificate, derived -/

section Certificate

open Real Complex

/-- The embedding of `ℤ[√5]` (the value ring used in `ArtinDefect.lean`) into `ℂ`. -/
noncomputable def toC (v : ArtinDefect.V) : ℂ := (v.re : ℂ) + (v.im : ℂ) * (√5 : ℝ)

theorem zA_pair_one : zA ^ 1 + zA ^ 9 = (((1 + √5) / 2 : ℝ) : ℂ) := by
  rw [zA_pair 1 9 rfl]
  norm_num [Real.cos_pi_div_five]
  ring

theorem zA_pair_two : zA ^ 2 + zA ^ 8 = (((√5 - 1) / 2 : ℝ) : ℂ) := by
  rw [zA_pair 2 8 rfl]
  norm_num [cos_two_pi_div_five]
  ring

theorem zA_pair_three : zA ^ 3 + zA ^ 7 = (((1 - √5) / 2 : ℝ) : ℂ) := by
  rw [zA_pair 3 7 rfl]
  norm_num [cos_three_pi_div_five]
  ring

theorem zA_pair_four : zA ^ 4 + zA ^ 6 = ((-(1 + √5) / 2 : ℝ) : ℂ) := by
  rw [zA_pair 4 6 rfl]
  norm_num [cos_four_pi_div_five]
  ring

/-- The degree-12 monomial character `Ind_{C₁₀} λ`, doubled, has exactly the
values tabulated as `A` in `ArtinDefect.lean`. -/
theorem two_indChar_lamA_eq (i : Fin 9) :
    2 * indChar lamA (rep i) = toC (ArtinDefect.A i) := by
  refine mul_left_cancel₀ (show (10 : ℂ) ≠ 0 by norm_num) ?_
  have h : (10 : ℂ) * (2 * indChar lamA (rep i))
      = 2 * ((10 : ℂ) * indChar lamA (rep i)) := by ring
  rw [h, ten_mul_indChar_lamA i]
  fin_cases i <;>
    simp [countA, toC, ArtinDefect.A, Fin.sum_univ_succ, zA_pow_five] <;>
    first
      | ring1
      | linear_combination (norm := (push_cast; ring1)) (20 : ℂ) * zA_pair_four
      | linear_combination (norm := (push_cast; ring1)) (20 : ℂ) * zA_pair_two
      | linear_combination (norm := (push_cast; ring1)) (20 : ℂ) * zA_pair_one
      | linear_combination (norm := (push_cast; ring1)) (20 : ℂ) * zA_pair_three

/-- The degree-20 monomial character `Ind_{C₆} μ` has exactly the values
tabulated as `B` in `ArtinDefect.lean`. -/
theorem indChar_muB_eq (i : Fin 9) : indChar muB (rep i) = toC (ArtinDefect.B i) := by
  refine mul_left_cancel₀ (show (6 : ℂ) ≠ 0 by norm_num) ?_
  rw [six_mul_indChar_muB i]
  fin_cases i <;> simp [countB, toC, ArtinDefect.B, Fin.sum_univ_succ] <;> norm_num

/-- **The icosahedral certificate, derived from the group.**  With `λ` the
faithful linear character of the cyclic subgroup `C₁₀ = ⟨aa⟩` and `μ` the
order-two linear character of `C₆ = ⟨bb⟩`, the class function
`2·Ind_{C₁₀}λ − Ind_{C₆}μ` takes exactly the values of `X = 2χ₂` tabulated in
`ArtinDefect.lean`. -/
theorem icosahedral_certificate_derived (i : Fin 9) :
    2 * indChar lamA (rep i) - indChar muB (rep i) = toC (ArtinDefect.X i) := by
  rw [two_indChar_lamA_eq i, indChar_muB_eq i, ArtinDefect.icosahedral_certificate i]
  simp [toC]
  ring

/-- Degree of the first monomial character: `[G : C₁₀] = 12`. -/
theorem indChar_lamA_one : indChar lamA 1 = 12 := by
  have h := two_indChar_lamA_eq 0
  have hrep : rep 0 = 1 := rfl
  rw [hrep] at h
  simp [toC, ArtinDefect.A] at h
  linear_combination h / 2

/-- Degree of the second monomial character: `[G : C₆] = 20`. -/
theorem indChar_muB_one : indChar muB 1 = 20 := by
  have h := indChar_muB_eq 0
  have hrep : rep 0 = 1 := rfl
  rw [hrep] at h
  simpa [toC, ArtinDefect.B] using h

/-- The certificate holds at every element of the group, not just at the nine
chosen representatives. -/
theorem certificate_all (g : G5) :
    ∃ i : Fin 9, 2 * indChar lamA g - indChar muB g = toC (ArtinDefect.X i) := by
  obtain ⟨i, x, hx⟩ := rep_covers g
  refine ⟨i, ?_⟩
  rw [← hx, indChar_conj, indChar_conj]
  exact icosahedral_certificate_derived i

end Certificate

/-! ## Section 6.  Frobenius inner products, computed on the group

The value-level inner product checks `ip_A_A`, `ip_B_B`, `ip_A_X`, `ip_B_X`,
`ip_X_X` of `ArtinDefect.lean` are re-derived here as honest sums over the
group of products of character values.  All the class functions involved are
real valued, so the Hermitian inner product `⟨f, g⟩ = |G|⁻¹ Σ_x f(x) conj g(x)`
is the sum below divided by `|G| = 120`. -/

section InnerProducts

open Real

/-- The conjugacy class of the `i`-th representative. -/
def classOf (i : Fin 9) : Finset G5 :=
  Finset.univ.filter (fun y => ∃ x : G5, x⁻¹ * rep i * x = y)

theorem mem_classOf {i : Fin 9} {y : G5} : y ∈ classOf i ↔ ∃ x : G5, x⁻¹ * rep i * x = y := by
  simp [classOf]

theorem classOf_disjoint (i j : Fin 9) (hij : i ≠ j) : Disjoint (classOf i) (classOf j) := by
  rw [Finset.disjoint_left]
  rintro y hi hj
  obtain ⟨x₁, h1⟩ := mem_classOf.1 hi
  obtain ⟨x₂, h2⟩ := mem_classOf.1 hj
  refine rep_not_conj i j hij ⟨x₁ * x₂⁻¹, ?_⟩
  have hy1 : rep i = x₁ * y * x₁⁻¹ := by rw [← h1]; group
  rw [hy1, ← h2]
  group

theorem biUnion_classOf : Finset.univ.biUnion classOf = (Finset.univ : Finset G5) := by
  ext g
  simp only [Finset.mem_biUnion, Finset.mem_univ, iff_true, true_and]
  obtain ⟨i, x, hx⟩ := rep_covers g
  exact ⟨i, mem_classOf.2 ⟨x, hx⟩⟩

theorem card_classOf (i : Fin 9) : (classOf i).card = classSize i := card_conjClass i

/-- A class function is summed over the group by weighting its values on the
nine representatives with the class sizes. -/
theorem sum_classFun (f : G5 → ℂ) (hf : ∀ g x : G5, f (x⁻¹ * g * x) = f g) :
    ∑ g : G5, f g = ∑ i : Fin 9, (classSize i : ℂ) * f (rep i) := by
  conv_lhs => rw [← biUnion_classOf]
  rw [Finset.sum_biUnion (fun i _ j _ hij => classOf_disjoint i j hij)]
  refine Finset.sum_congr rfl fun i _ => ?_
  have hval : ∀ g ∈ classOf i, f g = f (rep i) := by
    intro g hg
    obtain ⟨x, hx⟩ := mem_classOf.1 hg
    rw [← hx, hf]
  rw [Finset.sum_congr rfl hval, Finset.sum_const, nsmul_eq_mul, card_classOf]

theorem indChar_lamA_val (i : Fin 9) : indChar lamA (rep i) = toC (ArtinDefect.A i) / 2 := by
  linear_combination two_indChar_lamA_eq i / 2

theorem sqrt_five_sq : ((√5 : ℝ) : ℂ) ^ 2 = 5 := by
  norm_cast
  rw [Real.sq_sqrt]
  norm_num

/-- `⟨Ind_{C₁₀}λ, Ind_{C₁₀}λ⟩ = 3`: the degree-12 monomial character has three
irreducible constituents, each with multiplicity one. -/
theorem inner_lamA_lamA : ∑ g : G5, (indChar lamA g) ^ 2 = 3 * 120 := by
  rw [sum_classFun _ (fun g x => by rw [indChar_conj])]
  simp only [indChar_lamA_val]
  simp [Fin.sum_univ_succ, classSize, ArtinDefect.A, toC]
  linear_combination (12 : ℂ) * sqrt_five_sq

/-- `⟨Ind_{C₆}μ, Ind_{C₆}μ⟩ = 8`. -/
theorem inner_muB_muB : ∑ g : G5, (indChar muB g) ^ 2 = 8 * 120 := by
  rw [sum_classFun _ (fun g x => by rw [indChar_conj])]
  simp only [indChar_muB_eq]
  simp [Fin.sum_univ_succ, classSize, ArtinDefect.B, toC]
  norm_num

/-- `⟨Ind_{C₁₀}λ, Ind_{C₆}μ⟩ = 4`. -/
theorem inner_lamA_muB : ∑ g : G5, indChar lamA g * indChar muB g = 4 * 120 := by
  rw [sum_classFun _ (fun g x => by rw [indChar_conj, indChar_conj])]
  simp only [indChar_lamA_val, indChar_muB_eq]
  simp [Fin.sum_univ_succ, classSize, ArtinDefect.A, ArtinDefect.B, toC]
  norm_num

/-- `⟨2χ₂, 2χ₂⟩ = 4`, i.e. the icosahedral class function `χ₂` has norm one.
Together with `certificate_all` this says: the class function cut out by the
certificate is a norm-one class function of degree 2. -/
theorem inner_certificate : ∑ g : G5, (2 * indChar lamA g - indChar muB g) ^ 2 = 4 * 120 := by
  rw [sum_classFun _ (fun g x => by rw [indChar_conj, indChar_conj])]
  simp only [indChar_lamA_val, indChar_muB_eq]
  simp [Fin.sum_univ_succ, classSize, ArtinDefect.A, ArtinDefect.B, toC]
  linear_combination (48 : ℂ) * sqrt_five_sq

end InnerProducts

end ArtinDefect3
