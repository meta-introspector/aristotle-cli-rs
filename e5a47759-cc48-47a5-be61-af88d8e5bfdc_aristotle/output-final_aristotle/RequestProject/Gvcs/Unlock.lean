import RequestProject.Gvcs.Henge.Token

/-!
# Payment-gated unlocks

The page is free to play and some of it is not: a supporter can buy a brass
badge skin, a second shader theme, the soundtrack, or a plaque with their name
on it.  This file is the gate, and the point of writing it in Lean is to make
three promises checkable rather than merely stated:

1. **Paying is necessary** for a gated item — `unlocked_paid_sound` says that if
   the gate opens on a priced item then there really is a receipt for *that*
   buyer, for *that* item, sealed with the shop's key, not refunded, still
   live, and for at least the asking price.  `forged_not_unlocked` says that a
   player who cannot produce the right seal cannot open the gate at all, and
   `underpaid_not_unlocked` says that paying less than the price does not open
   it either.
2. **Paying is sufficient** — `unlocked_of_issue`: a genuine receipt from the
   shop opens the gate, so an honest customer is never locked out; and
   `unlocked_mono`, `unlocked_perm` say the ledger does not care how many other
   receipts are in it or in what order they arrive.
3. **Nothing that matters is behind the gate** — for the catalogue actually
   shipped, `core_items_are_free` proves every core item costs nothing and
   `paid_items_are_cosmetic` proves everything with a price on it is cosmetic.
   The game is not pay-to-win, and that is a theorem about the price list rather
   than a promise in the small print.

There is also a day pass: a receipt may carry an expiry, and `trial_expires`
shows the gate closes again the day after it runs out, while `refund_revokes`
shows a refunded receipt stops unlocking anything.

**What this is not.**  The seal is the keyed digest of `Henge.Token`, computed
in ordinary arithmetic: it stops a player who does not know the shop key from
writing their own receipts, and it is not claimed to be collision-resistant, nor
to be a payment system.  Money changing hands happens elsewhere; what is
formalized here is the *entitlement* it buys and the gate that reads it.
-/

namespace LifeTrac
namespace Unlock

open Henge

/-! ## The price list -/

/-- One thing that can be bought — or given away. -/
structure Item where
  /-- Stable numeric id, the thing that is signed. -/
  id : ℕ
  /-- What the shop calls it. -/
  name : String
  /-- Price in the smallest unit of money; `0` means free. -/
  price : ℕ
  /-- Whether it only changes how the page looks. -/
  cosmetic : Bool
  /-- Whether it is part of the game everybody gets. -/
  core : Bool
  deriving DecidableEq

/-- The shop's price list. -/
abbrev Catalogue := List Item

/-- The price of an item, if the shop sells it at all. -/
def priceOf (cat : Catalogue) (i : ℕ) : Option ℕ :=
  (cat.find? (fun it => it.id == i)).map Item.price

/-- An item nobody has to pay for. -/
def isFree (cat : Catalogue) (i : ℕ) : Bool := priceOf cat i == some 0

/-! ## Receipts -/

/-- What the shop hands back when it is paid.  `expires = 0` means the
entitlement never runs out; anything else is a day pass. -/
structure Receipt where
  /-- Who paid. -/
  buyer : ℕ
  /-- What they paid for. -/
  item : ℕ
  /-- How much they paid. -/
  amount : ℕ
  /-- A number that makes this receipt distinguishable from any other. -/
  nonce : ℕ
  /-- Last day on which it is good, or `0` for for ever. -/
  expires : ℕ
  /-- The shop's stamp. -/
  stamp : ℕ
  deriving DecidableEq

/-- The part of a receipt that is sealed. -/
def Receipt.body (r : Receipt) : List ℕ := [r.buyer, r.item, r.amount, r.nonce, r.expires]

/-- Is this receipt sealed with the shop's key? -/
def Receipt.sealed (key : ℕ) (r : Receipt) : Bool := verifySeal key r.body r.stamp

/-- The shop issuing a receipt. -/
def issue (key buyer item amount nonce expires : ℕ) : Receipt where
  buyer := buyer
  item := item
  amount := amount
  nonce := nonce
  expires := expires
  stamp := sealOf key [buyer, item, amount, nonce, expires]

/-- A receipt the shop issued is sealed. -/
theorem issue_sealed (key buyer item amount nonce expires : ℕ) :
    (issue key buyer item amount nonce expires).sealed key = true := by
  simp [Receipt.sealed, issue, Receipt.body, verifySeal]

/-- **Only the shop can write a receipt.**  A receipt passes the seal check
exactly when its seal is the keyed digest of its body. -/
theorem sealed_iff (key : ℕ) (r : Receipt) :
    r.sealed key = true ↔ r.stamp = sealOf key r.body := by
  simp [Receipt.sealed, verifySeal]

/-- Is the receipt still good on this day? -/
def Receipt.live (r : Receipt) (day : ℕ) : Bool := r.expires == 0 || decide (day ≤ r.expires)

/-- Does this receipt entitle `buyer` to `item` on `day`? -/
def Receipt.honours (key : ℕ) (cat : Catalogue) (buyer item day : ℕ)
    (refunds : List ℕ) (r : Receipt) : Bool :=
  r.sealed key && r.buyer == buyer && r.item == item && r.live day
    && !refunds.contains r.nonce
    && (match priceOf cat item with
        | some p => decide (p ≤ r.amount)
        | none => false)

/-- **The gate.**  An item is unlocked for a buyer on a day if the shop gives it
away, or if some receipt in the ledger honours it. -/
def unlocked (key : ℕ) (cat : Catalogue) (buyer item day : ℕ)
    (refunds : List ℕ) (receipts : List Receipt) : Bool :=
  isFree cat item || receipts.any (Receipt.honours key cat buyer item day refunds)

/-! ## What the gate guarantees -/

/-- **Free is free.**  Nothing has to be produced to unlock an item the shop
gives away — no receipt, no key, no network. -/
theorem unlocked_free {key : ℕ} {cat : Catalogue} {buyer item day : ℕ}
    {refunds : List ℕ} {receipts : List Receipt} (h : priceOf cat item = some 0) :
    unlocked key cat buyer item day refunds receipts = true := by
  simp [unlocked, isFree, h]

/-- **Paying is necessary.**  If the gate opens on an item the shop charges for,
there is a receipt behind it: sealed with the shop's key, made out to this buyer
for this item, still live, not refunded, and for at least the asking price. -/
theorem unlocked_paid_sound {key : ℕ} {cat : Catalogue} {buyer item day p : ℕ}
    {refunds : List ℕ} {receipts : List Receipt}
    (hp : priceOf cat item = some p) (hpos : p ≠ 0)
    (h : unlocked key cat buyer item day refunds receipts = true) :
    ∃ r ∈ receipts, r.sealed key = true ∧ r.buyer = buyer ∧ r.item = item ∧
      r.live day = true ∧ r.nonce ∉ refunds ∧ p ≤ r.amount := by
  have hfree : isFree cat item = false := by
    simp [isFree, hp, hpos]
  rw [unlocked, hfree, Bool.false_or, List.any_eq_true] at h
  obtain ⟨r, hr, hh⟩ := h
  refine ⟨r, hr, ?_⟩
  simp [Receipt.honours, hp] at hh
  exact ⟨hh.1.1.1.1.1, hh.1.1.1.1.2, hh.1.1.1.2, hh.1.1.2, hh.1.2, hh.2⟩

/-- **Paying is sufficient.**  A genuine receipt for at least the price, not
refunded and not expired, opens the gate. -/
theorem unlocked_of_issue {key : ℕ} {cat : Catalogue} {buyer item day amount nonce p : ℕ}
    {refunds : List ℕ} {receipts : List Receipt}
    (hp : priceOf cat item = some p) (hpay : p ≤ amount)
    (hnonce : nonce ∉ refunds)
    (hmem : issue key buyer item amount nonce 0 ∈ receipts) :
    unlocked key cat buyer item day refunds receipts = true := by
  rw [unlocked, Bool.or_eq_true, List.any_eq_true]
  refine Or.inr ⟨issue key buyer item amount nonce 0, hmem, ?_⟩
  simp [Receipt.honours, Receipt.live, hp, hpay, issue]
  refine ⟨?_, by simpa using hnonce⟩
  simp [Receipt.sealed, Receipt.body, verifySeal]

/-- **A player who cannot seal cannot buy.**  If no receipt in the ledger
carries the shop's seal, no priced item is unlocked. -/
theorem forged_not_unlocked {key : ℕ} {cat : Catalogue} {buyer item day p : ℕ}
    {refunds : List ℕ} {receipts : List Receipt}
    (hp : priceOf cat item = some p) (hpos : p ≠ 0)
    (hforged : ∀ r ∈ receipts, r.stamp ≠ sealOf key r.body) :
    unlocked key cat buyer item day refunds receipts = false := by
  by_contra hcon
  rw [Bool.not_eq_false] at hcon
  obtain ⟨r, hr, hsealed, _⟩ := unlocked_paid_sound hp hpos hcon
  exact hforged r hr ((sealed_iff key r).1 hsealed)

/-- **Underpaying does not open the gate.**  If every receipt for this item is
for less than the price, the item stays locked. -/
theorem underpaid_not_unlocked {key : ℕ} {cat : Catalogue} {buyer item day p : ℕ}
    {refunds : List ℕ} {receipts : List Receipt}
    (hp : priceOf cat item = some p) (hpos : p ≠ 0)
    (hshort : ∀ r ∈ receipts, r.amount < p) :
    unlocked key cat buyer item day refunds receipts = false := by
  by_contra hcon
  rw [Bool.not_eq_false] at hcon
  obtain ⟨r, hr, -, -, -, -, -, hge⟩ := unlocked_paid_sound hp hpos hcon
  exact absurd hge (not_le.2 (hshort r hr))

/-- **A refund revokes.**  Once the nonce of the only receipt is on the refund
list, a priced item is locked again. -/
theorem refund_revokes {key : ℕ} {cat : Catalogue} {buyer item day p : ℕ}
    {refunds : List ℕ} {r : Receipt}
    (hp : priceOf cat item = some p) (hpos : p ≠ 0)
    (hin : r.nonce ∈ refunds) :
    unlocked key cat buyer item day refunds [r] = false := by
  by_contra hcon
  rw [Bool.not_eq_false] at hcon
  obtain ⟨r', hr', -, -, -, -, hout, -⟩ := unlocked_paid_sound hp hpos hcon
  rw [List.mem_singleton] at hr'
  exact hout (hr' ▸ hin)

/-- **A day pass runs out.**  After the last day it names, the receipt no longer
honours anything. -/
theorem trial_expires {r : Receipt} {day : ℕ} (hlim : r.expires ≠ 0)
    (hday : r.expires < day) : r.live day = false := by
  simp [Receipt.live, hlim]
  omega

theorem expired_not_unlocked {key : ℕ} {cat : Catalogue} {buyer item day p : ℕ}
    {refunds : List ℕ} {receipts : List Receipt}
    (hp : priceOf cat item = some p) (hpos : p ≠ 0)
    (hdead : ∀ r ∈ receipts, r.live day = false) :
    unlocked key cat buyer item day refunds receipts = false := by
  by_contra hcon
  rw [Bool.not_eq_false] at hcon
  obtain ⟨r, hr, -, -, -, hlive, -, -⟩ := unlocked_paid_sound hp hpos hcon
  rw [hdead r hr] at hlive
  exact Bool.noConfusion hlive

/-- **More receipts never lock anything.** -/
theorem unlocked_mono {key : ℕ} {cat : Catalogue} {buyer item day : ℕ}
    {refunds : List ℕ} {rs rs' : List Receipt} (hsub : rs ⊆ rs')
    (h : unlocked key cat buyer item day refunds rs = true) :
    unlocked key cat buyer item day refunds rs' = true := by
  rw [unlocked, Bool.or_eq_true, List.any_eq_true] at h ⊢
  rcases h with h | ⟨r, hr, hh⟩
  · exact Or.inl h
  · exact Or.inr ⟨r, hsub hr, hh⟩

/-- **The order the receipts arrive in does not matter.** -/
theorem unlocked_perm {key : ℕ} {cat : Catalogue} {buyer item day : ℕ}
    {refunds : List ℕ} {rs rs' : List Receipt} (hperm : rs.Perm rs') :
    unlocked key cat buyer item day refunds rs
      = unlocked key cat buyer item day refunds rs' := by
  simp [unlocked, hperm.any_eq]

/-! ## The shipped price list -/

/-- The catalogue the page actually ships: the whole game free, four cosmetic
extras for a supporter. -/
def shopCatalogue : Catalogue :=
  [ ⟨1, "the game", 0, false, true⟩
  , ⟨2, "every content pack", 0, false, true⟩
  , ⟨3, "the pack editor", 0, false, true⟩
  , ⟨4, "share codes and receipts", 0, false, true⟩
  , ⟨5, "brass badge skin", 300, true, false⟩
  , ⟨6, "midnight shader theme", 300, true, false⟩
  , ⟨7, "the soundtrack", 500, true, false⟩
  , ⟨8, "a plaque with your name on it", 2500, true, false⟩ ]

/-- **Nothing that matters is behind the gate**: every core item is free. -/
theorem core_items_are_free :
    ∀ it ∈ shopCatalogue, it.core = true → it.price = 0 := by decide

/-- **And everything with a price on it only changes how the page looks.** -/
theorem paid_items_are_cosmetic :
    ∀ it ∈ shopCatalogue, it.price ≠ 0 → it.cosmetic = true := by decide

/-- So the game is not pay-to-win: no item is both priced and non-cosmetic. -/
theorem no_pay_to_win :
    ∀ it ∈ shopCatalogue, ¬ (it.price ≠ 0 ∧ it.cosmetic = false) := by decide

/-! ## A worked purchase -/

/-- The shop's key.  In a real shop this lives on the server; here it is a
number, and the theorems below say exactly what knowing it buys. -/
def shopKey : ℕ := 20250901

/-- Buyer 42 pays 300 for the brass badge skin. -/
def badgeReceipt : Receipt := issue shopKey 42 5 300 1 0

/-- The gate opens for them. -/
theorem badge_unlocked :
    unlocked shopKey shopCatalogue 42 5 0 [] [badgeReceipt] = true := by decide

/-- It does not open for somebody else holding their receipt. -/
theorem badge_not_transferable :
    unlocked shopKey shopCatalogue 43 5 0 [] [badgeReceipt] = false := by decide

/-- Nor for a different item. -/
theorem badge_does_not_unlock_the_plaque :
    unlocked shopKey shopCatalogue 42 8 0 [] [badgeReceipt] = false := by decide

/-- The core game is open to them with no receipt at all. -/
theorem game_is_free : unlocked shopKey shopCatalogue 42 1 0 [] [] = true := by decide

/-- Paying 299 does not buy a 300 item. -/
theorem underpaid_badge :
    unlocked shopKey shopCatalogue 42 5 0 [] [issue shopKey 42 5 299 1 0] = false := by decide

/-- Editing the amount on a genuine receipt breaks its seal, and the gate
notices. -/
theorem tampered_badge :
    unlocked shopKey shopCatalogue 42 5 0 [] [{ badgeReceipt with amount := 1 }] = false := by
  decide

/-- Refunding it locks the skin again. -/
theorem badge_refunded :
    unlocked shopKey shopCatalogue 42 5 0 [1] [badgeReceipt] = false := by decide

/-- A week's pass on the soundtrack, bought on day 0: good on day 7, gone on
day 8. -/
def soundtrackPass : Receipt := issue shopKey 42 7 500 2 7

theorem pass_good_on_day_seven :
    unlocked shopKey shopCatalogue 42 7 7 [] [soundtrackPass] = true := by decide

theorem pass_gone_on_day_eight :
    unlocked shopKey shopCatalogue 42 7 8 [] [soundtrackPass] = false := by decide

end Unlock
end LifeTrac
