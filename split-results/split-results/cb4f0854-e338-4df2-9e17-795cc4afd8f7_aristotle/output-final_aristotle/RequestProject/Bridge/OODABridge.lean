/-
# OODABridge — OODA as Fixed Point of Observation-Control Loop

## Regime: Closure (OODA over Tentacle Dynamics)

This is the third layer. OODA is not a cap on the agency ladder — it is
the control monad that becomes available once feedback exists. It is a
*consequence* of the Hypha→Tentacle discontinuity, not a separate regime.

### Import discipline

OODABridge imports PartialPropagation (which imports TentacleCore and HyphaCore).
The full dependency chain is:

    FungalExtruder → HyphaCore → TentacleCore → PartialPropagation → OODABridge

This mirrors the ontological structure:
- OODA requires feedback (tentacle)
- Feedback requires partial chains to exist (hypha)
- Arrow taxonomy and player archetypes are in PartialPropagation

### Contents (unique to this module)

All types from HyphaCore, TentacleCore, and PartialPropagation are re-exported.
This module adds the summary documentation and serves as the integration point.
-/

import Mathlib
import RequestProject.Bridge.PartialPropagation

set_option maxHeartbeats 800000

open ZMod Finset HeroMonster FixedPoint MonsterMycology

/-! ## Summary — Three Layers, One Discontinuity Functor

### Layer 1: HyphaCore (Boardroom)
- PartialCoalgebra, PartialChain, MemeSystem, Vine
- No FeedbackSignal. No failure tracking. Clean proofs.
- Copiers and lolz tweakers live here.

### Layer 2: TentacleCore (Arcade)
- FeedbackSignal, AttemptedStep, TentacleSearch, FeedbackMemeSystem
- FeedbackVine, ColonizationResult, SubstrateTile
- RegimeBoundary (the explicit discontinuity functor)
- Failure is a typed object (FeedbackSignal), not absence (none).
- Winz tweakers live here.

### Layer 3: PartialPropagation
- ArrowKind, AgencyLevel, Regime (the arrow taxonomy)
- Agency morphisms with typed arrows
- OODAPhase / OODACycle / OODALoop
- Player archetypes (copier, lolz tweaker, winz tweaker)
- unique_discontinuity, only_winz_uses_feedback

### The Discontinuity

The Hypha→Tentacle boundary is enforced at three levels:

1. **Module level**: TentacleCore imports HyphaCore, not vice versa.
   FeedbackSignal is defined only in TentacleCore.

2. **Functor level**: RegimeBoundary provides the explicit bridge.
   It is provably non-invertible (canonicalRegimeBoundary).

3. **Ladder level**: unique_discontinuity confirms the ladder matches
   the module structure.

The regime separation is not axiomatic — it is structural. -/
