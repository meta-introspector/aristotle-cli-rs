import RequestProject.Gvcs.Realm.Hash

/-!
# The chain of pages

A game of `Realm` is a list of moves.  A **page** is that list, the position it
replays to, and the digest that commits to it; one page per move, each carrying
everything that came before.

* `runFrom`, `run` — replay; `valid` — a transcript every move of which the
  rules allowed.
* `valid_take` — **every page in the history is itself a valid page**: a
  transcript stays valid when it is cut short, so the page a player publishes at
  move `n` can be checked on its own, and so can each of its predecessors.
* `wf_run` — the invariant of `RequestProject/Realm/Rules.lean` holds at every
  position a valid transcript reaches.
* `firstBad` — the **fraud proof**: for a transcript that breaks the rules, the
  first move that does, with `firstBad_spec` showing that everything before it
  was legal and it is not.  A challenger publishes that index; anyone can check
  it by replaying that much.
* `page`, `page_prefix` — a page and its predecessor: the older transcript, the
  older digest folded into the new one, and the one legal move between the two
  positions.
* `runFrom_impl_eq` — an engine on another platform (the JavaScript in the page,
  say) that agrees with `apply` move by move replays to the same position.  This
  is the correctness statement for the shell.
-/

namespace LifeTrac
namespace Realm

/-! ## Replay -/

/-- Replay a transcript from a position; `none` as soon as a move breaks a
rule. -/
def runFrom (s : State) : List Move → Option State
  | [] => some s
  | m :: ms =>
    match apply s m with
    | none => none
    | some s' => runFrom s' ms

/-- Replay a transcript from the opening position. -/
def run (ms : List Move) : Option State := runFrom genesis ms

/-- Every position a transcript passes through, starting with `s`. -/
def statesFrom (s : State) : List Move → List State
  | [] => [s]
  | m :: ms =>
    match apply s m with
    | none => [s]
    | some s' => s :: statesFrom s' ms

/-- Every position of a game, from the opening. -/
def statesOf (ms : List Move) : List State := statesFrom genesis ms

/-- A transcript the rules allow from beginning to end. -/
def valid (ms : List Move) : Bool := (run ms).isSome

@[simp] theorem runFrom_nil (s : State) : runFrom s [] = some s := rfl

theorem runFrom_cons (s : State) (m : Move) (ms : List Move) :
    runFrom s (m :: ms) = (apply s m).bind (fun s' => runFrom s' ms) := by
  show (match apply s m with | none => none | some s' => runFrom s' ms) = _
  cases apply s m <;> simp

theorem runFrom_append (s : State) (ms ns : List Move) :
    runFrom s (ms ++ ns) = (runFrom s ms).bind (fun t => runFrom t ns) := by
  induction ms generalizing s with
  | nil => simp
  | cons m ms ih => simp [runFrom_cons, ih]; cases apply s m <;> simp

theorem runFrom_concat (s : State) (ms : List Move) (m : Move) :
    runFrom s (ms ++ [m]) = (runFrom s ms).bind (fun t => apply t m) := by
  rw [runFrom_append]
  cases runFrom s ms <;> simp [runFrom_cons]

/-- **A page can be cut short.**  Any prefix of a transcript the rules allow is
itself a transcript the rules allow, so every earlier page of a game verifies on
its own. -/
theorem runFrom_take_isSome {s : State} {ms : List Move} (h : (runFrom s ms).isSome = true)
    (k : Nat) : (runFrom s (ms.take k)).isSome = true := by
  have hsplit : runFrom s (ms.take k ++ ms.drop k) = _ := runFrom_append s (ms.take k) (ms.drop k)
  rw [List.take_append_drop] at hsplit
  cases hk : runFrom s (ms.take k) with
  | none => rw [hk] at hsplit; simp [hsplit] at h
  | some t => simp
theorem valid_take {ms : List Move} (h : valid ms = true) (k : Nat) : valid (ms.take k) = true :=
  runFrom_take_isSome h k

theorem valid_append {ms ns : List Move} (h : valid (ms ++ ns) = true) : valid ms = true := by
  have := runFrom_take_isSome (s := genesis) (ms := ms ++ ns) h ms.length
  simpa using this

/-! ## The invariant along a whole game -/

/-- The invariant holds at every position a legal transcript reaches. -/
theorem wf_runFrom {s t : State} {ms : List Move} (hw : Wf s) (h : runFrom s ms = some t) :
    Wf t := by
  induction ms generalizing s with
  | nil => cases h; exact hw
  | cons m ms ih =>
    rw [runFrom_cons] at h
    cases ha : apply s m with
    | none => rw [ha] at h; simp at h
    | some s' => rw [ha] at h; exact ih (wf_apply hw ha) (by simpa using h)

/-- Every position of a valid game is a sane world. -/
theorem wf_run {t : State} {ms : List Move} (h : run ms = some t) : Wf t :=
  wf_runFrom wf_genesis h

/-! ## The fraud proof -/

/-- The first move of a transcript that breaks a rule, counted from the given
position. -/
def firstBadFrom (s : State) : List Move → Option Nat
  | [] => none
  | m :: rest =>
    match apply s m with
    | none => some 0
    | some s' => (firstBadFrom s' rest).map (· + 1)

/-- The first move of a game that breaks a rule: the fraud proof against the
page that published it. -/
def firstBad (ms : List Move) : Option Nat := firstBadFrom genesis ms

theorem firstBadFrom_eq_none_iff {s : State} {ms : List Move} :
    firstBadFrom s ms = none ↔ (runFrom s ms).isSome = true := by
  induction ms generalizing s with
  | nil => simp [firstBadFrom]
  | cons m ms ih =>
    unfold firstBadFrom
    cases ha : apply s m with
    | none => simp [runFrom_cons, ha]
    | some s' => simp [runFrom_cons, ha, ← ih]

/-- A transcript is valid exactly when there is no first bad move. -/
theorem firstBad_eq_none_iff {ms : List Move} : firstBad ms = none ↔ valid ms = true :=
  firstBadFrom_eq_none_iff

/-- **What a fraud proof proves.**  If the first bad move is number `i`, then
`i` really is a move of the game, everything before it was legal, and the
position reached by replaying those `i` moves does not allow it. -/
theorem firstBadFrom_spec {s : State} {ms : List Move} {i : Nat} (h : firstBadFrom s ms = some i) :
    i < ms.length ∧ (runFrom s (ms.take i)).isSome = true ∧
      (runFrom s (ms.take (i + 1))).isSome = false := by
  induction ms generalizing s i with
  | nil => simp [firstBadFrom] at h
  | cons m ms ih =>
    unfold firstBadFrom at h
    cases ha : apply s m with
    | none =>
      rw [ha] at h
      simp only [Option.some.injEq] at h
      subst h
      refine ⟨by simp, by simp, ?_⟩
      simp [runFrom_cons, ha]
    | some s' =>
      rw [ha] at h
      simp only [Option.map_eq_some_iff] at h
      obtain ⟨j, hj, rfl⟩ := h
      obtain ⟨h1, h2, h3⟩ := ih hj
      refine ⟨by simp; omega, ?_, ?_⟩
      · simp [runFrom_cons, ha, h2]
      · simp [runFrom_cons, ha, h3]

theorem firstBad_spec {ms : List Move} {i : Nat} (h : firstBad ms = some i) :
    i < ms.length ∧ valid (ms.take i) = true ∧ valid (ms.take (i + 1)) = false :=
  firstBadFrom_spec h

/-! ## Pages -/

/-- A page of the game: the whole transcript so far, the digest that commits to
it, and the position it replays to. -/
structure Page where
  /-- Every move of the game so far, in order. -/
  moves : List Move
  /-- The digest of `moves`: what a player puts on a chain. -/
  digest : Nat
  /-- The position `moves` replays to. -/
  state : State
  deriving DecidableEq, Repr

/-- The page a transcript makes, when the transcript is legal. -/
def page (ms : List Move) : Option Page := (run ms).map (fun s => ⟨ms, chainDigest ms, s⟩)

theorem page_isSome_iff {ms : List Move} : (page ms).isSome = true ↔ valid ms = true := by
  unfold page valid; cases run ms <;> simp

theorem page_moves {ms : List Move} {pg : Page} (h : page ms = some pg) : pg.moves = ms := by
  unfold page at h
  cases hr : run ms with
  | none => rw [hr] at h; simp at h
  | some s => rw [hr] at h; simp only [Option.map_some, Option.some.injEq] at h; rw [← h]

/-- **Every page carries its predecessor.**  A page for `ms ++ [m]` exists only
if the page for `ms` does; its digest is the older digest with the new move
folded in, and its position is the older position after that one move, which the
rules allowed. -/
theorem page_prefix {ms : List Move} {m : Move} {pg : Page} (h : page (ms ++ [m]) = some pg) :
    ∃ pg', page ms = some pg' ∧ pg'.moves = ms ∧
      pg.digest = mix pg'.digest m.code ∧ apply pg'.state m = some pg.state := by
  unfold page at h
  rw [run, runFrom_concat] at h
  cases hr : runFrom genesis ms with
  | none => rw [hr] at h; simp at h
  | some t =>
    rw [hr] at h
    simp only [Option.bind_some] at h
    cases ha : apply t m with
    | none => rw [ha] at h; simp at h
    | some t' =>
      rw [ha] at h
      simp only [Option.map_some, Option.some.injEq] at h
      refine ⟨⟨ms, chainDigest ms, t⟩, ?_, rfl, ?_, ?_⟩
      · unfold page; rw [run, hr]; rfl
      · rw [← h]; exact chainDigest_concat ms m
      · rw [← h]; exact ha

/-! ## Other engines -/

/-- **A shell is right when its step function is.**  Any implementation of the
rules that agrees with `apply` move by move — the JavaScript inside the page,
for instance — replays every transcript to the same position. -/
theorem runFrom_impl_eq {step : State → Move → Option State}
    (hstep : ∀ s m, step s m = apply s m) (s : State) (ms : List Move) :
    ms.foldl (fun o m => o.bind (fun t => step t m)) (some s) = runFrom s ms := by
  have hfun : (fun (o : Option State) (m : Move) => o.bind (fun t => step t m))
      = (fun (o : Option State) (m : Move) => o.bind (fun t => apply t m)) := by
    funext o m; cases o <;> simp [hstep]
  rw [hfun]
  suffices h : ∀ (ns : List Move) (o : Option State),
      ns.foldl (fun o m => o.bind (fun t => apply t m)) o = o.bind (fun t => runFrom t ns) by
    simpa using h ms (some s)
  intro ns
  induction ns with
  | nil => intro o; cases o <;> simp
  | cons m ns ih =>
    intro o
    cases o with
    | none => simp [ih]
    | some t => simp [ih, runFrom_cons]

end Realm
end LifeTrac
