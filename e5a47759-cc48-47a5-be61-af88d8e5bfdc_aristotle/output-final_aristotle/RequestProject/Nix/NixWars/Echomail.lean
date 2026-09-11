import RequestProject.Nix.NixWars.Bbs

/-!
# Echomail: two boards, a packet, and no server

A single board is one node.  What made a board network was the *packet*: a bag
of messages carried between nodes (by modem at four in the morning, here by
whatever you like), each message carrying a globally unique identifier, and each
node keeping a list of the identifiers it has already seen so a message that
comes round the loop twice is only entered once.

This file is that layer on top of `Bbs.lean`:

* a `Pkt` is a message as it travels — a `msgid`, the area, the author, the
  subject, the text, and the `msgid` of what it replies to;
* a `Node` is a board plus its **dupe database** (`seen`) and the map from
  travelling identifiers to its own local message numbers (`localOf`);
* `importOne` enters a packet if it is new and does nothing at all if it is
  not, renumbering it to the node's own next free number and re-hanging the
  reply on the local copy of its parent when the node has one.

What is proved:

* importing keeps the board in order (`importOne_preserves_WF`,
  `importAll_preserves_WF`) — even though the parent link is rewritten;
* importing is append-only (`importOne_appends`) and never renumbers;
* **a message is entered at most once**: importing the same packet twice is
  importing it once (`importOne_idempotent`), and so is importing a whole
  packet twice (`importAll_idempotent`), which is what makes a loop in the
  network harmless;
* a node never un-sees anything (`seen_monotone`), and after an import the
  packet is seen (`importOne_seen`);
* a node's own export comes back as a no-op (`import_own_export`): mail that
  goes round the ring and returns changes nothing.

The two-node run at the end is concrete: `nixwars` posts, the packet is carried
to `shardnet`, and the message arrives once however many times it is delivered.
-/

set_option maxRecDepth 40000

namespace NixWars

namespace Echomail

open Bbs

/-! ## Packets and nodes -/

/-- A message as it travels between boards. -/
structure Pkt where
  /-- The identifier that stays the same wherever the message goes. -/
  msgid : String
  /-- The area it belongs in. -/
  area : String
  /-- Who wrote it. -/
  author : String
  /-- The subject line. -/
  subject : String
  /-- The text. -/
  body : String
  /-- The identifier of the message it replies to, if it is a reply. -/
  replyTo : Option String
  deriving DecidableEq, Repr

/-- A node of the network: a board, the identifiers it has already seen, and
what it numbered each of them locally. -/
structure Node where
  /-- The board itself. -/
  board : Board
  /-- The dupe database: every identifier this node has entered. -/
  seen : List String
  /-- Travelling identifier ↦ this node's own message number. -/
  localOf : List (String × Nat)
  deriving DecidableEq, Repr

/-- What this node numbered a travelling identifier, if it has it. -/
def localOf (n : Node) (mid : String) : Option Nat :=
  (n.localOf.find? (fun k => k.1 = mid)).map Prod.snd

/-- The number, if this node really carries that message in that area. -/
def localHere (n : Node) (area : String) (i : Nat) : Option Nat :=
  if n.board.msgs.any (fun m => m.id = i && m.area = area) then some i else none

/-- The local number a reply should hang on: the node's own copy of the parent,
if it has one *in this area*, and otherwise nothing — a reply whose parent never
arrived is entered as the head of a thread rather than dropped. -/
def parentFor (n : Node) (area : String) : Option String → Option Nat
  | none => none
  | some mid => (localOf n mid).bind (localHere n area)

/-- Whatever `localHere` returns is a message of this node, in this area. -/
theorem localHere_spec {n : Node} {area : String} {i q : Nat}
    (h : localHere n area i = some q) :
    ∃ w ∈ n.board.msgs, w.id = q ∧ w.area = area := by
  unfold localHere at h
  by_cases hin : (n.board.msgs.any (fun m => m.id = i && m.area = area)) = true
  · rw [if_pos hin] at h
    obtain ⟨w, hw, hcheck⟩ := List.any_eq_true.1 hin
    simp only [Bool.and_eq_true, decide_eq_true_eq] at hcheck
    have hiq : i = q := by simpa using h
    exact ⟨w, hw, hiq ▸ hcheck.1, hcheck.2⟩
  · rw [if_neg hin] at h
    simp at h

/-- Enter a packet, if it is new. -/
def importOne (n : Node) (p : Pkt) : Node :=
  if n.seen.contains p.msgid then n
  else
    { board := { n.board with
        msgs := n.board.msgs ++
          [⟨nextId n.board, p.area, p.author, p.subject, p.body,
            parentFor n p.area p.replyTo⟩] }
      seen := p.msgid :: n.seen
      localOf := (p.msgid, nextId n.board) :: n.localOf }

/-- Enter a whole packet, in order. -/
def importAll (n : Node) (ps : List Pkt) : Node := ps.foldl importOne n

/-! ## What importing does -/

/-- Membership in the dupe database. -/
def Seen (n : Node) (mid : String) : Prop := mid ∈ n.seen

instance (n : Node) (mid : String) : Decidable (Seen n mid) :=
  inferInstanceAs (Decidable (mid ∈ n.seen))

theorem importOne_seen (n : Node) (p : Pkt) : Seen (importOne n p) p.msgid := by
  unfold importOne Seen
  split
  · rename_i hc
    exact List.mem_of_elem_eq_true hc
  · simp

/-- A node never un-sees an identifier. -/
theorem seen_monotone (n : Node) (p : Pkt) {mid : String} (h : Seen n mid) :
    Seen (importOne n p) mid := by
  unfold importOne Seen at *
  split
  · exact h
  · exact List.mem_cons_of_mem _ h

/-- Importing is append-only: nothing already on the board moves. -/
theorem importOne_appends (n : Node) (p : Pkt) :
    (importOne n p).board.msgs = n.board.msgs ∨
      (importOne n p).board.msgs = n.board.msgs ++
        [⟨nextId n.board, p.area, p.author, p.subject, p.body,
          parentFor n p.area p.replyTo⟩] := by
  unfold importOne
  split
  · exact Or.inl rfl
  · exact Or.inr rfl

/-- **Nothing arrives twice.**  A packet already in the dupe database is
entered again as a no-op, so a message that comes round a loop in the network
changes nothing the second time. -/
theorem importOne_dupe (n : Node) (p : Pkt) (h : Seen n p.msgid) :
    importOne n p = n := by
  have hc : n.seen.contains p.msgid = true := List.elem_eq_true_of_mem h
  unfold importOne
  rw [if_pos hc]

/-- Importing the same packet twice is importing it once. -/
theorem importOne_idempotent (n : Node) (p : Pkt) :
    importOne (importOne n p) p = importOne n p :=
  importOne_dupe _ _ (importOne_seen n p)

/-- Importing keeps the board in order. -/
theorem importOne_preserves_WF {n : Node} (h : WF n.board) (p : Pkt) :
    WF (importOne n p).board := by
  unfold importOne
  split
  · exact h
  · refine WF_append h _ rfl ?_
    intro q hq
    have hq' : parentFor n p.area p.replyTo = some q := hq
    cases hr : p.replyTo with
    | none =>
        rw [hr] at hq'
        have hnone : (none : Option Nat) = some q := hq'
        simp at hnone
    | some mid =>
        rw [hr] at hq'
        have hb : (localOf n mid).bind (localHere n p.area) = some q := hq'
        obtain ⟨i, _, hlh⟩ := Option.bind_eq_some_iff.1 hb
        exact localHere_spec hlh

theorem importAll_preserves_WF {n : Node} (h : WF n.board) (ps : List Pkt) :
    WF (importAll n ps).board := by
  unfold importAll
  induction ps generalizing n with
  | nil => exact h
  | cons p ps ih => exact ih (importOne_preserves_WF h p)

/-- Everything a node has entered stays entered, however much more it takes
in. -/
theorem importAll_seen_monotone : ∀ (ps : List Pkt) (n : Node) {mid : String},
    Seen n mid → Seen (importAll n ps) mid := by
  intro ps
  induction ps with
  | nil => intro n mid h; exact h
  | cons p ps ih => intro n mid h; exact ih (importOne n p) (seen_monotone n p h)

/-- Whatever a node takes in, it has seen. -/
theorem importAll_seen : ∀ (ps : List Pkt) (n : Node) {p : Pkt}, p ∈ ps →
    Seen (importAll n ps) p.msgid := by
  intro ps
  induction ps with
  | nil => intro n p hp; cases hp
  | cons q qs ih =>
      intro n p hp
      rcases List.mem_cons.1 hp with rfl | hp
      · exact importAll_seen_monotone qs _ (importOne_seen n p)
      · exact ih (importOne n q) hp

/-- A packet whose every message the node has already seen is carried in
without changing anything. -/
theorem importAll_dupes : ∀ (ps : List Pkt) (n : Node),
    (∀ p ∈ ps, Seen n p.msgid) → importAll n ps = n := by
  intro ps
  induction ps with
  | nil => intro n _; rfl
  | cons p qs ih =>
      intro n h
      have hp : importOne n p = n := importOne_dupe n p (h p (by simp))
      show importAll (importOne n p) qs = n
      rw [hp]
      exact ih n (fun q hq => h q (by simp [hq]))

/-- **Delivering the same packet twice delivers it once.**  This is what makes
a loop in the network harmless: the second copy is a no-op, however it gets
here. -/
theorem importAll_idempotent (n : Node) (ps : List Pkt) :
    importAll (importAll n ps) ps = importAll n ps :=
  importAll_dupes ps _ (fun _ hp => importAll_seen ps n hp)

/-! ## Exporting

What a node sends out is what it has entered: its own dupe database is exactly
the list of identifiers it can offer. -/

/-- The packets a node offers for an area — one per identifier it has, carrying
the text of its own copy. -/
def outbox (n : Node) (area : String) : List Pkt :=
  n.localOf.filterMap fun k =>
    (msgById n.board k.2).bind fun m =>
      if m.area = area then some ⟨k.1, m.area, m.author, m.subject, m.body, none⟩ else none

/-- Every identifier a node offers is one it has seen. -/
def SeenClosed (n : Node) : Prop := ∀ k ∈ n.localOf, Seen n k.1

instance (n : Node) : Decidable (SeenClosed n) :=
  inferInstanceAs (Decidable (∀ k ∈ n.localOf, Seen n k.1))

theorem outbox_seen {n : Node} (h : SeenClosed n) (area : String) :
    ∀ p ∈ outbox n area, Seen n p.msgid := by
  intro p hp
  unfold outbox at hp
  obtain ⟨k, hk, hval⟩ := List.mem_filterMap.1 hp
  obtain ⟨m, _, hf⟩ := Option.bind_eq_some_iff.1 hval
  have hid : p.msgid = k.1 := by
    by_cases harea : m.area = area
    · rw [if_pos harea] at hf
      have : (⟨k.1, m.area, m.author, m.subject, m.body, none⟩ : Pkt) = p := by
        simpa using hf
      rw [← this]
    · rw [if_neg harea] at hf
      simp at hf
  rw [hid]
  exact h k hk

/-- **Mail that goes round the ring and comes home changes nothing.** -/
theorem import_own_outbox {n : Node} (h : SeenClosed n) (area : String) :
    importAll n (outbox n area) = n :=
  importAll_dupes _ n (outbox_seen h area)

/-- Importing keeps a node closed: whatever it enters, it has seen. -/
theorem importOne_seenClosed {n : Node} (h : SeenClosed n) (p : Pkt) :
    SeenClosed (importOne n p) := by
  unfold importOne SeenClosed Seen at *
  split
  · exact h
  · intro k hk
    rcases List.mem_cons.1 hk with rfl | hk
    · simp
    · exact List.mem_cons_of_mem _ (h k hk)

theorem importAll_seenClosed : ∀ (ps : List Pkt) {n : Node},
    SeenClosed n → SeenClosed (importAll n ps) := by
  intro ps
  induction ps with
  | nil => intro n h; exact h
  | cons p ps ih => intro n h; exact ih (importOne_seenClosed h p)

/-! ## Two nodes

`nixwars` is the board of `Bbs.lean`; `shardnet` is a second node carrying the
same areas and nothing in them. -/

/-- The identifier a message of the home board travels under. -/
def homeId (i : Nat) : String := natToDec i ++ "@nixwars"

/-- The home node: the board that ships, with every message of it entered. -/
def nixwars : Node :=
  { board := Bbs.board
    seen := seedMsgs.map (fun m => homeId m.id)
    localOf := seedMsgs.map (fun m => (homeId m.id, m.id)) }

/-- The far node: the same areas, no messages, nobody seen. -/
def shardnet : Node :=
  { board := { users := Bbs.users, areas := Bbs.areas, msgs := [], marks := [], callers := [] }
    seen := []
    localOf := [] }

/-- Two messages of the trading area, as they travel. -/
def mailRun : List Pkt :=
  [⟨"6@nixwars", "TRADE", "ZOS", "FUEL IS DEARER EVERY TIME YOU BUY IT",
     "Four loads of fuel off one warehouse cost 15, 16, 19, 21. The shelf empties and the price climbs.",
     none⟩,
   ⟨"9@nixwars", "TRADE", "FREN", "Re: FUEL IS DEARER EVERY TIME YOU BUY IT",
     "Same at every port, and never the same price at two of them.", some "6@nixwars"⟩]

/-- Both nodes are in order to start with. -/
theorem nodes_WF : WF nixwars.board ∧ WF shardnet.board :=
  ⟨board_WF, by refine ⟨by decide, by decide, by decide⟩⟩

/-- Both nodes are closed: they have seen what they can offer. -/
theorem nodes_seenClosed : SeenClosed nixwars ∧ SeenClosed shardnet := by
  constructor
  · decide
  · decide

/-- The mail arrives: the far node had nothing and now carries both messages,
the reply hanging on the local copy of its parent. -/
theorem mail_arrives :
    (importAll shardnet mailRun).board.msgs =
      [⟨1, "TRADE", "ZOS", "FUEL IS DEARER EVERY TIME YOU BUY IT",
         "Four loads of fuel off one warehouse cost 15, 16, 19, 21. The shelf empties and the price climbs.",
         none⟩,
       ⟨2, "TRADE", "FREN", "Re: FUEL IS DEARER EVERY TIME YOU BUY IT",
         "Same at every port, and never the same price at two of them.", some 1⟩] := by
  decide

/-- Delivering it again changes nothing at all. -/
theorem mail_delivered_twice :
    importAll (importAll shardnet mailRun) mailRun = importAll shardnet mailRun :=
  importAll_idempotent _ _

/-- And the far node's board is still in order. -/
theorem mail_keeps_order : WF (importAll shardnet mailRun).board :=
  importAll_preserves_WF nodes_WF.2 _

/-- Sending the home board's own trading area back to it does nothing. -/
theorem home_ignores_its_own_mail :
    importAll nixwars (outbox nixwars "TRADE") = nixwars :=
  import_own_outbox nodes_seenClosed.1 "TRADE"

end Echomail

end NixWars
