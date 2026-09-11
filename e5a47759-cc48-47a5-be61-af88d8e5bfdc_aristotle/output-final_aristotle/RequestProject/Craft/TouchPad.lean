import RequestProject.Craft.TouchStick

/-!
# Touch input, part 3: the customisable pad and its builder

A **pad** is what the player sees over the game on a phone: on-screen keys, a
joystick and a trackpad, each a rectangle somewhere on the screen.  The player
can rearrange it — that is the *builder* — so the interesting question is what
the builder is allowed to produce.

A `Layout` is **valid** for a screen when

* every widget has a distinct id,
* no two widgets overlap,
* every widget is fully on the screen, and
* every widget is at least `minTarget = 44` pixels on a side, the usual
  minimum size for something you hit with a finger.

`Layout.hitTest` is the page's hit test: the first widget whose rectangle
contains the touch.  With a valid layout it is proved *unambiguous*: whichever
widget contains the point is the widget you get.

The builder applies `Edit`s — add, remove, move, resize, rebind — and refuses
any edit that would break validity, so **every layout the builder can produce
is valid**.  A move can always be undone by the opposite move, and the
builder's undo stack is proved to be a real undo.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Touch

/-! ## Widgets and layouts -/

/-- What a widget does when you touch it. -/
inductive WidgetKind
  /-- an on-screen key sending a key code -/
  | key (code : String)
  /-- the analogue joystick -/
  | stick
  /-- the virtual mouse trackpad -/
  | trackpad
  /-- a button that fires a named macro -/
  | macroBtn (name : String)
deriving DecidableEq, Repr, Inhabited

/-- One control on the pad. -/
structure Widget where
  id : String
  kind : WidgetKind
  rect : Rect
deriving DecidableEq, Repr, Inhabited

/-- The pad: a list of controls, drawn and hit-tested in order. -/
structure Layout where
  widgets : List Widget
deriving DecidableEq, Repr, Inhabited

/-- The smallest side, in CSS pixels, a finger target may have. -/
def minTarget : Int := 44

/-- Is this control big enough to hit with a thumb? -/
def Widget.bigEnough (w : Widget) : Bool :=
  decide (minTarget ≤ w.rect.w) && decide (minTarget ≤ w.rect.h)

/-- Does `r` miss every rectangle in the list? -/
def missesAll (r : Rect) : List Widget → Bool
  | [] => true
  | w :: ws => !r.overlaps w.rect && missesAll r ws

/-- Do the widgets pairwise miss each other? -/
def pairwiseApart : List Widget → Bool
  | [] => true
  | w :: ws => missesAll w.rect ws && pairwiseApart ws

/-- The ids in a layout. -/
def Layout.ids (l : Layout) : List String := l.widgets.map (·.id)

/-- Every control fits on the screen, is big enough, no two overlap, and all
ids are distinct. -/
def Layout.valid (screen : Rect) (l : Layout) : Bool :=
  decide l.ids.Nodup && pairwiseApart l.widgets &&
  l.widgets.all (fun w => screen.inside w.rect && w.bigEnough)

/-- The page's hit test: the first control under the finger. -/
def Layout.hitTest (l : Layout) (p : Pt) : Option Widget :=
  l.widgets.find? (fun w => w.rect.contains p)

/-! ### The hit test -/

theorem Layout.hitTest_sound {l : Layout} {p : Pt} {w : Widget} (h : l.hitTest p = some w) :
    w ∈ l.widgets ∧ w.rect.contains p = true :=
  ⟨List.mem_of_find?_eq_some h, List.find?_some (p := fun v : Widget => v.rect.contains p) h⟩

theorem Layout.hitTest_eq_none_iff (l : Layout) (p : Pt) :
    l.hitTest p = none ↔ ∀ w ∈ l.widgets, w.rect.contains p = false := by
  rw [Layout.hitTest, List.find?_eq_none]
  constructor <;> intro h w hw
  · have hn := h w hw
    simp only [Bool.not_eq_true] at hn
    exact hn
  · rw [h w hw]
    simp

private theorem missesAll_mem {r : Rect} {ws : List Widget} {w : Widget}
    (h : missesAll r ws = true) (hw : w ∈ ws) : r.overlaps w.rect = false := by
  induction ws with
  | nil => cases hw
  | cons a as ih =>
    simp only [missesAll, Bool.and_eq_true, Bool.not_eq_true'] at h
    rcases List.mem_cons.mp hw with rfl | hw'
    · exact h.1
    · exact ih h.2 hw'

/-- The list-level statement: among pairwise-apart rectangles, `find?` finds
the one containing the point wherever it sits in the list. -/
private theorem find?_eq_of_apart {ws : List Widget} {p : Pt} {w : Widget}
    (hd : pairwiseApart ws = true) (hw : w ∈ ws) (hp : w.rect.contains p = true) :
    ws.find? (fun v => v.rect.contains p) = some w := by
  induction ws with
  | nil => cases hw
  | cons a as ih =>
    simp only [pairwiseApart, Bool.and_eq_true] at hd
    rcases List.mem_cons.mp hw with rfl | hw'
    · simp [hp]
    · by_cases ha : a.rect.contains p = true
      · exact absurd (Rect.overlaps_of_mem ha hp) (by simp [missesAll_mem hd.1 hw'])
      · simp only [Bool.not_eq_true] at ha
        simp [ha, ih hd.2 hw']

/-- **The hit test is unambiguous.**  In a layout whose controls do not
overlap, a touch inside a control finds exactly that control — no matter where
in the list it sits. -/
theorem Layout.hitTest_unique {l : Layout} {p : Pt} {w : Widget}
    (hd : pairwiseApart l.widgets = true) (hw : w ∈ l.widgets)
    (hp : w.rect.contains p = true) : l.hitTest p = some w :=
  find?_eq_of_apart hd hw hp

/-- In a valid layout every touch lands on at most one control. -/
theorem Layout.hit_at_most_one {screen : Rect} {l : Layout} {p : Pt} {w₁ w₂ : Widget}
    (hv : l.valid screen = true) (h1 : w₁ ∈ l.widgets) (h2 : w₂ ∈ l.widgets)
    (hp1 : w₁.rect.contains p = true) (hp2 : w₂.rect.contains p = true) : w₁ = w₂ := by
  have hd : pairwiseApart l.widgets = true := by
    simp only [Layout.valid, Bool.and_eq_true] at hv
    exact hv.1.2
  have e1 := Layout.hitTest_unique hd h1 hp1
  have e2 := Layout.hitTest_unique hd h2 hp2
  rw [e1] at e2
  exact Option.some.inj e2

/-- Every control of a valid layout is a finger-sized target inside the screen —
this is the mobile-friendliness condition, and it is what the builder enforces. -/
theorem Layout.valid_widget {screen : Rect} {l : Layout} {w : Widget}
    (hv : l.valid screen = true) (hw : w ∈ l.widgets) :
    screen.inside w.rect = true ∧ minTarget ≤ w.rect.w ∧ minTarget ≤ w.rect.h := by
  simp only [Layout.valid, Bool.and_eq_true, List.all_eq_true] at hv
  have := hv.2 w hw
  simp only [Bool.and_eq_true, Widget.bigEnough, decide_eq_true_eq] at this
  exact ⟨this.1, this.2.1, this.2.2⟩

/-! ## The builder -/

/-- The edits the builder interface offers. -/
inductive Edit
  | add (w : Widget)
  | remove (id : String)
  | move (id : String) (dx dy : Int)
  | resize (id : String) (dw dh : Int)
  | rebind (id : String) (k : WidgetKind)
deriving DecidableEq, Repr, Inhabited

/-- Apply `f` to the widget with this id. -/
def Layout.mapWidget (l : Layout) (id : String) (f : Widget → Widget) : Layout :=
  ⟨l.widgets.map (fun w => if w.id = id then f w else w)⟩

/-- Drop the widget with this id. -/
def Layout.removeId (l : Layout) (id : String) : Layout :=
  ⟨l.widgets.filter (fun w => !decide (w.id = id))⟩

/-- The edit as a pure rewrite of the layout, before any check. -/
def applyEditRaw (l : Layout) : Edit → Layout
  | .add w => ⟨l.widgets ++ [w]⟩
  | .remove id => l.removeId id
  | .move id dx dy => l.mapWidget id (fun w => { w with rect := w.rect.shift dx dy })
  | .resize id dw dh =>
      l.mapWidget id (fun w => { w with rect := ⟨w.rect.x, w.rect.y, w.rect.w + dw, w.rect.h + dh⟩ })
  | .rebind id k => l.mapWidget id (fun w => { w with kind := k })

/-- The builder's edit: apply it, and keep it only if the result is still a
valid pad. -/
def applyEdit (screen : Rect) (l : Layout) (e : Edit) : Option Layout :=
  let l' := applyEditRaw l e
  if l'.valid screen then some l' else none

/-- **Everything the builder produces is valid.** -/
theorem applyEdit_valid {screen : Rect} {l l' : Layout} {e : Edit}
    (h : applyEdit screen l e = some l') : l'.valid screen = true := by
  simp only [applyEdit] at h
  split at h
  · rename_i hv
    rw [Option.some.inj h] at hv
    exact hv
  · exact absurd h (by simp)

/-- A rejected edit changes nothing. -/
theorem applyEdit_eq_none {screen : Rect} {l : Layout} {e : Edit}
    (h : applyEdit screen l e = none) : (applyEditRaw l e).valid screen = false := by
  simp only [applyEdit] at h
  split at h
  · exact absurd h (by simp)
  · simpa using ‹¬((applyEditRaw l e).valid screen = true)›

@[simp] theorem Rect.shift_shift (r : Rect) (dx dy : Int) :
    (r.shift dx dy).shift (-dx) (-dy) = r := by
  simp only [Rect.shift]
  cases r
  simp

/-- **A move is undone by the opposite move**, widget for widget. -/
theorem move_undo (l : Layout) (id : String) (dx dy : Int) :
    applyEditRaw (applyEditRaw l (.move id dx dy)) (.move id (-dx) (-dy)) = l := by
  simp only [applyEditRaw, Layout.mapWidget, List.map_map]
  congr 1
  conv_rhs => rw [← List.map_id l.widgets]
  apply List.map_congr_left
  intro w _
  by_cases h : w.id = id
  · subst h; simp
  · simp [h]

/-- A resize is undone by the opposite resize. -/
theorem resize_undo (l : Layout) (id : String) (dw dh : Int) :
    applyEditRaw (applyEditRaw l (.resize id dw dh)) (.resize id (-dw) (-dh)) = l := by
  simp only [applyEditRaw, Layout.mapWidget, List.map_map]
  congr 1
  conv_rhs => rw [← List.map_id l.widgets]
  apply List.map_congr_left
  intro w _
  by_cases h : w.id = id
  · subst h; simp
  · simp [h]

/-- The builder interface: a screen, the pad being built, and the undo stack. -/
structure Builder where
  screen : Rect
  layout : Layout
  history : List Layout
deriving DecidableEq, Repr, Inhabited

/-- A builder is well formed when the pad it is showing, and every pad it can
undo back to, is valid. -/
def Builder.WF (b : Builder) : Prop :=
  b.layout.valid b.screen = true ∧ ∀ l ∈ b.history, l.valid b.screen = true

/-- Try an edit; a rejected edit leaves the builder alone. -/
def Builder.apply (b : Builder) (e : Edit) : Builder :=
  match applyEdit b.screen b.layout e with
  | some l => { b with layout := l, history := b.layout :: b.history }
  | none => b

/-- Step back to the previous pad. -/
def Builder.undo (b : Builder) : Builder :=
  match b.history with
  | [] => b
  | l :: hs => { b with layout := l, history := hs }

/-- **The builder can never show an invalid pad.** -/
theorem Builder.apply_wf {b : Builder} (hb : b.WF) (e : Edit) : (b.apply e).WF := by
  simp only [Builder.apply]
  split
  · rename_i l h
    refine ⟨applyEdit_valid h, ?_⟩
    intro m hm
    rcases List.mem_cons.mp hm with rfl | hm'
    · exact hb.1
    · exact hb.2 m hm'
  · exact hb

/-- Undo cannot break the pad either. -/
theorem Builder.undo_wf {b : Builder} (hb : b.WF) : b.undo.WF := by
  simp only [Builder.undo]
  split
  · exact hb
  · rename_i l hs h
    exact ⟨hb.2 l (by rw [h]; exact List.mem_cons_self), fun m hm => hb.2 m (by rw [h]; exact List.mem_cons_of_mem _ hm)⟩

/-- **Undo really undoes**: after an edit the builder takes, one undo returns it
exactly where it was. -/
theorem Builder.undo_apply (b : Builder) (e : Edit)
    (h : (applyEdit b.screen b.layout e).isSome = true) : (b.apply e).undo = b := by
  simp only [Builder.apply]
  cases hc : applyEdit b.screen b.layout e with
  | none => rw [hc] at h; exact absurd h (by simp)
  | some l => simp [Builder.undo]

/-- An edit the builder refuses leaves it completely unchanged. -/
theorem Builder.apply_rejected (b : Builder) (e : Edit)
    (h : applyEdit b.screen b.layout e = none) : b.apply e = b := by
  simp only [Builder.apply, h]

/-- Applying a whole session of edits. -/
def Builder.applyAll (b : Builder) (es : List Edit) : Builder :=
  es.foldl Builder.apply b

/-- **A whole editing session keeps the pad valid.** -/
theorem Builder.applyAll_wf {b : Builder} (hb : b.WF) (es : List Edit) : (b.applyAll es).WF := by
  induction es generalizing b with
  | nil => exact hb
  | cons e es ih => exact ih (Builder.apply_wf hb e)

/-! ## A default pad, and the proof that it is a good one -/

/-- A 390 × 844 phone screen — the common portrait size. -/
def phoneScreen : Rect := ⟨0, 0, 390, 844⟩

/-- The pad the page ships with: a joystick bottom left, a trackpad bottom
right, a row of keys and a row of macro buttons above them. -/
def defaultPad : Layout :=
  ⟨[ { id := "stick", kind := .stick, rect := ⟨16, 620, 150, 150⟩ },
     { id := "pad", kind := .trackpad, rect := ⟨224, 620, 150, 150⟩ },
     { id := "k-esc", kind := .key "Escape", rect := ⟨16, 490, 50, 50⟩ },
     { id := "k-tab", kind := .key "Tab", rect := ⟨72, 490, 50, 50⟩ },
     { id := "k-ctrl", kind := .key "Control", rect := ⟨128, 490, 50, 50⟩ },
     { id := "k-space", kind := .key " ", rect := ⟨184, 490, 50, 50⟩ },
     { id := "k-enter", kind := .key "Enter", rect := ⟨240, 490, 50, 50⟩ },
     { id := "k-shift", kind := .key "Shift", rect := ⟨296, 490, 50, 50⟩ },
     { id := "m-1", kind := .macroBtn "dig", rect := ⟨16, 546, 100, 50⟩ },
     { id := "m-2", kind := .macroBtn "refuel", rect := ⟨128, 546, 100, 50⟩ },
     { id := "m-3", kind := .macroBtn "home", rect := ⟨240, 546, 100, 50⟩ } ]⟩

/-- **The shipped pad is a valid, mobile-friendly pad**: distinct ids, no
overlaps, everything on a 390 × 844 screen, every target at least 44 px. -/
theorem defaultPad_valid : defaultPad.valid phoneScreen = true := by decide

/-- Two examples of the hit test on the shipped pad, computed by Lean. -/
example : (defaultPad.hitTest ⟨200, 660⟩).map (·.id) = none := by decide

example : (defaultPad.hitTest ⟨90, 700⟩).map (·.id) = some "stick" := by decide

end Touch
