/-
  Roster.lean — the desk, restricted to the senators the dataset actually has.

  `RequestProject/Badges/Data/Claims.lean` is the table of the 100 addresses
  holding a Senate seat at the last of the dataset's 52 snapshots, and
  `ClaimFacts.lean` proves that table is what the snapshots yield.  This file
  points the desk at that table: who may hold a seat at the desk, what a
  senator's log looks like, and the one convenience the roster buys — every
  address on it is separator-free, so a senator's record is well formed as soon
  as the words they typed are.
-/

import RequestProject.Solfunmeme.Senate.Desk
import RequestProject.Solfunmeme.Badges.ClaimFacts

namespace Senate.Desk

open Senate.Wire

/-- The addresses holding a Senate seat at the last snapshot. -/
def roster : List String := Badges.Claim.claims.map (fun p => p.address)

/-- Is this address a sitting senator? -/
def isSenator (a : String) : Bool := roster.contains a

theorem roster_length : roster.length = 100 := by
  simp [roster, Badges.Claim.claims_length]

theorem roster_nodup : roster.Nodup := Badges.Claim.addresses_nodup

theorem mem_roster_iff {a : String} : isSenator a = true ↔ a ∈ roster := by
  simp [isSenator]

/-- The kind tags are legal fields. -/
theorem kindTag_sepFree (p : Payload) : SepFree (kindTag p) := by
  cases p <;> simp only [kindTag] <;> decide

/-- Every address on the roster is separator-free, so it is a legal field. -/
theorem roster_sepFree {a : String} (ha : a ∈ roster) : SepFree a := by
  have h := Badges.Claim.addresses_have_no_separator
  simp only [List.all_eq_true] at h
  obtain ⟨p, hp, rfl⟩ := List.mem_map.mp ha
  have := h p hp
  simpa [SepFree, sep] using this

/-- **A senator only has to watch their own words.**  For an address on the
roster, a record is well formed as soon as the nonce and the three payload
slots are separator-free: the tag, the address, the numbers and the kind are
legal fields already. -/
theorem wf_of_senator {r : Record} (ha : r.author ∈ roster)
    (hn : SepFree r.nonce) (hargs : ∀ a ∈ args r.payload, SepFree a) : wf r = true := by
  simp only [wf, fields, List.all_cons, List.all_eq_true, Bool.and_eq_true]
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · exact sepFreeB_iff.mpr (by decide)
  · exact sepFreeB_iff.mpr (roster_sepFree ha)
  · exact sepFreeB_iff.mpr (natStr_sepFree _)
  · exact sepFreeB_iff.mpr (natStr_sepFree _)
  · exact sepFreeB_iff.mpr hn
  · exact sepFreeB_iff.mpr (kindTag_sepFree r.payload)
  · intro a ha'
    exact sepFreeB_iff.mpr (hargs a (by simpa using ha'))

/-- The senators' part of a log. -/
def senateOnly (f : Feed) : Feed := f.filter (fun s => isSenator s.record.author)

theorem mem_senateOnly {f : Feed} {s : SignedRecord} :
    s ∈ senateOnly f ↔ s ∈ f ∧ s.record.author ∈ roster := by
  simp [senateOnly, List.mem_filter, mem_roster_iff]

/-- **What the desk shows under a Senate seat.**  Every record in the senators'
part of a valid log is signed by the key to an address that really does hold a
Senate seat in the dataset's last snapshot. -/
theorem senateOnly_authentic {V H} {HasKey : String → Prop}
    (hV : OnlyKeyHolderSigns V HasKey) {f : Feed} (hf : Valid V H f)
    {s : SignedRecord} (hs : s ∈ senateOnly f) :
    HasKey s.record.author ∧ s.record.author ∈ roster := by
  obtain ⟨hsf, hrost⟩ := mem_senateOnly.mp hs
  exact ⟨valid_author_holds_key hV hf hsf, hrost⟩

/-- Filtering to the roster removes records; it never adds or edits one. -/
theorem senateOnly_sublist (f : Feed) : (senateOnly f).Sublist f := List.filter_sublist

end Senate.Desk
