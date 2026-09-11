import RequestProject.Nix.Foundry.Zones
import RequestProject.Nix.NixWars.Frens

/-!
# The fleet: one agent, one user, one address, one extension

Eight agents run the foundry, and the rule the configuration is generated
under is that *nothing is shared*: each agent is its own Unix user with its
own home, its own IPv6 address inside its zone's /64, its own WireGuard peer
and port, its own PBX extension, its own fax extension, its own direct-dial
number, its own amateur callsign and its own UUCP node name.

Everything an agent gets is derived from the one number that already places
it in this project — its shard of the 71-shard DMZ — so the separation
theorems below are all consequences of the shards being distinct
(`fleet_shards_nodup`), and hold for any fleet with distinct shards, not just
this one:

* `uid_nodup`, `unixName_nodup`, `home_nodup` — separate users;
* `addr_nodup` — separate addresses, inside the right zone
  (`agent_addr_zone`);
* `ext_nodup`, `fax_nodup`, `did_nodup`, `wgPort_nodup` — separate numbers;
* `ext_ne_fax` — a voice extension is never a fax extension, for *any* two
  agents, because the voice block is 70xx and the fax block is 71xx and there
  are only 71 shards;
* `dial_ext`, `dial_fax` — the emitted dial plan routes each number to the
  agent it belongs to;
* `otel_reachable` — every agent can reach the collector in the lab, except
  the courier, who is in the air-gapped zone and whose telemetry therefore
  travels by hand (`courier_offline`).
-/

set_option autoImplicit false

namespace NixWars
namespace Foundry

/-! ## An agent -/

/-- An agent of the foundry. Everything else it is given is derived from its
shard. -/
structure Agent where
  /-- The name it is known by. -/
  handle : String
  /-- What it does. -/
  role : String
  /-- The zone it runs in. -/
  zone : Zone
  /-- Its shard of the 71-shard DMZ. -/
  shard : Nat
  /-- Its amateur radio callsign. -/
  callsign : String
  /-- Its UUCP node name, at most eight characters, as UUCP requires. -/
  uucp : String
  deriving DecidableEq, Repr, Inhabited

/-- The Unix account an agent runs as. -/
def Agent.unixName (a : Agent) : String := "nw-" ++ a.handle

/-- Its user id: the reserved block starts at 10000 and is indexed by shard. -/
def Agent.uid (a : Agent) : Nat := 10000 + a.shard

/-- Its home, which no other agent can read. -/
def Agent.home (a : Agent) : String := "/var/lib/nixwars/" ++ a.handle

/-- Its address: host `shard` of its zone's /64. -/
def Agent.addr (a : Agent) : Ip6 := zoneAddr a.zone a.shard

/-- Its WireGuard listen port. -/
def Agent.wgPort (a : Agent) : Nat := 51820 + a.shard

/-- Its PBX extension: the voice block is 70xx. -/
def Agent.ext (a : Agent) : Nat := 7000 + a.shard

/-- Its fax extension: the fax block is 71xx. -/
def Agent.fax (a : Agent) : Nat := 7100 + a.shard

/-- Its direct-dial number, in the fictional +1-555-01xx block. -/
def Agent.did (a : Agent) : String := "+1555" ++ toString (10000 + a.shard)

/-- Its SIP address on the foundry's PBX. -/
def Agent.sip (a : Agent) : String := "sip:" ++ a.handle ++ "@pbx.nixwars.internal"

/-- The systemd unit that runs it. -/
def Agent.unit (a : Agent) : String := "nixwars-agent-" ++ a.handle ++ ".service"

/-- Where its sops secret lives. -/
def Agent.secret (a : Agent) : String := "secrets/agents/" ++ a.handle ++ ".yaml"

/-! ## The fleet -/

/-- **The eight agents of the foundry.** -/
def fleet : List Agent :=
  [ { handle := "ingestor", role := "walks the disks and files what it finds as cartridges",
      zone := .lab, shard := 3, callsign := "W1SHD", uucp := "nwingest" },
    { handle := "curator", role := "keeps the catalogue of record and its digests",
      zone := .vault, shard := 11, callsign := "W2CAT", uucp := "nwcurate" },
    { handle := "warden", role := "holds the sops keys and signs the releases",
      zone := .vault, shard := 47, callsign := "W3WRD", uucp := "nwwarden" },
    { handle := "courier", role := "carries the sneakernet between the shelf and the lab",
      zone := .airgap, shard := 23, callsign := "W4CUR", uucp := "nwcourr" },
    { handle := "herald", role := "broadcasts the board: morse, numbers station, the feed",
      zone := .pub, shard := 41, callsign := "W5HRL", uucp := "nwherald" },
    { handle := "usher", role := "serves the fifteen doors to players",
      zone := .dmz, shard := 17, callsign := "W6USH", uucp := "nwusher" },
    { handle := "referee", role := "runs the agent challenges and scores the submissions",
      zone := .lab, shard := 59, callsign := "W7REF", uucp := "nwref" },
    { handle := "operator", role := "the switchboard: extensions, fax, VoIP trunks and the key",
      zone := .dmz, shard := 31, callsign := "W8OPR", uucp := "nwoper" } ]

/-- The fleet is eight agents. -/
theorem fleet_length : fleet.length = 8 := rfl

/-- Every agent stands on a real shard of the DMZ. -/
theorem fleet_shard_lt : ∀ a ∈ fleet, a.shard < numShards := by decide

/-- **No two agents share a shard** — which is where every other separation
below comes from. -/
theorem fleet_shards_nodup : (fleet.map Agent.shard).Nodup := by decide

/-- Handles are distinct. -/
theorem fleet_handles_nodup : (fleet.map Agent.handle).Nodup := by decide

/-! ## Separate users -/

/-- **Separate accounts**: no two agents run as the same user. -/
theorem unixName_nodup : (fleet.map Agent.unixName).Nodup := by decide

/-- **Separate user ids.** -/
theorem uid_nodup : (fleet.map Agent.uid).Nodup := by decide

/-- **Separate homes.** -/
theorem home_nodup : (fleet.map Agent.home).Nodup := by decide

/-- The user ids all live in the reserved block `10000–10070`. -/
theorem uid_range : ∀ a ∈ fleet, 10000 ≤ a.uid ∧ a.uid < 10071 := by
  intro a ha
  have := fleet_shard_lt a ha
  simp only [Agent.uid, numShards] at *
  omega

/-- No agent runs as root, and none collides with a system account. -/
theorem uid_not_system : ∀ a ∈ fleet, 1000 < a.uid := by
  intro a ha
  have := (uid_range a ha).1
  omega

/-- Each agent's secret file is its own. -/
theorem secret_nodup : (fleet.map Agent.secret).Nodup := by decide

/-- Each agent's systemd unit is its own. -/
theorem unit_nodup : (fleet.map Agent.unit).Nodup := by decide

/-! ## Separate addresses -/

/-- **Separate addresses.** -/
theorem addr_nodup : (fleet.map Agent.addr).Nodup := by decide

/-- An agent's address is inside its own zone's /64. -/
theorem agent_addr_zone (a : Agent) : zoneOfAddr a.addr = some a.zone :=
  zoneOf_zoneAddr a.zone a.shard

/-- **Separate WireGuard ports.** -/
theorem wgPort_nodup : (fleet.map Agent.wgPort).Nodup := by decide

/-! ## Separate numbers -/

/-- **Separate voice extensions.** -/
theorem ext_nodup : (fleet.map Agent.ext).Nodup := by decide

/-- **Separate fax extensions.** -/
theorem fax_nodup : (fleet.map Agent.fax).Nodup := by decide

/-- **Separate direct-dial numbers.** -/
theorem did_nodup : (fleet.map Agent.did).Nodup := by decide

/-- **A voice extension is never a fax extension**, for any two agents at all:
the voice block ends at 7070 and the fax block starts at 7100, because there
are only 71 shards. -/
theorem ext_ne_fax : ∀ a ∈ fleet, ∀ b ∈ fleet, a.ext ≠ b.fax := by
  intro a ha b hb
  have h1 := fleet_shard_lt a ha
  have h2 := fleet_shard_lt b hb
  simp only [Agent.ext, Agent.fax, numShards] at *
  omega

/-- The dial plan: which agent answers an extension. -/
def dial (n : Nat) : Option Agent := fleet.find? (fun a => a.ext == n)

/-- The fax plan: which agent's fax answers a number. -/
def dialFax (n : Nat) : Option Agent := fleet.find? (fun a => a.fax == n)

/-- **Every agent is reachable at its own extension.** -/
theorem dial_ext : ∀ a ∈ fleet, dial a.ext = some a := by decide

/-- **Every agent's fax is reachable at its own fax extension.** -/
theorem dial_fax : ∀ a ∈ fleet, dialFax a.fax = some a := by decide

/-- A number outside the voice block rings nobody. -/
theorem dial_out_of_block (n : Nat) (h : n < 7000) : dial n = none := by
  have : ∀ a ∈ fleet, ¬ (a.ext == n) = true := by
    intro a ha
    have := (uid_range a ha).1
    simp only [Agent.ext, beq_iff_eq]
    omega
  exact List.find?_eq_none.2 this

/-! ## Radio and UUCP -/

/-- A callsign as the band plan allows it: one letter, one digit, then two or
three letters, all upper case. -/
def validCallsign (s : String) : Bool :=
  let l := s.toList
  let isAZ := fun (c : Char) => 'A' ≤ c && c ≤ 'Z'
  let isDigit := fun (c : Char) => '0' ≤ c && c ≤ '9'
  (l.length == 4 || l.length == 5) &&
    (l.headD 'x' |> isAZ) && (l.getD 1 'x' |> isDigit) &&
    (l.drop 2).all isAZ && !((l.drop 2).isEmpty)

/-- **Every callsign is well formed.** -/
theorem callsigns_valid : ∀ a ∈ fleet, validCallsign a.callsign = true := by decide

/-- **No two agents transmit under the same callsign.** -/
theorem callsigns_nodup : (fleet.map Agent.callsign).Nodup := by decide

/-- **UUCP node names fit in eight characters**, as the protocol requires. -/
theorem uucp_names_short : ∀ a ∈ fleet, a.uucp.length ≤ 8 := by decide

/-- **UUCP node names are distinct.** -/
theorem uucp_names_nodup : (fleet.map Agent.uucp).Nodup := by decide

/-! ## Telemetry, and the one agent that has none -/

/-- The OpenTelemetry collector runs in the lab. -/
def otelZone : Zone := .lab

/-- The collector's endpoint. -/
def otelEndpoint : String := "http://[" ++ (zoneAddr .lab 1).toString ++ "]:4317"

/-- Every zone but the air-gapped one reaches the lab. -/
theorem zone_reaches_lab : ∀ z ∈ zones, z ≠ Zone.airgap → reachIn 5 z .lab = true := by decide

/-- **Every agent can reach the collector** — except the one in the air gap. -/
theorem otel_reachable : ∀ a ∈ fleet, a.zone ≠ Zone.airgap → Flows a.zone otelZone := by
  intro a _ hz
  rw [Flows_iff_reach]
  exact zone_reaches_lab a.zone (mem_zones _) hz

/-- The courier is the agent in the air gap. -/
theorem courier_in_airgap : ∀ a ∈ fleet, a.zone = Zone.airgap ↔ a.handle = "courier" := by decide

/-- **The courier is off the network in both directions**: whatever it carries,
it carries by hand. -/
theorem courier_offline (a : Agent) (h : a.zone = Zone.airgap) (z : Zone) (hz : z ≠ Zone.airgap) :
    ¬ Flows a.zone z ∧ ¬ Flows z a.zone := by
  rw [h]
  exact ⟨airgap_isolated_out z hz, airgap_isolated_in z hz⟩

/-! ## What the whole fleet looks like on the ring -/

/-- Every agent sits on a shard, and the crown shard 47 is the warden's. -/
theorem warden_on_crown : ∀ a ∈ fleet, a.shard = crownShard ↔ a.handle = "warden" := by decide

/-- The agents occupy eight of the seventy-one shards. -/
theorem fleet_shards : fleet.map Agent.shard = [3, 11, 47, 23, 41, 17, 59, 31] := rfl

end Foundry
end NixWars
