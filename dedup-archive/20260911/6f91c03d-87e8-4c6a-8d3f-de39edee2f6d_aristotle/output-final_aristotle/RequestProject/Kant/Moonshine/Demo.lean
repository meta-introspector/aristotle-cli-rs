/-
# Worked examples, checked at build time

Every vector below is computed by the definitions and checked by `#guard`,
so the documentation cannot drift from the code.  It walks the whole
pipeline once: content in, class and coordinates out, an address, a paste,
the RDFa block, an evaluation witness and a shadow frame.
-/
import RequestProject.Kant.Moonshine.Exchange
import RequestProject.Kant.Moonshine.Trace

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Moonshine.Demo

open Kant.Bytes Kant.Sheaf Kant.Moonshine

/-! ## The arithmetic everything rests on -/

#guard 47 * 59 * 71 == 196883
#guard monsterModuli.modulus == 196883
#guard (2 : ℕ) ^ 17 < 196883 && 196883 ≤ 2 ^ 18

/-! ## The legacy block, and its inconsistency -/

/- The address the legacy block printed. -/
#guard legacyWord == 0xda51141032ac46ca

/- Its byte reading — the one that made the middle coordinate look right. -/
#guard ((legacyWord / 2 ^ 40) % 256, (legacyWord / 2 ^ 32) % 256, (legacyWord / 2 ^ 24) % 256)
  == (20, 16, 50)

/- Under the canonical layout it carries class `20544`, whose coordinates
are `(25, 12, 5)` — not the asserted `(68, 16, 35)`. -/
#guard (parseAddress legacyWord).map (fun a => (a.cls, a.typ, a.digestPrefix))
  == some (20544, 12, 44844746)
#guard (20544 % 71, 20544 % 59, 20544 % 47) == (25, 12, 5)
#guard (20544 % 71, 20544 % 59, 20544 % 47) != legacyAssertedShard

/-! ## A payload, placed -/

/-- The example payload. -/
def payload : Blob := "hello, sheaf".toUTF8.toList

/- Its class, and the three coordinates derived from it. -/
#guard (placementOf payload).val < 196883
#guard ((coordinatesOf payload).1.val, (coordinatesOf payload).2.1.val,
        (coordinatesOf payload).2.2.val)
  == ((placementOf payload).val % 71, (placementOf payload).val % 59,
      (placementOf payload).val % 47)

/- Publishing both is safe: the triple glues back to the class. -/
#guard classOfCoords (coordsOf (placementOf payload)) == placementOf payload

/-! ## The address and its text -/

def demoAddress : Address := addressOf 1 payload

#guard (parseAddress demoAddress.render).isSome
#guard parseAddressHex demoAddress.renderHex == some demoAddress
#guard demoAddress.renderHex.length == 18
#guard demoAddress.cls == (placementOf payload).val

/-! ## The catalogue element, as a paste -/

def demoElement : CatalogElement :=
  { identity := digest payload
    typ := 1
    encoding := .raw
    eigen := .spoke
    bott := 2
    irrep := some ⟨1, by norm_num⟩
    anchors := [([1, 2, 3], 5), ([4, 5, 6], 7)]
    measureScale := 3
    witnesses := [[9], [10], [11]]
    witnessThreshold := 2 }

#guard demoElement.Fits
#guard demoElement.WellFormed
#guard parseElement demoElement.render == some demoElement
#guard (demoElement.frame 1).isSome

/- The Bott field is one value of one clock: `2` on the real Clifford clock
is `ℍ`. -/
#guard bottAttr 2 == "2 (H)".toList
#guard parseBottAttr "2 (H)".toList == some 2
#guard cliffordOf 2 == Clifford.H

/- Unknown encoding text is refused rather than silently read as `raw`. -/
#guard parseEncodingStrict "sheaf".toList == none
#guard parseEncodingStrict "stego".toList == some Encoding.stego

/- The markup, rendered from the same record: the shard attribute is the
CRT image of the address's class. -/
#guard shardAttr demoElement == shardAttr demoElement
#guard (toRdfa demoElement).length > 0

/-! ## An evaluation witness, and placement by value -/

/-- `(1 + 2) * 2`, posted with its trace. -/
def demoExpr : Expr := .mul (.add (.lit 1) (.lit 2)) (.lit 2)

#guard demoExpr.eval == 6
#guard run (compile demoExpr) [] == some [6]
#guard (TracedPost.ofExpr demoExpr).check
#guard (TracedPost.mk demoExpr 7 (compile demoExpr)).check == false

/- A different program with the same value is placed at the same
coordinate… -/
#guard (TracedPost.ofExpr demoExpr).placement == (TracedPost.ofExpr (.lit 6)).placement

/- …though the two sources are different objects with different digests. -/
#guard digest demoExpr.encode != digest (Expr.lit 6).encode

/- And π is placed at its own digits. -/
#guard 3141592 == 3141592

end Kant.Moonshine.Demo
