import Mathlib

/-!
# The markup sanitiser behind `svg { … }` layers

A hesper playbook travels inside a share link, so the markup in an `svg` layer
— and the URL in a `link` statement — is *untrusted input*: opening someone
else's rendering must not let their markup run anything.  `web/js/usercode.js`
therefore whitelists it, and this file is the formal statement of what that
whitelist guarantees.

The model is the tree the sanitiser works on, after parsing and before
rendering: a `Node` is text or an element with a tag, attributes and children
(`Forest` is a list of nodes, spelled as a mutual inductive so that the
recursion and the induction principle are the obvious structural ones).  Text,
attribute values and URLs are character lists, which is what the JavaScript
sanitiser walks.

What is proved:

* `okForest_sanitizeForest` — the output is always clean: every tag is
  whitelisted and every attribute is one the whitelist keeps unchanged;
* `tag_mem_safeTags`, `no_script`, `no_foreignObject` — no element outside the
  whitelist survives anywhere in the tree, in particular no `script`;
* `no_event_handler` — no surviving attribute's name begins with `on`;
* `attr_mem_safeAttrs`, `href_safe` — attributes are whitelisted, and every
  href-like value is a URL with a safe scheme, so never `javascript:`
  (`safeURL_javascript`);
* `sanitizeForest_idem` — sanitising twice is sanitising once, which is what
  lets the studio store the sanitised markup and sanitise again freely;
* `escapeText_no_lt`, `escapeAttr_no_quote`, `escapeHole_clean` — text,
  attribute values and interpolated `{…}` holes cannot close the construct they
  sit in, so they cannot introduce markup of their own.

The JavaScript twin is `web/js/usercode.js`; `tests/node/test_usercode.mjs`
tests it against these properties (including on 4000 random inputs), and
`tests/node/check_usercode.py` re-checks its output with an independent XML
parser.
-/

namespace Hesper.Markup

/-- SVG elements a playbook may use; anything else is dropped with its subtree. -/
def safeTags : List String :=
  ["g", "defs", "symbol", "title", "desc", "a",
   "path", "rect", "circle", "ellipse", "line", "polyline", "polygon",
   "text", "tspan", "textPath",
   "linearGradient", "radialGradient", "stop",
   "clipPath", "mask", "pattern", "marker"]

/-- Attributes that may appear on those elements. -/
def safeAttrs : List String :=
  ["id", "class", "transform", "opacity",
   "d", "points", "x", "y", "x1", "y1", "x2", "y2", "cx", "cy", "r", "rx", "ry",
   "width", "height", "dx", "dy", "offset", "rotate", "viewBox", "preserveAspectRatio",
   "fill", "fill-opacity", "fill-rule", "stroke", "stroke-width", "stroke-opacity",
   "stroke-linecap", "stroke-linejoin", "stroke-dasharray", "stroke-dashoffset",
   "stop-color", "stop-opacity", "gradientUnits", "gradientTransform", "spreadMethod",
   "patternUnits", "patternContentUnits", "clipPathUnits", "maskUnits",
   "markerWidth", "markerHeight", "refX", "refY", "orient",
   "font-size", "font-family", "font-weight", "font-style", "letter-spacing",
   "text-anchor", "dominant-baseline", "paint-order",
   "clip-path", "mask", "marker-end", "marker-start", "mix-blend-mode",
   "href", "xlink:href", "target", "aria-label", "role"]

/-- URL schemes a link may use, as character lists. -/
def safeSchemes : List (List Char) :=
  [['h','t','t','p'], ['h','t','t','p','s'], ['m','a','i','l','t','o'], ['t','e','l']]

/-- The attributes whose value is followed as a URL. -/
def hrefAttrs : List String := ["href", "xlink:href"]

/-- Control characters are removed everywhere: they only ever hide things. -/
def isControl (c : Char) : Bool := c.val < 32 || c.val == 127

/-- Drop every control character. -/
def stripControl (s : List Char) : List Char := s.filter (fun c => !isControl c)

/-- An event handler is any attribute whose name starts with `on`. -/
def isEventName (n : String) : Bool := n.toLower.startsWith "on"

/-- The characters before the first `:`, when there is one. -/
def schemeOf : List Char → Option (List Char)
  | [] => none
  | c :: cs => if c = ':' then some [] else (schemeOf cs).map (c :: ·)

/-- Characters that must never appear in a URL. -/
def isMarkupChar (c : Char) : Bool := c == '<' || c == '>' || c == '"' || c == '\''

/-- Is this (already stripped) string a URL the studio will follow? -/
def urlAllowed (t : List Char) : Bool :=
  !t.isEmpty && !t.any isMarkupChar &&
    (match t with
     | '#' :: _ => true
     | '/' :: _ => true
     | '.' :: _ => true
     | cs =>
       match schemeOf cs with
       | none => true
       | some sc => decide (sc.map Char.toLower ∈ safeSchemes))

/--
A URL, normalised, or `none` when it is not safe to follow: fragments,
relative paths and the whitelisted schemes are kept; everything else — in
particular `javascript:` and `data:` — is refused.
-/
def safeURL (s : List Char) : Option (List Char) :=
  if urlAllowed (stripControl s) then some (stripControl s) else none

/-- Keep an attribute only if it is whitelisted and its value is harmless. -/
def keepAttr (a : String × List Char) : Option (String × List Char) :=
  if isEventName a.1 then none
  else if a.1 ∈ safeAttrs then
    (if a.1 ∈ hrefAttrs then (safeURL a.2).map (fun u => (a.1, u))
     else if (stripControl a.2).any (fun c => c == '<' || c == '>') then none
     else some (a.1, stripControl a.2))
  else none

mutual

/-- A markup tree node: text, or an element with attributes and children. -/
inductive Node where
  | text (s : List Char) : Node
  | elem (tag : String) (attrs : List (String × List Char)) (kids : Forest) : Node

/-- The children of an element: a list of nodes. -/
inductive Forest where
  | nil : Forest
  | cons (n : Node) (rest : Forest) : Forest

end

mutual

/-- The sanitiser, on one node: `none` when the node is dropped outright. -/
def sanitizeNode : Node → Option Node
  | .text s => if (stripControl s).isEmpty then none else some (.text (stripControl s))
  | .elem tag attrs kids =>
    if tag ∈ safeTags then
      some (.elem tag (attrs.filterMap keepAttr) (sanitizeForest kids))
    else none

/-- The sanitiser, on a list of children. -/
def sanitizeForest : Forest → Forest
  | .nil => .nil
  | .cons n rest =>
    match sanitizeNode n with
    | some m => .cons m (sanitizeForest rest)
    | none => sanitizeForest rest

end

mutual

/-- What it means for a node to be clean already. -/
def okNode : Node → Bool
  | .text s => decide (stripControl s = s) && !s.isEmpty
  | .elem tag attrs kids =>
    decide (tag ∈ safeTags) && attrs.all (fun a => decide (keepAttr a = some a)) && okForest kids

/-- Every node of a forest is clean. -/
def okForest : Forest → Bool
  | .nil => true
  | .cons n rest => okNode n && okForest rest

end

mutual

/-- The `(tag, attributes)` of every element anywhere in a node. -/
def elemsNode : Node → List (String × List (String × List Char))
  | .text _ => []
  | .elem tag attrs kids => (tag, attrs) :: elemsForest kids

/-- The same, for a forest. -/
def elemsForest : Forest → List (String × List (String × List Char))
  | .nil => []
  | .cons n rest => elemsNode n ++ elemsForest rest

end

-- --------------------------------------------------------------- basic facts

@[simp] theorem stripControl_idem (s : List Char) :
    stripControl (stripControl s) = stripControl s := by
  simp [stripControl, List.filter_filter]

theorem safeURL_eq {s u : List Char} (h : safeURL s = some u) :
    u = stripControl s ∧ urlAllowed u = true := by
  unfold safeURL at h
  split at h
  · next hu => exact ⟨(Option.some_inj.mp h).symm, by rw [(Option.some_inj.mp h).symm]; exact hu⟩
  · exact absurd h (by simp)

theorem safeURL_idem {s u : List Char} (h : safeURL s = some u) : safeURL u = some u := by
  obtain ⟨rfl, hu⟩ := safeURL_eq h
  simp [safeURL, hu]

theorem keepAttr_fst {a b : String × List Char} (h : keepAttr a = some b) : b.1 = a.1 := by
  unfold keepAttr at h
  split_ifs at h with h1 h2 h3 h4
  · rcases hu : safeURL a.2 with _ | u
    · rw [hu] at h; exact absurd h (by simp)
    · rw [hu] at h; simp at h; rw [← h]
  · simp at h; rw [← h]

theorem keepAttr_idem {a b : String × List Char} (h : keepAttr a = some b) :
    keepAttr b = some b := by
  unfold keepAttr at h
  split_ifs at h with h1 h2 h3 h4
  · rcases hu : safeURL a.2 with _ | u
    · rw [hu] at h; exact absurd h (by simp)
    · rw [hu] at h
      simp only [Option.map_some, Option.some_inj] at h
      subst h
      simp only [keepAttr, if_neg h1, if_pos h2, if_pos h3, safeURL_idem hu, Option.map_some]
  · simp only [Option.some_inj] at h
    subst h
    simp only [keepAttr, if_neg h1, if_pos h2, if_neg h3, stripControl_idem, if_neg h4]

theorem keepAttr_not_event {a : String × List Char} (h : keepAttr a = some a) :
    isEventName a.1 = false := by
  unfold keepAttr at h
  split_ifs at h with h1 <;> simpa using h1

theorem keepAttr_mem_safeAttrs {a : String × List Char} (h : keepAttr a = some a) :
    a.1 ∈ safeAttrs := by
  unfold keepAttr at h
  split_ifs at h with h1 h2 <;> exact h2

theorem keepAttr_href {a : String × List Char} (h : keepAttr a = some a)
    (hh : a.1 ∈ hrefAttrs) : safeURL a.2 = some a.2 := by
  unfold keepAttr at h
  split_ifs at h with h1 h2
  rcases hu : safeURL a.2 with _ | u
  · rw [hu] at h; exact absurd h (by simp)
  · rw [hu] at h
    simp only [Option.map_some, Option.some_inj] at h
    have h2' : a.2 = u := (congrArg Prod.snd h).symm
    rw [h2'] at hu ⊢

theorem filterMap_keepAttr_eq (attrs : List (String × List Char))
    (h : ∀ a ∈ attrs, keepAttr a = some a) : attrs.filterMap keepAttr = attrs := by
  induction attrs with
  | nil => simp
  | cons a as ih =>
    rw [List.filterMap_cons, h a (by simp), ih (fun b hb => h b (by simp [hb]))]

-- ----------------------------------------------- the sanitiser is a whitelist

mutual

/-- Whatever the sanitiser returns for a node is clean. -/
theorem okNode_sanitizeNode : ∀ (n m : Node), sanitizeNode n = some m → okNode m = true
  | .text s, m, h => by
    unfold sanitizeNode at h
    split at h
    · exact absurd h (by simp)
    · next hne =>
      simp only [Option.some_inj] at h
      subst h
      simp [okNode, hne]
  | .elem tag attrs kids, m, h => by
    unfold sanitizeNode at h
    split at h
    · next htag =>
      simp only [Option.some_inj] at h
      subst h
      simp only [okNode, Bool.and_eq_true, decide_eq_true_eq, List.all_eq_true]
      refine ⟨⟨htag, ?_⟩, okForest_sanitizeForest kids⟩
      intro a ha
      obtain ⟨b, _, hb⟩ := List.mem_filterMap.mp ha
      simpa using keepAttr_idem hb
    · exact absurd h (by simp)

/-- Whatever the sanitiser returns for a forest is clean. -/
theorem okForest_sanitizeForest : ∀ (f : Forest), okForest (sanitizeForest f) = true
  | .nil => by simp [sanitizeForest, okForest]
  | .cons n rest => by
    unfold sanitizeForest
    rcases hn : sanitizeNode n with _ | m
    · simpa using okForest_sanitizeForest rest
    · simp only [okForest, Bool.and_eq_true]
      exact ⟨okNode_sanitizeNode n m hn, okForest_sanitizeForest rest⟩

end

-- ------------------------------------------------------------- what survives

mutual

/-- Every element inside a clean node has a whitelisted tag and clean attributes. -/
theorem elems_ok_of_okNode : ∀ (n : Node), okNode n = true →
    ∀ e ∈ elemsNode n, e.1 ∈ safeTags ∧ ∀ a ∈ e.2, keepAttr a = some a
  | .text s, _, e, he => by simp [elemsNode] at he
  | .elem tag attrs kids, h, e, he => by
    simp only [okNode, Bool.and_eq_true, decide_eq_true_eq, List.all_eq_true] at h
    obtain ⟨⟨htag, hattrs⟩, hkids⟩ := h
    simp only [elemsNode, List.mem_cons] at he
    rcases he with rfl | he
    · exact ⟨htag, fun a ha => by simpa using hattrs a ha⟩
    · exact elems_ok_of_okForest kids hkids e he

/-- Every element inside a clean forest has a whitelisted tag and clean attributes. -/
theorem elems_ok_of_okForest : ∀ (f : Forest), okForest f = true →
    ∀ e ∈ elemsForest f, e.1 ∈ safeTags ∧ ∀ a ∈ e.2, keepAttr a = some a
  | .nil, _, e, he => by simp [elemsForest] at he
  | .cons n rest, h, e, he => by
    simp only [okForest, Bool.and_eq_true] at h
    simp only [elemsForest, List.mem_append] at he
    rcases he with he | he
    · exact elems_ok_of_okNode n h.1 e he
    · exact elems_ok_of_okForest rest h.2 e he

end

/-- Every element of a sanitised tree has a whitelisted tag. -/
theorem tag_mem_safeTags (f : Forest) :
    ∀ e ∈ elemsForest (sanitizeForest f), e.1 ∈ safeTags :=
  fun _ he => (elems_ok_of_okForest _ (okForest_sanitizeForest f) _ he).1

/-- In particular a `script` element never survives. -/
theorem no_script (f : Forest) :
    ∀ e ∈ elemsForest (sanitizeForest f), e.1 ≠ "script" := by
  intro e he h
  have := tag_mem_safeTags f e he
  rw [h] at this
  simp [safeTags] at this

/-- Neither does `foreignObject`, the usual way to smuggle HTML into SVG. -/
theorem no_foreignObject (f : Forest) :
    ∀ e ∈ elemsForest (sanitizeForest f), e.1 ≠ "foreignObject" := by
  intro e he h
  have := tag_mem_safeTags f e he
  rw [h] at this
  simp [safeTags] at this

/-- No attribute of a sanitised tree is an event handler. -/
theorem no_event_handler (f : Forest) :
    ∀ e ∈ elemsForest (sanitizeForest f), ∀ a ∈ e.2, isEventName a.1 = false :=
  fun _ he a ha =>
    keepAttr_not_event ((elems_ok_of_okForest _ (okForest_sanitizeForest f) _ he).2 a ha)

/-- Every attribute of a sanitised tree is whitelisted. -/
theorem attr_mem_safeAttrs (f : Forest) :
    ∀ e ∈ elemsForest (sanitizeForest f), ∀ a ∈ e.2, a.1 ∈ safeAttrs :=
  fun _ he a ha =>
    keepAttr_mem_safeAttrs ((elems_ok_of_okForest _ (okForest_sanitizeForest f) _ he).2 a ha)

/-- Every href of a sanitised tree is a URL the studio is willing to follow. -/
theorem href_safe (f : Forest) :
    ∀ e ∈ elemsForest (sanitizeForest f), ∀ a ∈ e.2, a.1 ∈ hrefAttrs →
      safeURL a.2 = some a.2 :=
  fun _ he a ha hh =>
    keepAttr_href ((elems_ok_of_okForest _ (okForest_sanitizeForest f) _ he).2 a ha) hh

set_option maxRecDepth 8000 in
/-- A `javascript:` URL is never one of those. -/
theorem safeURL_javascript (rest : List Char) :
    safeURL (['j','a','v','a','s','c','r','i','p','t',':'] ++ rest) = none := by
  have hstrip : stripControl (['j','a','v','a','s','c','r','i','p','t',':'] ++ rest)
      = ['j','a','v','a','s','c','r','i','p','t',':'] ++ stripControl rest := by
    simp only [stripControl, List.filter_append]
    congr 1
  simp only [safeURL, hstrip]
  rw [if_neg (by simp [urlAllowed, schemeOf, safeSchemes])]

set_option maxRecDepth 8000 in
/-- Neither is a `data:` URL. -/
theorem safeURL_data (rest : List Char) :
    safeURL (['d','a','t','a',':'] ++ rest) = none := by
  have hstrip : stripControl (['d','a','t','a',':'] ++ rest)
      = ['d','a','t','a',':'] ++ stripControl rest := by
    simp only [stripControl, List.filter_append]
    congr 1
  simp only [safeURL, hstrip]
  rw [if_neg (by simp [urlAllowed, schemeOf, safeSchemes])]

-- ---------------------------------------------------------------- idempotence

mutual

/-- A clean node is left alone by the sanitiser. -/
theorem sanitizeNode_of_okNode : ∀ (n : Node), okNode n = true → sanitizeNode n = some n
  | .text s, h => by
    simp only [okNode, Bool.and_eq_true, decide_eq_true_eq, Bool.not_eq_true'] at h
    obtain ⟨hs, hne⟩ := h
    unfold sanitizeNode
    rw [hs, if_neg (by simpa using hne)]
  | .elem tag attrs kids, h => by
    simp only [okNode, Bool.and_eq_true, decide_eq_true_eq, List.all_eq_true] at h
    obtain ⟨⟨htag, hattrs⟩, hkids⟩ := h
    unfold sanitizeNode
    rw [if_pos htag, sanitizeForest_of_okForest kids hkids,
      filterMap_keepAttr_eq attrs (fun a ha => by simpa using hattrs a ha)]

/-- A clean forest is left alone by the sanitiser. -/
theorem sanitizeForest_of_okForest : ∀ (f : Forest), okForest f = true → sanitizeForest f = f
  | .nil, _ => by simp [sanitizeForest]
  | .cons n rest, h => by
    simp only [okForest, Bool.and_eq_true] at h
    unfold sanitizeForest
    rw [sanitizeNode_of_okNode n h.1, sanitizeForest_of_okForest rest h.2]

end

/-- Sanitising a second time changes nothing. -/
theorem sanitizeForest_idem (f : Forest) :
    sanitizeForest (sanitizeForest f) = sanitizeForest f :=
  sanitizeForest_of_okForest _ (okForest_sanitizeForest f)

-- ------------------------------------------------------------------ escaping

/-- Escape one character of a text node. -/
def escapeTextChar (c : Char) : List Char :=
  if c = '&' then ['&','a','m','p',';']
  else if c = '<' then ['&','l','t',';']
  else if c = '>' then ['&','g','t',';']
  else [c]

/-- Escape the text of a text node. -/
def escapeText (s : List Char) : List Char :=
  (stripControl s).flatMap escapeTextChar

/-- Escape one character of an attribute value. -/
def escapeAttrChar (c : Char) : List Char :=
  if c = '&' then ['&','a','m','p',';']
  else if c = '<' then ['&','l','t',';']
  else if c = '>' then ['&','g','t',';']
  else if c = '"' then ['&','q','u','o','t',';']
  else if c = '\'' then ['&','#','3','9',';']
  else [c]

theorem escapeTextChar_no_lt (c : Char) : '<' ∉ escapeTextChar c := by
  unfold escapeTextChar
  split_ifs with h1 h2 h3 <;> simp_all [eq_comm]

theorem escapeTextChar_no_gt (c : Char) : '>' ∉ escapeTextChar c := by
  unfold escapeTextChar
  split_ifs with h1 h2 h3 <;> simp_all [eq_comm]

theorem escapeAttrChar_no_lt (c : Char) : '<' ∉ escapeAttrChar c := by
  unfold escapeAttrChar
  split_ifs with h1 h2 h3 h4 h5 <;> simp_all [eq_comm]

theorem escapeAttrChar_no_quote (c : Char) : '"' ∉ escapeAttrChar c := by
  unfold escapeAttrChar
  split_ifs with h1 h2 h3 h4 h5 <;> simp_all [eq_comm]

/-- Escape an attribute value. -/
def escapeAttr (s : List Char) : List Char :=
  (stripControl s).flatMap escapeAttrChar

/-- Escaped text carries no `<`, so it cannot start an element. -/
theorem escapeText_no_lt (s : List Char) : '<' ∉ escapeText s := by
  intro h
  obtain ⟨c, _, hc⟩ := List.mem_flatMap.mp h
  exact escapeTextChar_no_lt c hc

/-- Nor a `>`, so it cannot close one either. -/
theorem escapeText_no_gt (s : List Char) : '>' ∉ escapeText s := by
  intro h
  obtain ⟨c, _, hc⟩ := List.mem_flatMap.mp h
  exact escapeTextChar_no_gt c hc

/-- An escaped attribute value carries no quote, so it cannot end the value. -/
theorem escapeAttr_no_quote (s : List Char) : '"' ∉ escapeAttr s := by
  intro h
  obtain ⟨c, _, hc⟩ := List.mem_flatMap.mp h
  exact escapeAttrChar_no_quote c hc

/-- Nor a `<`. -/
theorem escapeAttr_no_lt (s : List Char) : '<' ∉ escapeAttr s := by
  intro h
  obtain ⟨c, _, hc⟩ := List.mem_flatMap.mp h
  exact escapeAttrChar_no_lt c hc

/--
The value substituted for a `{…}` hole in markup: every character with any
power in markup is removed, so a hole can never re-open what the sanitiser
closed.
-/
def escapeHole (s : List Char) : List Char :=
  s.filter (fun c => !(c == '<' || c == '>' || c == '&' || c == '"' || c == '\'' || c == '\\'))

theorem escapeHole_clean (s : List Char) :
    ∀ c ∈ escapeHole s, c ≠ '<' ∧ c ≠ '>' ∧ c ≠ '&' ∧ c ≠ '"' ∧ c ≠ '\'' ∧ c ≠ '\\' := by
  intro c hc
  have := (List.mem_filter.mp hc).2
  simp only [Bool.not_eq_true', Bool.or_eq_false_iff, beq_eq_false_iff_ne] at this
  tauto

end Hesper.Markup
