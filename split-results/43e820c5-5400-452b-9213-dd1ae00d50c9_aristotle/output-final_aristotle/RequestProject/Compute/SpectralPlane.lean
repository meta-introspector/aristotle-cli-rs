import RequestProject.Math.UnivalentCore

/-!
# The spectral plane: 2D weight coordinates with origin non-occupancy

Spectral data is laid out on a 2D plane of **exact rational** coordinates so
that geometric predicates stay decidable (no real-number incomputability). The
central safety property is **origin non-occupancy**: no genuine spectral weight
is allowed to land on the origin `(0,0)`, which would correspond to a degenerate
/ unphysical mode.
-/

namespace RequestProject.Compute

/-- A point of the spectral plane, with exact rational coordinates. -/
structure SpectralPoint where
  re : ℚ
  im : ℚ
  deriving DecidableEq, Repr

/-- The origin of the spectral plane. -/
def SpectralPoint.origin : SpectralPoint := ⟨0, 0⟩

/-- A point **occupies the origin** when both coordinates vanish. -/
def SpectralPoint.atOrigin (p : SpectralPoint) : Prop := p = SpectralPoint.origin

instance (p : SpectralPoint) : Decidable p.atOrigin := by
  unfold SpectralPoint.atOrigin; infer_instance

/-- A concrete family of spectral weights placed on a unit-spaced lattice, with
the `(i+1)`-th harmonic carrying a nonzero real part. -/
def weightSite (i : ℕ) : SpectralPoint := ⟨(i : ℚ) + 1, (i : ℚ) / 2⟩

/-- **Origin non-occupancy.** Every weight site avoids the origin: its real part
is at least `1`, so it can never be the degenerate mode. -/
theorem weightSite_off_origin (i : ℕ) : ¬ (weightSite i).atOrigin := by
  unfold SpectralPoint.atOrigin SpectralPoint.origin weightSite
  intro h
  have : (i : ℚ) + 1 = 0 := congrArg SpectralPoint.re h
  have hi : (0 : ℚ) ≤ (i : ℚ) := by positivity
  linarith

/-- The first eight weight sites are pairwise distinct: the layout is injective
on the lattice, so no two harmonics collide. -/
theorem weightSite_injective {i j : ℕ} (h : weightSite i = weightSite j) : i = j := by
  have : (i : ℚ) + 1 = (j : ℚ) + 1 := congrArg SpectralPoint.re h
  have : (i : ℚ) = (j : ℚ) := by linarith
  exact_mod_cast this

end RequestProject.Compute
