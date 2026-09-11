import Mathlib.Data.List.Perm.Basic
import Mathlib.Data.List.Count
import Mathlib.Tactic

/-!
# `PipeSpec`: a specification language for hydraulic pipe circuits

This file is the grammar and the well-formedness theory of `PipeSpec`, the
specification format the rest of `RequestProject/PipeSpec/` compiles, exports
and self-applies.

A specification is a finite directed multigraph carrying the plumbing data:

* **nodes** — tanks (supply or sump), pumps, valves, manifolds and gauges, each
  with a list of *ports* (an inlet or outlet, a nominal bore, a thread form);
* **edges** — pipe segments with a length, a bore, a material and a *connector*
  at each end (joint kind, seal kind, thread form).

Well-formedness (`wf`) is a decidable predicate with three clauses:

* every node carries exactly the ports its kind demands, inlets first then
  outlets (`NodeKind.inPorts`, `NodeKind.outPorts`);
* every edge is *compatible*: both endpoints exist, the source end is an outlet
  and the destination end an inlet, the bores agree, the connector threads match
  the ports they screw into, and the seal is compatible with the pipe material;
* `portsUsedOnce` — **no dangling ports**: every port of every node is the end
  of exactly one edge, and no edge end points anywhere else.

The last clause is the interesting one.  `wf_ends_perm` turns it into a
statement about multisets — the list of edge ends is a permutation of the list
of all ports — and `wf_two_mul_edges` reads off the consequence that a
well-formed circuit has exactly twice as many ports as pipe segments.  That is
the invariant the generator of `RequestProject/PipeSpec/Emit.lean` maintains and
the export of `RequestProject/PipeSpec/Export.lean` is checked against.

Nodes and ports are addressed positionally (`Endpoint`), not by name; the
`label` fields are documentation for the human reading the manifest and are
never load-bearing.
-/

namespace LifeTrac
namespace PipeSpec

/-! ## Vocabulary -/

/-- The materials this system plumbs in. -/
inductive Material
  /-- Printed PLA — jigs and low-pressure bodies only. -/
  | pla
  /-- Printed PETG — the standard printed body material. -/
  | petg
  /-- Printed nylon — high-pressure printed bodies. -/
  | nylon
  /-- Steel tube, sourced. -/
  | steel
  /-- Flexible hose, sourced. -/
  | hose
  deriving DecidableEq, Repr, Inhabited

/-- How a joint is sealed. -/
inductive SealKind
  /-- An elastomeric O-ring in a machined or printed groove. -/
  | oring
  /-- PTFE tape on a thread. -/
  | ptfeTape
  /-- A bonded (adhesive) joint, no separate seal element. -/
  | bonded
  /-- Metal-to-metal, no seal element. -/
  | dry
  deriving DecidableEq, Repr, Inhabited

/-- How a joint is made mechanically. -/
inductive JointKind
  /-- Screwed together. -/
  | threaded
  /-- Glued or solvent-welded. -/
  | glued
  /-- Pushed onto a barb or into a face seal. -/
  | sealFit
  deriving DecidableEq, Repr, Inhabited

/-- The thread (or barb) form of a port. -/
inductive Thread
  /-- BSP parallel thread, size in sixteenths of an inch. -/
  | bsp (sixteenths : ℕ)
  /-- Metric thread, nominal diameter in millimetres. -/
  | metric (mm : ℕ)
  /-- A plain barb of the given nominal bore, for hose. -/
  | barb (mm : ℕ)
  deriving DecidableEq, Repr, Inhabited

/-- Which way a port faces. -/
inductive PortKind
  /-- Oil enters here. -/
  | inlet
  /-- Oil leaves here. -/
  | outlet
  deriving DecidableEq, Repr, Inhabited

/-- What a tank is for. -/
inductive TankRole
  /-- The reservoir the circuit draws from: one outlet, no inlet. -/
  | supply
  /-- The sump the circuit returns to: one inlet, no outlet. -/
  | sump
  deriving DecidableEq, Repr, Inhabited

/-- The kinds of node a circuit is built from. -/
inductive NodeKind
  /-- A reservoir, in one of its two roles. -/
  | tank (role : TankRole)
  /-- A pump: one inlet, one outlet. -/
  | pump
  /-- A valve: one inlet, one outlet. -/
  | valve
  /-- A manifold: one inlet, `branches` outlets. -/
  | manifold (branches : ℕ)
  /-- A pressure gauge: a dead-end tap, one inlet and no outlet. -/
  | gauge
  deriving DecidableEq, Repr, Inhabited

/-- How many inlets a node of this kind must have. -/
def NodeKind.inPorts : NodeKind → ℕ
  | .tank .supply => 0
  | .tank .sump => 1
  | .pump => 1
  | .valve => 1
  | .manifold _ => 1
  | .gauge => 1

/-- How many outlets a node of this kind must have. -/
def NodeKind.outPorts : NodeKind → ℕ
  | .tank .supply => 1
  | .tank .sump => 0
  | .pump => 1
  | .valve => 1
  | .manifold n => n
  | .gauge => 0

/-! ## Syntax -/

/-- A port: which way it faces, its nominal bore in millimetres, its thread
form. -/
structure Port where
  /-- Inlet or outlet. -/
  kind : PortKind
  /-- Nominal bore, in millimetres. -/
  bore : ℕ
  /-- The thread or barb form. -/
  thread : Thread
  deriving DecidableEq, Repr, Inhabited

/-- A node: a component with a list of ports, inlets first. -/
structure Node where
  /-- A human-readable label; never load-bearing. -/
  label : String
  /-- What kind of component it is. -/
  kind : NodeKind
  /-- Its ports, inlets first then outlets. -/
  ports : List Port
  deriving DecidableEq, Repr, Inhabited

/-- The address of a port: which node, and which of its ports. -/
structure Endpoint where
  /-- Index into `Spec.nodes`. -/
  node : ℕ
  /-- Index into that node's `ports`. -/
  port : ℕ
  deriving DecidableEq, Repr, Inhabited

/-- A connector: how one end of a pipe is joined to the port it meets. -/
structure Connector where
  /-- Threaded, glued, or pushed on. -/
  joint : JointKind
  /-- The sealing element. -/
  sealing : SealKind
  /-- The thread or barb form it mates with. -/
  thread : Thread
  deriving DecidableEq, Repr, Inhabited

/-- An edge: one pipe segment, from an outlet to an inlet. -/
structure Edge where
  /-- A human-readable label; never load-bearing. -/
  label : String
  /-- The outlet it leaves. -/
  src : Endpoint
  /-- The inlet it enters. -/
  dst : Endpoint
  /-- Cut length, in millimetres. -/
  lengthMm : ℕ
  /-- Nominal bore, in millimetres. -/
  bore : ℕ
  /-- What the segment is made of. -/
  material : Material
  /-- The connector at the source end. -/
  srcJoint : Connector
  /-- The connector at the destination end. -/
  dstJoint : Connector
  deriving DecidableEq, Repr, Inhabited

/-- A pipe-circuit specification. -/
structure Spec where
  /-- The components. -/
  nodes : List Node
  /-- The pipe segments. -/
  edges : List Edge
  deriving DecidableEq, Repr, Inhabited

/-! ## Well-formedness -/

/-- The port a given address picks out of a list of nodes, if it exists. -/
def portAtList (ns : List Node) (e : Endpoint) : Option Port :=
  (ns[e.node]?).bind fun n => n.ports[e.port]?

/-- The port a given endpoint addresses, if it exists. -/
def Spec.portAt (s : Spec) (e : Endpoint) : Option Port := portAtList s.nodes e

/-- Looking past the first node. -/
theorem portAtList_cons_succ (n : Node) (ns : List Node) (i j : ℕ) :
    portAtList (n :: ns) ⟨i + 1, j⟩ = portAtList ns ⟨i, j⟩ := by
  simp [portAtList]

/-- Looking at the first node. -/
theorem portAtList_cons_zero (n : Node) (ns : List Node) (j : ℕ) :
    portAtList (n :: ns) ⟨0, j⟩ = n.ports[j]? := by
  simp [portAtList]

/-- A node carries exactly the ports its kind demands, inlets first. -/
def nodeOk (n : Node) : Bool :=
  n.ports.map Port.kind ==
    List.replicate n.kind.inPorts PortKind.inlet ++
      List.replicate n.kind.outPorts PortKind.outlet

/-- Which seals may be used with which pipe material.  Printed bodies take an
O-ring or a bonded joint (nylon will also hold tape on a thread); steel takes
tape or a dry metal-to-metal face; hose is clamped over an O-ring seat or
bonded. -/
def sealOk : Material → SealKind → Bool
  | .pla, .oring => true
  | .pla, .bonded => true
  | .petg, .oring => true
  | .petg, .bonded => true
  | .nylon, .oring => true
  | .nylon, .ptfeTape => true
  | .steel, .ptfeTape => true
  | .steel, .dry => true
  | .hose, .oring => true
  | .hose, .bonded => true
  | _, _ => false

/-- Which joint mechanics go with which seal: tape and a dry face have to be
threaded, a bonded joint has to be glued, an O-ring is either threaded or pushed
into place. -/
def jointOk : JointKind → SealKind → Bool
  | .threaded, .oring => true
  | .threaded, .ptfeTape => true
  | .threaded, .dry => true
  | .glued, .bonded => true
  | .sealFit, .oring => true
  | _, _ => false

/-- A connector mates with the port it meets, and is a legal joint for the
material of the pipe carrying it. -/
def connectorOk (p : Port) (c : Connector) (m : Material) : Bool :=
  (c.thread == p.thread) && sealOk m c.sealing && jointOk c.joint c.sealing

/-- An edge is compatible with the spec it lives in: both ends address real
ports, it runs outlet-to-inlet, the bores agree, and both connectors mate. -/
def edgeOk (s : Spec) (e : Edge) : Bool :=
  match s.portAt e.src, s.portAt e.dst with
  | some ps, some pd =>
      (ps.kind == PortKind.outlet) && (pd.kind == PortKind.inlet) &&
        (ps.bore == e.bore) && (pd.bore == e.bore) &&
        connectorOk ps e.srcJoint e.material && connectorOk pd e.dstJoint e.material
  | _, _ => false

/-- All the ports of a list of nodes, the first of which is node `i`. -/
def portsFrom : ℕ → List Node → List Endpoint
  | _, [] => []
  | i, n :: ns =>
      (List.range n.ports.length).map (fun j => ⟨i, j⟩) ++ portsFrom (i + 1) ns

/-- Every port of the circuit, as an address. -/
def Spec.allPorts (s : Spec) : List Endpoint := portsFrom 0 s.nodes

/-- Every end of every pipe segment, as an address; two per segment. -/
def Spec.edgeEnds (s : Spec) : List Endpoint := s.edges.flatMap fun e => [e.src, e.dst]

/-- No dangling ports and no double connections: every port is the end of
exactly one segment, and no segment end points anywhere else. -/
def portsUsedOnce (s : Spec) : Bool :=
  s.allPorts.all (fun p => s.edgeEnds.count p == 1) &&
    s.edgeEnds.all (fun p => p ∈ s.allPorts)

/-- **Well-formedness.**  Every node has the ports its type requires, every edge
connects compatible ports outlet-to-inlet, and no port is left dangling. -/
def wf (s : Spec) : Bool :=
  s.nodes.all nodeOk && s.edges.all (edgeOk s) && portsUsedOnce s

/-! ## What well-formedness gives you -/

theorem wf_nodes {s : Spec} (h : wf s = true) : ∀ n ∈ s.nodes, nodeOk n = true := by
  rw [wf] at h
  simp only [Bool.and_eq_true, List.all_eq_true] at h
  exact h.1.1

theorem wf_edges {s : Spec} (h : wf s = true) : ∀ e ∈ s.edges, edgeOk s e = true := by
  rw [wf] at h
  simp only [Bool.and_eq_true, List.all_eq_true] at h
  exact h.1.2

theorem wf_usedOnce {s : Spec} (h : wf s = true) : portsUsedOnce s = true := by
  rw [wf] at h
  simp only [Bool.and_eq_true] at h
  exact h.2

/-- Each node has exactly the number of ports its kind demands. -/
theorem nodeOk_ports_length {n : Node} (h : nodeOk n = true) :
    n.ports.length = n.kind.inPorts + n.kind.outPorts := by
  have h' : n.ports.map Port.kind =
      List.replicate n.kind.inPorts PortKind.inlet ++
        List.replicate n.kind.outPorts PortKind.outlet := by
    simpa [nodeOk] using h
  simpa using congrArg List.length h'

/-- Below the first index, `portsFrom` has nothing. -/
theorem portsFrom_node_ge : ∀ (i : ℕ) (ns : List Node), ∀ p ∈ portsFrom i ns, i ≤ p.node := by
  intro i ns
  induction ns generalizing i with
  | nil => intro p hp; simp [portsFrom] at hp
  | cons n ns ih =>
      intro p hp
      rcases List.mem_append.1 hp with hp | hp
      · obtain ⟨j, -, rfl⟩ := List.mem_map.1 hp
        exact le_rfl
      · exact le_of_lt (lt_of_lt_of_le (Nat.lt_succ_self i) (ih (i + 1) p hp))

/-- The ports of a node list are distinct addresses. -/
theorem portsFrom_nodup : ∀ (i : ℕ) (ns : List Node), (portsFrom i ns).Nodup := by
  intro i ns
  induction ns generalizing i with
  | nil => simp [portsFrom]
  | cons n ns ih =>
      refine List.Nodup.append ?_ (ih (i + 1)) ?_
      · refine List.Nodup.map ?_ List.nodup_range
        intro a b hab
        simpa using hab
      · intro p hp hp'
        obtain ⟨j, -, rfl⟩ := List.mem_map.1 hp
        have := portsFrom_node_ge (i + 1) ns _ hp'
        simp at this
  
theorem Spec.allPorts_nodup (s : Spec) : s.allPorts.Nodup := portsFrom_nodup 0 s.nodes

/-- Two ends to a pipe. -/
theorem Spec.edgeEnds_length (s : Spec) : s.edgeEnds.length = 2 * s.edges.length := by
  simp only [Spec.edgeEnds]
  induction s.edges with
  | nil => simp
  | cons e es ih => simp at ih ⊢; omega

/-- **The connection invariant.**  In a well-formed spec the ends of the pipe
segments are, as a multiset, exactly the ports of the components: nothing is
left dangling and nothing is connected twice. -/
theorem wf_ends_perm {s : Spec} (h : wf s = true) : s.edgeEnds.Perm s.allPorts := by
  have h' := wf_usedOnce h
  rw [portsUsedOnce] at h'
  simp only [Bool.and_eq_true, List.all_eq_true, beq_iff_eq, decide_eq_true_eq] at h'
  obtain ⟨h1, h2⟩ := h'
  refine List.perm_iff_count.2 fun a => ?_
  by_cases ha : a ∈ s.allPorts
  · rw [h1 a ha, List.count_eq_one_of_mem s.allPorts_nodup ha]
  · have hz : s.edgeEnds.count a = 0 := by
      rw [List.count_eq_zero]
      exact fun hmem => ha (h2 a hmem)
    rw [hz, List.count_eq_zero_of_not_mem ha]

/-- The connection invariant is enough: a spec whose edge ends are a
permutation of its ports has no dangling ports and no double connections. -/
theorem portsUsedOnce_of_perm {s : Spec} (h : s.edgeEnds.Perm s.allPorts) :
    portsUsedOnce s = true := by
  rw [portsUsedOnce]
  simp only [Bool.and_eq_true, List.all_eq_true, beq_iff_eq, decide_eq_true_eq]
  refine ⟨fun p hp => ?_, fun p hp => ?_⟩
  · rw [h.count_eq, List.count_eq_one_of_mem s.allPorts_nodup hp]
  · exact h.mem_iff.1 hp

/-- A well-formed circuit has exactly two ports per pipe segment. -/
theorem wf_two_mul_edges {s : Spec} (h : wf s = true) :
    s.allPorts.length = 2 * s.edges.length := by
  rw [← (wf_ends_perm h).length_eq, s.edgeEnds_length]

/-- In a well-formed spec, every edge end addresses a real port. -/
theorem wf_portAt_isSome {s : Spec} (h : wf s = true) {e : Edge} (he : e ∈ s.edges) :
    (s.portAt e.src).isSome ∧ (s.portAt e.dst).isSome := by
  have h' := wf_edges h e he
  unfold edgeOk at h'
  cases hs : s.portAt e.src <;> cases hd : s.portAt e.dst <;>
    simp [hs, hd] at h' ⊢

/-- In a well-formed spec, every edge runs from an outlet to an inlet, and the
bores of the two ports and the pipe all agree. -/
theorem wf_edge_compatible {s : Spec} (h : wf s = true) {e : Edge} (he : e ∈ s.edges) :
    ∃ ps pd, s.portAt e.src = some ps ∧ s.portAt e.dst = some pd ∧
      ps.kind = PortKind.outlet ∧ pd.kind = PortKind.inlet ∧
      ps.bore = e.bore ∧ pd.bore = e.bore ∧
      connectorOk ps e.srcJoint e.material = true ∧
      connectorOk pd e.dstJoint e.material = true := by
  have h' := wf_edges h e he
  unfold edgeOk at h'
  cases hs : s.portAt e.src with
  | none => simp [hs] at h'
  | some ps =>
      cases hd : s.portAt e.dst with
      | none => simp [hs, hd] at h'
      | some pd =>
          rw [hs, hd] at h'
          simp only [Bool.and_eq_true, beq_iff_eq] at h'
          obtain ⟨⟨⟨⟨⟨h1, h2⟩, h3⟩, h4⟩, h5⟩, h6⟩ := h'
          exact ⟨ps, pd, rfl, rfl, h1, h2, h3, h4, h5, h6⟩

/-- The seal on every connector of a well-formed spec is compatible with the
material of the pipe it seals, and its mechanics match the seal. -/
theorem wf_seal_compatible {s : Spec} (h : wf s = true) {e : Edge} (he : e ∈ s.edges) :
    sealOk e.material e.srcJoint.sealing = true ∧ jointOk e.srcJoint.joint e.srcJoint.sealing = true ∧
      sealOk e.material e.dstJoint.sealing = true ∧
      jointOk e.dstJoint.joint e.dstJoint.sealing = true := by
  obtain ⟨ps, pd, -, -, -, -, -, -, hcs, hcd⟩ := wf_edge_compatible h he
  simp only [connectorOk, Bool.and_eq_true] at hcs hcd
  exact ⟨hcs.1.2, hcs.2, hcd.1.2, hcd.2⟩

end PipeSpec
end LifeTrac
