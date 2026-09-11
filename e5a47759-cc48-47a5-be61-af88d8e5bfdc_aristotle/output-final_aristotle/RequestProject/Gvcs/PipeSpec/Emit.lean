import RequestProject.Gvcs.PipeSpec.Grammar

/-!
# The verified generator: `emitPipeSpec`

A **circuit description term** (`Desc`) is a tree: a chain of pumps and valves,
manifolds that fan out into sub-trees, and two kinds of leaf — a gauge tap and a
return sump.  `emitPipeSpec` compiles such a term, together with a
`Cfg` (bore, pipe material, segment length), into a `PipeSpec.Spec`: it lays the
components out in depth-first order, hangs a supply tank at the root, and runs
one pipe segment into every component.

The theorem of this file is `emit_wf`:

> for every configuration `c` and every description `d`, `wf (emitPipeSpec c d)`.

So the generator cannot emit a circuit with a port left open, a port connected
twice, a pipe run backwards into an outlet, a bore mismatch or a seal the pipe
material will not take — those are exactly the clauses of `wf`.

The proof keeps three invariants through the recursion (`emitAt_inv`):

* every emitted node is a `mkNode c` and every emitted segment a `mkEdge c`
  (uniformity — this is what makes bores and threads match everywhere);
* the destinations of the emitted segments are, in order, the inlets
  `⟨base, 0⟩, ⟨base+1, 0⟩, …` of the emitted nodes — every component is fed
  exactly once (all component kinds other than the supply tank have exactly one
  inlet);
* the sources of the emitted segments are, as a multiset, the parent outlet
  handed in plus every outlet of the emitted nodes — every outlet is used
  exactly once.

Together the last two say the segment ends are a permutation of the ports, which
is the `portsUsedOnce` clause of `wf` (`Grammar.portsUsedOnce_of_perm`).
-/

namespace LifeTrac
namespace PipeSpec

/-! ## Description terms -/

/-- A circuit description term: the input to the generator. -/
inductive Desc where
  /-- A dead-end pressure gauge. -/
  | gauge
  /-- A return line to the sump. -/
  | sump
  /-- A pump, and what it feeds. -/
  | pump (rest : Desc)
  /-- A valve, and what it feeds. -/
  | valve (rest : Desc)
  /-- A manifold, and what hangs off each of its outlets. -/
  | manifold (kids : List Desc)
  deriving Repr, Inhabited

mutual

/-- How many components a description term calls for. -/
def Desc.size : Desc → ℕ
  | .gauge => 1
  | .sump => 1
  | .pump d => 1 + d.size
  | .valve d => 1 + d.size
  | .manifold ds => 1 + Desc.sizes ds

/-- How many components a list of sub-trees calls for. -/
def Desc.sizes : List Desc → ℕ
  | [] => 0
  | d :: ds => d.size + Desc.sizes ds

end

/-- The node kind a description term asks for at its root. -/
def Desc.kind : Desc → NodeKind
  | .gauge => .gauge
  | .sump => .tank .sump
  | .pump _ => .pump
  | .valve _ => .valve
  | .manifold ds => .manifold ds.length

/-- The label the generator gives the root component of a term. -/
def Desc.label : Desc → String
  | .gauge => "gauge"
  | .sump => "sump"
  | .pump _ => "pump"
  | .valve _ => "valve"
  | .manifold _ => "manifold"

/-- Every component a description term asks for takes oil in through exactly one
inlet. -/
theorem Desc.kind_inPorts (d : Desc) : d.kind.inPorts = 1 := by
  cases d <;> rfl

/-! ## The configuration -/

/-- The parameters the generator plumbs a term with. -/
structure Cfg where
  /-- Nominal bore of every port and pipe, in millimetres. -/
  bore : ℕ
  /-- What the pipe segments are made of. -/
  mat : Material
  /-- Cut length of a pipe segment, in millimetres. -/
  segMm : ℕ
  deriving DecidableEq, Repr, Inhabited

/-- The thread a port of the given bore carries: a metric thread six
millimetres over the bore. -/
def threadFor (bore : ℕ) : Thread := Thread.metric (bore + 6)

/-- The connector the generator fits: an O-ring on a thread, or PTFE tape where
the pipe is steel. -/
def connFor (c : Cfg) : Connector :=
  match c.mat with
  | .steel => ⟨.threaded, .ptfeTape, threadFor c.bore⟩
  | _ => ⟨.threaded, .oring, threadFor c.bore⟩

/-- The connector the generator fits is always a legal joint for the pipe
material it is fitted to. -/
theorem connFor_ok (c : Cfg) (p : Port) (hb : p.bore = c.bore) (ht : p.thread = threadFor c.bore) :
    connectorOk p (connFor c) c.mat = true := by
  obtain ⟨pk, pb, pt⟩ := p
  cases hmat : c.mat <;>
    simp_all [connectorOk, connFor, sealOk, jointOk, threadFor]

/-- A generated inlet. -/
def inPort (c : Cfg) : Port := ⟨.inlet, c.bore, threadFor c.bore⟩

/-- A generated outlet. -/
def outPort (c : Cfg) : Port := ⟨.outlet, c.bore, threadFor c.bore⟩

/-- A generated component: the ports its kind demands, inlets first. -/
def mkNode (c : Cfg) (label : String) (k : NodeKind) : Node :=
  ⟨label, k, List.replicate k.inPorts (inPort c) ++ List.replicate k.outPorts (outPort c)⟩

/-- A generated pipe segment. -/
def mkEdge (c : Cfg) (label : String) (src dst : Endpoint) : Edge :=
  ⟨label, src, dst, c.segMm, c.bore, c.mat, connFor c, connFor c⟩

/-- Generated components have the ports their kind demands. -/
theorem mkNode_ok (c : Cfg) (l : String) (k : NodeKind) : nodeOk (mkNode c l k) = true := by
  simp [nodeOk, mkNode, inPort, outPort, List.map_append, List.map_replicate]

/-- A generated component has as many ports as its kind demands. -/
theorem mkNode_ports_length (c : Cfg) (l : String) (k : NodeKind) :
    (mkNode c l k).ports.length = k.inPorts + k.outPorts := by
  simp [mkNode]

/-! ## The generator -/

mutual

/-- Compile a description term, given the parent outlet it hangs from and the
index `base` its root component will occupy. -/
def emitAt (c : Cfg) (parent : Endpoint) (base : ℕ) : Desc → List Node × List Edge
  | .gauge => ([mkNode c "gauge" .gauge], [mkEdge c "seg" parent ⟨base, 0⟩])
  | .sump => ([mkNode c "sump" (.tank .sump)], [mkEdge c "seg" parent ⟨base, 0⟩])
  | .pump d =>
      let r := emitAt c ⟨base, 1⟩ (base + 1) d
      (mkNode c "pump" .pump :: r.1, mkEdge c "seg" parent ⟨base, 0⟩ :: r.2)
  | .valve d =>
      let r := emitAt c ⟨base, 1⟩ (base + 1) d
      (mkNode c "valve" .valve :: r.1, mkEdge c "seg" parent ⟨base, 0⟩ :: r.2)
  | .manifold ds =>
      let r := emitKids c base 1 (base + 1) ds
      (mkNode c "manifold" (.manifold ds.length) :: r.1,
        mkEdge c "seg" parent ⟨base, 0⟩ :: r.2)

/-- Compile the sub-trees hanging off outlets `port, port+1, …` of the manifold
at index `hub`, laying their components out from index `base`. -/
def emitKids (c : Cfg) (hub port base : ℕ) : List Desc → List Node × List Edge
  | [] => ([], [])
  | d :: ds =>
      let r := emitAt c ⟨hub, port⟩ base d
      let t := emitKids c hub (port + 1) (base + r.1.length) ds
      (r.1 ++ t.1, r.2 ++ t.2)

end

/-- **The generator.**  A description term and a configuration compile to a
circuit: a supply tank at index `0`, then the components of the term. -/
def emitPipeSpec (c : Cfg) (d : Desc) : Spec :=
  let r := emitAt c ⟨0, 0⟩ 1 d
  ⟨mkNode c "supply tank" (.tank .supply) :: r.1, r.2⟩

/-! ## Bookkeeping for the invariants -/

/-- The outlets of the node at index `i`. -/
def nodeOutlets (i : ℕ) (n : Node) : List Endpoint :=
  (List.range n.kind.outPorts).map fun j => ⟨i, n.kind.inPorts + j⟩

/-- The outlets of a list of nodes, the first of which is node `i`. -/
def outletsFrom : ℕ → List Node → List Endpoint
  | _, [] => []
  | i, n :: ns => nodeOutlets i n ++ outletsFrom (i + 1) ns

/-- The inlets `⟨base, 0⟩, …, ⟨base + k - 1, 0⟩` of `k` single-inlet
components. -/
def inletHeads (base k : ℕ) : List Endpoint :=
  (List.range k).map fun i => ⟨base + i, 0⟩

/-- A list of nodes is *generated* by `c` when every node in it is a
`mkNode c`. -/
def Generated (c : Cfg) (ns : List Node) : Prop :=
  ∀ n ∈ ns, ∃ l k, n = mkNode c l k

/-- A list of nodes is *fed* when every node in it has exactly one inlet — true
of every component except a supply tank. -/
def SingleInlet (ns : List Node) : Prop := ∀ n ∈ ns, n.kind.inPorts = 1

theorem outletsFrom_append (i : ℕ) (ns₁ ns₂ : List Node) :
    outletsFrom i (ns₁ ++ ns₂) = outletsFrom i ns₁ ++ outletsFrom (i + ns₁.length) ns₂ := by
  induction ns₁ generalizing i with
  | nil => simp [outletsFrom]
  | cons n ns ih =>
      have : i + 1 + ns.length = i + (ns.length + 1) := by omega
      simp [outletsFrom, ih, List.append_assoc, this]

@[simp] theorem inletHeads_zero (base : ℕ) : inletHeads base 0 = [] := by simp [inletHeads]

@[simp] theorem inletHeads_one (base : ℕ) : inletHeads base 1 = [⟨base, 0⟩] := by
  simp [inletHeads]

theorem inletHeads_append (base k₁ k₂ : ℕ) :
    inletHeads base (k₁ + k₂) = inletHeads base k₁ ++ inletHeads (base + k₁) k₂ := by
  simp only [inletHeads, List.range_add, List.map_append, List.map_map]
  congr 1
  apply List.map_congr_left
  intro i _
  simp [Function.comp, Nat.add_assoc]

theorem inletHeads_succ (base k : ℕ) :
    inletHeads base (k + 1) = ⟨base, 0⟩ :: inletHeads (base + 1) k := by
  rw [Nat.add_comm k 1, inletHeads_append, inletHeads_one]
  rfl

/-- The outlets of a generated component. -/
theorem nodeOutlets_mkNode (c : Cfg) (i : ℕ) (l : String) (k : NodeKind) :
    nodeOutlets i (mkNode c l k) = (List.range k.outPorts).map fun j => ⟨i, k.inPorts + j⟩ := rfl

/-- Peeling the first sub-tree off a manifold's list of outlets. -/
theorem hubPorts_succ (hub port k : ℕ) :
    (List.range (k + 1)).map (fun i => (⟨hub, port + i⟩ : Endpoint)) =
      ⟨hub, port⟩ :: (List.range k).map fun i => ({ node := hub, port := port + 1 + i } : Endpoint) := by
  rw [List.range_succ_eq_map]
  simp only [List.map_cons, List.map_map, Nat.add_zero, Function.comp_def]
  congr 1
  apply List.map_congr_left
  intro i _
  simp [Nat.add_comm, Nat.add_left_comm]

/-! ## The invariant -/

/-- What the generator guarantees about a piece of circuit it emits: the
components are all generated single-inlet components, the segments are all
generated segments, the segments feed the components' inlets one for one, and
the segments leave, between them, exactly the outlets handed in from above
together with every outlet of the new components. -/
structure EmitInv (c : Cfg) (parents : List Endpoint) (base : ℕ) (ns : List Node)
    (es : List Edge) : Prop where
  /-- Every component is a generated component. -/
  gen : Generated c ns
  /-- Every component takes oil in through exactly one inlet. -/
  single : SingleInlet ns
  /-- Every segment is a generated segment. -/
  edgesGen : ∀ e ∈ es, ∃ l s t, e = mkEdge c l s t
  /-- The segments feed the components' inlets, in order. -/
  dsts : es.map Edge.dst = inletHeads base ns.length
  /-- The segments leave the outlets handed in plus the new components'
  outlets. -/
  srcs : (↑(es.map Edge.src) : Multiset Endpoint) = ↑parents + ↑(outletsFrom base ns)

/-- **The generator maintains the invariant.**  Proved simultaneously for terms
and for lists of sub-trees. -/
theorem emitAt_inv (d : Desc) : ∀ (c : Cfg) (parent : Endpoint) (base : ℕ),
    EmitInv c [parent] base (emitAt c parent base d).1 (emitAt c parent base d).2 := by
  induction d using Desc.rec
    (motive_2 := fun ds => ∀ (c : Cfg) (hub port base : ℕ),
      EmitInv c ((List.range ds.length).map fun i => ⟨hub, port + i⟩) base
        (emitKids c hub port base ds).1 (emitKids c hub port base ds).2) with
  | gauge =>
      intro c parent base
      refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> simp [emitAt, Generated, SingleInlet, inletHeads,
        outletsFrom, nodeOutlets, mkNode, mkEdge, NodeKind.inPorts, NodeKind.outPorts]
  | sump =>
      intro c parent base
      refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> simp [emitAt, Generated, SingleInlet, inletHeads,
        outletsFrom, nodeOutlets, mkNode, mkEdge, NodeKind.inPorts, NodeKind.outPorts]
  | pump d ih =>
      intro c parent base
      obtain ⟨g, sg, eg, hd, hs⟩ := ih c ⟨base, 1⟩ (base + 1)
      refine ⟨?_, ?_, ?_, ?_, ?_⟩
      · intro n hn
        simp only [emitAt, List.mem_cons] at hn
        rcases hn with rfl | hn
        · exact ⟨"pump", .pump, rfl⟩
        · exact g n hn
      · intro n hn
        simp only [emitAt, List.mem_cons] at hn
        rcases hn with rfl | hn
        · rfl
        · exact sg n hn
      · intro e he
        simp only [emitAt, List.mem_cons] at he
        rcases he with rfl | he
        · exact ⟨"seg", parent, ⟨base, 0⟩, rfl⟩
        · exact eg e he
      · simp only [emitAt, List.map_cons, hd, List.length_cons]
        rw [inletHeads_succ]
        rfl
      · simp only [emitAt, List.map_cons, outletsFrom]
        rw [← Multiset.cons_coe, hs]
        simp [nodeOutlets, mkNode, mkEdge, NodeKind.inPorts, NodeKind.outPorts,
          ← Multiset.cons_coe, Multiset.cons_swap]
  | valve d ih =>
      intro c parent base
      obtain ⟨g, sg, eg, hd, hs⟩ := ih c ⟨base, 1⟩ (base + 1)
      refine ⟨?_, ?_, ?_, ?_, ?_⟩
      · intro n hn
        simp only [emitAt, List.mem_cons] at hn
        rcases hn with rfl | hn
        · exact ⟨"valve", .valve, rfl⟩
        · exact g n hn
      · intro n hn
        simp only [emitAt, List.mem_cons] at hn
        rcases hn with rfl | hn
        · rfl
        · exact sg n hn
      · intro e he
        simp only [emitAt, List.mem_cons] at he
        rcases he with rfl | he
        · exact ⟨"seg", parent, ⟨base, 0⟩, rfl⟩
        · exact eg e he
      · simp only [emitAt, List.map_cons, hd, List.length_cons]
        rw [inletHeads_succ]
        rfl
      · simp only [emitAt, List.map_cons, outletsFrom]
        rw [← Multiset.cons_coe, hs]
        simp [nodeOutlets, mkNode, mkEdge, NodeKind.inPorts, NodeKind.outPorts,
          ← Multiset.cons_coe, Multiset.cons_swap]
  | manifold ds ih =>
      intro c parent base
      obtain ⟨g, sg, eg, hd, hs⟩ := ih c base 1 (base + 1)
      refine ⟨?_, ?_, ?_, ?_, ?_⟩
      · intro n hn
        simp only [emitAt, List.mem_cons] at hn
        rcases hn with rfl | hn
        · exact ⟨"manifold", .manifold ds.length, rfl⟩
        · exact g n hn
      · intro n hn
        simp only [emitAt, List.mem_cons] at hn
        rcases hn with rfl | hn
        · rfl
        · exact sg n hn
      · intro e he
        simp only [emitAt, List.mem_cons] at he
        rcases he with rfl | he
        · exact ⟨"seg", parent, ⟨base, 0⟩, rfl⟩
        · exact eg e he
      · simp only [emitAt, List.map_cons, hd, List.length_cons]
        rw [inletHeads_succ]
        rfl
      · simp only [emitAt, List.map_cons, outletsFrom]
        rw [← Multiset.cons_coe, hs, nodeOutlets_mkNode]
        simp [mkEdge, NodeKind.inPorts, NodeKind.outPorts, ← Multiset.coe_add]
  | nil =>
      rename_i c hub port base
      refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;>
        simp [emitKids, Generated, SingleInlet, outletsFrom]
  | cons d ds ihd ihds =>
      rename_i c hub port base
      obtain ⟨g₁, s₁, e₁, hd₁, hs₁⟩ := ihd c ⟨hub, port⟩ base
      obtain ⟨g₂, s₂, e₂, hd₂, hs₂⟩ :=
        ihds c hub (port + 1) (base + (emitAt c ⟨hub, port⟩ base d).1.length)
      refine ⟨?_, ?_, ?_, ?_, ?_⟩
      · intro n hn
        simp only [emitKids, List.mem_append] at hn
        rcases hn with hn | hn
        · exact g₁ n hn
        · exact g₂ n hn
      · intro n hn
        simp only [emitKids, List.mem_append] at hn
        rcases hn with hn | hn
        · exact s₁ n hn
        · exact s₂ n hn
      · intro e he
        simp only [emitKids, List.mem_append] at he
        rcases he with he | he
        · exact e₁ e he
        · exact e₂ e he
      · simp only [emitKids, List.map_append, hd₁, hd₂, List.length_append]
        rw [inletHeads_append]
      · simp only [emitKids, List.map_append, List.length_cons]
        rw [← Multiset.coe_add, hs₁, hs₂, outletsFrom_append, hubPorts_succ]
        simp [← Multiset.coe_add, ← Multiset.cons_coe, add_comm, add_left_comm, add_assoc]

/-! ## Reading the ports back off a generated circuit -/

/-- The first port of a generated single-inlet component is its inlet. -/
theorem mkNode_port_zero (c : Cfg) (l : String) (k : NodeKind) (h : k.inPorts = 1) :
    (mkNode c l k).ports[0]? = some (inPort c) := by
  simp [mkNode, h]

/-- The ports of a generated component past its inlets are its outlets. -/
theorem mkNode_port_out (c : Cfg) (l : String) (k : NodeKind) (j : ℕ) (hj : j < k.outPorts) :
    (mkNode c l k).ports[k.inPorts + j]? = some (outPort c) := by
  simp [mkNode, hj]

/-- Port `0` of every generated single-inlet component is a generated inlet. -/
theorem inlet_portAt (c : Cfg) : ∀ (ns : List Node), Generated c ns → SingleInlet ns →
    ∀ i, i < ns.length → portAtList ns ⟨i, 0⟩ = some (inPort c) := by
  intro ns
  induction ns with
  | nil => intro _ _ i hi; simp at hi
  | cons n ns ih =>
      intro hg hsi i hi
      cases i with
      | zero =>
          obtain ⟨l, k, rfl⟩ := hg n (by simp)
          rw [portAtList_cons_zero]
          exact mkNode_port_zero c l k (hsi (mkNode c l k) (by simp))
      | succ i =>
          rw [portAtList_cons_succ]
          exact ih (fun m hm => hg m (by simp [hm])) (fun m hm => hsi m (by simp [hm])) i
            (by simpa using hi)

/-- Every address in `outletsFrom` is a generated outlet of the list it came
from. -/
theorem outlet_portAt (c : Cfg) : ∀ (ns : List Node) (base : ℕ) (p : Endpoint), Generated c ns →
    p ∈ outletsFrom base ns →
      base ≤ p.node ∧ portAtList ns ⟨p.node - base, p.port⟩ = some (outPort c) := by
  intro ns
  induction ns with
  | nil => intro base p _ hp; simp [outletsFrom] at hp
  | cons n ns ih =>
      intro base p hg hp
      obtain ⟨l, k, rfl⟩ := hg n (by simp)
      rw [outletsFrom] at hp
      rcases List.mem_append.1 hp with h | h
      · rw [nodeOutlets_mkNode] at h
        obtain ⟨j, hj, rfl⟩ := List.mem_map.1 h
        refine ⟨le_rfl, ?_⟩
        simp only [Nat.sub_self]
        rw [portAtList_cons_zero]
        exact mkNode_port_out c l k j (List.mem_range.1 hj)
      · obtain ⟨hb, hpt⟩ := ih (base + 1) p (fun m hm => hg m (by simp [hm])) h
        refine ⟨by omega, ?_⟩
        rw [show p.node - base = (p.node - (base + 1)) + 1 by omega, portAtList_cons_succ]
        exact hpt

/-- The ports of a generated single-inlet component list, split into the inlets
and the outlets. -/
theorem portsFrom_multiset (c : Cfg) : ∀ (ns : List Node) (base : ℕ), Generated c ns →
    SingleInlet ns →
      (↑(portsFrom base ns) : Multiset Endpoint) =
        ↑(inletHeads base ns.length) + ↑(outletsFrom base ns) := by
  intro ns
  induction ns with
  | nil => intro base _ _; simp [portsFrom, outletsFrom]
  | cons n ns ih =>
      intro base hg hsi
      obtain ⟨l, k, rfl⟩ := hg n (by simp)
      have hk : k.inPorts = 1 := hsi (mkNode c l k) (by simp)
      have hlen : (mkNode c l k).ports.length = 1 + k.outPorts := by
        rw [mkNode_ports_length, hk]
      have hhead : (List.range (mkNode c l k).ports.length).map (fun j => (⟨base, j⟩ : Endpoint)) =
          ⟨base, 0⟩ :: (List.range k.outPorts).map fun j => (⟨base, 1 + j⟩ : Endpoint) := by
        rw [hlen, List.range_add]
        simp [Function.comp_def]
      have hout : outletsFrom base (mkNode c l k :: ns) =
          ((List.range k.outPorts).map fun j => (⟨base, 1 + j⟩ : Endpoint)) ++
            outletsFrom (base + 1) ns := by
        rw [outletsFrom, nodeOutlets_mkNode, hk]
      have hih := ih (base + 1) (fun m hm => hg m (by simp [hm])) (fun m hm => hsi m (by simp [hm]))
      rw [portsFrom, hhead, hout, List.length_cons, inletHeads_succ]
      simp only [← Multiset.coe_add, ← Multiset.cons_coe, hih, Multiset.cons_add]
      congr 1
      exact add_left_comm _ _ _

/-! ## The generated circuit is well-formed -/

/-- The ends of a list of segments, split into sources and destinations. -/
theorem edgeEnds_multiset (es : List Edge) :
    (↑(es.flatMap fun e => [e.src, e.dst]) : Multiset Endpoint) =
      ↑(es.map Edge.src) + ↑(es.map Edge.dst) := by
  induction es with
  | nil => simp
  | cons e es ih =>
      simp only [List.flatMap_cons, List.map_cons, ← Multiset.coe_add, ← Multiset.cons_coe, ih,
        Multiset.cons_add, Multiset.add_cons, Multiset.coe_nil, zero_add]
      exact Multiset.cons_swap _ _ _

@[simp] theorem emitPipeSpec_nodes (c : Cfg) (d : Desc) :
    (emitPipeSpec c d).nodes =
      mkNode c "supply tank" (.tank .supply) :: (emitAt c ⟨0, 0⟩ 1 d).1 := rfl

@[simp] theorem emitPipeSpec_edges (c : Cfg) (d : Desc) :
    (emitPipeSpec c d).edges = (emitAt c ⟨0, 0⟩ 1 d).2 := rfl

/-- **The generated circuit is well-formed.**  Every component carries the ports
its type demands, every segment runs from an outlet to an inlet of matching bore
with a seal its material will take, and no port anywhere in the circuit is left
dangling or connected twice. -/
theorem emit_wf (c : Cfg) (d : Desc) : wf (emitPipeSpec c d) = true := by
  obtain ⟨g, sg, eg, hd, hs⟩ := emitAt_inv d c ⟨0, 0⟩ 1
  set ns := (emitAt c ⟨0, 0⟩ 1 d).1 with hns
  set es := (emitAt c ⟨0, 0⟩ 1 d).2 with hes
  set tank := mkNode c "supply tank" (NodeKind.tank .supply) with htank
  have htankPort : portAtList (tank :: ns) ⟨0, 0⟩ = some (outPort c) := by
    rw [portAtList_cons_zero, htank]
    simpa using mkNode_port_out c "supply tank" (.tank .supply) 0 (by decide)
  have hdst : ∀ e ∈ es, (emitPipeSpec c d).portAt e.dst = some (inPort c) := by
    intro e he
    have hmem : e.dst ∈ inletHeads 1 ns.length := by
      rw [← hd]; exact List.mem_map_of_mem he
    obtain ⟨i, hi, hEq⟩ := List.mem_map.1 hmem
    rw [Spec.portAt, emitPipeSpec_nodes, ← hns, ← htank, ← hEq,
      show (1 : ℕ) + i = i + 1 by omega, portAtList_cons_succ]
    exact inlet_portAt c ns g sg i (List.mem_range.1 hi)
  have hsrc : ∀ e ∈ es, (emitPipeSpec c d).portAt e.src = some (outPort c) := by
    intro e he
    have hmem : e.src ∈ (↑(es.map Edge.src) : Multiset Endpoint) :=
      Multiset.mem_coe.2 (List.mem_map_of_mem he)
    rw [hs] at hmem
    rw [Spec.portAt, emitPipeSpec_nodes, ← hns, ← htank]
    rcases Multiset.mem_add.1 hmem with h | h
    · have : e.src = ⟨0, 0⟩ := by simpa using h
      rw [this]; exact htankPort
    · obtain ⟨hb, hp⟩ := outlet_portAt c ns 1 e.src g (Multiset.mem_coe.1 h)
      have hEq : e.src = ⟨(e.src.node - 1) + 1, e.src.port⟩ := by
        rw [show e.src.node - 1 + 1 = e.src.node by omega]
      have hstep : portAtList (tank :: ns) e.src = portAtList ns ⟨e.src.node - 1, e.src.port⟩ := by
        conv_lhs => rw [hEq]
        exact portAtList_cons_succ _ _ _ _
      rw [hstep]
      exact hp
  have hedge : ∀ e ∈ es, edgeOk (emitPipeSpec c d) e = true := by
    intro e he
    obtain ⟨l, s', t', rfl⟩ := eg e he
    have h1 := hsrc _ he
    have h2 := hdst _ he
    unfold edgeOk
    rw [h1, h2]
    simp only [mkEdge, inPort, outPort, beq_self_eq_true, Bool.and_true, Bool.true_and,
      Bool.and_eq_true]
    exact ⟨connFor_ok c (outPort c) rfl rfl, connFor_ok c (inPort c) rfl rfl⟩
  have hperm : (emitPipeSpec c d).edgeEnds.Perm (emitPipeSpec c d).allPorts := by
    rw [← Multiset.coe_eq_coe]
    have hports : (↑((emitPipeSpec c d).allPorts) : Multiset Endpoint) =
        ⟨0, 0⟩ ::ₘ (↑(inletHeads 1 ns.length) + ↑(outletsFrom 1 ns)) := by
      rw [Spec.allPorts, emitPipeSpec_nodes, ← hns, ← htank, portsFrom]
      rw [← portsFrom_multiset c ns 1 g sg]
      have : (List.range tank.ports.length).map (fun j => (⟨0, j⟩ : Endpoint)) = [⟨0, 0⟩] := by
        rw [htank, mkNode_ports_length]
        rfl
      rw [this]
      simp [← Multiset.cons_coe]
    rw [hports, Spec.edgeEnds, emitPipeSpec_edges, ← hes, edgeEnds_multiset, hs, hd]
    simp [← Multiset.cons_coe, add_comm]
  rw [wf]
  simp only [Bool.and_eq_true, List.all_eq_true]
  refine ⟨⟨?_, ?_⟩, portsUsedOnce_of_perm hperm⟩
  · intro n hn
    rw [emitPipeSpec_nodes, ← hns, ← htank] at hn
    rcases List.mem_cons.1 hn with rfl | hn
    · rw [htank]; exact mkNode_ok _ _ _
    · obtain ⟨l, k, rfl⟩ := g n hn
      exact mkNode_ok _ _ _
  · intro e he
    rw [emitPipeSpec_edges, ← hes] at he
    exact hedge e he

end PipeSpec
end LifeTrac
