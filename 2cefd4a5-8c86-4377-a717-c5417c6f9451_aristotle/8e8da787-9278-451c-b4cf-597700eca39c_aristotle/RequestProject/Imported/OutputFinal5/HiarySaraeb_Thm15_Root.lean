/-
================================================================================
  A CONVERSE TO GAUSS'S SEPARABILITY THEOREM
  (Hiary–Saraeb, "Functional equations characterize Dirichlet characters",
   arXiv:2607.00332v1, Theorem 1.5)

  STATEMENT.  Let N, m > 1, d = gcd(m, N).  Let f : ZMod N → K vanish exactly
  off the units, take m-th-root-of-unity values on units, with f 1 = 1.
  Let H ≤ (ZMod m)ˣ be such that every unit s mod N is congruent mod d to
  some c ∈ H.  If for every c ∈ H there is Λ_c ≠ 0 with
        𝓕(f^c)(ξ) = Λ_c · (f ξ)^{-c}     for all ξ : ZMod N          (★)
  (𝓕 = unnormalized finite Fourier transform), then f is the extension-by-zero
  of a PRIMITIVE Dirichlet character mod N.  If moreover gcd(m,N) = 1, then
  N is odd and squarefree.

  We work over an abstract field K with IsCyclotomicExtension {m·N} ℚ K, so that
  the Galois action σ_u(ζ) = ζ^u is available.  Complex conjugation of
  root-of-unity values is inversion, so f̄ is encoded as x ↦ (f x)⁻¹.

  NOTE (signature fixes, 2026-07): the original skeleton relied on Lean
  auto-bound section variables in a way that did not elaborate; every
  declaration below now carries explicit arguments.  The ambient cyclotomic
  set is `{m * N} : Set ℕ` (current Mathlib uses `Set ℕ`, not `Set ℕ+`), and
  the conductor is `DirichletCharacter.conductor` (there is no
  `MulChar.conductor`).
================================================================================
-/
import Mathlib

open Finset BigOperators Polynomial

namespace HiarySaraeb

variable {K : Type*} [Field K] [CharZero K]

/-! ### §0  Distinguished roots of unity -/

/-- The distinguished primitive N-th root of unity, ζ_N := ζ^m. -/
noncomputable def zN (m : ℕ) (ζ : K) : K := ζ ^ m

/-- The distinguished primitive m-th root of unity, ζ_m := ζ^N. -/
noncomputable def zm (N : ℕ) (ζ : K) : K := ζ ^ N

lemma zN_isPrimitiveRoot (N m : ℕ) [NeZero N] [NeZero m] {ζ : K}
    (hζ : IsPrimitiveRoot ζ (m * N)) : IsPrimitiveRoot (zN m ζ) N := by
  -- `IsPrimitiveRoot.pow` : from primitive (m·N)-th root ζ, ζ^m is primitive N-th.
  convert hζ.pow _ _ using 1;
  · exact Nat.mul_pos ( NeZero.pos m ) ( NeZero.pos N );
  · rfl

lemma zN_pow_N (N m : ℕ) {ζ : K} (hζ : IsPrimitiveRoot ζ (m * N)) :
    (zN m ζ) ^ N = 1 := by
  -- (ζ^m)^N = ζ^(m·N) = 1 from hζ.pow_eq_one.
  convert hζ.pow_eq_one using 1 ; ring!;
  rw [ zN, pow_mul' ]

/-! ### §1  Exponent-reduction micro-lemmas -/

/-- If v^k = 1 then powers of v only depend on the exponent mod k. -/
lemma pow_reduce {v : K} {k : ℕ} (hv : v ^ k = 1) (a : ℕ) :
    v ^ a = v ^ (a % k) := by
  conv_lhs => rw [← Nat.div_add_mod a k]
  rw [pow_add, pow_mul, hv, one_pow, one_mul]

/-
Cancellation of a unit exponent on m-th roots of unity:
    if c is invertible mod m and v^c = w^c on μ_m, then v = w.  (paper (38)⟹(39))
-/
lemma pow_val_unit_inj (m : ℕ) (hm1 : 1 < m) {v w : K}
    (hv : v ^ m = 1) (hw : w ^ m = 1) (c : (ZMod m)ˣ)
    (h : v ^ ((c : ZMod m)).val = w ^ ((c : ZMod m)).val) : v = w := by
  -- `ZMod.val_coe_unit_coprime` gives a modular inverse b of c.val; then
  -- (v^{c.val})^b = v^{c.val·b} = v since c.val·b ≡ 1 [MOD m] and v^m = 1.
  -- Since $c$ is a unit in $(\mathbb{Z}/m\mathbb{Z})^\times$, there exists some $b$ such that $c \cdot b \equiv 1 \pmod{m}$.
  obtain ⟨b, hb⟩ : ∃ b : ℕ, (c.val.val * b) % m = 1 := by
    have h_unit : ∃ b : ℕ, (c.val.val * b) ≡ 1 [MOD m] := by
      use c⁻¹.val.val;
      simp +decide [ ← ZMod.natCast_eq_natCast_iff ];
      cases m <;> simp_all +decide [ ZMod.natCast_eq_zero_iff ];
    exact ⟨ h_unit.choose, h_unit.choose_spec.symm ▸ Nat.mod_eq_of_lt hm1 ⟩;
  -- By raising both sides of $v^{c.val} = w^{c.val}$ to the power of $b$, we get $v^{c.val \cdot b} = w^{c.val \cdot b}$.
  have h_exp : v ^ (c.val.val * b) = w ^ (c.val.val * b) := by
    rw [ pow_mul, pow_mul, h ];
  rw [ ← Nat.mod_add_div ( ( c : ZMod m ).val * b ) m, hb ] at h_exp; simp_all +decide [ pow_add, pow_mul ] ;

/-! ### §2  The additive character and the finite Fourier transform -/

/-- e(a) = ζ_N^{a.val} : the standard additive character of ZMod N in K. -/
noncomputable def e (N m : ℕ) (ζ : K) (a : ZMod N) : K := (zN m ζ) ^ a.val

lemma e_zero (N m : ℕ) [NeZero N] (ζ : K) : e N m ζ 0 = 1 := by
  rw [e, ZMod.val_zero, pow_zero]

lemma e_add (N m : ℕ) [NeZero N] {ζ : K} (hζ : IsPrimitiveRoot ζ (m * N)) (a b : ZMod N) :
    e N m ζ (a + b) = e N m ζ a * e N m ζ b := by
  -- `ZMod.val_add`, `pow_reduce (zN_pow_N …)`, `pow_add`.
  unfold e;
  rw [ ← pow_add, ZMod.val_add ];
  rw [ ← Nat.mod_add_div ( a.val + b.val ) N, pow_add, pow_mul ];
  simp +decide [ zN_pow_N N m hζ ]

/-- Unnormalized finite Fourier transform on ZMod N with values in K:
    (𝓕 g)(ξ) = Σ_x g(x) · e(−xξ).   (Paper eq. (28), up to the 1/√N.) -/
noncomputable def Fhat (N m : ℕ) [NeZero N] (ζ : K) (g : ZMod N → K) (ξ : ZMod N) : K :=
  ∑ x : ZMod N, g x * e N m ζ (-(x * ξ))

/-- e(a) is an N-th root of unity. -/
lemma e_powN (N m : ℕ) [NeZero N] {ζ : K} (hζ : IsPrimitiveRoot ζ (m * N)) (a : ZMod N) :
    e N m ζ a ^ N = 1 := by
  rw [e, ← pow_mul, mul_comm, pow_mul, zN_pow_N N m hζ, one_pow]

/-
Raising e(a) to a natural power k equals e evaluated at k·a.
-/
lemma e_pow (N m : ℕ) [NeZero N] {ζ : K} (hζ : IsPrimitiveRoot ζ (m * N))
    (a : ZMod N) (k : ℕ) : e N m ζ a ^ k = e N m ζ ((k : ZMod N) * a) := by
  unfold e;
  rw [ ← pow_mul, mul_comm, pow_reduce ];
  any_goals exact N;
  · simp +decide [ ZMod.val_mul ];
  · exact zN_pow_N N m hζ

/-! ### §3  The function f: values on units are nonzero -/

/-- Values of f on units are nonzero (they are roots of unity). -/
lemma f_ne_zero {N m : ℕ} [NeZero m] {f : ZMod N → K}
    (hval : ∀ x : ZMod N, IsUnit x → (f x) ^ m = 1) {x : ZMod N} (hx : IsUnit x) :
    f x ≠ 0 := by
  intro h
  have := hval x hx
  rw [h, zero_pow (NeZero.ne m)] at this
  exact zero_ne_one this

/-! ### §4  The Galois action  (paper eqs. (31)–(34)) -/

/-- The automorphism σ_u of K with σ_u(ζ) = ζ^{u}, for u ∈ (ZMod (mN))ˣ. -/
noncomputable def σ (N m : ℕ) [NeZero N] [NeZero m]
    [IsCyclotomicExtension {m * N} ℚ K] (u : (ZMod (m * N))ˣ) : K ≃ₐ[ℚ] K :=
  (IsCyclotomicExtension.autEquivPow K
    (cyclotomic.irreducible_rat (n := m * N) (Nat.pos_of_ne_zero (NeZero.ne _)))).symm u

/-
σ_u acts on EVERY (mN)-th root of unity as the u-th power map.
-/
lemma σ_root (N m : ℕ) [NeZero N] [NeZero m]
    [IsCyclotomicExtension {m * N} ℚ K]
    (u : (ZMod (m * N))ˣ) {w : K} (hw : w ^ (m * N) = 1) :
    σ N m u w = w ^ ((u : ZMod (m * N))).val := by
  -- Via `modularCyclotomicCharacter`: the automorphism σ u acts on every
  -- (m*N)-th root of unity as the u.val power map.
  by_contra h_contra;
  -- Let $g$ be the automorphism $\sigma_u$.
  set g : K ≃ₐ[ℚ] K := σ N m u;
  have h_modular : ∀ t : Kˣ, t ∈ rootsOfUnity (m * N) K → g t = t ^ ((u : ZMod (m * N)).val) := by
    intro t ht
    have h_modular : modularCyclotomicCharacter K (IsCyclotomicExtension.zeta_spec (m * N) ℚ K).card_rootsOfUnity g = u := by
      have h_modular : (IsCyclotomicExtension.autEquivPow K (cyclotomic.irreducible_rat (n := m * N) (Nat.pos_of_ne_zero (NeZero.ne _)))).symm u = g := by
        rfl;
      convert congr_arg ( fun x : K ≃ₐ[ℚ] K => ( IsCyclotomicExtension.autEquivPow K ( cyclotomic.irreducible_rat ( n := m * N ) ( Nat.pos_of_ne_zero ( NeZero.ne _ ) ) ) ) x ) h_modular using 1;
      · simp +decide [ IsCyclotomicExtension.autEquivPow_apply ];
        grind +suggestions;
      · rw [ ← h_modular, MulEquiv.apply_symm_apply ];
    have := modularCyclotomicCharacter.spec K ( IsCyclotomicExtension.zeta_spec ( m * N ) ℚ K ).card_rootsOfUnity ( g : K ≃+* K ) ( t := t ) ht; aesop;
  by_cases hw' : w = 0 <;> simp_all +decide [ rootsOfUnity ];
  · simp_all +decide [ NeZero.ne ];
  · exact h_contra ( by simpa [ Units.ext_iff ] using h_modular ( Units.mk0 w hw' ) ( by simpa [ Units.ext_iff ] using hw ) )

lemma σ_zeta (N m : ℕ) [NeZero N] [NeZero m]
    [IsCyclotomicExtension {m * N} ℚ K] {ζ : K} (hζ : IsPrimitiveRoot ζ (m * N))
    (u : (ZMod (m * N))ˣ) :
    σ N m u ζ = ζ ^ ((u : ZMod (m * N))).val :=
  σ_root N m u hζ.pow_eq_one

/-! ### §5  The CRT unit lift  (paper eqs. (31)–(33)) -/

/-
Given a unit s mod N, produce c ∈ H and a unit u mod mN reducing to s
    mod N and to c mod m.
-/
lemma exists_lift (N m : ℕ) [NeZero N] [NeZero m] (H : Subgroup (ZMod m)ˣ)
    (hH : ∀ s : (ZMod N)ˣ, ∃ c ∈ H,
      ((s : ZMod N)).val ≡ ((c : ZMod m)).val [MOD Nat.gcd m N])
    (s : (ZMod N)ˣ) :
    ∃ (u : (ZMod (m * N))ˣ) (c : (ZMod m)ˣ), c ∈ H ∧
      ((u : ZMod (m * N))).val ≡ ((s : ZMod N)).val [MOD N] ∧
      ((u : ZMod (m * N))).val ≡ ((c : ZMod m)).val [MOD m] := by
  -- `Nat.chineseRemainder'` (compatible moduli), `ZMod.val_coe_unit_coprime`,
  -- `Nat.Coprime.mul_right`, `ZMod.unitOfCoprime`.
  obtain ⟨c, hc⟩ := hH s
  obtain ⟨k, hk⟩ := Nat.chineseRemainder' ( show (s.val.val : ℕ) ≡ c.val.val [MOD Nat.gcd N m] from by
                                              simpa only [ Nat.gcd_comm ] using hc.2 );
  -- Since $k$ is coprime to both $N$ and $m$, it is coprime to $mN$.
  have hk_coprime : Nat.Coprime k (m * N) := by
    rw [ Nat.coprime_mul_iff_right ];
    exact ⟨ by simpa using hk.2.gcd_eq.trans ( ZMod.val_coe_unit_coprime c ), by simpa using hk.1.gcd_eq.trans ( ZMod.val_coe_unit_coprime s ) ⟩;
  -- Let $u := ZMod.unitOfCoprime k (that coprimality) : (ZMod (m*N))ˣ$.
  obtain ⟨u, hu⟩ : ∃ u : (ZMod (m * N))ˣ, u.val.val = k % (m * N) := by
    have hk_unit : IsUnit (k : ZMod (m * N)) := by
      exact (ZMod.isUnit_iff_coprime k (m * N)).mpr hk_coprime;
    obtain ⟨ u, hu ⟩ := hk_unit;
    use u; simp_all +decide [ ZMod.val_natCast ] ;
  refine' ⟨ u, c, hc.1, _, _ ⟩ <;> simp_all +decide [ Nat.ModEq ]

/-! ### §6  The key computation  (paper eqs. (34)–(35)):
     σ_u intertwines 𝓕 f with 𝓕(f^c) at the dilated frequency. -/

lemma σ_Fhat (N m : ℕ) [NeZero N] [NeZero m]
    [IsCyclotomicExtension {m * N} ℚ K] {ζ : K} (hζ : IsPrimitiveRoot ζ (m * N))
    (f : ZMod N → K)
    (hval : ∀ x : ZMod N, IsUnit x → (f x) ^ m = 1)
    (hzero : ∀ x : ZMod N, ¬ IsUnit x → f x = 0)
    (u : (ZMod (m * N))ˣ) (c : (ZMod m)ˣ) (s : (ZMod N)ˣ)
    (hum : ((u : ZMod (m * N))).val ≡ ((c : ZMod m)).val [MOD m])
    (huN : ((u : ZMod (m * N))).val ≡ ((s : ZMod N)).val [MOD N])
    (hm1 : 1 < m) (r : ZMod N) :
    σ N m u (Fhat N m ζ f r)
      = Fhat N m ζ (fun x => f x ^ ((c : ZMod m)).val) ((s : ZMod N) * r) := by
  -- Push σ through the sum and products; σ(f x) = (f x)^{c.val}, σ(e(−xr)) =
  -- e(−x·(s·r)); non-unit terms vanish by `hzero`.  No sum reindexing needed.
  unfold Fhat; simp +decide [ *, Finset.mul_sum ] ;
  -- Apply the properties of σ to each term in the sum.
  have h_term : ∀ x : ZMod N, (σ N m u) (f x) = f x ^ (c : ZMod m).val ∧ (σ N m u) (e N m ζ (-(x * r))) = e N m ζ (-(x * (s * r))) := by
    intro x
    constructor;
    · by_cases hx : IsUnit x;
      · convert σ_root N m u _ using 1;
        · rw [ ← Nat.mod_add_div ( u.val.val ) m, ← Nat.mod_add_div ( c.val.val ) m, hum ];
          simp +decide [ pow_add, pow_mul, hval x hx ];
        · rw [ pow_mul, hval x hx, one_pow ];
      · simp +decide [ hzero x hx ];
        rw [ zero_pow ];
        intro h; have := c.isUnit; simp_all +decide [ ZMod.val_eq_zero ] ;
        rcases m with ( _ | _ | m ) <;> cases this ; contradiction;
    · rw [ σ_root ];
      · convert e_pow N m hζ ( - ( x * r ) ) ( u.val.val ) using 1;
        simp +decide [ ← ZMod.natCast_eq_natCast_iff ] at *;
        rw [ huN ] ; ring;
      · rw [ show e N m ζ ( - ( x * r ) ) ^ ( m * N ) = ( e N m ζ ( - ( x * r ) ) ^ N ) ^ m by ring, e_powN ] ; simp +decide [ hζ.pow_eq_one ];
        exact hζ;
  exact Finset.sum_congr rfl fun x _ => by rw [ h_term x |>.1, h_term x |>.2 ] ;

/-! ### §7  Multiplicativity  (paper eqs. (36)–(39)) -/

theorem f_multiplicative (N m : ℕ) [NeZero N] [NeZero m]
    [IsCyclotomicExtension {m * N} ℚ K] {ζ : K} (hζ : IsPrimitiveRoot ζ (m * N))
    (f : ZMod N → K)
    (hval : ∀ x : ZMod N, IsUnit x → (f x) ^ m = 1)
    (hzero : ∀ x : ZMod N, ¬ IsUnit x → f x = 0)
    (hone : f 1 = 1)
    (H : Subgroup (ZMod m)ˣ)
    (hH : ∀ s : (ZMod N)ˣ, ∃ c ∈ H,
      ((s : ZMod N)).val ≡ ((c : ZMod m)).val [MOD Nat.gcd m N])
    (hbat : ∀ c ∈ H, ∃ Λ : K, Λ ≠ 0 ∧
      ∀ ξ : ZMod N, Fhat N m ζ (fun x => f x ^ ((c : ZMod m)).val) ξ
        = Λ * ((f ξ) ^ ((c : ZMod m)).val)⁻¹)
    (hm1 : 1 < m) (s r : (ZMod N)ˣ) :
    f ((s : ZMod N) * (r : ZMod N)) = f s * f r := by
  -- Apply σ_u to the c=1 identity at ξ = r and at ξ = 1, compare with the c
  -- identity at ξ = s·r, cancel Λc, and remove the exponent with
  -- `pow_val_unit_inj`.
  obtain ⟨ u, c, hcH, huN, hum ⟩ := exists_lift N m H hH s;
  obtain ⟨ Λ₁, hΛ₁ne, hid₁ ⟩ := hbat 1 H.one_mem
  obtain ⟨ Λc, hΛcne, hidc ⟩ := hbat c hcH
  have hσΛ₁ : σ N m u Λ₁ = Λc * (f s ^ (c : ZMod m).val)⁻¹ := by
    have hσΛ₁ : σ N m u (Fhat N m ζ f 1) = Fhat N m ζ (fun x => f x ^ (c : ZMod m).val) (s * 1) := by
      convert σ_Fhat N m hζ f hval hzero u c s hum huN hm1 1 using 1;
    simp_all +decide [ ZMod.val_one ];
  have hσFr : σ N m u (Fhat N m ζ f r) = Λc * (f (s * r) ^ (c : ZMod m).val)⁻¹ := by
    rw [ ← hidc, σ_Fhat N m hζ f hval hzero u c s hum huN hm1 r ];
  have hσFr' : σ N m u (Fhat N m ζ f r) = σ N m u Λ₁ * (f r ^ (c : ZMod m).val)⁻¹ := by
    convert congr_arg ( σ N m u ) ( hid₁ r ) using 1;
    · haveI := Fact.mk hm1; simp +decide [ ZMod.val_one ] ;
    · simp +decide [ σ_root N m u ( show f r ^ ( m * N ) = 1 from by rw [ pow_mul, hval r ( by simp ) ] ; norm_num ) ];
      rw [ ← Nat.mod_add_div ( u.val.val ) m, hum ] ; simp +decide [ pow_add, pow_mul, hval ] ;
      rw [ ← Nat.mod_add_div ( c.val.val ) m ] ; simp +decide [ pow_add, pow_mul, hval ] ;
      rcases m with ( _ | _ | m ) <;> simp_all +decide [ ZMod.val ];
  simp_all +decide [ mul_assoc, mul_comm, mul_left_comm ];
  have h_eq : (f s * f r) ^ (c : ZMod m).val = (f (s * r)) ^ (c : ZMod m).val := by
    rw [ mul_pow, ← mul_inv, inv_eq_iff_eq_inv ] at * ; aesop;
  have := pow_val_unit_inj m hm1 ( show ( f ( s * r ) ) ^ m = 1 from hval _ <| by simp +decide [ IsUnit.mul_iff ] ) ( show ( f s * f r ) ^ m = 1 from by rw [ mul_pow, hval _ <| by simp +decide [ IsUnit.mul_iff ], hval _ <| by simp +decide [ IsUnit.mul_iff ], one_mul ] ) c h_eq.symm; simp_all +decide [ mul_comm ] ;

/-! ### §8  Packaging: f is a Dirichlet character -/

/-- The multiplicative character underlying f. -/
noncomputable def chi (N : ℕ) (f : ZMod N → K)
    (hmul : ∀ s r : (ZMod N)ˣ,
      f ((s : ZMod N) * (r : ZMod N)) = f (s : ZMod N) * f (r : ZMod N))
    (hne : ∀ s : (ZMod N)ˣ, f (s : ZMod N) ≠ 0)
    (hone : f 1 = 1) : MulChar (ZMod N) K :=
  MulChar.ofUnitHom
    { toFun := fun s => Units.mk0 (f (s : ZMod N)) (hne s),
      map_one' := by ext; simp [hone],
      map_mul' := by intro s r; ext; simp [Units.val_mk0, hmul s r] }

lemma chi_apply_eq (N : ℕ) (f : ZMod N → K)
    (hmul : ∀ s r : (ZMod N)ˣ,
      f ((s : ZMod N) * (r : ZMod N)) = f (s : ZMod N) * f (r : ZMod N))
    (hne : ∀ s : (ZMod N)ˣ, f (s : ZMod N) ≠ 0)
    (hone : f 1 = 1)
    (hzero : ∀ x : ZMod N, ¬ IsUnit x → f x = 0) (x : ZMod N) :
    chi N f hmul hne hone x = f x := by
  by_cases hx : IsUnit x
  · obtain ⟨s, rfl⟩ := hx
    rw [chi, MulChar.ofUnitHom_coe]
    simp [Units.val_mk0]
  · rw [MulChar.map_nonunit _ hx, hzero x hx]

/-! ### §9  Separability of ALL Gauss sums, and primitivity (paper eq. (40)) -/

/-
Separability: 𝓕 f ξ = 𝓕 f 1 · (f ξ)⁻¹ with 𝓕 f 1 ≠ 0.
    Immediate from the c = 1 identity of the battery.
-/
theorem separable (N m : ℕ) [NeZero N] [NeZero m] {ζ : K}
    (f : ZMod N → K) (hone : f 1 = 1)
    (H : Subgroup (ZMod m)ˣ)
    (hbat : ∀ c ∈ H, ∃ Λ : K, Λ ≠ 0 ∧
      ∀ ξ : ZMod N, Fhat N m ζ (fun x => f x ^ ((c : ZMod m)).val) ξ
        = Λ * ((f ξ) ^ ((c : ZMod m)).val)⁻¹)
    (hm1 : 1 < m) :
    (Fhat N m ζ f 1 ≠ 0) ∧ ∀ ξ, Fhat N m ζ f ξ = Fhat N m ζ f 1 * (f ξ)⁻¹ := by
  -- Exponent normalization: ((1 : (ZMod m)ˣ) : ZMod m).val = 1 for 1 < m; then
  -- evaluate the c=1 identity at ξ = 1 with hone.
  obtain ⟨ Λ, hΛ, h ⟩ := hbat 1 H.one_mem; simp_all +decide [ ZMod.val_one ] ;

/-! ### §9.5  Fiber-sum machinery for the primitivity proof (Round 2) -/

/-
`ζ_N^{N/d}` is a primitive `d`-th root of unity, for `d ∣ N`.
-/
lemma zN_pow_Ndivd_isPrimitiveRoot (N m : ℕ) [NeZero N] [NeZero m] {ζ : K}
    (hζ : IsPrimitiveRoot ζ (m * N)) {d : ℕ} (hd : d ∣ N) (hd0 : 0 < d) :
    IsPrimitiveRoot ((zN m ζ) ^ (N / d)) d := by
  convert ( zN_isPrimitiveRoot N m hζ ).pow ( NeZero.pos N ) ( Nat.div_mul_cancel hd |> Eq.symm ) using 1

/-
The additive character `e` at frequency `N/d` descends: `e(a·(N/d)) = ζ_d^{(a mod d)}`
    where `ζ_d = ζ_N^{N/d}`.  Holds for all `a` (units and non-units alike).
-/
lemma e_mul_Ndivd (N m : ℕ) [NeZero N] {ζ : K} (hζ : IsPrimitiveRoot ζ (m * N))
    {d : ℕ} (hd : d ∣ N) (a : ZMod N) :
    e N m ζ (a * ((N / d : ℕ) : ZMod N))
      = ((zN m ζ) ^ (N / d)) ^ ((ZMod.castHom hd (ZMod d) a).val) := by
  -- Using the properties of roots of unity, we can simplify the exponents.
  have h_exp : (zN m ζ) ^ (a.val * (N / d)) = (zN m ζ) ^ ((a.val % d) * (N / d)) := by
    rw [ ← Nat.mod_add_div ( a.val ) d, add_mul ] ; simp +decide [ pow_add, pow_mul ];
    -- Since $zN m ζ$ is a primitive $N$-th root of unity, we have $(zN m ζ ^ d) ^ (N / d) = 1$.
    have h_root : (zN m ζ ^ d) ^ (N / d) = 1 := by
      rw [ ← pow_mul, Nat.mul_div_cancel' hd, show zN m ζ ^ N = 1 from zN_pow_N N m hζ ];
    simp_all +decide [ pow_right_comm ];
  convert h_exp using 1;
  · unfold e; simp +decide [ ZMod.val_mul ] ;
    rw [ ← Nat.mod_add_div ( a.val * ( N / d ) ) N, pow_add, pow_mul ] ; simp +decide [ zN_pow_N N m hζ ];
  · rw [ ← pow_mul, mul_comm ];
    congr! 2;
    convert ZMod.val_natCast _ _;
    cases N <;> aesop

/-
Sum of `G ∘ unitsMap` over `(ZMod N)ˣ` is a positive multiple of the sum of `G`
    over `(ZMod d)ˣ` (the fibers of the surjective reduction all have equal size).
-/
lemma sum_units_comp_unitsMap {N d : ℕ} [NeZero N] [NeZero d] (hd : d ∣ N)
    (G : (ZMod d)ˣ → K) :
    ∃ c : ℕ, 0 < c ∧
      (∑ x : (ZMod N)ˣ, G (ZMod.unitsMap hd x)) = c • (∑ y : (ZMod d)ˣ, G y) := by
  obtain ⟨c, hc⟩ : ∃ c : ℕ, 0 < c ∧ ∀ b : (ZMod d)ˣ, (Finset.univ.filter (fun x : (ZMod N)ˣ => (ZMod.unitsMap hd) x = b)).card = c := by
    refine' ⟨ _, _, _ ⟩;
    exact ( Finset.univ.filter fun x : ( ZMod N ) ˣ => ( ZMod.unitsMap hd ) x = 1 ).card;
    · exact Finset.card_pos.mpr ⟨ 1, by simp +decide ⟩;
    · intro b
      have h_fiber : Finset.filter (fun x : (ZMod N)ˣ => (ZMod.unitsMap hd) x = b) Finset.univ = Finset.image (fun x : (ZMod N)ˣ => x * (Classical.choose (ZMod.unitsMap_surjective hd b))) (Finset.filter (fun x : (ZMod N)ˣ => (ZMod.unitsMap hd) x = 1) Finset.univ) := by
        ext x; simp +decide [ Classical.choose_spec ( ZMod.unitsMap_surjective hd b ) ] ;
        rw [ mul_inv_eq_one ];
      rw [ h_fiber, Finset.card_image_of_injective _ fun x y hxy => mul_right_cancel hxy ];
  have h_sum : ∑ x : (ZMod N)ˣ, G ((ZMod.unitsMap hd) x) = ∑ b : (ZMod d)ˣ, ∑ x ∈ Finset.filter (fun x : (ZMod N)ˣ => (ZMod.unitsMap hd) x = b) Finset.univ, G b := by
    simp +decide only [sum_filter];
    rw [ Finset.sum_comm, Finset.sum_congr rfl ] ; aesop;
  simp_all +decide [ Finset.sum_ite ];
  exact ⟨ c, hc.1, by rw [ Finset.mul_sum _ _ _ ] ⟩

/-
Lemma A: the Gauss sum `𝓕 χ` at frequency `-(N/d)` collapses to the units-sum of
    the reduced character `χ₀` against `ζ_d = ζ_N^{N/d}`.
-/
lemma Fhat_neg_Ndivd_eq (N m : ℕ) [NeZero N] [NeZero m] {ζ : K}
    (hζ : IsPrimitiveRoot ζ (m * N)) (χ : MulChar (ZMod N) K)
    {d : ℕ} [NeZero d] (hd : d ∣ N) (χ₀ : MulChar (ZMod d) K)
    (hfac : ∀ x : (ZMod N)ˣ, χ (x : ZMod N)
      = χ₀ ((ZMod.unitsMap hd x : (ZMod d)ˣ) : ZMod d)) :
    Fhat N m ζ (fun x => χ x) (-(((N / d : ℕ)) : ZMod N))
      = ∑ x : (ZMod N)ˣ,
          χ₀ ((ZMod.unitsMap hd x : (ZMod d)ˣ) : ZMod d)
            * ((zN m ζ) ^ (N / d)) ^ (((ZMod.unitsMap hd x : (ZMod d)ˣ)) : ZMod d).val := by
  convert Finset.sum_congr rfl fun x _ => ?_ using 1;
  rotate_left;
  use fun x => χ x * ( zN m ζ ^ ( N / d ) ) ^ ( ( ZMod.castHom hd ( ZMod d ) x ).val );
  · simp +decide [ e_mul_Ndivd N m hζ hd ];
  · rw [ ← Finset.sum_subset ( Finset.subset_univ ( Finset.image ( fun x : ( ZMod N ) ˣ => ( x : ZMod N ) ) Finset.univ ) ) ];
    · rw [ Finset.sum_image ];
      · congr! 2;
        rw [ hfac ];
      · exact fun x _ y _ hxy => Units.ext hxy;
    · intro x _ hx; rw [ show χ x = 0 from _ ] ; simp +decide ;
      exact χ.map_nonunit ( by contrapose! hx; aesop )

/-
A sum over `ZMod d` of a function vanishing off the units equals the sum over units.
-/
lemma sum_over_units_eq {d : ℕ} [NeZero d] (F : ZMod d → K)
    (hF : ∀ x : ZMod d, ¬ IsUnit x → F x = 0) :
    (∑ x : ZMod d, F x) = ∑ y : (ZMod d)ˣ, F (y : ZMod d) := by
  rw [ ← Finset.sum_subset ( Finset.subset_univ ( Finset.image ( fun u : ( ZMod d ) ˣ => ( u : ZMod d ) ) Finset.univ ) ) ];
  · rw [ Finset.sum_image ];
    exact fun x _ y _ hxy => Units.ext hxy;
  · simp +contextual [ hF ];
    exact fun x hx => hF x fun h => hx h.unit rfl

/-
The units-sum of `χ₀` against `ζd` is exactly the Mathlib Gauss sum against the
    additive character `AddChar.zmodChar d hpow`.
-/
lemma units_sum_eq_gaussSum {d : ℕ} [NeZero d] {ζd : K} (hpow : ζd ^ d = 1)
    (χ₀ : MulChar (ZMod d) K) :
    (∑ y : (ZMod d)ˣ, χ₀ (y : ZMod d) * ζd ^ ((y : ZMod d)).val)
      = gaussSum χ₀ (AddChar.zmodChar d hpow) := by
  convert ( sum_over_units_eq _ _ ).symm using 1;
  · simp +decide [ AddChar.zmodChar_apply ];
  · infer_instance;
  · exact fun x hx => by rw [ MulChar.map_nonunit χ₀ hx, MulZeroClass.zero_mul ] ;

/-
Finite Fourier inversion for Gauss sums: summing the shifted Gauss sums against
    the dual additive character recovers `card • χ₀`.  Works over any `IsDomain`
    (no field / prime-modulus assumption).
-/
lemma gaussSum_inversion {d : ℕ} [NeZero d] (χ₀ : MulChar (ZMod d) K)
    {ψ : AddChar (ZMod d) K} (hψ : ψ.IsPrimitive) (x : ZMod d) :
    (∑ a : ZMod d, gaussSum χ₀ (ψ.mulShift a) * ψ (-(a * x)))
      = (Fintype.card (ZMod d) : K) * χ₀ x := by
  -- Apply the orthogonality relation of the additive character `ψ`.
  have h_ortho : ∀ x : ZMod d, (∑ a : ZMod d, ψ (a * x)) = (if x = 0 then (Fintype.card (ZMod d) : K) else 0) := by
    intro x; split_ifs with hx <;> simp_all +decide [ AddChar.sum_mulShift ] ;
  -- Expand the Gauss sum and the multiplication shift using their definitions.
  have h_expand : ∀ a : ZMod d, gaussSum χ₀ (ψ.mulShift a) * ψ (-(a * x)) = ∑ y : ZMod d, χ₀ y * ψ (a * (y - x)) := by
    simp +decide [ gaussSum, mul_sub, AddChar.mulShift_apply ];
    simp +decide [ Finset.sum_mul, mul_assoc, sub_eq_add_neg, AddChar.map_add_eq_mul ];
  rw [ Finset.sum_congr rfl fun a _ => h_expand a, Finset.sum_comm ];
  simp +decide [ ← Finset.mul_sum _ _ _, ← Finset.sum_mul, h_ortho ];
  simp +decide [ sub_eq_zero, mul_comm ]

/-- Lemma B2: the level-`d` Gauss sum of a primitive character against a primitive
    `d`-th root of unity is nonzero.  Proof via Fourier inversion: if the Gauss sum
    vanished, primitivity would force every shifted Gauss sum to vanish, hence
    (by inversion) `card · χ₀ 1 = 0`, contradicting `χ₀ 1 = 1` and `card ≠ 0`. -/
lemma sum_units_primitive_ne_zero {d : ℕ} [NeZero d] {ζd : K}
    (hζd : IsPrimitiveRoot ζd d) (χ₀ : MulChar (ZMod d) K)
    (hprim : DirichletCharacter.conductor χ₀ = d) :
    (∑ y : (ZMod d)ˣ, χ₀ (y : ZMod d) * ζd ^ ((y : ZMod d)).val) ≠ 0 := by
  rw [units_sum_eq_gaussSum hζd.pow_eq_one χ₀]
  have hIsPrim : DirichletCharacter.IsPrimitive χ₀ := hprim
  have hψprim : (AddChar.zmodChar d hζd.pow_eq_one).IsPrimitive :=
    AddChar.zmodChar_primitive_of_primitive_root d hζd
  intro hS
  have hall : ∀ a : ZMod d,
      gaussSum χ₀ ((AddChar.zmodChar d hζd.pow_eq_one).mulShift a) = 0 := by
    intro a
    rw [gaussSum_mulShift_of_isPrimitive _ hIsPrim a, hS, mul_zero]
  have key := gaussSum_inversion χ₀ hψprim (1 : ZMod d)
  simp only [hall, zero_mul, Finset.sum_const_zero, map_one, mul_one] at key
  rw [ZMod.card] at key
  exact (Nat.cast_ne_zero.mpr (NeZero.ne d)) key.symm

/-- PRIMITIVITY (converse of Apostol's separability theorem, Apostol Thm 8.19/8.20).
    If every Gauss sum of χ is separable and τ(χ) = 𝓕 χ 1 ≠ 0, then χ is
    primitive: its conductor is N.

    PROOF (Round 2, fully algebraic; works over the abstract field K, no
    absolute values or Möbius casework).  Let `d = conductor χ`; as `d ∣ N`
    either `d = N` (done) or `d < N`.  In the latter case, factor `χ` through
    the primitive character `χ₀ = χ.primitiveCharacter` mod `d`
    (`changeLevel_primitiveCharacter`).  Evaluate the separability identity at
    the single non-unit frequency `ξ = -(N/d)`:
    * LHS `𝓕 χ (-(N/d))` collapses along the fibres of the surjective unit
      reduction `(ZMod N)ˣ ↠ (ZMod d)ˣ` to a positive integer multiple of the
      level-`d` Gauss sum `∑ y, χ₀ y · ζ_d^{y}` (`Fhat_neg_Ndivd_eq`,
      `sum_units_comp_unitsMap`), which is nonzero: if it vanished, primitivity
      of `χ₀` would force *every* shifted Gauss sum to vanish, and finite
      Fourier inversion (`gaussSum_inversion`) would give `χ₀ 1 = 0`, absurd
      (`sum_units_primitive_ne_zero`).  Note this uses only `IsDomain K`, so it
      is valid for composite `d` where the field-based `|τ|²=d` is unavailable.
    * RHS `τ(χ) · (χ (-(N/d)))⁻¹ = τ(χ) · 0⁻¹ = 0`, because `-(N/d)` is a
      non-unit (`gcd(N/d, N) = N/d > 1`).
    Contradiction.  (The hypothesis `hsep0` is not needed on this route.) -/
theorem separable_implies_primitive (N m : ℕ) [NeZero N] [NeZero m] {ζ : K}
    (hζ : IsPrimitiveRoot ζ (m * N)) (χ : MulChar (ZMod N) K)
    (hsep0 : Fhat N m ζ (fun x => χ x) 1 ≠ 0)
    (hsep : ∀ ξ, Fhat N m ζ (fun x => χ x) ξ
      = Fhat N m ζ (fun x => χ x) 1 * (χ ξ)⁻¹) :
    DirichletCharacter.conductor χ = N := by
  -- Let `d = conductor χ`.  Either `d = N` (done) or `d < N` (contradiction).
  have hdvd : DirichletCharacter.conductor χ ∣ N := DirichletCharacter.conductor_dvd_level χ
  rcases eq_or_lt_of_le (Nat.le_of_dvd (NeZero.pos N) hdvd) with h | hlt
  · exact h
  exfalso
  have hd0 : 0 < DirichletCharacter.conductor χ := Nat.pos_of_dvd_of_pos hdvd (NeZero.pos N)
  haveI : NeZero (DirichletCharacter.conductor χ) := ⟨hd0.ne'⟩
  -- The primitive character `χ₀` mod `d = conductor χ` through which `χ` factors.
  set χ₀ := DirichletCharacter.primitiveCharacter χ with hχ₀def
  have hfacL : χ = DirichletCharacter.changeLevel hdvd χ₀ :=
    (DirichletCharacter.changeLevel_primitiveCharacter χ).symm
  have hprim : DirichletCharacter.conductor χ₀ = DirichletCharacter.conductor χ :=
    (DirichletCharacter.isPrimitive_def _).1 (DirichletCharacter.primitiveCharacter_isPrimitive χ)
  -- Per-unit factorization.
  have hfac : ∀ x : (ZMod N)ˣ, χ (x : ZMod N)
      = χ₀
          ((ZMod.unitsMap hdvd x : (ZMod (DirichletCharacter.conductor χ))ˣ)
            : ZMod (DirichletCharacter.conductor χ)) := by
    intro x
    have hcast : ((ZMod.unitsMap hdvd x : (ZMod (DirichletCharacter.conductor χ))ˣ)
        : ZMod (DirichletCharacter.conductor χ)) = (↑x : ZMod N).cast := by
      rw [ZMod.unitsMap_def, Units.coe_map]; rfl
    rw [hcast]
    have h1 := DirichletCharacter.changeLevel_eq_cast_of_dvd χ₀ hdvd x
    rw [← hfacL] at h1
    exact h1
  -- Nonvanishing of the Gauss sum at the non-unit frequency `-(N/d)`.
  have hA := Fhat_neg_Ndivd_eq N m hζ χ hdvd χ₀ hfac
  obtain ⟨c, hc0, hcsum⟩ := sum_units_comp_unitsMap hdvd
    (fun y : (ZMod (DirichletCharacter.conductor χ))ˣ =>
      χ₀ (y : ZMod (DirichletCharacter.conductor χ))
        * ((zN m ζ) ^ (N / DirichletCharacter.conductor χ)) ^ ((y : ZMod (DirichletCharacter.conductor χ))).val)
  have hζd : IsPrimitiveRoot ((zN m ζ) ^ (N / DirichletCharacter.conductor χ))
      (DirichletCharacter.conductor χ) :=
    zN_pow_Ndivd_isPrimitiveRoot N m hζ hdvd hd0
  have hS : (∑ y : (ZMod (DirichletCharacter.conductor χ))ˣ,
      χ₀ (y : ZMod (DirichletCharacter.conductor χ))
        * ((zN m ζ) ^ (N / DirichletCharacter.conductor χ)) ^ ((y : ZMod (DirichletCharacter.conductor χ))).val) ≠ 0 :=
    sum_units_primitive_ne_zero hζd χ₀ hprim
  have hFeq : Fhat N m ζ (fun x => χ x)
      (-(((N / DirichletCharacter.conductor χ : ℕ)) : ZMod N))
      = c • (∑ y : (ZMod (DirichletCharacter.conductor χ))ˣ,
          χ₀ (y : ZMod (DirichletCharacter.conductor χ))
            * ((zN m ζ) ^ (N / DirichletCharacter.conductor χ)) ^ ((y : ZMod (DirichletCharacter.conductor χ))).val) := by
    exact hA.trans hcsum
  -- But separability forces it to be `0`: `-(N/d)` is a non-unit.
  have hNd_dvd : (N / DirichletCharacter.conductor χ) ∣ N := Nat.div_dvd_of_dvd hdvd
  have hNd_gt : 1 < N / DirichletCharacter.conductor χ := by
    rcases hdvd with ⟨k, hk⟩
    have hNdk : N / DirichletCharacter.conductor χ = k :=
      Nat.div_eq_of_eq_mul_left hd0 (by rw [mul_comm]; exact hk)
    have hk1 : 1 < k := by
      by_contra hc
      push_neg at hc
      interval_cases k <;> omega
    rw [hNdk]; exact hk1
  have hnu0 : ¬ IsUnit (((N / DirichletCharacter.conductor χ : ℕ)) : ZMod N) := by
    rw [ZMod.isUnit_iff_coprime, Nat.Coprime, Nat.gcd_eq_left hNd_dvd]
    omega
  have hnu : ¬ IsUnit (-(((N / DirichletCharacter.conductor χ : ℕ)) : ZMod N)) :=
    fun h => hnu0 (by simpa using h.neg)
  have hz := hsep (-(((N / DirichletCharacter.conductor χ : ℕ)) : ZMod N))
  rw [MulChar.map_nonunit χ hnu, inv_zero, mul_zero] at hz
  exact smul_ne_zero hc0.ne' hS (hFeq.symm.trans hz)

/-! ### §10  The coprime case: N odd and squarefree  (paper eq. (6)) -/

/-
If `N ∣ p·d` and `N ∣ d²`, then a unit `≡ 1 (mod d)` has `p`-th power `1`.
-/
lemma unit_congr_one_pow_prime {N : ℕ} [NeZero N] {p d : ℕ} (hp : p.Prime)
    (hd : d ∣ N) (hpd : N ∣ p * d) (hd2 : N ∣ d ^ 2)
    (u : (ZMod N)ˣ) (hu : ZMod.unitsMap hd u = 1) : u ^ p = 1 := by
  -- Since $u \equiv 1 \pmod{d}$, we have $u = 1 + kd$ for some integer $k$.
  obtain ⟨k, hk⟩ : ∃ k : ℤ, u.val.val = 1 + k * d := by
    have h_cong : (u.val.val : ℤ) ≡ 1 [ZMOD d] := by
      simp_all +decide [ ← ZMod.intCast_eq_intCast_iff, ZMod.unitsMap ];
      injection hu;
    exact h_cong.symm.dvd.imp fun k hk => by linarith;
  -- Therefore, $u^p \equiv 1 \pmod{N}$.
  have h_up_mod : (u.val.val : ℤ) ^ p ≡ 1 [ZMOD N] := by
    -- Expand $(1 + kd)^p$ using the binomial theorem.
    have h_expand : (1 + k * d) ^ p = 1 + p * k * d + ∑ i ∈ Finset.Icc 2 p, Nat.choose p i * k ^ i * d ^ i := by
      rw [ add_comm, add_pow ];
      erw [ Finset.sum_Ico_eq_sub _ ] <;> norm_num [ Finset.sum_range_succ' ] ; ring;
      linarith [ hp.two_le ];
    -- Since $N \mid p * d$ and $N \mid d^2$, we have $N \mid p * k * d$ and $N \mid \sum_{i=2}^p \binom{p}{i} k^i d^i$.
    have h_div : (N : ℤ) ∣ p * k * d ∧ (N : ℤ) ∣ ∑ i ∈ Finset.Icc 2 p, Nat.choose p i * k ^ i * d ^ i := by
      exact ⟨ by simpa [ mul_assoc, mul_comm, mul_left_comm ] using Int.natCast_dvd_natCast.mpr hpd |> fun x => dvd_mul_of_dvd_left x k, Finset.dvd_sum fun i hi => dvd_mul_of_dvd_right ( by exact dvd_trans ( mod_cast hd2 ) ( pow_dvd_pow _ <| Finset.mem_Icc.mp hi |>.1 ) ) _ ⟩;
    simp_all +decide [ Int.modEq_iff_dvd ];
    convert dvd_neg.mpr ( dvd_add h_div.1 h_div.2 ) using 1 ; ring;
  simp_all +decide [ ← ZMod.intCast_eq_intCast_iff ];
  convert h_up_mod using 1;
  simp +decide [ ← hk, Units.ext_iff ];
  norm_cast;
  simp +decide [ ← hk, ZMod.natCast_eq_zero_iff ]

/-- Primitivity of `χ` mod `N` forces `χ` to be nontrivial on the kernel of the
    reduction to `(ZMod d)ˣ`, for any proper divisor `d < N`. -/
lemma exists_nontrivial_on_ker_div {N : ℕ} [NeZero N] (χ : MulChar (ZMod N) K)
    (hχ : DirichletCharacter.conductor χ = N) {d : ℕ} (hd : d ∣ N) (hdlt : d < N) :
    ∃ u : (ZMod N)ˣ, ZMod.unitsMap hd u = 1 ∧ χ u ≠ 1 := by
  by_contra! h_nontrivial
  have h_factor : DirichletCharacter.FactorsThrough χ d := by
    rw [DirichletCharacter.factorsThrough_iff_ker_unitsMap hd]
    intro u hu
    simp only [MonoidHom.mem_ker] at hu ⊢
    specialize h_nontrivial u hu
    rw [← Units.val_inj, MulChar.coe_toUnitHom, Units.val_one, h_nontrivial]
  have hdvd := DirichletCharacter.conductor_dvd_of_mem_conductorSet χ (NeZero.ne N)
    ((DirichletCharacter.mem_conductorSet_iff χ).mpr h_factor)
  rw [hχ] at hdvd
  have hd0 : 0 < d := Nat.pos_of_dvd_of_pos hd (Nat.pos_of_ne_zero (NeZero.ne N))
  exact absurd (Nat.le_of_dvd hd0 hdvd) (by omega)

/-- If some unit `u` satisfies `u^p = 1` and `χ u ≠ 1` (χ taking `m`-th-root values
    on units), then the prime `p` divides `m`. -/
lemma p_dvd_of_unit_pth_root {N : ℕ} [NeZero N] (χ : MulChar (ZMod N) K)
    {m p : ℕ} (hp : p.Prime) (hmo : ∀ x, IsUnit x → (χ x) ^ m = 1)
    (u : (ZMod N)ˣ) (hup : u ^ p = 1) (hu1 : χ (u : ZMod N) ≠ 1) : p ∣ m := by
  have hpow : (χ (u : ZMod N)) ^ p = 1 := by
    rw [← map_pow]
    have : ((u ^ p : (ZMod N)ˣ) : ZMod N) = ((1 : (ZMod N)ˣ) : ZMod N) := by rw [hup]
    simpa using congrArg χ this
  haveI : Fact (Nat.Prime p) := ⟨hp⟩
  have horder : orderOf (χ (u : ZMod N)) = p := orderOf_eq_prime hpow hu1
  rw [← horder]
  exact orderOf_dvd_of_pow_eq_one (hmo _ u.isUnit)

/-- Engine of (6): a primitive character mod p^α with α ≥ 2 taking mo-th-root
    values has p ∣ mo. -/
lemma p_dvd_order_of_primitive_prime_pow
    {p α : ℕ} (hp : p.Prime) (hα : 2 ≤ α)
    (χ : MulChar (ZMod (p ^ α)) K) (hχ : DirichletCharacter.conductor χ = p ^ α)
    {mo : ℕ} (hmo : ∀ x, IsUnit x → (χ x) ^ mo = 1) : p ∣ mo := by
  haveI : NeZero (p ^ α) := ⟨pow_ne_zero α hp.ne_zero⟩
  have hd : p ^ (α - 1) ∣ p ^ α := pow_dvd_pow p (Nat.sub_le α 1)
  have hdlt : p ^ (α - 1) < p ^ α := pow_lt_pow_right₀ hp.one_lt (by omega)
  have hpd : p ^ α ∣ p * p ^ (α - 1) := by
    have h : p * p ^ (α - 1) = p ^ α := by rw [← pow_succ', Nat.sub_add_cancel (by omega)]
    rw [h]
  have hd2 : p ^ α ∣ (p ^ (α - 1)) ^ 2 := by
    rw [← pow_mul]; exact pow_dvd_pow p (by omega)
  obtain ⟨u, hu, hu1⟩ := exists_nontrivial_on_ker_div χ hχ hd hdlt
  have hup : u ^ p = 1 := unit_congr_one_pow_prime hp hd hpd hd2 u hu
  exact p_dvd_of_unit_pth_root χ hp hmo u hup hu1

/-- If a prime square `p² ∣ N` and `χ` is primitive mod `N` with `m`-th-root values,
    then `p ∣ m`.  (Level-N version, no CRT factorization needed.) -/
lemma prime_sq_dvd_imp_p_dvd_m {N : ℕ} [NeZero N] (χ : MulChar (ZMod N) K)
    (hχ : DirichletCharacter.conductor χ = N) {m : ℕ} (hmo : ∀ x, IsUnit x → (χ x) ^ m = 1)
    {p : ℕ} (hp : p.Prime) (hp2 : p ^ 2 ∣ N) : p ∣ m := by
  have hpN : p ∣ N := (dvd_pow_self p two_ne_zero).trans hp2
  obtain ⟨b, hb⟩ := hp2
  set d := N / p with hd_def
  have hd : d ∣ N := ⟨p, (Nat.div_mul_cancel hpN).symm⟩
  have hpd_eq : p * d = N := Nat.mul_div_cancel' hpN
  have hdlt : d < N := Nat.div_lt_self (Nat.pos_of_ne_zero (NeZero.ne N)) hp.one_lt
  have hpd : N ∣ p * d := by rw [hpd_eq]
  have hdb : d = p * b := by
    rw [hd_def, hb, pow_two, mul_assoc, Nat.mul_div_cancel_left _ hp.pos]
  have hd2 : N ∣ d ^ 2 := ⟨b, by rw [hdb, hb]; ring⟩
  obtain ⟨u, hu, hu1⟩ := exists_nontrivial_on_ker_div χ hχ hd hdlt
  have hup : u ^ p = 1 := unit_congr_one_pow_prime hp hd hpd hd2 u hu
  exact p_dvd_of_unit_pth_root χ hp hmo u hup hu1

/-
A character mod `N = 2·N'` with `N'` odd factors through `N'`
    (there is no primitive character modulo an exact factor of 2).
-/
lemma factorsThrough_half {N : ℕ} [NeZero N] (χ : MulChar (ZMod N) K)
    {N' : ℕ} (hN : N = 2 * N') (hodd : Odd N') :
    DirichletCharacter.FactorsThrough χ N' := by
  convert DirichletCharacter.factorsThrough_iff_ker_unitsMap ( show N' ∣ N from hN.symm ▸ dvd_mul_left _ _ ) |>.2 _;
  intro u hu
  have hu1 : u.val.val ≡ 1 [MOD N'] := by
    simp_all +decide [ ← ZMod.natCast_eq_natCast_iff, ZMod.unitsMap ];
    injection hu
  have hu2 : u.val.val ≡ 1 [MOD 2] := by
    have hu2 : (ZMod.unitsMap (show 2 ∣ N from hN.symm ▸ dvd_mul_right _ _) u) = 1 := by
                                exact Subsingleton.elim _ _;
    simp_all +decide [ ← ZMod.natCast_eq_natCast_iff ];
    convert congr_arg ( fun x : ( ZMod 2 ) ˣ => ( x : ZMod 2 ) ) hu2 using 1
  have hu3 : u.val.val ≡ 1 [MOD N] := by
    rw [ Nat.modEq_iff_dvd ] at *;
    convert Int.coe_lcm_dvd hu1 hu2 using 1 ; simp +decide [ hN, Int.lcm ];
    rw [ Nat.lcm_comm, Nat.Coprime.lcm_eq_mul ] <;> simp +decide [ hodd, Nat.Coprime, Nat.gcd_comm ]
  have hu4 : u = 1 := by
    convert hu3 using 1;
    simp +decide [ ← ZMod.natCast_eq_natCast_iff ]
  aesop

/-- The coprime case: a primitive character mod `N` with `m`-th-root values and
    `gcd(m, N) = 1` forces `N` odd and squarefree. -/
theorem odd_and_squarefree_of_coprime (N m : ℕ) [NeZero N] [NeZero m]
    (χ : MulChar (ZMod N) K) (hχ : DirichletCharacter.conductor χ = N)
    (hmo : ∀ x, IsUnit x → (χ x) ^ m = 1)
    (hcop : Nat.Coprime m N) : Odd N ∧ Squarefree N := by
  have hsf : Squarefree N := by
    rw [Nat.squarefree_iff_prime_squarefree]
    intro p hp hp2
    have hp2' : p ^ 2 ∣ N := by rwa [pow_two]
    have hpm : p ∣ m := prime_sq_dvd_imp_p_dvd_m χ hχ hmo hp hp2'
    have hpN : p ∣ N := (dvd_mul_left p p).trans hp2
    exact hp.not_dvd_one
      (show p ∣ 1 from (show Nat.gcd m N = 1 from hcop) ▸ Nat.dvd_gcd hpm hpN)
  refine ⟨?_, hsf⟩
  rw [← Nat.not_even_iff_odd]
  intro hne
  rw [even_iff_two_dvd] at hne
  have hN : N = 2 * (N / 2) := (Nat.mul_div_cancel' hne).symm
  have hodd : Odd (N / 2) := by
    rw [← Nat.not_even_iff_odd]
    intro h4
    rw [even_iff_two_dvd] at h4
    have h44 : 2 * 2 ∣ N := by rw [hN]; exact mul_dvd_mul_left 2 h4
    exact absurd (hsf 2 h44) (by simp)
  have hFT : DirichletCharacter.FactorsThrough χ (N / 2) := factorsThrough_half χ hN hodd
  have hdvd := DirichletCharacter.conductor_dvd_of_mem_conductorSet χ (NeZero.ne N)
    ((DirichletCharacter.mem_conductorSet_iff χ).mpr hFT)
  rw [hχ] at hdvd
  have h2pos : 0 < N := Nat.pos_of_ne_zero (NeZero.ne N)
  have hlt : N / 2 < N := Nat.div_lt_self h2pos one_lt_two
  have hpos2 : 0 < N / 2 := by omega
  have hle := Nat.le_of_dvd hpos2 hdvd
  omega

/-! ### §11  Assembled statement of Theorem 1.5. -/

/-- Theorem 1.5 (Hiary–Saraeb).  Under the battery (★), `f` is the
    extension-by-zero of a primitive Dirichlet character mod N; if moreover
    `gcd(m, N) = 1` then N is odd and squarefree. -/
theorem thm15 (N m : ℕ) [NeZero N] [NeZero m]
    [IsCyclotomicExtension {m * N} ℚ K] {ζ : K} (hζ : IsPrimitiveRoot ζ (m * N))
    (f : ZMod N → K)
    (hval : ∀ x : ZMod N, IsUnit x → (f x) ^ m = 1)
    (hzero : ∀ x : ZMod N, ¬ IsUnit x → f x = 0)
    (hone : f 1 = 1)
    (H : Subgroup (ZMod m)ˣ)
    (hH : ∀ s : (ZMod N)ˣ, ∃ c ∈ H,
      ((s : ZMod N)).val ≡ ((c : ZMod m)).val [MOD Nat.gcd m N])
    (hbat : ∀ c ∈ H, ∃ Λ : K, Λ ≠ 0 ∧
      ∀ ξ : ZMod N, Fhat N m ζ (fun x => f x ^ ((c : ZMod m)).val) ξ
        = Λ * ((f ξ) ^ ((c : ZMod m)).val)⁻¹)
    (hm1 : 1 < m) :
    ∃ χ : MulChar (ZMod N) K, (∀ x, χ x = f x) ∧
      DirichletCharacter.conductor χ = N ∧
      (Nat.Coprime m N → Odd N ∧ Squarefree N) := by
  have hne : ∀ s : (ZMod N)ˣ, f (s : ZMod N) ≠ 0 := fun s => f_ne_zero hval s.isUnit
  have hmul : ∀ s r : (ZMod N)ˣ,
      f ((s : ZMod N) * (r : ZMod N)) = f (s : ZMod N) * f (r : ZMod N) :=
    fun s r => f_multiplicative N m hζ f hval hzero hone H hH hbat hm1 s r
  set χ := chi N f hmul hne hone with hχdef
  have hχf : ∀ x, χ x = f x := chi_apply_eq N f hmul hne hone hzero
  have hfun : (fun x => χ x) = f := funext hχf
  obtain ⟨hsep0, hsep⟩ := separable N m f hone H hbat hm1
  have hcond : DirichletCharacter.conductor χ = N := by
    refine separable_implies_primitive N m hζ χ ?_ ?_
    · rw [hfun]; exact hsep0
    · intro ξ; rw [hfun, hχf]; exact hsep ξ
  refine ⟨χ, hχf, hcond, ?_⟩
  intro hcop
  refine odd_and_squarefree_of_coprime N m χ hcond ?_ hcop
  intro x hx
  rw [hχf]; exact hval x hx

end HiarySaraeb