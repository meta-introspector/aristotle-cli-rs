import RequestProject.Nix.NixWars.Tape
import RequestProject.Nix.NixWars.Shards

/-!
# One coordinate system for everything: the shard group, and the catalog

Every game on this board, every recorded tape and every page is, in the end, a
vector of natural numbers. This file gives all of them *one address*, and that
address is a group element.

## The address

`horner` reads a vector of numbers as a single number in base 71 — the Monster's
largest prime, the number of shards the board is cut into. Reading that number
modulo a prime is a coordinate, and `digest m` computes the coordinate without
ever building the big number (`digestMod_eq`).

## The first coordinate system: 71, 59, 47

`Shard = ZMod 71 × ZMod 59 × ZMod 47` is the grid the development already flies
in — `71 × 59 × 47 = 196883` cells, the dimension of the Monster's smallest
faithful representation. `shardMap` sends an address to its three coordinates,
and it is a *ring isomorphism* (`shardMap_bijective`, `shardEquiv`): the three
coordinates are not a lossy hash but a change of basis, so a state and its shard
coordinates carry exactly the same information (`shard_eq_iff`).

## The other coordinates

The Monster has fifteen primes, and each one is another coordinate (`coords`).
Two vectors that agree in all fifteen agree modulo the product of all fifteen
(`coords_determine`), by the same Chinese-remainder argument, one dimension per
prime.

## The catalog

`catalog` files everything the board holds as *content* at a level: level 0 the
recorded tapes, level 1 the doors that play them, level 2 the board, level 3 the
universe that holds the board. A catalog may only hold items of the level below
(`parts_lower`), so containment is well founded (`contains_wf`) and nothing
contains itself (`not_contains_self`) — a universe of universes with no circle
in it. Every item has its own cell of the `71 × 59 × 47` grid
(`catalog_places_nodup`).
-/

set_option maxRecDepth 100000

namespace NixWars
namespace Universe

open Agents

/-! ## The address of a vector of numbers -/

/-- The base of the positional system: the largest Monster prime, the number of
shards. -/
def base : Nat := 71

/-- A vector of numbers read as one number, base 71, least significant first. -/
def horner : List Nat → Nat
  | [] => 0
  | x :: xs => x + base * horner xs

/-- The same number modulo `m`, computed without ever building the big
number. -/
def digest (m : Nat) : List Nat → Nat
  | [] => 0
  | x :: xs => (x + base * digest m xs) % m

/-- The computed coordinate is the coordinate. -/
theorem digestMod_eq (m : Nat) (xs : List Nat) : digest m xs = horner xs % m := by
  induction xs with
  | nil => simp [digest, horner]
  | cons x xs ih =>
      simp only [digest, horner, ih]
      conv_rhs => rw [Nat.add_mod, Nat.mul_mod]
      rw [Nat.add_mod x, Nat.mul_mod base (horner xs % m), Nat.mod_mod]

/-- Appending vectors shifts the second one up by as many digits as the first
one has. -/
theorem horner_append (xs ys : List Nat) :
    horner (xs ++ ys) = horner xs + base ^ xs.length * horner ys := by
  induction xs with
  | nil => simp [horner]
  | cons x xs ih =>
      simp only [List.cons_append, horner, ih, List.length_cons, pow_succ]
      ring

/-! ## The first coordinate system: 71, 59, 47 -/

/-- The grid the board is cut into: `71 × 59 × 47`. -/
abbrev Shard := ZMod 71 × ZMod 59 × ZMod 47

/-- `71 × 59 × 47`: the dimension of the Monster's smallest faithful
representation, and the number of cells of the world the frontier run is flown
in. -/
def dim : Nat := 196883

theorem dim_eq : dim = 71 * (59 * 47) := by norm_num [dim]

/-- The address of a vector: one element of `ZMod 196883`. -/
def addr (xs : List Nat) : ZMod dim := (horner xs : ZMod dim)

/-- Reading an address in the three coordinates: modulo 71, modulo 59 and
modulo 47. -/
def shardMap : ZMod dim →+* Shard :=
  RingHom.prod (ZMod.castHom (by norm_num [dim]) (ZMod 71))
    (RingHom.prod (ZMod.castHom (by norm_num [dim]) (ZMod 59))
      (ZMod.castHom (by norm_num [dim]) (ZMod 47)))

/-- The Chinese remainder theorem, in the shape the board uses it. -/
def crtEquiv : ZMod dim ≃+* Shard :=
  (ZMod.ringEquivCongr dim_eq).trans
    ((ZMod.chineseRemainder (show Nat.Coprime 71 (59 * 47) by norm_num)).trans
      ((RingEquiv.refl (ZMod 71)).prodCongr
        (ZMod.chineseRemainder (show Nat.Coprime 59 47 by norm_num))))

/-- Reduction and the Chinese remainder theorem are the same map: there is only
one ring homomorphism out of `ZMod n`. -/
theorem shardMap_eq_crt : shardMap = (crtEquiv : ZMod dim →+* Shard) :=
  RingHom.ext_zmod _ _

/-- **The three coordinates are a change of basis, not a hash.** -/
theorem shardMap_bijective : Function.Bijective shardMap := by
  rw [shardMap_eq_crt]
  exact crtEquiv.bijective

theorem shardMap_injective : Function.Injective shardMap := shardMap_bijective.1

/-- The place of a vector in the grid. -/
def shard (xs : List Nat) : Shard := shardMap (addr xs)

/-- Two vectors sit in the same cell of the grid exactly when they have the
same address. -/
theorem shard_eq_iff (xs ys : List Nat) : shard xs = shard ys ↔ addr xs = addr ys :=
  ⟨fun h => shardMap_injective h, fun h => by simp [shard, h]⟩

/-- The place, as three numbers — this is what a page prints. -/
def place (xs : List Nat) : Nat × Nat × Nat :=
  (digest 71 xs, digest 59 xs, digest 47 xs)

/-- The printed place is the group element. -/
theorem place_eq_shard (xs : List Nat) :
    shard xs = (((place xs).1 : ZMod 71), ((place xs).2.1 : ZMod 59),
      ((place xs).2.2 : ZMod 47)) := by
  have h : ∀ m : ℕ, ((digest m xs : ℕ) : ZMod m) = ((horner xs : ℕ) : ZMod m) := by
    intro m
    rw [digestMod_eq, ZMod.natCast_mod]
  simp [shard, addr, place, shardMap, h, Prod.ext_iff]

/-! ## The other coordinates: one per Monster prime -/

/-- The coordinates of a vector: its address read modulo each of the fifteen
Monster primes. The last three are the grid above. -/
def coords (xs : List Nat) : List Nat := monsterPrimes.map (fun p => digest p xs)

theorem coords_length (xs : List Nat) : (coords xs).length = 15 := by
  simp [coords, monsterPrimes]

/-- A number coprime to every entry of a list is coprime to their product. -/
theorem coprime_list_prod {p : Nat} :
    ∀ {l : List Nat}, (∀ q ∈ l, Nat.Coprime p q) → Nat.Coprime p l.prod
  | [], _ => by simp [Nat.Coprime]
  | q :: l, h => by
      rw [List.prod_cons]
      exact Nat.Coprime.mul_right (h q (by simp))
        (coprime_list_prod (fun r hr => h r (by simp [hr])))

/-- Agreeing modulo every modulus of a pairwise-coprime list is agreeing modulo
their product. -/
theorem modEq_prod_of_forall :
    ∀ {l : List Nat}, l.Pairwise Nat.Coprime → ∀ {a b : Nat},
      (∀ p ∈ l, a ≡ b [MOD p]) → a ≡ b [MOD l.prod]
  | [], _, _, _, _ => by simp [Nat.ModEq, Nat.mod_one]
  | p :: l, hp, a, b, h => by
      have hcop : Nat.Coprime p l.prod :=
        coprime_list_prod (fun q hq => (List.pairwise_cons.1 hp).1 q hq)
      have h1 : a ≡ b [MOD p] := h p (by simp)
      have h2 : a ≡ b [MOD l.prod] :=
        modEq_prod_of_forall (List.pairwise_cons.1 hp).2 (fun q hq => h q (by simp [hq]))
      simpa [List.prod_cons] using (Nat.modEq_and_modEq_iff_modEq_mul hcop).1 ⟨h1, h2⟩

/-- The fifteen Monster primes are pairwise coprime. -/
theorem monsterPrimes_pairwise_coprime : monsterPrimes.Pairwise Nat.Coprime := by
  refine List.Pairwise.imp_of_mem ?_ monsterPrimes_nodup
  intro a b ha hb hab
  exact (Nat.coprime_primes (monsterPrimes_prime a ha) (monsterPrimes_prime b hb)).2 hab

/-- **Fifteen coordinates pin a state down.** Two vectors whose addresses agree
modulo every Monster prime agree modulo the product of all fifteen. -/
theorem coords_determine {xs ys : List Nat} (h : coords xs = coords ys) :
    horner xs ≡ horner ys [MOD monsterPrimes.prod] := by
  refine modEq_prod_of_forall monsterPrimes_pairwise_coprime ?_
  intro p hp
  obtain ⟨i, hi⟩ := List.mem_iff_getElem?.1 hp
  have hx : (coords xs)[i]? = some (digest p xs) := by
    simp only [coords, List.getElem?_map, hi, Option.map_some]
  have hy : (coords ys)[i]? = some (digest p ys) := by
    simp only [coords, List.getElem?_map, hi, Option.map_some]
  have hxy : digest p xs = digest p ys := by
    have : (coords xs)[i]? = (coords ys)[i]? := by rw [h]
    rw [hx, hy] at this
    exact Option.some.inj this
  simpa [Nat.ModEq, digestMod_eq] using hxy

/-! ## The catalog: everything the board holds, as content -/

/-- One item of the universe catalog. -/
structure Item where
  /-- Its level: 0 content, 1 a door, 2 the board, 3 the universe. -/
  level : Nat
  /-- Its name in the catalog. -/
  name : String
  /-- Its content, as a vector of numbers. -/
  body : List Nat
  /-- The names of the items it holds; they are all one level below. -/
  parts : List String
  deriving Repr, DecidableEq, Inhabited

/-- Level 0: the recorded lesson of a door, as the numbers of its tape. -/
def tapeItem (c : Card) : Item :=
  ⟨0, "tape/" ++ c.door, ((Tape.lesson c).map Tape.toNats).getD [c.doorNo], []⟩

/-- Level 1: a door, its number and starting vector, holding its tape. -/
def doorItem (c : Card) : Item :=
  ⟨1, "door/" ++ c.door, c.doorNo :: c.start, ["tape/" ++ c.door]⟩

/-- Level 2: the board, holding the fifteen doors. -/
def boardItem : Item :=
  ⟨2, "board", [Wasm.boardIR.length], agentCards.map (fun c => "door/" ++ c.door)⟩

/-- Level 3: the universe, holding the board. -/
def universeItem : Item := ⟨3, "universe", [dim], ["board"]⟩

/-- **The catalog.** -/
def catalog : List Item :=
  agentCards.map tapeItem ++ agentCards.map doorItem ++ [boardItem, universeItem]

theorem catalog_length : catalog.length = 32 := by rfl

/-- Every item has a distinct name. -/
theorem catalog_names_nodup : (catalog.map Item.name).Nodup := by decide

/-- Whether the catalog holds an item of a given name at a given level. -/
def holds (n : String) (lvl : Nat) : Bool :=
  catalog.any (fun j => j.name == n && j.level == lvl)

/-- **A catalog only holds the level below it.** -/
theorem parts_lower :
    catalog.all (fun i => i.parts.all (fun n =>
      i.level != 0 && holds n (i.level - 1))) = true := by decide

/-- One item of the catalog is part of another: the first is held by the
second, one level up. -/
def PartOf (i j : Item) : Prop :=
  i ∈ catalog ∧ j ∈ catalog ∧ i.name ∈ j.parts ∧ i.level + 1 = j.level

/-- What a catalog holds is of a lower level than the catalog. -/
theorem partOf_level {i j : Item} (h : PartOf i j) : i.level < j.level := by
  obtain ⟨-, -, -, hl⟩ := h
  omega

/-- Containment is well founded: there is no infinite descent, and in
particular no cycle. -/
theorem contains_wf : WellFounded PartOf :=
  Subrelation.wf (fun {_ _} h => partOf_level h) (measure Item.level).wf

/-- **Nothing contains itself** — a universe of universes with no circle in
it. -/
theorem not_contains_self (i : Item) : ¬ PartOf i i := fun h =>
  absurd (partOf_level h) (lt_irrefl _)

/-- Every item's place in the `71 × 59 × 47` grid. -/
def catalogPlaces : List (Nat × Nat × Nat) := catalog.map (fun i => place i.body)

/-- **Everything has its own cell.** No two items of the catalog share a place
in the grid. -/
theorem catalog_places_nodup : catalogPlaces.Nodup := by decide

/-- The doors of the catalog are exactly the doors of the board. -/
theorem catalog_doors :
    (catalog.filter (fun i => i.level == 1)).map Item.name =
      Wasm.boardIR.map (fun d => "door/" ++ d.name) := by rfl

end Universe
end NixWars
