import RequestProject.Motion.Anim.Markup

/-!
# The drawing-command validator behind `script { … }` layers

A `script` layer runs the author's own JavaScript.  In the studio that code
runs inside a sandboxed iframe which cannot reach the page, and it is allowed
to speak back in exactly one language: a list of *drawing commands*.  The host
never trusts that list — `sanitizeDrawList` in `web/js/usercode.js` re-validates
it before anything enters a render list — and this file is the formal statement
of what that validation guarantees.

The model keeps the part of the validator that matters:

* `Raw` — a command as it arrives: an op name and a bag of optional fields
  (`none` stands for "absent, or not a finite number / not a string", which is
  what the JavaScript `finite`/`typeof` guards reject);
* `Item` — a validated render-list item, and `Item.Valid`, the invariant the
  backends rely on;
* `toItem` / `sanitizeList` — the validator itself.

What is proved:

* `sanitizeList_valid` — *every* item the validator returns satisfies the
  invariant, whatever the input: op in the whitelist, coordinates inside the
  frame's neighbourhood, stroke width in `[0.1, 200]`, opacity in `(0, 1]`,
  colour drawn from a restricted alphabet, text free of control characters and
  no longer than `maxText`;
* `sanitizeList_length_le` / `sanitizeList_length_le_maxItems` — the frame's
  render list cannot be flooded: a script contributes at most its own limit,
  and never more than `maxItems` items;
* `color_no_colon`, `color_no_quote`, `color_no_lt` — a validated colour can
  neither close the attribute it is written into nor name a scheme, so no
  `url(javascript:…)` and no attribute break-out;
* `toItem_toRaw` and `sanitizeList_idem` — validating an already validated list
  changes nothing, which is what lets the studio re-validate freely.
-/

namespace Hesper.UserDraw

open Hesper.Markup (isControl)

noncomputable section

/-- The drawing operations a script layer may ask for. -/
inductive Op
  | line | rect | circle | text
  deriving DecidableEq, Repr

/-- The op names, as they travel over the sandbox's message channel. -/
def opName : Op → List Char
  | .line => ['l','i','n','e']
  | .rect => ['r','e','c','t']
  | .circle => ['c','i','r','c','l','e']
  | .text => ['t','e','x','t']

/-- Recognise an op name; anything else is dropped. -/
def opOf (s : List Char) : Option Op :=
  if s = opName .line then some .line
  else if s = opName .rect then some .rect
  else if s = opName .circle then some .circle
  else if s = opName .text then some .text
  else none

@[simp] theorem opOf_opName (o : Op) : opOf (opName o) = some o := by
  cases o <;> simp [opOf, opName]

/--
A command as it comes back from a script layer.  Every field is optional:
`none` is what the JavaScript validator sees when a field is missing, is not a
finite number, or is not a string.
-/
structure Raw where
  /-- The requested operation. -/
  op : List Char
  /-- First abscissa (`x`, `x1` or `cx`). -/
  x : Option ℝ := none
  /-- First ordinate (`y`, `y1` or `cy`). -/
  y : Option ℝ := none
  /-- Second abscissa-like field (`x2`, `w`, or the radius of a circle). -/
  u : Option ℝ := none
  /-- Second ordinate-like field (`y2` or `h`). -/
  v : Option ℝ := none
  /-- Stroke width. -/
  width : Option ℝ := none
  /-- Opacity. -/
  opacity : Option ℝ := none
  /-- Colour (stroke or fill, depending on the op). -/
  color : Option (List Char) := none
  /-- The string of a `text` command. -/
  text : Option (List Char) := none

/-- A validated render-list item. -/
structure Item where
  /-- The operation. -/
  op : Op
  /-- First abscissa. -/
  x : ℝ
  /-- First ordinate. -/
  y : ℝ
  /-- Second abscissa-like field. -/
  u : ℝ
  /-- Second ordinate-like field. -/
  v : ℝ
  /-- Stroke width. -/
  width : ℝ
  /-- Opacity. -/
  opacity : ℝ
  /-- Colour. -/
  color : List Char
  /-- Text, empty for the geometric ops. -/
  text : List Char

-- ------------------------------------------------------------------ clamping

/-- Clamp a real into `[lo, hi]`, exactly as the JavaScript validator does. -/
def clampR (lo hi x : ℝ) : ℝ := min hi (max lo x)

theorem clampR_lower {lo hi x : ℝ} (h : lo ≤ hi) : lo ≤ clampR lo hi x :=
  le_min h (le_max_left _ _)

theorem clampR_upper (lo hi x : ℝ) : clampR lo hi x ≤ hi := min_le_left _ _

theorem clampR_eq_self {lo hi x : ℝ} (h1 : lo ≤ x) (h2 : x ≤ hi) : clampR lo hi x = x := by
  simp [clampR, max_eq_right h1, min_eq_right h2]

/-- The largest number of items one script layer may contribute to a frame. -/
def maxItems : ℕ := 4000

/-- The longest string a `text` command may draw. -/
def maxText : ℕ := 400

/-- The smallest stroke width the backends accept. -/
def minWidth : ℝ := 1 / 10

/-- The largest stroke width the backends accept. -/
def maxWidth : ℝ := 200

theorem minWidth_le_maxWidth : minWidth ≤ maxWidth := by
  unfold minWidth maxWidth; norm_num

-- ------------------------------------------------------------------- colours

/-- The alphabet a colour may be spelled with: no `:`, no quote, no angle bracket. -/
def isColorChar (c : Char) : Bool :=
  c.isAlphanum || c == '#' || c == '(' || c == ')' || c == ',' || c == '.' ||
    c == '%' || c == '-' || c == ' '

/-- A colour is accepted when it is short and spelled with that alphabet. -/
def colorOK (s : List Char) : Bool :=
  !s.isEmpty && decide (s.length ≤ 32) && s.all isColorChar

/-- The colour a command falls back to. -/
def defColor : List Char := ['#','7','a','d','7','f','f']

theorem colorOK_defColor : colorOK defColor = true := by decide

/-- Keep the author's colour when it is acceptable, otherwise the default. -/
def sanColor (v : Option (List Char)) : List Char :=
  match v with
  | some s => if colorOK s then s else defColor
  | none => defColor

theorem colorOK_sanColor (v : Option (List Char)) : colorOK (sanColor v) = true := by
  cases v with
  | none => exact colorOK_defColor
  | some s =>
    by_cases h : colorOK s
    · simp [sanColor, h]
    · simpa [sanColor, h] using colorOK_defColor

@[simp] theorem sanColor_of_ok {s : List Char} (h : colorOK s = true) : sanColor (some s) = s := by
  simp [sanColor, h]

-- ---------------------------------------------------------------------- text

/-- Control characters become spaces, and the string is cut to `maxText`. -/
def sanText (s : List Char) : List Char :=
  (s.map (fun c => if isControl c then ' ' else c)).take maxText

theorem sanText_length (s : List Char) : (sanText s).length ≤ maxText := by
  simp [sanText]

theorem sanText_clean (s : List Char) : ∀ c ∈ sanText s, isControl c = false := by
  intro c hc
  have hc' : c ∈ s.map (fun c => if isControl c then ' ' else c) :=
    List.mem_of_mem_take hc
  obtain ⟨d, _, rfl⟩ := List.mem_map.mp hc'
  by_cases hd : isControl d
  · rw [if_pos hd]; decide
  · rw [if_neg hd]; simpa using hd

theorem sanText_eq_self {s : List Char} (hlen : s.length ≤ maxText)
    (hclean : ∀ c ∈ s, isControl c = false) : sanText s = s := by
  have hmap : s.map (fun c => if isControl c then ' ' else c) = s :=
    (List.map_congr_left (fun c hc => by simp [hclean c hc])).trans (List.map_id s)
  rw [sanText, hmap, List.take_of_length_le hlen]

-- ---------------------------------------------------------------- the fields

/-- A coordinate: the author's number, or `0`, clamped into the frame's neighbourhood. -/
def coord (span : ℝ) (v : Option ℝ) : ℝ := clampR (-span) (2 * span) (v.getD 0)

/-- A non-negative extent, clamped into the frame. -/
def extent (span : ℝ) (v : Option ℝ) : ℝ := clampR 0 (2 * span) (v.getD 0)

/-- A radius, clamped generously. -/
def radius (w h : ℝ) (v : Option ℝ) : ℝ := clampR 0 (4 * max w h) (v.getD 4)

/-- A stroke width, clamped into `[minWidth, maxWidth]`. -/
def strokeWidth (v : Option ℝ) : ℝ := clampR minWidth maxWidth (v.getD 2)

/-- An opacity, clamped into `[0, 1]`. -/
def alpha (v : Option ℝ) : ℝ := clampR 0 1 (v.getD 1)

theorem coord_mem {span : ℝ} (hs : 0 ≤ span) (v : Option ℝ) :
    -span ≤ coord span v ∧ coord span v ≤ 2 * span :=
  ⟨clampR_lower (by linarith), clampR_upper _ _ _⟩

theorem extent_mem {span : ℝ} (hs : 0 ≤ span) (v : Option ℝ) :
    0 ≤ extent span v ∧ extent span v ≤ 2 * span :=
  ⟨clampR_lower (by linarith), clampR_upper _ _ _⟩

theorem radius_mem {w h : ℝ} (hw : 0 ≤ w) (v : Option ℝ) :
    0 ≤ radius w h v ∧ radius w h v ≤ 4 * max w h := by
  refine ⟨clampR_lower ?_, clampR_upper _ _ _⟩
  have : (0:ℝ) ≤ max w h := le_max_of_le_left hw
  linarith

theorem strokeWidth_mem (v : Option ℝ) :
    minWidth ≤ strokeWidth v ∧ strokeWidth v ≤ maxWidth :=
  ⟨clampR_lower minWidth_le_maxWidth, clampR_upper _ _ _⟩

theorem alpha_le_one (v : Option ℝ) : alpha v ≤ 1 := clampR_upper _ _ _

-- ----------------------------------------------------------- the invariant

/-- The invariant every item of a frame's render list satisfies. -/
def Item.Valid (w h : ℝ) (i : Item) : Prop :=
  (-w ≤ i.x ∧ i.x ≤ 2 * w) ∧ (-h ≤ i.y ∧ i.y ≤ 2 * h) ∧
  (match i.op with
   | .line => (-w ≤ i.u ∧ i.u ≤ 2 * w) ∧ (-h ≤ i.v ∧ i.v ≤ 2 * h) ∧ i.text = []
   | .rect => (0 ≤ i.u ∧ i.u ≤ 2 * w) ∧ (0 ≤ i.v ∧ i.v ≤ 2 * h) ∧ i.text = []
   | .circle => (0 ≤ i.u ∧ i.u ≤ 4 * max w h) ∧ i.v = 0 ∧ i.text = []
   | .text => i.text ≠ [] ∧ i.u = 0 ∧ i.v = 0) ∧
  (minWidth ≤ i.width ∧ i.width ≤ maxWidth) ∧
  (0 < i.opacity ∧ i.opacity ≤ 1) ∧
  colorOK i.color = true ∧
  i.text.length ≤ maxText ∧ (∀ c ∈ i.text, isControl c = false)

-- ------------------------------------------------------------ the validator

/-- Validate one command, or drop it. -/
def toItem (w h : ℝ) (c : Raw) : Option Item :=
  match opOf c.op with
  | none => none
  | some o =>
    if alpha c.opacity ≤ 0 then none
    else
      match o with
      | .line =>
        some { op := .line, x := coord w c.x, y := coord h c.y,
               u := coord w c.u, v := coord h c.v,
               width := strokeWidth c.width, opacity := alpha c.opacity,
               color := sanColor c.color, text := [] }
      | .rect =>
        some { op := .rect, x := coord w c.x, y := coord h c.y,
               u := extent w c.u, v := extent h c.v,
               width := strokeWidth c.width, opacity := alpha c.opacity,
               color := sanColor c.color, text := [] }
      | .circle =>
        some { op := .circle, x := coord w c.x, y := coord h c.y,
               u := radius w h c.u, v := 0,
               width := strokeWidth c.width, opacity := alpha c.opacity,
               color := sanColor c.color, text := [] }
      | .text =>
        let t := sanText (c.text.getD [])
        if t.isEmpty then none
        else
          some { op := .text, x := coord w c.x, y := coord h c.y, u := 0, v := 0,
                 width := strokeWidth c.width, opacity := alpha c.opacity,
                 color := sanColor c.color, text := t }

/-- Validate a whole list, keeping at most `min limit maxItems` items. -/
def sanitizeList (w h : ℝ) (limit : ℕ) (l : List Raw) : List Item :=
  (l.filterMap (toItem w h)).take (min limit maxItems)

theorem toItem_valid {w h : ℝ} (hw : 0 ≤ w) (hh : 0 ≤ h) {c : Raw} {i : Item}
    (hi : toItem w h c = some i) : i.Valid w h := by
  have hcol := colorOK_sanColor c.color
  have hwid := strokeWidth_mem c.width
  have hcx := coord_mem hw c.x
  have hcy := coord_mem hh c.y
  unfold toItem at hi
  rcases ho : opOf c.op with _ | o
  · rw [ho] at hi; exact absurd hi (by simp)
  · rw [ho] at hi
    simp only at hi
    split at hi
    · exact absurd hi (by simp)
    · next hpos =>
      have hop : 0 < alpha c.opacity := lt_of_not_ge hpos
      have hle := alpha_le_one c.opacity
      cases o with
      | line =>
        simp only [Option.some_inj] at hi
        subst hi
        exact ⟨hcx, hcy, ⟨coord_mem hw c.u, coord_mem hh c.v, rfl⟩, hwid, ⟨hop, hle⟩, hcol,
          by simp [maxText], by simp⟩
      | rect =>
        simp only [Option.some_inj] at hi
        subst hi
        exact ⟨hcx, hcy, ⟨extent_mem hw c.u, extent_mem hh c.v, rfl⟩, hwid, ⟨hop, hle⟩, hcol,
          by simp [maxText], by simp⟩
      | circle =>
        simp only [Option.some_inj] at hi
        subst hi
        exact ⟨hcx, hcy, ⟨radius_mem hw c.u, rfl, rfl⟩, hwid, ⟨hop, hle⟩, hcol,
          by simp [maxText], by simp⟩
      | text =>
        simp only at hi
        split at hi
        · exact absurd hi (by simp)
        · next hne =>
          simp only [Option.some_inj] at hi
          subst hi
          exact ⟨hcx, hcy, ⟨by simpa using hne, rfl, rfl⟩,
            hwid, ⟨hop, hle⟩, hcol, sanText_length _, sanText_clean _⟩

/-- Every item of a validated list satisfies the invariant. -/
theorem sanitizeList_valid {w h : ℝ} (hw : 0 ≤ w) (hh : 0 ≤ h) (limit : ℕ) (l : List Raw) :
    ∀ i ∈ sanitizeList w h limit l, i.Valid w h := by
  intro i hi
  obtain ⟨c, _, hc⟩ := List.mem_filterMap.mp (List.mem_of_mem_take hi)
  exact toItem_valid hw hh hc

/-- A script layer contributes at most the number of items it is allowed. -/
theorem sanitizeList_length_le (w h : ℝ) (limit : ℕ) (l : List Raw) :
    (sanitizeList w h limit l).length ≤ limit :=
  le_trans (List.length_take_le _ _) (min_le_left _ _)

/-- And never more than `maxItems`, whatever limit it asks for. -/
theorem sanitizeList_length_le_maxItems (w h : ℝ) (limit : ℕ) (l : List Raw) :
    (sanitizeList w h limit l).length ≤ maxItems :=
  le_trans (List.length_take_le _ _) (min_le_right _ _)

-- --------------------------------------------------------- colours are inert

theorem colorOK_mem {s : List Char} (h : colorOK s = true) :
    ∀ c ∈ s, isColorChar c = true := by
  simp only [colorOK, Bool.and_eq_true, List.all_eq_true] at h
  exact h.2

theorem isColorChar_ne {c : Char} (h : isColorChar c = true) :
    c ≠ ':' ∧ c ≠ '"' ∧ c ≠ '\'' ∧ c ≠ '<' ∧ c ≠ '>' := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> rintro rfl <;> simp [isColorChar] at h

/-- A validated colour can never name a scheme: it has no `:`. -/
theorem color_no_colon {w h : ℝ} {i : Item} (hi : i.Valid w h) : ':' ∉ i.color :=
  fun hc => (isColorChar_ne (colorOK_mem hi.2.2.2.2.2.1 _ hc)).1 rfl

/-- Nor can it end the attribute it is written into. -/
theorem color_no_quote {w h : ℝ} {i : Item} (hi : i.Valid w h) : '"' ∉ i.color :=
  fun hc => (isColorChar_ne (colorOK_mem hi.2.2.2.2.2.1 _ hc)).2.1 rfl

/-- Nor open an element of its own. -/
theorem color_no_lt {w h : ℝ} {i : Item} (hi : i.Valid w h) : '<' ∉ i.color :=
  fun hc => (isColorChar_ne (colorOK_mem hi.2.2.2.2.2.1 _ hc)).2.2.2.1 rfl

-- ---------------------------------------------------------------- idempotence

/-- Send a validated item back through the sandbox's message format. -/
def toRaw (i : Item) : Raw :=
  { op := opName i.op, x := some i.x, y := some i.y, u := some i.u, v := some i.v,
    width := some i.width, opacity := some i.opacity, color := some i.color,
    text := some i.text }

theorem toItem_toRaw {w h : ℝ} : ∀ {i : Item}, i.Valid w h → toItem w h (toRaw i) = some i := by
  rintro ⟨op, x, y, u, v, wd, al, col, txt⟩ hi
  obtain ⟨⟨hx1, hx2⟩, ⟨hy1, hy2⟩, hop, ⟨hw1, hw2⟩, ⟨ha1, ha2⟩, hcol, hlen, hclean⟩ := hi
  simp only at hx1 hx2 hy1 hy2 hop hw1 hw2 ha1 ha2 hcol hlen hclean
  have hxe : coord w (some x) = x := clampR_eq_self hx1 hx2
  have hye : coord h (some y) = y := clampR_eq_self hy1 hy2
  have hwe : strokeWidth (some wd) = wd := clampR_eq_self hw1 hw2
  have hae : alpha (some al) = al := clampR_eq_self ha1.le ha2
  have hpos : ¬ (al ≤ 0) := not_le.mpr ha1
  cases op with
  | line =>
    obtain ⟨⟨hu1, hu2⟩, ⟨hv1, hv2⟩, ht⟩ := hop
    have hue : coord w (some u) = u := clampR_eq_self hu1 hu2
    have hve : coord h (some v) = v := clampR_eq_self hv1 hv2
    simp [toItem, toRaw, opOf_opName, hxe, hye, hwe, hae, hpos, ht, hue, hve,
      sanColor_of_ok hcol]
  | rect =>
    obtain ⟨⟨hu1, hu2⟩, ⟨hv1, hv2⟩, ht⟩ := hop
    have hue : extent w (some u) = u := clampR_eq_self hu1 hu2
    have hve : extent h (some v) = v := clampR_eq_self hv1 hv2
    simp [toItem, toRaw, opOf_opName, hxe, hye, hwe, hae, hpos, ht, hue, hve,
      sanColor_of_ok hcol]
  | circle =>
    obtain ⟨⟨hu1, hu2⟩, hv, ht⟩ := hop
    have hue : radius w h (some u) = u := clampR_eq_self hu1 hu2
    simp [toItem, toRaw, opOf_opName, hxe, hye, hwe, hae, hpos, ht, hv, hue,
      sanColor_of_ok hcol]
  | text =>
    obtain ⟨ht, hu, hv⟩ := hop
    have hte : sanText txt = txt := sanText_eq_self hlen hclean
    simp [toItem, toRaw, opOf_opName, hxe, hye, hwe, hae, hpos, hu, hv, hte, ht,
      sanColor_of_ok hcol]

theorem filterMap_map_toRaw {w h : ℝ} (L : List Item) (hv : ∀ i ∈ L, i.Valid w h) :
    (L.map toRaw).filterMap (toItem w h) = L := by
  induction L with
  | nil => simp
  | cons a as ih =>
    rw [List.map_cons, List.filterMap_cons, toItem_toRaw (hv a (by simp)),
      ih (fun i hi => hv i (by simp [hi]))]

/-- Validating an already validated list changes nothing. -/
theorem sanitizeList_idem {w h : ℝ} (hw : 0 ≤ w) (hh : 0 ≤ h) (limit : ℕ) (l : List Raw) :
    sanitizeList w h limit ((sanitizeList w h limit l).map toRaw)
      = sanitizeList w h limit l := by
  have hlen : (sanitizeList w h limit l).length ≤ min limit maxItems :=
    List.length_take_le _ _
  rw [sanitizeList, filterMap_map_toRaw _ (sanitizeList_valid hw hh limit l),
    List.take_of_length_le hlen]

end

end Hesper.UserDraw
