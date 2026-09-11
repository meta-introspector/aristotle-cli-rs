import Mathlib
import RequestProject.Solfunmeme.Meme.Svg
import RequestProject.Solfunmeme.Meme.Proofs.Engine

/-!
# Badge cards say only what the state earned

`chunks_length` — one chip per unlocked badge, no more; `chunks_sub_unlocked` —
every chip drawn corresponds to a badge the state actually meets; `render_eq` —
the card really is header, chips, footer, so a reader can locate the share code
in the footer.  `chunks_start` records that a fresh save draws no badges at all.
-/

namespace Meme.Svg

open Meme.Engine

@[simp] theorem chunks_length (s : State) : (chunks s).length = (unlocked s).length := by
  simp [chunks]

/-- A card is exactly its header, its chips and its footer. -/
theorem render_eq (s : State) : render s = header s ++ String.join (chunks s) ++ footer s := rfl

/-- Every chip drawn is a badge the state has genuinely unlocked. -/
theorem chunk_mem_of_mem_chunks {s : State} {t : String} (ht : t ∈ chunks s) :
    ∃ i b, b.meets s = true ∧ t = chunk i b := by
  simp only [chunks, List.mem_map] at ht
  obtain ⟨⟨b, i⟩, hmem, rfl⟩ := ht
  refine ⟨i, b, ?_, rfl⟩
  have : b ∈ unlocked s := by
    obtain ⟨_, hlt, hget⟩ := List.mem_zipIdx hmem
    rw [hget]
    exact List.getElem_mem (by omega)
  simpa [unlocked, List.mem_filter] using (List.mem_filter.mp this).2

/-- A fresh save has earned nothing, and draws nothing. -/
theorem chunks_start (b : Nat) : chunks (start b) = [] := by
  simp [chunks, unlocked, allBadges, Badge.meets, start]

end Meme.Svg
