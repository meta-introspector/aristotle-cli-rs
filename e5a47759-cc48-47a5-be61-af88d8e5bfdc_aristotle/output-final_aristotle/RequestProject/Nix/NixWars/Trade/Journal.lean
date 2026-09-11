import RequestProject.Nix.NixWars.Trade.Voyage
import RequestProject.Nix.NixWars.Ledger
import RequestProject.Nix.NixWars.Transports

/-!
# Recording a voyage: the log, the save file and the commitment

A game here is not a server session, it is a *log*: which ship was flown, and
which commands were given.  That is all a recording needs to be, because the
flight is deterministic — replaying the log reproduces the game exactly, frame
for frame (`replay_record`, `replay_append`).

* **Recording.**  `Log.record` writes one command at the end of the tape;
  replaying the longer tape is replaying the shorter one and then taking that
  command (`replay_record`).  Nothing already recorded is ever rewritten
  (`record_prefix`).
* **Saving.**  A log is a list of numbers (`logNums`), and the project's own
  URL transport turns that into text and back, so a recording is a string a
  player can keep, paste or mail: `loadLog_saveLog` says a saved game loads
  back exactly.
* **The log you can check.**  Every recorded command carries a hash of the
  state it produced, folded into the hash before it (`chainFrom`), and the
  last hash is the *commitment* of the recording (`commit`).  The chain has
  one hash per command (`chain_length`), is append-only (`chain_append`,
  `chain_prefix`) and is exactly what a verifier recomputes (`verify_iff`,
  `verify_self`).  If the mixer never collides then two different recordings
  of the same length cannot produce the same chain (`chainFrom_inj`) — and the
  demo run's thirty-four hashes are checked to be distinct
  (`tradeRun_chain_distinct`).

This is what makes `Trade.Sync` possible: two players can swap recordings and
check each other's games without trusting each other or any server.
-/

set_option maxRecDepth 100000

namespace NixWars
namespace Trade

/-! ## Commands as numbers -/

/-- A command as a number. -/
def encodeCmd : VoyageCmd → Nat
  | .thrust => 1
  | .brake => 2
  | .fly => 3
  | .dock => 4
  | .refuel => 5
  | .wait => 6
  | .turnTo h => 10 + h
  | .buy g => 20 + g
  | .sell g => 30 + g

/-- Reading a command back out of a number. -/
def decodeCmd (n : Nat) : VoyageCmd :=
  if n = 1 then .thrust
  else if n = 2 then .brake
  else if n = 3 then .fly
  else if n = 4 then .dock
  else if n = 5 then .refuel
  else if 10 ≤ n ∧ n ≤ 15 then .turnTo (n - 10)
  else if 20 ≤ n ∧ n ≤ 24 then .buy (n - 20)
  else if 30 ≤ n ∧ n ≤ 34 then .sell (n - 30)
  else .wait

/-- A command a player can actually give: headings among the six, goods among
the five. -/
def CmdOk : VoyageCmd → Prop
  | .turnTo h => h ≤ 5
  | .buy g => g < numGoods
  | .sell g => g < numGoods
  | _ => True

instance : DecidablePred CmdOk := fun c => by
  cases c <;> unfold CmdOk <;> infer_instance

/-- **A command survives the round trip.** -/
theorem decodeCmd_encodeCmd {c : VoyageCmd} (h : CmdOk c) : decodeCmd (encodeCmd c) = c := by
  cases c with
  | thrust => rfl
  | brake => rfl
  | fly => rfl
  | dock => rfl
  | refuel => rfl
  | wait => rfl
  | turnTo k =>
      have hk : k ≤ 5 := h
      simp only [encodeCmd, decodeCmd]
      split_ifs <;> (congr 1; omega)
  | buy g =>
      have hg : g < numGoods := h
      simp only [numGoods] at hg
      simp only [encodeCmd, decodeCmd]
      split_ifs <;> (congr 1; omega)
  | sell g =>
      have hg : g < numGoods := h
      simp only [numGoods] at hg
      simp only [encodeCmd, decodeCmd]
      split_ifs <;> (congr 1; omega)

/-- Every command of the demo run is a command a player could give. -/
theorem tradeRun_cmds_ok : ∀ c ∈ tradeRun, CmdOk c := by decide

/-! ## The log -/

/-- A recording: the build that was flown and the commands that were given. -/
structure Log where
  /-- The ship, packed by `encodeSpec`. -/
  ship : Nat
  /-- The commands, in the order they were given. -/
  cmds : List VoyageCmd
  deriving DecidableEq, Repr, Inhabited

/-- The position a recording starts from. -/
def Log.start (l : Log) : Voyage := newVoyage (decodeSpec "RECORDED" l.ship)

/-- Replaying a recording. -/
def Log.replay (l : Log) : Voyage := voyageRun l.start l.cmds

/-- Writing one more command at the end of the tape. -/
def Log.record (l : Log) (c : VoyageCmd) : Log := { l with cmds := l.cmds ++ [c] }

/-- An empty recording of a given build. -/
def Log.fresh (spec : ShipSpec) : Log := { ship := encodeSpec spec, cmds := [] }

theorem voyageRun_append (s : Voyage) (cs ds : List VoyageCmd) :
    voyageRun s (cs ++ ds) = voyageRun (voyageRun s cs) ds := by
  induction cs generalizing s with
  | nil => rfl
  | cons c cs ih => simpa [voyageRun] using ih (voyageStep s c)

/-- **Replaying a longer tape is replaying the shorter one and then playing the
command that was added.** -/
theorem replay_record (l : Log) (c : VoyageCmd) :
    (l.record c).replay = voyageStep l.replay c := by
  simp [Log.replay, Log.record, Log.start, voyageRun_append, voyageRun]

/-- Replaying two stretches of tape is replaying them one after the other. -/
theorem replay_append (l : Log) (ds : List VoyageCmd) :
    ({ l with cmds := l.cmds ++ ds } : Log).replay = voyageRun l.replay ds := by
  simp [Log.replay, Log.start, voyageRun_append]

/-- **Recording never rewrites the tape**: what was there is still there, in
order, at the front. -/
theorem record_prefix (l : Log) (c : VoyageCmd) : l.cmds <+: (l.record c).cmds :=
  ⟨[c], rfl⟩

/-- A recording of a legal build stays legal for its whole length. -/
theorem replay_ok {l : Log} (h : VoyageOk l.start) : VoyageOk l.replay :=
  voyageRun_ok h l.cmds

/-! ## Saving and loading -/

/-- A recording as a list of numbers: the ship, then one number per
command. -/
def logNums (l : Log) : List Nat := l.ship :: l.cmds.map encodeCmd

/-- Reading a recording back out of a list of numbers. -/
def logOfNums : List Nat → Option Log
  | [] => none
  | ship :: rest => some { ship := ship, cmds := rest.map decodeCmd }

/-- A recording as text: the project's own URL transport. -/
def saveLog (l : Log) : String := urlTransport.encode (logNums l)

/-- Reading a recording back out of text. -/
def loadLog (str : String) : Option Log :=
  match urlTransport.decode str with
  | none => none
  | some ns => logOfNums ns

/-- Every command in a list of legal commands survives the round trip. -/
theorem map_decodeCmd_encodeCmd : ∀ (cs : List VoyageCmd), (∀ c ∈ cs, CmdOk c) →
    (cs.map encodeCmd).map decodeCmd = cs := by
  intro cs
  induction cs with
  | nil => intro _; rfl
  | cons c cs ih =>
      intro h
      simp only [List.map_cons, List.cons.injEq]
      exact ⟨decodeCmd_encodeCmd (h c (by simp)), ih (fun c' hc' => h c' (by simp [hc']))⟩

/-- **A saved game loads back exactly.** -/
theorem loadLog_saveLog (l : Log) (h : ∀ c ∈ l.cmds, CmdOk c) : loadLog (saveLog l) = some l := by
  unfold loadLog saveLog
  rw [urlTransport.decode_encode]
  simp only [logNums, logOfNums, Option.some.injEq]
  have hmap := map_decodeCmd_encodeCmd l.cmds h
  cases l
  simp only [Log.mk.injEq, true_and]
  simpa using hmap

/-- The demo run, saved. -/
def demoLog : Log :=
  { ship := encodeSpec (stockShips.getD 3 default), cmds := tradeRun }

theorem demoLog_roundtrip : loadLog (saveLog demoLog) = some demoLog :=
  loadLog_saveLog demoLog (by decide)

/-! ## The chain: a log you can check -/

/-- The state of a voyage as numbers, for hashing. -/
def voyageDigest (s : Voyage) : List Nat :=
  [s.x, s.y, s.z, s.hdg, s.speed, s.fuel, s.docked, s.credits, s.shipCode,
   s.maxSpeed, s.tankCap, s.holdCap, s.turn, s.econ.round] ++ s.hold ++ s.econ.stocks.flatten

/-- One link of the chain: the hash before it, the command played, and the
state that command produced. -/
def chainStep (h : Nat) (c : VoyageCmd) (s : Voyage) : Nat :=
  hashNums h (encodeCmd c :: voyageDigest s)

/-- The hashes of the states a recording passes through. -/
def chainFrom (s : Voyage) (h : Nat) : List VoyageCmd → List Nat
  | [] => []
  | c :: rest =>
      let s' := voyageStep s c
      let h' := chainStep h c s'
      h' :: chainFrom s' h' rest

/-- The hash of the position a recording starts from. -/
def rootHash (s : Voyage) : Nat := hashNums 0 (voyageDigest s)

/-- The chain of a recording. -/
def Log.chain (l : Log) : List Nat := chainFrom l.start (rootHash l.start) l.cmds

/-- **The commitment** of a recording: the hash a player can post to stake a
claim on the game they played. -/
def Log.commit (l : Log) : Nat := l.chain.getLastD (rootHash l.start)

/-- One hash per command. -/
theorem chain_length (s : Voyage) (h : Nat) (cs : List VoyageCmd) :
    (chainFrom s h cs).length = cs.length := by
  induction cs generalizing s h with
  | nil => rfl
  | cons c cs ih => simp [chainFrom, ih]

/-- The last element of a non-empty list does not depend on the default. -/
theorem getLastD_cons_eq (x d : Nat) : ∀ (rest : List Nat),
    (x :: rest).getLastD d = rest.getLastD x
  | [] => rfl
  | y :: ys => by
      cases hg : (y :: ys).getLast? with
      | none => simp [List.getLast?_eq_none_iff] at hg
      | some v => simp [List.getLastD_eq_getLast?, hg]

/-- **The chain is append-only**: playing on extends it and rewrites none of
it. -/
theorem chain_append (s : Voyage) (h : Nat) (cs ds : List VoyageCmd) :
    chainFrom s h (cs ++ ds) =
      chainFrom s h cs ++
        chainFrom (voyageRun s cs) ((chainFrom s h cs).getLastD h) ds := by
  induction cs generalizing s h with
  | nil => simp [chainFrom, voyageRun]
  | cons c cs ih =>
      simp only [List.cons_append, chainFrom, voyageRun, ih, getLastD_cons_eq]

theorem chain_prefix (s : Voyage) (h : Nat) (cs ds : List VoyageCmd) :
    chainFrom s h cs <+: chainFrom s h (cs ++ ds) := by
  rw [chain_append]
  exact ⟨_, rfl⟩

/-- Recording one more command extends the chain by one hash and keeps every
hash that was there. -/
theorem record_chain (l : Log) (c : VoyageCmd) : l.chain <+: (l.record c).chain := by
  simpa [Log.chain, Log.record, Log.start] using chain_prefix l.start (rootHash l.start) l.cmds [c]

/-! ## Checking somebody else's game -/

/-- A *sealed* recording: a log and the commitment its owner claims for it. -/
structure Sealed where
  /-- The recording. -/
  log : Log
  /-- The commitment claimed for it. -/
  claim : Nat
  deriving DecidableEq, Repr, Inhabited

/-- Seal a recording with its own commitment. -/
def sealLog (l : Log) : Sealed := { log := l, claim := l.commit }

/-- Check a sealed recording: replay it and see whether the chain ends where
its owner says it does. -/
def verify (r : Sealed) : Bool := r.log.commit == r.claim

/-- **The verifier is exactly right.** -/
theorem verify_iff (r : Sealed) : verify r = true ↔ r.log.commit = r.claim := by
  simp [verify]

/-- **An honest recording always checks out.** -/
theorem verify_self (l : Log) : verify (sealLog l) = true := by
  simp [verify, sealLog]

/-- **A checked recording tells you the position it ended in**: the verifier
having passed, the claimed commitment is the commitment of the replay, which is
the hash chain of the states `Log.replay` passes through. -/
theorem verified_commit {r : Sealed} (h : verify r = true) : r.log.commit = r.claim :=
  (verify_iff r).mp h

/-- Tamper evidence, on the hypothesis that the mixer never collides: two
recordings of the same length with the same chain are the same recording. -/
theorem chainFrom_inj (hinj : ∀ h h' c c' s s', hashNums h (encodeCmd c :: voyageDigest s) =
      hashNums h' (encodeCmd c' :: voyageDigest s') → c = c') :
    ∀ (cs ds : List VoyageCmd) (s : Voyage) (h : Nat),
      cs.length = ds.length → chainFrom s h cs = chainFrom s h ds → cs = ds := by
  intro cs
  induction cs with
  | nil => intro ds _ _ hlen _; cases ds <;> simp_all
  | cons c cs ih =>
      intro ds s h hlen hchain
      cases ds with
      | nil => simp at hlen
      | cons d ds =>
          simp only [chainFrom, List.cons.injEq] at hchain
          obtain ⟨hh, htail⟩ := hchain
          have hcd : c = d := hinj _ _ _ _ _ _ hh
          subst hcd
          have htail' := ih ds (voyageStep s c) (chainStep h c (voyageStep s c))
            (by simpa using hlen) (by simpa [hh] using htail)
          rw [htail']

/-- The demo recording's thirty-four hashes are all different. -/
theorem tradeRun_chain_distinct : demoLog.chain.Nodup := by decide +kernel

/-- …and there is one of them per command. -/
theorem tradeRun_chain_length : demoLog.chain.length = 34 := by decide +kernel

end Trade
end NixWars
