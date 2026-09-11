import Mathlib

/-!
# Posts: what may become a link in a rendered write-up

The URL whitelist of `web/js/post.js`.  A post is Markdown-ish text written by
one person and read by another, so the address in `[label](url)` is not to be
trusted: only a scheme on the list is allowed through, and a URL that is not is
dropped altogether — the label survives as plain text and the address never
reaches the document.

What is proved:

* `safeHref_eq_some_iff` — a URL is accepted exactly when it starts with one of
  the allowed prefixes and is not a `javascript:` URL, and what comes back is
  the URL itself, unchanged;
* `safeHref_javascript` — a `javascript:` URL is never accepted, in any case
  mixture;
* `renderLink_of_unsafe` — a refused link renders as its label alone, so the
  address is not in the output;
* `renderLink_mem_allowed` — every `href` that does reach the document begins
  with an allowed prefix.
-/

namespace Hesper.Post

/-- The schemes and relative forms a link may use. -/
def allowedPrefixes : List String :=
  ["https://", "http://", "mailto:", "tel:", "#", "/", "./", "../"]

/-- Case-folded, so `JavaScript:` is caught as well as `javascript:`. -/
def isJavascript (u : String) : Bool := u.toLower.startsWith "javascript:"

/-- The URL, if the whitelist accepts it. -/
def safeHref (u : String) : Option String :=
  if (allowedPrefixes.any fun p => u.startsWith p) && !isJavascript u then some u else none

theorem safeHref_eq_some_iff {u v : String} :
    safeHref u = some v ↔
      v = u ∧ (∃ p ∈ allowedPrefixes, u.startsWith p) ∧ isJavascript u = false := by
  unfold safeHref
  constructor
  · intro h
    by_cases hc : (allowedPrefixes.any fun p => u.startsWith p) && !isJavascript u
    · simp only [hc, if_true] at h
      have hand := Bool.and_eq_true_iff.mp hc
      refine ⟨(Option.some_inj.mp h).symm, ?_, ?_⟩
      · simpa using List.any_eq_true.mp hand.1
      · simpa using hand.2
    · simp [hc] at h
  · rintro ⟨rfl, ⟨p, hp, hstart⟩, hjs⟩
    have hany : (allowedPrefixes.any fun p => v.startsWith p) = true :=
      List.any_eq_true.mpr ⟨p, hp, hstart⟩
    simp [hany, hjs]

/-- A `javascript:` URL is never accepted. -/
theorem safeHref_javascript {u : String} (h : isJavascript u = true) : safeHref u = none := by
  simp [safeHref, h]

/-- What is rendered for `[label](url)`. -/
def renderLink (label url : String) : String :=
  match safeHref url with
  | some href => "<a href=\"" ++ href ++ "\" target=\"_blank\" rel=\"noopener\">" ++ label ++ "</a>"
  | none => label

/-- A refused link is rendered as its label alone: the address is dropped. -/
theorem renderLink_of_unsafe {label url : String} (h : safeHref url = none) :
    renderLink label url = label := by
  simp [renderLink, h]

/-- In particular a `javascript:` URL never reaches the document. -/
theorem renderLink_javascript {label url : String} (h : isJavascript url = true) :
    renderLink label url = label :=
  renderLink_of_unsafe (safeHref_javascript h)

/-- Every address that does reach the document begins with an allowed prefix. -/
theorem renderLink_mem_allowed {url href : String} (h : safeHref url = some href) :
    ∃ p ∈ allowedPrefixes, href.startsWith p := by
  obtain ⟨rfl, hp, -⟩ := safeHref_eq_some_iff.mp h
  exact hp

end Hesper.Post
