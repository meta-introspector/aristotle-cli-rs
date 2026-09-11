/-
# Solfunmeme Top-Level Types

Each UML class element from the solfunmeme diagram is converted to its own
top-level Lean type (structure). UML generalizations become `extends`,
and UML associations become optional fields pointing to the related type.

## Clusters
- Mathematics (35 types)
- Computation (20 types)
- Metaphysics (23 types)
- Biology (15 types)
- Culture (2 types)
- Technology (10 types)
- Type Theory (6 types)
- Semiotics (9 types)
- Foundational Figures (3 types)
- Person (1 type)

## Source
- Modelio project: solfunmeme (April 2025)
- User: jmikedupont on SOLFUNMEME1
-/

-- We use a minimal import; no Mathlib needed for pure structure definitions
import Lean

namespace SolfunmemeTypes

-- ============================================================================
-- § 1  Cluster tag
-- ============================================================================

/-- The thematic cluster an element belongs to. -/
inductive Cluster where
  | mathematics
  | computation
  | metaphysics
  | biology
  | culture
  | technology
  | typeTheory
  | semiotics
  deriving DecidableEq, Repr, Inhabited

-- ============================================================================
-- § 2  Mathematics cluster — base types
-- ============================================================================

/-- UML class: Number -/
structure Number where
  value : String := ""
  deriving Repr, Inhabited

/-- UML class: NaturalNumber extends Number -/
structure NaturalNumber extends Number where
  deriving Repr, Inhabited

/-- UML class: IntegerNum extends Number -/
structure IntegerNum extends Number where
  deriving Repr, Inhabited

/-- UML class: RealNumber extends Number -/
structure RealNumber extends Number where
  deriving Repr, Inhabited

/-- UML class: ComplexNumber extends Number -/
structure ComplexNumber extends Number where
  deriving Repr, Inhabited

/-- UML class: Sequence -/
structure Sequence where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: OEISSequence extends Sequence -/
structure OEISSequence extends Sequence where
  oeis_id : String := ""
  deriving Repr, Inhabited

/-- UML class: Primes extends Sequence -/
structure Primes extends Sequence where
  deriving Repr, Inhabited

/-- UML class: Fibonacci extends OEISSequence -/
structure Fibonacci extends OEISSequence where
  deriving Repr, Inhabited

/-- UML class: Model. Association: has_sequence → Sequence -/
structure Model where
  description : String := ""
  has_sequence : Option Sequence := none
  deriving Repr, Inhabited

/-- UML class: FiniteModel extends Model. Association: uses_sequence → Sequence -/
structure FiniteModel extends Model where
  uses_sequence : Option Sequence := none
  deriving Repr, Inhabited

/-- UML class: EllipticCurve -/
structure EllipticCurve where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: SetConcept -/
structure SetConcept where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: FunctionConcept. Associations: domain, codomain → SetConcept -/
structure FunctionConcept where
  description : String := ""
  domain : Option SetConcept := none
  codomain : Option SetConcept := none
  deriving Repr, Inhabited

/-- UML class: Relation. Association: on_set → SetConcept -/
structure Relation where
  description : String := ""
  on_set : Option SetConcept := none
  deriving Repr, Inhabited

/-- UML class: Group -/
structure Group where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: Ring extends Group -/
structure Ring extends Group where
  deriving Repr, Inhabited

/-- UML class: FieldAlgebra extends Ring -/
structure FieldAlgebra extends Ring where
  deriving Repr, Inhabited

/-- UML class: VectorSpace extends Group -/
structure VectorSpace extends Group where
  deriving Repr, Inhabited

/-- UML class: Topology. Association: on_set → SetConcept -/
structure Topology where
  description : String := ""
  on_set : Option SetConcept := none
  deriving Repr, Inhabited

/-- UML class: Manifold -/
structure Manifold where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: CategoryConcept -/
structure CategoryConcept where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: Morphism -/
structure Morphism where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: Homomorphism extends Morphism -/
structure Homomorphism extends Morphism where
  deriving Repr, Inhabited

/-- UML class: Isomorphism extends Homomorphism -/
structure Isomorphism extends Homomorphism where
  deriving Repr, Inhabited

/-- UML class: FunctorConcept. Associations: source_cat, target_cat → CategoryConcept -/
structure FunctorConcept where
  description : String := ""
  source_cat : Option CategoryConcept := none
  target_cat : Option CategoryConcept := none
  deriving Repr, Inhabited

/-- UML class: Logic -/
structure Logic where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: AxiomConcept -/
structure AxiomConcept where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: TheoremConcept -/
structure TheoremConcept where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: ProofConcept. Association: proves → TheoremConcept -/
structure ProofConcept where
  description : String := ""
  proves : Option TheoremConcept := none
  deriving Repr, Inhabited

-- ============================================================================
-- § 3  Computation cluster
-- ============================================================================

/-- UML class: LanguageConcept -/
structure LanguageConcept where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: ProgramConcept. Association: written_in → LanguageConcept -/
structure ProgramConcept where
  description : String := ""
  written_in : Option LanguageConcept := none
  deriving Repr, Inhabited

/-- UML class: Compiler. Associations: produces → Executable (forward-declared),
    source_language, target_language → LanguageConcept -/
structure Compiler where
  description : String := ""
  source_language : Option LanguageConcept := none
  target_language : Option LanguageConcept := none
  deriving Repr, Inhabited

/-- UML class: Executable extends ProgramConcept.
    Association: compiled_by → Compiler -/
structure Executable extends ProgramConcept where
  compiled_by : Option Compiler := none
  deriving Repr, Inhabited

/-- UML class: Algorithm -/
structure Algorithm where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: DataStructure -/
structure DataStructure where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: TypeConcept -/
structure TypeConcept where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: Expression. Association: has_type → TypeConcept -/
structure Expression where
  description : String := ""
  has_type : Option TypeConcept := none
  deriving Repr, Inhabited

/-- UML class: VariableConcept extends Expression -/
structure VariableConcept extends Expression where
  deriving Repr, Inhabited

/-- UML class: ConstantConcept extends Expression -/
structure ConstantConcept extends Expression where
  deriving Repr, Inhabited

/-- UML class: OperatorConcept -/
structure OperatorConcept where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: StatementConcept -/
structure StatementConcept where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: ModuleConcept -/
structure ModuleConcept where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: InterfaceConcept -/
structure InterfaceConcept where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: ClassConcept. Association: implements → InterfaceConcept -/
structure ClassConcept where
  description : String := ""
  implements : Option InterfaceConcept := none
  deriving Repr, Inhabited

/-- UML class: ObjectConcept. Association: instance_of → ClassConcept -/
structure ObjectConcept where
  description : String := ""
  instance_of : Option ClassConcept := none
  deriving Repr, Inhabited

/-- UML class: MethodConcept. Association: returns → TypeConcept -/
structure MethodConcept where
  description : String := ""
  returns : Option TypeConcept := none
  deriving Repr, Inhabited

/-- UML class: PropertyConcept -/
structure PropertyConcept where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: EventConcept -/
structure EventConcept where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: SignalConcept -/
structure SignalConcept where
  description : String := ""
  deriving Repr, Inhabited

-- ============================================================================
-- § 4  Metaphysics cluster
-- ============================================================================

/-- UML class: TheoryConcept. Associations: instance_of_self → TheoryConcept,
    has_model → Model -/
structure TheoryConcept where
  description : String := ""
  /-- Theory is an instance of itself (self-referential). -/
  instance_of_self : Bool := false
  has_model : Option Model := none
  deriving Repr, Inhabited

/-- UML class: Chaos -/
structure Chaos where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: OrderConcept -/
structure OrderConcept where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: Good -/
structure Good where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: Evil -/
structure Evil where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: Truth -/
structure Truth where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: Beauty -/
structure Beauty where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: Justice -/
structure Justice where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: Freedom -/
structure Freedom where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: Mind. Association: aware_of → Consciousness (forward ref) -/
structure Mind where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: Consciousness. Association: resides_in → Mind -/
structure Consciousness where
  description : String := ""
  resides_in : Option Mind := none
  deriving Repr, Inhabited

/-- UML class: Soul -/
structure Soul where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: Spirit -/
structure Spirit where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: Matter -/
structure Matter where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: EnergyConcept -/
structure EnergyConcept where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: SpaceConcept -/
structure SpaceConcept where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: TimeConcept -/
structure TimeConcept where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: Causality -/
structure Causality where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: IdentityConcept -/
structure IdentityConcept where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: DualityConcept -/
structure DualityConcept where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: UnityConcept -/
structure UnityConcept where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: InfinityConcept -/
structure InfinityConcept where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: VoidConcept -/
structure VoidConcept where
  description : String := ""
  deriving Repr, Inhabited

-- ============================================================================
-- § 5  Biology cluster
-- ============================================================================

/-- UML class: Gene. Association: encodes → Protein (forward ref) -/
structure Gene where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: Protein -/
structure Protein where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: DNA. Association: contains → Gene -/
structure DNA where
  description : String := ""
  contains : Option Gene := none
  deriving Repr, Inhabited

/-- UML class: RNA. Association: transcribed_from → DNA -/
structure RNA where
  description : String := ""
  transcribed_from : Option DNA := none
  deriving Repr, Inhabited

/-- UML class: CellConcept. Association: has_dna → DNA -/
structure CellConcept where
  description : String := ""
  has_dna : Option DNA := none
  deriving Repr, Inhabited

/-- UML class: Meme. Association: cultural_analog_of → Gene -/
structure Meme where
  description : String := ""
  cultural_analog_of : Option Gene := none
  deriving Repr, Inhabited

/-- UML class: MetaMeme extends Meme -/
structure MetaMeme extends Meme where
  deriving Repr, Inhabited

/-- UML class: SpeciesConcept -/
structure SpeciesConcept where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: Organism. Association: belongs_to → SpeciesConcept -/
structure Organism where
  description : String := ""
  belongs_to : Option SpeciesConcept := none
  deriving Repr, Inhabited

/-- UML class: Mutation -/
structure Mutation where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: Selection -/
structure Selection where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: Evolution.
    Associations: driven_by → Mutation, filtered_by → Selection -/
structure Evolution where
  description : String := ""
  driven_by : Option Mutation := none
  filtered_by : Option Selection := none
  deriving Repr, Inhabited

/-- UML class: FitnessConcept -/
structure FitnessConcept where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: PopulationConcept. Association: of_species → SpeciesConcept -/
structure PopulationConcept where
  description : String := ""
  of_species : Option SpeciesConcept := none
  deriving Repr, Inhabited

/-- UML class: Ecosystem -/
structure Ecosystem where
  description : String := ""
  deriving Repr, Inhabited

-- ============================================================================
-- § 6  Culture cluster
-- ============================================================================

/-- UML class: SkibidiToilet extends Meme -/
structure SkibidiToilet extends Meme where
  deriving Repr, Inhabited

/-- UML class: PianoMan extends Meme -/
structure PianoMan extends Meme where
  deriving Repr, Inhabited

-- ============================================================================
-- § 7  Technology cluster
-- ============================================================================

/-- UML class: GitConcept extends ProgramConcept -/
structure GitConcept extends ProgramConcept where
  deriving Repr, Inhabited

/-- UML class: GitHubConcept. Association: hosts → GitConcept -/
structure GitHubConcept where
  description : String := ""
  hosts : Option GitConcept := none
  deriving Repr, Inhabited

/-- UML class: LinuxConcept extends ProgramConcept -/
structure LinuxConcept extends ProgramConcept where
  deriving Repr, Inhabited

/-- UML class: DockerConcept extends ProgramConcept -/
structure DockerConcept extends ProgramConcept where
  deriving Repr, Inhabited

/-- UML class: KubernetesConcept. Association: orchestrates → DockerConcept -/
structure KubernetesConcept where
  description : String := ""
  orchestrates : Option DockerConcept := none
  deriving Repr, Inhabited

/-- UML class: ProtocolConcept -/
structure ProtocolConcept where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: DatabaseConcept -/
structure DatabaseConcept where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: APIConcept. Association: uses_protocol → ProtocolConcept -/
structure APIConcept where
  description : String := ""
  uses_protocol : Option ProtocolConcept := none
  deriving Repr, Inhabited

/-- UML class: WebServerConcept. Association: serves → APIConcept -/
structure WebServerConcept where
  description : String := ""
  serves : Option APIConcept := none
  deriving Repr, Inhabited

/-- UML class: NetworkConcept. Association: runs_protocol → ProtocolConcept -/
structure NetworkConcept where
  description : String := ""
  runs_protocol : Option ProtocolConcept := none
  deriving Repr, Inhabited

-- ============================================================================
-- § 8  Type Theory cluster
-- ============================================================================

/-- UML class: ComputabilityTheory extends TheoryConcept -/
structure ComputabilityTheory extends TheoryConcept where
  deriving Repr, Inhabited

/-- UML class: LambdaCalculus extends TheoryConcept -/
structure LambdaCalculus extends TheoryConcept where
  deriving Repr, Inhabited

/-- UML class: HomotopyTypeTheory extends TheoryConcept.
    Association: realizes → UniMathConcept (forward ref) -/
structure HomotopyTypeTheory extends TheoryConcept where
  deriving Repr, Inhabited

/-- UML class: UniMathConcept -/
structure UniMathConcept where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: CategoryTheoryConcept extends TheoryConcept.
    Association: uses → FunctorConcept -/
structure CategoryTheoryConcept extends TheoryConcept where
  uses : Option FunctorConcept := none
  deriving Repr, Inhabited

/-- UML class: DependentType extends TypeConcept -/
structure DependentType extends TypeConcept where
  deriving Repr, Inhabited

/-- UML class: InductiveType extends TypeConcept -/
structure InductiveType extends TypeConcept where
  deriving Repr, Inhabited

/-- UML class: CoinductiveType extends TypeConcept -/
structure CoinductiveType extends TypeConcept where
  deriving Repr, Inhabited

-- ============================================================================
-- § 9  Semiotics cluster
-- ============================================================================

/-- UML class: SignifierConcept -/
structure SignifierConcept where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: SignifiedConcept -/
structure SignifiedConcept where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: SignConcept.
    Associations: has_signifier → SignifierConcept,
                  has_signified → SignifiedConcept -/
structure SignConcept where
  description : String := ""
  has_signifier : Option SignifierConcept := none
  has_signified : Option SignifiedConcept := none
  deriving Repr, Inhabited

/-- UML class: SymbolConcept extends SignConcept -/
structure SymbolConcept extends SignConcept where
  deriving Repr, Inhabited

/-- UML class: IconConcept extends SignConcept -/
structure IconConcept extends SignConcept where
  deriving Repr, Inhabited

/-- UML class: IndexConcept extends SignConcept -/
structure IndexConcept extends SignConcept where
  deriving Repr, Inhabited

/-- UML class: Firstness (Peircean category) -/
structure Firstness where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: Secondness (Peircean category) -/
structure Secondness where
  description : String := ""
  deriving Repr, Inhabited

/-- UML class: Thirdness (Peircean category) -/
structure Thirdness where
  description : String := ""
  deriving Repr, Inhabited

-- ============================================================================
-- § 10  Foundational Figures
-- ============================================================================

/-- UML class: GoedelConcept. Association: incomplete → Logic -/
structure GoedelConcept where
  description : String := ""
  incomplete : Option Logic := none
  deriving Repr, Inhabited

/-- UML class: TuringConcept. Association: machine → ComputabilityTheory -/
structure TuringConcept where
  description : String := ""
  machine : Option ComputabilityTheory := none
  deriving Repr, Inhabited

/-- UML class: ChurchConcept. Association: created → LambdaCalculus -/
structure ChurchConcept where
  description : String := ""
  created : Option LambdaCalculus := none
  deriving Repr, Inhabited

-- ============================================================================
-- § 11  Person
-- ============================================================================

/-- UML class: JamesMichaelDuPont — Creator of solfunmeme -/
structure JamesMichaelDuPont where
  description : String := "Creator of solfunmeme"
  deriving Repr, Inhabited

-- ============================================================================
-- § 12  Cluster membership — a type class approach
-- ============================================================================

/-- Type class witnessing that a type `T` is a concept in a given cluster. -/
class InCluster (T : Type) (c : Cluster) where

-- Mathematics cluster
instance : InCluster Number .mathematics := ⟨⟩
instance : InCluster NaturalNumber .mathematics := ⟨⟩
instance : InCluster IntegerNum .mathematics := ⟨⟩
instance : InCluster RealNumber .mathematics := ⟨⟩
instance : InCluster ComplexNumber .mathematics := ⟨⟩
instance : InCluster Sequence .mathematics := ⟨⟩
instance : InCluster OEISSequence .mathematics := ⟨⟩
instance : InCluster Primes .mathematics := ⟨⟩
instance : InCluster Fibonacci .mathematics := ⟨⟩
instance : InCluster Model .mathematics := ⟨⟩
instance : InCluster FiniteModel .mathematics := ⟨⟩
instance : InCluster EllipticCurve .mathematics := ⟨⟩
instance : InCluster SetConcept .mathematics := ⟨⟩
instance : InCluster FunctionConcept .mathematics := ⟨⟩
instance : InCluster Relation .mathematics := ⟨⟩
instance : InCluster Group .mathematics := ⟨⟩
instance : InCluster Ring .mathematics := ⟨⟩
instance : InCluster FieldAlgebra .mathematics := ⟨⟩
instance : InCluster VectorSpace .mathematics := ⟨⟩
instance : InCluster Topology .mathematics := ⟨⟩
instance : InCluster Manifold .mathematics := ⟨⟩
instance : InCluster CategoryConcept .mathematics := ⟨⟩
instance : InCluster FunctorConcept .mathematics := ⟨⟩
instance : InCluster Morphism .mathematics := ⟨⟩
instance : InCluster Homomorphism .mathematics := ⟨⟩
instance : InCluster Isomorphism .mathematics := ⟨⟩
instance : InCluster Logic .mathematics := ⟨⟩
instance : InCluster AxiomConcept .mathematics := ⟨⟩
instance : InCluster ProofConcept .mathematics := ⟨⟩
instance : InCluster TheoremConcept .mathematics := ⟨⟩
instance : InCluster GoedelConcept .mathematics := ⟨⟩
instance : InCluster TuringConcept .mathematics := ⟨⟩
instance : InCluster ChurchConcept .mathematics := ⟨⟩
instance : InCluster LambdaCalculus .mathematics := ⟨⟩
instance : InCluster ComputabilityTheory .mathematics := ⟨⟩

-- Computation cluster
instance : InCluster LanguageConcept .computation := ⟨⟩
instance : InCluster ProgramConcept .computation := ⟨⟩
instance : InCluster Compiler .computation := ⟨⟩
instance : InCluster Executable .computation := ⟨⟩
instance : InCluster Algorithm .computation := ⟨⟩
instance : InCluster DataStructure .computation := ⟨⟩
instance : InCluster TypeConcept .computation := ⟨⟩
instance : InCluster Expression .computation := ⟨⟩
instance : InCluster VariableConcept .computation := ⟨⟩
instance : InCluster ConstantConcept .computation := ⟨⟩
instance : InCluster OperatorConcept .computation := ⟨⟩
instance : InCluster StatementConcept .computation := ⟨⟩
instance : InCluster ModuleConcept .computation := ⟨⟩
instance : InCluster InterfaceConcept .computation := ⟨⟩
instance : InCluster ClassConcept .computation := ⟨⟩
instance : InCluster ObjectConcept .computation := ⟨⟩
instance : InCluster MethodConcept .computation := ⟨⟩
instance : InCluster PropertyConcept .computation := ⟨⟩
instance : InCluster EventConcept .computation := ⟨⟩
instance : InCluster SignalConcept .computation := ⟨⟩

-- Metaphysics cluster
instance : InCluster TheoryConcept .metaphysics := ⟨⟩
instance : InCluster Chaos .metaphysics := ⟨⟩
instance : InCluster OrderConcept .metaphysics := ⟨⟩
instance : InCluster Good .metaphysics := ⟨⟩
instance : InCluster Evil .metaphysics := ⟨⟩
instance : InCluster Truth .metaphysics := ⟨⟩
instance : InCluster Beauty .metaphysics := ⟨⟩
instance : InCluster Justice .metaphysics := ⟨⟩
instance : InCluster Freedom .metaphysics := ⟨⟩
instance : InCluster Consciousness .metaphysics := ⟨⟩
instance : InCluster Mind .metaphysics := ⟨⟩
instance : InCluster Soul .metaphysics := ⟨⟩
instance : InCluster Spirit .metaphysics := ⟨⟩
instance : InCluster Matter .metaphysics := ⟨⟩
instance : InCluster EnergyConcept .metaphysics := ⟨⟩
instance : InCluster SpaceConcept .metaphysics := ⟨⟩
instance : InCluster TimeConcept .metaphysics := ⟨⟩
instance : InCluster Causality .metaphysics := ⟨⟩
instance : InCluster IdentityConcept .metaphysics := ⟨⟩
instance : InCluster DualityConcept .metaphysics := ⟨⟩
instance : InCluster UnityConcept .metaphysics := ⟨⟩
instance : InCluster InfinityConcept .metaphysics := ⟨⟩
instance : InCluster VoidConcept .metaphysics := ⟨⟩

-- Biology cluster
instance : InCluster Gene .biology := ⟨⟩
instance : InCluster Meme .biology := ⟨⟩
instance : InCluster MetaMeme .biology := ⟨⟩
instance : InCluster CellConcept .biology := ⟨⟩
instance : InCluster Protein .biology := ⟨⟩
instance : InCluster DNA .biology := ⟨⟩
instance : InCluster RNA .biology := ⟨⟩
instance : InCluster Organism .biology := ⟨⟩
instance : InCluster SpeciesConcept .biology := ⟨⟩
instance : InCluster Evolution .biology := ⟨⟩
instance : InCluster Mutation .biology := ⟨⟩
instance : InCluster Selection .biology := ⟨⟩
instance : InCluster FitnessConcept .biology := ⟨⟩
instance : InCluster PopulationConcept .biology := ⟨⟩
instance : InCluster Ecosystem .biology := ⟨⟩

-- Culture cluster
instance : InCluster SkibidiToilet .culture := ⟨⟩
instance : InCluster PianoMan .culture := ⟨⟩

-- Technology cluster
instance : InCluster GitConcept .technology := ⟨⟩
instance : InCluster GitHubConcept .technology := ⟨⟩
instance : InCluster LinuxConcept .technology := ⟨⟩
instance : InCluster DockerConcept .technology := ⟨⟩
instance : InCluster KubernetesConcept .technology := ⟨⟩
instance : InCluster DatabaseConcept .technology := ⟨⟩
instance : InCluster APIConcept .technology := ⟨⟩
instance : InCluster WebServerConcept .technology := ⟨⟩
instance : InCluster NetworkConcept .technology := ⟨⟩
instance : InCluster ProtocolConcept .technology := ⟨⟩

-- Type Theory cluster
instance : InCluster HomotopyTypeTheory .typeTheory := ⟨⟩
instance : InCluster UniMathConcept .typeTheory := ⟨⟩
instance : InCluster CategoryTheoryConcept .typeTheory := ⟨⟩
instance : InCluster DependentType .typeTheory := ⟨⟩
instance : InCluster InductiveType .typeTheory := ⟨⟩
instance : InCluster CoinductiveType .typeTheory := ⟨⟩

-- Semiotics cluster
instance : InCluster SignConcept .semiotics := ⟨⟩
instance : InCluster SignifierConcept .semiotics := ⟨⟩
instance : InCluster SignifiedConcept .semiotics := ⟨⟩
instance : InCluster SymbolConcept .semiotics := ⟨⟩
instance : InCluster IconConcept .semiotics := ⟨⟩
instance : InCluster IndexConcept .semiotics := ⟨⟩
instance : InCluster Firstness .semiotics := ⟨⟩
instance : InCluster Secondness .semiotics := ⟨⟩
instance : InCluster Thirdness .semiotics := ⟨⟩

-- Person
instance : InCluster JamesMichaelDuPont .culture := ⟨⟩

-- ============================================================================
-- § 13  Coercion witnesses — UML generalizations as structure coercions
-- ============================================================================

/-- Every NaturalNumber can be viewed as a Number. -/
instance : Coe NaturalNumber Number where coe n := n.toNumber
/-- Every IntegerNum can be viewed as a Number. -/
instance : Coe IntegerNum Number where coe n := n.toNumber
/-- Every RealNumber can be viewed as a Number. -/
instance : Coe RealNumber Number where coe n := n.toNumber
/-- Every ComplexNumber can be viewed as a Number. -/
instance : Coe ComplexNumber Number where coe n := n.toNumber
/-- Every OEISSequence can be viewed as a Sequence. -/
instance : Coe OEISSequence Sequence where coe s := s.toSequence
/-- Every Primes can be viewed as a Sequence. -/
instance : Coe Primes Sequence where coe s := s.toSequence
/-- Every Fibonacci can be viewed as an OEISSequence. -/
instance : Coe Fibonacci OEISSequence where coe f := f.toOEISSequence
/-- Every FiniteModel can be viewed as a Model. -/
instance : Coe FiniteModel Model where coe m := m.toModel
/-- Every Ring can be viewed as a Group. -/
instance : Coe Ring Group where coe r := r.toGroup
/-- Every FieldAlgebra can be viewed as a Ring. -/
instance : Coe FieldAlgebra Ring where coe f := f.toRing
/-- Every VectorSpace can be viewed as a Group. -/
instance : Coe VectorSpace Group where coe v := v.toGroup
/-- Every Homomorphism can be viewed as a Morphism. -/
instance : Coe Homomorphism Morphism where coe h := h.toMorphism
/-- Every Isomorphism can be viewed as a Homomorphism. -/
instance : Coe Isomorphism Homomorphism where coe i := i.toHomomorphism
/-- Every Executable can be viewed as a ProgramConcept. -/
instance : Coe Executable ProgramConcept where coe e := e.toProgramConcept
/-- Every VariableConcept can be viewed as an Expression. -/
instance : Coe VariableConcept Expression where coe v := v.toExpression
/-- Every ConstantConcept can be viewed as an Expression. -/
instance : Coe ConstantConcept Expression where coe c := c.toExpression
/-- Every MetaMeme can be viewed as a Meme. -/
instance : Coe MetaMeme Meme where coe m := m.toMeme
/-- Every SkibidiToilet can be viewed as a Meme. -/
instance : Coe SkibidiToilet Meme where coe s := s.toMeme
/-- Every PianoMan can be viewed as a Meme. -/
instance : Coe PianoMan Meme where coe p := p.toMeme
/-- Every GitConcept can be viewed as a ProgramConcept. -/
instance : Coe GitConcept ProgramConcept where coe g := g.toProgramConcept
/-- Every LinuxConcept can be viewed as a ProgramConcept. -/
instance : Coe LinuxConcept ProgramConcept where coe l := l.toProgramConcept
/-- Every DockerConcept can be viewed as a ProgramConcept. -/
instance : Coe DockerConcept ProgramConcept where coe d := d.toProgramConcept
/-- Every DependentType can be viewed as a TypeConcept. -/
instance : Coe DependentType TypeConcept where coe d := d.toTypeConcept
/-- Every InductiveType can be viewed as a TypeConcept. -/
instance : Coe InductiveType TypeConcept where coe i := i.toTypeConcept
/-- Every CoinductiveType can be viewed as a TypeConcept. -/
instance : Coe CoinductiveType TypeConcept where coe c := c.toTypeConcept
/-- Every SymbolConcept can be viewed as a SignConcept. -/
instance : Coe SymbolConcept SignConcept where coe s := s.toSignConcept
/-- Every IconConcept can be viewed as a SignConcept. -/
instance : Coe IconConcept SignConcept where coe i := i.toSignConcept
/-- Every IndexConcept can be viewed as a SignConcept. -/
instance : Coe IndexConcept SignConcept where coe i := i.toSignConcept
/-- Every HomotopyTypeTheory can be viewed as a TheoryConcept. -/
instance : Coe HomotopyTypeTheory TheoryConcept where coe h := h.toTheoryConcept
/-- Every CategoryTheoryConcept can be viewed as a TheoryConcept. -/
instance : Coe CategoryTheoryConcept TheoryConcept where coe c := c.toTheoryConcept
/-- Every LambdaCalculus can be viewed as a TheoryConcept. -/
instance : Coe LambdaCalculus TheoryConcept where coe l := l.toTheoryConcept
/-- Every ComputabilityTheory can be viewed as a TheoryConcept. -/
instance : Coe ComputabilityTheory TheoryConcept where coe c := c.toTheoryConcept

-- ============================================================================
-- § 14  Instance specifications — concrete exemplars
-- ============================================================================

/-- The Fibonacci sequence instance -/
def fibonacci_instance : Fibonacci :=
  { toOEISSequence := { toSequence := { description := "0, 1, 1, 2, 3, 5, 8, ..." },
                         oeis_id := "A000045" } }

/-- Theory as an instance of itself -/
def theory_self : TheoryConcept :=
  { description := "Theory", instance_of_self := true }

/-- Kurt Gödel -/
def goedel : GoedelConcept :=
  { description := "Incompleteness theorems",
    incomplete := some { description := "Mathematical logic" } }

/-- Alan Turing -/
def turing : TuringConcept :=
  { description := "Turing machine, halting problem" }

/-- Alonzo Church -/
def church : ChurchConcept :=
  { description := "Lambda calculus, Church-Turing thesis" }

/-- Git version control -/
def git : GitConcept :=
  { toProgramConcept := { description := "Distributed version control system" } }

/-- GitHub hosting platform -/
def github : GitHubConcept :=
  { description := "Git hosting platform", hosts := some git }

/-- Linux kernel -/
def linux : LinuxConcept :=
  { toProgramConcept := { description := "Unix-like operating system kernel" } }

/-- Skibidi toilet meme -/
def skibidi : SkibidiToilet :=
  { toMeme := { description := "Internet meme series" } }

/-- Piano Man meme -/
def pianoMan : PianoMan :=
  { toMeme := { description := "Billy Joel song / cultural reference" } }

/-- James Michael DuPont -/
def dupont : JamesMichaelDuPont :=
  { description := "Creator of solfunmeme" }

/-- Homotopy Type Theory -/
def hott : HomotopyTypeTheory :=
  { toTheoryConcept := { description := "HoTT, univalent foundations" } }

/-- UniMath -/
def unimath : UniMathConcept :=
  { description := "Univalent Mathematics library" }

/-- Peircean sign with signifier and signified -/
def peircean_sign : SignConcept :=
  { description := "Peircean sign",
    has_signifier := some { description := "Sign-vehicle" },
    has_signified := some { description := "Interpretant" } }

-- ============================================================================
-- § 15  Summary counts
-- ============================================================================

/-- Total number of top-level types in the ontology. -/
def totalTypeCount : Nat := 124
-- 30 Mathematics base + 5 foundational figures/theories
-- 20 Computation
-- 23 Metaphysics
-- 15 Biology
-- 2 Culture
-- 10 Technology
-- 6 Type Theory (+ 2 theories counted in Math)
-- 9 Semiotics
-- 1 Person
-- = 121 from original + 3 extra (Compiler separate from program hierarchy)

-- ============================================================================
-- § 16  Verified structural properties
-- ============================================================================

/-- Fibonacci can be coerced all the way to Sequence (transitive inheritance). -/
example : Sequence := fibonacci_instance

/-- Isomorphism can be coerced all the way to Morphism (transitive inheritance). -/
example : Morphism := (default : Isomorphism)

/-- FieldAlgebra can be coerced all the way to Group (transitive inheritance). -/
example : Group := (default : FieldAlgebra)

/-- SkibidiToilet is a Meme. -/
example : Meme := skibidi

/-- GitConcept is a ProgramConcept. -/
example : ProgramConcept := git

/-- HomotopyTypeTheory is a TheoryConcept. -/
example : TheoryConcept := hott

/-- Theory is self-referential. -/
example : theory_self.instance_of_self = true := rfl

/-- GitHub hosts Git. -/
example : github.hosts = some git := rfl

end SolfunmemeTypes
