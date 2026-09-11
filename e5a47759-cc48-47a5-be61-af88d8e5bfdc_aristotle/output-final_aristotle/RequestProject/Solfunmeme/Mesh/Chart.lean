import RequestProject.Solfunmeme.Mesh.Post

/-!
# Charts that are derived, not asserted

A chart in this game is never an image somebody drew: it is a *function of the
signed view*, computed in integer arithmetic so that the page, the phone and
the command line all produce the same pixels.  A reader who imports a card
re-runs this function and compares.

What is proved:

* `points_length` — one plotted point per reading, so no reading is dropped and
  none is invented;
* `mem_points` — every point plotted comes from a quote in the view;
* `x_le_width`, `y_le_height` — the drawing stays inside its box;
* `xOf_mono` — later readings are further right, so the time axis cannot be
  reordered to flatter a move;
* `yOf_of_price_low`, `yOf_of_price_high` — the extremes of the vertical axis
  are the lowest and highest price actually quoted, so the scale cannot be
  chosen to exaggerate;
* `points_of_message_eq` — **the chart is pinned by the signature**: two
  well-formed posts with the same signed text plot exactly the same chart.
-/

namespace Mesh.Chart

/-- The pixel box the chart is drawn in. -/
structure Geom where
  /-- Width in pixels. -/
  width : Nat
  /-- Height in pixels. -/
  height : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The slot window the view covers. -/
def slotSpan (v : View) : Nat := v.toSlot - v.fromSlot

/-- Lowest price quoted in the view. -/
def priceLow (v : View) : Nat := ((v.quotes.map Quote.price).min?).getD 0

/-- Highest price quoted in the view. -/
def priceHigh (v : View) : Nat := ((v.quotes.map Quote.price).max?).getD 0

/-- Horizontal position of a reading. -/
def xOf (g : Geom) (v : View) (q : Quote) : Nat :=
  if slotSpan v = 0 then 0 else min (q.slot - v.fromSlot) (slotSpan v) * g.width / slotSpan v

/-- Vertical position of a reading: prices grow upwards, so a high price is a
small `y`. -/
def yOf (g : Geom) (v : View) (q : Quote) : Nat :=
  if priceHigh v ≤ priceLow v then g.height / 2
  else g.height -
    min (q.price - priceLow v) (priceHigh v - priceLow v) * g.height / (priceHigh v - priceLow v)

/-- The polyline: one point per reading, in the order the view lists them. -/
def points (g : Geom) (v : View) : List (Nat × Nat) :=
  v.quotes.map (fun q => (xOf g v q, yOf g v q))

@[simp] theorem points_length (g : Geom) (v : View) : (points g v).length = v.quotes.length := by
  simp [points]

theorem mem_points {g : Geom} {v : View} {p : Nat × Nat} (h : p ∈ points g v) :
    ∃ q ∈ v.quotes, p = (xOf g v q, yOf g v q) := by
  simpa [points, eq_comm] using List.mem_map.mp h

theorem scaled_le {a s w : Nat} (h : a ≤ s) : a * w / s ≤ w := by
  rcases Nat.eq_zero_or_pos s with rfl | hs
  · simp
  · calc a * w / s ≤ s * w / s := Nat.div_le_div_right (Nat.mul_le_mul_right w h)
      _ = w := by rw [Nat.mul_comm, Nat.mul_div_cancel _ hs]

theorem x_le_width (g : Geom) (v : View) (q : Quote) : xOf g v q ≤ g.width := by
  unfold xOf
  split
  · exact Nat.zero_le _
  · exact scaled_le (Nat.min_le_right _ _)

theorem y_le_height (g : Geom) (v : View) (q : Quote) : yOf g v q ≤ g.height := by
  unfold yOf
  split
  · exact Nat.div_le_self _ _
  · exact Nat.sub_le _ _

/-- Time runs left to right. -/
theorem xOf_mono {g : Geom} {v : View} {q r : Quote} (h : q.slot ≤ r.slot) :
    xOf g v q ≤ xOf g v r := by
  unfold xOf
  split
  · exact Nat.le_refl _
  · exact Nat.div_le_div_right (Nat.mul_le_mul_right _
      (min_le_min (Nat.sub_le_sub_right h _) (Nat.le_refl _)))

/-- The bottom of the box is the lowest price quoted. -/
theorem yOf_of_price_low {g : Geom} {v : View} {q : Quote} (hq : q.price = priceLow v)
    (hlt : priceLow v < priceHigh v) : yOf g v q = g.height := by
  simp [yOf, Nat.not_le.mpr hlt, hq]

/-- The top of the box is the highest price quoted. -/
theorem yOf_of_price_high {g : Geom} {v : View} {q : Quote} (hq : q.price = priceHigh v)
    (hlt : priceLow v < priceHigh v) : yOf g v q = 0 := by
  have hspan : 0 < priceHigh v - priceLow v := by omega
  simp only [yOf, Nat.not_le.mpr hlt, if_false, hq, Nat.min_self]
  rw [Nat.mul_comm, Nat.mul_div_cancel _ hspan]
  omega

/-- **The chart is pinned by the signature.**  Posts that carry the same signed
text plot the same chart, so no viewer can be shown a curve the signer did not
sign. -/
theorem points_of_message_eq {g : Geom} {p q : Post} (hp : Mesh.wf p = true)
    (hq : Mesh.wf q = true) (h : message p = message q) :
    points g p.view = points g q.view := by
  rw [message_injective hp hq h]

/-! ## Rendering -/

open Senate.Wire in
/-- The polyline coordinates as SVG text. -/
def polyline (g : Geom) (v : View) : String :=
  String.intercalate " "
    ((points g v).map (fun p => natStr p.1 ++ "," ++ natStr p.2))

open Senate.Wire in
/-- The whole chart as a standalone SVG document. -/
def render (g : Geom) (v : View) : String :=
  "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 " ++ natStr g.width ++ " " ++
    natStr g.height ++ "\" width=\"" ++ natStr g.width ++ "\" height=\"" ++ natStr g.height ++
    "\"><rect width=\"100%\" height=\"100%\" fill=\"#0b0b14\"/><polyline fill=\"none\" " ++
    "stroke=\"#ff4fd8\" stroke-width=\"2\" points=\"" ++ polyline g v ++ "\"/></svg>"

/-- The rendering is a function of the signed view, so it too is pinned by the
signature. -/
theorem render_of_message_eq {g : Geom} {p q : Post} (hp : Mesh.wf p = true)
    (hq : Mesh.wf q = true) (h : message p = message q) :
    render g p.view = render g q.view := by
  rw [message_injective hp hq h]

end Mesh.Chart
