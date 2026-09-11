import Mathlib

/-!
# The share codec of the voxel viewer

`web/voxel.html` is a one-file voxel builder and viewer — build a course out of blocks,
walk it with a thumb joystick, share the whole design as a link — whose runtime is
hand-assembled into WebAssembly by `tools/gen_voxel_wasm.py` and embedded in the page.

A design travels as *text*: nothing is uploaded, there is no server and no account, so the
code in the link has to *be* the level.  This file is the specification of that text, in
three layers:

* **the run-length code** (`enc`, `dec`) of the `24 × 16 × 24` grid of block types — two
  bytes to a run, at most `4096` cells to a chunk — which is exactly `encodeWorld` in the
  WebAssembly module and `refEncode` in `tools/test_voxel.mjs`;
* **base64url** (`toB64`, `ofB64`, `b64Text`, `b64Bytes`), the alphabet the page uses to
  put bytes in a URL fragment;
* **the level record** (`levelBytes`, `levelCode`, `decodeLevel`): a version byte, the
  length of the name, the name, and then the run-length code.

What is proved here:

* `dec_enc` — decoding an encoded world returns that world, exactly, so a share link
  cannot silently deliver a different level from the one that was built;
* `enc_length_le` — a code is never longer than twice its world;
* `ofB64_toB64`, `b64Bytes_b64Text` — the base64url layer is lossless on bytes;
* `decodeLevel_levelCode` — **the whole link round-trips**: the text of a share link
  carries back the name it was made with and, through `dec_enc`, the very world that was
  encoded (`decodeLevel_shareOfWorld`);
* `enc_uniform_world` — a uniform world of the shipped build volume costs six bytes;
* and, of the shipped page itself: that it is one self-contained file, that it embeds the
  WebAssembly module whose base64 sits next to it, and that it carries the controls, the
  palette and the codec it advertises.

`RequestProject/Voxel/View.lean` and `RequestProject/VoxelGame/View.lean` put the machine
and the game world into this format, so the same page views them.

The page audits are discharged by compiled evaluation (`native_decide`) over the bytes of
the artifact, like the project's other finite audits over large strings, so they
additionally use Lean's compiler-evaluation axioms; the mathematics above them does not.
Lake does not track `include_str` dependencies: after rebuilding the page, elaborate this
module again (`lake build RequestProject.Voxel.Codec`) to re-run the audit.
-/

namespace LifeTrac
namespace Voxel
namespace Codec

/-! ## The build volume -/

/-- The width of the build volume, as compiled into the runtime. -/
def dimX : Nat := 24
/-- Its height. -/
def dimY : Nat := 16
/-- Its depth. -/
def dimZ : Nat := 24
/-- The number of cells of a world. -/
def cells : Nat := dimX * dimY * dimZ

/-- A world is a list of block types, each of them a nibble (`0` air, `1` stone, `2` turf,
`3` ice, `4` bounce, `5` lava, `6` coin, `7` goal, `8` start, `9` glass). -/
def IsWorld (l : List Nat) : Prop := ∀ v ∈ l, v < 16

/-! ## The run-length code -/

/-- The length of the leading run of `v`s in `t`. -/
def runLen (v : Nat) (t : List Nat) : Nat := (t.takeWhile (fun x => x == v)).length

/-- The encoder: two bytes per chunk, at most `4096` cells to a chunk. -/
def enc : List Nat → List Nat
  | [] => []
  | v :: t =>
    let n := min 4096 (1 + runLen v t)
    (v % 16 + 16 * ((n - 1) / 256)) :: ((n - 1) % 256) :: enc ((v :: t).drop n)
  termination_by l => l.length
  decreasing_by
    simp only [List.length_drop, List.length_cons]
    have : 1 ≤ min 4096 (1 + runLen v t) := le_min (by norm_num) (by omega)
    omega

/-- The decoder; `none` on a code of odd length. -/
def dec : List Nat → Option (List Nat)
  | [] => some []
  | [_] => none
  | b0 :: b1 :: r =>
    (dec r).map (fun tail => List.replicate (1 + (b0 / 16) * 256 + b1) (b0 % 16) ++ tail)

/-- A prefix of the leading run of `v`s is a block of `v`s. -/
theorem take_runLen_eq_replicate {v : Nat} {t : List Nat} {m : Nat}
    (hm : m ≤ runLen v t) : t.take m = List.replicate m v := by
  have hu : t.takeWhile (fun x => x == v) = t.take (runLen v t) :=
    List.prefix_iff_eq_take.mp (List.takeWhile_prefix _)
  have hrep : t.takeWhile (fun x => x == v) = List.replicate (runLen v t) v := by
    refine List.eq_replicate_iff.mpr ⟨rfl, ?_⟩
    intro x hx
    simpa using List.mem_takeWhile_imp hx
  calc t.take m = (t.take (runLen v t)).take m := by
        rw [List.take_take, min_eq_left hm]
    _ = (List.replicate (runLen v t) v).take m := by rw [← hu, hrep]
    _ = List.replicate m v := by rw [List.take_replicate, min_eq_left hm]

/-- The first `m` cells of `v :: t` are `m` copies of `v`, as long as `m` does not outrun
the leading run. -/
theorem take_cons_eq_replicate {v : Nat} {t : List Nat} {m : Nat}
    (hm : m ≤ 1 + runLen v t) : (v :: t).take m = List.replicate m v := by
  cases m with
  | zero => simp
  | succ k =>
    have hk : k ≤ runLen v t := by omega
    simp [take_runLen_eq_replicate hk, List.replicate_succ]

/-- **Decoding inverts encoding**: a design survives the trip through a share link. -/
theorem dec_enc : ∀ (l : List Nat), IsWorld l → dec (enc l) = some l
  | [], _ => by rw [enc, dec]
  | v :: t, h => by
    have hv : v < 16 := h v (by simp)
    have hn1 : 1 ≤ min 4096 (1 + runLen v t) := le_min (by norm_num) (by omega)
    have hnr : min 4096 (1 + runLen v t) ≤ 1 + runLen v t := min_le_right _ _
    have hdrop : IsWorld ((v :: t).drop (min 4096 (1 + runLen v t))) :=
      fun x hx => h x (List.mem_of_mem_drop hx)
    have hlt : ((v :: t).drop (min 4096 (1 + runLen v t))).length < (v :: t).length := by
      simp only [List.length_drop, List.length_cons]; omega
    have ih := dec_enc ((v :: t).drop (min 4096 (1 + runLen v t))) hdrop
    rw [enc, dec, ih]
    simp only [Option.map_some]
    congr 1
    have h1 : (v % 16 + 16 * ((min 4096 (1 + runLen v t) - 1) / 256)) % 16 = v := by omega
    have h2 : 1 + (v % 16 + 16 * ((min 4096 (1 + runLen v t) - 1) / 256)) / 16 * 256
        + (min 4096 (1 + runLen v t) - 1) % 256 = min 4096 (1 + runLen v t) := by omega
    rw [h1, h2, ← take_cons_eq_replicate hnr, List.take_append_drop]
  termination_by l => l.length

/-- A code is never longer than twice its world: sharing cannot blow up. -/
theorem enc_length_le : ∀ l : List Nat, (enc l).length ≤ 2 * l.length
  | [] => by rw [enc]; simp
  | v :: t => by
    have hn1 : 1 ≤ min 4096 (1 + runLen v t) := le_min (by norm_num) (by omega)
    have hlt : ((v :: t).drop (min 4096 (1 + runLen v t))).length < (v :: t).length := by
      simp only [List.length_drop, List.length_cons]; omega
    have ih := enc_length_le ((v :: t).drop (min 4096 (1 + runLen v t)))
    rw [enc]
    simp only [List.length_cons, List.length_drop] at *
    omega
  termination_by l => l.length

/-- Every byte of a code is a byte: the code can go in a `Uint8Array`. -/
theorem enc_lt_256 : ∀ l : List Nat, IsWorld l → ∀ b ∈ enc l, b < 256
  | [], _ => by rw [enc]; simp
  | v :: t, h => by
    have hv : v < 16 := h v (by simp)
    have hn1 : 1 ≤ min 4096 (1 + runLen v t) := le_min (by norm_num) (by omega)
    have hn2 : min 4096 (1 + runLen v t) ≤ 4096 := min_le_left _ _
    have hdrop : IsWorld ((v :: t).drop (min 4096 (1 + runLen v t))) :=
      fun x hx => h x (List.mem_of_mem_drop hx)
    have hlt : ((v :: t).drop (min 4096 (1 + runLen v t))).length < (v :: t).length := by
      simp only [List.length_drop, List.length_cons]; omega
    have ih := enc_lt_256 ((v :: t).drop (min 4096 (1 + runLen v t))) hdrop
    rw [enc]
    intro b hb
    simp only [List.mem_cons] at hb
    rcases hb with rfl | rfl | hb
    · omega
    · omega
    · exact ih b hb
  termination_by l => l.length

/-- A code has an even number of bytes: two to a chunk. -/
theorem enc_length_even : ∀ l : List Nat, (enc l).length % 2 = 0
  | [] => by rw [enc]; simp
  | v :: t => by
    have hn1 : 1 ≤ min 4096 (1 + runLen v t) := le_min (by norm_num) (by omega)
    have hlt : ((v :: t).drop (min 4096 (1 + runLen v t))).length < (v :: t).length := by
      simp only [List.length_drop, List.length_cons]; omega
    have ih := enc_length_even ((v :: t).drop (min 4096 (1 + runLen v t)))
    rw [enc]
    simp only [List.length_cons]
    omega
  termination_by l => l.length

/-- A nonempty world costs at least one chunk. -/
theorem two_le_enc_length (v : Nat) (t : List Nat) : 2 ≤ (enc (v :: t)).length := by
  rw [enc]; simp

/-- The empty (or any uniform) world of the shipped build volume costs six bytes: three
chunks, because `9216 = 4096 + 4096 + 1024`.  This is the number
`node tools/test_voxel.mjs` reads off the WebAssembly encoder. -/
theorem enc_uniform_world : enc (List.replicate cells 0) = [240, 255, 240, 255, 48, 255] := by
  native_decide

/-- …and it decodes back to that world. -/
theorem dec_uniform_world :
    dec [240, 255, 240, 255, 48, 255] = some (List.replicate cells 0) := by
  native_decide

/-! ## base64url

The page puts the bytes of a level in the fragment of a URL, in the alphabet
`A–Z a–z 0–9 - _`, three bytes to four characters, with no padding.  `toB64` turns bytes
into six-bit groups and `ofB64` turns them back; `b64Text` and `b64Bytes` are the same
thing at the level of characters. -/

/-- Bytes to six-bit groups, three at a time, with no padding. -/
def toB64 : List Nat → List Nat
  | [] => []
  | [a] => [a / 4, (a % 4) * 16]
  | [a, b] => [a / 4, (a % 4) * 16 + b / 16, (b % 16) * 4]
  | a :: b :: c :: t =>
      (a / 4) :: ((a % 4) * 16 + b / 16) :: ((b % 16) * 4 + c / 64) :: (c % 64) :: toB64 t

/-- Six-bit groups back to bytes.  A single leftover group carries no byte, exactly as in
the page's decoder. -/
def ofB64 : List Nat → List Nat
  | [] => []
  | [_] => []
  | [p, q] => [p * 4 + q / 16]
  | [p, q, r] => [p * 4 + q / 16, (q % 16) * 16 + r / 4]
  | p :: q :: r :: s :: t =>
      (p * 4 + q / 16) :: ((q % 16) * 16 + r / 4) :: ((r % 4) * 64 + s) :: ofB64 t

/-- Every group `toB64` produces is six bits wide. -/
theorem toB64_lt_64 : ∀ l : List Nat, (∀ b ∈ l, b < 256) → ∀ g ∈ toB64 l, g < 64
  | [], _ => by simp [toB64]
  | [a], h => by
    have ha : a < 256 := h a (by simp)
    intro g hg; simp only [toB64, List.mem_cons, List.not_mem_nil, or_false] at hg
    rcases hg with rfl | rfl <;> omega
  | [a, b], h => by
    have ha : a < 256 := h a (by simp)
    have hb : b < 256 := h b (by simp)
    intro g hg; simp only [toB64, List.mem_cons, List.not_mem_nil, or_false] at hg
    rcases hg with rfl | rfl | rfl <;> omega
  | a :: b :: c :: t, h => by
    have ha : a < 256 := h a (by simp)
    have hb : b < 256 := h b (by simp)
    have hc : c < 256 := h c (by simp)
    have ht : ∀ x ∈ t, x < 256 := fun x hx => h x (by simp [hx])
    intro g hg
    rw [toB64] at hg
    simp only [List.mem_cons] at hg
    rcases hg with rfl | rfl | rfl | rfl | hg
    · omega
    · omega
    · omega
    · omega
    · exact toB64_lt_64 t ht g hg

/-- **base64url is lossless** on bytes. -/
theorem ofB64_toB64 : ∀ l : List Nat, (∀ b ∈ l, b < 256) → ofB64 (toB64 l) = l
  | [], _ => rfl
  | [a], h => by
    have ha : a < 256 := h a (by simp)
    have : a / 4 * 4 + (a % 4) * 16 / 16 = a := by omega
    simp only [toB64, ofB64, List.cons.injEq, and_true]
    omega
  | [a, b], h => by
    have ha : a < 256 := h a (by simp)
    have hb : b < 256 := h b (by simp)
    simp only [toB64, ofB64, List.cons.injEq, and_true]
    constructor <;> omega
  | a :: b :: c :: t, h => by
    have ha : a < 256 := h a (by simp)
    have hb : b < 256 := h b (by simp)
    have hc : c < 256 := h c (by simp)
    have ht : ∀ x ∈ t, x < 256 := fun x hx => h x (by simp [hx])
    rw [toB64, ofB64, ofB64_toB64 t ht]
    simp only [List.cons.injEq, and_true]
    refine ⟨by omega, by omega, by omega⟩

/-- The alphabet the page uses, in order. -/
def b64Chars : List Char :=
  ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W',
   'X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t',
   'u','v','w','x','y','z','0','1','2','3','4','5','6','7','8','9','-','_']

/-- The alphabet as the page spells it. -/
def b64Alphabet : String := String.ofList b64Chars

/-- The character of a six-bit group. -/
def b64Char (n : Nat) : Char := b64Chars.getD n 'A'

/-- The six-bit group of a character (`0` on a character outside the alphabet, as the page
rejects those before it gets here). -/
def b64Val (c : Char) : Nat :=
  match b64Chars.findIdx? (fun d => d == c) with
  | some i => i
  | none => 0

set_option maxHeartbeats 1000000 in
/-- The alphabet is read back correctly. -/
theorem b64Val_b64Char : ∀ n < 64, b64Val (b64Char n) = n := by decide

/-- The text of a list of bytes. -/
def b64Text (bytes : List Nat) : String := String.ofList ((toB64 bytes).map b64Char)

/-- The bytes of a piece of text. -/
def b64Bytes (s : String) : List Nat := ofB64 (s.toList.map b64Val)

/-- **The text layer is lossless too.** -/
theorem b64Bytes_b64Text (l : List Nat) (h : ∀ b ∈ l, b < 256) : b64Bytes (b64Text l) = l := by
  have hmap : ((toB64 l).map b64Char).map b64Val = toB64 l := by
    rw [List.map_map]
    conv_rhs => rw [← List.map_id (toB64 l)]
    exact List.map_congr_left (fun g hg => b64Val_b64Char _ (toB64_lt_64 l h g hg))
  unfold b64Bytes b64Text
  rw [String.toList_ofList, hmap]
  exact ofB64_toB64 l h

/-! ## The level record

A level is a version byte, the length of its name, the bytes of the name, and then the
run-length code — base64url'd, which is what goes in the fragment of the URL. -/

/-- The bytes of a level record. -/
def levelBytes (name : List Nat) (rle : List Nat) : List Nat :=
  1 :: name.length :: (name ++ rle)

/-- The text in the fragment of a share link. -/
def levelCode (name : List Nat) (rle : List Nat) : String := b64Text (levelBytes name rle)

/-- Reading a share link: the name and the run-length code, or `none` if the text is not a
level of the version the page knows. -/
def decodeLevel (s : String) : Option (List Nat × List Nat) :=
  match b64Bytes s with
  | 1 :: n :: rest =>
      if rest.length < n + 2 ∨ (rest.length - n) % 2 = 1 then none
      else some (rest.take n, rest.drop n)
  | _ => none

/-- **A share link round-trips**: the text carries back the name and the code it was made
from. -/
theorem decodeLevel_levelCode (name rle : List Nat)
    (hn : ∀ b ∈ name, b < 256) (hr : ∀ b ∈ rle, b < 256)
    (hlen : name.length < 256) (hrle : 2 ≤ rle.length) (heven : rle.length % 2 = 0) :
    decodeLevel (levelCode name rle) = some (name, rle) := by
  have hb : ∀ b ∈ levelBytes name rle, b < 256 := by
    intro b hb
    simp only [levelBytes, List.mem_cons, List.mem_append] at hb
    rcases hb with rfl | rfl | hb
    · norm_num
    · exact hlen
    · rcases hb with hb | hb
      · exact hn b hb
      · exact hr b hb
  have hbytes : b64Bytes (levelCode name rle) = 1 :: name.length :: (name ++ rle) :=
    b64Bytes_b64Text _ hb
  have ht : (name ++ rle).take name.length = name := by simp
  have hd : (name ++ rle).drop name.length = rle := by simp
  unfold decodeLevel
  rw [hbytes]
  simp only [ht, hd, List.length_append]
  rw [if_neg (by push_neg; omega)]

/-- The bytes of a design's name: the page keeps at most 24 characters of plain ASCII. -/
def asciiName (s : String) : List Nat := (s.toList.map (fun c => c.toNat % 128)).take 24

theorem asciiName_lt_256 (s : String) : ∀ b ∈ asciiName s, b < 256 := by
  intro b hb
  obtain ⟨c, _, rfl⟩ := List.mem_map.1 (List.mem_of_mem_take hb)
  omega

theorem asciiName_length_lt_256 (s : String) : (asciiName s).length < 256 := by
  have : (asciiName s).length ≤ 24 := by simp [asciiName]
  omega

/-- The share text of a world: the whole pipeline, run-length code and all. -/
def shareOfWorld (name : List Nat) (world : List Nat) : String :=
  levelCode name (enc world)

/-- **The headline**: the text of a share link made from a world decodes back to that very
world, block by block. -/
theorem decodeLevel_shareOfWorld (name world : List Nat)
    (hn : ∀ b ∈ name, b < 256) (hlen : name.length < 256)
    (hw : IsWorld world) (hne : world ≠ []) :
    ∃ rle, decodeLevel (shareOfWorld name world) = some (name, rle) ∧ dec rle = some world := by
  refine ⟨enc world, ?_, dec_enc world hw⟩
  have hr : ∀ b ∈ enc world, b < 256 := enc_lt_256 world hw
  have h2 : 2 ≤ (enc world).length := by
    cases world with
    | nil => exact absurd rfl hne
    | cons v t => exact two_le_enc_length v t
  exact decodeLevel_levelCode name (enc world) hn hr hlen h2 (enc_length_even world)

/-! ## The shipped page -/

namespace Site

/-- The shipped page, read at build time. -/
def page : String := include_str "../../../projects/gvcs/web/voxel.html"

/-- The base64 of the WebAssembly runtime, as written next to it by
`tools/build_voxel.py`. -/
def wasmBase64 : String := include_str "../../../projects/gvcs/web/voxel-runtime.b64"

/-- How many times `needle` occurs in `s`. -/
def occurrences (s needle : String) : Nat := (s.splitOn needle).length - 1

/-- The page has exactly one script, and it is inline. -/
theorem page_single_script : occurrences page "<script" = 1 := by native_decide

/-- Nothing is fetched: no `src=` and no `href=` anywhere in the page, so it runs from a
phone's downloads folder, from a USB stick, or from any static host, offline. -/
theorem page_self_contained :
    occurrences page "src=" = 0 ∧ occurrences page "href=" = 0 := by native_decide

/-- The WebAssembly runtime is embedded in the page, exactly once. -/
theorem page_embeds_runtime : occurrences page wasmBase64 = 1 := by native_decide

/-- The page carries the codec proved above: the base64url alphabet, and both directions
of the level code. -/
theorem page_carries_the_codec :
    occurrences page b64Alphabet = 1
    ∧ 0 < occurrences page "function encodeLevel"
    ∧ 0 < occurrences page "function decodeLevel" := by native_decide

/-- The page carries the controls it advertises: a joystick, action buttons, an on-screen
keyboard, taps and swipes. -/
theorem page_carries_the_controls :
    0 < occurrences page "function attachInput"
    ∧ 0 < occurrences page "function buildKeyboard"
    ∧ 0 < occurrences page "onLongPress"
    ∧ 0 < occurrences page "pointerdown"
    ∧ 0 < occurrences page "id=\"stick\"" := by native_decide

/-- The page carries the editor, the renderer and the block palette. -/
theorem page_carries_the_game :
    0 < occurrences page "function drawScene"
    ∧ 0 < occurrences page "BOUNCE"
    ∧ 0 < occurrences page "LAVA"
    ∧ 0 < occurrences page "GLASS"
    ∧ 0 < occurrences page "window.VOXLAB" := by native_decide

end Site

/-! ## Audit -/

-- The mathematics: standard axioms only.
#print axioms dec_enc
#print axioms decodeLevel_shareOfWorld
-- The artifact audits additionally use compiled evaluation.
#print axioms Site.page_embeds_runtime

end Codec
end Voxel
end LifeTrac
