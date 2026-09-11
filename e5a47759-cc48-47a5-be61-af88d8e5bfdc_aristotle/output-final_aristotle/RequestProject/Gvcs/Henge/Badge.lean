import Mathlib
import RequestProject.Gvcs.Henge.Share

/-!
# The badge: a screenshot you can read the save back out of

Every unlock in the game produces a picture.  The picture is an SVG, and the
save that produced it is written into the picture's `<desc>` element, length
first, so that the whole state can be recovered from the image alone.

* `badgeChars` — the picture.
* `readBadge` — the save recovered from a picture.
* `readBadge_badgeChars` — **the round trip**: a badge always reads back as the
  save it was drawn from, so a screenshot is a share code and a share code is a
  screenshot.
* `badge_shows_only_earned` — the badge names only badges the score has earned.

The drawing itself grows with the player: one more standing stone for every
badge earned.
-/

namespace LifeTrac
namespace Henge

/-! ## The frame -/

/-- Everything before the payload. -/
def badgeHead : List Char :=
  "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 320 200\"><desc>".toList

/-- How many badges a save has earned. -/
def tierOf (s : Save) : ℕ := (unlocked s).length

/-- The drawing, chosen by tier.  Closing the `<desc>` first, so the payload
sits inside it and the file stays well-formed. -/
def artFor : ℕ → String
  | 0 => "</desc><rect width=\"320\" height=\"200\" fill=\"#101020\"/>"
  | 1 => "</desc><rect width=\"320\" height=\"200\" fill=\"#101020\"/><rect x=\"40\" y=\"90\" width=\"18\" height=\"70\" fill=\"#9a9\"/>"
  | 2 => "</desc><rect width=\"320\" height=\"200\" fill=\"#141428\"/><rect x=\"40\" y=\"90\" width=\"18\" height=\"70\" fill=\"#9a9\"/><rect x=\"90\" y=\"90\" width=\"18\" height=\"70\" fill=\"#9a9\"/>"
  | 3 => "</desc><rect width=\"320\" height=\"200\" fill=\"#141428\"/><rect x=\"40\" y=\"90\" width=\"18\" height=\"70\" fill=\"#9a9\"/><rect x=\"90\" y=\"90\" width=\"18\" height=\"70\" fill=\"#9a9\"/><rect x=\"36\" y=\"78\" width=\"76\" height=\"14\" fill=\"#bbc\"/>"
  | 4 => "</desc><rect width=\"320\" height=\"200\" fill=\"#181832\"/><circle cx=\"160\" cy=\"120\" r=\"70\" fill=\"none\" stroke=\"#9a9\" stroke-width=\"8\"/>"
  | 5 => "</desc><rect width=\"320\" height=\"200\" fill=\"#181832\"/><circle cx=\"160\" cy=\"120\" r=\"70\" fill=\"none\" stroke=\"#9a9\" stroke-width=\"8\"/><circle cx=\"160\" cy=\"120\" r=\"26\" fill=\"none\" stroke=\"#fc6\" stroke-width=\"6\"/>"
  | 6 => "</desc><rect width=\"320\" height=\"200\" fill=\"#1c1c3c\"/><circle cx=\"160\" cy=\"120\" r=\"70\" fill=\"none\" stroke=\"#9a9\" stroke-width=\"8\"/><path d=\"M160 120 L160 70\" stroke=\"#fc6\" stroke-width=\"6\"/><path d=\"M160 120 L196 120\" stroke=\"#6cf\" stroke-width=\"6\"/>"
  | _ => "</desc><rect width=\"320\" height=\"200\" fill=\"#201038\"/><circle cx=\"160\" cy=\"120\" r=\"70\" fill=\"none\" stroke=\"#fc6\" stroke-width=\"8\"/><circle cx=\"160\" cy=\"120\" r=\"26\" fill=\"none\" stroke=\"#6cf\" stroke-width=\"6\"/><circle cx=\"60\" cy=\"40\" r=\"10\" fill=\"#ff6\"/><circle cx=\"260\" cy=\"46\" r=\"7\" fill=\"#6ff\"/>"

/-- The drawing, and the closing tag.  The drawing may say anything at all: the
payload is recovered from its own declared length, not from where the drawing
happens to end. -/
def badgeArt (s : Save) : List Char := (artFor (tierOf s)).toList ++ "</svg>".toList

/-! ## The payload -/

theorem bar_not_mem_natToChars (n : ℕ) : '|' ∉ natToChars n := by
  intro hmem
  have := natToChars_digit n _ hmem
  revert this
  decide

theorem bar_not_mem_shareCode (s : Save) : '|' ∉ shareCode s := by
  intro hmem
  unfold shareCode at hmem
  have hno : ∀ w ∈ (encodeSave s).map natToChars, '|' ∉ w := by
    intro w hw
    obtain ⟨n, _, rfl⟩ := List.mem_map.1 hw
    exact bar_not_mem_natToChars n
  -- a joined string only holds what its words and the separator hold
  have key : ∀ ws : List (List Char), (∀ w ∈ ws, '|' ∉ w) → '|' ∉ joinWith '.' ws := by
    intro ws
    induction ws with
    | nil => intro _; simp [joinWith]
    | cons w ws ih =>
        intro h
        cases ws with
        | nil => simpa [joinWith] using h w (by simp)
        | cons v vs =>
            rw [joinWith, List.mem_append]
            push_neg
            refine ⟨h w (by simp), ?_⟩
            simp only [List.mem_cons]
            push_neg
            refine ⟨by decide, ih (fun x hx => h x (by simp [hx]))⟩
            simp
  exact key _ hno hmem

/-! ## The badge -/

/-- The badge: frame, then the length of the code, a bar, the code, and the
drawing. -/
def badgeChars (s : Save) : List Char :=
  badgeHead ++ natToChars (shareCode s).length ++ '|' :: (shareCode s ++ badgeArt s)

/-- The save recovered from a badge. -/
def readBadge (l : List Char) : Option Save :=
  match splitOnChar '|' (l.drop badgeHead.length) with
  | lenCs :: rest :: _ => (charsToNat lenCs).bind (fun n => readShare (rest.take n))
  | _ => none

/-- **A badge reads back as the save it was drawn from.** -/
theorem readBadge_badgeChars (s : Save) : readBadge (badgeChars s) = some s := by
  have hdrop : (badgeChars s).drop badgeHead.length =
      natToChars (shareCode s).length ++ '|' :: (shareCode s ++ badgeArt s) := by
    unfold badgeChars
    rw [List.append_assoc, List.drop_left]
  have hsplit : splitOnChar '|' ((badgeChars s).drop badgeHead.length) =
      natToChars (shareCode s).length ::
        (shareCode s ++ (splitOnChar '|' (badgeArt s)).headI) ::
          (splitOnChar '|' (badgeArt s)).tail := by
    rw [hdrop, splitOnChar_append_sep _ _ (bar_not_mem_natToChars _),
      splitOnChar_append_no_sep _ _ (bar_not_mem_shareCode s)]
  unfold readBadge
  rw [hsplit]
  simp only [charsToNat_natToChars, Option.bind_some, List.take_left]
  exact readShare_shareCode s

/-- **The badge shows only what was earned.** -/
theorem badge_shows_only_earned (s : Save) : ∀ b ∈ unlocked s, b.need ≤ score s := by
  intro b hb
  rw [unlocked, List.mem_filter] at hb
  simpa using hb.2

/-- The tier a badge draws never falls as the play goes on. -/
theorem tierOf_run_mono {s t : Save} {ms : List Move} (h : run s ms = some t) :
    tierOf s ≤ tierOf t := by
  unfold tierOf unlocked
  rw [← List.countP_eq_length_filter, ← List.countP_eq_length_filter]
  refine List.countP_mono_left ?_
  intro b _ hbs
  have hmono := score_run_mono h
  have hbs' : b.need ≤ score s := by simpa using hbs
  simpa using le_trans hbs' hmono

end Henge
end LifeTrac
