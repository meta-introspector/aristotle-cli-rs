import RequestProject.Math.Bridge.CliffordMorphismLift

/-!
# Clifford metric lift

The geometric metric (the quadratic form `Q`) is lifted into the Clifford
algebra by the defining relation `ι(m)² = Q(m)`: squaring an embedded vector
recovers its scalar length. This module records this **metric lift** and the
polarized companion relating the symmetric product of two embedded vectors to
the associated bilinear form — the algebraic incarnation of the inner product.
-/

universe u

namespace RequestProject.Math.Bridge

open CliffordAlgebra

variable {R : Type u} [CommRing R]

/-- **The metric lift.** The square of an embedded vector equals the scalar
given by the quadratic form: the Clifford algebra internalizes the metric. -/
theorem clifford_metric_sq {M : Type u} [AddCommGroup M] [Module R M]
    (Q : QuadraticForm R M) (m : M) :
    ι Q m * ι Q m = algebraMap R (CliffordAlgebra Q) (Q m) :=
  CliffordAlgebra.ι_sq_scalar Q m

/-- **Polarization.** The symmetric (anticommutator) product of two embedded
vectors is the scalar given by the polar (bilinear) form of `Q`. This is the
algebraic inner product carried by the Clifford metric lift. -/
theorem clifford_metric_polar {M : Type u} [AddCommGroup M] [Module R M]
    (Q : QuadraticForm R M) (a b : M) :
    ι Q a * ι Q b + ι Q b * ι Q a
      = algebraMap R (CliffordAlgebra Q) (QuadraticMap.polar Q a b) :=
  CliffordAlgebra.ι_mul_ι_add_swap a b

end RequestProject.Math.Bridge
