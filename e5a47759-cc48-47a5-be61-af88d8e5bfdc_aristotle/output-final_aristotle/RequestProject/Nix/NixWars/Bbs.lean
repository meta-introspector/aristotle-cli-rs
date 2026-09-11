import Mathlib
import RequestProject.Nix.NixWars.Codec

/-!
# The board behind the board: a BBS

`www/index.html` is laid out like a BBS main menu, and every door of NixWars is
a *door* in the BBS sense, but until now there was no BBS underneath: no
callers, no message base, no access levels, no drop file handed to a door.
This file is that system, as a model with its laws proved:

* **callers** — a user list, a hashed secret and an access level, with `login`
  proved sound (it only ever returns a user of the board whose secret matches
  the hash of what was typed);
* **the message base** — areas with a read level and a post level, messages
  carrying an optional parent, and a well-formedness invariant (`WF`) saying
  the identifiers strictly increase and every reply points backwards at a
  message that exists in the same area.  `post` is append-only and preserves
  the invariant, so threads can never form a cycle (`no_self_reply`,
  `ancestors_lt`);
* **new-message pointers** — `unread` and `readAll`, with "after reading there
  is nothing unread" and "a post adds exactly one unread message, to the people
  cleared to read the area" proved;
* **the menu** — the screens of the board as a machine, with the theorem that
  matters for a multi-level board: *whatever you press*, from the login screen,
  you never reach the sysop area without the level for it
  (`no_sysop_without_level`), while at sysop level you do (`sysop_reachable`);
* **the drop file** — the record the board hands a door when it shells out,
  with the field-level round trip proved and the text form checked on samples.

`Bbs.lean` is the model; `BbsPage.lean` emits `www/bbs.html` from it, so the
page's login, menu, areas, threads and drop file are the ones proved here.
-/

set_option maxRecDepth 40000

namespace NixWars

namespace Bbs

/-! ## Callers -/

/-- The board never stores what was typed: it stores this. -/
def hash (s : String) : Nat :=
  s.foldl (fun a c => (a * 131 + c.toNat) % 1000003) 7

/-- A caller: the handle, the hash of the secret, and the access level. -/
structure User where
  /-- The handle the caller logs in under. -/
  handle : String
  /-- The hash of the caller's secret. -/
  secret : Nat
  /-- The access level: what the caller may read, post and open. -/
  level : Nat
  deriving DecidableEq, Repr

/-- A message area: a tag, a name, the level needed to read it and the level
needed to post in it. -/
structure Area where
  /-- The short tag messages carry. -/
  tag : String
  /-- The name on the menu. -/
  name : String
  /-- The level needed to read the area. -/
  readLevel : Nat
  /-- The level needed to post in the area. -/
  postLevel : Nat
  deriving DecidableEq, Repr

/-- A message.  `parent` is the message it replies to, if any. -/
structure Msg where
  /-- The message number. -/
  id : Nat
  /-- The tag of the area it was posted in. -/
  area : String
  /-- The handle that posted it. -/
  author : String
  /-- The subject line. -/
  subject : String
  /-- The text. -/
  body : String
  /-- The message this one replies to, if it is a reply. -/
  parent : Option Nat
  deriving DecidableEq, Repr

/-- The whole board: who calls, what areas it carries, the message base, each
caller's new-message pointer, and the callers log (newest first). -/
structure Board where
  /-- The callers. -/
  users : List User
  /-- The message areas. -/
  areas : List Area
  /-- The message base, oldest first. -/
  msgs : List Msg
  /-- Each caller's high-water mark: the last message number they have seen. -/
  marks : List (String × Nat)
  /-- The callers log, newest first. -/
  callers : List String
  deriving DecidableEq, Repr

/-- Log in: the caller of that handle whose stored hash matches what was
typed. -/
def login (b : Board) (handle secret : String) : Option User :=
  b.users.find? (fun u => u.handle = handle && u.secret = hash secret)

/-- A successful login returns a caller of *this* board, under the handle that
was typed, whose stored hash is the hash of what was typed.  Nothing else can
get in. -/
theorem login_sound {b : Board} {h s : String} {u : User}
    (hu : login b h s = some u) :
    u ∈ b.users ∧ u.handle = h ∧ u.secret = hash s := by
  unfold login at hu
  have hmem : u ∈ b.users := List.mem_of_find?_eq_some hu
  have hp := List.find?_some hu
  simp only [Bool.and_eq_true, decide_eq_true_eq] at hp
  exact ⟨hmem, hp.1, hp.2⟩

/-- A wrong secret never gets in. -/
theorem login_wrong_secret {b : Board} {h s : String} {u : User}
    (hu : login b h s = some u) (hne : u.secret ≠ hash s) : False :=
  hne (login_sound hu).2.2

/-! ## The message base -/

/-- The largest message number on the board (`0` if it is empty). -/
def topId (b : Board) : Nat := (b.msgs.map Msg.id).foldr max 0

/-- The number the next message will get. -/
def nextId (b : Board) : Nat := topId b + 1

private theorem le_foldr_max : ∀ (l : List Nat) {x : Nat}, x ∈ l → x ≤ l.foldr max 0 := by
  intro l
  induction l with
  | nil => intro x hx; cases hx
  | cons a t ih =>
      intro x hx
      rcases List.mem_cons.1 hx with rfl | hx
      · exact le_max_left _ _
      · exact le_trans (ih hx) (le_max_right _ _)

/-- Every message on the board is at or below the top number. -/
theorem id_le_topId {b : Board} {m : Msg} (hm : m ∈ b.msgs) : m.id ≤ topId b :=
  le_foldr_max _ (List.mem_map_of_mem hm)

/-- The next number is free. -/
theorem lt_nextId {b : Board} {m : Msg} (hm : m ∈ b.msgs) : m.id < nextId b :=
  Nat.lt_succ_of_le (id_le_topId hm)

/-- May this caller read this area? -/
def canRead (u : User) (a : Area) : Bool := a.readLevel ≤ u.level

/-- May this caller post in this area? -/
def canPost (u : User) (a : Area) : Bool := a.postLevel ≤ u.level

/-- Is this a legal thing to reply to: nothing, or a message that exists in
this very area? -/
def parentOk (b : Board) (a : Area) : Option Nat → Bool
  | none => true
  | some p => b.msgs.any (fun m => m.id = p && m.area = a.tag)

/-- Post a message.  A post that the caller's level does not allow, or that
replies to something which is not in the area, does not happen at all. -/
def post (b : Board) (u : User) (a : Area) (subject body : String)
    (parent : Option Nat) : Board :=
  if canPost u a && parentOk b a parent then
    { b with msgs := b.msgs ++ [⟨nextId b, a.tag, u.handle, subject, body, parent⟩] }
  else b

/-- The message base is append-only: whatever was on it is still on it, in the
order it was in, and at most one message is added. -/
theorem post_appends (b : Board) (u : User) (a : Area) (s t : String)
    (p : Option Nat) :
    (post b u a s t p).msgs = b.msgs ∨
      (post b u a s t p).msgs =
        b.msgs ++ [⟨nextId b, a.tag, u.handle, s, t, p⟩] := by
  unfold post
  split <;> simp

/-- Nothing is ever removed. -/
theorem post_preserves_msgs {b : Board} {u : User} {a : Area} {s t : String}
    {p : Option Nat} {m : Msg} (hm : m ∈ b.msgs) : m ∈ (post b u a s t p).msgs := by
  rcases post_appends b u a s t p with h | h <;> rw [h]
  · exact hm
  · exact List.mem_append_left _ hm

/-- A caller below the posting level of an area changes nothing at all. -/
theorem post_refused_below_level {b : Board} {u : User} {a : Area} {s t : String}
    {p : Option Nat} (h : ¬ canPost u a) : post b u a s t p = b := by
  have hf : canPost u a = false := by simpa using h
  simp [post, hf]

/-- A reply to a message that is not in the area changes nothing at all. -/
theorem post_refused_bad_parent {b : Board} {u : User} {a : Area} {s t : String}
    {p : Option Nat} (h : ¬ parentOk b a p) : post b u a s t p = b := by
  have hf : parentOk b a p = false := by simpa using h
  simp [post, hf]

/-- The board is in order: message numbers strictly increase down the base,
every reply points backwards at a message that exists in the same area, and no
caller's new-message pointer runs ahead of the base. -/
def WF (b : Board) : Prop :=
  (b.msgs.map Msg.id).Pairwise (· < ·) ∧
  (∀ m ∈ b.msgs, ∀ p ∈ m.parent, ∃ q ∈ b.msgs, q.id = p ∧ q.area = m.area ∧ p < m.id) ∧
  (∀ k ∈ b.marks, k.2 ≤ topId b)

/-- On a board in order, a reply is always younger than what it replies to. -/
theorem parent_lt {b : Board} (h : WF b) {m : Msg} (hm : m ∈ b.msgs) {p : Nat}
    (hp : m.parent = some p) : p < m.id := by
  obtain ⟨_, hrep, _⟩ := h
  obtain ⟨_, _, _, _, hlt⟩ := hrep m hm p (by simp [hp])
  exact hlt

/-- Nothing replies to itself. -/
theorem no_self_reply {b : Board} (h : WF b) {m : Msg} (hm : m ∈ b.msgs) :
    m.parent ≠ some m.id := by
  intro hp
  exact absurd (parent_lt h hm hp) (lt_irrefl _)

private theorem foldr_max_append_singleton (x : Nat) : ∀ l : List Nat,
    (l ++ [x]).foldr max 0 = max x (l.foldr max 0) := by
  intro l
  induction l with
  | nil => simp
  | cons a t ih =>
      show max a ((t ++ [x]).foldr max 0) = max x (max a (t.foldr max 0))
      rw [ih]
      omega

/-- **Appending a fresh message keeps the board in order.**  If the message
takes the next free number, and any message it replies to is really on the
board and in its own area, the invariant survives. -/
theorem WF_append {b : Board} (h : WF b) (m : Msg) (hid : m.id = nextId b)
    (hpar : ∀ p, m.parent = some p → ∃ q ∈ b.msgs, q.id = p ∧ q.area = m.area) :
    WF { b with msgs := b.msgs ++ [m] } := by
  obtain ⟨hsorted, hrep, hmark⟩ := h
  have htop : topId { b with msgs := b.msgs ++ [m] } = nextId b := by
    show ((b.msgs ++ [m]).map Msg.id).foldr max 0 = nextId b
    rw [List.map_append]
    simp only [List.map_cons, List.map_nil]
    rw [foldr_max_append_singleton, hid]
    have : topId b < nextId b := Nat.lt_succ_self _
    unfold topId at this
    omega
  refine ⟨?_, ?_, ?_⟩
  · show ((b.msgs ++ [m]).map Msg.id).Pairwise (· < ·)
    rw [List.map_append, List.pairwise_append]
    refine ⟨hsorted, by simp, ?_⟩
    intro x hx y hy
    obtain ⟨q, hq, rfl⟩ := List.mem_map.1 hx
    simp only [List.map_cons, List.map_nil, List.mem_singleton] at hy
    subst hy
    rw [hid]
    exact lt_nextId hq
  · intro m' hm' p hp
    rcases List.mem_append.1 hm' with hin | hin
    · obtain ⟨w, hw, h1, h2, h3⟩ := hrep m' hin p hp
      exact ⟨w, List.mem_append_left _ hw, h1, h2, h3⟩
    · simp only [List.mem_singleton] at hin
      subst hin
      simp only [Option.mem_def] at hp
      obtain ⟨w, hw, h1, h2⟩ := hpar p hp
      refine ⟨w, List.mem_append_left _ hw, h1, h2, ?_⟩
      rw [hid]
      exact h1 ▸ lt_nextId hw
  · intro k hk
    have hk2 : k.2 ≤ topId b := hmark k hk
    have hb : topId b < nextId b := Nat.lt_succ_self _
    rw [htop]
    omega

/-- Posting keeps the board in order.  (The new message gets the free number,
so it is above everything already there, and if it is a reply it replies to
something that is there.) -/
theorem post_preserves_WF {b : Board} (h : WF b) (u : User) (a : Area)
    (s t : String) (p : Option Nat) : WF (post b u a s t p) := by
  unfold post
  split
  · rename_i hcond
    have hpar : parentOk b a p = true := by
      simp only [Bool.and_eq_true] at hcond; exact hcond.2
    refine WF_append h ⟨nextId b, a.tag, u.handle, s, t, p⟩ rfl ?_
    intro q hq
    have hq' : p = some q := hq
    unfold parentOk at hpar
    rw [hq'] at hpar
    obtain ⟨w, hw, hcheck⟩ := List.any_eq_true.1 hpar
    simp only [Bool.and_eq_true, decide_eq_true_eq] at hcheck
    exact ⟨w, hw, hcheck.1, hcheck.2⟩
  · exact h

/-! ## Threads -/

/-- The message with this number, if the board carries it. -/
def msgById (b : Board) (i : Nat) : Option Msg := b.msgs.find? (fun m => m.id = i)

/-- The number a message replies to, if it is a reply. -/
def parentOf (b : Board) (i : Nat) : Option Nat := (msgById b i).bind Msg.parent

/-- Walking up a thread: the numbers a message hangs under, nearest first.
`fuel` bounds the walk; `ancestors_length_le` shows the bound is never the
thing that stops it on a board in order. -/
def ancestors (b : Board) : Nat → Nat → List Nat
  | 0, _ => []
  | f + 1, i =>
      match parentOf b i with
      | none => []
      | some p => p :: ancestors b f p

theorem msgById_spec {b : Board} {i : Nat} {m : Msg} (h : msgById b i = some m) :
    m ∈ b.msgs ∧ m.id = i := by
  unfold msgById at h
  refine ⟨List.mem_of_find?_eq_some h, ?_⟩
  simpa using List.find?_some h

/-- On a board in order, a message always hangs under a *smaller* number. -/
theorem parentOf_lt {b : Board} (h : WF b) {i p : Nat} (hp : parentOf b i = some p) :
    p < i := by
  unfold parentOf at hp
  cases hm : msgById b i with
  | none => rw [hm] at hp; simp at hp
  | some m =>
      rw [hm] at hp
      have hp' : m.parent = some p := hp
      obtain ⟨hmem, hid⟩ := msgById_spec hm
      exact hid ▸ parent_lt h hmem hp'

/-- Threads cannot loop: every number above you in a thread is below you. -/
theorem ancestors_lt {b : Board} (h : WF b) :
    ∀ (f i : Nat), ∀ p ∈ ancestors b f i, p < i := by
  intro f
  induction f with
  | zero => intro i p hp; cases hp
  | succ f ih =>
      intro i p hp
      unfold ancestors at hp
      cases hq : parentOf b i with
      | none => rw [hq] at hp; cases hp
      | some q =>
          rw [hq] at hp
          have hqi : q < i := parentOf_lt h hq
          rcases List.mem_cons.1 hp with rfl | hp
          · exact hqi
          · exact lt_trans (ih q p hp) hqi

/-- In particular nothing is above itself. -/
theorem self_notMem_ancestors {b : Board} (h : WF b) (f i : Nat) :
    i ∉ ancestors b f i := fun hi => absurd (ancestors_lt h f i i hi) (lt_irrefl _)

/-- A thread is no longer than the number it starts at, so walking it with that
much fuel walks all of it. -/
theorem ancestors_length_le {b : Board} (h : WF b) :
    ∀ (f i : Nat), (ancestors b f i).length ≤ i := by
  intro f
  induction f with
  | zero => intro i; simp [ancestors]
  | succ f ih =>
      intro i
      unfold ancestors
      cases hq : parentOf b i with
      | none => simp
      | some q =>
          have hqi : q < i := parentOf_lt h hq
          have := ih q
          simp only [List.length_cons]
          omega

/-! ## New-message pointers -/

/-- The last message number this caller has seen. -/
def markOf (b : Board) (handle : String) : Nat :=
  ((b.marks.find? (fun k => k.1 = handle)).map Prod.snd).getD 0

/-- What is new for this caller in this area — nothing at all if the area is
above their level. -/
def unread (b : Board) (u : User) (a : Area) : List Msg :=
  if canRead u a then
    b.msgs.filter (fun m => m.area = a.tag && markOf b u.handle < m.id)
  else []

/-- Mark everything read. -/
def readAll (b : Board) (u : User) : Board :=
  { b with marks := (u.handle, topId b) :: b.marks.filter (fun k => k.1 ≠ u.handle) }

/-- On a board in order, no caller's pointer runs ahead of the base. -/
theorem markOf_le_topId {b : Board} (h : WF b) (handle : String) :
    markOf b handle ≤ topId b := by
  unfold markOf
  cases hf : b.marks.find? (fun k => k.1 = handle) with
  | none => simp
  | some k =>
      simp only [Option.map_some, Option.getD_some]
      exact h.2.2 k (List.mem_of_find?_eq_some hf)

theorem markOf_readAll (b : Board) (u : User) :
    markOf (readAll b u) u.handle = topId b := by
  simp [markOf, readAll]

/-- After reading, nothing is unread. -/
theorem readAll_no_unread (b : Board) (u : User) (a : Area) :
    unread (readAll b u) u a = [] := by
  unfold unread
  split
  · rw [List.filter_eq_nil_iff]
    intro m hm
    have hmem : m ∈ b.msgs := hm
    have hle : m.id ≤ topId b := id_le_topId hmem
    have hmark : markOf (readAll b u) u.handle = topId b := markOf_readAll b u
    simp only [Bool.and_eq_true, decide_eq_true_eq, not_and, hmark]
    intro _
    simpa using hle
  · rfl

/-- Reading keeps the board in order. -/
theorem readAll_preserves_WF {b : Board} (h : WF b) (u : User) : WF (readAll b u) := by
  obtain ⟨hs, hr, hm⟩ := h
  refine ⟨hs, hr, ?_⟩
  intro k hk
  rcases List.mem_cons.1 hk with rfl | hk
  · exact le_of_eq rfl
  · exact hm k (List.mem_of_mem_filter hk)

/-- A post that goes through adds exactly one unread message for every caller
cleared to read the area — and it is the message that was posted. -/
theorem unread_after_post {b : Board} (h : WF b) {u v : User} {a : Area}
    {s t : String} {p : Option Nat}
    (hgo : canPost u a && parentOk b a p) (hv : canRead v a) :
    unread (post b u a s t p) v a =
      unread b v a ++ [⟨nextId b, a.tag, u.handle, s, t, p⟩] := by
  have hpost : post b u a s t p =
      { b with msgs := b.msgs ++ [(⟨nextId b, a.tag, u.handle, s, t, p⟩ : Msg)] } := by
    simp [post, hgo]
  have hmark : markOf b v.handle ≤ topId b := markOf_le_topId h v.handle
  have hlt : markOf b v.handle < nextId b := Nat.lt_succ_of_le hmark
  unfold unread
  rw [hpost]
  simp only [hv, if_true]
  show (b.msgs ++ [(⟨nextId b, a.tag, u.handle, s, t, p⟩ : Msg)]).filter _ = _
  rw [List.filter_append]
  simp only [markOf] at hlt
  simp [markOf, hlt]

/-! ## The menu -/

/-- The level a caller needs for the sysop's area. -/
def sysopLevel : Nat := 100

/-- The screens of the board. -/
inductive Screen
  /-- The login prompt. -/
  | login
  /-- The main menu. -/
  | main
  /-- The list of message areas. -/
  | areas
  /-- Reading an area. -/
  | reading
  /-- Writing a message. -/
  | posting
  /-- The doors: the games. -/
  | doors
  /-- The file area. -/
  | files
  /-- The callers log. -/
  | callers
  /-- The mail room: packets in and out of the other node. -/
  | mail
  /-- The sysop's area. -/
  | sysop
  /-- Logged off. -/
  | goodbye
  deriving DecidableEq, Repr

/-- Every screen. -/
def allScreens : List Screen :=
  [.login, .main, .areas, .reading, .posting, .doors, .files, .callers, .mail, .sysop, .goodbye]

theorem mem_allScreens (s : Screen) : s ∈ allScreens := by cases s <;> decide

/-- One line of the board's menu machine: on this screen, this key takes you to
that screen, provided you have the level in the last column.  This table *is*
the machine — `step` is a lookup in it — and it is what the page runs. -/
def stepTable : List (Screen × Char × Screen × Nat) :=
  [(.login, 'L', .main, 0),
   (.login, 'G', .goodbye, 0),
   (.main, 'M', .areas, 0),
   (.main, 'D', .doors, 0),
   (.main, 'F', .files, 0),
   (.main, 'C', .callers, 0),
   (.main, 'E', .mail, 0),
   (.main, 'S', .sysop, sysopLevel),
   (.main, 'G', .goodbye, 0),
   (.areas, 'R', .reading, 0),
   (.areas, 'Q', .main, 0),
   (.reading, 'P', .posting, 0),
   (.reading, 'Q', .areas, 0),
   (.posting, 'Q', .reading, 0),
   (.doors, 'Q', .main, 0),
   (.files, 'Q', .main, 0),
   (.callers, 'Q', .main, 0),
   (.mail, 'Q', .main, 0),
   (.sysop, 'Q', .main, 0)]

/-- What a key does, at a given access level.  `none` means the key does
nothing on this screen — either there is no such entry, or the caller is below
the level it asks for — and the board just redraws the screen. -/
def step (lvl : Nat) (s : Screen) (k : Char) : Option Screen :=
  (stepTable.find? (fun e => e.1 = s && e.2.1 = k && e.2.2.2 ≤ lvl)).map (fun e => e.2.2.1)

/-- Where a sequence of keys leaves you. -/
def run (lvl : Nat) : Screen → List Char → Screen
  | s, [] => s
  | s, k :: ks =>
      match step lvl s k with
      | none => run lvl s ks
      | some t => run lvl t ks

/-- The sysop's area is the one place on the board that asks for a level. -/
theorem only_sysop_gated :
    ∀ e ∈ stepTable, (e.2.2.1 = Screen.sysop ↔ e.2.2.2 = sysopLevel) := by decide

/-- Below the sysop level, no key anywhere opens the sysop's area. -/
theorem step_not_sysop {lvl : Nat} {s t : Screen} {k : Char}
    (hl : lvl < sysopLevel) (h : step lvl s k = some t) : t ≠ Screen.sysop := by
  unfold step at h
  cases hf : stepTable.find? (fun e => e.1 = s && e.2.1 = k && e.2.2.2 ≤ lvl) with
  | none => rw [hf] at h; simp at h
  | some e =>
      rw [hf] at h
      simp only [Option.map_some, Option.some.injEq] at h
      subst h
      intro hsys
      have hmem : e ∈ stepTable := List.mem_of_find?_eq_some hf
      have hpred := List.find?_some hf
      simp only [Bool.and_eq_true, decide_eq_true_eq] at hpred
      have := (only_sysop_gated e hmem).1 hsys
      omega

/-- **The board keeps its own door shut.**  Whatever a caller below the sysop
level presses, from the login prompt, they never end up in the sysop's area. -/
theorem no_sysop_without_level {lvl : Nat} (hl : lvl < sysopLevel) (ks : List Char) :
    run lvl Screen.login ks ≠ Screen.sysop := by
  have general : ∀ (ks : List Char) (s : Screen), s ≠ Screen.sysop →
      run lvl s ks ≠ Screen.sysop := by
    intro ks
    induction ks with
    | nil => intro s hs; simpa [run] using hs
    | cons k ks ih =>
        intro s hs
        show (match step lvl s k with
              | none => run lvl s ks
              | some t => run lvl t ks) ≠ Screen.sysop
        cases hstep : step lvl s k with
        | none => simpa [hstep] using ih s hs
        | some t => simpa [hstep] using ih t (step_not_sysop hl hstep)
  exact general ks Screen.login (by simp)

/-- At sysop level it does open. -/
theorem sysop_reachable : run sysopLevel Screen.login ['L', 'S'] = Screen.sysop := by decide

/-- The keys that walk to each screen from the login prompt. -/
def pathTo : Screen → List Char
  | .login => []
  | .main => ['L']
  | .areas => ['L', 'M']
  | .reading => ['L', 'M', 'R']
  | .posting => ['L', 'M', 'R', 'P']
  | .doors => ['L', 'D']
  | .files => ['L', 'F']
  | .callers => ['L', 'C']
  | .mail => ['L', 'E']
  | .sysop => ['L', 'S']
  | .goodbye => ['L', 'G']

/-- With the level for it, every screen of the board is reachable from the
login prompt, and `pathTo` says how. -/
theorem every_screen_reachable :
    ∀ s ∈ allScreens, run sysopLevel Screen.login (pathTo s) = s := by decide

/-- No line of the table starts at the goodbye screen. -/
theorem stepTable_no_goodbye : ∀ e ∈ stepTable, e.1 ≠ Screen.goodbye := by decide

/-- Nothing on the table leads out of the goodbye screen. -/
theorem step_goodbye (lvl : Nat) (k : Char) : step lvl Screen.goodbye k = none := by
  unfold step
  have hnone : stepTable.find?
      (fun e => e.1 = Screen.goodbye && e.2.1 = k && e.2.2.2 ≤ lvl) = none := by
    rw [List.find?_eq_none]
    intro e he
    have hne : e.1 ≠ Screen.goodbye := stepTable_no_goodbye e he
    simp [hne]
  rw [hnone]
  rfl

/-- Logging off is the end: no key does anything afterwards. -/
theorem goodbye_absorbing (lvl : Nat) (ks : List Char) :
    run lvl Screen.goodbye ks = Screen.goodbye := by
  induction ks with
  | nil => rfl
  | cons k ks ih =>
      show (match step lvl Screen.goodbye k with
            | none => run lvl Screen.goodbye ks
            | some t => run lvl t ks) = Screen.goodbye
      rw [step_goodbye]
      exact ih

/-! ## The drop file

When a board shells out to a door it writes a small record to disk first — the
`DOOR.SYS` of the eighties — and the door reads it to find out who is calling.
The round trip is proved at the field level; the text form is the fields joined
by newlines, and is pinned on samples below. -/

/-- The ten digits. -/
def digits10 : List Char := ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']

/-- A decimal digit as a character. -/
def digitChar (d : Nat) : Char := digits10.getD d '0'

/-- A character read back as a decimal digit. -/
def charDigit (c : Char) : Option Nat := digits10.findIdx? (· = c)

theorem charDigit_digitChar {d : Nat} (h : d < 10) : charDigit (digitChar d) = some d := by
  interval_cases d <;> decide

/-- The decimal digits of a number, most significant first.  The recursion is
on a fuel argument rather than well founded, so the digits of a literal reduce
in the kernel and `decide` can check the samples at the end of the file. -/
def decDigitsAux : Nat → Nat → List Nat
  | 0, n => [n]
  | f + 1, n => if n < 10 then [n] else decDigitsAux f (n / 10) ++ [n % 10]

/-- The decimal digits of a number, most significant first. -/
def decDigits (n : Nat) : List Nat := decDigitsAux n n

/-- The number a digit string stands for. -/
def decValue (l : List Nat) : Nat := l.foldl (fun a d => a * 10 + d) 0

private theorem decDigitsAux_lt : ∀ (f n : Nat), n ≤ f → ∀ d ∈ decDigitsAux f n, d < 10 := by
  intro f
  induction f with
  | zero => intro n hn d hd; simp only [decDigitsAux, List.mem_singleton] at hd; omega
  | succ f ih =>
      intro n hn d hd
      unfold decDigitsAux at hd
      split at hd
      · simp only [List.mem_singleton] at hd; omega
      · rename_i hbig
        rcases List.mem_append.1 hd with hd | hd
        · have hdiv : n / 10 ≤ f := by
            have : n / 10 < n := Nat.div_lt_self (by omega) (by omega)
            omega
          exact ih (n / 10) hdiv d hd
        · simp only [List.mem_singleton] at hd
          subst hd
          omega

theorem decDigits_lt (n : Nat) : ∀ d ∈ decDigits n, d < 10 :=
  decDigitsAux_lt n n le_rfl

private theorem decValue_foldl (l : List Nat) (a : Nat) :
    l.foldl (fun a d => a * 10 + d) a = a * 10 ^ l.length + decValue l := by
  induction l generalizing a with
  | nil => simp [decValue]
  | cons x t ih =>
      have h1 := ih (a * 10 + x)
      have h2 := ih (0 * 10 + x)
      simp only [List.foldl_cons, decValue, List.length_cons] at *
      rw [h1, h2]
      ring

private theorem decValue_aux : ∀ (f n : Nat), n ≤ f → decValue (decDigitsAux f n) = n := by
  intro f
  induction f with
  | zero =>
      intro n hn
      have : n = 0 := by omega
      subst this
      simp [decDigitsAux, decValue]
  | succ f ih =>
      intro n hn
      unfold decDigitsAux
      split
      · simp [decValue]
      · rename_i hbig
        have hdiv : n / 10 ≤ f := by
          have : n / 10 < n := Nat.div_lt_self (by omega) (by omega)
          omega
        have hrec := ih (n / 10) hdiv
        unfold decValue at *
        rw [List.foldl_append]
        simp only [List.foldl_cons, List.foldl_nil]
        rw [hrec]
        omega

theorem decValue_decDigits (n : Nat) : decValue (decDigits n) = n :=
  decValue_aux n n le_rfl

/-- A number written out in decimal. -/
def natToDec (n : Nat) : String := String.ofList ((decDigits n).map digitChar)

/-- A decimal string read back. -/
def decToNat? (s : String) : Option Nat :=
  (mapOption charDigit s.toList).map decValue

private theorem mapOption_charDigit :
    ∀ (l : List Nat), (∀ d ∈ l, d < 10) → mapOption charDigit (l.map digitChar) = some l := by
  intro l
  induction l with
  | nil => intro _; rfl
  | cons a t ih =>
      intro h
      have ha : charDigit (digitChar a) = some a :=
        charDigit_digitChar (h a (by simp))
      have ht := ih (fun d hd => h d (by simp [hd]))
      simp [List.map_cons, mapOption_cons, ha, ht]

/-- Decimal round-trips. -/
theorem decToNat?_natToDec (n : Nat) : decToNat? (natToDec n) = some n := by
  have hmap : mapOption charDigit ((decDigits n).map digitChar) = some (decDigits n) :=
    mapOption_charDigit _ (decDigits_lt n)
  simp [decToNat?, natToDec, String.toList_ofList, hmap, decValue_decDigits]

/-- What the board hands a door: who is calling, at what level, which door,
where on the ring, and how long they have left. -/
structure Drop where
  /-- The caller's handle. -/
  handle : String
  /-- The caller's access level. -/
  level : Nat
  /-- The door being opened. -/
  door : String
  /-- The shard the session sits on. -/
  shard : Nat
  /-- Seconds left in the session. -/
  seconds : Nat
  deriving DecidableEq, Repr

/-- The drop file as its fields, in `DOOR.SYS` order. -/
def Drop.fields (d : Drop) : List String :=
  [d.handle, natToDec d.level, d.door, natToDec d.shard, natToDec d.seconds]

/-- The fields read back. -/
def Drop.parse : List String → Option Drop
  | [h, l, dr, sh, se] =>
      match decToNat? l, decToNat? sh, decToNat? se with
      | some l', some sh', some se' => some ⟨h, l', dr, sh', se'⟩
      | _, _, _ => none
  | _ => none

/-- **The drop file round-trips**: the door reads back exactly the record the
board wrote. -/
theorem drop_round_trip (d : Drop) : Drop.parse d.fields = some d := by
  cases d with
  | mk handle level door shard seconds =>
      simp [Drop.fields, Drop.parse, decToNat?_natToDec]

/-- The drop file as text, one field per line, as a door would read it. -/
def Drop.render (d : Drop) : String := String.intercalate "\n" d.fields ++ "\n"

/-! ## The board this system runs

Four callers, five areas and a seeded message base, so the page has something
to show and the laws above have something concrete to be true of. -/

/-- The message areas. -/
def areas : List Area :=
  [⟨"GEN", "GENERAL CHATTER", 0, 10⟩,
   ⟨"NIX", "NIXWARS PLAYERS", 0, 10⟩,
   ⟨"SHARD", "SHARD OPERATIONS", 10, 50⟩,
   ⟨"TRADE", "THE TRADING FLOOR", 0, 10⟩,
   ⟨"SYSOP", "SYSOP ONLY", 100, 100⟩]

/-- The callers. -/
def users : List User :=
  [⟨"SYSOP", hash "monster", 100⟩,
   ⟨"ZOS", hash "196883", 50⟩,
   ⟨"FREN", hash "shards", 20⟩,
   ⟨"GUEST", hash "guest", 5⟩]

/-- The seeded message base. -/
def seedMsgs : List Msg :=
  [⟨1, "GEN", "SYSOP", "WELCOME TO NIXWARS BBS",
     "Twenty-two cabinets, five wires and no server. Press M for the message areas, D for the doors.", none⟩,
   ⟨2, "GEN", "FREN", "Re: WELCOME TO NIXWARS BBS",
     "Called in on a 300 baud handset and the whole board still fits in the address bar.", some 1⟩,
   ⟨3, "NIX", "ZOS", "270 HOPS AND A FULL TANK",
     "Ninety-nine light years a hop costs no fuel at all. Lean proved the line; the tape room plays it.", none⟩,
   ⟨4, "NIX", "GUEST", "Re: 270 HOPS AND A FULL TANK",
     "Pasted the tape, watched it land on Sgr A*. Is the crown really only on shard 47?", some 3⟩,
   ⟨5, "NIX", "SYSOP", "Re: 270 HOPS AND A FULL TANK",
     "Only on 47. UNLOCK anywhere else is refused by the module itself, not by the page.", some 4⟩,
   ⟨6, "TRADE", "ZOS", "FUEL IS DEARER EVERY TIME YOU BUY IT",
     "Four loads of fuel off one warehouse cost 15, 16, 19, 21. The shelf empties and the price climbs.", none⟩,
   ⟨7, "SHARD", "ZOS", "CHORD ROUTING ON THE RING",
     "Seven chord hops reach any of the 71 shards, and the gossip doubles each round.", none⟩,
   ⟨8, "SYSOP", "SYSOP", "CALLERS LOG",
     "Nothing in this area leaves it: the read level is 100 and the machine will not walk you here without it.", none⟩]

/-- The board as it ships. -/
def board : Board :=
  { users := users
    areas := areas
    msgs := seedMsgs
    marks := [("GUEST", 2)]
    callers := ["GUEST", "FREN", "ZOS", "SYSOP"] }

/-- The board that ships is in order. -/
theorem board_WF : WF board := by
  refine ⟨by decide, ?_, by decide⟩
  decide

/-- The caller with the lowest level on the board. -/
def guest : User := ⟨"GUEST", hash "guest", 5⟩

/-- The sysop's area. -/
def sysopArea : Area := ⟨"SYSOP", "SYSOP ONLY", 100, 100⟩

/-- The shard operations area. -/
def shardArea : Area := ⟨"SHARD", "SHARD OPERATIONS", 10, 50⟩

/-- The sysop's area is closed to everyone else: `GUEST` sees nothing in it. -/
theorem guest_sees_no_sysop_area : unread board guest sysopArea = [] := by
  decide

/-- `GUEST` cannot post in the shard area, and trying changes nothing. -/
theorem guest_cannot_post_in_shard_area :
    post board guest shardArea "HELLO" "anyone there?" none = board :=
  post_refused_below_level (by decide)

/-- The thread message 5 hangs in, walked back to the message that started it. -/
theorem thread_of_five : ancestors board 5 5 = [4, 3] := by decide

/-- The drop file the board writes when `ZOS` opens the frontier run. -/
def zosDrop : Drop := ⟨"ZOS", 50, "frontier", 47, 1800⟩

/-- The text of that drop file, pinned. -/
theorem zosDrop_render : zosDrop.render = "ZOS\n50\nfrontier\n47\n1800\n" := by decide

end Bbs

end NixWars
