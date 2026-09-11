/-
Reasoning over the SOLFUNMEME ticket knowledge base: the wish list.
-/
import RequestProject.Solfunmeme.Tickets.Model

/-!
# Querying the ticket database

What the ontology buys us. Three kinds of statement live here.

**Entailments** hold in *every* model of the knowledge base, so they are
consequences of the ontology and the ticket database alone:

* `wish_entailed` — a ticket the corpus records as open and asking for
  something is, necessarily, on the wish list;
* `wishListItem_sub_ticket`, `actionable_sub_wishListItem`, … — the shape of
  the wish list: every wish is an open ticket, every actionable wish is an
  unclaimed wish, nothing is both actionable and blocked;
* `ticket10_rewarded`, `ticket175_proofWish`, `ticket42_communityWish` — worked
  examples on real tickets.

**Non-entailments** are refuted by exhibiting the corpus model, in which the
statement fails: `ticket13_not_wish` (a closed ticket is not entailed to be a
wish) and `wish_not_sub_rewarded` (most wishes carry no bounty).

**Computations** report what the corpus model actually says: the wish list has
105 of the 230 tickets, 99 of them actionable, 31 about proofs and formal
methods, 9 raised from outside the core team, 14 with a reward attached.
-/

namespace SFM.Tickets

open SFM.DL

set_option maxRecDepth 200000

/-! ## The wish list, read off the corpus -/

/-- Does the corpus record this ticket as open and asking for something? -/
def isWishB (n : Nat) : Bool :=
  hasC n .StOpen && askingConcepts.any (fun c => hasC n c)

/-- The wish list: every ticket the corpus records as an open request. -/
def wishNumbers : List Nat := ticketNumbers.filter isWishB

/-- **A ticket the corpus records as open and asking for something is on the
wish list in every model of the knowledge base.** -/
theorem wish_entailed {n : Nat} (h : isWishB n = true) :
    kb.entails (.inst n (cn .WishListItem)) := by
  rw [isWishB, Bool.and_eq_true, List.any_eq_true] at h
  obtain ⟨hopen, c, hc, hcn⟩ := h
  intro M hM
  have hax : (⟨wishBody, cn .WishListItem⟩ : TGCI) ∈ kb.tbox := by decide
  refine hM.1 _ hax (M.ind n) ⟨entails_of_hasC hopen M hM, ?_⟩
  exact M.eval_orAll_of_mem _ (List.mem_map_of_mem hc) (entails_of_hasC hcn M hM)

/-- Every ticket on the computed wish list really is entailed to be one. -/
theorem mem_wishNumbers_entails {n : Nat} (h : n ∈ wishNumbers) :
    kb.entails (.inst n (cn .WishListItem)) :=
  wish_entailed (List.mem_filter.1 h).2

/-- The wish list has 105 of the 230 tickets. -/
theorem wishNumbers_length : wishNumbers.length = 105 := by decide

/-- The wish list read off the ABox is exactly the extension of
`WishListItem` in the corpus model. -/
theorem extension_wishListItem :
    corpusModel.extension (cn .WishListItem) = wishNumbers := by decide

/-! ## The shape of the wish list

These are pure TBox consequences: they hold for any ticket database at all,
not just this one. -/

private theorem tbox_mem {g : TGCI} (h : g ∈ tbox) : g ∈ kb.tbox := h

/-- Every wish is an open ticket. -/
theorem wishListItem_sub_open : kb.entailsGCI ⟨cn .WishListItem, cn .StOpen⟩ := by
  intro M hM d hd
  have hax : (⟨cn .WishListItem, wishBody⟩ : TGCI) ∈ kb.tbox := by decide
  exact (hM.1 _ hax d hd).1

/-- Every wish is a ticket. -/
theorem wishListItem_sub_ticket : kb.entailsGCI ⟨cn .WishListItem, cn .Ticket⟩ := by
  refine KB.entailsGCI_trans wishListItem_sub_open ?_
  exact KB.entailsGCI_of_mem_tbox (by decide : (⟨cn .StOpen, cn .Ticket⟩ : TGCI) ∈ kb.tbox)

/-- No wish is a closed ticket. -/
theorem wishListItem_not_closed : kb.entailsGCI ⟨cn .WishListItem, ¬ᶜ(cn .StClosed)⟩ := by
  intro M hM d hd
  have hopen : M.eval (cn .StOpen) d := wishListItem_sub_open M hM d hd
  have hdis : (⟨cn .StOpen ⊓ᶜ cn .StClosed, .bot⟩ : TGCI) ∈ kb.tbox := by decide
  exact fun hclosed => hM.1 _ hdis d ⟨hopen, hclosed⟩

/-- Every unclaimed wish is a wish. -/
theorem unclaimed_sub_wishListItem : kb.entailsGCI ⟨cn .Unclaimed, cn .WishListItem⟩ := by
  intro M hM d hd
  have hax : (⟨cn .Unclaimed, cn .WishListItem ⊓ᶜ ¬ᶜ(cn .Assigned)⟩ : TGCI) ∈ kb.tbox := by
    decide
  exact (hM.1 _ hax d hd).1

/-- Every actionable wish is an unclaimed wish. -/
theorem actionable_sub_unclaimed : kb.entailsGCI ⟨cn .Actionable, cn .Unclaimed⟩ := by
  intro M hM d hd
  have hax : (⟨cn .Actionable, cn .Unclaimed ⊓ᶜ ¬ᶜ(cn .Blocked)⟩ : TGCI) ∈ kb.tbox := by
    decide
  exact (hM.1 _ hax d hd).1

/-- Every actionable wish is a wish. -/
theorem actionable_sub_wishListItem : kb.entailsGCI ⟨cn .Actionable, cn .WishListItem⟩ :=
  KB.entailsGCI_trans actionable_sub_unclaimed unclaimed_sub_wishListItem

/-- Nothing is both actionable and blocked. -/
theorem actionable_blocked_disjoint :
    kb.entailsGCI ⟨cn .Actionable ⊓ᶜ cn .Blocked, .bot⟩ := by
  intro M hM d hd
  have hax : (⟨cn .Actionable, cn .Unclaimed ⊓ᶜ ¬ᶜ(cn .Blocked)⟩ : TGCI) ∈ kb.tbox := by
    decide
  exact (hM.1 _ hax d hd.1).2 hd.2

/-- Every rewarded wish is a wish. -/
theorem rewarded_sub_wishListItem : kb.entailsGCI ⟨cn .Rewarded, cn .WishListItem⟩ := by
  intro M hM d hd
  have hax : (⟨cn .Rewarded, cn .WishListItem ⊓ᶜ (cn .LBounty ⊔ᶜ cn .KBountyOffer)⟩ : TGCI)
      ∈ kb.tbox := by decide
  exact (hM.1 _ hax d hd).1

/-- Every blocked wish waits on an open wish. -/
theorem blocked_waits :
    kb.entailsGCI ⟨cn .Blocked, Concept.ex .Rreferences (cn .StOpen ⊓ᶜ cn .WishListItem)⟩ := by
  intro M hM d hd
  have hax : (⟨cn .Blocked,
      cn .WishListItem ⊓ᶜ Concept.ex .Rreferences (cn .StOpen ⊓ᶜ cn .WishListItem)⟩ : TGCI)
      ∈ kb.tbox := by decide
  exact (hM.1 _ hax d hd).2

/-- Every ticket has an author, and that author is a person. -/
theorem ticket_has_author :
    kb.entailsGCI ⟨cn .Ticket, Concept.ex .RauthoredBy (cn .Person)⟩ :=
  KB.entailsGCI_of_mem_tbox
    (by decide : (⟨cn .Ticket, Concept.ex .RauthoredBy (cn .Person)⟩ : TGCI) ∈ kb.tbox)

/-! ## Worked examples on real tickets -/

/-- Ticket 10, "bounty 2 zost : How to use an ai to help out and earn credits",
is a wish with a reward attached. -/
theorem ticket10_rewarded : kb.entails (.inst 10 (cn .Rewarded)) := by
  intro M hM
  have hax : (⟨cn .WishListItem ⊓ᶜ (cn .LBounty ⊔ᶜ cn .KBountyOffer), cn .Rewarded⟩ : TGCI)
      ∈ kb.tbox := by decide
  exact hM.1 _ hax (M.ind 10)
    ⟨wish_entailed (by decide) M hM, Or.inl (entails_of_hasC (by decide) M hM)⟩

/-- Ticket 175, "manifesto about recursive, self-carrying proof systems", is a
wish about proofs and formal methods. -/
theorem ticket175_proofWish : kb.entails (.inst 175 (cn .ProofWish)) := by
  intro M hM
  have hax : (⟨cn .WishListItem ⊓ᶜ cn .TProof, cn .ProofWish⟩ : TGCI) ∈ kb.tbox := by decide
  exact hM.1 _ hax (M.ind 175)
    ⟨wish_entailed (by decide) M hM, entails_of_hasC (by decide) M hM⟩

/-- Ticket 42, "Project Proposal: SOLFUNMEME Token Swap Platform", is a wish
raised from outside the core team. -/
theorem ticket42_communityWish : kb.entails (.inst 42 (cn .CommunityWish)) := by
  intro M hM
  have hax : (⟨cn .WishListItem ⊓ᶜ cn .FromOutside, cn .CommunityWish⟩ : TGCI) ∈ kb.tbox := by
    decide
  exact hM.1 _ hax (M.ind 42)
    ⟨wish_entailed (by decide) M hM, entails_of_hasC (by decide) M hM⟩

/-! ## What the knowledge base does *not* say -/

/-- Ticket 13 is closed, so nothing makes it a wish: the corpus model is a
model of the knowledge base in which it is not one. -/
theorem ticket13_not_wish : ¬ kb.entails (.inst 13 (cn .WishListItem)) := by
  refine KB.not_entails_of_model corpusModel_isModel ?_
  show ¬ corpusModel.toInterp.eval (cn .WishListItem) (corpusModel.pt 13)
  rw [FModel.eval_iff]
  decide

/-- Being on the wish list does not mean being paid for: the corpus model has
wishes with no reward. -/
theorem wish_not_sub_rewarded :
    ¬ kb.entailsGCI ⟨cn .WishListItem, cn .Rewarded⟩ := by
  refine KB.not_entailsGCI_of_model corpusModel_isModel ?_
  intro hsub
  have h := hsub (corpusModel.pt 3)
  rw [FModel.eval_iff, FModel.eval_iff] at h
  exact absurd (h (by decide)) (by decide)

/-! ## The wish list in numbers

Extensions in the corpus model. These are computations about this particular
ticket database, checked by the kernel. -/

/-- The knowledge base: 93 inclusions and 2593 assertions about 273
individuals — 230 tickets and the 43 people who opened, were assigned to,
commented on or reacted to them. -/
theorem kb_size :
    kb.tbox.length = 93 ∧ kb.abox.length = 2593 ∧ domList.length = 273 := by
  refine ⟨by decide, by decide, by decide⟩

/-- 230 tickets in the database. -/
theorem count_tickets : (corpusModel.extension (cn .Ticket)).length = 230 := by decide

/-- 105 of them are on the wish list. -/
theorem count_wishes : (corpusModel.extension (cn .WishListItem)).length = 105 := by decide

/-- 99 wishes can be worked on right now: unclaimed and waiting on nothing. -/
theorem count_actionable : (corpusModel.extension (cn .Actionable)).length = 99 := by decide

/-- 31 wishes are about proofs, ontology or formal methods. -/
theorem count_proofWishes : (corpusModel.extension (cn .ProofWish)).length = 31 := by decide

/-- 9 wishes were raised from outside the core team. -/
theorem count_communityWishes :
    (corpusModel.extension (cn .CommunityWish)).length = 9 := by decide

/-- 14 wishes have a reward attached. -/
theorem count_rewarded : (corpusModel.extension (cn .Rewarded)).length = 14 := by decide

/-- Exactly two wishes are blocked on another open wish. -/
theorem blocked_wishes : corpusModel.extension (cn .Blocked) = [31, 186] := by decide

/-- How the wish list divides up by topic (tickets can have several topics). -/
theorem wish_topic_counts :
    topicConcepts.map
        (fun c => (c, (corpusModel.extension (cn .WishListItem ⊓ᶜ cn c)).length)) =
      [(.TAI, 51), (.TAgent, 34), (.TProof, 31), (.TSolana, 53), (.TInfra, 27),
       (.TDocs, 29), (.TNetwork, 4), (.TCommunity, 39), (.TGovernance, 35),
       (.TSecurity, 46), (.TInstaller, 21), (.TArt, 31)] := by decide

/-- The wishes about proofs and formal methods. -/
theorem proof_wishes :
    corpusModel.extension (cn .ProofWish) =
      [17, 43, 46, 120, 125, 131, 138, 145, 148, 149, 160, 161, 162, 165, 166, 168, 171,
       174, 175, 176, 178, 186, 188, 189, 191, 196, 203, 205, 207, 227, 230] := by decide

/-- The wishes raised from outside the core team. -/
theorem community_wishes :
    corpusModel.extension (cn .CommunityWish) = [3, 19, 42, 43, 48, 50, 52, 69, 101] := by
  decide

/-! ## Planning

The concepts a plan is written in — `Ready`, `QuickWin`, `Epic`, `NeedsSpec`,
`Dormant`, `Answered` — come from the comment dump and the size rules of
`scripts/codeberg_tickets.py`. First what the ontology forces, then what this
particular database says. -/

/-- Every ready wish is an actionable wish. -/
theorem ready_sub_actionable : kb.entailsGCI ⟨cn .Ready, cn .Actionable⟩ := by
  intro M hM d hd
  have hax : (⟨cn .Ready, cn .Actionable ⊓ᶜ ¬ᶜ(cn .Waiting)⟩ : TGCI) ∈ kb.tbox := by decide
  exact (hM.1 _ hax d hd).1

/-- Every ready wish is a wish. -/
theorem ready_sub_wishListItem : kb.entailsGCI ⟨cn .Ready, cn .WishListItem⟩ :=
  KB.entailsGCI_trans ready_sub_actionable actionable_sub_wishListItem

/-- Every quick win is ready to start. -/
theorem quickWin_sub_ready : kb.entailsGCI ⟨cn .QuickWin, cn .Ready⟩ := by
  intro M hM d hd
  have hax : (⟨cn .QuickWin, cn .Ready ⊓ᶜ cn .EffSmall⟩ : TGCI) ∈ kb.tbox := by decide
  exact (hM.1 _ hax d hd).1

/-- Nothing ready is waiting on a prerequisite. -/
theorem ready_waiting_disjoint : kb.entailsGCI ⟨cn .Ready ⊓ᶜ cn .Waiting, .bot⟩ := by
  intro M hM d hd
  have hax : (⟨cn .Ready, cn .Actionable ⊓ᶜ ¬ᶜ(cn .Waiting)⟩ : TGCI) ∈ kb.tbox := by decide
  exact (hM.1 _ hax d hd.1).2 hd.2

/-- Every waiting wish really has a prerequisite that is still open. -/
theorem waiting_has_open_prerequisite :
    kb.entailsGCI ⟨cn .Waiting, Concept.ex .RdependsOn (cn .StOpen)⟩ := by
  intro M hM d hd
  have hax : (⟨cn .Waiting, cn .WishListItem ⊓ᶜ Concept.ex .RdependsOn (cn .StOpen)⟩ : TGCI)
      ∈ kb.tbox := by decide
  exact (hM.1 _ hax d hd).2

/-- No ticket is both small and large. -/
theorem small_large_disjoint : kb.entailsGCI ⟨cn .EffSmall ⊓ᶜ cn .EffLarge, .bot⟩ :=
  KB.entailsGCI_of_mem_tbox
    (by decide : (⟨cn .EffSmall ⊓ᶜ cn .EffLarge, .bot⟩ : TGCI) ∈ kb.tbox)

/-- A ticket is discussed exactly when somebody commented on it. -/
theorem discussed_iff_spoken :
    kb.entailsGCI ⟨cn .Discussed, Concept.ex .RdiscussedBy (cn .Person)⟩ ∧
    kb.entailsGCI ⟨cn .Ticket ⊓ᶜ Concept.ex .RdiscussedBy (cn .Person), cn .Discussed⟩ := by
  constructor
  · intro M hM d hd
    have hax : (⟨cn .Discussed, cn .Ticket ⊓ᶜ Concept.ex .RdiscussedBy (cn .Person)⟩ : TGCI)
        ∈ kb.tbox := by decide
    exact (hM.1 _ hax d hd).2
  · exact KB.entailsGCI_of_mem_tbox
      (by decide : (⟨cn .Ticket ⊓ᶜ Concept.ex .RdiscussedBy (cn .Person),
        cn .Discussed⟩ : TGCI) ∈ kb.tbox)

/-- Every wish the core team has answered is a discussed wish. -/
theorem answered_sub_discussed : kb.entailsGCI ⟨cn .Answered, cn .Discussed⟩ := by
  refine KB.entailsGCI_trans ?_ (KB.entailsGCI_of_mem_tbox
    (by decide : (⟨cn .CoreAnswered, cn .Discussed⟩ : TGCI) ∈ kb.tbox))
  intro M hM d hd
  have hax : (⟨cn .Answered, cn .WishListItem ⊓ᶜ cn .CoreAnswered⟩ : TGCI) ∈ kb.tbox := by
    decide
  exact (hM.1 _ hax d hd).2

/-- **The tracker declares no prerequisites at all**: no ticket says in words
that it depends on, is blocked by or waits for another one, so nothing is
`Waiting` and everything actionable is ready to start. -/
theorem no_waiting_wishes : corpusModel.extension (cn .Waiting) = [] := by decide

/-- Consequently the ready wishes are exactly the actionable ones. -/
theorem ready_eq_actionable :
    corpusModel.extension (cn .Ready) = corpusModel.extension (cn .Actionable) := by decide

/-- 24 wishes are quick wins: ready to start, short, and with a quiet thread. -/
theorem count_quickWins : (corpusModel.extension (cn .QuickWin)).length = 24 := by decide

/-- The quick wins, by ticket number. -/
theorem quick_wins :
    corpusModel.extension (cn .QuickWin) =
      [11, 19, 23, 24, 27, 35, 36, 40, 41, 55, 62, 77, 87, 94, 95, 96, 98, 100, 143,
       159, 164, 172, 192, 215] := by decide

/-- 44 wishes are epics: a long ticket, or a long thread. -/
theorem count_epics : (corpusModel.extension (cn .Epic)).length = 44 := by decide

/-- 56 wishes are written as an idea or a proposal with no concrete task in
them: they need a specification before they can be implemented. -/
theorem count_needsSpec : (corpusModel.extension (cn .NeedsSpec)).length = 56 := by decide

/-- 53 wishes have an answer from the core team; 49 have gone quiet without
one. -/
theorem count_answered_dormant :
    (corpusModel.extension (cn .Answered)).length = 53 ∧
    (corpusModel.extension (cn .Dormant)).length = 49 := by
  refine ⟨by decide, by decide⟩

/-- The comment dump in numbers: 115 of the 230 tickets have been commented
on, the maintainer has answered on 112 of them, 32 carry a thread of five
comments or more, and 206 have seen no activity for six months. -/
theorem discussion_counts :
    (corpusModel.extension (cn .Discussed)).length = 115 ∧
    (corpusModel.extension (cn .CoreAnswered)).length = 112 ∧
    (corpusModel.extension (cn .HotTopic)).length = 32 ∧
    (corpusModel.extension (cn .Stale)).length = 206 := by
  refine ⟨by decide, by decide, by decide, by decide⟩

/-- **Endorsement is rare**: in the whole history of the tracker four tickets
have ever been reacted to, and only one of them — #10, the 2 ZOST bounty — is
on the wish list. It is too thin a signal to sort a plan by. -/
theorem endorsed_tickets :
    corpusModel.extension (cn .Endorsed) = [10, 13, 92, 112] ∧
    corpusModel.extension (cn .Endorsed ⊓ᶜ cn .WishListItem) = [10] := by
  refine ⟨by decide, by decide⟩

/-- How the tickets divide up by size: 81 small, 81 medium, 68 large. -/
theorem size_counts :
    (corpusModel.extension (cn .EffSmall)).length = 81 ∧
    (corpusModel.extension (cn .EffMedium)).length = 81 ∧
    (corpusModel.extension (cn .EffLarge)).length = 68 := by
  refine ⟨by decide, by decide, by decide⟩

end SFM.Tickets
