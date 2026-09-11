import RequestProject.Gvcs.Steampunk.Jacquard
import RequestProject.Gvcs.Water.Solar

/-!
# The stack of cards: the program store, and the thing you can sell

The water gates of `Water/Logic.lean` compute; they do not remember a
*program*.  The program lives where Jacquard put it in 1804 — on a chain of
punched cards, read by needles that a water gate can pull.  This file counts
and prices that chain.

* `printerStack` — the printer's own self-print job as a card chain, and
  `printerStack_length` says it is 910 cards of 71 columns.
* `printerStack_roundtrip` — the chain survives punch → weave → re-punch, so a
  stack can be *copied on the loom* rather than bought again; that is what
  makes a stack a tradable good rather than a licence.
* `stackPrice` — what a stack costs: pasteboard, punching labour, and a lacing
  cord, all linear in the card count (`stackPrice_add`, `stackPrice_mono`).
* `printerStack_price_eq` — the printer's stack, priced: 213.21 in the game's
  units, against 1 000.00 for a machine-shop controller.
* `stack_beats_controller` — and that is the sales pitch, as arithmetic.
-/

namespace LifeTrac
namespace Water

open Steampunk
open Voxel
open LifeTrac.Printer

/-! ## The chain -/

/-- The printer's own job, punched onto cards. -/
def printerStack : List (Card cardWidth) := chainOf (job d3d 205 printerParts)

/-- **910 cards.** -/
theorem printerStack_length : printerStack.length = 910 :=
  selfPrint_chain_length

/-- Each card carries 71 punch columns. -/
theorem printerStack_width : cardWidth = 71 := cardWidth_eq

/-- **A stack can be copied.**  Punched, woven and re-punched on any loom whose
comber board is onto, the printer's stack reads back as exactly the same
job — so a customer who buys one stack can weave the next one. -/
theorem printerStack_roundtrip {w : ℕ} (tie : Fin w → Fin cardWidth)
    (hs : Function.Surjective tie) :
    jobOf ((Loom.mk cardWidth w tie).punch hs
        ((Loom.mk cardWidth w tie).weave printerStack)) = some (job d3d 205 printerParts) :=
  selfPrint_jacquard_roundtrip tie hs

/-! ## What a stack costs

Money is in millionths, as everywhere else in the game: `1000000` is one
unit of account. -/

/-- A blank pasteboard card. -/
def cardBlank : Int := 120000

/-- Punching one card on the hand press, at the shop's labour rate. -/
def cardPunch : Int := 111000

/-- The lacing cord, brass eyelets and end boards of one chain. -/
def stackFurniture : Int := 3000000

/-- The price of a chain of `n` cards. -/
def stackPrice (n : ℕ) : Int := stackFurniture + (n : Int) * (cardBlank + cardPunch)

/-- Stacks price additively in their cards, up to the one set of end boards. -/
theorem stackPrice_add (m n : ℕ) :
    stackPrice (m + n) + stackFurniture = stackPrice m + stackPrice n := by
  unfold stackPrice; push_cast; ring

/-- A longer program costs more. -/
theorem stackPrice_mono {m n : ℕ} (h : m ≤ n) : stackPrice m ≤ stackPrice n := by
  unfold stackPrice
  have : (m : Int) ≤ (n : Int) := Int.ofNat_le.mpr h
  have hpos : (0 : Int) ≤ cardBlank + cardPunch := by decide
  nlinarith

/-- The printer's stack, priced: 213.21. -/
def printerStackPrice : Int := stackPrice 910

theorem printerStack_price_eq : printerStackPrice = 213210000 := by decide

/-- What the electronics dealer wants for a controller board that does the same
job — and it has a silicon die in it. -/
def boughtControllerPrice : Int := 1000000000

/-- **The pitch, as arithmetic.**  A woven program stack is under a quarter the
price of the bought controller it replaces. -/
theorem stack_beats_controller : 4 * printerStackPrice < boughtControllerPrice := by decide

/-- Copying a stack on the loom costs the blanks and the punching, and no
furniture beyond the first: the marginal card is 0.231. -/
theorem marginal_card : stackPrice 911 - stackPrice 910 = 231000 := by decide

end Water
end LifeTrac
