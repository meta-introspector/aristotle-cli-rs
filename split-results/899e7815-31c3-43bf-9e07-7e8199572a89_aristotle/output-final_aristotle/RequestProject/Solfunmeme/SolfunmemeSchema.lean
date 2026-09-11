/-
# Solfunmeme IPLD Schema

This module encodes the solfunmeme UML model as an IPLD Schema value.
Each UML class becomes a `.typeDefnStruct`, generalizations are modeled
as link-typed fields to parent types, and associations become link fields.

The schema covers all concept clusters from the solfunmeme Modelio project:
- Mathematics (Sequence, FiniteModel, Primes, EllipticCurve, …)
- Computation (Compiler, Executable, Program, Language, …)
- Metaphysics (Good, Evil, Order, Chaos, Theory, …)
- Biology/Memetics (Gene, Meme, MetaMeme, Cell, Protein, …)
- Culture (SkibidiToilet, PianoMan, Fibonacci)
- Technology (Git, GitHub, Linux, …)
- Type Theory (HomotopyTypeTheory, UniMath, CategoryTheory, …)
- Semiotics (Sign, Signifier, Signified, Firstness, Secondness, Thirdness)
-/

import RequestProject.Compute.IPLD.IPLD

namespace Solfunmeme

open IPLD

-- ============================================================================
-- Helper: build a struct field concisely
-- ============================================================================

private def reqField (ty : String) : StructField :=
  .mk (.typeName ty) false false

private def optField (ty : String) : StructField :=
  .mk (.typeName ty) true false

private def linkField (target : String) : StructField :=
  .mk (.inlineDefn (.link { expectedType := target })) true false

-- A simple identity struct (just a name/id field)
private def idStruct : TypeDefn :=
  .struct {
    fields := [("name", reqField "String")],
    representation := .map ⟨none⟩
  }

-- ============================================================================
-- § 1  The Solfunmeme IPLD Schema — all concept clusters
-- ============================================================================

/-- The complete IPLD schema for the solfunmeme ontology.
    120 UML classes organized into thematic clusters, with
    generalization hierarchies as link fields and
    associations as optional link fields. -/
def solfunmemeSchema : Schema := {
  types := [

    -- ======================================================================
    -- Mathematics cluster
    -- ======================================================================

    ("Number", .struct {
      fields := [
        ("name", reqField "String"),
        ("value", optField "Int")
      ],
      representation := .map ⟨none⟩
    }),

    ("NaturalNumber", .struct {
      fields := [
        ("value", reqField "Int"),
        ("parent_Number", linkField "Number")   -- generalization
      ],
      representation := .map ⟨none⟩
    }),

    ("IntegerNum", .struct {
      fields := [
        ("value", reqField "Int"),
        ("parent_Number", linkField "Number")
      ],
      representation := .map ⟨none⟩
    }),

    ("RealNumber", .struct {
      fields := [
        ("name", reqField "String"),
        ("parent_Number", linkField "Number")
      ],
      representation := .map ⟨none⟩
    }),

    ("ComplexNumber", .struct {
      fields := [
        ("real", reqField "String"),
        ("imag", reqField "String"),
        ("parent_Number", linkField "Number")
      ],
      representation := .map ⟨none⟩
    }),

    ("Sequence", .struct {
      fields := [
        ("name", reqField "String"),
        ("terms", reqField "String"),           -- serialized list
        ("oeis_id", optField "String")
      ],
      representation := .map ⟨none⟩
    }),

    ("OEISSequence", .struct {
      fields := [
        ("id", reqField "String"),              -- e.g. "A000045"
        ("name", reqField "String"),
        ("parent_Sequence", linkField "Sequence")  -- generalization
      ],
      representation := .map ⟨none⟩
    }),

    ("Primes", .struct {
      fields := [
        ("name", reqField "String"),
        ("parent_Sequence", linkField "Sequence")
      ],
      representation := .map ⟨none⟩
    }),

    ("Fibonacci", .struct {
      fields := [
        ("name", reqField "String"),
        ("parent_OEISSequence", linkField "OEISSequence")
      ],
      representation := .map ⟨none⟩
    }),

    ("Model", .struct {
      fields := [
        ("name", reqField "String"),
        ("assoc_sequence", linkField "Sequence")  -- association
      ],
      representation := .map ⟨none⟩
    }),

    ("FiniteModel", .struct {
      fields := [
        ("name", reqField "String"),
        ("universe_size", optField "Int"),
        ("parent_Model", linkField "Model"),       -- generalization
        ("assoc_sequence", linkField "Sequence")
      ],
      representation := .map ⟨none⟩
    }),

    ("EllipticCurve", .struct {
      fields := [
        ("name", reqField "String"),
        ("a", optField "String"),
        ("b", optField "String")
      ],
      representation := .map ⟨none⟩
    }),

    ("SetConcept", .struct {
      fields := [("name", reqField "String")],
      representation := .map ⟨none⟩
    }),

    ("FunctionConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("domain", linkField "SetConcept"),
        ("codomain", linkField "SetConcept")
      ],
      representation := .map ⟨none⟩
    }),

    ("Relation", .struct {
      fields := [
        ("name", reqField "String"),
        ("on_set", linkField "SetConcept")
      ],
      representation := .map ⟨none⟩
    }),

    ("Group", .struct {
      fields := [
        ("name", reqField "String"),
        ("parent_Set", linkField "SetConcept")
      ],
      representation := .map ⟨none⟩
    }),

    ("Ring", .struct {
      fields := [
        ("name", reqField "String"),
        ("parent_Group", linkField "Group")
      ],
      representation := .map ⟨none⟩
    }),

    ("FieldAlgebra", .struct {
      fields := [
        ("name", reqField "String"),
        ("parent_Ring", linkField "Ring")
      ],
      representation := .map ⟨none⟩
    }),

    ("VectorSpace", .struct {
      fields := [
        ("name", reqField "String"),
        ("over_field", linkField "FieldAlgebra"),
        ("parent_Group", linkField "Group")
      ],
      representation := .map ⟨none⟩
    }),

    ("Topology", .struct {
      fields := [
        ("name", reqField "String"),
        ("on_set", linkField "SetConcept")
      ],
      representation := .map ⟨none⟩
    }),

    ("Manifold", .struct {
      fields := [
        ("name", reqField "String"),
        ("dimension", optField "Int"),
        ("parent_Topology", linkField "Topology")
      ],
      representation := .map ⟨none⟩
    }),

    -- Category theory
    ("CategoryConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("objects", optField "String"),
        ("morphisms", optField "String")
      ],
      representation := .map ⟨none⟩
    }),

    ("FunctorConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("source", linkField "CategoryConcept"),
        ("target", linkField "CategoryConcept")
      ],
      representation := .map ⟨none⟩
    }),

    ("Morphism", .struct {
      fields := [
        ("name", reqField "String"),
        ("source", optField "String"),
        ("target", optField "String")
      ],
      representation := .map ⟨none⟩
    }),

    ("Homomorphism", .struct {
      fields := [
        ("name", reqField "String"),
        ("parent_Morphism", linkField "Morphism")
      ],
      representation := .map ⟨none⟩
    }),

    ("Isomorphism", .struct {
      fields := [
        ("name", reqField "String"),
        ("parent_Homomorphism", linkField "Homomorphism")
      ],
      representation := .map ⟨none⟩
    }),

    -- Logic / Proof
    ("Logic", idStruct),

    ("Axiom", .struct {
      fields := [
        ("name", reqField "String"),
        ("statement", optField "String")
      ],
      representation := .map ⟨none⟩
    }),

    ("ProofConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("of_theorem", linkField "TheoremConcept")
      ],
      representation := .map ⟨none⟩
    }),

    ("TheoremConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("statement", optField "String"),
        ("proof", linkField "ProofConcept")
      ],
      representation := .map ⟨none⟩
    }),

    -- ======================================================================
    -- Computation cluster
    -- ======================================================================

    ("LanguageConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("paradigm", optField "String")
      ],
      representation := .map ⟨none⟩
    }),

    ("ProgramConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("language", linkField "LanguageConcept")
      ],
      representation := .map ⟨none⟩
    }),

    ("Compiler", .struct {
      fields := [
        ("name", reqField "String"),
        ("source_lang", linkField "LanguageConcept"),
        ("target_lang", linkField "LanguageConcept"),
        ("assoc_executable", linkField "Executable")  -- association
      ],
      representation := .map ⟨none⟩
    }),

    ("Executable", .struct {
      fields := [
        ("name", reqField "String"),
        ("parent_Program", linkField "ProgramConcept"),
        ("assoc_compiler", linkField "Compiler")     -- association
      ],
      representation := .map ⟨none⟩
    }),

    ("Algorithm", .struct {
      fields := [
        ("name", reqField "String"),
        ("complexity", optField "String")
      ],
      representation := .map ⟨none⟩
    }),

    ("DataStructure", .struct {
      fields := [
        ("name", reqField "String"),
        ("kind", optField "String")
      ],
      representation := .map ⟨none⟩
    }),

    ("TypeConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("kind", optField "String")
      ],
      representation := .map ⟨none⟩
    }),

    ("Expression", .struct {
      fields := [
        ("name", reqField "String"),
        ("type_of", linkField "TypeConcept")
      ],
      representation := .map ⟨none⟩
    }),

    ("VariableConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("type_of", linkField "TypeConcept"),
        ("parent_Expression", linkField "Expression")
      ],
      representation := .map ⟨none⟩
    }),

    ("ConstantConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("value", optField "String"),
        ("parent_Expression", linkField "Expression")
      ],
      representation := .map ⟨none⟩
    }),

    ("OperatorConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("arity", optField "Int")
      ],
      representation := .map ⟨none⟩
    }),

    ("StatementConcept", .struct {
      fields := [("name", reqField "String")],
      representation := .map ⟨none⟩
    }),

    ("ModuleConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("exports", optField "String")
      ],
      representation := .map ⟨none⟩
    }),

    ("InterfaceConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("methods", optField "String")
      ],
      representation := .map ⟨none⟩
    }),

    ("ClassConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("parent", linkField "ClassConcept"),
        ("implements", linkField "InterfaceConcept")
      ],
      representation := .map ⟨none⟩
    }),

    ("ObjectConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("of_class", linkField "ClassConcept")
      ],
      representation := .map ⟨none⟩
    }),

    ("MethodConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("return_type", linkField "TypeConcept")
      ],
      representation := .map ⟨none⟩
    }),

    ("PropertyConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("type_of", linkField "TypeConcept")
      ],
      representation := .map ⟨none⟩
    }),

    ("EventConcept", idStruct),
    ("SignalConcept", idStruct),

    -- ======================================================================
    -- Metaphysics / Philosophy cluster
    -- ======================================================================

    ("TheoryConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("self_instance", linkField "TheoryConcept"), -- Theory is instance of itself
        ("assoc_model", linkField "Model")
      ],
      representation := .map ⟨none⟩
    }),

    ("Chaos", idStruct),
    ("OrderConcept", idStruct),
    ("Good", idStruct),
    ("Evil", idStruct),
    ("Truth", idStruct),
    ("Beauty", idStruct),
    ("Justice", idStruct),
    ("Freedom", idStruct),

    ("Consciousness", .struct {
      fields := [
        ("name", reqField "String"),
        ("assoc_mind", linkField "Mind")
      ],
      representation := .map ⟨none⟩
    }),

    ("Mind", .struct {
      fields := [
        ("name", reqField "String"),
        ("assoc_consciousness", linkField "Consciousness")
      ],
      representation := .map ⟨none⟩
    }),

    ("Soul", idStruct),
    ("Spirit", idStruct),
    ("Matter", idStruct),
    ("EnergyConcept", idStruct),
    ("SpaceConcept", idStruct),
    ("TimeConcept", idStruct),
    ("Causality", idStruct),

    ("IdentityConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("of", optField "String")
      ],
      representation := .map ⟨none⟩
    }),

    ("DualityConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("pole_a", optField "String"),
        ("pole_b", optField "String")
      ],
      representation := .map ⟨none⟩
    }),

    ("UnityConcept", idStruct),
    ("InfinityConcept", idStruct),
    ("VoidConcept", idStruct),

    -- ======================================================================
    -- Biology / Memetics cluster
    -- ======================================================================

    ("Gene", .struct {
      fields := [
        ("name", reqField "String"),
        ("sequence", optField "String")
      ],
      representation := .map ⟨none⟩
    }),

    ("Meme", .struct {
      fields := [
        ("name", reqField "String"),
        ("carrier", linkField "Gene"),       -- association: meme ↔ gene analogy
        ("intensity", optField "Int")
      ],
      representation := .map ⟨none⟩
    }),

    ("MetaMeme", .struct {
      fields := [
        ("name", reqField "String"),
        ("parent_Meme", linkField "Meme")    -- generalization: metameme extends meme
      ],
      representation := .map ⟨none⟩
    }),

    ("CellConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("dna", linkField "DNA")
      ],
      representation := .map ⟨none⟩
    }),

    ("Protein", .struct {
      fields := [
        ("name", reqField "String"),
        ("encoded_by", linkField "Gene")
      ],
      representation := .map ⟨none⟩
    }),

    ("DNA", .struct {
      fields := [
        ("name", reqField "String"),
        ("genes", optField "String")
      ],
      representation := .map ⟨none⟩
    }),

    ("RNA", .struct {
      fields := [
        ("name", reqField "String"),
        ("transcribed_from", linkField "DNA")
      ],
      representation := .map ⟨none⟩
    }),

    ("Organism", .struct {
      fields := [
        ("name", reqField "String"),
        ("species", linkField "SpeciesConcept"),
        ("cells", optField "String")
      ],
      representation := .map ⟨none⟩
    }),

    ("SpeciesConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("parent_Organism", linkField "Organism")
      ],
      representation := .map ⟨none⟩
    }),

    ("Evolution", .struct {
      fields := [
        ("name", reqField "String"),
        ("mechanism", optField "String"),
        ("assoc_mutation", linkField "Mutation"),
        ("assoc_selection", linkField "Selection")
      ],
      representation := .map ⟨none⟩
    }),

    ("Mutation", idStruct),
    ("Selection", idStruct),
    ("FitnessConcept", idStruct),

    ("PopulationConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("species", linkField "SpeciesConcept")
      ],
      representation := .map ⟨none⟩
    }),

    ("Ecosystem", .struct {
      fields := [
        ("name", reqField "String"),
        ("populations", optField "String")
      ],
      representation := .map ⟨none⟩
    }),

    -- ======================================================================
    -- Culture / Instance exemplars
    -- ======================================================================

    ("SkibidiToilet", .struct {
      fields := [
        ("name", reqField "String"),
        ("parent_Meme", linkField "Meme")    -- it's a meme
      ],
      representation := .map ⟨none⟩
    }),

    ("PianoMan", .struct {
      fields := [
        ("name", reqField "String"),
        ("parent_Meme", linkField "Meme")
      ],
      representation := .map ⟨none⟩
    }),

    -- ======================================================================
    -- Technology / Software cluster
    -- ======================================================================

    ("GitConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("parent_Program", linkField "ProgramConcept")
      ],
      representation := .map ⟨none⟩
    }),

    ("GitHubConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("assoc_git", linkField "GitConcept"),
        ("parent_WebServer", linkField "WebServerConcept")
      ],
      representation := .map ⟨none⟩
    }),

    ("LinuxConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("parent_Program", linkField "ProgramConcept")
      ],
      representation := .map ⟨none⟩
    }),

    ("DockerConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("parent_Program", linkField "ProgramConcept")
      ],
      representation := .map ⟨none⟩
    }),

    ("KubernetesConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("assoc_docker", linkField "DockerConcept")
      ],
      representation := .map ⟨none⟩
    }),

    ("DatabaseConcept", .struct {
      fields := [("name", reqField "String")],
      representation := .map ⟨none⟩
    }),

    ("APIConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("protocol", linkField "ProtocolConcept")
      ],
      representation := .map ⟨none⟩
    }),

    ("WebServerConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("serves", linkField "APIConcept")
      ],
      representation := .map ⟨none⟩
    }),

    ("NetworkConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("protocol", linkField "ProtocolConcept")
      ],
      representation := .map ⟨none⟩
    }),

    ("ProtocolConcept", .struct {
      fields := [("name", reqField "String")],
      representation := .map ⟨none⟩
    }),

    -- ======================================================================
    -- Type Theory cluster
    -- ======================================================================

    ("HomotopyTypeTheory", .struct {
      fields := [
        ("name", reqField "String"),
        ("parent_Theory", linkField "TheoryConcept"),
        ("realizes_unimath", linkField "UniMathConcept")  -- realization
      ],
      representation := .map ⟨none⟩
    }),

    ("UniMathConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("parent_Program", linkField "ProgramConcept")
      ],
      representation := .map ⟨none⟩
    }),

    ("CategoryTheoryConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("parent_Theory", linkField "TheoryConcept"),
        ("assoc_functor", linkField "FunctorConcept")  -- dependency
      ],
      representation := .map ⟨none⟩
    }),

    ("DependentType", .struct {
      fields := [
        ("name", reqField "String"),
        ("parent_Type", linkField "TypeConcept")
      ],
      representation := .map ⟨none⟩
    }),

    ("InductiveType", .struct {
      fields := [
        ("name", reqField "String"),
        ("parent_Type", linkField "TypeConcept")
      ],
      representation := .map ⟨none⟩
    }),

    ("CoinductiveType", .struct {
      fields := [
        ("name", reqField "String"),
        ("parent_Type", linkField "TypeConcept")
      ],
      representation := .map ⟨none⟩
    }),

    -- ======================================================================
    -- Semiotics cluster (Peircean)
    -- ======================================================================

    ("SignConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("signifier", linkField "SignifierConcept"),
        ("signified", linkField "SignifiedConcept")
      ],
      representation := .map ⟨none⟩
    }),

    ("SignifierConcept", .struct {
      fields := [("name", reqField "String")],
      representation := .map ⟨none⟩
    }),

    ("SignifiedConcept", .struct {
      fields := [("name", reqField "String")],
      representation := .map ⟨none⟩
    }),

    ("SymbolConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("parent_Sign", linkField "SignConcept")
      ],
      representation := .map ⟨none⟩
    }),

    ("IconConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("parent_Sign", linkField "SignConcept")
      ],
      representation := .map ⟨none⟩
    }),

    ("IndexConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("parent_Sign", linkField "SignConcept")
      ],
      representation := .map ⟨none⟩
    }),

    -- Peircean categories
    ("Firstness", idStruct),
    ("Secondness", idStruct),
    ("Thirdness", idStruct),

    -- ======================================================================
    -- Foundational figures (instance-like)
    -- ======================================================================

    ("GoedelConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("incompleteness", optField "String"),
        ("assoc_logic", linkField "Logic")
      ],
      representation := .map ⟨none⟩
    }),

    ("TuringConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("machine", optField "String"),
        ("assoc_computability", linkField "ComputabilityTheory")
      ],
      representation := .map ⟨none⟩
    }),

    ("ChurchConcept", .struct {
      fields := [
        ("name", reqField "String"),
        ("assoc_lambda", linkField "LambdaCalculus")
      ],
      representation := .map ⟨none⟩
    }),

    ("LambdaCalculus", .struct {
      fields := [
        ("name", reqField "String"),
        ("parent_Theory", linkField "TheoryConcept")
      ],
      representation := .map ⟨none⟩
    }),

    ("ComputabilityTheory", .struct {
      fields := [
        ("name", reqField "String"),
        ("parent_Theory", linkField "TheoryConcept")
      ],
      representation := .map ⟨none⟩
    }),

    -- ======================================================================
    -- The person behind the project
    -- ======================================================================

    ("JamesMichaelDuPont", .struct {
      fields := [
        ("name", reqField "String"),
        ("projects", optField "String")
      ],
      representation := .map ⟨none⟩
    })

  ],
  advanced := none
}

-- ============================================================================
-- § 2  Schema statistics
-- ============================================================================

/-- Number of types in the solfunmeme schema. -/
def schemaTypeCount : Nat := solfunmemeSchema.types.length

#eval schemaTypeCount  -- expect ~120

end Solfunmeme
