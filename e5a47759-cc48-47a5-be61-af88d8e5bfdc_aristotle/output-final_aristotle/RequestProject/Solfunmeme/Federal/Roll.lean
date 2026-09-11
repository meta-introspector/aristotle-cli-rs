/-
  Roll.lean — the Senate's votes, taken from the senators' own desk.

  `RequestProject/Senate/` gives the senators a desk: a log of records, each one
  signed with the key to the address that publishes it, with replay protection,
  strictly increasing sequence numbers per author, and the rule that nothing may
  point at a record the log does not already hold.  `RequestProject/Senate/
  Roster.lean` restricts it to the 100 addresses that actually hold a Senate
  seat in the dataset's last snapshot.

  This file makes that desk the Senate's voting floor, so the federal chamber of
  `RequestProject/Federal/Congress.lean` is filled with real, key-holding
  senators rather than with numbers:

      a bill    is tabled as an ordinary `news` record on the desk;
      a vote    is a `comment` on that record whose text is exactly
                `SOLFUNMEME-FEDERAL-v1:AYE` or `SOLFUNMEME-FEDERAL-v1:NAY`.

  Nothing new has to be signed, verified or transmitted: a roll call is a
  reading of the log the senators already keep.

  What is proved:

    * `rollCall_authentic`, `rollCall_senator` — everybody counted holds the key
      to a seated address, and to an address on the roster whenever the seats
      are filled from it (the desk's unforgeability assumption is the only
      assumption made);
    * `rollCall_nodup` — one senator, one vote: later ballots by the same
      senator are discarded, so nobody is counted twice;
    * `rollCall_first_vote_wins` — and the ballot that counts is the one they
      cast first, so a senator cannot vote twice and keep the better one;
    * `bill_must_be_tabled` — a counted vote is a vote on a bill that is really
      on the desk, tabled before the vote was cast;
    * `rollCall_le_seats`, `chamberTally_cast` — the chamber cannot record more
      votes than it has members;
    * `passage_needs_quorum_of_ballots`, `passage_needs_quorum_of_senators` —
      passing a chamber takes signed ballots from a quorum of distinct
      key-holding senators.
-/

import RequestProject.Solfunmeme.Federal.Congress
import RequestProject.Solfunmeme.Senate.Roster

namespace Federal.Roll

open Senate.Desk

/-! ### Bills and ballots on the desk -/

/-- The source field that marks a desk news record as a tabled bill. -/
def billSource : String := "SOLFUNMEME-FEDERAL-v1"

/-- The exact text of an aye. -/
def ayeText : String := "SOLFUNMEME-FEDERAL-v1:AYE"

/-- The exact text of a nay. -/
def nayText : String := "SOLFUNMEME-FEDERAL-v1:NAY"

theorem aye_ne_nay : ayeText ≠ nayText := by decide

/-- Tabling a bill: a news record carrying the federal source tag. -/
def tableBill (url title : String) : Payload := .news url title billSource

/-- Casting a ballot on the bill with identifier `billId`. -/
def ballot (billId : String) (aye : Bool) : Payload :=
  .comment billId (if aye then ayeText else nayText)

/-- Reading a record as a ballot on a given bill. -/
def ballotOf (billId : String) (s : SignedRecord) : Option Bool :=
  match s.record.payload with
  | .comment parent text =>
      if parent = billId then
        if text = ayeText then some true
        else if text = nayText then some false
        else none
      else none
  | _ => none

theorem ballotOf_ballot (billId : String) (aye : Bool) {s : SignedRecord}
    (h : s.record.payload = ballot billId aye) : ballotOf billId s = some aye := by
  cases aye <;> simp [ballotOf, ballot, h, ayeText, nayText]

/-- A record read as a ballot is a comment on the bill. -/
theorem ballotOf_isComment {billId : String} {s : SignedRecord} {b : Bool}
    (h : ballotOf billId s = some b) :
    ∃ text, s.record.payload = .comment billId text := by
  unfold ballotOf at h
  split at h
  · next parent text heq =>
      by_cases hpar : parent = billId
      · exact ⟨text, by rw [heq, hpar]⟩
      · rw [if_neg hpar] at h; simp at h
  · simp at h

/-! ### The roll call -/

/-- Every ballot on the bill in the order the log holds them. -/
def ballots (billId : String) (f : Feed) : List (String × Bool) :=
  f.filterMap (fun s => (ballotOf billId s).map (fun b => (s.record.author, b)))

/-- Keep the first ballot of each author, discarding their later ones. -/
def dedupAuthors : List (String × Bool) → List (String × Bool)
  | [] => []
  | p :: t => p :: (dedupAuthors t).filter (fun q => q.1 != p.1)

/-- **The roll call.**  The log is read oldest first, only members holding a
seat are counted, and each of them is counted once, by the ballot they cast
first. -/
def rollCall (seat : List String) (billId : String) (f : Feed) : List (String × Bool) :=
  dedupAuthors ((ballots billId f.reverse).filter (fun p => seat.contains p.1))

/-- The chamber's tally: ayes, nays, and nobody counted as present who did not
vote. -/
def chamberTally (seat : List String) (billId : String) (f : Feed) : Tally :=
  let r := rollCall seat billId f
  ⟨(r.filter (fun p => p.2)).length, (r.filter (fun p => !p.2)).length, 0⟩

/-! ### Facts about deduplication -/

theorem dedupAuthors_sublist (l : List (String × Bool)) : (dedupAuthors l).Sublist l := by
  induction l with
  | nil => simp [dedupAuthors]
  | cons p t ih =>
    exact List.Sublist.cons₂ p (List.Sublist.trans List.filter_sublist ih)

theorem mem_dedupAuthors {l : List (String × Bool)} {p : String × Bool}
    (h : p ∈ dedupAuthors l) : p ∈ l :=
  (dedupAuthors_sublist l).subset h

/-- **One senator, one vote.** -/
theorem dedupAuthors_nodup (l : List (String × Bool)) :
    ((dedupAuthors l).map Prod.fst).Nodup := by
  induction l with
  | nil => simp [dedupAuthors]
  | cons p t ih =>
    simp only [dedupAuthors, List.map_cons, List.nodup_cons]
    constructor
    · intro hmem
      obtain ⟨q, hq, hfst⟩ := List.mem_map.mp hmem
      have := (List.mem_filter.mp hq).2
      simp only [bne_iff_ne, ne_eq] at this
      exact this hfst
    · exact List.Nodup.sublist (List.Sublist.map _ List.filter_sublist) ih

/-- The first ballot an author cast is the one that is kept. -/
theorem dedupAuthors_first {l : List (String × Bool)} {a : String} {b : Bool}
    (h : (a, b) ∈ dedupAuthors l) : ∃ pre suf, l = pre ++ (a, b) :: suf ∧ a ∉ pre.map Prod.fst := by
  induction l with
  | nil => simp [dedupAuthors] at h
  | cons p t ih =>
    rw [dedupAuthors] at h
    rcases List.mem_cons.mp h with rfl | hmem
    · exact ⟨[], t, by simp, by simp⟩
    · have hne : a ≠ p.1 := by
        have := (List.mem_filter.mp hmem).2
        simp only [bne_iff_ne, ne_eq] at this
        exact this
      obtain ⟨pre, suf, hsplit, hnot⟩ := ih (List.mem_filter.mp hmem).1
      exact ⟨p :: pre, suf, by rw [hsplit]; simp, by simp [hne, hnot]⟩

/-! ### Everybody counted is a senator who signed -/

theorem mem_rollCall_mem_ballots {seat : List String} {billId : String} {f : Feed}
    {p : String × Bool} (h : p ∈ rollCall seat billId f) :
    p ∈ ballots billId f.reverse ∧ p.1 ∈ seat := by
  have := mem_dedupAuthors h
  have h2 := List.mem_filter.mp this
  exact ⟨h2.1, by simpa using h2.2⟩

theorem mem_ballots {billId : String} {f : Feed} {p : String × Bool}
    (h : p ∈ ballots billId f) :
    ∃ s ∈ f, s.record.author = p.1 ∧ ballotOf billId s = some p.2 := by
  obtain ⟨s, hs, hmap⟩ := List.mem_filterMap.mp h
  cases hb : ballotOf billId s with
  | none => rw [hb] at hmap; simp at hmap
  | some b =>
    rw [hb] at hmap
    simp only [Option.map_some, Option.some.injEq] at hmap
    exact ⟨s, hs, by rw [← hmap], by rw [hb, ← hmap]⟩

/-- **Everybody counted holds a seat, and signed their ballot.**  Under the
desk's unforgeability assumption, every vote in a roll call taken from a valid
log was cast by the holder of the key to a seated address. -/
theorem rollCall_authentic {V H} {HasKey : String → Prop}
    (hV : OnlyKeyHolderSigns V HasKey) {f : Feed} (hf : Valid V H f)
    {seat : List String} {billId : String} {p : String × Bool}
    (hp : p ∈ rollCall seat billId f) : HasKey p.1 ∧ p.1 ∈ seat := by
  obtain ⟨hb, hsen⟩ := mem_rollCall_mem_ballots hp
  obtain ⟨s, hs, hauth, -⟩ := mem_ballots hb
  have hs' : s ∈ f := List.mem_reverse.mp hs
  refine ⟨?_, hsen⟩
  rw [← hauth]
  exact valid_author_holds_key hV hf hs'

/-- **And is a senator of the dataset**, when the seats are filled from the
roster. -/
theorem rollCall_senator {V H} {HasKey : String → Prop}
    (hV : OnlyKeyHolderSigns V HasKey) {f : Feed} (hf : Valid V H f)
    {seat : List String} (hseat : seat ⊆ roster) {billId : String} {p : String × Bool}
    (hp : p ∈ rollCall seat billId f) : HasKey p.1 ∧ p.1 ∈ roster := by
  obtain ⟨hkey, hmem⟩ := rollCall_authentic hV hf hp
  exact ⟨hkey, hseat hmem⟩

/-- **Nobody is counted twice.** -/
theorem rollCall_nodup (seat : List String) (billId : String) (f : Feed) :
    ((rollCall seat billId f).map Prod.fst).Nodup := dedupAuthors_nodup _

/-- **The first ballot is the one that counts.**  A senator who posts a second,
different ballot on the same bill does not change the roll call: the ballot kept
is the earliest one in the log. -/
theorem rollCall_first_vote_wins {seat : List String} {billId : String} {f : Feed}
    {a : String} {b : Bool} (h : (a, b) ∈ rollCall seat billId f) :
    ∃ pre suf, (ballots billId f.reverse).filter (fun p => seat.contains p.1)
        = pre ++ (a, b) :: suf ∧ a ∉ pre.map Prod.fst :=
  dedupAuthors_first h

/-- **You cannot vote on a bill nobody tabled.**  A ballot in a valid log is a
comment, so the desk's rule that references resolve backwards puts the bill on
the desk before the vote was cast. -/
theorem bill_must_be_tabled {V H} {f : Feed} (hf : Valid V H f) {billId : String}
    {pre : Feed} {s : SignedRecord} {rest : Feed} (hsplit : f = pre ++ s :: rest)
    {b : Bool} (hb : ballotOf billId s = some b) :
    ∃ t ∈ rest, rid H t.record = billId := by
  obtain ⟨text, hp⟩ := ballotOf_isComment hb
  exact comment_parent_exists hf hsplit hp

/-! ### Size of the roll -/

/-- **The roll is never longer than the chamber.**  Nobody outside the seated
membership is counted, and nobody is counted twice. -/
theorem rollCall_le_seats (seat : List String) (billId : String) (f : Feed) :
    (rollCall seat billId f).length ≤ seat.length := by
  classical
  have hsub : (rollCall seat billId f).map Prod.fst ⊆ seat := by
    intro a ha
    obtain ⟨p, hp, rfl⟩ := List.mem_map.mp ha
    exact (mem_rollCall_mem_ballots hp).2
  have hsubF : ((rollCall seat billId f).map Prod.fst).toFinset ⊆ seat.toFinset := by
    intro a ha
    simp only [List.mem_toFinset] at ha ⊢
    exact hsub ha
  have hlen : ((rollCall seat billId f).map Prod.fst).length ≤ seat.length :=
    calc ((rollCall seat billId f).map Prod.fst).length
        = ((rollCall seat billId f).map Prod.fst).toFinset.card :=
          (List.toFinset_card_of_nodup (rollCall_nodup seat billId f)).symm
      _ ≤ seat.toFinset.card := Finset.card_le_card hsubF
      _ ≤ seat.length := List.toFinset_card_le seat
  simpa using hlen

/-- Ayes and nays together are exactly the votes cast. -/
theorem chamberTally_cast (seat : List String) (billId : String) (f : Feed) :
    (chamberTally seat billId f).cast = (rollCall seat billId f).length := by
  simp only [chamberTally, Tally.cast, Nat.add_zero]
  induction rollCall seat billId f with
  | nil => simp
  | cons p t ih => cases hp : p.2 <;> simp [hp] <;> omega

/-- **A chamber cannot record more votes than it has members.** -/
theorem chamberTally_cast_le (seat : List String) (billId : String) (f : Feed) :
    (chamberTally seat billId f).cast ≤ seat.length := by
  rw [chamberTally_cast]; exact rollCall_le_seats seat billId f

/-! ### What passage costs -/

/-- **Passing a chamber takes a quorum of signed ballots.**  A bill carries the
chamber only if at least `quorum c` distinct seated members put a signed ballot
on the desk. -/
theorem passage_needs_quorum_of_ballots {c : Chamber} {seat : List String} {billId : String}
    {f : Feed} (h : passes c (chamberTally seat billId f) = true) :
    quorum c ≤ (rollCall seat billId f).length := by
  simp only [passes, hasQuorum, Bool.and_eq_true, decide_eq_true_eq] at h
  have hq := h.1.1
  rwa [chamberTally_cast] at hq

/-- And every one of those ballots is a distinct key-holding senator. -/
theorem passage_needs_quorum_of_senators {V H} {HasKey : String → Prop}
    (hV : OnlyKeyHolderSigns V HasKey) {f : Feed} (hf : Valid V H f) {c : Chamber}
    {seat : List String} (hseat : seat ⊆ roster) {billId : String}
    (h : passes c (chamberTally seat billId f) = true) :
    ∃ voters : List String, voters.Nodup ∧ quorum c ≤ voters.length ∧
      ∀ a ∈ voters, HasKey a ∧ a ∈ roster := by
  refine ⟨(rollCall seat billId f).map Prod.fst, rollCall_nodup seat billId f, ?_, ?_⟩
  · simpa using passage_needs_quorum_of_ballots h
  · intro a ha
    obtain ⟨p, hp, rfl⟩ := List.mem_map.mp ha
    exact rollCall_senator hV hf hseat hp

end Federal.Roll
