import RequestProject.Solfunmeme.Mesh.Net
import RequestProject.Solfunmeme.Mesh.Chart
import RequestProject.Solfunmeme.Mesh.Skin
import RequestProject.Solfunmeme.Mesh.Bundle

/-!
# Worked examples: none of the mesh theorems are vacuous

Every statement in `Mesh.*` is about objects that exist, and this file exhibits
them: a three-node mesh that converges, a signed card that verifies, a
co-signature that is accepted and a forgery that is refused, a card that
survives a URL, a QR split and a meme, and a served page whose signature stops
at its own origin.

The verifier used here is a toy — a signature is the key and the message glued
together — because the theorems are stated for *any* verifier and the examples
only need one that exists.  In the page the same interface is WebCrypto ECDSA
P-256.
-/

namespace Mesh.Examples

set_option maxRecDepth 100000

open Mesh Mesh.Codec

/-! ## A market -/

/-- Three readings of token 1 from two venues. -/
def q1 : Quote := { token := 1, venue := 7, slot := 314266534, price := 1250, size := 4000000 }
/-- A later reading from the other venue. -/
def q2 : Quote := { token := 1, venue := 9, slot := 314266536, price := 1310, size := 1500000 }
/-- The newest reading. -/
def q3 : Quote := { token := 1, venue := 7, slot := 314266540, price := 1290, size := 900000 }

#guard q1.wf && q2.wf && q3.wf

/-- Node A has the first two readings, node B the last one, node C nothing. -/
def netStart : Net := [[q1, q2], [q3], []]

/-- A gossip schedule: A meets B, then B meets C. -/
def schedule : List (Nat × Nat) := [(0, 1), (1, 2)]

/-- Node C, which started empty and never met A, ends up with A's readings. -/
example : q1 ∈ get (deliver schedule netStart) 2 := by decide

/-- Everybody ends up with everything. -/
example : (get (deliver schedule netStart) 2).toFinset = (unionAll netStart).toFinset := by decide

/-- Gossip is not needed twice: replaying the schedule changes nothing. -/
example : (get (deliver (schedule ++ schedule) netStart) 2).toFinset
    = (get (deliver schedule netStart) 2).toFinset := by decide

/-- The printed price is the newest reading. -/
example : latest 1 (unionAll netStart) = some q3 := by decide

/-- The volume-weighted average sits inside the quoted range. -/
example : 1250 ≤ vwap [q1, q2, q3] ∧ vwap [q1, q2, q3] ≤ 1310 := by decide

/-! ## A signed card -/

/-- The view the post publishes. -/
def view1 : View :=
  { title := "SOLFUNMEME 5m", token := 1, fromSlot := 314266534, toSlot := 314266540,
    quotes := [q1, q2, q3] }

/-- The author's post. -/
def post1 : Post :=
  { author := "AuthorKey11111111111111111111111", seq := 1, time := 1736974661,
    imports := [], view := view1 }

#guard Mesh.wf post1

/-- A second reader, who will check the data and co-sign it. -/
def reader : String := "ReaderKey1111111111111111111111"

/-- A toy verifier: a small table of who signed what with which string.  The
theorems hold for any verifier; in the page this interface is WebCrypto ECDSA
P-256. -/
def sigTable : List (String × String × String) :=
  [(post1.author, message post1, "AuthorSig"), (reader, message post1, "ReaderSig")]

/-- The verifier the examples use. -/
def V : Verifier := fun k m s => sigTable.contains (k, m, s)

/-- The author signs their own post. -/
def signed1 : SignedPost :=
  { post := post1, sigs := [{ signer := post1.author, sig := "AuthorSig" }] }

#guard verifyPost V signed1

/-- The co-signed card: the reader checked the data and added their name. -/
def signed2 : SignedPost := cosign signed1 { signer := reader, sig := "ReaderSig" }

#guard verifyPost V signed2

-- Two names, same data.
#guard signers signed2 == [post1.author, reader]
#guard signed2.post.view == signed1.post.view

-- A forged co-signature — the right key, somebody else's signature — is refused.
#guard !verifyPost V (cosign signed1 { signer := reader, sig := "AuthorSig" })

-- Signing twice under the same name is refused.
#guard !verifyPost V (cosign signed1 { signer := post1.author, sig := "AuthorSig" })

/-- Editing a single price after signing breaks the signature: the canonical
text is different, so the old signature no longer applies. -/
def tamperedPost : Post := { post1 with view := { view1 with quotes := [q1, q2,
  { q3 with price := 9999 }] } }

#guard message tamperedPost != message post1
#guard !verifyPost V { post := tamperedPost, sigs := signed1.sigs }

/-! ## Sharing it -/

/-- The card is well formed for the wire. -/
theorem signed2_cardWf : CardWf signed2 := by decide

/-- It round trips through the base-58 text. -/
example : ofCode (toCode signed2) = some signed2 := ofCode_toCode signed2_cardWf

/-- It round trips through a link. -/
example : ofCode (fragment (toUrl "https://solfunmeme.com/m" signed2)) = some signed2 :=
  ofUrl_toUrl (by decide) signed2_cardWf

/-- It round trips through a set of QR fragments. -/
example : assemble (fragments 120 (toCode signed2)) = some (toCode signed2) :=
  assemble_fragments (by norm_num) _

/-- Drop one QR fragment and the rest are refused rather than misread. -/
example (f : Frag) (fs : List Frag) (hf : f ∈ fs) (h : f.total ≠ fs.length) :
    assemble fs = none := assemble_eq_none_of_missing hf h

/-- It survives being hidden in a meme. -/
example (cover : List Nat) (hroom : Mesh.Skin.room signed2 ≤ cover.length) :
    Mesh.Skin.reveal (encCard signed2).length (Mesh.Skin.hide cover signed2) = some signed2 :=
  Mesh.Skin.reveal_hide signed2_cardWf hroom

/-! ## The chart -/

/-- A chart of the view: one point per reading, inside the box. -/
def geom : Chart.Geom := { width := 640, height := 240 }

#guard (Chart.points geom view1).length == 3
#guard (Chart.points geom view1).all (fun p => p.1 ≤ 640 && p.2 ≤ 240)

/-- The newest reading is not the highest: the top of the chart is the highest
price quoted, which is the middle reading. -/
example : Chart.yOf geom view1 q2 = 0 := by decide

/-- The lowest price quoted sits on the floor of the chart. -/
example : Chart.yOf geom view1 q1 = 240 := by decide

/-! ## The served page -/

open Mesh.Runtime

/-- A page: a tiny runtime and the card woven together. -/
def page : Bundle := { runtime := [1, 2, 3, 4, 5], payload := encCard signed2 }

theorem page_wf : page.wf := by
  constructor
  · simp [page, Meme.Share.bound]
  · decide

/-- An honest client recovers both halves. -/
example : unweave (weave page) = some page := unweave_weave page_wf

/-- Stripping the market data out of the page changes what is served, so the
site signature no longer covers it. -/
example {H : List UInt8 → String} (hH : Function.Injective H) :
    H (weave page) ≠ H (weave { page with payload := [] }) := by
  refine strip_detected hH page_wf ?_
  simp [page, encCard, Codec.frameStr, Meme.Share.natToLE8]

/-- Swapping the runtime for another one is equally visible. -/
example {H : List UInt8 → String} (hH : Function.Injective H) :
    H (weave page) ≠ H (weave { page with runtime := [9, 9, 9] }) :=
  runtime_swap_detected hH page_wf ⟨by simp [Meme.Share.bound], page_wf.2⟩ (by simp [page])

end Mesh.Examples
