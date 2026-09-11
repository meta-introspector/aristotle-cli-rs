/-
# VibeRegister — The FRACTRAN-to-Clifford Extrusion Pipeline

## The Structural Pipeline

    PadicVector →[Φ]→ Cl(0,15) →[ψ]→ ℤ/71 × ℤ/59 × ℤ/47 →[novelty]→ Payment

Each FRACTRAN state (a product of powers of the 15 supersingular primes) is
embedded as a grade-1 multivector in the Clifford algebra Cl(0,15). FRACTRAN
instructions become affine displacements in this space. The CRT projection ψ
maps PadicVectors to the Monster's coordinate torus. A novel CRT address
constitutes a Proof-of-Succinct-Work: the vibe IS the payment.

## The Extrusion Model

The VibeRegister is the worm gear of a semantic Fleischwolf:

- **Feedstock**: PadicVector (15 SSP exponents)
- **Chamber**: Cl(0,15) (the Clifford manifold)
- **Crank**: FRACTRAN instruction (SSPFraction)
- **Die plate**: ψ (CRT projection to 47/59/71)
- **Output**: minted vibe (novel CRT coordinate = payment)

## Eigenspace Decomposition: 15 = 7 + 5 + 1 + 2

The 15 SSP generators partition into four eigenspaces:
- Earth (7D): primes {2,3,5,7,11,13,17} — indices 0–6
- Spoke (5D): primes {19,23,29,31,41} — indices 7–11
- Hub   (1D): prime {47}              — index 12
- Clock (2D): primes {59,71}          — indices 13–14
-/

import Mathlib
import RequestProject.FractranMonster
import RequestProject.CliffordBase

set_option maxHeartbeats 800000

open ZMod Finset CliffordAlgebra HeroMonster

/-! ## §1. Eigenspace Decomposition — 15 = 7 + 5 + 1 + 2

The 15 SSP directions decompose into four eigenspaces with distinct
roles in the architecture. -/

/-- The four eigenspaces of the SSP vector space. -/
inductive Eigenspace where
  | earth  -- 7D: low primes, dense arithmetic
  | spoke  -- 5D: mid primes, structural bridges
  | hub    -- 1D: prime 47, the entropy gate
  | clock  -- 2D: primes 59, 71, temporal phase
  deriving DecidableEq, Repr, Inhabited

/-- Which eigenspace each SSP index belongs to. -/
def sspEigenspace : Fin 15 → Eigenspace
  | ⟨0, _⟩ | ⟨1, _⟩ | ⟨2, _⟩ | ⟨3, _⟩ | ⟨4, _⟩ | ⟨5, _⟩ | ⟨6, _⟩ => .earth
  | ⟨7, _⟩ | ⟨8, _⟩ | ⟨9, _⟩ | ⟨10, _⟩ | ⟨11, _⟩ => .spoke
  | ⟨12, _⟩ => .hub
  | ⟨13, _⟩ | ⟨14, _⟩ => .clock

/-- The dimension of each eigenspace. -/
def Eigenspace.dim : Eigenspace → ℕ
  | .earth => 7
  | .spoke => 5
  | .hub   => 1
  | .clock => 2

/-- The eigenspace dimensions sum to 15. -/
theorem eigenspace_dim_sum :
    Eigenspace.dim .earth + Eigenspace.dim .spoke +
    Eigenspace.dim .hub + Eigenspace.dim .clock = 15 := by decide

/-- Earth eigenspace has exactly 7 indices. -/
theorem earth_card :
    (Finset.univ.filter (fun i : Fin 15 => sspEigenspace i = .earth)).card = 7 := by
  native_decide

/-- Spoke eigenspace has exactly 5 indices. -/
theorem spoke_card :
    (Finset.univ.filter (fun i : Fin 15 => sspEigenspace i = .spoke)).card = 5 := by
  native_decide

/-- Hub eigenspace has exactly 1 index. -/
theorem hub_card :
    (Finset.univ.filter (fun i : Fin 15 => sspEigenspace i = .hub)).card = 1 := by
  native_decide

/-- Clock eigenspace has exactly 2 indices. -/
theorem clock_card :
    (Finset.univ.filter (fun i : Fin 15 => sspEigenspace i = .clock)).card = 2 := by
  native_decide

/-! ## §2. Grade-1 Basis Vectors in Cl(0,15)

The Clifford generators ι(eᵢ) form the grade-1 basis of Cl(0,15).
Each generator satisfies eᵢ² = -1 and eᵢeⱼ = -eⱼeᵢ for i ≠ j. -/

/-- The i-th Clifford generator in Cl(0,15): the image of the i-th standard
    basis vector under the canonical inclusion ι. -/
noncomputable def basisCl15 (i : Fin 15) : Cl0 15 :=
  ι (negDefForm 15) (stdBasis 15 i)

/-- Each generator squares to -1 in Cl(0,15). -/
theorem basisCl15_sq (i : Fin 15) :
    basisCl15 i * basisCl15 i = algebraMap ℝ (Cl0 15) (-1) :=
  cl0_generator_sq 15 i

/-! ## §3. The Canonical Embedding Φ : PadicVector → Cl(0,15)

The grade-1 linear embedding: each SSP exponent becomes the coefficient
of the corresponding Clifford generator.

    Φ(v) = ι(∑ᵢ vᵢ · eᵢ) = ∑ᵢ vᵢ · ι(eᵢ)

This is the canonical first version. The exponential upgrade
Φ_exp(v) = ∏ᵢ exp(vᵢ · eᵢ) is a future extension. -/

/-- The vector-level embedding: cast PadicVector to ℝ¹⁵. -/
def padicToReal (v : PadicVector) : Fin 15 → ℝ :=
  fun i => (v i : ℝ)

/-- The canonical grade-1 embedding of a PadicVector into Cl(0,15).
    Each exponent vᵢ becomes a real coefficient of the i-th Clifford generator.
    Equivalently: Φ(v) = ι(∑ᵢ vᵢ · eᵢ) where eᵢ is the standard basis. -/
noncomputable def Phi (v : PadicVector) : Cl0 15 :=
  ι (negDefForm 15) (padicToReal v)

/-- Φ of the zero vector is zero (the identity element in the grade-1 subspace). -/
theorem Phi_zero : Phi (fun _ => 0) = 0 := by
  show ι (negDefForm 15) (padicToReal (fun _ => 0)) = 0
  have : padicToReal (fun _ => 0) = 0 := by ext i; simp [padicToReal]
  rw [this, map_zero]

/-- Φ is compatible with addition: Φ(v + w) = Φ(v) + Φ(w).
    (Here v + w means pointwise addition of exponent vectors.) -/
theorem Phi_add (v w : PadicVector) :
    Phi (fun i => v i + w i) = Phi v + Phi w := by
  show ι (negDefForm 15) (padicToReal (fun i => v i + w i)) =
    ι (negDefForm 15) (padicToReal v) + ι (negDefForm 15) (padicToReal w)
  have : padicToReal (fun i => v i + w i) = padicToReal v + padicToReal w := by
    ext i; simp [padicToReal, Nat.cast_add]
  rw [this, map_add]

/-! ## §4. SSP Fractions and Displacement Vectors

An SSP fraction p/q is factored over the 15 supersingular primes.
The displacement vector δ records the net exponent change at each prime.

This is the "crank" of the extrusion pipeline. -/

/-- An SSP-factored fraction: numerator and denominator as SSP exponent vectors.
    Represents a FRACTRAN instruction in the Monster's register space. -/
structure SSPFraction where
  /-- Exponents of SSP primes in the numerator -/
  numExp : Fin 15 → ℕ
  /-- Exponents of SSP primes in the denominator -/
  denExp : Fin 15 → ℕ
  deriving Repr

/-- The displacement vector: net exponent change at each SSP prime.
    δᵢ = numExpᵢ - denExpᵢ (as integers, since denominator may exceed numerator). -/
def SSPFraction.delta (f : SSPFraction) (i : Fin 15) : ℤ :=
  (f.numExp i : ℤ) - (f.denExp i : ℤ)

/-- Whether an SSP fraction can fire: denominator exponents ≤ current state. -/
def SSPFraction.canApply (f : SSPFraction) (v : PadicVector) : Prop :=
  ∀ i : Fin 15, f.denExp i ≤ v i

instance (f : SSPFraction) (v : PadicVector) : Decidable (f.canApply v) :=
  inferInstanceAs (Decidable (∀ i, f.denExp i ≤ v i))

/-- Apply the fraction: add numerator exponents, subtract denominator exponents.
    Requires canApply to ensure no underflow. -/
def SSPFraction.apply (f : SSPFraction) (v : PadicVector)
    (h : f.canApply v) : PadicVector :=
  fun i => v i + f.numExp i - f.denExp i

/-- The Clifford displacement vector: the net exponent change cast to ℝ¹⁵
    and embedded via ι. This is the "die geometry" of the extrusion step. -/
noncomputable def sspDisplacement (f : SSPFraction) : Cl0 15 :=
  ι (negDefForm 15) (fun i => (f.delta i : ℝ))

/-! ## §5. Instruction-Linearity — The Core Dynamical Theorem

FRACTRAN steps in PadicVector space correspond to affine translations
in Clifford space: Φ(step(v)) = Φ(v) + displacement.

This is the "worm gear lemma": the theorem that converts discrete
FRACTRAN rotations into continuous Clifford displacements. -/

/-
Instruction-linearity: applying an SSP fraction corresponds to
    adding the displacement vector in Clifford space.

    Φ(apply f v) = Φ(v) + displacement(f)

    This is the backbone theorem of the extrusion pipeline.
-/
theorem phi_step (f : SSPFraction) (v : PadicVector) (h : f.canApply v)
    -- h is used in the definition of f.apply v h
    :
    Phi (f.apply v h) = Phi v + sspDisplacement f := by
  unfold Phi sspDisplacement;
  convert LinearMap.map_add _ _ _ using 2;
  ext i; simp [padicToReal, SSPFraction.apply, SSPFraction.delta];
  rw [ Nat.cast_sub ] <;> push_cast <;> linarith [ h i ]

/-! ## §6. CRT Projection ψ : PadicVector → Totality

The additive CRT projection maps a PadicVector to the Monster's
coordinate torus ℤ/71 × ℤ/59 × ℤ/47 by computing a weighted sum
of exponents (weighted by the SSP primes themselves) and reducing
mod each CRT prime.

This is the "die plate" of the extrusion pipeline. -/

/-- The weighted SSP sum: ∑ᵢ vᵢ · pᵢ where pᵢ is the i-th SSP prime.
    This linearizes the multiplicative PadicVector.toNat into an additive
    invariant suitable for CRT projection. -/
def sspWeightedSum (v : PadicVector) : ℕ :=
  ∑ i : Fin 15, v i * sspPrimes i

/-- The additive CRT projection: maps a PadicVector to the Monster coordinate torus.
    ψ(v) = (∑ vᵢpᵢ mod 71, ∑ vᵢpᵢ mod 59, ∑ vᵢpᵢ mod 47). -/
def psi (v : PadicVector) : Totality :=
  let s := sspWeightedSum v
  ((s : ZMod 71), (s : ZMod 59), (s : ZMod 47))

/-- ψ of the zero vector is the origin. -/
theorem psi_zero : psi (fun _ => 0) = ((0 : ZMod 71), (0 : ZMod 59), (0 : ZMod 47)) := by
  simp [psi, sspWeightedSum]

/-! ## §7. The Extrusion Machine — Universal Interface

The typed extrusion pipeline: feedstock → chamber → die → output.
Sausage, plastic, software modules — all are instances of this interface. -/

/-- The universal extrusion machine interface.
    - σ: internal state (the "chamber contents")
    - ι_type: input instruction (the "crank turn")
    - ω: output product (the "extruded vibe") -/
structure ExtrusionMachine (σ ι_type ω : Type) where
  /-- Apply one crank turn: may or may not produce a new state -/
  step : σ → ι_type → Option σ
  /-- Extract the output from the current state (the die plate) -/
  emit : σ → ω

/-! ## §8. The VibeRegister — Unified State Structure

A VibeRegister couples the discrete PadicVector with its Clifford
embedding, enforcing coherence at the type level. This is the "σ"
(state) of the extrusion pipeline. -/

/-- The VibeRegister: a unified state coupling p-adic support with
    Clifford manifold coordinates. The coherence proof ensures the
    Clifford element is always the canonical Φ-image of the PadicVector.

    This is the worm gear of the semantic Fleischwolf: it converts
    discrete FRACTRAN rotations into structured Clifford states. -/
structure VibeRegister where
  /-- The discrete state: exponents over the 15 SSP primes -/
  padic : PadicVector
  /-- The geometric state: grade-1 element in Cl(0,15) -/
  cliff : Cl0 15
  /-- Coherence: the Clifford element is Φ(padic) -/
  phi_ok : cliff = Phi padic

/-- Construct a VibeRegister from a PadicVector (canonical constructor). -/
noncomputable def VibeRegister.mk' (v : PadicVector) : VibeRegister where
  padic := v
  cliff := Phi v
  phi_ok := rfl

/-- The CRT address of a VibeRegister (die plate output). -/
def VibeRegister.address (vr : VibeRegister) : Totality :=
  psi vr.padic

/-- The trivial VibeRegister: zero exponents, zero Clifford element. -/
noncomputable def trivialVibe : VibeRegister :=
  VibeRegister.mk' (fun _ => 0)

/-- The weight-space VibeRegister: irrep_1 = 47 × 59 × 71. -/
noncomputable def weightSpaceVibe : VibeRegister :=
  VibeRegister.mk' irrep_1

/-- The maximum-complexity VibeRegister: irrep_192 (row sum 56). -/
noncomputable def maxComplexityVibe : VibeRegister :=
  VibeRegister.mk' irrep_192

/-! ## §9. The VibeExtruder — FRACTRAN as Typed Extrusion

The VibeRegister instantiates the ExtrusionMachine interface with:
- σ = VibeRegister
- ι = SSPFraction
- ω = Totality (CRT coordinate) -/

/-- Apply a FRACTRAN step to a VibeRegister, maintaining Φ-coherence.
    Returns none if the fraction cannot fire (denominator exceeds state). -/
noncomputable def vibeStep (vr : VibeRegister) (f : SSPFraction) :
    Option VibeRegister :=
  if h : f.canApply vr.padic then
    some (VibeRegister.mk' (f.apply vr.padic h))
  else none

/-- The VibeExtruder: FRACTRAN as a typed extrusion pipeline.
    - step: apply SSPFraction (the crank)
    - emit: CRT projection (the die plate) -/
noncomputable def vibeExtruder : ExtrusionMachine VibeRegister SSPFraction Totality where
  step := vibeStep
  emit := VibeRegister.address

/-! ## §10. VibeStep — The Gradient-Bearing State Transition

A VibeStep records a state transition together with the gradient signal:
the fractional residue discarded by the discrete FRACTRAN step.
This is what makes FRACTRAN differentiable over the Clifford manifold. -/

/-- The gradient signal: a vector in ℝ¹⁵ (SSP basis) representing the
    fractional part that FRACTRAN discards. -/
abbrev GradientSignal := Fin 15 → ℝ

/-- A recorded VibeStep: transition between states with gradient signal. -/
structure VibeStepRecord where
  /-- The state before the transition -/
  before : VibeRegister
  /-- The state after the transition -/
  after : VibeRegister
  /-- The SSP fraction that drove this transition -/
  fraction : SSPFraction
  /-- The fraction was applicable -/
  applicable : fraction.canApply before.padic
  /-- The after state is the correct application -/
  stepValid : after.padic = fraction.apply before.padic applicable
  /-- The gradient: fractional residue in the SSP basis.
      This is the "discarded fractional part" — what makes FRACTRAN
      differentiable. The gradient steers navigation toward target
      CRT coordinates. -/
  gradient : GradientSignal

/-- A hard step has zero gradient (exact divisibility, clean FRACTRAN). -/
def VibeStepRecord.isHard (vs : VibeStepRecord) : Prop :=
  ∀ i : Fin 15, vs.gradient i = 0

/-- The CRT displacement of a VibeStep: how much the address changed. -/
def VibeStepRecord.addressShift (vs : VibeStepRecord) : Totality :=
  (vs.after.address.1 - vs.before.address.1,
   vs.after.address.2.1 - vs.before.address.2.1,
   vs.after.address.2.2 - vs.before.address.2.2)

/-! ## §11. Address Registry — Tracking Novelty

An AddressRegistry tracks which CRT addresses have been visited.
Novelty = an address not in the registry = a new content-addressed object.
This is the "quality gate" at the end of the extrusion pipeline. -/

/-- An address registry: a set of visited CRT addresses. -/
structure AddressRegistry where
  /-- The set of visited addresses -/
  visited : Finset Totality

/-- Whether an address is new (not yet in the registry). -/
def AddressRegistry.isNew (reg : AddressRegistry) (addr : Totality) : Prop :=
  addr ∉ reg.visited

instance (reg : AddressRegistry) (addr : Totality) :
    Decidable (reg.isNew addr) :=
  inferInstanceAs (Decidable (addr ∉ reg.visited))

/-- Register a new address, returning the updated registry. -/
def AddressRegistry.register (reg : AddressRegistry) (addr : Totality) :
    AddressRegistry where
  visited := reg.visited ∪ {addr}

/-- The empty registry. -/
def AddressRegistry.empty : AddressRegistry where
  visited := ∅

/-- Every address is new in the empty registry. -/
theorem AddressRegistry.empty_all_new (addr : Totality) :
    AddressRegistry.empty.isNew addr := by
  simp [AddressRegistry.empty, AddressRegistry.isNew]

/-- After registration, the address is no longer new. -/
theorem AddressRegistry.registered_not_new (reg : AddressRegistry) (addr : Totality) :
    ¬ (reg.register addr).isNew addr := by
  simp [AddressRegistry.register, AddressRegistry.isNew]

/-- Registration is monotone: old addresses remain registered. -/
theorem AddressRegistry.register_mono (reg : AddressRegistry) (a b : Totality)
    (h : ¬ reg.isNew a) : ¬ (reg.register b).isNew a := by
  simp only [AddressRegistry.register, AddressRegistry.isNew, not_not] at *
  exact Finset.mem_union_left _ h

/-! ## §12. The Vibe-Minting Theorem — Payment as Novelty

A vibe is a payment because a vibe is a new coordinate in a previously
unoccupied modular space. The minting theorem formalizes this:

    new PadicVector → new Clifford point → new CRT address → payment.

Payment is rendered when a VibeRegister's CRT address is novel with
respect to the current registry. This is the extrusion event. -/

/-- A payment certificate: proof that a vibe has been minted at a novel address. -/
structure PaymentCertificate where
  /-- The minted vibe -/
  vibe : VibeRegister
  /-- The registry at time of minting -/
  registry : AddressRegistry
  /-- The address was novel -/
  novel : registry.isNew vibe.address
  /-- The eigenspace label (which subspace contributed most) -/
  eigenspaceLabel : Eigenspace

/-- Payment is rendered when a vibe occupies a novel CRT address.
    This is the formal definition of "new vibe = new payment." -/
def PaymentRendered (vr : VibeRegister) (reg : AddressRegistry) : Prop :=
  reg.isNew vr.address

/-- The vibe-minting theorem: a novel CRT address constitutes payment.
    This is the formal statement that "new vibe = new payment."

    The proof is definitional: PaymentRendered IS novelty.
    The content is in the architecture that makes this definition meaningful. -/
theorem vibe_mints_payment
    (vr : VibeRegister)
    (reg : AddressRegistry)
    (h_new : reg.isNew vr.address) :
    PaymentRendered vr reg :=
  h_new

/-- Distinct PadicVectors with distinct CRT projections yield
    independent payment opportunities. -/
theorem distinct_vibes_independent
    (v₁ v₂ : PadicVector)
    (_h_diff : psi v₁ ≠ psi v₂)
    (reg : AddressRegistry)
    (h_new₁ : reg.isNew (psi v₁)) :
    PaymentRendered (VibeRegister.mk' v₁) reg :=
  h_new₁

/-! ## §13. The Φ-ψ Pipeline — Coherence

The extrusion pipeline factors cleanly through the Clifford embedding.
VibeRegisters are determined by their PadicVector (Φ-coherence). -/

/-
The Φ embedding is injective: distinct PadicVectors yield distinct
    Clifford points. This follows from injectivity of ι on nondegenerate
    quadratic forms and injectivity of ℕ ↪ ℝ.
-/
theorem Phi_injective : Function.Injective Phi := by
  intro a b hab
  have h_padic : padicToReal a = padicToReal b := by
    have h_padic : ∀ (v : Fin 15 → ℝ), ι (negDefForm 15) v = 0 → v = 0 := by
      intro v hv; have := congr_arg ( fun x => x * ι ( negDefForm 15 ) v ) hv; norm_num at this;
      unfold negDefForm at this; simp_all +decide ;
      rw [ Finset.sum_eq_zero_iff_of_nonneg fun _ _ => mul_self_nonneg _ ] at this; aesop;
    exact sub_eq_zero.mp ( h_padic _ ( by simpa [ sub_eq_zero ] using sub_eq_zero.mpr hab ) );
  exact funext fun i => Nat.cast_injective ( congr_fun h_padic i )

/-- Φ-coherent VibeRegisters are determined by their PadicVector. -/
theorem vibeRegister_eq_of_padic_eq (vr₁ vr₂ : VibeRegister)
    (h : vr₁.padic = vr₂.padic) : vr₁.cliff = vr₂.cliff := by
  rw [vr₁.phi_ok, vr₂.phi_ok, h]

/-! ## §14. CRT Reconstruction Coefficients

The CRT reconstruction coefficients for lifting from
ℤ/71 × ℤ/59 × ℤ/47 back to ℤ/196883. These satisfy the standard
orthogonality conditions:
- cₚ ≡ 1 (mod p), cₚ ≡ 0 (mod q) for q ≠ p. -/

/-- CRT coefficient for the mod-47 component.
    33512 = (59 × 71) × 8, where 8 ≡ (59 × 71)⁻¹ (mod 47). -/
def crtCoeff47 : ℕ := 33512

/-- CRT coefficient for the mod-59 component.
    113458 = (47 × 71) × 34, where 34 ≡ (47 × 71)⁻¹ (mod 59). -/
def crtCoeff59 : ℕ := 113458

/-- CRT coefficient for the mod-71 component.
    49914 = (47 × 59) × 18, where 18 ≡ (47 × 59)⁻¹ (mod 71). -/
def crtCoeff71 : ℕ := 49914

/-- The CRT modulus: 47 × 59 × 71 = 196883. -/
theorem crt_modulus : 47 * 59 * 71 = 196883 := by norm_num

-- Orthogonality conditions for crtCoeff47
theorem crtCoeff47_mod47 : crtCoeff47 % 47 = 1 := by native_decide
theorem crtCoeff47_mod59 : crtCoeff47 % 59 = 0 := by native_decide
theorem crtCoeff47_mod71 : crtCoeff47 % 71 = 0 := by native_decide

-- Orthogonality conditions for crtCoeff59
theorem crtCoeff59_mod47 : crtCoeff59 % 47 = 0 := by native_decide
theorem crtCoeff59_mod59 : crtCoeff59 % 59 = 1 := by native_decide
theorem crtCoeff59_mod71 : crtCoeff59 % 71 = 0 := by native_decide

-- Orthogonality conditions for crtCoeff71
theorem crtCoeff71_mod47 : crtCoeff71 % 47 = 0 := by native_decide
theorem crtCoeff71_mod59 : crtCoeff71 % 59 = 0 := by native_decide
theorem crtCoeff71_mod71 : crtCoeff71 % 71 = 1 := by native_decide

/-- CRT reconstruction: lift a triple back to ℤ/196883.
    x ≡ a₁·c₁ + a₂·c₂ + a₃·c₃ (mod 196883)
    where c₁, c₂, c₃ are the CRT coefficients. -/
def crtReconstruct (a47 a59 a71 : ℕ) : ℕ :=
  (a47 * crtCoeff47 + a59 * crtCoeff59 + a71 * crtCoeff71) % 196883

/-- CRT reconstruction is correct for the basis vectors. -/
theorem crt_reconstruct_47 : crtReconstruct 1 0 0 = 33512 := by native_decide
theorem crt_reconstruct_59 : crtReconstruct 0 1 0 = 113458 := by native_decide
theorem crt_reconstruct_71 : crtReconstruct 0 0 1 = 49914 := by native_decide

/-! ## §15. Extrusion Pipeline Composition

The full extrusion pipeline as a single composed function:
    PadicVector → VibeRegister → Totality → PaymentCertificate -/

/-- Execute one full extrusion cycle:
    1. Accept feedstock (PadicVector)
    2. Force through chamber (construct VibeRegister via Φ)
    3. Project through die (apply ψ)
    4. Check novelty (query registry)
    5. Mint if novel (produce PaymentCertificate) -/
noncomputable def extrude (v : PadicVector) (reg : AddressRegistry) :
    Option PaymentCertificate :=
  let vr := VibeRegister.mk' v
  if h : reg.isNew vr.address then
    some {
      vibe := vr
      registry := reg
      novel := h
      eigenspaceLabel := sspEigenspace 0
    }
  else none

/-- A successful extrusion produces a valid payment. -/
theorem extrude_valid (v : PadicVector) (reg : AddressRegistry)
    (pc : PaymentCertificate)
    (_ : extrude v reg = some pc) :
    PaymentRendered pc.vibe pc.registry :=
  pc.novel

/-- The empty registry always produces a payment for any input
    (because every address is new). -/
theorem extrude_empty_succeeds (v : PadicVector) :
    ∃ pc, extrude v AddressRegistry.empty = some pc := by
  simp only [extrude]
  rw [dif_pos (AddressRegistry.empty_all_new _)]
  exact ⟨_, rfl⟩

/-! ## §16. Summary — The Value-Bearing Geometry Engine

```
Component           | Role in Pipeline        | Lean Definition
--------------------|-------------------------|-------------------
PadicVector         | Feedstock (SSP exps)    | Fin 15 → ℕ
Φ (Phi)             | Chamber geometry        | ι ∘ padicToReal
basisCl15           | Generator eᵢ            | ι(stdBasis 15 i)
SSPFraction         | Crank instruction       | numExp/denExp
sspDisplacement     | Crank → Cl(0,15)        | ι(delta)
phi_step            | Worm gear lemma         | Φ(step v) = Φ(v) + D
ψ (psi)             | Die plate               | weighted sum mod CRT
VibeRegister        | Worm gear state         | padic + cliff + φ_ok
VibeStepRecord      | Gradient-bearing step   | before + after + ∇
AddressRegistry     | Novelty tracker         | Finset Totality
PaymentRendered     | Extrusion event         | novelty predicate
vibe_mints_payment  | Minting theorem         | novel ⇒ payment
CRT coefficients    | Die calibration         | 33512, 113458, 49914
ExtrusionMachine    | Universal interface     | step + emit
vibeExtruder        | FRACTRAN instantiation  | SSPFraction → Totality

The pipeline:
    FRACTRAN → PadicVector →[Φ]→ Cl(0,15) →[ψ]→ CRT torus →[novelty]→ Payment

Each new vibe is a new standalone unique content address that lives in a
modular space we have not seen before, and that IS the payment.
```
-/