import RequestProject.Gvcs.Rig.Blocks
import RequestProject.Gvcs.Web.Base64

/-!
# Share codes for designs

A design is sixty-four cells, each one of seven blocks, so it fits in a very
short string: two cells go into one base64 character (`7 × 7 = 49 < 64`), which
makes thirty-two characters, and a version prefix and a checksum character
bracket them.  A code is thirty-five characters long, survives being pasted
into a chat window, and is the whole of what a player has to send to a friend
for the friend to drive the same machine.

```
R1 QcQcQcQcQcQcQcQcAAAAAAAAAAAAAAAA k
│  └ thirty-two characters, two cells each   └ checksum
└ version
```

* `encodeDesign` / `decodeDesign` are the two directions;
* `decode_encode` is the round trip: what a friend pastes in is the machine
  that was sent, cell for cell;
* `decode_bad_version`, `decode_bad_length` and `decode_bad_checksum` say the
  reader refuses a code it should refuse — a mistyped character will not
  silently give a *different* machine.
-/

namespace LifeTrac
namespace Rig

open Web

/-! ## Cells to characters -/

/-- The cells of a design, in index order. -/
def cellsOf (d : Design) : List Nat := (List.range gridN).map d

theorem cellsOf_length (d : Design) : (cellsOf d).length = gridN := by
  simp [cellsOf]

theorem cellsOf_get {d : Design} {i : Nat} (hi : i < gridN) : (cellsOf d).getD i kEmpty = d i := by
  have : i < (cellsOf d).length := by rw [cellsOf_length]; exact hi
  rw [List.getD_eq_getElem _ _ this]
  simp [cellsOf]

theorem ofList_cellsOf {d : Design} {i : Nat} (hi : i < gridN) : ofList (cellsOf d) i = d i :=
  cellsOf_get hi

/-- Two cells to a number below `49`. -/
def packPairs : List Nat → List Nat
  | a :: b :: t => (a * 7 + b) :: packPairs t
  | [a] => [a * 7]
  | [] => []

/-- And back. -/
def unpackPairs : List Nat → List Nat
  | v :: t => (v / 7) :: (v % 7) :: unpackPairs t
  | [] => []

theorem packPairs_length : ∀ l : List Nat, 2 * (packPairs l).length = l.length + l.length % 2
  | [] => rfl
  | [_] => rfl
  | a :: b :: t => by
      have := packPairs_length t
      simp only [packPairs, List.length_cons]
      omega

theorem packPairs_lt : ∀ (l : List Nat), (∀ x ∈ l, x < 7) → ∀ v ∈ packPairs l, v < 49
  | [], _ => by simp [packPairs]
  | [a], h => by
      have ha := h a (by simp)
      simp only [packPairs, List.mem_singleton]
      intro v hv
      subst hv
      omega
  | a :: b :: t, h => by
      intro v hv
      simp only [packPairs, List.mem_cons] at hv
      rcases hv with rfl | hv
      · have ha := h a (by simp)
        have hb := h b (by simp)
        omega
      · exact packPairs_lt t (fun x hx => h x (by simp [hx])) v hv

theorem unpack_pack : ∀ (l : List Nat), (∀ x ∈ l, x < 7) → l.length % 2 = 0 →
    unpackPairs (packPairs l) = l
  | [], _, _ => rfl
  | [_], _, h => by simp at h
  | a :: b :: t, hx, hl => by
      have ha : a < 7 := hx a (by simp)
      have hb : b < 7 := hx b (by simp)
      have ht : unpackPairs (packPairs t) = t :=
        unpack_pack t (fun x hxx => hx x (by simp [hxx])) (by simp at hl; omega)
      simp only [packPairs, unpackPairs, ht]
      have h1 : (a * 7 + b) / 7 = a := by omega
      have h2 : (a * 7 + b) % 7 = b := by omega
      rw [h1, h2]

/-! ## The code -/

/-- The checksum character's value: everything added up, modulo the alphabet. -/
def shareSum (l : List Nat) : Nat := (l.sum + l.length) % 64

/-- The characters of a design's code. -/
def encodeChars (d : Design) : List Char :=
  let vals := packPairs (cellsOf d)
  'R' :: '1' :: (vals.map b64Char ++ [b64Char (shareSum vals)])

/-- **A design as a string.** -/
def encodeDesign (d : Design) : String := String.ofList (encodeChars d)

/-- The reader, on characters. -/
def decodeChars : List Char → Option Design
  | 'R' :: '1' :: rest =>
      if rest.length = 33 then
        let vals := (rest.take 32).map b64Val
        if (rest.drop 32).map b64Val = [shareSum vals] ∧ ∀ v ∈ vals, v < 49 then
          some (ofList (unpackPairs vals))
        else none
      else none
  | _ => none

/-- **A string as a design**, if it is a code at all. -/
def decodeDesign (s : String) : Option Design := decodeChars s.toList

/-! ## The round trip -/

theorem cellsOf_lt {d : Design} (hd : DesignOk d) : ∀ x ∈ cellsOf d, x < 7 := by
  intro x hx
  simp only [cellsOf, List.mem_map, List.mem_range] at hx
  obtain ⟨i, hi, rfl⟩ := hx
  exact hd i hi

theorem packPairs_cellsOf_length (d : Design) : (packPairs (cellsOf d)).length = 32 := by
  have h := packPairs_length (cellsOf d)
  rw [cellsOf_length] at h
  simp only [gridN, gridW, gridH, gridD] at h
  omega

/-- **A code reads back as the machine it was made from.**  Nothing about a
design is lost by sending it as thirty-five characters. -/
theorem decode_encode {d : Design} (hd : DesignOk d) :
    ∃ e, decodeDesign (encodeDesign d) = some e ∧ ∀ i < gridN, e i = d i := by
  set vals := packPairs (cellsOf d) with hvals
  have hlen : vals.length = 32 := packPairs_cellsOf_length d
  have hlt : ∀ v ∈ vals, v < 49 := packPairs_lt _ (cellsOf_lt hd)
  have hlt64 : ∀ v ∈ vals, v < 64 := fun v hv => lt_trans (hlt v hv) (by norm_num)
  set rest := vals.map b64Char ++ [b64Char (shareSum vals)] with hrest
  have hrestlen : rest.length = 33 := by simp [hrest, hlen]
  have htake : rest.take 32 = vals.map b64Char := by
    rw [hrest, List.take_left' (by simp [hlen])]
  have hdrop : rest.drop 32 = [b64Char (shareSum vals)] := by
    rw [hrest, List.drop_left' (by simp [hlen])]
  have hvalback : (rest.take 32).map b64Val = vals := by
    rw [htake, List.map_map]
    calc List.map (b64Val ∘ b64Char) vals
        = List.map id vals := List.map_congr_left fun v hv => b64Val_b64Char (hlt64 v hv)
      _ = vals := List.map_id vals
  have hsum : (rest.drop 32).map b64Val = [shareSum vals] := by
    rw [hdrop]
    simp only [List.map_cons, List.map_nil, List.cons.injEq, and_true]
    exact b64Val_b64Char (Nat.mod_lt _ (by norm_num))
  refine ⟨ofList (unpackPairs vals), ?_, ?_⟩
  · rw [decodeDesign, encodeDesign, String.toList_ofList, encodeChars]
    show decodeChars ('R' :: '1' :: rest) = _
    rw [decodeChars, if_pos hrestlen, hvalback, hsum, if_pos ⟨rfl, hlt⟩]
  · intro i hi
    have hup : unpackPairs vals = cellsOf d :=
      unpack_pack (cellsOf d) (cellsOf_lt hd) (by rw [cellsOf_length]; rfl)
    rw [hup]
    exact ofList_cellsOf hi

/-- A code with the wrong version prefix is refused. -/
theorem decode_bad_version {s : String} (h : ¬ ∃ r, s.toList = 'R' :: '1' :: r) :
    decodeDesign s = none := by
  unfold decodeDesign decodeChars
  split
  · next r heq => exact absurd ⟨r, heq⟩ h
  · rfl

/-- A code of the wrong length is refused. -/
theorem decode_bad_length {r : List Char} (h : r.length ≠ 33) :
    decodeChars ('R' :: '1' :: r) = none := by
  rw [decodeChars, if_neg h]

/-- A code whose checksum does not match is refused. -/
theorem decode_bad_checksum {r : List Char} (hlen : r.length = 33)
    (h : (r.drop 32).map b64Val ≠ [shareSum ((r.take 32).map b64Val)]) :
    decodeChars ('R' :: '1' :: r) = none := by
  rw [decodeChars, if_pos hlen, if_neg (by tauto)]

/-- Every code is thirty-five characters. -/
theorem encodeChars_length (d : Design) : (encodeChars d).length = 35 := by
  simp [encodeChars, packPairs_cellsOf_length d]

end Rig
end LifeTrac
