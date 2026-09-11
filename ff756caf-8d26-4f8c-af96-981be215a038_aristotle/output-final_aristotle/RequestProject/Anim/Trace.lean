import Mathlib

/-!
# Traces, quoted programs and partial proofs

The semantics of `web/js/trace.js`: what it means to copy an execution as a
trace, to share it in a link, and for someone else to bind it into their own
work as a quoted program or a partial proof.

There are two objects.

**A trace** is a seed plus a list of moves.  It is replayed rather than
transmitted in full — the state never travels, only what produced it — and the
recipient can *check* it: `verify` recomputes the run and compares it with the
state the sender claimed, so a closed trace replays to exactly the state its
sender had, or the recipient learns that it does not (`verify_iff`,
`replay_append`).

**A quoted program** is a term with named holes.  Binding fills a hole; a term
with no holes is closed.  The two properties that make this trustworthy are
proved here:

* binding preserves well-formedness (`check_subst`, and `check_iff` saying the
  Boolean checker really decides the inductive specification, so the recipient
  need not trust the sender);
* binding a partial trace into the hole of another is concatenation
  (`subst_traceTerm`), and by `replay_append` the composite replays to the
  state obtained by replaying one after the other (`replay_bind`).

Everything travels as a token list with a round-trip: `parse_flatten` says the
postfix encoding a link carries decodes back to the very term that was sent.

No axioms are introduced: every assumption a statement needs is one of its
hypotheses.
-/

namespace Hesper.Trace

/-! ## Terms with holes -/

/-- A quoted program: a tree whose leaves may be named holes. -/
inductive Term where
  | hole : String → Term
  | node : String → List Term → Term
  deriving Repr, Inhabited

namespace Term

/-- The induction principle for `Term`, with the hypothesis for a node quantified
    over its children. -/
@[elab_as_elim]
theorem induction {motive : Term → Prop}
    (hole : ∀ n, motive (.hole n))
    (node : ∀ n args, (∀ a ∈ args, motive a) → motive (.node n args)) :
    ∀ t, motive t := by
  intro t
  induction t using Term.rec (motive_2 := fun ts => ∀ a ∈ ts, motive a) with
  | hole n => exact hole n
  | node n args ih => exact node n args ih
  | nil => rename_i a ha; exact absurd ha (by simp)
  | cons head tail ih iht =>
    rename_i a ha
    rcases List.mem_cons.1 ha with rfl | h
    · exact ih
    · exact iht a h

end Term

/-! The holes of a term, left to right, with repeats. -/
mutual
def holes : Term → List String
  | .hole n => [n]
  | .node _ args => holesAll args
/-- The holes of a list of terms. -/
def holesAll : List Term → List String
  | [] => []
  | t :: ts => holes t ++ holesAll ts
end

@[simp] theorem holesAll_eq (ts : List Term) : holesAll ts = ts.flatMap holes := by
  induction ts with
  | nil => rfl
  | cons t ts ih => simp [holesAll, ih]

@[simp] theorem holes_node (n : String) (args : List Term) :
    holes (.node n args) = args.flatMap holes := by simp [holes]

@[simp] theorem holes_hole (n : String) : holes (.hole n) = [n] := rfl

/-- A term with no holes: a finished program, or a complete proof. -/
def closed (t : Term) : Prop := holes t = []

instance : DecidablePred closed := fun t => by
  unfold closed; infer_instance

/-! Binding: fill every hole named `x` with `u`. -/
mutual
def subst (x : String) (u : Term) : Term → Term
  | .hole n => if n = x then u else .hole n
  | .node n args => .node n (substAll x u args)
/-- Binding, inside a list of terms. -/
def substAll (x : String) (u : Term) : List Term → List Term
  | [] => []
  | t :: ts => subst x u t :: substAll x u ts
end

@[simp] theorem substAll_eq (x : String) (u : Term) (ts : List Term) :
    substAll x u ts = ts.map (subst x u) := by
  induction ts with
  | nil => rfl
  | cons t ts ih => simp [substAll, ih]

@[simp] theorem subst_hole_same (x : String) (u : Term) : subst x u (.hole x) = u := by
  simp [subst]

@[simp] theorem subst_node (x : String) (u : Term) (n : String) (args : List Term) :
    subst x u (.node n args) = .node n (args.map (subst x u)) := by simp [subst]

/-- Exactly which holes survive a binding. -/
theorem holes_subst (x : String) (u : Term) (t : Term) :
    holes (subst x u t) = (holes t).flatMap (fun y => if y = x then holes u else [y]) := by
  induction t using Term.induction with
  | hole n => by_cases h : n = x <;> simp [subst, h]
  | node n args ih =>
    simp only [subst_node, holes_node, List.flatMap_map]
    induction args with
    | nil => simp
    | cons a as iha =>
      have hmem : ∀ b ∈ as, holes (subst x u b)
          = (holes b).flatMap (fun y => if y = x then holes u else [y]) :=
        fun b hb => ih b (List.mem_cons_of_mem _ hb)
      simp only [List.flatMap_cons, ih a (List.mem_cons_self ..), iha hmem, List.flatMap_append]

/-- Binding a hole that is not there changes nothing. -/
theorem subst_of_not_mem {x : String} {t : Term} (h : x ∉ holes t) (u : Term) :
    subst x u t = t := by
  induction t using Term.induction with
  | hole n =>
    have hne : n ≠ x := fun hn => h (by simp [hn])
    simp [subst, hne]
  | node n args ih =>
    have hnot : ∀ b ∈ args, x ∉ holes b := by
      intro b hb hx
      exact h (by simp only [holes_node, List.mem_flatMap]; exact ⟨b, hb, hx⟩)
    simp only [subst_node]
    congr 1
    calc args.map (subst x u)
        = args.map id := List.map_congr_left (fun b hb => ih b hb (hnot b hb))
      _ = args := List.map_id args

/-- Filling the last hole of a term with a closed term closes it. -/
theorem closed_subst {x : String} {t u : Term} (ht : holes t = [x]) (hu : closed u) :
    closed (subst x u t) := by
  unfold closed at *
  rw [holes_subst, ht]
  simp [hu]

/-- Binding never introduces a hole that was in neither party. -/
theorem holes_subst_subset (x : String) (u t : Term) {y : String}
    (hy : y ∈ holes (subst x u t)) : y ∈ holes t ∨ y ∈ holes u := by
  rw [holes_subst] at hy
  simp only [List.mem_flatMap] at hy
  obtain ⟨z, hz, hzy⟩ := hy
  by_cases h : z = x
  · subst h; simp only [if_true] at hzy; exact Or.inr hzy
  · simp only [if_neg h, List.mem_singleton] at hzy
    exact Or.inl (hzy ▸ hz)

/-! ## Well-formedness, and the checker the recipient runs

A signature gives each operator its arity.  A term is well-formed when every
node's name is in the signature with exactly the arity it was used at; holes
are always well-formed, which is what makes a *partial* proof a first-class
object rather than a broken one.
-/

/-- The specification. -/
inductive WF (sig : String → Option Nat) : Term → Prop
  | hole (n : String) : WF sig (.hole n)
  | node (n : String) (args : List Term) :
      sig n = some args.length → (∀ a ∈ args, WF sig a) → WF sig (.node n args)

/-! The checker: what the recipient actually runs. -/
mutual
def check (sig : String → Option Nat) : Term → Bool
  | .hole _ => true
  | .node n args => (sig n == some args.length) && checkAll sig args
/-- The checker, on a list of terms. -/
def checkAll (sig : String → Option Nat) : List Term → Bool
  | [] => true
  | t :: ts => check sig t && checkAll sig ts
end

@[simp] theorem checkAll_eq (sig : String → Option Nat) (ts : List Term) :
    checkAll sig ts = ts.all (check sig) := by
  induction ts with
  | nil => rfl
  | cons t ts ih => simp [checkAll, ih]

@[simp] theorem check_hole (sig : String → Option Nat) (n : String) :
    check sig (.hole n) = true := rfl

@[simp] theorem check_node (sig : String → Option Nat) (n : String) (args : List Term) :
    check sig (.node n args) = ((sig n == some args.length) && args.all (check sig)) := by
  simp [check]

/-- The checker decides the specification, so a received term can be verified
    rather than trusted. -/
theorem check_iff (sig : String → Option Nat) (t : Term) : check sig t = true ↔ WF sig t := by
  induction t using Term.induction with
  | hole n => simp [WF.hole]
  | node n args ih =>
    simp only [check_node, Bool.and_eq_true, beq_iff_eq, List.all_eq_true]
    constructor
    · rintro ⟨harity, hargs⟩
      exact WF.node n args harity (fun a ha => (ih a ha).1 (hargs a ha))
    · intro h
      cases h with
      | node _ _ harity hargs =>
        exact ⟨harity, fun a ha => (ih a ha).2 (hargs a ha)⟩

/-- **Binding preserves well-formedness.**  Someone can continue a partial
    proof without being able to break it. -/
theorem WF_subst {sig : String → Option Nat} {x : String} {u t : Term}
    (hu : WF sig u) (ht : WF sig t) : WF sig (subst x u t) := by
  induction t using Term.induction with
  | hole n =>
    by_cases h : n = x
    · subst h; simpa using hu
    · simpa [subst, h] using WF.hole (sig := sig) n
  | node n args ih =>
    cases ht with
    | node _ _ harity hargs =>
      rw [subst_node]
      refine WF.node n _ (by simpa using harity) ?_
      intro a ha
      obtain ⟨b, hb, rfl⟩ := List.mem_map.1 ha
      exact ih b hb (hargs b hb)

/-- The same, in the form the runtime uses: the checker accepts the result. -/
theorem check_subst {sig : String → Option Nat} {x : String} {u t : Term}
    (hu : check sig u = true) (ht : check sig t = true) : check sig (subst x u t) = true :=
  (check_iff sig _).2 (WF_subst ((check_iff sig u).1 hu) ((check_iff sig t).1 ht))

/-! ## Traces

A trace is a seed and a list of moves.  Only the moves travel; the state is
recomputed, and the recomputation is what makes the claim checkable.
-/

/-- A replayable trace over a state type `σ` and a move type `M`. -/
structure Run (σ M : Type) where
  seed : σ
  moves : List M
  deriving Repr

variable {σ M : Type}

/-- Replaying a trace: fold the step function over the moves. -/
def replay (stepf : σ → M → σ) (r : Run σ M) : σ := r.moves.foldl stepf r.seed

@[simp] theorem replay_nil (stepf : σ → M → σ) (s : σ) :
    replay stepf ⟨s, []⟩ = s := rfl

@[simp] theorem replay_cons (stepf : σ → M → σ) (s : σ) (m : M) (ms : List M) :
    replay stepf ⟨s, m :: ms⟩ = replay stepf ⟨stepf s m, ms⟩ := rfl

/-- Replaying a concatenation is replaying one after the other: this is what
    makes a partial trace continuable. -/
theorem replay_append (stepf : σ → M → σ) (s : σ) (a b : List M) :
    replay stepf ⟨s, a ++ b⟩ = replay stepf ⟨replay stepf ⟨s, a⟩, b⟩ := by
  simp [replay, List.foldl_append]

/-- The length of a trace bounds the work of replaying it. -/
@[simp] theorem length_moves_append (a b : List M) : (a ++ b).length = a.length + b.length :=
  List.length_append

/-- What the recipient runs: recompute, and compare with what was claimed. -/
def verify [DecidableEq σ] (stepf : σ → M → σ) (r : Run σ M) (claim : σ) : Bool :=
  replay stepf r == claim

/-- A closed trace replays to exactly the state its sender had — or the
    recipient finds out that it does not. -/
theorem verify_iff [DecidableEq σ] (stepf : σ → M → σ) (r : Run σ M) (claim : σ) :
    verify stepf r claim = true ↔ replay stepf r = claim := by
  simp [verify]

/-- Replaying is a function of the trace alone, so two recipients of the same
    trace compute the same state. -/
theorem replay_deterministic (stepf : σ → M → σ) (r r' : Run σ M) (h : r = r') :
    replay stepf r = replay stepf r' := by rw [h]

/-! ## A trace as a quoted program

A partial trace is a term whose one hole is its continuation.  Binding that
hole with someone else's partial trace concatenates the two, and the composite
replays to the state obtained by replaying one and then the other.
-/

/-- The quoted form of a partial run: the moves, ending in a named hole. -/
def traceTerm (moves : List String) (tail : String) : Term :=
  moves.foldr (fun m acc => .node "step" [.node m [], acc]) (.hole tail)

@[simp] theorem traceTerm_nil (tail : String) : traceTerm [] tail = .hole tail := rfl

@[simp] theorem traceTerm_cons (m : String) (ms : List String) (tail : String) :
    traceTerm (m :: ms) tail = .node "step" [.node m [], traceTerm ms tail] := rfl

/-- A quoted partial run has exactly one hole: its continuation. -/
@[simp] theorem holes_traceTerm (moves : List String) (tail : String) :
    holes (traceTerm moves tail) = [tail] := by
  induction moves with
  | nil => simp
  | cons m ms ih => simp [ih]

/-- **Binding a continuation is concatenation.** -/
theorem subst_traceTerm (ms ns : List String) (x y : String) :
    subst x (traceTerm ns y) (traceTerm ms x) = traceTerm (ms ++ ns) y := by
  induction ms with
  | nil => simp
  | cons m ms ih => simp [ih]

/-- …and the bound trace replays to the state the two runs give one after the
    other, so continuing someone's partial trace is sound. -/
theorem replay_bind (stepf : σ → M → σ) (s : σ) (a b : List M) :
    replay stepf ⟨s, a ++ b⟩ = replay stepf ⟨replay stepf ⟨s, a⟩, b⟩ :=
  replay_append stepf s a b

/-- A quoted run is closed once its continuation has been bound to a term with
    no holes of its own. -/
theorem closed_bind (ms : List String) (x : String) (u : Term) (hu : closed u) :
    closed (subst x u (traceTerm ms x)) :=
  closed_subst (by simp) hu

/-! ## The wire format

A term travels as a postfix token list: the shape a link carries.  The
round-trip theorem says what is decoded is what was sent.
-/

/-- One token of the wire format. -/
inductive Tok where
  | hole : String → Tok
  | node : String → Nat → Tok
  deriving Repr, DecidableEq, Inhabited

/-! The postfix encoding of a term (children first, then the node). -/
mutual
def flatten : Term → List Tok
  | .hole n => [.hole n]
  | .node n args => flattenAll args ++ [.node n args.length]
/-- The postfix encoding of a list of terms. -/
def flattenAll : List Term → List Tok
  | [] => []
  | t :: ts => flatten t ++ flattenAll ts
end

@[simp] theorem flattenAll_eq (ts : List Term) : flattenAll ts = ts.flatMap flatten := by
  induction ts with
  | nil => rfl
  | cons t ts ih => simp [flattenAll, ih]

@[simp] theorem flatten_hole (n : String) : flatten (.hole n) = [.hole n] := rfl

@[simp] theorem flatten_node (n : String) (args : List Term) :
    flatten (.node n args) = args.flatMap flatten ++ [.node n args.length] := by
  simp [flatten]

/-- One step of the decoder: a stack machine. -/
def popStep (st : List Term) : Tok → Option (List Term)
  | .hole n => some (Term.hole n :: st)
  | .node n k =>
      if k ≤ st.length then some (Term.node n ((st.take k).reverse) :: st.drop k) else none

/-- The decoder. -/
def pop : List Tok → List Term → Option (List Term)
  | [], st => some st
  | tk :: ts, st =>
      match popStep st tk with
      | none => none
      | some st' => pop ts st'

/-- Decoding a token stream that starts with an encoded term pushes exactly
    that term and carries on. -/
theorem pop_flatten (t : Term) : ∀ (rest : List Tok) (st : List Term),
    pop (flatten t ++ rest) st = pop rest (t :: st) := by
  have hargs : ∀ (as : List Term), (∀ a ∈ as, ∀ (rest : List Tok) (st : List Term),
      pop (flatten a ++ rest) st = pop rest (a :: st)) →
      ∀ (rest : List Tok) (st : List Term),
      pop (as.flatMap flatten ++ rest) st = pop rest (as.reverse ++ st) := by
    intro as
    induction as with
    | nil => intro _ rest st; simp
    | cons a as iha =>
      intro h rest st
      have h1 := h a (List.mem_cons_self ..)
      have h2 := iha (fun b hb => h b (List.mem_cons_of_mem _ hb))
      simp only [List.flatMap_cons, List.append_assoc, h1, h2, List.reverse_cons,
        List.append_assoc, List.cons_append]
      simp
  induction t using Term.induction with
  | hole n => intro rest st; simp [pop, popStep]
  | node n args ih =>
    intro rest st
    have htake : (args.reverse ++ st).take args.length = args.reverse :=
      List.take_left' (by simp)
    have hdrop : (args.reverse ++ st).drop args.length = st :=
      List.drop_left' (by simp)
    calc pop (flatten (.node n args) ++ rest) st
        = pop ((args.flatMap flatten) ++ ([Tok.node n args.length] ++ rest)) st := by
          simp
      _ = pop ([Tok.node n args.length] ++ rest) (args.reverse ++ st) := hargs args ih _ _
      _ = pop rest (Term.node n args :: st) := by
          simp [pop, popStep, htake, hdrop]

/-- **The wire format round-trips**: what a link carries decodes to the very
    term that was sent. -/
theorem pop_flatten_nil (t : Term) : pop (flatten t) [] = some [t] := by
  simpa using pop_flatten t [] []

end Hesper.Trace
