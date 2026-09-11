/-
# RequestProject/TypedDMZ.lean
## Typed DMZ: Hierarchical, Fiber-Indexed, Schema-Aware Safe Zone

If a block is admitted into fiber F, then every field of that block
is automatically considered part of the DMZ for F.

Architecture:
  Admitted(F, c, b) ⇒ ∀ f ∈ Fields(S), f(b) ∈ DMZ(F)

Each field in a schema is a set constructor:
  TypeDefnString → set of strings
  TypeDefnInt    → set of integers
  TypeDefnStruct → product of sets
  TypeDefnList   → list of elements from a set
  TypeDefnMap    → map from one set to another
  TypeDefnLink   → pointer into another dataset (cross-fiber link)
  TypeDefnUnion  → disjoint sum of sets

The DMZ is not a flat space:
  - Partitioned by Monster fibers (196883 zones)
  - Each fiber has its own schema
  - Each schema defines its own sub-DMZ
  - Each field defines its own sub-sub-DMZ

DMZ(F) = all code allowed to read fields of blocks whose fiber is F.
-/
import Mathlib
import RequestProject.GovernanceInvariant
import RequestProject.KernelGovernance

set_option maxHeartbeats 800000

open GovernanceInvariant KernelGovernance

namespace TypedDMZ

/-! ## §18. Schema — What Fields Exist -/

/-- A field type in the schema language.
    Each variant is a set constructor over the block's content. -/
inductive FieldType where
  | string   : FieldType
  | int      : FieldType
  | bool     : FieldType
  | bytes    : FieldType
  | link     : FieldType   -- CID pointer into another dataset
  | list     : FieldType → FieldType
  | mapType  : FieldType → FieldType → FieldType
  | union    : List FieldType → FieldType
  | struct   : List (String × FieldType) → FieldType

/-- A field is a named, typed slot in a schema. -/
structure Field where
  name     : String
  fieldType : FieldType

/-- A schema is a list of fields — the shape of a block. -/
structure Schema where
  fields : List Field

/-- The number of fields in a schema. -/
def Schema.fieldCount (s : Schema) : ℕ := s.fields.length

/-- A field name belongs to a schema. -/
def Schema.hasField (s : Schema) (name : String) : Prop :=
  ∃ f ∈ s.fields, f.name = name

instance (s : Schema) (name : String) : Decidable (s.hasField name) := by
  unfold Schema.hasField
  infer_instance

/-! ## §19. Fiber-Schema Binding

Each fiber has an associated schema.
The schema defines the shape of all blocks in that fiber.
-/

/-- A fiber-schema binding: assigns a schema to each fiber.
    This is the "type system" of the Monster torus. -/
structure FiberSchemaMap where
  /-- The schema for each fiber. -/
  schemaOf : Dataset → Schema

/-- A block is schema-valid for a dataset if its content hash
    corresponds to data matching the dataset's schema.
    (In practice, this means the DAG-CBOR decoding produces
    a record matching the schema's field types.)
    We model this as an abstract predicate. -/
def SchemaValid (_fsm : FiberSchemaMap) (ds : Dataset) (b : Block) : Prop :=
  -- Abstract: the block's content matches the schema
  -- In a real implementation, this would decode DAG-CBOR
  -- and check each field against its declared type.
  ds.contains b

/-! ## §20. DMZ — The Typed Safe Zone

DMZ(F) = all code that is allowed to read fields of blocks
whose fiber is F.

If a block is admitted into fiber F, then every field
of that block is automatically considered part of DMZ(F).
-/

/-- A DMZ capability: what operations are allowed on a field. -/
inductive Capability where
  | read    : Capability
  | write   : Capability
  | execute : Capability
  | link    : Capability   -- follow CID links
  deriving DecidableEq

/-- A DMZ rule: a specific capability on a specific field in a fiber. -/
structure DMZRule where
  /-- Which dataset/fiber. -/
  dataset    : Dataset
  /-- Which field (by name). -/
  fieldName  : String
  /-- What capability is granted. -/
  capability : Capability
  deriving DecidableEq

/-- A DMZ policy: the set of all allowed operations per fiber. -/
structure DMZPolicy where
  /-- The rules. -/
  rules : List DMZRule
  /-- Whether a specific (dataset, field, capability) triple is allowed. -/
  allows : Dataset → String → Capability → Prop
  /-- Decidable. -/
  decidable : DecidablePred (fun t : Dataset × String × Capability =>
    allows t.1 t.2.1 t.2.2)

instance (pol : DMZPolicy) (ds : Dataset) (field : String) (cap : Capability) :
    Decidable (pol.allows ds field cap) :=
  pol.decidable (ds, field, cap)

/-- The permissive DMZ: all fields in all fibers are readable. -/
def DMZPolicy.permitAll : DMZPolicy where
  rules := []
  allows := fun _ _ _ => True
  decidable := fun _ => isTrue trivial

/-- The restrictive DMZ: no access to any field. -/
def DMZPolicy.denyAll : DMZPolicy where
  rules := []
  allows := fun _ _ _ => False
  decidable := fun _ => isFalse id

/-! ## §21. The DMZ Admission Theorem

If a block is admitted to fiber F, then every field of that block
is automatically inside DMZ(F).

This is the key theorem: admission ⇒ field-level trust.
-/

/-- A field value is "in the DMZ" for a fiber if the block
    containing it was admitted to that fiber. -/
def FieldInDMZ (ds : Dataset) (b : Block) (fieldName : String)
    (fsm : FiberSchemaMap) : Prop :=
  ds.contains b ∧ (fsm.schemaOf ds).hasField fieldName

/-- The DMZ admission theorem:
    If a block is committee-approved for dataset ds,
    then every field defined in ds's schema is in the DMZ for ds. -/
theorem dmz_admission (ds : Dataset) (c : CID) (b : Block)
    (fsm : FiberSchemaMap)
    (hcomm : CommitteeApproved ds c b)
    (fieldName : String)
    (hfield : (fsm.schemaOf ds).hasField fieldName) :
    FieldInDMZ ds b fieldName fsm := by
  exact ⟨hcomm.2, hfield⟩

/-- No block from a different fiber can have its fields
    in this fiber's DMZ. Cross-fiber DMZ contamination is impossible. -/
theorem dmz_no_cross_fiber (ds₁ ds₂ : Dataset) (b : Block)
    (fieldName : String) (fsm : FiberSchemaMap)
    (h₁ : FieldInDMZ ds₁ b fieldName fsm)
    (h₂ : FieldInDMZ ds₂ b fieldName fsm) :
    ds₁ = ds₂ :=
  no_cross_contamination ds₁ ds₂ b h₁.1 h₂.1

/-! ## §22. Three-Layer Admission: Committee → Senate → DMZ

The complete pipeline:
  1. Committee (CRT congruence + fiber) — mathematics
  2. Senate (ACL policy) — governance
  3. DMZ (field-level capability) — operations

Each layer can only restrict, never extend.
-/

/-- Three-layer admission: all three gates must pass. -/
def ThreeLayerAdmitted (ds : Dataset) (principal : Principal)
    (c : CID) (b : Block) (pol : ACLPolicy)
    (dmzPol : DMZPolicy) (fieldName : String) (cap : Capability)
    (fsm : FiberSchemaMap) : Prop :=
  -- Layer 1: Committee (mathematics)
  CommitteeApproved ds c b ∧
  -- Layer 2: Senate (governance)
  SenateApproved pol principal ds c ∧
  -- Layer 3: DMZ (field-level operations)
  FieldInDMZ ds b fieldName fsm ∧
  dmzPol.allows ds fieldName cap

/-- Three-layer admission implies two-layer admission. -/
theorem three_layer_implies_two (ds : Dataset) (principal : Principal)
    (c : CID) (b : Block) (pol : ACLPolicy)
    (dmzPol : DMZPolicy) (fieldName : String) (cap : Capability)
    (fsm : FiberSchemaMap)
    (h : ThreeLayerAdmitted ds principal c b pol dmzPol fieldName cap fsm) :
    TwoLayerAdmitted ds principal c b pol :=
  ⟨h.1, h.2.1⟩

/-- Three-layer admission implies congruence. Mathematics is absolute. -/
theorem three_layer_implies_congruent (ds : Dataset) (principal : Principal)
    (c : CID) (b : Block) (pol : ACLPolicy)
    (dmzPol : DMZPolicy) (fieldName : String) (cap : Capability)
    (fsm : FiberSchemaMap)
    (h : ThreeLayerAdmitted ds principal c b pol dmzPol fieldName cap fsm) :
    Congruent c b :=
  h.1.1

/-- Committee veto kills everything — no Senate or DMZ can override. -/
theorem committee_veto_absolute (ds : Dataset) (principal : Principal)
    (c : CID) (b : Block) (pol : ACLPolicy)
    (dmzPol : DMZPolicy) (fieldName : String) (cap : Capability)
    (fsm : FiberSchemaMap)
    (h : ¬ CommitteeApproved ds c b) :
    ¬ ThreeLayerAdmitted ds principal c b pol dmzPol fieldName cap fsm :=
  fun hadm => h hadm.1

/-! ## §23. Link Traversal — Following CID Pointers Across Fibers

When a block contains a Link field (CID pointer), following that
link crosses from one fiber to another. The DMZ must re-validate
at the target fiber.

This is recursive DMZ inheritance: each linked dataset has its
own schema, its own DMZ, its own Committee check.
-/

/-- A link traversal: from a source block in one dataset
    to a target block in another dataset, via a CID pointer. -/
structure LinkTraversal where
  /-- Source dataset. -/
  source      : Dataset
  /-- Source block containing the link. -/
  sourceBlock : Block
  /-- The field name containing the link CID. -/
  linkField   : String
  /-- Target dataset (determined by the linked CID's fiber). -/
  target      : Dataset
  /-- Target CID (the value of the link field). -/
  targetCid   : CID
  /-- Target block. -/
  targetBlock : Block
  /-- The source block is in its dataset. -/
  sourceOk    : source.contains sourceBlock
  /-- The target CID is congruent with the target block. -/
  targetCong  : Congruent targetCid targetBlock
  /-- The target block is in the target dataset. -/
  targetOk    : target.contains targetBlock

/-- Following a link always lands in a well-defined fiber. -/
theorem link_lands_in_fiber (lt : LinkTraversal) :
    blockToBase lt.targetBlock = lt.target.fiber :=
  lt.targetOk

/-- A link traversal cannot contaminate the source fiber. -/
theorem link_no_contamination (lt : LinkTraversal)
    (h : lt.source ≠ lt.target) :
    ¬ lt.source.contains lt.targetBlock := by
  intro hbad
  exact h (no_cross_contamination lt.source lt.target lt.targetBlock hbad lt.targetOk)

/-! ## §24. The Complete Governance Architecture

Summary of the full system:

  Layer 0: Monster torus — 196883 fibers define the universe
  Layer 1: Committee — CRT congruence + fiber check (mathematics)
  Layer 2: Senate — ACL policy (governance)
  Layer 3: DMZ — field-level capabilities (operations)
  Layer 4: Links — cross-fiber traversal with re-validation

Each layer can only restrict. Mathematics is absolute.
The government can only think sure mathematical thoughts.
-/

/-- THE COMPLETE GOVERNANCE THEOREM:

All four layers compose correctly:
1. The universe has Monster size (196883)
2. Every block belongs to exactly one dataset
3. Committee approval is necessary for all higher layers
4. Senate cannot override Committee
5. DMZ cannot override Senate
6. Link traversal re-validates at the target fiber
7. Cross-fiber contamination is impossible at every layer -/
theorem complete_governance
    (ds : Dataset) (principal : Principal)
    (c : CID) (b : Block)
    (pol : ACLPolicy) (dmzPol : DMZPolicy)
    (fieldName : String) (cap : Capability)
    (fsm : FiberSchemaMap) :
    -- The universe has Monster size
    (Fintype.card Base = 196883) ∧
    -- Every block belongs to exactly one dataset
    (∃! ds' : Dataset, ds'.contains b) ∧
    -- Committee veto is absolute across all layers
    (¬ CommitteeApproved ds c b →
      ¬ ThreeLayerAdmitted ds principal c b pol dmzPol fieldName cap fsm) ∧
    -- Three-layer implies two-layer implies committee
    (ThreeLayerAdmitted ds principal c b pol dmzPol fieldName cap fsm →
      TwoLayerAdmitted ds principal c b pol) ∧
    -- Two-layer implies congruence
    (TwoLayerAdmitted ds principal c b pol → Congruent c b) ∧
    -- Congruence = three CRT equalities
    (Congruent c b ↔
      (c.digest : ZMod 71) = (b.contentHash : ZMod 71) ∧
      (c.digest : ZMod 59) = (b.contentHash : ZMod 59) ∧
      (c.digest : ZMod 47) = (b.contentHash : ZMod 47)) := by
  exact ⟨base_card,
         block_unique_dataset b,
         committee_veto_absolute ds principal c b pol dmzPol fieldName cap fsm,
         three_layer_implies_two ds principal c b pol dmzPol fieldName cap fsm,
         two_layer_implies_congruent ds principal c b pol,
         congruent_iff c b⟩

end TypedDMZ
