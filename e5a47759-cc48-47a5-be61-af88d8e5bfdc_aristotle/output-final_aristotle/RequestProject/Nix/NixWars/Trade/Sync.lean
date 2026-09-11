import RequestProject.Nix.NixWars.Trade.Journal
import RequestProject.Nix.Foundry.Comms

/-!
# UUCP sync: two players swap games and check each other

There is no server.  A game is a recording (`Log`), a recording is a string
(`saveLog`), and a string is something you can put in a UUCP bag and hand to
the next node in the ring.  This file is the protocol on top of that:

* **Comparing.**  `syncLogs mine theirs` says what the two recordings are to
  each other: the same game (`inSync`), theirs is mine plus more moves
  (`fastForward`), mine is theirs plus more (`ahead`), a different ship
  altogether (`otherShip`), or the same opening followed by two different
  moves — a **fork**, reported at the exact move where the two games part
  company (`fork n`).  The classification is proved right in every case
  (`sync_inSync`, `sync_fastForward`, `sync_ahead`, `sync_otherShip`,
  `sync_fork_agrees_before`, `sync_fork_differs_at`).
* **Taking their game.**  A fast-forward never rewrites history: my hash chain
  is a prefix of theirs, so every move I have already played is still there,
  hash for hash (`fastForward_keeps_chain`, `fastForward_keeps_commit`).
* **Checking their game.**  `accept` takes a sealed recording and replays it:
  it is kept only if its commitment is the one the replay produces
  (`accept_verified`) and refused otherwise (`accept_rejects_tampered`), and
  an accepted recording is a legal game (`accept_legal`).
* **Carrying it.**  `sendLog` puts a sealed recording in a UUCP packet with a
  bang path, and `receiveLog` takes it out again: the packet arrives at the
  node it is addressed to (`send_arrives`) in at most seven hops
  (`send_hops_le`), and what comes out is exactly what went in
  (`receive_send`, `receive_send_verifies`).

The demo is two players who share an opening and then disagree: `demoFork`
is detected at move 30, and the honest fast-forward `demoAhead` is not.
-/

set_option maxRecDepth 100000

namespace NixWars
namespace Trade

open NixWars.Foundry (uucpNodes uucpRoute bangPath uucpRoute_arrives uucpRoute_length_le)

/-! ## Comparing two recordings -/

/-- What another player's recording is to mine. -/
inductive SyncResult where
  /-- The same game. -/
  | inSync
  /-- Theirs is mine with more moves played: take it. -/
  | fastForward (l : Log)
  /-- Mine is theirs with more moves played: send mine. -/
  | ahead
  /-- Not even the same ship. -/
  | otherShip
  /-- The games part company at this move. -/
  | fork (n : Nat)
  deriving DecidableEq, Repr, Inhabited

/-- The first move at which two command tapes differ; the length of the
shorter one when one is a prefix of the other. -/
def firstDiff : List VoyageCmd → List VoyageCmd → Nat
  | [], _ => 0
  | _, [] => 0
  | a :: as, b :: bs => if a = b then firstDiff as bs + 1 else 0

/-- Comparing my recording with a peer's. -/
def syncLogs (mine theirs : Log) : SyncResult :=
  if mine.ship ≠ theirs.ship then .otherShip
  else if mine.cmds = theirs.cmds then .inSync
  else if mine.cmds <+: theirs.cmds then .fastForward theirs
  else if theirs.cmds <+: mine.cmds then .ahead
  else .fork (firstDiff mine.cmds theirs.cmds)

/-- **The same game is recognised as the same game.** -/
theorem sync_inSync (l : Log) : syncLogs l l = .inSync := by
  simp [syncLogs]

/-- **A peer who has played on is a fast-forward.** -/
theorem sync_fastForward {a b : Log} (hs : a.ship = b.ship) (hp : a.cmds <+: b.cmds)
    (hne : a.cmds ≠ b.cmds) : syncLogs a b = .fastForward b := by
  simp [syncLogs, hs, hne, hp]

/-- **A peer who is behind me leaves me ahead.** -/
theorem sync_ahead {a b : Log} (hs : a.ship = b.ship) (hp : b.cmds <+: a.cmds)
    (hne : a.cmds ≠ b.cmds) : syncLogs a b = .ahead := by
  have hnp : ¬ a.cmds <+: b.cmds := by
    intro h
    exact hne (List.IsPrefix.eq_of_length h (Nat.le_antisymm h.length_le hp.length_le))
  simp [syncLogs, hs, hne, hnp, hp]

/-- **A peer flying another ship is not playing my game.** -/
theorem sync_otherShip {a b : Log} (hs : a.ship ≠ b.ship) : syncLogs a b = .otherShip := by
  simp [syncLogs, hs]

/-- Up to the first difference, the two tapes agree. -/
theorem firstDiff_take : ∀ (as bs : List VoyageCmd),
    as.take (firstDiff as bs) = bs.take (firstDiff as bs) := by
  intro as
  induction as with
  | nil => intro bs; simp [firstDiff]
  | cons a as ih =>
      intro bs
      cases bs with
      | nil => simp [firstDiff]
      | cons b bs =>
          simp only [firstDiff]
          split_ifs with h
          · subst h
            simp [ih bs]
          · simp

/-- Where two tapes both go on, the first difference really is a difference. -/
theorem firstDiff_ne : ∀ (as bs : List VoyageCmd),
    firstDiff as bs < as.length → firstDiff as bs < bs.length →
      as[firstDiff as bs]! ≠ bs[firstDiff as bs]! := by
  intro as
  induction as with
  | nil => intro bs h; simp at h
  | cons a as ih =>
      intro bs ha hb
      cases bs with
      | nil => simp [firstDiff] at hb
      | cons b bs =>
          simp only [firstDiff] at ha hb ⊢
          split_ifs at ha hb ⊢ with h
          · have ha' : firstDiff as bs < as.length := by simpa using ha
            have hb' : firstDiff as bs < bs.length := by simpa using hb
            simpa using ih bs ha' hb'
          · simpa using h

/-- A fork is reported at the first difference. -/
theorem syncLogs_fork_eq {a b : Log} {n : Nat} (h : syncLogs a b = .fork n) :
    n = firstDiff a.cmds b.cmds := by
  unfold syncLogs at h
  split_ifs at h with h1 h2 h3 h4
  all_goals simp only [SyncResult.fork.injEq] at h
  exact h.symm

/-- **A fork is reported where the games really part company** — the opening
they share is the same on both tapes. -/
theorem sync_fork_agrees_before {a b : Log} {n : Nat} (h : syncLogs a b = .fork n) :
    a.cmds.take n = b.cmds.take n := by
  have hn := syncLogs_fork_eq h
  subst hn
  exact firstDiff_take a.cmds b.cmds

/-- **And at the fork the two moves are different.** -/
theorem sync_fork_differs_at {a b : Log} {n : Nat} (h : syncLogs a b = .fork n)
    (ha : n < a.cmds.length) (hb : n < b.cmds.length) :
    a.cmds[n]! ≠ b.cmds[n]! := by
  have hn := syncLogs_fork_eq h
  subst hn
  exact firstDiff_ne a.cmds b.cmds ha hb

/-! ## Taking a peer's game -/

/-- **A fast-forward never rewrites history**: everything I had already played
is still there, hash for hash. -/
theorem fastForward_keeps_chain {a b : Log} (hs : a.ship = b.ship) (hp : a.cmds <+: b.cmds) :
    a.chain <+: b.chain := by
  obtain ⟨ds, hds⟩ := hp
  have hstart : a.start = b.start := by
    unfold Log.start
    rw [hs]
  unfold Log.chain
  rw [hstart, ← hds]
  exact chain_prefix b.start (rootHash b.start) a.cmds ds

/-- My commitment is one of the hashes of the game I fast-forward to. -/
theorem fastForward_keeps_commit {a b : Log} (hs : a.ship = b.ship) (hp : a.cmds <+: b.cmds)
    (hne : a.cmds ≠ []) : a.commit ∈ b.chain := by
  have hpc := fastForward_keeps_chain hs hp
  have hlen : a.chain.length = a.cmds.length := chain_length _ _ _
  have hne' : a.chain ≠ [] := by
    intro h
    rw [h] at hlen
    exact hne (List.eq_nil_of_length_eq_zero hlen.symm)
  have hmem : a.commit ∈ a.chain := by
    unfold Log.commit
    rw [List.getLastD_eq_getLast? ]
    cases hlast : a.chain.getLast? with
    | none => exact absurd (List.getLast?_eq_none_iff.mp hlast) hne'
    | some v => simpa using List.mem_of_getLast? hlast
  exact hpc.subset hmem

/-! ## Checking a peer's game -/

/-- Take a sealed recording only if it checks out: the commitment must be the
one its own replay produces. -/
def accept (r : Sealed) : Option Log := if verify r then some r.log else none

/-- **A recording that checks out is kept.** -/
theorem accept_verified (l : Log) : accept (sealLog l) = some l := by
  unfold accept
  rw [if_pos (verify_self l)]
  rfl

/-- **A recording whose commitment does not match its moves is refused.** -/
theorem accept_rejects_tampered {r : Sealed} (h : r.log.commit ≠ r.claim) : accept r = none := by
  unfold accept
  rw [if_neg]
  intro hv
  exact h ((verify_iff r).mp hv)

/-- **An accepted recording is a legal game**: replaying it never leaves the
box, the ship's limits or a well-formed market. -/
theorem accept_legal {r : Sealed} {l : Log} (h : accept r = some l) (hstart : VoyageOk l.start) :
    VoyageOk l.replay ∧ l.commit = r.claim := by
  unfold accept at h
  split_ifs at h with hv
  have hl : r.log = l := by injection h
  subst hl
  exact ⟨replay_ok hstart, (verify_iff r).mp hv⟩

/-! ## Carrying a game over UUCP -/

/-- A recording in the bag: who it is going to, the bang path it travels, the
saved game and the commitment claimed for it. -/
structure Packet where
  /-- The node it starts at. -/
  src : Nat
  /-- The node it is addressed to. -/
  dst : Nat
  /-- The store-and-forward route through the ring. -/
  route : List Nat
  /-- The route the way UUCP writes it. -/
  path : String
  /-- The saved game. -/
  payload : String
  /-- The commitment claimed for it. -/
  claim : Nat
  deriving DecidableEq, Repr, Inhabited

/-- Put a sealed recording in the bag. -/
def sendLog (src dst : Nat) (user : String) (r : Sealed) : Packet :=
  { src := src, dst := dst, route := uucpRoute src dst, path := bangPath src dst user,
    payload := saveLog r.log, claim := r.claim }

/-- Take it out again. -/
def receiveLog (p : Packet) : Option Sealed :=
  (loadLog p.payload).map (fun l => { log := l, claim := p.claim })

/-- **The bag arrives where it is addressed.** -/
theorem send_arrives : ∀ i < uucpNodes, ∀ j < uucpNodes, ∀ (user : String) (r : Sealed),
    (sendLog i j user r).route.getLast? = some j := by
  intro i hi j hj user r
  exact uucpRoute_arrives i hi j hj

/-- **And never takes more than seven hops.** -/
theorem send_hops_le (i j : Nat) (user : String) (r : Sealed) :
    (sendLog i j user r).route.length ≤ uucpNodes := uucpRoute_length_le i j

/-- **What comes out of the bag is what went in.** -/
theorem receive_send (i j : Nat) (user : String) (r : Sealed)
    (h : ∀ c ∈ r.log.cmds, CmdOk c) :
    receiveLog (sendLog i j user r) = some r := by
  simp only [receiveLog, sendLog, loadLog_saveLog r.log h, Option.map_some]

/-- **A recording that left sealed arrives verified.** -/
theorem receive_send_verifies (i j : Nat) (user : String) (l : Log)
    (h : ∀ c ∈ l.cmds, CmdOk c) :
    (receiveLog (sendLog i j user (sealLog l))).map verify = some true := by
  rw [receive_send i j user (sealLog l) h]
  simpa using verify_self l

/-! ## Two players -/

/-- Player one's game: the demo trade run. -/
def demoMine : Log := demoLog

/-- Player two has played the same opening and three moves more. -/
def demoTheirs : Log :=
  { demoMine with cmds := demoMine.cmds ++ [.turnTo 2, .thrust, .fly] }

/-- **Player two is a clean fast-forward.** -/
theorem demoAhead : syncLogs demoMine demoTheirs = .fastForward demoTheirs := by
  refine sync_fastForward rfl ⟨[.turnTo 2, .thrust, .fly], rfl⟩ ?_
  intro h
  have := congrArg List.length h
  simp [demoTheirs] at this

/-- **Taking their game keeps mine**: my commitment is one of their hashes. -/
theorem demoAhead_keeps_commit : demoMine.commit ∈ demoTheirs.chain := by
  refine fastForward_keeps_commit rfl ⟨[.turnTo 2, .thrust, .fly], rfl⟩ ?_
  decide

/-- Player three shares the opening but sells where player one bought. -/
def demoOther : Log :=
  { demoMine with cmds := demoMine.cmds.take 30 ++ [.wait, .wait, .wait] }

/-- **The fork is found at move thirty.** -/
theorem demoFork : syncLogs demoMine demoOther = .fork 30 := by decide +kernel

/-- **And the two games really do agree up to it and differ at it.** -/
theorem demoFork_is_a_fork :
    demoMine.cmds.take 30 = demoOther.cmds.take 30 ∧
      demoMine.cmds[30]! ≠ demoOther.cmds[30]! := by
  refine ⟨sync_fork_agrees_before demoFork, sync_fork_differs_at demoFork ?_ ?_⟩ <;> decide

/-- **A tampered recording is refused**: change one move and the commitment no
longer matches. -/
theorem demoTamper_refused :
    accept { log := demoOther, claim := demoMine.commit } = none := by
  refine accept_rejects_tampered ?_
  decide +kernel

end Trade
end NixWars
