import RequestProject.Nix.NixWars.Holo.Archive

/-!
# Compressed frames: one cell per frame, and the seek that survives compression

The archive of `Archive.lean` is laid out uncompressed.  Real seekable archive
formats — zstd frames, gzip members, bgzf blocks — are compressed *and* still
randomly accessible, and they get that from one property: each frame is
independently decodable, so the offset table can point at frame boundaries
instead of at raw records.

This file makes that literal.  A cell's wire form is run-length compressed and
wrapped in a length-prefixed **frame**; the archive is the frames laid end to
end, and the offset table is the table of frame boundaries.

* `rle` / `unrle` — the codec, lossless (`unrle_rle`).
* `frame` / `decodeFrame` — one cell per frame.  `decodeFrame_frame`: a frame
  decodes on its own, whatever follows it in the file.
* `framedBytes`, `frameOffset` — the compressed layout.  `frame_range_fetch`
  says the byte interval `[frameOffset i, frameOffset i + frameSize i)` *is*
  frame `i`, `frame_fetch_decompress` that decompressing exactly those bytes
  returns cell `i`, and `frame_intervals_disjoint` that frames never overlap.
* `frames_shorter_than_raw` — on a repetitive cell the compressed frame really
  is smaller than the raw record, so the compression is not a no-op.
-/

namespace NixWars
namespace Holo
namespace Frames

open Archive

/-! ## A framed codec -/

/-- The compressor's inner loop: `v` is the value of the run in progress, `n`
its length so far. -/
def rleGo : Nat → Nat → List Nat → List Nat
  | v, n, [] => [n, v]
  | v, n, x :: xs => if x = v then rleGo v (n + 1) xs else n :: v :: rleGo x 1 xs

/-- Run-length compression: the stream as a list of `count, value` pairs. -/
def rle : List Nat → List Nat
  | [] => []
  | x :: xs => rleGo x 1 xs

/-- Run-length decompression. -/
def unrle : List Nat → List Nat
  | n :: v :: rest => List.replicate n v ++ unrle rest
  | _ => []

theorem unrle_rleGo (v n : Nat) (xs : List Nat) :
    unrle (rleGo v n xs) = List.replicate n v ++ xs := by
  induction xs generalizing v n with
  | nil => simp [rleGo, unrle]
  | cons x xs ih =>
    by_cases hx : x = v
    · subst hx
      simp only [rleGo, if_true]
      rw [ih, List.replicate_succ']
      simp
    · simp only [rleGo, if_neg hx, unrle, ih]
      simp

/-- **The codec is lossless.** -/
@[simp] theorem unrle_rle (l : List Nat) : unrle (rle l) = l := by
  cases l with
  | nil => simp [rle, unrle]
  | cons x xs => simpa [rle] using unrle_rleGo x 1 xs

/-! ## Frames -/

/-- The **frame** of a cell: the compressed length, then the compressed wire
form of the cell.  The length prefix is what makes the frame independently
decodable — a reader positioned at the first byte of a frame knows where the
frame ends without consulting anything else. -/
def frame (c : Cell) : List Nat := (rle c.encode).length :: rle c.encode

/-- The number of bytes the frame of a cell occupies in the compressed file. -/
def frameSize (c : Cell) : Nat := (rle c.encode).length + 1

@[simp] theorem length_frame (c : Cell) : (frame c).length = frameSize c := by
  simp [frame, frameSize]

/-- Read one frame off the front of a compressed stream: take the framed bytes,
decompress them, and decode the cell they hold.  Nothing outside the frame is
consulted. -/
def decodeFrame (bs : List Nat) : Option (Cell × List Nat) :=
  match bs with
  | [] => none
  | n :: rest =>
    if rest.length < n then none
    else
      match decodeCell (unrle (rest.take n)) with
      | some (c, []) => some (c, rest.drop n)
      | _ => none

/-- **A frame is self-contained.**  Decompressing and decoding the bytes at a
frame boundary returns that cell and stops exactly at the end of the frame,
whatever follows it in the compressed file. -/
@[simp] theorem decodeFrame_frame (c : Cell) (rest : List Nat) :
    decodeFrame (frame c ++ rest) = some (c, rest) := by
  have hcell : decodeCell c.encode = some (c, []) := by
    simpa using decodeCell_encode c []
  simp only [frame, List.cons_append, decodeFrame]
  rw [if_neg (by simp)]
  rw [List.take_left' rfl, List.drop_left' rfl, unrle_rle, hcell]

/-! ## The compressed layout -/

/-- The compressed file: the frames laid end to end. -/
def framedBytes (A : Archive) : List Nat := (A.map frame).flatten

/-- The byte offset at which frame `i` begins: **the offset table is the table
of frame boundaries**. -/
def frameOffset (A : Archive) (i : Nat) : Nat := ((A.take i).map frameSize).sum

@[simp] theorem frameOffset_zero (A : Archive) : frameOffset A 0 = 0 := by simp [frameOffset]

theorem frameOffset_succ (A : Archive) (i : Nat) (h : i < A.length) :
    frameOffset A (i + 1) = frameOffset A i + frameSize (A[i]'h) := by
  unfold frameOffset
  rw [List.take_add_one, List.getElem?_eq_getElem h, List.map_append, List.sum_append]
  simp

theorem frameOffset_mono (A : Archive) {i j : Nat} (h : i ≤ j) :
    frameOffset A i ≤ frameOffset A j := by
  unfold frameOffset
  exact ((List.take_sublist_take_left h).map _).sum_le_sum (by intro a _; omega)

theorem length_framedBytes (A : Archive) :
    (framedBytes A).length = frameOffset A A.length := by
  unfold framedBytes frameOffset
  simp [List.length_flatten, List.map_map, Function.comp_def]

theorem framedBytes_drop (A : Archive) (i : Nat) (h : i < A.length) :
    (framedBytes A).drop (frameOffset A i) =
      frame (A[i]'h) ++ ((A.drop (i + 1)).map frame).flatten := by
  have hsplit : framedBytes A =
      ((A.take i).map frame).flatten ++
        (frame (A[i]'h) ++ ((A.drop (i + 1)).map frame).flatten) := by
    conv_lhs => rw [framedBytes, ← List.take_append_drop i A]
    rw [List.drop_eq_getElem_cons h, List.map_append, List.flatten_append, List.map_cons,
      List.flatten_cons]
  have hlen : (((A.take i).map frame).flatten).length = frameOffset A i := by
    unfold frameOffset
    simp [List.length_flatten, List.map_map, Function.comp_def]
  rw [hsplit, ← hlen, List.drop_left]

/-- **The frame boundary is a retrieval coordinate.**  Seeking to the frame
offset and reading the frame's length in bytes returns exactly that frame. -/
theorem frame_range_fetch (A : Archive) (i : Nat) (h : i < A.length) :
    ((framedBytes A).drop (frameOffset A i)).take (frameSize (A[i]'h)) = frame (A[i]'h) := by
  rw [framedBytes_drop A i h, List.take_left' (by simp)]

/-- **Decompressing a fetched frame returns the cell.**  One range request
against the *compressed* file, and the client holds the cell — the rest of the
file is neither fetched nor decompressed. -/
theorem frame_fetch_decompress (A : Archive) (i : Nat) (h : i < A.length) :
    decodeFrame (((framedBytes A).drop (frameOffset A i)).take (frameSize (A[i]'h)))
      = some (A[i]'h, []) := by
  rw [frame_range_fetch A i h]
  simpa using decodeFrame_frame (A[i]'h) []

/-- Even reading to the end of the file from a frame boundary stops at the end
of the frame: the reader never needs bytes it did not ask for. -/
theorem frame_fetch_at_offset (A : Archive) (i : Nat) (h : i < A.length) :
    decodeFrame ((framedBytes A).drop (frameOffset A i)) =
      some (A[i]'h, ((A.drop (i + 1)).map frame).flatten) := by
  rw [framedBytes_drop A i h]
  exact decodeFrame_frame _ _

/-- Distinct frames occupy disjoint byte intervals. -/
theorem frame_intervals_disjoint (A : Archive) {i j : Nat} (hij : i < j) (hj : j < A.length) :
    frameOffset A i + frameSize (A[i]'(lt_trans hij hj)) ≤ frameOffset A j := by
  have := frameOffset_succ A i (lt_trans hij hj)
  have := frameOffset_mono A (show i + 1 ≤ j by omega)
  omega

/-! ## The compression is not a no-op -/

/-- A cell whose supporting material repeats. -/
def repetitiveCell : Cell := ⟨7, List.replicate 40 3, [6, 8]⟩

/-- **Compression pays.**  The raw record of a repetitive cell is 45 bytes; its
frame, length prefix included, is 12. -/
theorem frames_shorter_than_raw :
    frameSize repetitiveCell < repetitiveCell.size := by
  decide

/-- And the fetched frame still decodes to the cell on its own. -/
theorem repetitive_frame_roundtrip :
    decodeFrame (frame repetitiveCell) = some (repetitiveCell, []) := by
  simpa using decodeFrame_frame repetitiveCell []

end Frames
end Holo
end NixWars
