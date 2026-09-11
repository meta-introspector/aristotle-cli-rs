import RequestProject.Nix.NixWars.Shards

/-!
# The FRENS roster: the players found on the branches and the pull requests

The upstream repository `meta-introspector/shards` carries its players in a
`FRENS.md` registry and a `frens/*.json` directory. Reading every branch
(`main`, `nydiokar/main`, `jmikedupont2-patch-1`) and every pull request
(#1 "Add FREN nydiokar", #3, #5) turns up four handles:

| handle         | chain    | where it was found                              | reward |
| -------------- | -------- | ----------------------------------------------- | ------ |
| `jmikedupont2` | github   | branch `main`, author of every commit           | 3×     |
| `nathan`       | ethereum | `FRENS.md` on `main`                            | 2×     |
| `nydiokar`     | solana   | PR #1, `frens/nydiokar_GWryBrYo.json`           | 2×     |
| `kanebra`      | solana   | PR #1, `frens/kanebra_26qVRWZg.json`            | 2×     |

This file is the roster as data, with the invariants a player list has to
satisfy before the board will seat it: handles are distinct, everybody stands
on a real shard of the 71-shard DMZ, and every reward multiplier is positive.

Two things about placement are worth being precise about, because the upstream
data and the code do not agree by accident:

* `frens/nydiokar_moonshine.json` *declares* shard 47 for `nydiokar`, with the
  comment `hash(nydiokar) mod 71 = 47`. The hash it used is not recorded
  anywhere in the repository, and none of the usual string hashes reproduces
  it, so the declared shard is carried as a field of the roster rather than
  derived. `nydiokar_on_crown` records that this declared shard is exactly the
  crown shard the game already knew about.
* the players with no declared shard are placed by `frenHash` (FNV-1a, 32-bit)
  reduced modulo 71, and `roster_placement_by_hash` checks each of those three
  placements against the hash.

Finally the "TRUE_FREN tower" of PR #1 is proved rather than asserted. That
note claims `47^71 ≡ 47 (mod 71)` and that the whole tower
`47^(71^(71^…))` collapses to 47. Both are instances of one fact about a
prime shard count: `frenTower_fixed` says every residue is fixed by raising to
the `71^k`, for every height `k`.
-/

namespace NixWars

/-- A player of NixWars, as recorded in the upstream FRENS registry. -/
structure Fren where
  /-- The handle the player is known by. -/
  handle : String
  /-- The chain the player's address lives on (`github` for a plain committer). -/
  chain : String
  /-- The shard of the DMZ the player sits on. -/
  shard : Nat
  /-- The Metameme Coin reward multiplier: 3 for a core contributor, 2 for an
  early adopter. -/
  multiplier : Nat
  /-- Where in the repository the player was found. -/
  source : String
  deriving DecidableEq, Repr, Inhabited

/-- FNV-1a over the bytes of a handle, 32-bit. Used to place a player who did
not bring a declared shard with them. -/
def frenHash (s : String) : Nat :=
  s.toList.foldl (fun h c => ((h ^^^ c.toNat) * 16777619) % 4294967296) 2166136261

/-- Where the hash puts a handle. -/
def frenPlacement (s : String) : Nat := shardOf (frenHash s)

theorem frenPlacement_lt (s : String) : frenPlacement s < numShards :=
  shardOf_lt _

/-! ## The roster -/

/-- **Every player found on the branches and pull requests of the upstream
repository.** -/
def roster : List Fren :=
  [ { handle := "jmikedupont2", chain := "github", shard := 62, multiplier := 3,
      source := "branch main" },
    { handle := "nathan", chain := "ethereum", shard := 36, multiplier := 2,
      source := "FRENS.md" },
    { handle := "nydiokar", chain := "solana", shard := 47, multiplier := 2,
      source := "PR #1, frens/nydiokar_GWryBrYo.json" },
    { handle := "kanebra", chain := "solana", shard := 18, multiplier := 2,
      source := "PR #1, frens/kanebra_26qVRWZg.json" } ]

/-- The roster has four players. -/
theorem roster_length : roster.length = 4 := rfl

/-- No handle appears twice: nobody can be seated in the lobby twice. -/
theorem roster_handles_nodup : (roster.map Fren.handle).Nodup := by decide

/-- Every player stands on a real shard of the DMZ. -/
theorem roster_shards_lt : ∀ f ∈ roster, f.shard < numShards := by decide

/-- No two players share a shard, so the lobby seats them on distinct shards. -/
theorem roster_shards_nodup : (roster.map Fren.shard).Nodup := by decide

/-- Everybody earns something: no reward multiplier is zero. -/
theorem roster_multiplier_pos : ∀ f ∈ roster, 0 < f.multiplier := by decide

/-- The multipliers are the two the registry defines: 3 for a core
contributor, 2 for an early adopter. -/
theorem roster_multiplier_mem : ∀ f ∈ roster, f.multiplier = 2 ∨ f.multiplier = 3 := by decide

/-- The three players with no declared shard are placed by the hash. -/
theorem roster_placement_by_hash :
    frenPlacement "jmikedupont2" = 62 ∧
    frenPlacement "nathan" = 36 ∧
    frenPlacement "kanebra" = 18 := by
  refine ⟨?_, ?_, ?_⟩ <;> rfl

/-- `nydiokar` brought a declared shard, and it is the crown shard: the one
shard of the 71 where the Monster Crown can be unlocked. -/
theorem nydiokar_on_crown :
    ∀ f ∈ roster, f.handle = "nydiokar" → f.shard = crownShard := by decide

/-- Only one player sits on the crown shard. -/
theorem crown_seat_unique :
    (roster.filter (fun f => f.shard = crownShard)).map Fren.handle = ["nydiokar"] := by decide

/-! ## The TRUE_FREN tower

PR #1 claims that shard 47 is a fixed point of the Monster tower
`47^(71^(71^…))`. It is, and so is every other residue: raising to the
`71`-th power is the identity on `ZMod 71`, so raising to the `71^k`-th power
is too, at every height of the tower. -/

/-- **The tower is the identity.** For every residue mod 71 and every tower
height `k`, `a ^ (71 ^ k) = a`. -/
theorem frenTower_fixed (a : ZMod numShards) : ∀ k : Nat, a ^ (numShards ^ k) = a := by
  haveI : Fact (Nat.Prime numShards) := ⟨numShards_prime⟩
  intro k
  induction k with
  | zero => simp
  | succ k ih =>
      calc a ^ (numShards ^ (k + 1)) = (a ^ (numShards ^ k)) ^ numShards := by
              rw [← pow_mul, pow_succ]
        _ = a ^ (numShards ^ k) := ZMod.pow_card _
        _ = a := ih

/-- The claim of PR #1 as it is written there, over the naturals: the crown
shard is fixed by the tower at every height. -/
theorem crown_tower_fixed (k : Nat) : crownShard ^ (numShards ^ k) % numShards = crownShard := by
  have h : ((crownShard : ZMod numShards)) ^ (numShards ^ k) = (crownShard : ZMod numShards) :=
    frenTower_fixed _ k
  have h' : ((crownShard ^ (numShards ^ k) : Nat) : ZMod numShards)
      = ((crownShard : Nat) : ZMod numShards) := by push_cast; exact h
  have := (ZMod.natCast_eq_natCast_iff' _ _ _).1 h'
  simpa [crownShard, numShards] using this

/-- The first rung of that tower, `47 ^ 71 ≡ 47 (mod 71)`, is the case
`k = 1`. -/
theorem crown_pow_numShards : 47 ^ 71 % 71 = 47 := crown_tower_fixed 1

end NixWars
