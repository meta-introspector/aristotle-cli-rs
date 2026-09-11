import RequestProject.Nix.NixWars.Shards

/-!
# Zones: SELinux labels, the IPv6 plan, and what may talk to what

The shard foundry does not run as one process on one machine. It runs as five
*zones*, each an SELinux type, each a /64 of the site's IPv6 ULA prefix, and
each with a fixed set of neighbours it may open a socket to.

* `Zone` is the five: the `public` edge, the `dmz` where the doors are served,
  the `lab` where games are ingested and agents play, the `vault` where the
  sops keys and the ledger live, and the `airgap` shelf, which no network
  reaches at all.
* `allowFlow` is the one-hop policy, and `Flows` is its transitive closure as
  an inductive relation — a genuine "can a packet get there, by any route".
  `reachIn` computes that closure, `reachIn_saturates` shows five rounds are
  enough for five zones, and `Flows_iff_reach` ties the two together, so the
  interesting facts are decidable:
  * `vault_unreachable_from_public` — nothing that starts at the edge reaches
    the vault, however many hops it takes;
  * `airgap_isolated_in` / `airgap_isolated_out` — the air-gapped shelf is
    reachable from nothing and reaches nothing. The only way in is a courier,
    which is what `Foundry/Comms.lean` calls the sneakernet.
* `Ip6` is an address as eight hextets; `zoneAddr` puts host `h` of zone `z`
  at `fd47:...:<zone>::<h>`, and `zoneAddr_inj` says the plan never hands the
  same address to two hosts, while `zoneOf_zoneAddr` says an address always
  announces its own zone — which is what makes the emitted `ip6tables` rules
  a faithful rendering of `allowFlow`.
-/

set_option autoImplicit false

namespace NixWars
namespace Foundry

/-! ## The five zones -/

/-- The five zones of the foundry. -/
inductive Zone where
  /-- The public edge: what the internet can see. -/
  | pub
  /-- The demilitarised zone: the BBS doors, served to players. -/
  | dmz
  /-- The laboratory: ingestion, agents, and the challenge runner. -/
  | lab
  /-- The vault: sops keys, the ledger, the catalogue of record. -/
  | vault
  /-- The air-gapped shelf: reached only by a courier. -/
  | airgap
  deriving DecidableEq, Repr, Inhabited

/-- The five zones, in policy order. -/
def zones : List Zone := [.pub, .dmz, .lab, .vault, .airgap]

/-- Every zone is one of the five. -/
theorem mem_zones (z : Zone) : z ∈ zones := by cases z <;> simp [zones]

/-- The short name of a zone, as it appears in unit names and hostnames. -/
def Zone.name : Zone → String
  | .pub => "public"
  | .dmz => "dmz"
  | .lab => "lab"
  | .vault => "vault"
  | .airgap => "airgap"

/-- The SELinux type of a zone. -/
def Zone.selinuxType (z : Zone) : String := "nixwars_" ++ z.name ++ "_t"

/-- The subnet number of a zone within the site prefix. -/
def Zone.subnet : Zone → Nat
  | .pub => 0x0010
  | .dmz => 0x0020
  | .lab => 0x0030
  | .vault => 0x0040
  | .airgap => 0x0050

/-- Zone names are distinct. -/
theorem zone_names_nodup : (zones.map Zone.name).Nodup := by decide

/-- SELinux types are distinct — no two zones share a label. -/
theorem zone_selinux_nodup : (zones.map Zone.selinuxType).Nodup := by decide

/-- Zone subnets are distinct. -/
theorem zone_subnets_nodup : (zones.map Zone.subnet).Nodup := by decide

/-! ## The policy

One hop of the policy. Read `allowFlow a b = true` as "a socket may be opened
from zone `a` to zone `b`". -/

/-- **The one-hop flow policy.** -/
def allowFlow : Zone → Zone → Bool
  | .pub, .dmz => true
  | .dmz, .lab => true
  | .lab, .dmz => true
  | .vault, .lab => true
  | _, _ => false

/-- The policy as a list of rules, in the order the firewall renders them. -/
def flowRules : List (Zone × Zone) :=
  (zones.flatMap (fun a => zones.map (fun b => (a, b)))).filter (fun p => allowFlow p.1 p.2)

/-- There are four rules. -/
theorem flowRules_length : flowRules.length = 4 := by decide

/-- The rules are exactly the policy. -/
theorem mem_flowRules (a b : Zone) : (a, b) ∈ flowRules ↔ allowFlow a b = true := by
  constructor
  · intro h
    simpa using (List.of_mem_filter h)
  · intro h
    refine List.mem_filter.2 ⟨?_, by simpa using h⟩
    exact List.mem_flatMap.2 ⟨a, mem_zones a, List.mem_map.2 ⟨b, mem_zones b, rfl⟩⟩

/-- Nothing may be opened into the air-gapped shelf, and nothing out of it. -/
theorem allowFlow_airgap (z : Zone) :
    allowFlow .airgap z = false ∧ allowFlow z .airgap = false := by
  cases z <;> exact ⟨rfl, rfl⟩

/-! ## Reachability: the transitive closure of the policy -/

/-- **A packet gets from `a` to `b`** if it can be walked there one allowed hop
at a time. -/
inductive Flows : Zone → Zone → Prop where
  /-- A zone reaches itself. -/
  | refl (a : Zone) : Flows a a
  /-- One allowed hop, then the rest of the route. -/
  | step {a m b : Zone} : allowFlow a m = true → Flows m b → Flows a b

/-- Reachability in at most `n` hops, computed. -/
def reachIn : Nat → Zone → Zone → Bool
  | 0, a, b => a == b
  | n + 1, a, b => (a == b) || zones.any (fun m => allowFlow a m && reachIn n m b)

/-- **Five rounds saturate**: with five zones, a sixth round finds nothing new. -/
theorem reachIn_saturates : ∀ a ∈ zones, ∀ b ∈ zones, reachIn 6 a b = reachIn 5 a b := by decide

/-- One hop in front of a route is still a route, in the computed closure. -/
theorem reachIn_step {a m b : Zone} (h : allowFlow a m = true) (hr : reachIn 5 m b = true) :
    reachIn 5 a b = true := by
  have h6 : reachIn 6 a b = true := by
    show ((a == b) || zones.any (fun x => allowFlow a x && reachIn 5 x b)) = true
    have hany : zones.any (fun x => allowFlow a x && reachIn 5 x b) = true :=
      List.any_eq_true.2 ⟨m, mem_zones m, by rw [h, hr]; rfl⟩
    rw [hany, Bool.or_true]
  rw [← reachIn_saturates a (mem_zones a) b (mem_zones b)]
  exact h6

/-- **The computed closure is the real one.** -/
theorem Flows_iff_reach (a b : Zone) : Flows a b ↔ reachIn 5 a b = true := by
  constructor
  · intro h
    induction h with
    | refl a => simp [reachIn]
    | step hab _ ih => exact reachIn_step hab ih
  · intro h
    -- five hops of the computed relation, unfolded into the inductive one
    have key : ∀ n, ∀ a b : Zone, reachIn n a b = true → Flows a b := by
      intro n
      induction n with
      | zero =>
          intro a b hab
          simp only [reachIn, beq_iff_eq] at hab
          exact hab ▸ Flows.refl a
      | succ n ih =>
          intro a b hab
          simp only [reachIn, Bool.or_eq_true, beq_iff_eq, List.any_eq_true,
            Bool.and_eq_true] at hab
          rcases hab with rfl | ⟨m, _, hm, hr⟩
          · exact Flows.refl a
          · exact Flows.step hm (ih m b hr)
    exact key 5 a b h

/-- **The vault is unreachable from the public edge**, by any route. -/
theorem vault_unreachable_from_public : ¬ Flows .pub .vault := by
  rw [Flows_iff_reach]
  decide

/-- **Nothing reaches the air-gapped shelf.** -/
theorem airgap_isolated_in (z : Zone) (h : z ≠ .airgap) : ¬ Flows z .airgap := by
  rw [Flows_iff_reach]
  revert h
  cases z <;> decide

/-- **The air-gapped shelf reaches nothing.** -/
theorem airgap_isolated_out (z : Zone) (h : z ≠ .airgap) : ¬ Flows .airgap z := by
  rw [Flows_iff_reach]
  revert h
  cases z <;> decide

/-- What the edge can reach: the DMZ and the lab, and nothing else. -/
theorem public_reaches :
    zones.filter (fun z => reachIn 5 .pub z) = [.pub, .dmz, .lab] := by decide

/-! ## The IPv6 plan

The site is a ULA prefix, `fd47:` for the 71 shards and the crown on 47. Each
zone owns a /64 inside it, and a host is the low hextet. -/

/-- An IPv6 address, as eight hextets. -/
structure Ip6 where
  /-- The eight sixteen-bit groups, most significant first. -/
  groups : List Nat
  deriving DecidableEq, Repr, Inhabited

/-- The site prefix: `fd47:5152:1c47::/48` (`fd47` — 47 is the crown shard). -/
def sitePrefix : List Nat := [0xfd47, 0x5152, 0x1c47]

/-- **The address of host `h` in zone `z`.** -/
def zoneAddr (z : Zone) (h : Nat) : Ip6 :=
  ⟨sitePrefix ++ [z.subnet, 0, 0, 0, h % 65536]⟩

/-- Which zone an address belongs to, read back off the wire. -/
def zoneOfAddr (a : Ip6) : Option Zone :=
  zones.find? (fun z => a.groups[3]? == some z.subnet)

/-- **An address announces its own zone.** -/
theorem zoneOf_zoneAddr (z : Zone) (h : Nat) : zoneOfAddr (zoneAddr z h) = some z := by
  cases z <;> rfl

/-- **The plan never hands the same address to two hosts.** -/
theorem zoneAddr_inj {z z' : Zone} {h h' : Nat} (hh : h < 65536) (hh' : h' < 65536)
    (e : zoneAddr z h = zoneAddr z' h') : z = z' ∧ h = h' := by
  have hz : zoneOfAddr (zoneAddr z h) = zoneOfAddr (zoneAddr z' h') := by rw [e]
  rw [zoneOf_zoneAddr, zoneOf_zoneAddr] at hz
  have hzz : z = z' := Option.some.inj hz
  subst hzz
  refine ⟨rfl, ?_⟩
  have : (⟨sitePrefix ++ [z.subnet, 0, 0, 0, h % 65536]⟩ : Ip6).groups
      = (⟨sitePrefix ++ [z.subnet, 0, 0, 0, h' % 65536]⟩ : Ip6).groups := by
    simpa [zoneAddr] using congrArg Ip6.groups e
  have hlast : h % 65536 = h' % 65536 := by
    simpa [sitePrefix] using this
  rwa [Nat.mod_eq_of_lt hh, Nat.mod_eq_of_lt hh'] at hlast

/-- Every address the plan hands out has eight groups. -/
theorem zoneAddr_length (z : Zone) (h : Nat) : (zoneAddr z h).groups.length = 8 := by
  simp [zoneAddr, sitePrefix]

/-- Four hexadecimal digits, no leading-zero suppression. -/
def hex4 (n : Nat) : String :=
  let d := fun (k : Nat) => "0123456789abcdef".toList.getD ((n / 16 ^ k) % 16) '0'
  String.ofList [d 3, d 2, d 1, d 0]

/-- An address, written out. -/
def Ip6.toString (a : Ip6) : String := String.intercalate ":" (a.groups.map hex4)

/-- The /64 of a zone, in CIDR form. -/
def Zone.cidr (z : Zone) : String :=
  String.intercalate ":" ((sitePrefix ++ [z.subnet]).map hex4) ++ "::/64"

end Foundry
end NixWars
