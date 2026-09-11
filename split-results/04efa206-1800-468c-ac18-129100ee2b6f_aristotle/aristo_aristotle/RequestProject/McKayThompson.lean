/-
# McKay-Thompson Series

For a finite group G acting on a ℤ-graded module K = ⊕ₙ Kₙ via
finite-dimensional representations, the McKay-Thompson series of g ∈ G is
  T_g(τ) = Σₙ tr(g | Kₙ) · qⁿ
where q = e^{2πiτ}. This is a formal power series in q whose coefficients
are traces of the group action on each graded piece.
McKay-Thompson series are the bridge between representation theory and
modular forms in moonshine phenomena.
-/
import Mathlib

namespace McKayThompsonNS

open scoped BigOperators
/-! ## Graded Representations -/
/-- A ℕ-graded representation of a group G over a commutative semiring k.
This packages a sequence of finite-dimensional free representations
indexed by natural numbers. -/
structure GradedRepresentation (k : Type*) [CommSemiring k]
    (G : Type*) [Monoid G] where
  /-- The underlying type of each graded piece -/
  space : ℕ → Type
  /-- Each graded piece is an additive commutative group -/
  [addCommGroup : ∀ n, AddCommGroup (space n)]
  /-- Each graded piece is a k-module -/
  [module : ∀ n, Module k (space n)]
  /-- Each graded piece is a free module -/
  [free : ∀ n, Module.Free k (space n)]
  /-- Each graded piece is finite-dimensional -/
  [finite : ∀ n, Module.Finite k (space n)]
  /-- The representation on each graded piece -/
  action : ∀ n, Representation k G (space n)
attribute [instance] GradedRepresentation.addCommGroup
  GradedRepresentation.module GradedRepresentation.free
  GradedRepresentation.finite
/-! ## McKay-Thompson Series -/
/-- The McKay-Thompson series of an element g in a group G acting on a
ℕ-graded module via finite-dimensional representations.
The n-th coefficient is `tr(ρₙ(g))`, the trace of g acting on the
n-th graded piece. This is a formal power series in `PowerSeries k`. -/
noncomputable def McKayThompsonSeries {k : Type*} [CommSemiring k]
    {G : Type*} [Monoid G]
    (K : GradedRepresentation k G) (g : G) : PowerSeries k :=
  PowerSeries.mk fun n => (LinearMap.trace k (K.space n)) (K.action n g)
/-- The n-th coefficient of the McKay-Thompson series is the trace of g
on the n-th graded piece. -/
theorem McKayThompsonSeries_coeff {k : Type*} [CommSemiring k]
    {G : Type*} [Monoid G]
    (K : GradedRepresentation k G) (g : G) (n : ℕ) :
    (PowerSeries.coeff n) (McKayThompsonSeries K g) =
      (LinearMap.trace k (K.space n)) (K.action n g) := by
  simp [McKayThompsonSeries, PowerSeries.coeff_mk]
/-- McKay-Thompson series are class functions: conjugate elements have
the same series. This follows from the conjugation-invariance of the trace. -/
theorem McKayThompsonSeries_conj {k : Type*} [CommRing k]
    {G : Type*} [Group G]
    (K : GradedRepresentation k G) (g h : G) :
    McKayThompsonSeries K (h * g * h⁻¹) = McKayThompsonSeries K g := by
  ext n
  convert LinearMap.trace_conj k (K.action n g)
    (Representation.asGroupHom (K.action n) h) using 1
  · unfold McKayThompsonSeries
    simp +decide [mul_assoc, Representation.asGroupHom]
    congr
  · exact McKayThompsonSeries_coeff K g n
/-! ## Assembly Lemma
The key logical step: if we have representations for each graded piece
whose traces match given Fourier coefficients, we can assemble them
into a graded module whose McKay-Thompson series equals the target. -/
/-- **Assembly Lemma**: Given representations for each graded piece whose
traces match the Fourier coefficients of a power series, we can assemble
them into a graded representation whose McKay-Thompson series equals that
power series.
This captures the final step of the Duncan-Griffin-Ono proof: once we know
that the Fourier coefficients define genuine characters (not just virtual
characters), we can construct the graded module. -/
theorem graded_assembly {G : Type} [Group G] [Fintype G]
    (f : G → PowerSeries ℂ)
    (hmult : ∀ n, ∃ (V : Type) (_ : AddCommGroup V) (_ : Module ℂ V)
      (_ : Module.Finite ℂ V) (_ : Module.Free ℂ V)
      (ρ : Representation ℂ G V),
      ∀ g : G, (LinearMap.trace ℂ V) (ρ g) = (PowerSeries.coeff n) (f g)) :
    ∃ K : GradedRepresentation ℂ G, ∀ g, McKayThompsonSeries K g = f g := by
  choose V instACG instMod instFin instFree ρ hρ using hmult
  exact ⟨⟨V, ρ⟩, fun g => PowerSeries.ext fun n => by
    simp [McKayThompsonSeries_coeff, hρ n g]⟩

end McKayThompsonNS
