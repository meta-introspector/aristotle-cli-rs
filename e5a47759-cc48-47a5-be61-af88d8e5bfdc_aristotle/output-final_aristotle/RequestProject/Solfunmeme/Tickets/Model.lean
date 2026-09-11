/-
The canonical finite model of the SOLFUNMEME ticket knowledge base.
-/
import RequestProject.Solfunmeme.Tickets.TBox

/-!
# The corpus model

`corpusModel` is the interpretation the ticket database itself describes: its
domain is the 230 tickets and the 17 people, atomic concepts hold exactly where
the corpus says they do, and the defined concepts of the TBox (`WishListItem`
and friends) get the extension their definitions force.

`corpusModel_checks` is a single kernel computation checking that every TBox
inclusion and every ABox assertion holds in it. From it follows
`kb_consistent`: the ontology and the ticket database do not contradict each
other, so the entailments proved in `Queries.lean` are not vacuous.
-/

namespace SFM.Tickets

open SFM.DL

/-- The domain: every ticket and every person in the corpus. -/
def domList : List Nat := ticketNumbers ++ personKeys

/-- Membership of an individual in an atomic concept as recorded by the corpus. -/
def baseHas (c : CN) (d : Nat) : Bool := (maskOf d).testBit c.idx

/-- Role successors, cut down to the domain. -/
def succD (r : RN) (d : Nat) : List Nat :=
  (succRaw r d).filter (fun e => domList.contains e)

/-- The wish list, computed: an open ticket that asks for something. -/
def wishB (d : Nat) : Bool :=
  baseHas .StOpen d && askingConcepts.any (fun c => baseHas c d)

/-- A wish that waits on another open wish. -/
def blockedB (d : Nat) : Bool :=
  wishB d && (succD .Rreferences d).any (fun e => baseHas .StOpen e && wishB e)

/-- A wish with a declared prerequisite that is still open. -/
def waitingB (d : Nat) : Bool :=
  wishB d && (succD .RdependsOn d).any (fun e => baseHas .StOpen e)

/-- A wish that can be started today: unclaimed, unblocked, not waiting. -/
def readyB (d : Nat) : Bool :=
  ((wishB d && !baseHas .Assigned d) && !blockedB d) && !waitingB d

/-- The extension of every atomic concept in the corpus model: asserted
concepts come from the corpus, defined concepts are computed. -/
def atomBC : CN → Nat → Bool
  | .WishListItem, d => wishB d
  | .Rewarded, d => wishB d && (baseHas .LBounty d || baseHas .KBountyOffer d)
  | .Unclaimed, d => wishB d && !baseHas .Assigned d
  | .Blocked, d => blockedB d
  | .Actionable, d => (wishB d && !baseHas .Assigned d) && !blockedB d
  | .ProofWish, d => wishB d && baseHas .TProof d
  | .CommunityWish, d => wishB d && baseHas .FromOutside d
  | .EffMedium, d => (baseHas .Ticket d && !baseHas .EffSmall d) && !baseHas .EffLarge d
  | .Waiting, d => waitingB d
  | .Ready, d => readyB d
  | .QuickWin, d => readyB d && baseHas .EffSmall d
  | .Epic, d => wishB d && baseHas .EffLarge d
  | .NeedsSpec, d =>
      (wishB d && (baseHas .KIdea d || baseHas .KProposal d)) && !baseHas .KTask d
  | .Dormant, d => (wishB d && baseHas .Stale d) && !baseHas .CoreAnswered d
  | .Answered, d => wishB d && baseHas .CoreAnswered d
  | c, d => baseHas c d

/-- The interpretation described by the ticket database. -/
def corpusModel : FModel CN RN where
  dom := domList
  dom_ne := by decide
  atomB := atomBC
  succ := succD
  succ_sub := by
    intro r d e he
    have := (List.mem_filter.1 he).2
    simpa using this

set_option maxRecDepth 100000 in
set_option maxHeartbeats 4000000 in
/-- Everything in the knowledge base holds in the corpus model. -/
theorem corpusModel_checks : corpusModel.checkKB kb = true := by decide

/-- The corpus model is a model of the knowledge base. -/
theorem corpusModel_isModel : corpusModel.toInterp.IsModel kb :=
  FModel.isModel_of_checkKB corpusModel_checks

/-- **The ontology and the ticket database are consistent.** -/
theorem kb_consistent : kb.Consistent :=
  FModel.consistent_of_checkKB corpusModel_checks

/-- Consequently no individual is entailed to be absurd. -/
theorem kb_no_absurd_individual (i : Ind) : ¬ kb.entails (.inst i .bot) :=
  KB.not_entails_bot_of_consistent kb_consistent i

end SFM.Tickets
