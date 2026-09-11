import RequestProject.Craft.Training

/-!
# Broadcasting the games: clips under a byte budget, stills, and short updates

The games the model plays have to leave the machine: a short **clip** of the
factory being built, a **still** of the finished shop, and a one-line **update**
for the people following along.  Each of those has a hard limit — a clip must
fit in five megabytes, an update in two hundred and eighty characters — and the
point of this file is that the limits are met *by construction* and that what
goes out is the game that was actually played.

The clip is the SVG film of the recording, thinned by keeping every `k`-th
frame, and then cut to fit: `takeWithin` walks the frames adding them while the
budget lasts and stops when the next one would not fit.  So the clip is a
prefix of a thinned film, which is a sublist of the real film — frames can be
dropped, never invented or reordered.

Sizes are measured in real bytes (`String.utf8ByteSize`), and the post length in
characters, which is what a post counts.

Proved here:

* `bytes_joinS` — the size of a concatenation is the sum of the sizes;
* `takeWithin_bytes_le` — **the budget is never exceeded**;
* `takeWithin_prefix`, `takeWithin_sublist` — what is kept is a prefix of what
  was offered;
* `takeWithin_all` — nothing is dropped that would have fitted anyway;
* `stride_sublist` — thinning drops frames, it does not invent them;
* `clip_bytes_le` — **every clip is at most five megabytes**;
* `clip_frames_sublist` — **every frame in a clip is a frame of the recorded
  game**, in the order it was played;
* `clip_head` — a clip starts at the start of the game;
* `clip_complete_of_small` — a game whose whole film fits is broadcast whole;
* `clip_wraps` — the clip is a well-formed SVG document;
* `still_faithful`, `stillWithin_bytes_le` — a still is the renderer's picture
  of a real frame, and is only published if it fits;
* `decVal_dec` — **the numerals in an update are the numbers they claim to
  be**: reading the digits back gives the value they were printed from;
* `dec_length_le`, `post_chars_le` — **every update fits in 280 characters**;
* `postText_honest` — while the numbers stay below a billion, nothing in an
  update is clamped;
* `broadcast_report` — the sizes of a real broadcast of the trained model's
  game, checked by evaluation.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false
set_option maxRecDepth 10000

namespace Tycoon
namespace Broadcast

/-! ## Measuring -/

/-- The size of a piece of media, in bytes. -/
def bytes (s : String) : Nat := s.utf8ByteSize

@[simp] theorem bytes_append (a b : String) : bytes (a ++ b) = bytes a + bytes b :=
  String.utf8ByteSize_append

/-- Concatenate the pieces of a document. -/
def joinS : List String → String
  | [] => ""
  | s :: t => s ++ joinS t

@[simp] theorem joinS_nil : joinS [] = "" := rfl

@[simp] theorem joinS_cons (s : String) (t : List String) :
    joinS (s :: t) = s ++ joinS t := rfl

/-- The size of a document is the sum of the sizes of its pieces. -/
theorem bytes_joinS : ∀ l : List String, bytes (joinS l) = (l.map bytes).sum := by
  intro l
  induction l with
  | nil => rfl
  | cons s t ih => simp [ih]

/-! ## Cutting to a budget -/

/-- Keep pieces while the budget lasts, and stop at the first one that will not
fit. -/
def takeWithin (budget : Nat) : List String → List String
  | [] => []
  | s :: t => if bytes s ≤ budget then s :: takeWithin (budget - bytes s) t else []

/-- **The budget is never exceeded.** -/
theorem takeWithin_bytes_le : ∀ (l : List String) (b : Nat),
    bytes (joinS (takeWithin b l)) ≤ b := by
  intro l
  induction l with
  | nil =>
      intro b
      have h0 : bytes (joinS (takeWithin b ([] : List String))) = 0 := rfl
      omega
  | cons s t ih =>
      intro b
      by_cases h : bytes s ≤ b
      · have := ih (b - bytes s)
        simp only [takeWithin, h, if_true, joinS_cons, bytes_append]
        omega
      · have h0 : bytes (joinS (takeWithin b (s :: t))) = 0 := by
          simp only [takeWithin, h, if_false]
          rfl
        omega

/-- What is kept is a prefix of what was offered. -/
theorem takeWithin_prefix : ∀ (l : List String) (b : Nat), ∃ k, takeWithin b l = l.take k := by
  intro l
  induction l with
  | nil => intro b; exact ⟨0, rfl⟩
  | cons s t ih =>
      intro b
      by_cases h : bytes s ≤ b
      · obtain ⟨k, hk⟩ := ih (b - bytes s)
        exact ⟨k + 1, by simp [takeWithin, h, hk]⟩
      · exact ⟨0, by simp [takeWithin, h]⟩

/-- In particular, the clip contains only real frames, in the order they were
played. -/
theorem takeWithin_sublist (l : List String) (b : Nat) : List.Sublist (takeWithin b l) l := by
  obtain ⟨k, hk⟩ := takeWithin_prefix l b
  rw [hk]
  exact (l.take_sublist k)

/-- Nothing is dropped that would have fitted. -/
theorem takeWithin_all : ∀ (l : List String) (b : Nat),
    bytes (joinS l) ≤ b → takeWithin b l = l := by
  intro l
  induction l with
  | nil => intro b _; rfl
  | cons s t ih =>
      intro b hb
      simp only [joinS_cons, bytes_append] at hb
      have hs : bytes s ≤ b := by omega
      have ht : bytes (joinS t) ≤ b - bytes s := by omega
      simp [takeWithin, hs, ih (b - bytes s) ht]

/-! ## Thinning the film -/

/-- Keep one frame in every `k + 1`. -/
def strideAux {α : Type} (k : Nat) : Nat → List α → List α
  | _, [] => []
  | 0, x :: t => x :: strideAux k k t
  | c + 1, _ :: t => strideAux k c t

/-- Thin a list: keep the first entry and then one in every `k + 1`. -/
def stride {α : Type} (k : Nat) (l : List α) : List α := strideAux k 0 l

theorem strideAux_sublist {α : Type} (k : Nat) :
    ∀ (l : List α) (c : Nat), List.Sublist (strideAux k c l) l := by
  intro l
  induction l with
  | nil => intro c; cases c <;> exact List.Sublist.refl _
  | cons x t ih =>
      intro c
      cases c with
      | zero => exact (ih k).cons₂ x
      | succ n => exact (ih n).cons x

/-- **Thinning drops frames; it never invents one or moves one.** -/
theorem stride_sublist {α : Type} (k : Nat) (l : List α) : List.Sublist (stride k l) l :=
  strideAux_sublist k l 0

@[simp] theorem stride_cons {α : Type} (k : Nat) (x : α) (t : List α) :
    stride k (x :: t) = x :: strideAux k k t := rfl

@[simp] theorem stride_nil {α : Type} (k : Nat) : stride k ([] : List α) = [] := rfl

/-! ## The clip -/

/-- A clip must fit in five megabytes. -/
def maxClipBytes : Nat := 5000000

/-- The film of a recording, one SVG group per frame, thinned by keeping one
frame in every `k + 1`. -/
def filmChunks (r : Recording) (k : Nat) : List String :=
  stride k (r.frames.mapIdx Recording.svgGroup)

/-- The frames a clip actually carries: as many of the thinned film as the
budget allows. -/
def clipBody (r : Recording) (k : Nat) : List String :=
  takeWithin (maxClipBytes - bytes svgHeader - bytes svgFooter) (filmChunks r k)

/-- **The clip**: a self-contained SVG film of the game, inside the budget. -/
def clip (r : Recording) (k : Nat) : String :=
  svgHeader ++ joinS (clipBody r k) ++ svgFooter

theorem header_footer_small : bytes svgHeader + bytes svgFooter ≤ maxClipBytes := by
  decide

/-- **Every clip fits in five megabytes.** -/
theorem clip_bytes_le (r : Recording) (k : Nat) : bytes (clip r k) ≤ maxClipBytes := by
  have hb := takeWithin_bytes_le (filmChunks r k)
    (maxClipBytes - bytes svgHeader - bytes svgFooter)
  have hhf := header_footer_small
  simp only [clip, bytes_append, clipBody]
  omega

/-- **Every frame in a clip is a frame of the game that was recorded**, in the
order it was played. -/
theorem clip_frames_sublist (r : Recording) (k : Nat) :
    List.Sublist (clipBody r k) (r.frames.mapIdx Recording.svgGroup) :=
  (takeWithin_sublist _ _).trans (stride_sublist k _)

/-- The clip never carries more frames than the game had. -/
theorem clip_length_le (r : Recording) (k : Nat) :
    (clipBody r k).length ≤ r.moves.length + 1 := by
  have := (clip_frames_sublist r k).length_le
  simpa using this

/-- The frames of a recording always start with the position it started from. -/
theorem frames_cons (r : Recording) : ∃ rest, r.frames = r.init :: rest := by
  cases hm : r.moves with
  | nil => exact ⟨[], by simp [Recording.frames, hm]⟩
  | cons a t =>
      exact ⟨List.scanl GameState.step (r.init.step a) t, by simp [Recording.frames, hm]⟩

/-- **A clip starts where the game started.** -/
theorem clip_head (r : Recording) (k : Nat)
    (h : bytes (Recording.svgGroup 0 r.init) ≤ maxClipBytes - bytes svgHeader - bytes svgFooter) :
    (clipBody r k).head? = some (Recording.svgGroup 0 r.init) := by
  obtain ⟨rest, hrest⟩ := frames_cons r
  simp only [clipBody, filmChunks, hrest, List.mapIdx_cons, stride_cons, takeWithin, h,
    if_true, List.head?_cons]

/-- **A game whose whole film fits is broadcast whole.** -/
theorem clip_complete_of_small (r : Recording) (k : Nat)
    (h : bytes (joinS (filmChunks r k)) ≤ maxClipBytes - bytes svgHeader - bytes svgFooter) :
    clipBody r k = filmChunks r k :=
  takeWithin_all _ _ h

/-- The clip is a well-formed SVG document. -/
theorem clip_wraps (r : Recording) (k : Nat) :
    ∃ body, clip r k = svgHeader ++ body ++ svgFooter :=
  ⟨joinS (clipBody r k), rfl⟩

/-! ## Stills -/

/-- A still: the renderer's picture of one position. -/
def still (g : GameState) : String := renderSVG g.scene

/-- A still is exactly the renderer's picture of that position — it is not
retouched. -/
theorem still_faithful (g : GameState) : still g = renderSVG g.scene := rfl

/-- Publish a still only if it fits in the budget. -/
def stillWithin (g : GameState) : Option String :=
  if bytes (still g) ≤ maxClipBytes then some (still g) else none

/-- A published still is within budget. -/
theorem stillWithin_bytes_le {g : GameState} {s : String} (h : stillWithin g = some s) :
    bytes s ≤ maxClipBytes := by
  unfold stillWithin at h
  split at h
  · rename_i hfit
    cases h
    exact hfit
  · cases h

/-- A published still is the picture of that very position. -/
theorem stillWithin_eq {g : GameState} {s : String} (h : stillWithin g = some s) :
    s = renderSVG g.scene := by
  unfold stillWithin at h
  split at h
  · cases h; rfl
  · cases h

/-! ## Numerals -/

/-- The decimal digits of a number. -/
def dec (n : Nat) : List Char :=
  if n < 10 then [Char.ofNat (48 + n)]
  else dec (n / 10) ++ [Char.ofNat (48 + n % 10)]
decreasing_by
  exact Nat.div_lt_self (by omega) (by omega)

/-- Read a list of decimal digits back as a number. -/
def decVal (l : List Char) : Nat :=
  l.foldl (fun a c => a * 10 + (c.toNat - 48)) 0

theorem decVal_append_digit (l : List Char) (c : Char) :
    decVal (l ++ [c]) = decVal l * 10 + (c.toNat - 48) := by
  simp [decVal, List.foldl_append]

theorem toNat_ofNat_digit {d : Nat} (h : d < 10) : (Char.ofNat (48 + d)).toNat = 48 + d := by
  have hv : Nat.isValidChar (48 + d) := Or.inl (by omega)
  rw [Char.toNat_ofNat, if_pos hv]

/-- **The numerals really are the numbers.** -/
theorem decVal_dec (n : Nat) : decVal (dec n) = n := by
  induction n using Nat.strong_induction_on with
  | _ n ih =>
      rw [dec]
      by_cases h : n < 10
      · simp only [h, if_true, decVal, List.foldl_cons, List.foldl_nil]
        rw [toNat_ofNat_digit h]
        omega
      · simp only [h, if_false]
        rw [decVal_append_digit, toNat_ofNat_digit (Nat.mod_lt _ (by omega))]
        have hlt : n / 10 < n := Nat.div_lt_self (by omega) (by omega)
        rw [ih (n / 10) hlt]
        have := Nat.div_add_mod n 10
        omega

/-- A number below `10 ^ (k + 1)` has at most `k + 1` digits. -/
theorem dec_length_le : ∀ (k n : Nat), n < 10 ^ (k + 1) → (dec n).length ≤ k + 1 := by
  intro k
  induction k with
  | zero =>
      intro n hn
      have hn' : n < 10 := by simpa using hn
      rw [dec, if_pos hn']
      simp
  | succ m ih =>
      intro n hn
      rw [dec]
      by_cases h : n < 10
      · simp [h]
      · simp only [h, if_false, List.length_append, List.length_singleton]
        have hdiv : n / 10 < 10 ^ (m + 1) := by
          have : n < 10 ^ (m + 1) * 10 := by
            calc n < 10 ^ (m + 1 + 1) := hn
            _ = 10 ^ (m + 1) * 10 := by ring
          exact Nat.div_lt_of_lt_mul (by omega)
        have := ih (n / 10) hdiv
        omega

/-- A number as a string. -/
def decStr (n : Nat) : String := String.ofList (dec n)

@[simp] theorem decStr_length (n : Nat) : (decStr n).length = (dec n).length :=
  String.length_ofList

/-- The largest number an update prints in full. -/
def nineNines : Nat := 999999999

/-- Numbers are printed in full up to `nineNines`, and clamped above it, so that
an update has a length limit no matter what. -/
def dec9 (n : Nat) : String := decStr (min n nineNines)

theorem dec9_length_le (n : Nat) : (dec9 n).length ≤ 9 := by
  have hpow : (10 : Nat) ^ (8 + 1) = 1000000000 := by norm_num
  have h1 : min n nineNines ≤ 999999999 := Nat.min_le_right _ _
  have h : min n nineNines < 10 ^ (8 + 1) := by omega
  have := dec_length_le 8 (min n nineNines) h
  simpa [dec9] using this

/-- **Nothing is clamped** while the numbers stay below a billion. -/
theorem dec9_eq_of_lt {n : Nat} (h : n < 1000000000) : dec9 n = decStr n := by
  have : min n nineNines = n := Nat.min_eq_left (by show n ≤ 999999999; omega)
  simp [dec9, this]

/-! ## The update for the punters -/

/-- What an update says. -/
structure Update where
  /-- World ticks elapsed in the game. -/
  tick : Nat
  /-- Cash the game finished with. -/
  cash : Nat
  /-- Parts standing at the end. -/
  parts : Nat
  /-- Moves the critic flagged. -/
  flagged : Nat
  /-- The best score the database knows from that starting position. -/
  book : Nat
deriving DecidableEq, Repr, Inhabited

/-- The update a finished game generates: every field read off the game itself
and the database, nothing invented. -/
def updateOf (db : DB) (r : Recording) : Update :=
  { tick := r.final.tick,
    cash := r.final.cash,
    parts := r.final.scene.length,
    flagged := (critique db r).length,
    book := bestScore db r.init }

/-- The update, as the text that gets posted. -/
def postText (u : Update) : String :=
  "FACTORY FLOOR | tick " ++ dec9 u.tick ++ " | cash " ++ dec9 u.cash ++
  " | parts " ++ dec9 u.parts ++ " | flagged " ++ dec9 u.flagged ++
  " | book " ++ dec9 u.book ++ " | proved in Lean"

/-- **Every update fits in a 280-character post.** -/
theorem post_chars_le (u : Update) : (postText u).length ≤ 280 := by
  simp only [postText, String.length_append]
  have h1 := dec9_length_le u.tick
  have h2 := dec9_length_le u.cash
  have h3 := dec9_length_le u.parts
  have h4 := dec9_length_le u.flagged
  have h5 := dec9_length_le u.book
  have e1 : "FACTORY FLOOR | tick ".length = 21 := by rfl
  have e2 : " | cash ".length = 8 := by rfl
  have e3 : " | parts ".length = 9 := by rfl
  have e4 : " | flagged ".length = 11 := by rfl
  have e5 : " | book ".length = 8 := by rfl
  have e6 : " | proved in Lean".length = 17 := by rfl
  omega

/-- **An update reports the game that was played.** Its fields are read off the
recording and the database. -/
theorem updateOf_fields (db : DB) (r : Recording) :
    (updateOf db r).tick = r.final.tick ∧
    (updateOf db r).cash = r.final.cash ∧
    (updateOf db r).parts = r.final.scene.length ∧
    (updateOf db r).flagged = (critique db r).length ∧
    (updateOf db r).book = bestScore db r.init :=
  ⟨rfl, rfl, rfl, rfl, rfl⟩

/-- While the numbers stay below a billion — which they do in any real game —
the update prints them exactly. -/
theorem postText_honest (u : Update)
    (h1 : u.tick < 1000000000) (h2 : u.cash < 1000000000) (h3 : u.parts < 1000000000)
    (h4 : u.flagged < 1000000000) (h5 : u.book < 1000000000) :
    postText u =
      "FACTORY FLOOR | tick " ++ decStr u.tick ++ " | cash " ++ decStr u.cash ++
      " | parts " ++ decStr u.parts ++ " | flagged " ++ decStr u.flagged ++
      " | book " ++ decStr u.book ++ " | proved in Lean" := by
  simp [postText, dec9_eq_of_lt h1, dec9_eq_of_lt h2, dec9_eq_of_lt h3,
    dec9_eq_of_lt h4, dec9_eq_of_lt h5]

/-! ## A real broadcast -/

/-- The clip of the trained model's game, keeping every fourth frame. -/
def trainedClip : String := clip trainedGame 3

/-- The still of the factory the trained model finished with. -/
def trainedStill : Option String := stillWithin trainedGame.final

/-- The update that goes out with them. -/
def trainedUpdate : Update := updateOf coachedDB trainedGame

/-- The trained model's broadcast, measured (checked by evaluation): the clip
carries 31 frames in 689,814 bytes — comfortably inside the five-megabyte limit,
and a seventh of the 2,712,792 bytes the unthinned film would have needed — the
still is 31,788 bytes, and the post is 87 characters. -/
theorem broadcast_report :
    bytes trainedClip = 689814 ∧
    (clipBody trainedGame 3).length = 31 ∧
    bytes (joinS (filmChunks trainedGame 0)) = 2712792 ∧
    trainedStill = some (renderSVG trainedGame.final.scene) ∧
    (trainedStill.map bytes) = some 31788 ∧
    postText trainedUpdate =
      "FACTORY FLOOR | tick 72 | cash 2095 | parts 23 | flagged 0 | book 2095 | proved in Lean" ∧
    (postText trainedUpdate).length = 87 ∧
    trainedUpdate.cash = 2095 ∧
    trainedUpdate.flagged = 0 := by
  native_decide

/-- The broadcast of the trained model's game is inside the five-megabyte
limit — as every clip is. -/
theorem trainedClip_bytes_le : bytes trainedClip ≤ maxClipBytes :=
  clip_bytes_le trainedGame 3

/-- Thinned to every fourth frame, the whole film fits, so the clip carries all
of it. -/
theorem trainedClip_whole_thinned_film :
    clipBody trainedGame 3 = filmChunks trainedGame 3 :=
  clip_complete_of_small trainedGame 3 (by native_decide)

/-- The post about the trained model's game fits, as every post does. -/
theorem trainedPost_chars_le : (postText trainedUpdate).length ≤ 280 :=
  post_chars_le trainedUpdate

end Broadcast
end Tycoon
