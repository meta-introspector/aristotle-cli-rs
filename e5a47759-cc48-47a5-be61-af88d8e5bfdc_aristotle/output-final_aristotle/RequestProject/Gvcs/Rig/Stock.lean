import RequestProject.Gvcs.Rig.Wasm
import RequestProject.Gvcs.Rig.Share
import RequestProject.Gvcs.Rig.Touch
import RequestProject.Gvcs.Web.Base64
import RequestProject.Gvcs.Wasm.DecodeCorrect

/-!
# The single page

`web/rigs.html` is the whole thing in one file: the workshop, the course, the
shell, the tables and the WebAssembly module of `RequestProject/Rig/Wasm.lean`.
There is no `<script src=…>`, no `<link>`, no image and no `fetch`, so opening
the file from disk — a plain `file://` URL — is enough to build a machine and
drive it, on a phone as well as on a desktop.

The module travels the same way as in `RequestProject/Web/Standalone.lean`: the
bytes are masked with the keystream of a linear congruential generator and
written as base64, and the page's JavaScript undoes both before
`WebAssembly.instantiate` sees a byte.  `rig_page_runs_rigMod` is the statement
that it gets back exactly the module the correctness theorems are about, and
that those bytes parse — through the independent decoder of
`RequestProject/Wasm/Decode.lean` — to `rigMod` itself.

The tables in the page's JavaScript (the blocks, their figures, the course, the
share alphabet) are all *generated from the Lean definitions* below, so there
is one place where the numbers of the game are written down.
-/

namespace LifeTrac
namespace Rig

open Wasm Web

/-! ## The module, sealed into the page -/

/-- The seed of the keystream the module is masked with. -/
def rigKey : Nat := 20260901

/-- The module, masked and in base64: the string the page carries. -/
def rigPayload : String := payloadOf rigKey (encodeMod rigMod)

/-- **The page runs the verified module.**  Undoing the base64 and the mask
returns exactly the bytes of `rigMod`, and those bytes parse back to `rigMod` —
one page of memory, its data segment, and its six entry points. -/
theorem rig_page_runs_rigMod :
    recoverBytes rigKey rigPayload = encodeMod rigMod ∧
    decodeMod (modFuel rigMod) (recoverBytes rigKey rigPayload) =
      some ⟨rigMod.memPages, imageBytes rigMod.image, rigMod.funcs.map (fun f =>
        (⟨f.name.toUTF8.toList, f.params, f.locals, f.returns, f.body⟩ : DecFunc))⟩ := by
  have hbytes : recoverBytes rigKey rigPayload = encodeMod rigMod :=
    recoverBytes_payloadOf _ _
  exact ⟨hbytes, by rw [hbytes]; exact decodeMod_encodeMod rigMod _ le_rfl⟩

/-- The masking is not a no-op: the payload does not begin with the
WebAssembly magic. -/
theorem rig_payload_masked (b : ℕ) (t : List ℕ) :
    (maskFrom rigKey (b :: t)).head? ≠ some b :=
  maskFrom_head_ne (by decide) t

/-! ## Stock machines -/

/-- The starter machine: two wheels, an engine, a tank and a scoop on a frame.
Eight hundred and sixty of a thousand. -/
def hauler : Design := ofList
  [1,2,1,1,1,1,2,1,
   0,1,3,1,1,4,1,0,
   0,0,0,6,0,0,0,0,
   0,0,0,0,0,0,0,0,
   0,0,0,0,0,0,0,0,
   0,0,0,0,0,0,0,0,
   0,0,0,0,0,0,0,0,
   0,0,0,0,0,0,0,0]

/-- A machine with four wheels and no scoop: it corners, but it carries
nothing. -/
def sprinter : Design := ofList
  [1,2,1,1,1,1,2,1,
   0,0,1,3,1,4,0,0,
   0,0,0,0,0,0,0,0,
   0,0,0,0,0,0,0,0,
   0,2,1,1,1,1,2,0,
   0,0,0,0,0,0,0,0,
   0,0,0,0,0,0,0,0,
   0,0,0,0,0,0,0,0]

/-- A heavy machine: two scoops and ballast, slow away from the line. -/
def digger : Design := ofList
  [1,2,1,1,1,1,2,1,
   0,1,3,5,1,4,1,0,
   0,0,6,0,0,6,0,0,
   0,0,0,0,0,0,0,0,
   0,0,0,0,0,0,0,0,
   0,0,0,0,0,0,0,0,
   0,0,0,0,0,0,0,0,
   0,0,0,0,0,0,0,0]

/-- The machines the page ships with, and their names. -/
def stockDesigns : List (String × Design) :=
  [("Hauler", hauler), ("Sprinter", sprinter), ("Digger", digger)]

theorem hauler_ok : DesignOk hauler := by decide
theorem sprinter_ok : DesignOk sprinter := by decide
theorem digger_ok : DesignOk digger := by decide

-- The simp set that evaluates the figures of a design written out as a list:
-- unfold the grid, expand the sum over its sixty-four cells, read the tables.
attribute [local simp] Valid wheels engines tanks cost statOf gridN gridW gridH gridD budget
  Finset.sum_range_succ
  ofList List.getD wheelTbl engineTbl tankTbl costTbl

set_option maxHeartbeats 1000000 in
/-- The starter machine passes the workshop rules. -/
theorem hauler_valid : Valid hauler := by simp [hauler]

set_option maxHeartbeats 1000000 in
/-- The four-wheeler passes the workshop rules. -/
theorem sprinter_valid : Valid sprinter := by simp [sprinter]

set_option maxHeartbeats 1000000 in
/-- The heavy machine passes the workshop rules. -/
theorem digger_valid : Valid digger := by simp [digger]

/-- All three stock machines pass the workshop rules. -/
theorem stock_valid : Valid hauler ∧ Valid sprinter ∧ Valid digger :=
  ⟨hauler_valid, sprinter_valid, digger_valid⟩
end Rig
end LifeTrac
