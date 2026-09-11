/-
  DULA_Bridge1.lean
  THE DULA GRADING DETERMINES SPLITTING IN THE EISENSTEIN INTEGERS
  ====================================================================
  This file formalizes Bridge 1 of the arithmetic chain:
    (ℤ/6ℤ)* → ℤ[ω] → K₁₂ → Λ₂₄
  Main theorem: For primes p > 3, the DULA grading ϕ₆(p) determines
  whether p splits or remains inert in the Eisenstein integers ℤ[ω]:
    - ϕ₆(p) = 0  ⟺  p ≡ 1 mod 6  ⟺  p splits in ℤ[ω]
    - ϕ₆(p) = 1  ⟺  p ≡ 5 mod 6  ⟺  p is inert in ℤ[ω]
  This connects the verified DULA core (phi6 = chi3, M5 involution)
  to the algebraic number theory of quadratic fields.
  For compilation with Lean 4 + Mathlib.
  Send to Aristotle for verification.
-/
import Mathlib
namespace DULA.Bridge1
/-! ## Part 1: The DULA Grading (from verified core) -/
/-- The DULA grading: classifies integers coprime to 6 by residue mod 6.
    ϕ₆(n) = 0 if n ≡ 1 mod 6, ϕ₆(n) = 1 if n ≡ 5 mod 6. -/
def phi6 (n : ℕ) : ZMod 2 :=
  if n % 6 = 1 then 0 else 1
/-- The Dirichlet character χ₃: the Legendre symbol mod 3.
    χ₃(n) = +1 if n ≡ 1 mod 3, χ₃(n) = -1 if n ≡ 2 mod 3, χ₃(n) = 0 if 3 | n. -/
def chi3 (n : ℤ) : ℤ :=
  if (n % 3 : ℤ) = 1 then 1
  else if (n % 3 : ℤ) = 2 then -1
  else 0
/-! ## Part 2: Splitting Behavior in ℤ[ω] -/
/-- A prime p > 3 splits in ℤ[ω] if and only if p ≡ 1 mod 3.
    This is equivalent to p ≡ 1 mod 6 (since p > 3 implies p is odd and not divisible by 3). -/
def splits_in_eisenstein (p : ℕ) : Prop := p % 3 = 1
/-- A prime p > 3 is inert in ℤ[ω] if and only if p ≡ 2 mod 3.
    This is equivalent to p ≡ 5 mod 6. -/
def inert_in_eisenstein (p : ℕ) : Prop := p % 3 = 2
/-! ## Part 3: The Bridge Theorem -/
private lemma coprime6_mod2_eq1 (p : ℕ) (hp_cop : Nat.Coprime p 6) : p % 2 = 1 := by
  have : Odd p := Nat.coprime_two_right.mp
    (Nat.Coprime.coprime_dvd_right (by norm_num : 2 ∣ 6) hp_cop)
  obtain ⟨k, hk⟩ := this; omega
private lemma coprime6_mod3_ne0 (p : ℕ) (hp_cop : Nat.Coprime p 6) : p % 3 ≠ 0 := by
  intro h
  have h3 : Nat.Coprime p 3 := Nat.Coprime.coprime_dvd_right (by norm_num : 3 ∣ 6) hp_cop
  have hd : 3 ∣ p := Nat.dvd_of_mod_eq_zero h
  rw [Nat.coprime_comm] at h3
  have hge : Nat.gcd 3 p ≥ 3 := Nat.le_of_dvd (by omega) (Nat.dvd_gcd dvd_rfl hd)
  omega
/-- For primes p > 3 with p ≡ 1 mod 6: the DULA grading is 0. -/
theorem phi6_zero_of_mod6_eq1 (p : ℕ) (hp : p % 6 = 1) :
    phi6 p = 0 := by
  unfold phi6; simp [hp]
/-- For primes p > 3 with p ≡ 5 mod 6: the DULA grading is 1. -/
theorem phi6_one_of_mod6_eq5 (p : ℕ) (hp : p % 6 = 5) :
    phi6 p = 1 := by
  unfold phi6
  simp_all
/-- KEY LEMMA: p ≡ 1 mod 6 if and only if p ≡ 1 mod 3 (for p coprime to 6).
    This connects the DULA grading (mod 6) to the splitting condition (mod 3). -/
theorem mod6_eq1_iff_mod3_eq1 (p : ℕ) (hp_gt3 : p > 3) (hp_cop : Nat.Coprime p 6) :
    p % 6 = 1 ↔ p % 3 = 1 := by
  constructor
  · intro h; omega
  · intro h
    have hp2 := coprime6_mod2_eq1 p hp_cop
    omega
/-- KEY LEMMA: p ≡ 5 mod 6 if and only if p ≡ 2 mod 3 (for p coprime to 6). -/
theorem mod6_eq5_iff_mod3_eq2 (p : ℕ) (hp_gt3 : p > 3) (hp_cop : Nat.Coprime p 6) :
    p % 6 = 5 ↔ p % 3 = 2 := by
  constructor
  · intro h; omega
  · intro h
    have hp2 := coprime6_mod2_eq1 p hp_cop
    omega
/-- BRIDGE 1 THEOREM (Forward direction):
    If the DULA grading ϕ₆(p) = 0, then p splits in ℤ[ω]. -/
theorem splits_of_phi6_zero (p : ℕ) (hp_gt3 : p > 3) (hp_cop : Nat.Coprime p 6)
    (hphi : phi6 p = 0) : splits_in_eisenstein p := by
  unfold splits_in_eisenstein
  unfold phi6 at hphi
  simp at hphi
  exact ((mod6_eq1_iff_mod3_eq1 p hp_gt3 hp_cop).mp hphi)
/-- BRIDGE 1 THEOREM (Reverse direction):
    If p splits in ℤ[ω], then the DULA grading ϕ₆(p) = 0. -/
theorem phi6_zero_of_splits (p : ℕ) (hp_gt3 : p > 3) (hp_cop : Nat.Coprime p 6)
    (hsplit : splits_in_eisenstein p) : phi6 p = 0 := by
  unfold phi6
  have h : p % 6 = 1 := (mod6_eq1_iff_mod3_eq1 p hp_gt3 hp_cop).mpr hsplit
  simp [h]
/-- BRIDGE 1 THEOREM (Forward direction, inert case):
    If the DULA grading ϕ₆(p) = 1, then p is inert in ℤ[ω]. -/
theorem inert_of_phi6_one (p : ℕ) (hp_gt3 : p > 3) (hp_cop : Nat.Coprime p 6)
    (hphi : phi6 p = 1) : inert_in_eisenstein p := by
  unfold inert_in_eisenstein
  unfold phi6 at hphi
  by_cases h6 : p % 6 = 1
  · simp [h6] at hphi
  · have h5 : p % 6 = 5 := by
      have hp2 := coprime6_mod2_eq1 p hp_cop
      have hp3 := coprime6_mod3_ne0 p hp_cop
      omega
    exact (mod6_eq5_iff_mod3_eq2 p hp_gt3 hp_cop).mp h5
/-- BRIDGE 1 THEOREM (Reverse direction, inert case):
    If p is inert in ℤ[ω], then the DULA grading ϕ₆(p) = 1. -/
theorem phi6_one_of_inert (p : ℕ) (hp_gt3 : p > 3) (hp_cop : Nat.Coprime p 6)
    (hinert : inert_in_eisenstein p) : phi6 p = 1 := by
  unfold phi6
  have h : p % 6 = 5 := (mod6_eq5_iff_mod3_eq2 p hp_gt3 hp_cop).mpr hinert
  simp_all
/-! ## Part 4: The Complete Biconditional -/
/-- MAIN THEOREM: The DULA grading determines splitting in ℤ[ω].
    For any prime p > 3 coprime to 6:
      ϕ₆(p) = 0  ⟺  p splits in ℤ[ω]  ⟺  p ≡ 1 mod 3  ⟺  χ₃(p) = +1
      ϕ₆(p) = 1  ⟺  p inert in ℤ[ω]  ⟺  p ≡ 2 mod 3  ⟺  χ₃(p) = -1 -/
theorem dula_grading_determines_splitting (p : ℕ) (hp_gt3 : p > 3) (hp_cop : Nat.Coprime p 6) :
    (phi6 p = 0 ↔ splits_in_eisenstein p) ∧
    (phi6 p = 1 ↔ inert_in_eisenstein p) := by
  constructor
  · exact ⟨splits_of_phi6_zero p hp_gt3 hp_cop, phi6_zero_of_splits p hp_gt3 hp_cop⟩
  · exact ⟨inert_of_phi6_one p hp_gt3 hp_cop, phi6_one_of_inert p hp_gt3 hp_cop⟩
/-- The DULA grading and χ₃ agree on the splitting/inert classification.
    χ₃(p) = +1 when p splits (ϕ₆ = 0), χ₃(p) = -1 when p is inert (ϕ₆ = 1). -/
theorem chi3_classifies_splitting (p : ℕ) (hp_gt3 : p > 3) (hp_cop : Nat.Coprime p 6) :
    (splits_in_eisenstein p ↔ chi3 (p : ℤ) = 1) ∧
    (inert_in_eisenstein p ↔ chi3 (p : ℤ) = -1) := by
  unfold splits_in_eisenstein inert_in_eisenstein chi3
  constructor
  · constructor
    · intro h; split_ifs with h1 <;> omega
    · intro h; split_ifs at h with h1 h2 <;> omega
  · constructor
    · intro h; split_ifs with h1 h2 <;> omega
    · intro h; split_ifs at h with h1 h2 <;> omega
/-! ## Part 5: The Norm Form Connection -/
/-- The norm form of ℤ[ω]: N(a + bω) = a² - ab + b² = a² + ab + b²
    (depending on convention; we use the standard N(a+bω) = a² + ab + b²
    which equals the A₂ quadratic form). -/
def eisenstein_norm (a b : ℤ) : ℤ := a^2 + a * b + b^2
/-- The norm form is the A₂ quadratic form Q(a,b) = a² + ab + b².
    This is the same form whose theta series gives L(s,Θ_{A₂}) = 6·ζ(s)·L(s,χ₃). -/
theorem norm_is_A2_form (a b : ℤ) : eisenstein_norm a b = a^2 + a * b + b^2 :=
  rfl
/-
PROBLEM
Backward direction: if p is represented by the norm form, then p ≡ 1 mod 3.
    Proof: a² + ab + b² mod 3 is always 0 or 1. Since p is prime and p > 3,
    p is not divisible by 3, so p ≡ 1 mod 3.
PROVIDED SOLUTION
We need: if ∃ a b : ℤ, a² + ab + b² = p and p is prime with p > 3, then p % 3 = 1.
Obtain a, b from hrep. Unfold eisenstein_norm and splits_in_eisenstein.
Key observation: a² + ab + b² mod 3 ∈ {0, 1}. Specifically, it's never ≡ 2 mod 3.
To show this, work in ZMod 3 or use Int.emod. Consider a % 3 and b % 3 (9 cases). In each case a^2 + a*b + b^2 is 0 or 1 mod 3.
Since p > 3 and p is prime, p % 3 ≠ 0 (as 3 doesn't divide p, since p is prime and p > 3 means p ≠ 3).
From hab: (a^2 + a*b + b^2) % 3 = p % 3. Since LHS % 3 ∈ {0,1} and p % 3 ≠ 0, we get p % 3 = 1.
For the mod 3 case analysis on the quadratic form, use `omega` or `Int.emod_emod_of_dvd` or cast to ZMod 3 and use `decide`. The simplest approach: take hab mod 3, use omega on the 9 cases of (a%3, b%3).
-/
theorem splits_of_represented (p : ℕ) (hp_prime : Nat.Prime p) (hp_gt3 : p > 3)
    (hrep : ∃ a b : ℤ, eisenstein_norm a b = (p : ℤ)) :
    splits_in_eisenstein p := by
  obtain ⟨ a, b, hab ⟩ := hrep;
  have h_mod3 : (a^2 + a * b + b^2) % 3 = 0 ∨ (a^2 + a * b + b^2) % 3 = 1 := by
    norm_num [ sq, Int.add_emod, Int.mul_emod ] ; have := Int.emod_nonneg a three_pos.ne'; have := Int.emod_nonneg b three_pos.ne'; have := Int.emod_lt_of_pos a three_pos; have := Int.emod_lt_of_pos b three_pos; interval_cases a % 3 <;> interval_cases b % 3 <;> trivial;
  cases h_mod3 <;> have := Nat.mod_lt p zero_lt_three <;> simp_all +decide [ Nat.add_mod, Nat.mul_mod, Nat.pow_mod ];
  · unfold splits_in_eisenstein; unfold eisenstein_norm at hab; simp_all +decide [ Nat.dvd_iff_mod_eq_zero ] ;
    norm_cast at *; simp_all +decide [ Nat.prime_dvd_prime_iff_eq ] ;
  · exact Eq.symm ( by rw [ show eisenstein_norm a b = a ^ 2 + a * b + b ^ 2 from rfl ] at hab; omega )
/-
PROBLEM
Forward direction: if p ≡ 1 mod 3, then p is represented by the norm form.
    Proof: p ≡ 1 mod 3 implies -3 is a QR mod p. By Thue's lemma / descent,
    p is represented by x² + xy + y².
PROVIDED SOLUTION
We need: if p is prime, p > 3, and p % 3 = 1, then ∃ a b : ℤ, a² + ab + b² = p.
Use the relation: a² + ab + b² = ((2a+b)² + 3b²) / 4. So proving ∃ a b, a²+ab+b² = p is equivalent to proving ∃ x y, x² + 3y² = 4p with x ≡ y mod 2.
Approach via descent / pigeonhole (Thue's lemma):
Since p ≡ 1 mod 3, the group (ZMod p)* has an element of order 3. That means ∃ r : ZMod p, r^2 + r + 1 = 0, which gives (2r+1)^2 = -3. So -3 is a square in ZMod p.
Let t : ZMod p satisfy t^2 = -3. Lift t to an integer representative t₀ with 0 ≤ t₀ < p. Then t₀² ≡ -3 mod p.
By Thue's lemma (pigeonhole on the lattice ℤ²), ∃ u v : ℤ with 1 ≤ u² + 3v² ≤ 4p and u ≡ t₀·v mod p. This implies u² + 3v² ≡ v²(t₀² + 3) ≡ 0 mod p.
So p | u² + 3v² and 1 ≤ u² + 3v² ≤ 4p, giving u² + 3v² ∈ {p, 2p, 3p, 4p}.
- 2p: impossible since u² + 3v² is even only if u,v have same parity, then u²+3v² ≡ 0 mod 4, so 4|2p, impossible since p is odd prime > 3.
- 3p: then 3 | u² + 3v² - 3v² = u², so 3|u, then 9|u²+3v² means 3|v², so 3|v, then u²+3v² ≥ 9+27 = 36 > 3p for small p. Actually need more care.
- 4p: then u,v both even (say) or... need case analysis.
This is quite complex for the subagent. An easier approach might exist if we can use `Nat.Prime.sq_add_sq` or adapt its proof.
Alternative: use the fact that ℤ[ω] is a UFD (or a PID). Since p ≡ 1 mod 3, there exists ω ∈ ℤ/pℤ with ω² + ω + 1 = 0. Then p | (a - ω)(a - ω²) in ℤ[ω] but p doesn't divide either factor, so p is not irreducible in ℤ[ω], meaning p = π·π̄ for some Eisenstein integer π. Then N(π) = p, giving the representation.
But formalizing this requires Eisenstein integer machinery not in Mathlib.
Perhaps the simplest approach: just do a direct descent argument. Or use the Minkowski bound approach. This might be too hard for the subagent. Let me try anyway.
-/
theorem represented_of_splits (p : ℕ) (hp_prime : Nat.Prime p) (hp_gt3 : p > 3)
    (hsplit : splits_in_eisenstein p) :
    ∃ a b : ℤ, eisenstein_norm a b = (p : ℤ) := by
  -- Since $p \equiv 1 \mod 3$, we can use the fact that $-3$ is a quadratic residue modulo $p$.
  have h_quad_res : ∃ t : ℤ, t^2 ≡ -3 [ZMOD p] := by
    haveI := Fact.mk hp_prime;
    -- Since $p \equiv 1 \mod 3$, we have that $-3$ is a quadratic residue modulo $p$.
    have h_quad_res : legendreSym p (-3) = 1 := by
      -- By Euler's criterion, since $p \equiv 1 \pmod{3}$, we have $\left(\frac{-3}{p}\right) = 1$.
      have h_euler : jacobiSym (-3) p = 1 := by
        rw [ jacobiSym.mod_right ];
        · unfold splits_in_eisenstein at hsplit; ( rw [ ← Nat.mod_mod_of_dvd p ( by decide : 3 ∣ 12 ) ] at hsplit; ( have := Nat.mod_lt p ( by decide : 0 < 12 ) ; interval_cases _ : p % 12 <;> simp_all +decide ; ) );
          · have := Nat.Prime.eq_two_or_odd hp_prime; omega;
          · native_decide +revert;
          · have := Nat.Prime.eq_two_or_odd hp_prime; omega;
        · exact hp_prime.odd_of_ne_two <| by linarith;
      rw [ jacobiSym ] at h_euler;
      simp_all +decide [ Nat.primeFactorsList_prime hp_prime ];
    rw [ legendreSym.eq_one_iff ] at h_quad_res;
    · obtain ⟨ x, hx ⟩ := h_quad_res; use x.val; simp_all +decide [ sq, ← ZMod.intCast_eq_intCast_iff ] ;
    · simp +zetaDelta at *;
      erw [ ZMod.natCast_eq_zero_iff ] ; exact Nat.not_dvd_of_pos_of_lt ( by decide ) hp_gt3;
  -- By Thue's lemma, there exist integers $u$ and $v$ such that $1 \leq u^2 + 3v^2 \leq 4p$ and $u \equiv tv \pmod{p}$.
  obtain ⟨u, v, huv⟩ : ∃ u v : ℤ, 1 ≤ u^2 + 3 * v^2 ∧ u^2 + 3 * v^2 ≤ 4 * p ∧ u ≡ h_quad_res.choose * v [ZMOD p] := by
    -- Consider the set of pairs $(x, y)$ with $0 \leq x, y \leq \lfloor \sqrt{p} \rfloor$.
    set S := Finset.product (Finset.Icc 0 (Nat.sqrt p)) (Finset.Icc 0 (Nat.sqrt p)) with hS_def
    have hS_card : S.card > p := by
      erw [ Finset.card_product ] ; norm_num ; nlinarith [ Nat.lt_succ_sqrt p ] ;
    generalize_proofs at *; (
    -- By the pigeonhole principle, there exist distinct pairs $(x_1, y_1)$ and $(x_2, y_2)$ in $S$ such that $x_1 + t y_1 \equiv x_2 + t y_2 \pmod{p}$.
    obtain ⟨x1, y1, x2, y2, h_distinct, h_cong⟩ : ∃ x1 y1 x2 y2 : ℕ, (x1, y1) ∈ S ∧ (x2, y2) ∈ S ∧ (x1, y1) ≠ (x2, y2) ∧ (x1 + h_quad_res.choose * y1) ≡ (x2 + h_quad_res.choose * y2) [ZMOD p] := by
      have h_pigeonhole : Finset.card (Finset.image (fun (xy : ℕ × ℕ) => (xy.1 + h_quad_res.choose * xy.2) % p) S) ≤ p := by
        exact le_trans ( Finset.card_le_card <| Finset.image_subset_iff.mpr fun x hx => Finset.mem_Ico.mpr ⟨ Int.emod_nonneg _ <| Nat.cast_ne_zero.mpr hp_prime.ne_zero, Int.emod_lt_of_pos _ <| Nat.cast_pos.mpr hp_prime.pos ⟩ ) ( by simpa ) ;
      generalize_proofs at *; (
      contrapose! h_pigeonhole;
      rw [ Finset.card_image_of_injOn fun x hx y hy hxy => by specialize h_pigeonhole x.1 x.2 y.1 y.2 hx hy; simp_all +decide [ Int.ModEq ] ] ; linarith;)
    generalize_proofs at *; (
    refine' ⟨ x1 - x2, y2 - y1, _, _, _ ⟩ <;> simp_all +decide [ ← ZMod.intCast_eq_intCast_iff ];
    · by_contra h_contra
      generalize_proofs at *; (
      exact h_cong.2.1 ( by nlinarith only [ h_contra ] ) ( by nlinarith only [ h_contra ] ));
    · nlinarith only [ Nat.sqrt_le p, h_distinct, h_cong.1 ] ;
    · linear_combination' h_cong.2.2));
  -- Since $u^2 + 3v^2$ is divisible by $p$ and $1 \leq u^2 + 3v^2 \leq 4p$, we have $u^2 + 3v^2 = p$, $2p$, $3p$, or $4p$.
  have h_cases : u^2 + 3 * v^2 = p ∨ u^2 + 3 * v^2 = 2 * p ∨ u^2 + 3 * v^2 = 3 * p ∨ u^2 + 3 * v^2 = 4 * p := by
    have h_div : (p : ℤ) ∣ u^2 + 3 * v^2 := by
      have := h_quad_res.choose_spec.symm.dvd;
      convert huv.2.2.symm.dvd.mul_left ( u + h_quad_res.choose * v ) |> Int.dvd_add <| this.mul_left ( v ^ 2 ) using 1 ; ring;
    obtain ⟨ k, hk ⟩ := h_div;
    have : k ≤ 4 := Int.le_of_lt_add_one ( by nlinarith ) ; ( have : k ≥ 0 := Int.le_of_lt_add_one ( by nlinarith ) ; interval_cases k <;> simp_all +decide ; );
    · exact Or.inr <| Or.inl <| by ring;
    · exact Or.inr <| Or.inr <| Or.inl <| by ring;
    · exact Or.inr <| Or.inr <| Or.inr <| by ring;
  rcases h_cases with h | h | h | h <;> simp_all +decide [ eisenstein_norm ];
  · exact ⟨ u - v, 2 * v, by linarith ⟩;
  · have := congr_arg ( · % 4 ) h ; rcases Int.even_or_odd' u with ⟨ k, rfl | rfl ⟩ <;> rcases Int.even_or_odd' v with ⟨ l, rfl | rfl ⟩ <;> ring_nf at this ⊢ <;> norm_num [ Int.ModEq, Int.add_emod, Int.mul_emod ] at this;
    · have := Nat.Prime.eq_two_or_odd hp_prime; omega;
    · grind +splitIndPred;
    · lia;
    · norm_cast at this; have := Nat.Prime.eq_two_or_odd hp_prime; omega;
  · -- If $u^2 + 3v^2 = 3p$, then $u$ must be divisible by 3. Let $u = 3k$ for some integer $k$.
    obtain ⟨k, rfl⟩ : ∃ k : ℤ, u = 3 * k := by
      exact Int.dvd_of_emod_eq_zero ( by have := congr_arg ( · % 3 ) h; norm_num [ sq, Int.add_emod, Int.mul_emod ] at this; have := Int.emod_nonneg u three_pos.ne'; have := Int.emod_lt_of_pos u three_pos; interval_cases u % 3 <;> trivial );
    exact ⟨ k + v, k - v, by linarith ⟩;
  · -- If $u^2 + 3v^2 = 4p$, then we can write $u = 2a + b$ and $v = b$ for some integers $a$ and $b$.
    obtain ⟨a, b, ha, hb⟩ : ∃ a b : ℤ, u = 2 * a + b ∧ v = b := by
      exact ⟨ ( u - v ) / 2, v, by linarith [ Int.ediv_mul_cancel ( show 2 ∣ u - v from even_iff_two_dvd.mp ( by apply_fun Even at *; simp_all +decide [ parity_simps ] ) ) ], rfl ⟩;
    exact ⟨ a, b, by subst_vars; linarith ⟩
/-- A prime p > 3 splits in ℤ[ω] if and only if p is represented by the
    norm form: ∃ a b : ℤ, a² + ab + b² = p.
    (This is the classical criterion connecting splitting to representation by forms.) -/
theorem splits_iff_represented (p : ℕ) (hp_prime : Nat.Prime p) (hp_gt3 : p > 3) :
    splits_in_eisenstein p ↔ ∃ a b : ℤ, eisenstein_norm a b = (p : ℤ) :=
  ⟨represented_of_splits p hp_prime hp_gt3, splits_of_represented p hp_prime hp_gt3⟩
/-! ## Part 6: Verification Checks -/
-- Verify specific primes
example : phi6 7 = 0 := by decide
example : phi6 11 = 1 := by decide
example : phi6 13 = 0 := by decide
example : phi6 17 = 1 := by decide
example : phi6 19 = 0 := by decide
example : phi6 23 = 1 := by decide
-- Verify splitting classification
example : splits_in_eisenstein 7 := by unfold splits_in_eisenstein; decide
example : inert_in_eisenstein 11 := by unfold inert_in_eisenstein; decide
example : splits_in_eisenstein 13 := by unfold splits_in_eisenstein; decide
example : inert_in_eisenstein 17 := by unfold inert_in_eisenstein; decide
example : splits_in_eisenstein 19 := by unfold splits_in_eisenstein; decide
example : inert_in_eisenstein 23 := by unfold inert_in_eisenstein; decide
-- Verify norm representations for splitting primes
example : eisenstein_norm 3 (-1) = 7 := by unfold eisenstein_norm; ring
example : eisenstein_norm 4 (-1) = 13 := by unfold eisenstein_norm; ring
example : eisenstein_norm 5 (-2) = 19 := by unfold eisenstein_norm; ring
-- Type checks for main theorems
#check dula_grading_determines_splitting
#check chi3_classifies_splitting
#check splits_iff_represented
end DULA.Bridge1
