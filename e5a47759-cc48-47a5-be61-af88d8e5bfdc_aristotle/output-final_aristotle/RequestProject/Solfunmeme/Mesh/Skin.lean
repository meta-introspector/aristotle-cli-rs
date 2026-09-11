import RequestProject.Solfunmeme.Mesh.Codec
import RequestProject.Solfunmeme.Meme.Proofs.Stego

/-!
# Brainrot carriers: a signed market card hidden in a meme

Sharing is the point of the game, and what people actually share is a picture.
So a card travels two ways at once:

* **overt** — the chart and the numbers are drawn on the meme for a human to
  read (`Mesh.Chart`);
* **covert** — the exact bytes of the signed card sit in the least significant
  bits of the same image, so a machine that receives the picture recovers the
  data, the signatures and the citations, and can check every claim the picture
  makes.

`reveal_hide` is the guarantee: what is hidden comes back out, byte for byte,
and parses to the same signed post.  The image itself is barely touched — the
carrier's per-byte error is at most one unit, which is `Meme.Stego`'s
`embedBits_preserves_upper`, reused here rather than reproved.
-/

namespace Mesh.Skin

/-- Hide a signed card in the low bits of a meme's pixel bytes. -/
def hide (cover : List Nat) (sp : SignedPost) : List Nat :=
  Meme.Stego.embedBytes cover ((Codec.encCard sp).map UInt8.toNat)

/-- The number of pixel bytes a card needs. -/
def room (sp : SignedPost) : Nat := 8 * (Codec.encCard sp).length

/-- Read a card back out of a carrier image. -/
def reveal (n : Nat) (carrier : List Nat) : Option SignedPost := do
  let (sp, _) ← Codec.readCard ((Meme.Stego.extractBytes n carrier).map UInt8.ofNat)
  pure sp

/-- **What you hide is what you get back.**  A card embedded in a large enough
meme is recovered exactly, and parses to the same signed post — same view, same
signatures, same citations. -/
theorem reveal_hide {cover : List Nat} {sp : SignedPost} (h : Codec.CardWf sp)
    (hroom : room sp ≤ cover.length) :
    reveal (Codec.encCard sp).length (hide cover sp) = some sp := by
  have hp : ∀ b ∈ (Codec.encCard sp).map UInt8.toNat, b < 256 := by
    intro b hb
    obtain ⟨x, -, rfl⟩ := List.mem_map.mp hb
    exact UInt8.toNat_lt_size x
  have hlen : ((Codec.encCard sp).map UInt8.toNat).length = (Codec.encCard sp).length := by simp
  have hround := Meme.Stego.extractBytes_embedBytes (cover := cover)
    (payload := (Codec.encCard sp).map UInt8.toNat) hp (by simpa [room, hlen] using hroom)
  rw [hlen] at hround
  simp only [reveal, hide, hround, List.map_map]
  have hid : ((Codec.encCard sp).map (fun b => UInt8.ofNat b.toNat)) = Codec.encCard sp := by
    rw [List.map_congr_left (fun b _ => UInt8.ofNat_toNat)]
    simp
  simp only [Function.comp_def, hid]
  rw [show Codec.readCard (Codec.encCard sp) = some (sp, []) by
    simpa using Codec.decodeCard_encodeCard h []]
  rfl

end Mesh.Skin
