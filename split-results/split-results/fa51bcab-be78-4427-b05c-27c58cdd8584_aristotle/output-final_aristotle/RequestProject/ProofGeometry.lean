/-
ProofGeometry.lean — comparing *proof geometry* against *statement geometry* in the 7D
act-space.

The earlier `SevenDEmbedding` fixes every term `t` at its 7D coordinate `SevenD.coord t`
(the seven act-sizes of its type-shape's size word) and reads the term-relation graph off
**statements** (types): an arrow `t → u` whenever `u`'s *type* mentions `t`.

This file keeps the **same vertices / same coordinate space** but makes the *edge provenance*
a first-class parameter, so that we can put two graphs on the same geometry:

* the **statement graph** — edges read from types (`u`'s type references `t`), and
* the **proof graph** — edges read from *raw proof terms* (`u`'s value references `t`).

An edge is just a pair of size words `(t, u)` (source term, target term); a list of edges is a
graph. The **flow** of a graph is the sum of its per-edge 7D displacement vectors
(`SevenD.arrowVec`). The headline machine-checked facts:

* `flow_eq_head_sub_tail` — *the geometry of a graph depends only on its endpoints'
  coordinates, not on how the edges were obtained*: `flow es i` is the sum of the head
  coordinates minus the sum of the tail coordinates. So an edge `t → u` contributes the
  identical displacement whether it came from a statement or from a proof — the comparison of
  proof- vs statement-geometry is a comparison of **which edges exist**, on one fixed space.
* `flow_append` / `flow_nil` — flow is additive over graph concatenation.
* `flowDiff_of_extends` — if the proof graph extends the statement graph (`proof = stmt ++
  extra`), the proof-minus-statement flow difference is exactly the flow of the *proof-only*
  edges `extra`. This is the precise sense in which "expanding to proof terms" adds geometry.
* `flow_reverse` — reversing every edge negates the flow.
* `flow_telescope_path` — on a path the flow telescopes to the endpoint difference
  (consistency with `SevenD.arrow_telescope`).
-/
import Mathlib
import RequestProject.SevenDEmbedding

open Finset

namespace ProofGeometry

/-- An **edge** of the term-relation graph: a pair `(t, u)` of size words, read as the relation
`t → u`. The two graphs we compare (statement graph, proof graph) live over the same vertices
and differ only in *which* such pairs they contain. -/
abbrev Edge := List Nat × List Nat

/-- A **graph** is a list of edges (multiplicity allowed: an edge may be read more than once). -/
abbrev Graph := List Edge

/-- The `i`-th component of the **flow** of a graph: the sum, over its edges, of the 7D
displacement vectors `SevenD.arrowVec` (`coord u − coord t`). This is the net per-axis motion
the graph induces in the 7D act-space. -/
def flow (es : Graph) (i : Fin 7) : ℤ :=
  (es.map (fun e => SevenD.arrowVec e.1 e.2 i)).sum

@[simp] theorem flow_nil (i : Fin 7) : flow [] i = 0 := rfl

theorem flow_cons (e : Edge) (es : Graph) (i : Fin 7) :
    flow (e :: es) i = SevenD.arrowVec e.1 e.2 i + flow es i := by
  simp [flow]

/-- Flow is additive over graph concatenation. -/
theorem flow_append (es fs : Graph) (i : Fin 7) :
    flow (es ++ fs) i = flow es i + flow fs i := by
  simp [flow, List.map_append, List.sum_append]

/-- **Provenance independence of geometry.** The flow of a graph is the sum of its edges' head
coordinates minus the sum of their tail coordinates — it depends only on the endpoints'
coordinates, never on how the edge was discovered. Hence an edge `t → u` contributes the same
displacement whether read from a statement or from a proof term, and comparing proof- and
statement-geometry is exactly comparing the two edge sets on one fixed space. -/
theorem flow_eq_head_sub_tail (es : Graph) (i : Fin 7) :
    flow es i
      = (es.map (fun e => (SevenD.coord e.2 i : ℤ))).sum
        - (es.map (fun e => (SevenD.coord e.1 i : ℤ))).sum := by
  induction es with
  | nil => simp [flow]
  | cons e es ih =>
    simp only [flow_cons, List.map_cons, List.sum_cons, ih, SevenD.arrowVec]
    ring

/-- The **flow difference** between a proof graph and a statement graph: proof flow minus
statement flow, the per-axis "extra geometry" of the proofs over the statements. -/
def flowDiff (stmt proof : Graph) (i : Fin 7) : ℤ := flow proof i - flow stmt i

/-- **Proofs extend statements ⇒ the geometry difference is the proof-only flow.** If the proof
graph is the statement graph plus extra (proof-only) edges, the proof-minus-statement flow
difference is exactly the flow of those extra edges. -/
theorem flowDiff_of_extends (stmt extra : Graph) (i : Fin 7) :
    flowDiff stmt (stmt ++ extra) i = flow extra i := by
  simp [flowDiff, flow_append]

/-- Reversing every edge of a graph negates its flow (a backward arrow is the negated arrow). -/
theorem flow_reverse (es : Graph) (i : Fin 7) :
    flow (es.map (fun e => (e.2, e.1))) i = - flow es i := by
  induction es with
  | nil => simp [flow]
  | cons e es ih =>
    rw [List.map_cons, flow_cons, flow_cons, ih, SevenD.arrowVec_swap]
    ring

/-- On a path `w 0 → w 1 → … → w n`, the proof/statement flow telescopes to the endpoint
difference, consistent with `SevenD.arrow_telescope`. -/
theorem flow_telescope_path (w : ℕ → List Nat) (n : ℕ) (i : Fin 7) :
    flow ((List.range n).map (fun j => (w j, w (j + 1)))) i
      = (SevenD.coord (w n) i : ℤ) - (SevenD.coord (w 0) i : ℤ) := by
  induction n with
  | zero => simp [flow, SevenD.arrowVec]
  | succ n ih =>
    rw [List.range_succ, List.map_append, flow_append, ih]
    simp only [List.map_cons, List.map_nil, flow_cons, flow_nil, SevenD.arrowVec]
    ring

end ProofGeometry
