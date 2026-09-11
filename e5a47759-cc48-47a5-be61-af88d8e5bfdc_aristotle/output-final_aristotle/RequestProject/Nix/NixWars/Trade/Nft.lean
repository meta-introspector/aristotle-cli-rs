import RequestProject.Nix.NixWars.Trade.Ships
import RequestProject.Nix.NixWars.Ledger

/-!
# The shipyard's registry: ships as tokens that can be bought, sold and traded

A custom build is worth something, so it is worth *owning*.  This file is the
registry: every ship a player commissions is minted as a token with a serial
number of its own, and tokens can be listed for sale, bought with credits,
gifted and swapped between players.

The registry is a plain piece of arithmetic, and the guarantees a player would
want out of a token are theorems about it:

* **Tokens are unique and are never lost.**  Serial numbers are handed out in
  order, so no two tokens share one (`mint_ids_nodup`), and every operation
  that is not a mint leaves the list of serials exactly as it found it
  (`buy_ids`, `swap_ids`, `list_ids`, `gift_ids`) — nothing is duplicated,
  nothing is destroyed, nothing is conjured.
* **A ship has exactly one owner**, and only a sale, a gift or a swap moves it
  (`buy_transfers`, `gift_transfers`, `swap_swaps`, `list_keeps_owner`).
* **Money is conserved.**  A sale moves the asking price from the buyer to the
  seller and no credits are created or destroyed (`buy_credits_conserved`,
  `buy_pays_seller`); a sale that cannot be paid for does not happen at all
  (`buy_refused_without_funds`), and neither does one nobody offered
  (`buy_refused_unlisted`).
* **A swap is atomic and reversible**: both ships change hands or neither does,
  and swapping twice is doing nothing (`swap_involutive`).
* **A token names a build.**  Its fingerprint is a hash of the build's own
  number, so two tokens of the same ship carry the same fingerprint
  (`fingerprint_congr`) and the six ships on the shelf carry six different
  ones (`stock_fingerprints_distinct`).
* Only legal builds can be minted (`mint_specs_ok`).
-/

set_option maxRecDepth 100000

namespace NixWars
namespace Trade

/-- How many players the registry has room for. -/
def numPlayers : Nat := 4

/-- A token: a serial number, the build it names, who owns it, and what they
are asking for it (zero when it is not for sale). -/
structure Token where
  /-- The serial number: unique, and never reissued. -/
  id : Nat
  /-- The build the token names. -/
  spec : ShipSpec
  /-- The player who owns it. -/
  owner : Nat
  /-- The asking price, or zero when it is not for sale. -/
  ask : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The registry: the tokens, the next serial number to hand out, and every
player's credits. -/
structure Yard where
  /-- Every token minted so far. -/
  tokens : List Token
  /-- The next serial number. -/
  next : Nat
  /-- One balance per player. -/
  balances : List Nat
  deriving DecidableEq, Repr, Inhabited

/-- An empty registry: no ships, everybody with a thousand credits. -/
def emptyYard : Yard :=
  { tokens := [], next := 1, balances := List.replicate numPlayers 1000 }

/-- A well-formed registry. -/
def YardOk (y : Yard) : Prop :=
  (y.tokens.map Token.id).Nodup ∧ (∀ t ∈ y.tokens, t.id < y.next) ∧
    (∀ t ∈ y.tokens, ShipOk t.spec) ∧ (∀ t ∈ y.tokens, t.owner < numPlayers) ∧
    y.balances.length = numPlayers

instance : DecidablePred YardOk := fun y => by unfold YardOk; infer_instance

theorem emptyYard_ok : YardOk emptyYard := by decide

/-- The token with a given serial, if it exists. -/
def tokenOf (y : Yard) (id : Nat) : Option Token := y.tokens.find? (fun t => t.id = id)

/-- Change one token, leaving every other alone. -/
def updateToken (y : Yard) (id : Nat) (f : Token → Token) : Yard :=
  { y with tokens := y.tokens.map (fun t => if t.id = id then f t else t) }

/-- Changing a token never changes which serials exist. -/
theorem updateToken_ids (y : Yard) (id : Nat) (f : Token → Token)
    (hf : ∀ t, (f t).id = t.id) :
    ((updateToken y id f).tokens.map Token.id) = y.tokens.map Token.id := by
  simp only [updateToken, List.map_map]
  apply List.map_congr_left
  intro t _
  simp only [Function.comp_apply]
  split_ifs with h
  · exact hf t
  · rfl

/-! ## Minting -/

/-- Commission a ship: mint a token for a legal build, with the next serial. -/
def mint (y : Yard) (owner : Nat) (spec : ShipSpec) : Yard :=
  if ShipOk spec ∧ owner < numPlayers then
    { y with tokens := y.tokens ++ [{ id := y.next, spec := spec, owner := owner, ask := 0 }],
             next := y.next + 1 }
  else y

/-- **Minting keeps the registry well formed** — in particular serials stay
distinct, because the new one is larger than every serial already issued. -/
theorem mint_ok {y : Yard} (h : YardOk y) (owner : Nat) (spec : ShipSpec) :
    YardOk (mint y owner spec) := by
  obtain ⟨hnd, hlt, hspec, hown, hbal⟩ := h
  unfold mint
  split_ifs with hc
  · refine ⟨?_, ?_, ?_, ?_, hbal⟩
    · simp only [List.map_append, List.map_cons, List.map_nil]
      refine List.Nodup.append hnd (by simp) ?_
      intro a ha hb
      simp only [List.mem_singleton] at hb
      simp only [List.mem_map] at ha
      obtain ⟨t, ht, rfl⟩ := ha
      exact absurd hb (Nat.ne_of_lt (hlt t ht))
    · intro t ht
      simp only [List.mem_append, List.mem_singleton] at ht
      rcases ht with ht | rfl
      · exact Nat.lt_succ_of_lt (hlt t ht)
      · exact Nat.lt_succ_self _
    · intro t ht
      simp only [List.mem_append, List.mem_singleton] at ht
      rcases ht with ht | rfl
      · exact hspec t ht
      · exact hc.1
    · intro t ht
      simp only [List.mem_append, List.mem_singleton] at ht
      rcases ht with ht | rfl
      · exact hown t ht
      · exact hc.2
  · exact ⟨hnd, hlt, hspec, hown, hbal⟩

/-- **No two tokens share a serial.** -/
theorem mint_ids_nodup {y : Yard} (h : YardOk y) (owner : Nat) (spec : ShipSpec) :
    ((mint y owner spec).tokens.map Token.id).Nodup := (mint_ok h owner spec).1

/-- **Only legal builds are ever minted.** -/
theorem mint_specs_ok {y : Yard} (h : YardOk y) (owner : Nat) (spec : ShipSpec) :
    ∀ t ∈ (mint y owner spec).tokens, ShipOk t.spec := (mint_ok h owner spec).2.2.1

/-- A mint adds exactly one token. -/
theorem mint_length {y : Yard} (owner : Nat) (spec : ShipSpec)
    (hc : ShipOk spec ∧ owner < numPlayers) :
    (mint y owner spec).tokens.length = y.tokens.length + 1 := by
  simp [mint, hc]

/-! ## Listing, selling and swapping -/

/-- Put a ship up for sale at a price. -/
def listToken (y : Yard) (id who ask : Nat) : Yard :=
  match tokenOf y id with
  | none => y
  | some t => if t.owner = who then updateToken y id (fun t => { t with ask := ask }) else y

/-- Take it off the market. -/
def delistToken (y : Yard) (id who : Nat) : Yard := listToken y id who 0

/-- Buy a listed ship: the asking price moves from the buyer to the seller, the
ship moves the other way, and it comes off the market. -/
def buyToken (y : Yard) (id buyer : Nat) : Yard :=
  match tokenOf y id with
  | none => y
  | some t =>
      if 1 ≤ t.ask ∧ buyer < numPlayers ∧ t.owner ≠ buyer ∧ t.ask ≤ stockOf y.balances buyer then
        { updateToken y id (fun t => { t with owner := buyer, ask := 0 }) with
          balances := addStock (subStock y.balances buyer t.ask) t.owner t.ask }
      else y

/-- Give a ship away. -/
def giftToken (y : Yard) (id who dest : Nat) : Yard :=
  match tokenOf y id with
  | none => y
  | some t =>
      if t.owner = who ∧ dest < numPlayers then
        updateToken y id (fun t => { t with owner := dest, ask := 0 })
      else y

/-- Swap two ships between their owners: both change hands or neither does. -/
def swapTokens (y : Yard) (id₁ id₂ : Nat) : Yard :=
  match tokenOf y id₁, tokenOf y id₂ with
  | some t₁, some t₂ =>
      if id₁ ≠ id₂ then
        { y with tokens := y.tokens.map (fun t =>
            if t.id = id₁ then { t with owner := t₂.owner, ask := 0 }
            else if t.id = id₂ then { t with owner := t₁.owner, ask := 0 }
            else t) }
      else y
  | _, _ => y

/-- **Listing moves no ship.** -/
theorem list_ids (y : Yard) (id who ask : Nat) :
    (listToken y id who ask).tokens.map Token.id = y.tokens.map Token.id := by
  unfold listToken
  cases tokenOf y id with
  | none => rfl
  | some t =>
      simp only []
      split_ifs
      · exact updateToken_ids y id _ (fun _ => rfl)
      · rfl

/-- Listing does not change who owns the ship. -/
theorem list_keeps_owner (y : Yard) (id who ask : Nat) :
    (listToken y id who ask).tokens.map Token.owner = y.tokens.map Token.owner := by
  unfold listToken
  cases tokenOf y id with
  | none => rfl
  | some t =>
      simp only []
      split_ifs
      · simp only [updateToken, List.map_map]
        apply List.map_congr_left
        intro u _
        simp only [Function.comp_apply]
        split_ifs <;> rfl
      · rfl

/-- **A sale creates and destroys no tokens.** -/
theorem buy_ids (y : Yard) (id buyer : Nat) :
    (buyToken y id buyer).tokens.map Token.id = y.tokens.map Token.id := by
  unfold buyToken
  cases tokenOf y id with
  | none => rfl
  | some t =>
      simp only []
      split_ifs
      · exact updateToken_ids y id _ (fun _ => rfl)
      · rfl

/-- **A gift creates and destroys no tokens.** -/
theorem gift_ids (y : Yard) (id who dest : Nat) :
    (giftToken y id who dest).tokens.map Token.id = y.tokens.map Token.id := by
  unfold giftToken
  cases tokenOf y id with
  | none => rfl
  | some t =>
      simp only []
      split_ifs
      · exact updateToken_ids y id _ (fun _ => rfl)
      · rfl

/-- **A swap creates and destroys no tokens.** -/
theorem swap_ids (y : Yard) (id₁ id₂ : Nat) :
    (swapTokens y id₁ id₂).tokens.map Token.id = y.tokens.map Token.id := by
  unfold swapTokens
  cases tokenOf y id₁ with
  | none => rfl
  | some t₁ =>
      cases tokenOf y id₂ with
      | none => rfl
      | some t₂ =>
          simp only []
          split_ifs
          · simp only [List.map_map]
            apply List.map_congr_left
            intro u _
            simp only [Function.comp_apply]
            split_ifs <;> rfl
          · rfl

/-- Finding a token by serial finds a token with that serial. -/
theorem tokenOf_id {y : Yard} {id : Nat} {t : Token} (h : tokenOf y id = some t) : t.id = id := by
  have := List.find?_eq_some_iff_getElem.mp h
  simpa using this.1

/-- **A sale hands the ship to the buyer.** -/
theorem buy_transfers {y : Yard} {id buyer : Nat} {t : Token} (ht : tokenOf y id = some t)
    (hc : 1 ≤ t.ask ∧ buyer < numPlayers ∧ t.owner ≠ buyer ∧ t.ask ≤ stockOf y.balances buyer) :
    ∀ u ∈ (buyToken y id buyer).tokens, u.id = id → u.owner = buyer ∧ u.ask = 0 := by
  intro u hu hid
  simp only [buyToken, ht, if_pos hc, updateToken, List.mem_map] at hu
  obtain ⟨v, hv, rfl⟩ := hu
  by_cases hvid : v.id = id
  · rw [if_pos hvid]
    exact ⟨rfl, rfl⟩
  · rw [if_neg hvid] at hid
    exact absurd hid hvid

/-- Adding to one shelf adds to the total. -/
theorem sum_addStock_all : ∀ (st : List Nat) (g n : Nat), g < st.length →
    (addStock st g n).sum = st.sum + n := by
  intro st
  induction st with
  | nil => intro g n h; simp at h
  | cons a t ih =>
      intro g n h
      cases g with
      | zero =>
          simp only [addStock, stockOf, List.getD_cons_zero, List.set_cons_zero, List.sum_cons]
          omega
      | succ m =>
          have hm : m < t.length := by simpa using h
          have := ih m n hm
          simp only [addStock, stockOf, List.getD_cons_succ, List.set_cons_succ, List.sum_cons]
          simp only [addStock, stockOf] at this
          omega

/-- Taking off one shelf takes off the total. -/
theorem sum_subStock_all : ∀ (st : List Nat) (g n : Nat), g < st.length → n ≤ stockOf st g →
    (subStock st g n).sum + n = st.sum := by
  intro st
  induction st with
  | nil => intro g n h _; simp at h
  | cons a t ih =>
      intro g n h hn
      cases g with
      | zero =>
          simp only [subStock, stockOf, List.getD_cons_zero, List.set_cons_zero,
            List.sum_cons] at *
          omega
      | succ m =>
          have hm : m < t.length := by simpa using h
          have hn' : n ≤ stockOf t m := by simpa [stockOf] using hn
          have := ih m n hm hn'
          simp only [subStock, stockOf, List.getD_cons_succ, List.set_cons_succ, List.sum_cons]
          simp only [subStock, stockOf] at this
          omega

/-- **A sale moves the price and no more**: the buyer pays exactly the asking
price, the seller receives exactly it, and the total number of credits in the
registry is unchanged. -/
theorem buy_credits_conserved {y : Yard} {id buyer : Nat} {t : Token}
    (ht : tokenOf y id = some t)
    (hc : 1 ≤ t.ask ∧ buyer < numPlayers ∧ t.owner ≠ buyer ∧ t.ask ≤ stockOf y.balances buyer)
    (hown : t.owner < numPlayers) (hbal : y.balances.length = numPlayers) :
    (buyToken y id buyer).balances.sum = y.balances.sum := by
  have hb := hc.2.1
  have hfunds := hc.2.2.2
  simp only [buyToken, ht, if_pos hc]
  show (addStock (subStock y.balances buyer t.ask) t.owner t.ask).sum = y.balances.sum
  have hlenb : buyer < y.balances.length := by omega
  have hleno : t.owner < (subStock y.balances buyer t.ask).length := by
    rw [subStock_length]; omega
  have hsub := sum_subStock_all y.balances buyer t.ask hlenb hfunds
  have hadd := sum_addStock_all (subStock y.balances buyer t.ask) t.owner t.ask hleno
  omega

/-- **The seller is paid.** -/
theorem buy_pays_seller {y : Yard} {id buyer : Nat} {t : Token} (ht : tokenOf y id = some t)
    (hc : 1 ≤ t.ask ∧ buyer < numPlayers ∧ t.owner ≠ buyer ∧ t.ask ≤ stockOf y.balances buyer)
    (hown : t.owner < y.balances.length) :
    stockOf (buyToken y id buyer).balances t.owner = stockOf y.balances t.owner + t.ask := by
  simp only [buyToken, ht, if_pos hc]
  show stockOf (addStock (subStock y.balances buyer t.ask) t.owner t.ask) t.owner =
    stockOf y.balances t.owner + t.ask
  rw [stockOf_add_self (by rw [subStock_length]; exact hown),
    stockOf_sub_other (Ne.symm hc.2.2.1)]

/-- **A sale nobody can pay for does not happen.** -/
theorem buy_refused_without_funds {y : Yard} {id buyer : Nat} {t : Token}
    (ht : tokenOf y id = some t) (hfunds : ¬ t.ask ≤ stockOf y.balances buyer) :
    buyToken y id buyer = y := by
  simp only [buyToken, ht]
  rw [if_neg]
  intro hc
  exact hfunds hc.2.2.2

/-- **A ship nobody offered cannot be bought.** -/
theorem buy_refused_unlisted {y : Yard} {id buyer : Nat} {t : Token}
    (ht : tokenOf y id = some t) (hask : t.ask = 0) :
    buyToken y id buyer = y := by
  simp only [buyToken, ht]
  rw [if_neg]
  intro hc
  omega

/-- **A gift hands the ship over.** -/
theorem gift_transfers {y : Yard} {id who dest : Nat} {t : Token} (ht : tokenOf y id = some t)
    (hc : t.owner = who ∧ dest < numPlayers) :
    ∀ u ∈ (giftToken y id who dest).tokens, u.id = id → u.owner = dest ∧ u.ask = 0 := by
  intro u hu hid
  simp only [giftToken, ht, if_pos hc, updateToken, List.mem_map] at hu
  obtain ⟨v, hv, rfl⟩ := hu
  by_cases hvid : v.id = id
  · rw [if_pos hvid]
    exact ⟨rfl, rfl⟩
  · rw [if_neg hvid] at hid
    exact absurd hid hvid

/-- **A swap really swaps.** -/
theorem swap_swaps {y : Yard} {id₁ id₂ : Nat} {t₁ t₂ : Token}
    (h₁ : tokenOf y id₁ = some t₁) (h₂ : tokenOf y id₂ = some t₂) (hne : id₁ ≠ id₂) :
    ∀ u ∈ (swapTokens y id₁ id₂).tokens,
      (u.id = id₁ → u.owner = t₂.owner) ∧ (u.id = id₂ → u.owner = t₁.owner) := by
  intro u hu
  simp only [swapTokens, h₁, h₂, if_pos hne, List.mem_map] at hu
  obtain ⟨v, hv, rfl⟩ := hu
  by_cases hv1 : v.id = id₁
  · rw [if_pos hv1]
    exact ⟨fun _ => rfl, fun h => absurd (hv1.symm.trans h) hne⟩
  · by_cases hv2 : v.id = id₂
    · rw [if_neg hv1, if_pos hv2]
      exact ⟨fun h => absurd h hv1, fun _ => rfl⟩
    · rw [if_neg hv1, if_neg hv2]
      exact ⟨fun h => absurd h hv1, fun h => absurd h hv2⟩

/-! ## A ship's fingerprint -/

/-- The fingerprint of a build: a hash of the number that *is* the build. -/
def fingerprint (spec : ShipSpec) : Nat := hashNums 0 [encodeSpec spec, 71]

/-- **Two tokens of the same build carry the same fingerprint.** -/
theorem fingerprint_congr {s₁ s₂ : ShipSpec} (h : encodeSpec s₁ = encodeSpec s₂) :
    fingerprint s₁ = fingerprint s₂ := by
  unfold fingerprint
  rw [h]

/-- The six ships on the shelf carry six different fingerprints. -/
theorem stock_fingerprints_distinct : (stockShips.map fingerprint).Nodup := by decide

/-! ## A registry in play -/

/-- Four players, six ships: player 0 commissions the shelf. -/
def demoYard : Yard :=
  stockShips.foldl (fun y s => mint y 0 s) emptyYard

theorem demoYard_ok : YardOk demoYard := by decide

/-- Six tokens, serials 1 … 6, all player 0's. -/
theorem demoYard_tokens :
    demoYard.tokens.map Token.id = [1, 2, 3, 4, 5, 6] ∧
      demoYard.tokens.map Token.owner = [0, 0, 0, 0, 0, 0] ∧
      demoYard.next = 7 := by decide

/-- Player 0 lists the CLIPPER at 300; player 1 buys it. -/
def demoSale : Yard := buyToken (listToken demoYard 3 0 300) 3 1

/-- **The sale goes through, and the registry is still well formed.**  The
CLIPPER changes hands, player 1 is 300 credits poorer, player 0 300 richer, and
the four thousand credits in the registry are still four thousand. -/
theorem demoSale_works :
    YardOk demoSale ∧
      demoSale.tokens.map Token.owner = [0, 0, 1, 0, 0, 0] ∧
      demoSale.balances = [1300, 700, 1000, 1000] ∧
      demoSale.balances.sum = demoYard.balances.sum := by decide

/-- Player 1 swaps the CLIPPER for player 0's HAULER. -/
def demoSwap : Yard := swapTokens demoSale 3 5

/-- **The swap is atomic**: both ships change hands. -/
theorem demoSwap_works :
    demoSwap.tokens.map Token.owner = [0, 0, 0, 0, 1, 0] ∧
      demoSwap.balances = demoSale.balances ∧
      demoSwap.tokens.map Token.id = demoSale.tokens.map Token.id := by decide

/-- **Swapping twice is doing nothing.** -/
theorem swap_involutive : swapTokens demoSwap 3 5 = demoSale := by decide

end Trade
end NixWars
