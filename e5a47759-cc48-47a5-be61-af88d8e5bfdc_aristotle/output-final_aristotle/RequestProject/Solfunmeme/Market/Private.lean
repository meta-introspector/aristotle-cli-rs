/-
# Private input + untrusted compute + verifiable result

Senator Vaicu's report singles out the combination

    private input + untrusted compute + verifiable result

as the commercially valuable one.  This file makes the cheapest honest version
of that combination precise: the customer blinds the input with a uniformly
chosen mask, the operator computes on the blinded input and proves what it did,
and the customer unblinds the answer.

Two things are proved.

* **Perfect blinding.**  The blinded input the operator sees carries no
  information about the real input: for every pair of inputs there is a
  bijection of the mask space matching their blinded values one for one, and
  over a finite group each blinded value arises from exactly one mask.
* **Correct recovery.**  If the computation is equivariant for the mask (the
  additively homomorphic case), unblinding the verified result of the blinded
  job returns the result of the real job.

This is *additive blinding*, not fully homomorphic encryption; the equivariance
hypothesis is exactly what restricts which computations it applies to.  Nothing
here claims a general FHE construction.
-/
import Mathlib
import RequestProject.Solfunmeme.Market.Compute

namespace RequestProject.Market

section Blinding

variable {G : Type*} [AddCommGroup G]

/-- Blind an input with a mask. -/
def mask (x r : G) : G := x + r

/-- Recover a blinded value given the mask. -/
def unmask (z r : G) : G := z - r

@[simp] theorem unmask_mask (x r : G) : unmask (mask x r) r = x := by
  simp [unmask, mask]

/-- Rebasing masks from one input to another. -/
def blindEquiv (x x' : G) : G ≃ G := Equiv.addRight (x - x')

/-- **Perfect blinding.**  Every mask for the input `x` corresponds to exactly
one mask for any other input `x'` producing the same blinded value, so the
operator's view is consistent with every possible input. -/
theorem mask_blindEquiv (x x' r : G) : mask x' (blindEquiv x x' r) = mask x r := by
  simp [mask, blindEquiv, Equiv.addRight]
  abel

/-- The blinding map is a bijection of the mask space onto the possible views. -/
theorem mask_bijective (x : G) : Function.Bijective (mask x) :=
  (Equiv.addLeft x).bijective

/-- **Uniformity over a finite group.**  Whatever the real input, each blinded
value comes from exactly one mask; so a uniformly chosen mask makes the
operator's view uniform, independently of the input. -/
theorem card_mask_fiber [Fintype G] [DecidableEq G] (x z : G) :
    (Finset.univ.filter fun r : G => mask x r = z).card = 1 := by
  have : (Finset.univ.filter fun r : G => mask x r = z) = {z - x} := by
    ext r
    simp [mask, Finset.mem_filter, eq_sub_iff_add_eq, add_comm, eq_comm]
  simp [this]

end Blinding

section Equivariant

variable {G H : Type*} [AddCommGroup G] [AddCommGroup H]

/-- A computation that commutes with the blinding: the mask propagates through
it by a known homomorphism. -/
structure Blindable (G H : Type*) [AddCommGroup G] [AddCommGroup H] where
  /-- The computation the customer wants performed. -/
  f : G → H
  /-- How a mask on the input shows up on the output. -/
  shift : G →+ H
  /-- The equivariance law. -/
  equivariant : ∀ x r, f (x + r) = f x + shift r

/-- **Correct recovery.**  Unblinding the result of the blinded job returns the
result of the real job. -/
theorem Blindable.recover (b : Blindable G H) (x r : G) :
    unmask (b.f (mask x r)) (b.shift r) = b.f x := by
  simp [unmask, mask, b.equivariant x r]

/-- **Private, untrusted and verified at once.**  Take the market task "return
`b.f w` for the blinded input `w`".  If the settlement of the blinded job pays
the operator anything, then unblinding the submitted output yields exactly
`b.f x` for the customer's real, never-revealed input `x`. -/
theorem private_verified_result {Proof : Type*}
    (b : Blindable G H) (T : Task G H Proof)
    (hspec : ∀ w z, T.spec w z → z = b.f w)
    (x r : G) (t : Trade) (s : Submission H Proof)
    (hpay : 0 < (T.payout ⟨mask x r, t, some s⟩).1) :
    unmask s.output (b.shift r) = b.f x := by
  obtain ⟨s', hs', hspec'⟩ := paid_implies_spec T ⟨mask x r, t, some s⟩ hpay
  have hss : s' = s := (Option.some_inj.mp hs').symm
  subst hss
  have : s'.output = b.f (mask x r) := hspec _ _ hspec'
  rw [this, b.recover]

end Equivariant

end RequestProject.Market
