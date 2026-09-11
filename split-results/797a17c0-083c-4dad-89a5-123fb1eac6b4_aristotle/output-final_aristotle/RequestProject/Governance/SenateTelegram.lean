/-
# Parliament of Behaviors — Telegrams, Dockets, and the Chamber

Every runtime signal — a coverage bitmap, a CRT address, a j-coefficient,
a kernel defect — is a **telegram** delivered to a procedural chamber.
The chamber accumulates telegrams into a **docket** (an ordered,
monotonically refined witness record).

## Mapping

| Concept           | Type             | Role                              |
|-------------------|------------------|-----------------------------------|
| Telegram          | `Telegram`       | One runtime signal (fuzz, perf…)  |
| Docket            | `List DocketEntry` | Ordered record of all telegrams |
| Chamber           | `Chamber`        | Geometric context (lattice params)|
| Monotone folding  | `chamber_receive_monotone` | Coverage only grows (proven) |
-/

import RequestProject.Bridge.WitnessLayer

namespace IPLD.Witness.Senate

open IPLD.Witness

-- ============================================================================
-- § 1  Telegram — a single runtime message
-- ============================================================================

/-- The channel a telegram arrives on — which subsystem produced the signal. -/
inductive Channel where
  | coverage
  | performance
  | defect
  | certificate
  | spectral
  | governance
  deriving BEq, Inhabited, Repr, DecidableEq

/-- A **Telegram** is a single message delivered to the chamber. -/
structure Telegram where
  /-- The behavioral data — coverage bitmap + run metadata. -/
  sheafSection : SheafSection
  /-- Which subsystem originated this signal. -/
  chan : Channel
  /-- Monotonic timestamp within the session. -/
  timestamp : Nat
  /-- Optional structured payload (serialized as IPLD). -/
  payload : Option IPLDNode := none
  deriving BEq, Inhabited

-- ============================================================================
-- § 2  DocketEntry — a telegram plus its effect on the witness state
-- ============================================================================

/-- A **DocketEntry** records one telegram and the witness layer state
    *after* incorporating it. -/
structure DocketEntry where
  /-- The telegram that was processed. -/
  telegram : Telegram
  /-- The witness layer state after folding this telegram's section. -/
  resultingLayer : WitnessLayer
  deriving BEq

-- ============================================================================
-- § 3  Chamber — the geometric context
-- ============================================================================

/-- A **Chamber** holds the procedural and geometric context for
    a witness accumulation session. -/
structure Chamber where
  /-- The current accumulated witness state. -/
  currentLayer : WitnessLayer
  /-- The ordered procedural record. -/
  docket : List DocketEntry
  /-- The coverage bitmap dimension (number of edges tracked). -/
  dimension : Nat
  deriving BEq

/-- Create an empty chamber with a given coverage dimension. -/
def Chamber.empty (dim : Nat) : Chamber :=
  { currentLayer := WitnessLayer.empty dim
    docket := []
    dimension := dim }

-- ============================================================================
-- § 4  Receiving a telegram — the procedural fold
-- ============================================================================

/-- Process a telegram: fold its section into the chamber's witness layer,
    and append a docket entry recording the transaction. -/
def Chamber.receive (ch : Chamber) (tel : Telegram) : Chamber :=
  let newLayer := foldWitness tel.sheafSection ch.currentLayer
  let entry : DocketEntry := { telegram := tel, resultingLayer := newLayer }
  { ch with
    currentLayer := newLayer
    docket := ch.docket ++ [entry] }

/-- Process a batch of telegrams in order. -/
def Chamber.receiveBatch (ch : Chamber) (tels : List Telegram) : Chamber :=
  tels.foldl Chamber.receive ch

-- ============================================================================
-- § 5  Monotonicity of the chamber — coverage only grows
-- ============================================================================

/-- **Chamber monotonicity**: receiving a telegram never decreases coverage. -/
theorem chamber_receive_monotone (ch : Chamber) (tel : Telegram) :
    ch.currentLayer ≤ (ch.receive tel).currentLayer :=
  foldWitness_monotone tel.sheafSection ch.currentLayer

/-- **Batch monotonicity**: receiving any sequence of telegrams
    produces a chamber whose coverage refines the original. -/
theorem chamber_receiveBatch_monotone (ch : Chamber) (tels : List Telegram) :
    ch.currentLayer ≤ (ch.receiveBatch tels).currentLayer := by
  induction tels generalizing ch with
  | nil => exact witnessLayer_le_refl ch.currentLayer
  | cons t ts ih =>
    simp only [Chamber.receiveBatch, List.foldl]
    exact witnessLayer_le_trans
      (chamber_receive_monotone ch t)
      (ih (ch.receive t))

-- ============================================================================
-- § 6  Docket structural properties
-- ============================================================================

/-- The docket length after receiving one telegram increases by 1. -/
theorem docket_length_receive (ch : Chamber) (tel : Telegram) :
    (ch.receive tel).docket.length = ch.docket.length + 1 := by
  simp [Chamber.receive]

/-- The grade after receiving one telegram increases by 1. -/
theorem grade_receive (ch : Chamber) (tel : Telegram) :
    (ch.receive tel).currentLayer.grade = ch.currentLayer.grade + 1 := by
  simp [Chamber.receive, foldWitness]

-- ============================================================================
-- § 7  IPLD serialization — telegrams as IPLD nodes
-- ============================================================================

/-- Encode a `Channel` as an IPLD string. -/
def Channel.toIPLDNode : Channel → IPLDNode
  | .coverage    => .string "coverage"
  | .performance => .string "performance"
  | .defect      => .string "defect"
  | .certificate => .string "certificate"
  | .spectral    => .string "spectral"
  | .governance  => .string "governance"

/-- Decode a `Channel` from an `IPLDNode`. -/
def Channel.fromIPLDNode : IPLDNode → Option Channel
  | .string "coverage"    => some .coverage
  | .string "performance" => some .performance
  | .string "defect"      => some .defect
  | .string "certificate" => some .certificate
  | .string "spectral"    => some .spectral
  | .string "governance"  => some .governance
  | _ => none

/-- Encode a `Telegram` as an `IPLDNode`. -/
def Telegram.toIPLDNode (tel : Telegram) : IPLDNode :=
  .map [
    ("channel", tel.chan.toIPLDNode),
    ("timestamp", .int tel.timestamp),
    ("runId", .int tel.sheafSection.runId),
    ("inputHash", .int tel.sheafSection.inputHash),
    ("coverage", .list (tel.sheafSection.coverage.bits.map fun b => .bool b)),
    ("payload", tel.payload.getD .null)
  ]

/-- Encode a `DocketEntry` as an `IPLDNode`. -/
def DocketEntry.toIPLDNode (entry : DocketEntry) : IPLDNode :=
  .map [
    ("telegram", entry.telegram.toIPLDNode),
    ("resultingLayer", entry.resultingLayer.toIPLDNode)
  ]

/-- Encode an entire `Chamber` snapshot as an `IPLDNode`. -/
def Chamber.toIPLDNode (ch : Chamber) : IPLDNode :=
  .map [
    ("dimension", .int ch.dimension),
    ("currentLayer", ch.currentLayer.toIPLDNode),
    ("docket", .list (ch.docket.map DocketEntry.toIPLDNode))
  ]

-- ============================================================================
-- § 8  Convenience: constructing telegrams from raw data
-- ============================================================================

/-- Construct a coverage telegram from a raw bitmap. -/
def Telegram.fromCoverage (bits : List Bool) (runId timestamp : Nat)
    (inputHash : Nat := 0) : Telegram :=
  { sheafSection := { coverage := ⟨bits⟩, runId, inputHash }
    chan := .coverage
    timestamp }

/-- Construct a defect telegram (crash / assertion failure). -/
def Telegram.fromDefect (bits : List Bool) (runId timestamp : Nat)
    (description : String) : Telegram :=
  { sheafSection := { coverage := ⟨bits⟩, runId }
    chan := .defect
    timestamp
    payload := some (.string description) }

/-- Construct a spectral telegram (j-coefficient, eigenvalue, etc.). -/
def Telegram.fromSpectral (bits : List Bool) (runId timestamp : Nat)
    (coefficients : List Int) : Telegram :=
  { sheafSection := { coverage := ⟨bits⟩, runId }
    chan := .spectral
    timestamp
    payload := some (.list (coefficients.map fun c => .int c)) }

/-- Construct a governance telegram (schema change, codec update, etc.). -/
def Telegram.fromGovernance (runId timestamp : Nat)
    (description : String) (dim : Nat := 0) : Telegram :=
  { sheafSection := { coverage := ⟨List.replicate dim false⟩, runId }
    chan := .governance
    timestamp
    payload := some (.string description) }

-- ============================================================================
-- § 9  Example: a tiny session
-- ============================================================================

/-- A demonstration of a 3-telegram session on a 4-edge program. -/
def exampleSession : Chamber :=
  let ch := Chamber.empty 4
  let t1 := Telegram.fromCoverage [true, false, false, false] 1 100
  let t2 := Telegram.fromCoverage [false, true, false, true]  2 200
  let t3 := Telegram.fromDefect   [true, true, false, false]  3 300 "null deref"
  ch.receiveBatch [t1, t2, t3]

-- The session accumulates coverage monotonically
#eval exampleSession.currentLayer.grade        -- 3
#eval exampleSession.currentLayer.witnessCount -- 3
#eval exampleSession.docket.length             -- 3
#eval exampleSession.currentLayer.accumulated.bits
-- [true, true, false, true] — union of all three runs' coverage

end IPLD.Witness.Senate
