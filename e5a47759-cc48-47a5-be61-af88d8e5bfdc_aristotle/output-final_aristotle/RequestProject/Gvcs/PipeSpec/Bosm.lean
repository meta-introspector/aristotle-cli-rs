import RequestProject.Gvcs.PipeSpec.Emit

/-!
# The bill of materials, split into what is printed and what is sourced

Nothing in this development pretends that a 3-D printer makes gauges.  This
file draws the line explicitly: every component and every pipe segment of a
`PipeSpec` expands into a list of `Part`s, and each part is either

* `Sourcing.printed` — a non-standard body the rig makes on its own printer
  (manifold bodies, valve housings, pump brackets, union nuts, port bosses,
  gauge adapters, and pipe segments whose material is a printable polymer), or
* `Sourcing.sourced` — a standard, off-the-shelf item that must be in a bin
  before the build starts (pumps, valve cartridges, gauges, reservoirs,
  O-rings, PTFE tape, adhesive, fasteners, steel tube, flexible hose).

`bosm` is the **bill of sourced materials**: the list a human has to buy and
load.  `printedParts` is its complement.  `parts_partition` is the honest
statement that these two lists together are exactly the bill — no part is
counted twice and none is quietly dropped — and `partCount_partition` says the
same for the quantities.

The classification tables (`nodeParts`, `edgeParts`) are this file's modelling
assumptions about what a component is made of; every count reported downstream
is derived from them rather than asserted.
-/

namespace LifeTrac
namespace PipeSpec

/-! ## Parts -/

/-- Where a part comes from. -/
inductive Sourcing
  /-- The rig prints it. -/
  | printed
  /-- It comes out of a bin, bought in. -/
  | sourced
  deriving DecidableEq, Repr, Inhabited

/-- One line of the bill of materials. -/
structure Part where
  /-- What the part is. -/
  name : String
  /-- Printed, or bought in. -/
  sourcing : Sourcing
  /-- How many are needed. -/
  qty : ℕ
  /-- Which bin the loader arm picks it from; printed parts come off the bed. -/
  bin : String
  deriving DecidableEq, Repr, Inhabited

/-- A part the rig prints, off the print bed. -/
def printedPart (name : String) (qty : ℕ) : Part := ⟨name, .printed, qty, "bed"⟩

/-- A part that has to be bought in, out of the named bin. -/
def sourcedPart (name : String) (qty : ℕ) (bin : String) : Part := ⟨name, .sourced, qty, bin⟩

/-- Which pipe materials the printer can lay down. -/
def materialPrinted : Material → Bool
  | .pla => true
  | .petg => true
  | .nylon => true
  | .steel => false
  | .hose => false

/-! ## What each part of a circuit is made of -/

/-- The parts a component of the given kind is made of. -/
def nodeParts : NodeKind → List Part
  | .tank _ =>
      [sourcedPart "reservoir, 5 L" 1 "bin-tank", printedPart "tank port boss" 1]
  | .pump =>
      [sourcedPart "gear pump" 1 "bin-pump", sourcedPart "shaft coupling" 1 "bin-misc",
        printedPart "pump mount bracket" 1, sourcedPart "M5 cap screw" 4 "bin-fastener"]
  | .valve =>
      [printedPart "valve housing" 1, sourcedPart "valve cartridge" 1 "bin-valve",
        sourcedPart "valve spring" 1 "bin-misc", sourcedPart "M5 cap screw" 4 "bin-fastener"]
  | .manifold n =>
      [printedPart "manifold body" 1, sourcedPart "O-ring" (n + 1) "bin-seal",
        sourcedPart "M5 cap screw" 4 "bin-fastener"]
  | .gauge =>
      [sourcedPart "pressure gauge" 1 "bin-gauge", printedPart "gauge adapter" 1]

/-- The parts one end connector is made of: a printed union nut, plus whatever
seal element the joint calls for. -/
def connectorParts : Connector → List Part
  | ⟨_, .oring, _⟩ => [printedPart "union nut" 1, sourcedPart "O-ring" 1 "bin-seal"]
  | ⟨_, .ptfeTape, _⟩ => [printedPart "union nut" 1, sourcedPart "PTFE tape, 1 m" 1 "bin-seal"]
  | ⟨_, .bonded, _⟩ => [printedPart "union nut" 1, sourcedPart "anaerobic adhesive" 1 "bin-misc"]
  | ⟨_, .dry, _⟩ => [printedPart "union nut" 1]

/-- The parts a pipe segment is made of: the tube itself — printed when its
material is a printable polymer, bought in when it is steel or hose — and the
two connectors. -/
def edgeParts (e : Edge) : List Part :=
  (if materialPrinted e.material then [printedPart "pipe segment" 1]
    else [sourcedPart "tube or hose, cut to length" 1 "bin-hose"]) ++
    connectorParts e.srcJoint ++ connectorParts e.dstJoint

/-- The whole bill of materials of a circuit. -/
def allParts (s : Spec) : List Part :=
  s.nodes.flatMap (fun n => nodeParts n.kind) ++ s.edges.flatMap edgeParts

/-- The parts the rig prints. -/
def printedParts (s : Spec) : List Part :=
  (allParts s).filter fun p => p.sourcing == Sourcing.printed

/-- **The bill of sourced materials**: everything a human has to buy and load
into bins before the build starts. -/
def bosm (s : Spec) : List Part :=
  (allParts s).filter fun p => p.sourcing == Sourcing.sourced

/-- How many individual items a list of bill lines calls for. -/
def partCount (l : List Part) : ℕ := (l.map Part.qty).sum

/-! ## The split is a partition -/

theorem printedParts_printed {s : Spec} : ∀ p ∈ printedParts s, p.sourcing = Sourcing.printed := by
  intro p hp
  have := List.of_mem_filter hp
  simpa using this

theorem bosm_sourced {s : Spec} : ∀ p ∈ bosm s, p.sourcing = Sourcing.sourced := by
  intro p hp
  have := List.of_mem_filter hp
  simpa using this

/-- A bill line is *placed* when, if the rig prints it, the loader picks it off
the print bed rather than out of a bin. -/
def PartPlaced (p : Part) : Prop := p.sourcing = Sourcing.printed → p.bin = "bed"

theorem nodeParts_placed (k : NodeKind) : ∀ p ∈ nodeParts k, PartPlaced p := by
  cases k <;> simp [nodeParts, PartPlaced, printedPart, sourcedPart]

theorem connectorParts_placed (co : Connector) : ∀ p ∈ connectorParts co, PartPlaced p := by
  obtain ⟨j, sl, th⟩ := co
  cases sl <;> simp [connectorParts, PartPlaced, printedPart, sourcedPart]

theorem edgeParts_placed (e : Edge) : ∀ p ∈ edgeParts e, PartPlaced p := by
  intro p hp
  rw [edgeParts] at hp
  rcases List.mem_append.1 hp with h | h
  · rcases List.mem_append.1 h with h' | h'
    · by_cases hm : materialPrinted e.material = true <;>
        simp [hm, PartPlaced, printedPart, sourcedPart] at h' ⊢ <;> simp [h']
    · exact connectorParts_placed _ p h'
  · exact connectorParts_placed _ p h

/-- Everything the rig prints is picked off the print bed, not out of a bin. -/
theorem printedParts_bin {s : Spec} : ∀ p ∈ printedParts s, p.bin = "bed" := by
  intro p hp
  have hmem := List.mem_of_mem_filter hp
  have hpr : p.sourcing = Sourcing.printed := printedParts_printed p hp
  rw [allParts, List.mem_append] at hmem
  rcases hmem with h | h
  · obtain ⟨n, -, hn⟩ := List.mem_flatMap.1 h
    exact nodeParts_placed n.kind p hn hpr
  · obtain ⟨e, -, he⟩ := List.mem_flatMap.1 h
    exact edgeParts_placed e p he hpr

/-- **The bill splits cleanly.**  What the rig prints and what a human sources
are, together, exactly the bill of materials. -/
theorem parts_partition (s : Spec) : (printedParts s ++ bosm s).Perm (allParts s) := by
  have : bosm s = (allParts s).filter (fun p => !(p.sourcing == Sourcing.printed)) := by
    rw [bosm]
    apply List.filter_congr
    intro p _
    cases p.sourcing <;> simp
  rw [printedParts, this]
  exact List.filter_append_perm _ _

/-- And the item counts add up. -/
theorem partCount_partition (s : Spec) :
    partCount (printedParts s) + partCount (bosm s) = partCount (allParts s) := by
  have h := ((parts_partition s).map Part.qty).sum_eq
  rw [partCount, partCount, partCount, ← h, List.map_append, List.sum_append]

end PipeSpec
end LifeTrac
