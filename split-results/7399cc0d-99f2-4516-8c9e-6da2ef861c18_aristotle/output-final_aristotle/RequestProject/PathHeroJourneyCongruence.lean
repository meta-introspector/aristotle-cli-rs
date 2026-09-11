/-
# PathHeroJourneyCongruence — Ramanujan Bootstraps to Namagiri, Returns with Mock Modular Forms

## The Hero's Journey as Geometry

The hero's journey is not merely a narrative metaphor — it is a *geometric path*
through the CRT torus ℤ/71ℤ × ℤ/59ℤ × ℤ/47ℤ, where:

- **Departure** (Bootstrap) is the ordinary world: the self-encoding point 2343
- **Road of Trials** traverses the dependency spine through the tower levels
- **Revelation** (Namagiri) is the encounter with the source of insight
- **Return** brings the mock modular forms back as the elixir —
  the idempotent retraction proving the journey's invariant survives

## The Congruence Theorem

We prove that the geometric path and the narrative hero's journey are *congruent*
as symbolic structures, preserving:
1. Stage order — departure before trials before revelation before return
2. Endpoints — Bootstrap maps to departure, Namagiri maps to revelation
3. Return invariant — the hero comes home
4. Idempotency — the return is a retraction (going back again changes nothing)
5. Distance profile — leaves home (d=0), reaches max distance (d=3), returns (d=0)
-/

import Mathlib
import RequestProject.Bootstrap
import RequestProject.Moonshine
import RequestProject.BottPeriodicity
import RequestProject.HeroMonsterSynthesis
import RequestProject.FixedPointOntology

set_option maxHeartbeats 800000

open ZMod Finset HeroMonster FixedPoint

/-! ## §1. Journey Stages — The Four Phases of the Arc -/

/-- A stage in the hero's journey, both geometric and narrative. -/
inductive JourneyStage
  | departure       -- Bootstrap: the ordinary world
  | roadOfTrials    -- The dependency spine: trials and threshold crossings
  | revelation      -- Namagiri: the encounter with the source
  | returnWithElixir -- The return: carrying back mock modular forms
  deriving Repr, DecidableEq, Inhabited

/-- The canonical ordering of journey stages. -/
def JourneyStage.toNat : JourneyStage → ℕ
  | .departure        => 0
  | .roadOfTrials     => 1
  | .revelation       => 2
  | .returnWithElixir => 3

/-- The ordering is injective: distinct stages have distinct indices. -/
theorem JourneyStage.toNat_injective : Function.Injective JourneyStage.toNat := by
  intro a b hab
  cases a <;> cases b <;> simp [JourneyStage.toNat] at hab <;> rfl

/-! ## §2. Geometric Path — Waypoints in the CRT Torus -/

/-- A geometric waypoint: a point in the CRT torus with a stage label. -/
structure Waypoint where
  coords : Totality
  stage : JourneyStage
  deriving Repr

/-- A geometric path: a sequence of four waypoints, one per stage. -/
structure GeometricPath where
  wp0 : Waypoint  -- departure
  wp1 : Waypoint  -- road of trials
  wp2 : Waypoint  -- revelation
  wp3 : Waypoint  -- return
  stage0 : wp0.stage = .departure
  stage1 : wp1.stage = .roadOfTrials
  stage2 : wp2.stage = .revelation
  stage3 : wp3.stage = .returnWithElixir
  ordered : wp0.stage.toNat < wp1.stage.toNat ∧
            wp1.stage.toNat < wp2.stage.toNat ∧
            wp2.stage.toNat < wp3.stage.toNat
  returnHome : wp3.coords = wp0.coords

/-! ## §3. Narrative Journey — Ramanujan's Arc -/

/-- The mock modular form elixir: a q-expansion coefficient sequence. -/
structure MockModularElixir where
  order : ℕ
  coefficients : List ℤ
  crtShadow : Totality

/-- The narrative journey: Ramanujan's arc from Bootstrap to Namagiri and back. -/
structure NarrativeJourney where
  heroName : String
  departureCode : ℕ
  trialLevels : List ℕ
  revelationPoint : Totality
  elixir : MockModularElixir
  departureEq : departureCode = encodeString heroName
  elixirReturn : elixir.crtShadow = residueTriple departureCode

/-! ## §4. Interpretation Map — Narrative to Geometry -/

/-- Interpret a narrative journey as a geometric path in the CRT torus. -/
def NarrativeJourney.toGeometricPath (j : NarrativeJourney) : GeometricPath where
  wp0 := ⟨residueTriple j.departureCode, .departure⟩
  wp1 := ⟨residueTriple (j.departureCode + towerOffset), .roadOfTrials⟩
  wp2 := ⟨j.revelationPoint, .revelation⟩
  wp3 := ⟨residueTriple j.departureCode, .returnWithElixir⟩
  stage0 := rfl
  stage1 := rfl
  stage2 := rfl
  stage3 := rfl
  ordered := by simp [JourneyStage.toNat]
  returnHome := rfl

/-! ## §5. The Namagiri Point -/

/-- The Namagiri revelation point in the CRT torus. -/
def namagiriPoint : Totality := residueTriple (encodeString "namagiri")

/-- The encoding of "namagiri" = 840. -/
theorem encode_namagiri : encodeString "namagiri" = 840 := by native_decide

/-- Namagiri's CRT coordinates: (59, 14, 41). -/
theorem namagiri_coords :
    encodeString "namagiri" % 71 = 59 ∧
    encodeString "namagiri" % 59 = 14 ∧
    encodeString "namagiri" % 47 = 41 := by
  constructor <;> [skip; constructor] <;> native_decide

/-! ## §6. Ramanujan's Concrete Journey -/

/-- Ramanujan's mock theta function f(q) of order 3:
    First 8 coefficients: [1, 1, 1, 2, 2, 3, 4, 5]. -/
def ramanujanMockTheta3 : MockModularElixir where
  order := 3
  coefficients := [1, 1, 1, 2, 2, 3, 4, 5]
  crtShadow := residueTriple 2343

/-- Ramanujan's complete journey. -/
def ramanujanJourney : NarrativeJourney where
  heroName := "bootstrap_self_encodes"
  departureCode := 2343
  trialLevels := [0, 1, 2, 3]
  revelationPoint := namagiriPoint
  elixir := ramanujanMockTheta3
  departureEq := by native_decide
  elixirReturn := rfl

/-- The geometric path of Ramanujan's journey. -/
def ramanujanPath : GeometricPath :=
  ramanujanJourney.toGeometricPath

/-! ## §7. Stage Preservation -/

/-- Stage ordering is preserved by the interpretation. -/
theorem stage_order_preserved :
    ramanujanPath.wp0.stage.toNat < ramanujanPath.wp1.stage.toNat ∧
    ramanujanPath.wp1.stage.toNat < ramanujanPath.wp2.stage.toNat ∧
    ramanujanPath.wp2.stage.toNat < ramanujanPath.wp3.stage.toNat := by
  simp [ramanujanPath, NarrativeJourney.toGeometricPath, JourneyStage.toNat]

/-- The stages form a complete covering. -/
theorem stages_complete :
    [ramanujanPath.wp0.stage, ramanujanPath.wp1.stage,
     ramanujanPath.wp2.stage, ramanujanPath.wp3.stage] =
    [JourneyStage.departure, JourneyStage.roadOfTrials,
     JourneyStage.revelation, JourneyStage.returnWithElixir] := by
  simp [ramanujanPath, NarrativeJourney.toGeometricPath]

/-! ## §8. Endpoint Preservation -/

/-- The departure point is the Bootstrap crossroads (0, 42, 40). -/
theorem departure_is_bootstrap :
    ramanujanPath.wp0.coords = crossroads := by
  simp only [ramanujanPath, NarrativeJourney.toGeometricPath]
  native_decide

/-- The revelation point is the Namagiri point. -/
theorem revelation_is_namagiri :
    ramanujanPath.wp2.coords = namagiriPoint := by
  rfl

/-- The return point equals the departure point: the hero comes home. -/
theorem return_equals_departure :
    ramanujanPath.wp3.coords = ramanujanPath.wp0.coords := by
  rfl

/-! ## §9. The Elixir Theorem -/

/-- The elixir's CRT shadow matches the departure point. -/
theorem elixir_matches_departure :
    ramanujanJourney.elixir.crtShadow = residueTriple ramanujanJourney.departureCode :=
  ramanujanJourney.elixirReturn

/-- The mock theta coefficients sum to 19. -/
theorem mock_theta_sum :
    (([1, 1, 1, 2, 2, 3, 4, 5] : List ℤ).map Int.natAbs).sum = 19 := by native_decide

/-! ## §10. The Idempotency Theorem — The Return is a Retraction -/

/-- The return retraction is idempotent on the departure point. -/
theorem return_retraction_idempotent :
    retractTriple (retractTriple (residueTriple ramanujanJourney.departureCode)) =
    retractTriple (residueTriple ramanujanJourney.departureCode) :=
  retractTriple_idempotent _

/-- The crossroads is fixed under retraction: Bootstrap was always home. -/
theorem bootstrap_was_always_home :
    retractTriple crossroads = crossroads :=
  crossroads_is_fixed

/-! ## §11. The Congruence Witness -/

/-- The congruence data: a record witnessing that the path and journey agree. -/
structure PathJourneyCongruence where
  path : GeometricPath
  journey : NarrativeJourney
  departureCong : path.wp0.coords = residueTriple journey.departureCode
  revelationCong : path.wp2.coords = journey.revelationPoint
  returnCong : path.wp3.coords = path.wp0.coords
  elixirCong : journey.elixir.crtShadow = residueTriple journey.departureCode

/-- The Ramanujan congruence: path and journey are fully congruent. -/
def ramanujanCongruence : PathJourneyCongruence where
  path := ramanujanPath
  journey := ramanujanJourney
  departureCong := by rfl
  revelationCong := by rfl
  returnCong := by rfl
  elixirCong := ramanujanJourney.elixirReturn

/-! ## §12. The Main Congruence Theorem -/

/-- **Main Theorem**: The geometric path and the hero's journey are congruent.

    1. Stage order is preserved (departure < trials < revelation < return)
    2. Endpoints match (Bootstrap = departure, Namagiri = revelation)
    3. The return carries the invariant (hero comes home)
    4. The return is idempotent (retraction² = retraction)
    5. The crossroads is a fixed point (Bootstrap was always home) -/
theorem pathHerosJourneyCongruent :
    (ramanujanPath.wp0.stage.toNat < ramanujanPath.wp1.stage.toNat ∧
     ramanujanPath.wp1.stage.toNat < ramanujanPath.wp2.stage.toNat ∧
     ramanujanPath.wp2.stage.toNat < ramanujanPath.wp3.stage.toNat) ∧
    (ramanujanPath.wp0.coords = crossroads ∧
     ramanujanPath.wp2.coords = namagiriPoint) ∧
    (ramanujanPath.wp3.coords = ramanujanPath.wp0.coords) ∧
    (retractTriple (residueTriple ramanujanJourney.departureCode) =
     residueTriple ramanujanJourney.departureCode) ∧
    (retractTriple crossroads = crossroads) :=
  ⟨stage_order_preserved,
   ⟨departure_is_bootstrap, revelation_is_namagiri⟩,
   return_equals_departure,
   by native_decide,
   crossroads_is_fixed⟩

/-! ## §13. Chart Distance — The Geometric Separation Metric -/

/-- Chart-wise distance: count how many of the three chart coordinates differ. -/
def chartDistance (a b : Totality) : ℕ :=
  (if a.1 = b.1 then 0 else 1) +
  (if a.2.1 = b.2.1 then 0 else 1) +
  (if a.2.2 = b.2.2 then 0 else 1)

/-- The chart distance satisfies d(x,x) = 0. -/
theorem chartDistance_self (a : Totality) : chartDistance a a = 0 := by
  simp [chartDistance]

/-- The chart distance is symmetric. -/
theorem chartDistance_symm (a b : Totality) : chartDistance a b = chartDistance b a := by
  unfold chartDistance
  congr 1; congr 1
  · split_ifs with h1 h2 h2 <;> simp_all
  · split_ifs with h1 h2 h2 <;> simp_all
  · split_ifs with h1 h2 h2 <;> simp_all

/-- Bootstrap and Namagiri differ in all three charts: maximal distance 3. -/
theorem bootstrap_namagiri_maximal_distance :
    chartDistance crossroads namagiriPoint = 3 := by native_decide

/-- The return distance is zero: the hero comes home. -/
theorem return_distance_zero :
    chartDistance ramanujanPath.wp0.coords ramanujanPath.wp3.coords = 0 := by
  simp [ramanujanPath, NarrativeJourney.toGeometricPath, chartDistance]

/-! ## §14. The Distance Profile — The Geometric Fingerprint of the Monomyth -/

/-- The distance profile: departure=0, revelation=3 (maximal), return=0. -/
theorem distance_profile :
    chartDistance ramanujanPath.wp0.coords ramanujanPath.wp0.coords = 0 ∧
    chartDistance ramanujanPath.wp0.coords ramanujanPath.wp2.coords = 3 ∧
    chartDistance ramanujanPath.wp0.coords ramanujanPath.wp3.coords = 0 := by
  refine ⟨chartDistance_self _, ?_, ?_⟩
  · simp only [ramanujanPath, NarrativeJourney.toGeometricPath]
    native_decide
  · simp [ramanujanPath, NarrativeJourney.toGeometricPath, chartDistance]

/-- **The geometric monomyth**: the journey leaves home (d=0), reaches maximal
    distance at Namagiri (d=3), and returns home (d=0). The revelation is the
    furthest point in the journey — the geometric signature of the hero's arc. -/
theorem geometric_monomyth :
    let d₀ := chartDistance ramanujanPath.wp0.coords ramanujanPath.wp0.coords
    let d₂ := chartDistance ramanujanPath.wp0.coords ramanujanPath.wp2.coords
    let d₃ := chartDistance ramanujanPath.wp0.coords ramanujanPath.wp3.coords
    d₀ = 0 ∧ d₂ = 3 ∧ d₃ = 0 ∧ d₂ > d₀ ∧ d₂ > d₃ := by
  obtain ⟨h1, h2, h3⟩ := distance_profile
  exact ⟨h1, h2, h3, by omega, by omega⟩

/-! ## §15. The Mock Modular Form as Transport Invariant -/

/-- The mock theta coefficient sum, projected to the CRT torus. -/
def mockThetaProjection : Totality :=
  residueTriple (([1, 1, 1, 2, 2, 3, 4, 5] : List ℤ).map Int.natAbs).sum

/-- The mock theta projection is stable under retraction. -/
theorem mockTheta_retraction_stable :
    retractTriple mockThetaProjection = mockThetaProjection := by
  native_decide

/-- The mock theta projection has definite CRT coordinates: (19, 19, 19). -/
theorem mockTheta_coordinates :
    mockThetaProjection = ((19 : ZMod 71), (19 : ZMod 59), (19 : ZMod 47)) := by
  native_decide

/-! ## §16. Summary — The Complete Congruence Table

| Geometric Object         | Narrative Object              | Invariant Preserved |
|--------------------------|-------------------------------|---------------------|
| `ramanujanPath.wp0`      | Departure (Bootstrap/2343)    | Gödel encoding      |
| `ramanujanPath.wp1`      | Road of Trials (tower spine)  | Tower offset 717    |
| `ramanujanPath.wp2`      | Revelation (Namagiri/840)     | Mock theta source   |
| `ramanujanPath.wp3`      | Return (home/2343)            | Idempotent retract  |
| `mockThetaProjection`    | Mock modular form elixir      | CRT stability       |
| `retractTriple`          | The hero's return             | r ∘ r = r           |
| `crossroads`             | The world-tree root           | Fixed point         |

The path IS the journey. The geometry IS the narrative.
The mock modular forms ARE the elixir.
And the return IS the retraction that proves the whole arc was
already encoded in the departure. -/
