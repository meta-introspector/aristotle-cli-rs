/-
  Supersede.lean — the replacement, stated as a theorem.

  Two rules, one electorate.  `RequestProject/Review/PublishedData.lean` shows
  the dataset's own rule is unsatisfiable: quorum is a majority of a *nominal*
  chamber of 100 while `proofs/credentials.json` records 42 senate credentials
  ever issued, so every vote the electorate can cast resolves to `noQuorum` and
  no bill can be enacted.  This file puts the two rules side by side on the
  same page:

    * `old_rule_kills_every_vote` — under the published rule, no vote by the
      credentials that exist reaches a quorum;
    * `new_rule_is_live` — under the new chamber's rule, the chamber reaches a
      quorum and carries a motion at every threshold;
    * `replacement_is_not_vacuous` — both at once, so the replacement changes
      the answer rather than restating it.

  The new chamber is not a larger electorate: it seats exactly the hundred
  badge holders the dataset supports (`chamber_holders_are_senators`).  What
  changes is that a quorum is taken from the seats that exist rather than from
  seats the dataset never filled.
-/

import RequestProject.Solfunmeme.Chamber.Roster
import RequestProject.Solfunmeme.Review.PublishedData

namespace Chamber.Seated

open Review.PublishedData

/-- **The old rule kills every vote the electorate can cast.** -/
theorem old_rule_kills_every_vote (v : ChamberVote) (hsize : v.size = senateSize)
    (hcred : v.yea + v.nay ≤ senateCredentials) : chamberQuorum v = false :=
  senate_quorum_unreachable v hsize hcred

/-- **The new rule is live.** -/
theorem new_rule_is_live : Chamber.hasQuorum chamber (Chamber.unanimous chamber) = true :=
  Chamber.quorum_attainable chamber (by simp [chamber_size])

/-- **The replacement changes the answer.**  On the same electorate the old
rule admits no quorum at all and the new one carries a motion at the highest
threshold the charter knows. -/
theorem replacement_is_not_vacuous :
    (∀ v : ChamberVote, v.size = senateSize → v.yea + v.nay ≤ senateCredentials →
      chamberQuorum v = false) ∧
    Chamber.carries chamber Chamber.Threshold.threeQuarters (Chamber.unanimous chamber) = true :=
  ⟨fun v h1 h2 => old_rule_kills_every_vote v h1 h2, chamber_can_act _⟩

end Chamber.Seated
