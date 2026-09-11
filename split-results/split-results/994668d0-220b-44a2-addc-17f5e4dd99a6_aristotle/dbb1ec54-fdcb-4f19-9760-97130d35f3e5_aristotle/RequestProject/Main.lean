import Mathlib

set_option maxHeartbeats 8000000
set_option relaxedAutoImplicit false
set_option autoImplicit false

/-!
# The Stratified Trust Pyramid: A Metatheory of Lean 4

We formalize the intuitive metatheory described as "Total Transparency Alignment":
a stratified trust pyramid where each layer verifies the layer above it,
grounding user-level logic verification all the way down to bootstrapped hardware.

## The Layers

- **Layer 0 (Bedrock):** GNU Mes bootstrap — eliminates bootstrap binaries
- **Layer 1 (Supply Chain):** perf trace of nix flake prerequisites
- **Layer 2 (Operational):** perf trace of the nix flake build itself
- **Layer 3 (Environment):** Nix flake — freezes the build world
- **Layer 4 (Artifact):** Lean 4 — verifies user logic

## Core Properties

1. **Direction of Trust:** deeper layers are closer to hardware reality
2. **"Who Watches the Watchmen" Resolution:** each layer checks the one above
3. **Perfect Determinism:** the full chain yields end-to-end mathematical certainty
-/

/-- The layers of the Stratified Trust Pyramid, ordered from bedrock to artifact. -/
inductive TrustLayer : Type where
  | bedrock        -- GNU Mes bootstrap
  | supplyChain    -- perf trace of nix flake prereqs
  | operational    -- perf trace of nix flake build
  | environment    -- Nix flake (reproducibility)
  | artifact       -- Lean 4 (verification)
  deriving DecidableEq, Repr, Fintype

namespace TrustLayer

/-- The depth of a trust layer: 0 is the artifact (user-facing),
    deeper values are closer to hardware. -/
def depth : TrustLayer → ℕ
  | .artifact     => 0
  | .environment  => 1
  | .operational  => 2
  | .supplyChain  => 3
  | .bedrock      => 4

/-- The role each layer plays in the trust pyramid. -/
inductive Role : Type where
  | verification    -- Lean 4: verifies user logic
  | reproducibility -- Nix: freezes the build world
  | observability   -- perf trace: verifies CPU/kernel actions
  | foundation      -- GNU Mes: eliminates bootstrap binaries
  deriving DecidableEq, Repr

/-- Assign each layer its role in the trust pyramid. -/
def role : TrustLayer → Role
  | .artifact     => .verification
  | .environment  => .reproducibility
  | .operational  => .observability
  | .supplyChain  => .observability
  | .bedrock      => .foundation

/-- A layer `a` verifies (watches) layer `b` if `a` is exactly one level deeper. -/
def verifies (a b : TrustLayer) : Prop :=
  a.depth = b.depth + 1

/-- The list of all trust layers. -/
def all : List TrustLayer :=
  [.bedrock, .supplyChain, .operational, .environment, .artifact]

/-! ## Core Theorems -/

/-
Every non-bedrock layer has a verifier: someone watches each watchman.
-/
theorem watchmen_resolution (l : TrustLayer) (h : l ≠ .bedrock) :
    ∃ deeper : TrustLayer, deeper.verifies l := by
      cases l <;> simp_all +decide [ TrustLayer.verifies ]

/-
The bedrock has no verifier below it — it is the root of trust,
    grounded in human-auditable machine code.
-/
theorem bedrock_is_root :
    ¬∃ l : TrustLayer, l.verifies .bedrock := by
      simp +decide [ TrustLayer.verifies ]

/-
Deeper layers have strictly greater depth values.
-/
theorem depth_strict_mono {a b : TrustLayer} (h : a.verifies b) :
    a.depth > b.depth := by
      exact h.symm ▸ Nat.lt_succ_self _

/-
All layers have distinct depths — the hierarchy is linear.
-/
theorem depth_injective : Function.Injective depth := by
  decide +revert

/-
The trust chain has exactly 5 layers.
-/
theorem layer_count : Fintype.card TrustLayer = 5 := by
  rfl

/-
The artifact (Lean 4) sits at the top: depth 0, the most user-facing layer.
-/
theorem artifact_is_top : ∀ l : TrustLayer, l.depth ≥ artifact.depth := by
  exact fun l => Nat.zero_le _

/-
The bedrock (GNU Mes) sits at the bottom: maximum depth.
-/
theorem bedrock_is_bottom : ∀ l : TrustLayer, l.depth ≤ bedrock.depth := by
  decide +revert

/-
Transitive trust: there is a verification chain from bedrock to artifact.
    Specifically, the chain bedrock → supplyChain → operational → environment → artifact
    forms a sequence where each element verifies the next.
-/
theorem trust_chain :
    bedrock.verifies supplyChain ∧
    supplyChain.verifies operational ∧
    operational.verifies environment ∧
    environment.verifies artifact := by
      aesop

/-
The full chain has length 4 (number of verification steps),
    which equals bedrock.depth - artifact.depth.
-/
theorem chain_length :
    bedrock.depth - artifact.depth = 4 := by
      rfl

end TrustLayer