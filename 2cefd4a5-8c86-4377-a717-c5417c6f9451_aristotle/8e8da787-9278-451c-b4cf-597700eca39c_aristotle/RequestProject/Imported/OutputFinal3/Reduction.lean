/-
Copyright (c) 2026. Released under Apache 2.0 license.
-/
import Mathlib

/-!
# Reduction mod `p` and the order of a Galois group

This file proves a general, standard piece of algebraic number theory which is not in Mathlib:

> **Theorem.** Let `L` be a Galois number field, let `f ∈ ℤ[X]` be monic and suppose `f` splits
> in `L`.  If `q` is a prime and `g ∈ 𝔽_q[X]` is a monic irreducible factor of `f mod q`, then
> `deg g` divides the order of `Gal(L/ℚ)`.

This is the "easy half" of Dedekind's theorem on the factorisation of primes: no cycle types
and no Frobenius conjugacy classes are needed, only the fact that the residue degree of a prime
of `𝓞 L` above `q` divides `[L : ℚ]`, together with the observation that the residue field must
contain a root of `g` (because `f` splits there).

The main theorem is `ArtinA5Even.natDegree_dvd_card_gal`.  It is applied in
`ArtinA5Even.GalA5` to the Doud–Moore quintic, with `q = 3` (where the quintic stays irreducible,
giving `5 ∣ |Gal|`) and `q = 13` (where it acquires an irreducible cubic factor, giving
`3 ∣ |Gal|`).
-/

set_option maxHeartbeats 1000000

namespace ArtinA5Even

open Polynomial NumberField IntermediateField

/-- If every member of a multiset is in the image of `φ`, the multiset is the image of a
multiset. -/
theorem exists_multiset_map {α β : Type*} (φ : α → β) :
    ∀ (s : Multiset β), (∀ b ∈ s, ∃ a, φ a = b) → ∃ t : Multiset α, s = t.map φ := by
  intro s
  induction s using Multiset.induction with
  | empty => exact fun _ => ⟨0, by simp⟩
  | cons b s ih =>
      intro h
      obtain ⟨a, ha⟩ := h b (Multiset.mem_cons_self b s)
      obtain ⟨t, ht⟩ := ih fun c hc => h c (Multiset.mem_cons_of_mem hc)
      exact ⟨a ::ₘ t, by rw [Multiset.map_cons, ha, ht]⟩

/-- If a monic irreducible `g ∈ 𝔽_q[X]` has a root in a finite extension `k` of `𝔽_q`, then
`deg g` divides `[k : 𝔽_q]`. -/
theorem natDegree_dvd_finrank_of_root {q : ℕ} [Fact q.Prime] {k : Type*} [Field k]
    [Algebra (ZMod q) k] [FiniteDimensional (ZMod q) k]
    {g : (ZMod q)[X]} (hg : Irreducible g) (hgm : g.Monic) {β : k} (hβ : aeval β g = 0) :
    g.natDegree ∣ Module.finrank (ZMod q) k := by
  have hint : IsIntegral (ZMod q) β := ⟨g, hgm, by simpa [Polynomial.aeval_def] using hβ⟩
  have hminpoly : minpoly (ZMod q) β = g :=
    (minpoly.eq_of_irreducible_of_monic hg hβ hgm).symm
  have hfr : Module.finrank (ZMod q) (ZMod q)⟮β⟯ = g.natDegree := by
    rw [IntermediateField.adjoin.finrank hint, hminpoly]
  rw [← hfr]
  exact ⟨Module.finrank (ZMod q)⟮β⟯ k,
    (Module.finrank_mul_finrank (ZMod q) (ZMod q)⟮β⟯ k).symm⟩

variable (L : Type*) [Field L] [NumberField L]

omit [NumberField L] in
/-- A monic integer polynomial that splits in a number field `L` already factors into monic
linear factors over the ring of integers `𝓞 L`. -/
theorem exists_prod_X_sub_C_of_splits {f : ℤ[X]} (hf : f.Monic)
    (hsplit : (f.map (algebraMap ℤ L)).Splits) :
    ∃ t : Multiset (𝓞 L),
      f.map (algebraMap ℤ (𝓞 L)) = (t.map fun a => X - C a).prod := by
  classical
  set fL := f.map (algebraMap ℤ L) with hfL
  have hfLmonic : fL.Monic := hf.map _
  have hprod : fL = (fL.roots.map fun a => X - C a).prod :=
    hsplit.eq_prod_roots_of_monic hfLmonic
  have hmem : ∀ a ∈ fL.roots, ∃ α : 𝓞 L, algebraMap (𝓞 L) L α = a := by
    intro a ha
    have hroot : aeval a f = 0 := by
      have := (mem_roots (hfLmonic.ne_zero)).mp ha
      simpa [hfL, aeval_def, eval_map] using this
    have hint : IsIntegral ℤ a := ⟨f, hf, by simpa [aeval_def] using hroot⟩
    exact (IsIntegralClosure.isIntegral_iff (A := 𝓞 L)).mp hint
  obtain ⟨t, ht⟩ := exists_multiset_map (algebraMap (𝓞 L) L) fL.roots hmem
  refine ⟨t, ?_⟩
  have hinj : Function.Injective (algebraMap (𝓞 L) L) := FaithfulSMul.algebraMap_injective _ _
  apply Polynomial.map_injective (algebraMap (𝓞 L) L) hinj
  rw [Polynomial.map_map, ← IsScalarTower.algebraMap_eq, Polynomial.map_multiset_prod,
    Multiset.map_map]
  calc fL = (fL.roots.map fun a => X - C a).prod := hprod
    _ = ((t.map (algebraMap (𝓞 L) L)).map fun a => X - C a).prod := by rw [← ht]
    _ = (t.map ((fun a => X - C a) ∘ algebraMap (𝓞 L) L)).prod := by rw [Multiset.map_map]
    _ = _ := by
        congr 1
        refine Multiset.map_congr rfl ?_
        intro a _
        simp

omit [NumberField L] in
/-- The reduction of `f` modulo any ideal of `𝓞 L` splits, if `f` splits in `L`. -/
theorem splits_map_quotient {f : ℤ[X]} (hf : f.Monic)
    (hsplit : (f.map (algebraMap ℤ L)).Splits) (P : Ideal (𝓞 L)) :
    (f.map (algebraMap ℤ ((𝓞 L) ⧸ P))).Splits := by
  obtain ⟨t, ht⟩ := exists_prod_X_sub_C_of_splits L hf hsplit
  have : f.map (algebraMap ℤ ((𝓞 L) ⧸ P))
      = ((t.map fun a => X - C a).prod).map (algebraMap (𝓞 L) ((𝓞 L) ⧸ P)) := by
    rw [← ht, Polynomial.map_map, ← IsScalarTower.algebraMap_eq]
  rw [this, Polynomial.map_multiset_prod, Multiset.map_map]
  refine Splits.multisetProd ?_
  intro r hr
  obtain ⟨a, -, rfl⟩ := Multiset.mem_map.mp hr
  simp

/-- **Reduction mod `q` bounds the Galois group from below.**

If `f ∈ ℤ[X]` is monic and splits in the Galois number field `L`, and if the reduction of `f`
modulo a prime `q` has a monic irreducible factor `g` over `𝔽_q`, then `deg g` divides the order
of `Gal(L/ℚ)`.

The mechanism: `g` has a root in the residue field `k` of any prime `P` of `𝓞 L` above `q`
(because `f`, hence `g`, splits over `k`), so `deg g ∣ [k : 𝔽_q]`, and the residue degree
`[k : 𝔽_q]` divides `|Gal(L/ℚ)|` by the fundamental identity for Galois extensions. -/
theorem natDegree_dvd_card_gal [IsGalois ℚ L] {f : ℤ[X]} (hf : f.Monic)
    (hsplit : (f.map (algebraMap ℤ L)).Splits) {q : ℕ} (hq : q.Prime) {g : (ZMod q)[X]}
    (hg : Irreducible g) (hgm : g.Monic) (hgdvd : g ∣ f.map (Int.castRingHom (ZMod q))) :
    g.natDegree ∣ Nat.card (L ≃ₐ[ℚ] L) := by
  classical
  haveI : Fact q.Prime := ⟨hq⟩
  -- the prime `q` of `ℤ` and a prime `P` of `𝓞 L` above it
  set p : Ideal ℤ := Ideal.span {(q : ℤ)} with hp
  have hpprime : Prime (q : ℤ) := Nat.prime_iff_prime_int.mp hq
  have hpne : p ≠ ⊥ := by
    simp only [hp, Ne, Ideal.span_singleton_eq_bot]
    exact_mod_cast hq.ne_zero
  have hpmax : p.IsMaximal :=
    ((Ideal.span_singleton_prime (by exact_mod_cast hq.ne_zero)).mpr hpprime).isMaximal hpne
  obtain ⟨P, hPmax, hPover⟩ := Ideal.exists_ideal_over_maximal_of_isIntegral (R := ℤ) (S := 𝓞 L) p
    (by
      have hinj : Function.Injective (algebraMap ℤ (𝓞 L)) := FaithfulSMul.algebraMap_injective _ _
      rw [(RingHom.injective_iff_ker_eq_bot _).mp hinj]
      exact bot_le)
  haveI : P.LiesOver p := ⟨hPover.symm⟩
  have hqmem : (algebraMap ℤ (𝓞 L)) (q : ℤ) ∈ P := by
    have : (q : ℤ) ∈ p := Ideal.mem_span_singleton_self _
    rwa [← hPover] at this
  have hPbot : P ≠ ⊥ := by
    intro h
    rw [h, Ideal.mem_bot] at hqmem
    have hinj : Function.Injective (algebraMap ℤ (𝓞 L)) := FaithfulSMul.algebraMap_injective _ _
    have h0 : (q : ℤ) = 0 := hinj (by rw [hqmem, map_zero])
    exact_mod_cast hq.ne_zero (by exact_mod_cast h0)
  haveI : Finite ((𝓞 L) ⧸ P) := Ideal.finiteQuotientOfFreeOfNeBot P hPbot
  haveI : Finite (ℤ ⧸ p) := Ideal.finiteQuotientOfFreeOfNeBot p hpne
  letI : Field (ℤ ⧸ p) := Ideal.Quotient.field p
  letI : Field ((𝓞 L) ⧸ P) := Ideal.Quotient.field P
  haveI : Algebra.IsSeparable (ℤ ⧸ p) ((𝓞 L) ⧸ P) := inferInstance
  -- the residue degree divides the order of the Galois group
  have hkey : Module.finrank (ℤ ⧸ p) ((𝓞 L) ⧸ P) ∣ Nat.card (L ≃ₐ[ℚ] L) := by
    have key := Ideal.ncard_primesOver_mul_card_inertia_mul_finrank
      (G := (L ≃ₐ[ℚ] L)) (R := ℤ) (S := 𝓞 L) p P
    refine ⟨(p.primesOver (𝓞 L)).ncard * Nat.card (Ideal.inertia (L ≃ₐ[ℚ] L) P), ?_⟩
    rw [← key]; ring

  -- the residue field as an `𝔽_q`-algebra
  have hchar : ((q : ℕ) : ((𝓞 L) ⧸ P)) = 0 := by
    have : (algebraMap (𝓞 L) ((𝓞 L) ⧸ P)) ((algebraMap ℤ (𝓞 L)) (q : ℤ)) = 0 := by
      rw [Ideal.Quotient.algebraMap_eq, Ideal.Quotient.eq_zero_iff_mem]
      exact hqmem
    simpa using this
  haveI : CharP ((𝓞 L) ⧸ P) q := (CharP.charP_iff_prime_eq_zero hq).mpr hchar
  letI : Algebra (ZMod q) ((𝓞 L) ⧸ P) := ZMod.algebra _ q
  haveI : FiniteDimensional (ZMod q) ((𝓞 L) ⧸ P) := Module.Finite.of_finite
  -- the two `finrank`s of the residue field over its prime field agree
  have hcardp : Nat.card (ℤ ⧸ p) = q := by
    have := Nat.card_congr (Int.quotientSpanNatEquivZMod q).toEquiv
    rwa [Nat.card_zmod] at this
  have hfinrank_eq :
      Module.finrank (ZMod q) ((𝓞 L) ⧸ P) = Module.finrank (ℤ ⧸ p) ((𝓞 L) ⧸ P) := by
    haveI : Fintype ((𝓞 L) ⧸ P) := Fintype.ofFinite _
    haveI : Fintype (ZMod q) := Fintype.ofFinite _
    haveI : Fintype (ℤ ⧸ p) := Fintype.ofFinite _
    have h1 : Nat.card ((𝓞 L) ⧸ P) = q ^ Module.finrank (ZMod q) ((𝓞 L) ⧸ P) := by
      have := Module.card_eq_pow_finrank (K := ZMod q) (V := ((𝓞 L) ⧸ P))
      simpa [Nat.card_eq_fintype_card, ZMod.card] using this
    have h2 : Nat.card ((𝓞 L) ⧸ P) = q ^ Module.finrank (ℤ ⧸ p) ((𝓞 L) ⧸ P) := by
      have := Module.card_eq_pow_finrank (K := ℤ ⧸ p) (V := ((𝓞 L) ⧸ P))
      rw [← Nat.card_eq_fintype_card, ← Nat.card_eq_fintype_card, hcardp] at this
      exact this
    exact Nat.pow_right_injective hq.two_le (h1.symm.trans h2)
  -- `g` has a root in the residue field
  have hmapcomp : (f.map (Int.castRingHom (ZMod q))).map (algebraMap (ZMod q) ((𝓞 L) ⧸ P))
      = f.map (algebraMap ℤ ((𝓞 L) ⧸ P)) := by
    rw [Polynomial.map_map]
    congr 1
    exact RingHom.ext_int _ _
  have hsplit_k : (f.map (algebraMap ℤ ((𝓞 L) ⧸ P))).Splits := splits_map_quotient L hf hsplit P
  have hgk : g.map (algebraMap (ZMod q) ((𝓞 L) ⧸ P)) ∣ f.map (algebraMap ℤ ((𝓞 L) ⧸ P)) := by
    rw [← hmapcomp]
    exact Polynomial.map_dvd _ hgdvd
  have hgsplit : (g.map (algebraMap (ZMod q) ((𝓞 L) ⧸ P))).Splits :=
    Polynomial.Splits.of_dvd hsplit_k (hf.map _).ne_zero hgk
  have hdegpos : 0 < g.natDegree := hg.natDegree_pos
  obtain ⟨β, hβ⟩ : ∃ β : ((𝓞 L) ⧸ P), (g.map (algebraMap (ZMod q) ((𝓞 L) ⧸ P))).IsRoot β := by
    have hdeg : (g.map (algebraMap (ZMod q) ((𝓞 L) ⧸ P))).degree ≠ 0 := by
      rw [Polynomial.degree_map_eq_of_leadingCoeff_ne_zero]
      · exact fun h => by
          rw [Polynomial.degree_eq_natDegree hgm.ne_zero] at h
          exact absurd (by exact_mod_cast h) hdegpos.ne'
      · simp [hgm.leadingCoeff]
    exact hgsplit.exists_eval_eq_zero hdeg
  have haeval : (Polynomial.aeval β) g = 0 := by
    rw [Polynomial.aeval_def, ← Polynomial.eval_map]
    exact hβ
  -- so `deg g` divides the residue degree, which divides the order of the Galois group
  have hdvd_finrank : g.natDegree ∣ Module.finrank (ZMod q) ((𝓞 L) ⧸ P) :=
    natDegree_dvd_finrank_of_root hg hgm haeval
  exact hdvd_finrank.trans (hfinrank_eq ▸ hkey)

end ArtinA5Even
