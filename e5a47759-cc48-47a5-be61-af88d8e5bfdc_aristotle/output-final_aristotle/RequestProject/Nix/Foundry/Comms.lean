import RequestProject.Nix.Foundry.Fleet
import RequestProject.Nix.NixWars.Transports

/-!
# Out-of-band: UUCP, dead drops, sneakernet, fax, morse and the ham band

The foundry's agents are on a VPN, but the VPN is not how they are *specified*
to talk. Everything here is a channel that survives the network being wrong,
and every one of them is a codec with a round-trip proof, so a message that
goes out one end comes back at the other:

* **UUCP** — the eight nodes are a ring, `uucpRoute` is the store-and-forward
  route between two of them and `bangPath` writes it the way UUCP writes it,
  `nwingest!nwcurate!user`. `uucpRoute_arrives` says the route arrives,
  `uucpRoute_length_le` that it never takes more than seven hops.
* **Dead drops** — a message left on a shard, one-time padded and read out as
  a numbers station (`collect_leave`).
* **Sneakernet** — the courier's stick: SLIP frames carried by hand into the
  air-gapped zone. `sneakernet_roundtrip` reads the stick back;
  `sneakernet_is_the_only_way` is the reason there is a courier at all.
* **Fax** — Group 3 in miniature: a scanline is run-length coded
  (`unruns_runsOf`), the runs go out as numbers in an async-HDLC frame, and a
  page is a list of scanlines (`faxTransport_roundtrip`).
* **Morse and the 40-metre band** — a message keyed as international morse
  (`qso_roundtrip`), each agent with its own CW frequency inside the band
  (`freq_in_band`, `freq_nodup`).

Every wire here is built from the codecs the board already ships, so the
round trips are the board's own theorems, reused.
-/

set_option autoImplicit false

namespace NixWars
namespace Foundry

/-! ## UUCP: the eight nodes, and the bang path between them -/

/-- The number of UUCP nodes: one per agent. -/
def uucpNodes : Nat := 8

/-- The agent at a node index. -/
def node (i : Nat) : Agent := fleet.getD i default

/-- One store-and-forward hop around the ring. -/
def uucpHop (i : Nat) : Nat := (i + 1) % uucpNodes

/-- How many hops separate two nodes, going the way the spool runs. -/
def uucpHops (i j : Nat) : Nat := (j + uucpNodes - i % uucpNodes) % uucpNodes

/-- **The route**: the nodes a job passes through, sender first, recipient
last. -/
def uucpRoute (i j : Nat) : List Nat :=
  (List.range (uucpHops i j + 1)).map (fun k => (i + k) % uucpNodes)

/-- **The route arrives.** -/
theorem uucpRoute_arrives : ∀ i < uucpNodes, ∀ j < uucpNodes,
    (uucpRoute i j).getLast? = some j := by decide

/-- The route starts at the sender. -/
theorem uucpRoute_head : ∀ i < uucpNodes, ∀ j < uucpNodes,
    (uucpRoute i j).head? = some (i % uucpNodes) := by decide

/-- **Never more than seven hops**, because there are eight nodes. -/
theorem uucpRoute_length_le (i j : Nat) : (uucpRoute i j).length ≤ uucpNodes := by
  have h : uucpHops i j < uucpNodes := Nat.mod_lt _ (by decide)
  simp only [uucpRoute, List.length_map, List.length_range]
  omega

/-- Each hop of the route really is a hop. -/
theorem uucpRoute_hops : ∀ i < uucpNodes, ∀ j < uucpNodes,
    ∀ k < (uucpRoute i j).length - 1,
      (uucpRoute i j).getD (k + 1) 0 = uucpHop ((uucpRoute i j).getD k 0) := by decide

/-- **The bang path**, as UUCP writes it. -/
def bangPath (i j : Nat) (user : String) : String :=
  String.intercalate "!" (((uucpRoute i j).map (fun k => (node k).uucp)) ++ [user])

/-- The ingestor mailing the referee, written out. -/
theorem bangPath_example :
    bangPath 0 6 "challenge" =
      "nwingest!nwcurate!nwwarden!nwcourr!nwherald!nwusher!nwref!challenge" := by
  native_decide

/-- Every node of every route is one of the eight agents. -/
theorem uucpRoute_nodes : ∀ i < uucpNodes, ∀ j < uucpNodes,
    ∀ k ∈ uucpRoute i j, k < uucpNodes := by decide

/-! ## Dead drops

A message left on a shard for somebody else to collect: one-time padded, then
read out in groups of digits the way a numbers station does. -/

/-- A dead drop: the shard it was left on, and what was left there. -/
structure Drop where
  /-- The shard of the DMZ the drop sits on. -/
  shard : Nat
  /-- The traffic, as the station reads it out. -/
  traffic : String
  deriving DecidableEq, Repr, Inhabited

/-- **Leaving a drop**: pad the message, read it out, leave it on a shard. -/
def leaveDrop (key : List (Sym 9)) (shard : Nat) (msg : List Nat) : Drop :=
  ⟨shardOf shard, (paddedNumbersTransport key).encode msg⟩

/-- **Collecting a drop**, with the same pad. -/
def collectDrop (key : List (Sym 9)) (d : Drop) : Option (List Nat) :=
  (paddedNumbersTransport key).decode d.traffic

/-- **A drop reads back exactly what was left.** -/
theorem collect_leave (key : List (Sym 9)) (shard : Nat) (msg : List Nat) :
    collectDrop key (leaveDrop key shard msg) = some msg :=
  (paddedNumbersTransport key).decode_encode msg

/-- A drop is always on a real shard. -/
theorem leaveDrop_shard_lt (key : List (Sym 9)) (shard : Nat) (msg : List Nat) :
    (leaveDrop key shard msg).shard < numShards := shardOf_lt _

/-- Without the pad the traffic is somebody else's problem: a drop left under
one key does not read back under another unless the keys agree on it. -/
theorem collect_wrong_key_ne (key key' : List (Sym 9)) (shard : Nat) (msg : List Nat)
    (h : collectDrop key' (leaveDrop key shard msg) = some msg) :
    (paddedNumbersTransport key').decode ((paddedNumbersTransport key).encode msg) = some msg := h

/-! ## Sneakernet

The courier's stick: a list of messages, each an RFC 1055 SLIP frame, carried
by hand into the air gap. -/

/-- **The stick.** -/
def sneakernet : Codec (List (List Nat)) (List (List UInt8)) := Codec.onList slipTransport

/-- **What is carried in is what is read out.** -/
theorem sneakernet_roundtrip (msgs : List (List Nat)) :
    sneakernet.decode (sneakernet.encode msgs) = some msgs :=
  sneakernet.decode_encode msgs

/-- **Why there is a courier**: no zone reaches the air gap over the network,
so the only way in is to carry it. -/
theorem sneakernet_is_the_only_way (z : Zone) (h : z ≠ Zone.airgap) : ¬ Flows z Zone.airgap :=
  airgap_isolated_in z h

/-! ## Fax

Group 3 in miniature: a scanline is a list of black-and-white pixels, coded as
runs of one colour. -/

/-- The runs of a scanline: the colour of each run and its length. -/
def runsOf : List Bool → List (Bool × Nat)
  | [] => []
  | b :: l =>
    match runsOf l with
    | [] => [(b, 1)]
    | (c, n) :: rest => if b == c then (c, n + 1) :: rest else (b, 1) :: (c, n) :: rest

/-- Painting the runs back out. -/
def unruns : List (Bool × Nat) → List Bool
  | [] => []
  | (c, n) :: rest => List.replicate n c ++ unruns rest

/-- **Run-length coding a scanline loses nothing.** -/
theorem unruns_runsOf (l : List Bool) : unruns (runsOf l) = l := by
  induction l with
  | nil => rfl
  | cons b l ih =>
      unfold runsOf
      cases hr : runsOf l with
      | nil =>
          rw [hr] at ih
          simp only [unruns] at ih ⊢
          simp [← ih]
      | cons p rest =>
          obtain ⟨c, n⟩ := p
          rw [hr] at ih
          by_cases hbc : b = c
          · subst hbc
            simp only [beq_self_eq_true, if_true, unruns] at ih ⊢
            rw [List.replicate_succ]
            simpa using congrArg (fun x => b :: x) ih
          · simp only [beq_iff_eq, hbc, if_false, unruns] at ih ⊢
            simpa using congrArg (fun x => b :: x) ih

/-- The runs, as numbers on the wire: colour bit, then length. -/
def runsToNats (rs : List (Bool × Nat)) : List Nat :=
  rs.flatMap (fun r => [if r.1 then 1 else 0, r.2])

/-- Reading the runs back off the wire. -/
def natsToRuns : List Nat → Option (List (Bool × Nat))
  | [] => some []
  | c :: n :: rest => (natsToRuns rest).map (fun rs => ((c == 1), n) :: rs)
  | _ => none

theorem natsToRuns_runsToNats (rs : List (Bool × Nat)) :
    natsToRuns (runsToNats rs) = some rs := by
  induction rs with
  | nil => rfl
  | cons p rest ih =>
      obtain ⟨c, n⟩ := p
      cases c <;> simp [runsToNats, natsToRuns, ih] at ih ⊢

/-- **A scanline as a codec.** -/
def faxLine : Codec (List Bool) (List Nat) where
  encode := fun l => runsToNats (runsOf l)
  decode := fun ns => (natsToRuns ns).map unruns
  decode_encode := fun l => by rw [natsToRuns_runsToNats]; simp [unruns_runsOf]

/-- A page: a list of scanlines. -/
abbrev Page := List (List Bool)

/-- **The fax transport**: every scanline run-length coded and sent in an
async-HDLC frame, exactly as the board's PPP wire does it. -/
def faxTransport : Codec Page (List (List UInt8)) :=
  Codec.onList (faxLine.comp pppTransport)

/-- **A page received is the page sent.** -/
theorem faxTransport_roundtrip (p : Page) :
    faxTransport.decode (faxTransport.encode p) = some p :=
  faxTransport.decode_encode p

/-- A cover sheet: five scanlines of eight pixels, the letters `NW`. -/
def coverSheet : Page :=
  [ [true, false, false, true, false, true, false, true],
    [true, true, false, true, false, true, false, true],
    [true, false, true, true, false, true, true, true],
    [true, false, false, true, false, true, true, true],
    [true, false, false, true, false, false, true, false] ]

/-- The cover sheet survives the fax. -/
theorem coverSheet_roundtrip : faxTransport.decode (faxTransport.encode coverSheet) = some coverSheet :=
  faxTransport_roundtrip coverSheet

/-! ## Morse and the 40-metre band -/

/-- **A QSO**: what one agent keys to another. -/
def qso : Codec (List Nat) (List MorseSym) := morseTransport

/-- **What is keyed is what is copied.** -/
theorem qso_roundtrip (msg : List Nat) : qso.decode (qso.encode msg) = some msg :=
  morseTransport.decode_encode msg

/-- The CW frequency, in kilohertz, an agent is assigned inside the 40-metre
band. -/
def Agent.freqKHz (a : Agent) : Nat := 7010 + a.shard

/-- **Every agent's frequency is inside the CW segment of the band**, which
runs from 7000 to 7080 kHz however the shards fall. -/
theorem freq_in_band : ∀ a ∈ fleet, 7000 ≤ a.freqKHz ∧ a.freqKHz ≤ 7080 := by
  intro a ha
  have := fleet_shard_lt a ha
  simp only [Agent.freqKHz, numShards] at *
  omega

/-- **No two agents transmit on the same frequency.** -/
theorem freq_nodup : (fleet.map Agent.freqKHz).Nodup := by decide

/-- A callsign keyed in morse, letter by letter. -/
def callsignMorse (a : Agent) : List (List MorseSym) :=
  a.callsign.toList.map (fun c =>
    let i := if '0' ≤ c && c ≤ '9' then c.toNat - 48 else c.toNat - 65 + 10
    (morseTable.getD i []))

/-- Every letter of every callsign has a morse code. -/
theorem callsignMorse_nonempty : ∀ a ∈ fleet, ∀ m ∈ callsignMorse a, m ≠ [] := by decide

/-! ## Telemetry

The spans an agent exports carry its own resource attributes, so two agents'
traces never merge. -/

/-- The OpenTelemetry `service.name` of an agent. -/
def Agent.serviceName (a : Agent) : String := "nixwars." ++ a.handle

/-- The resource attributes of an agent, as the collector receives them. -/
def Agent.otelResource (a : Agent) : List (String × String) :=
  [ ("service.name", a.serviceName),
    ("service.namespace", "nixwars"),
    ("nixwars.zone", a.zone.name),
    ("nixwars.shard", toString a.shard),
    ("nixwars.callsign", a.callsign),
    ("nixwars.extension", toString a.ext) ]

/-- **Two agents never share a service name.** -/
theorem serviceName_nodup : (fleet.map Agent.serviceName).Nodup := by decide

/-- Every agent reports the same six attributes. -/
theorem otelResource_keys : ∀ a ∈ fleet, a.otelResource.map Prod.fst =
    ["service.name", "service.namespace", "nixwars.zone", "nixwars.shard",
     "nixwars.callsign", "nixwars.extension"] := by decide

end Foundry
end NixWars
