import Mathlib

open scoped BigOperators

/-!
# Gödel Brainrot Stealer — a formalized game

This file gives a *machine-verified* Lean 4 model of the "Gödel Brainrot Stealer"
Roblox concept: brainrot phrases are encoded as Gödel numbers (products of prime
powers), players steal each other's encoded brainrot, the Cambridge logicians lock
it all in a vault, and finally everyone fights in the Colosseum — both the historical
mathematicians and the modern ML architectures.

Everything below actually compiles and every `theorem` is fully proved (no `sorry`).
The headline result is `vault_always_incomplete`: a Gödel-flavoured incompleteness
statement saying that **no finite vault can contain all brainrot**.
-/

namespace GodelBrainrot

/-- A brainrot statement is a list of "meme tokens". -/
structure Brainrot where
  tokens : List String
deriving Repr, DecidableEq

/-- A short prime table; we fall back to `2` past the end of the table, which is
fine for the game (the encoding stays well-defined and total). -/
def primes : List Nat := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]

/-- Gödel numbering: the product of `prime i ^ (length of i-th token)`. -/
def encodeBrainrot (b : Brainrot) : Nat :=
  (b.tokens.zipIdx).foldl (init := 1)
    fun acc p => acc * (primes.getD p.2 2) ^ p.1.length

/-- A brainrot made of a single token of `n` copies of `'a'`. Its code is `2 ^ n`. -/
def aaaBrainrot (n : Nat) : Brainrot := ⟨[String.ofList (List.replicate n 'a')]⟩

/-
The code of `aaaBrainrot n` is exactly `2 ^ n`.
-/
theorem encode_aaaBrainrot (n : Nat) : encodeBrainrot (aaaBrainrot n) = 2 ^ n := by
  unfold encodeBrainrot;
  -- Let's simplify the expression for the fold.
  simp [aaaBrainrot, primes]

/-
Brainrot codes are unbounded: for every `N` there is a brainrot with a bigger code.
-/
theorem encode_unbounded (N : Nat) : ∃ b : Brainrot, N < encodeBrainrot b := by
  -- By definition of `encodeBrainrot`, there exists a brainrot `b` such that `encodeBrainrot b > N`.
  have h_unbounded : ∃ n, N < 2^n := by
    exact pow_unbounded_of_one_lt _ one_lt_two;
  exact ⟨ _, h_unbounded.choose_spec.trans_eq ( encode_aaaBrainrot _ |> Eq.symm ) ⟩

/-! ## Stealing -/

/-- A player owns a `name`, a `vault` of encoded brainrot numbers, and some `aura`. -/
structure Player where
  name : String
  vault : List Nat
  aura : Nat
deriving Repr

/-- Steal a target encoded brainrot from a victim, if they own it: the attacker gains
the number and +100 aura, the victim loses the number and half their aura. -/
def steal (attacker victim : Player) (target : Nat) : Player × Player :=
  if target ∈ victim.vault then
    ({ attacker with vault := target :: attacker.vault, aura := attacker.aura + 100 },
     { victim with vault := victim.vault.erase target, aura := victim.aura / 2 })
  else (attacker, victim)

/-
A successful steal really does transfer the brainrot to the attacker.
-/
theorem steal_gains (attacker victim : Player) (target : Nat)
    (h : target ∈ victim.vault) :
    target ∈ (steal attacker victim target).1.vault
      ∧ (steal attacker victim target).1.aura = attacker.aura + 100 := by
  unfold steal; aesop;

/-
A successful steal removes the brainrot from the victim (no duplicates in vault).
-/
theorem steal_removes (attacker victim : Player) (target : Nat)
    (h : target ∈ victim.vault) (hnodup : victim.vault.Nodup) :
    target ∉ (steal attacker victim target).2.vault := by
  grind +locals

/-! ## The Cambridge vault and Gödel incompleteness -/

/-- The Cambridge vault: owners, imprisoned brainrot, and its sealed master code. -/
structure CambridgeVault where
  owners : List String
  prisoners : List Brainrot
  sealedNumber : Nat
deriving Repr

/-
**Incompleteness, brainrot edition.** No finite vault can imprison all brainrot:
there is always a brainrot whose code escapes the vault's prisoners. This is a real,
fully-proved statement (proved via `encode_unbounded`), in the spirit of Gödel's
first incompleteness theorem.
-/
theorem vault_always_incomplete (v : CambridgeVault) :
    ∃ b : Brainrot, encodeBrainrot b ∉ v.prisoners.map encodeBrainrot := by
  obtain ⟨N, hN⟩ : ∃ N : Nat, ∀ b ∈ v.prisoners, encodeBrainrot b ≤ N := by
    exact ⟨ Finset.sup ( v.prisoners.toFinset ) fun b => encodeBrainrot b, fun b hb => Finset.le_sup ( f := fun b => encodeBrainrot b ) ( by aesop ) ⟩;
  rcases encode_unbounded N with ⟨ b, hb ⟩ ; exact ⟨ b, fun h => by obtain ⟨ c, hc, hc' ⟩ := List.mem_map.mp h; linarith [ hN c hc ] ⟩

/-- Gödel's slap on the vault: he becomes an owner and frees Ramanujan. -/
def godelSlap (v : CambridgeVault) : CambridgeVault :=
  { v with
    owners := v.owners ++ ["Gödel"],
    prisoners := v.prisoners.filter (· ≠ ⟨["ramanujan"]⟩),
    sealedNumber := encodeBrainrot ⟨["this", "vault", "is", "incomplete"]⟩ }

/-
After Gödel's slap, Ramanujan is no longer a prisoner.
-/
theorem ramanujan_freed (v : CambridgeVault) :
    (⟨["ramanujan"]⟩ : Brainrot) ∉ (godelSlap v).prisoners := by
  unfold godelSlap; aesop;

/-! ## The Colosseum -/

/-- A gladiator: math legend or ML architecture, carrying a hoard of brainrot. -/
structure Gladiator where
  name : String
  brainrot : List Brainrot
  aura : Nat
deriving Repr

/-- A gladiator's raw power is the total of all their brainrot codes. -/
def power (g : Gladiator) : Nat := (g.brainrot.map encodeBrainrot).sum

/-- A fight: the higher total brainrot code wins (ties go to the first fighter). -/
def fight (g1 g2 : Gladiator) : Gladiator :=
  if power g2 > power g1 then g2 else g1

/-
The winner of a fight always has at least as much power as either fighter.
-/
theorem fight_winner_strongest (g1 g2 : Gladiator) :
    power g1 ≤ power (fight g1 g2) ∧ power g2 ≤ power (fight g1 g2) := by
  unfold fight;
  grind

/-
The winner is always one of the two fighters.
-/
theorem fight_is_a_fighter (g1 g2 : Gladiator) :
    fight g1 g2 = g1 ∨ fight g1 g2 = g2 := by
  unfold fight; split_ifs <;> tauto;

/-! ### ML architecture gladiators -/

/-- The modern ML fighters now headlining the Colosseum. -/
inductive Arch
  | Torch | ONNX | JAX | GGUF | TensorRT | CoreML | TFLite | Triton
deriving Repr, DecidableEq

/-- An ML gladiator with a quantization level (lower preserves more brainrot),
inference speed, and brainrot power. -/
structure MLGladiator where
  name : Arch
  quant_level : Nat
  inference_speed : Nat
  brainrot_power : Nat
deriving Repr

/-- Gödel slaps every model: incompleteness halves its brainrot power. -/
def godelSlapArch (g : MLGladiator) : MLGladiator :=
  { g with brainrot_power := g.brainrot_power / 2 }

/-
Gödel's slap never increases a model's power (incompleteness is a debuff).
-/
theorem godelSlapArch_le (g : MLGladiator) :
    (godelSlapArch g).brainrot_power ≤ g.brainrot_power := by
  exact Nat.div_le_self _ _

/-
**Gödel always slaps.** There is always an arena in which a gladiator named
"Gödel" reigns with aura above 200.
-/
theorem godel_always_slaps :
    ∃ (arena : List Gladiator) (winner : Gladiator),
      winner ∈ arena ∧ winner.name = "Gödel" ∧ winner.aura > 200 := by
  exists [ ⟨ "Gödel", [ ], 201 ⟩ ]

end GodelBrainrot