/-
The SOLFUNMEME ticket ontology: the TBox, the ABox, and the knowledge base.
-/
import RequestProject.Solfunmeme.Tickets.Corpus

/-!
# The ontology

The TBox says what the vocabulary of `Vocabulary.lean` *means*: how the state
of a ticket, its labels, its author and its links constrain each other, and —
the point of the exercise — what counts as an item on the project's **wish
list**.

The wish list is defined here, not asserted:

```
WishListItem ≡ StOpen ⊓ (LBounty ⊔ LFeature ⊔ LEnhancement
                          ⊔ KProposal ⊔ KIdea ⊔ KRequest ⊔ KTask ⊔ KBountyOffer)
```

an open ticket that asks for something — a labelled feature or bounty, or a
ticket whose own wording is a proposal, an idea, a request, a task or a bounty
offer. Everything else about the wish list (`Rewarded`, `Unclaimed`, `Blocked`,
`Actionable`, `ProofWish`, `CommunityWish`) is defined from it.

The ABox is the corpus: the concept and role assertions generated from the
codeberg ticket database.
-/

namespace SFM.Tickets

open SFM.DL

@[inherit_doc] scoped infixl:65 " ⊓ᶜ " => Concept.and
@[inherit_doc] scoped infixl:60 " ⊔ᶜ " => Concept.or
@[inherit_doc] scoped prefix:max "¬ᶜ" => Concept.neg

/-- `C ⊑ D`. -/
def sub (C D : TConcept) : TGCI := ⟨C, D⟩

/-- `C ≡ D`, as the two inclusions. -/
def equiv (C D : TConcept) : List TGCI := [⟨C, D⟩, ⟨D, C⟩]

/-! ## The concepts that classify a ticket -/

/-- Concepts that only tickets can belong to. -/
def ticketOnly : List CN :=
  [.StOpen, .StClosed, .Assigned, .Milestoned, .Discussed, .FromOutside,
   .LBounty, .LFeature, .LEnhancement, .LDocumentation, .LSecurity, .LTesting,
   .LBug, .LPriorityHigh, .LSkibidi,
   .KProposal, .KIdea, .KQuestion, .KPlan, .KBountyOffer, .KRequest, .KTask,
   .TAI, .TAgent, .TProof, .TSolana, .TInfra, .TDocs, .TNetwork, .TCommunity,
   .TGovernance, .TSecurity, .TInstaller, .TArt,
   .CoreAnswered, .HotTopic, .Stale, .EffSmall, .EffLarge, .Endorsed]

/-- The topics a ticket can be about. -/
def topicConcepts : List CN :=
  [.TAI, .TAgent, .TProof, .TSolana, .TInfra, .TDocs, .TNetwork, .TCommunity,
   .TGovernance, .TSecurity, .TInstaller, .TArt]

/-- The ways a ticket can ask for something. -/
def askingConcepts : List CN :=
  [.LBounty, .LFeature, .LEnhancement, .KProposal, .KIdea, .KRequest, .KTask,
   .KBountyOffer]

/-- `Asking`: the disjunction of the ways a ticket can ask for something. -/
def asking : TConcept := Concept.orAll (askingConcepts.map cn)

/-- The body of the definition of the wish list. -/
def wishBody : TConcept := cn .StOpen ⊓ᶜ asking

/-! ## The TBox -/

/-- Structural axioms: states, people, and how tickets relate to them. -/
def tboxStructure : List TGCI :=
  [ sub (cn .Ticket) (cn .StOpen ⊔ᶜ cn .StClosed)
  , sub (cn .StOpen ⊓ᶜ cn .StClosed) .bot
  , sub (cn .Person) ¬ᶜ(cn .Ticket)
  , sub (cn .CoreDev) (cn .Person)
  , sub (cn .Outsider) (cn .Person)
  , sub (cn .CoreDev ⊓ᶜ cn .Outsider) .bot
  , sub (cn .Ticket) (Concept.ex .RauthoredBy (cn .Person))
  , sub (cn .Ticket) (Concept.all .Rreferences (cn .Ticket))
  , sub (cn .Assigned) (Concept.ex .RassignedTo (cn .Person))
  , sub (cn .Ticket ⊓ᶜ Concept.ex .RassignedTo (cn .Person)) (cn .Assigned)
  , sub (cn .FromOutside) (Concept.ex .RauthoredBy (cn .Outsider))
  , sub (cn .Ticket ⊓ᶜ Concept.ex .RauthoredBy (cn .Outsider)) (cn .FromOutside) ]

/-- What the comment dump adds: who spoke on a ticket, whether the maintainer
answered, how big the ticket is. -/
def tboxDiscussion : List TGCI :=
  [ sub (cn .Ticket) (Concept.all .RdiscussedBy (cn .Person))
  , sub (cn .Ticket) (Concept.all .RdependsOn (cn .Ticket))
  , sub (cn .Ticket) (Concept.all .Rmentions (cn .Ticket))
  , sub (cn .CoreAnswered) (cn .Discussed)
  , sub (cn .HotTopic) (cn .Discussed)
  , sub (cn .EffSmall ⊓ᶜ cn .EffLarge) .bot
  , sub (cn .Ticket) (Concept.all .RendorsedBy (cn .Person)) ]
  ++ equiv (cn .Discussed) (cn .Ticket ⊓ᶜ Concept.ex .RdiscussedBy (cn .Person))
  ++ equiv (cn .Endorsed) (cn .Ticket ⊓ᶜ Concept.ex .RendorsedBy (cn .Person))

/-- Every label, kind and topic concept applies to tickets only. -/
def tboxTicketOnly : List TGCI := ticketOnly.map (fun c => sub (cn c) (cn .Ticket))

/-- The definitions of the wish list and of everything derived from it. -/
def tboxWishList : List TGCI :=
  equiv (cn .WishListItem) wishBody
  ++ equiv (cn .Rewarded) (cn .WishListItem ⊓ᶜ (cn .LBounty ⊔ᶜ cn .KBountyOffer))
  ++ equiv (cn .Unclaimed) (cn .WishListItem ⊓ᶜ ¬ᶜ(cn .Assigned))
  ++ equiv (cn .Blocked)
      (cn .WishListItem ⊓ᶜ Concept.ex .Rreferences (cn .StOpen ⊓ᶜ cn .WishListItem))
  ++ equiv (cn .Actionable) (cn .Unclaimed ⊓ᶜ ¬ᶜ(cn .Blocked))
  ++ equiv (cn .ProofWish) (cn .WishListItem ⊓ᶜ cn .TProof)
  ++ equiv (cn .CommunityWish) (cn .WishListItem ⊓ᶜ cn .FromOutside)

/-- The concepts a plan is written in: what is ready to start, what is small,
what still needs a specification, and what has gone quiet. -/
def tboxPlanning : List TGCI :=
  equiv (cn .EffMedium) (cn .Ticket ⊓ᶜ ¬ᶜ(cn .EffSmall) ⊓ᶜ ¬ᶜ(cn .EffLarge))
  ++ equiv (cn .Waiting)
      (cn .WishListItem ⊓ᶜ Concept.ex .RdependsOn (cn .StOpen))
  ++ equiv (cn .Ready) (cn .Actionable ⊓ᶜ ¬ᶜ(cn .Waiting))
  ++ equiv (cn .QuickWin) (cn .Ready ⊓ᶜ cn .EffSmall)
  ++ equiv (cn .Epic) (cn .WishListItem ⊓ᶜ cn .EffLarge)
  ++ equiv (cn .NeedsSpec)
      (cn .WishListItem ⊓ᶜ (cn .KIdea ⊔ᶜ cn .KProposal) ⊓ᶜ ¬ᶜ(cn .KTask))
  ++ equiv (cn .Dormant) (cn .WishListItem ⊓ᶜ cn .Stale ⊓ᶜ ¬ᶜ(cn .CoreAnswered))
  ++ equiv (cn .Answered) (cn .WishListItem ⊓ᶜ cn .CoreAnswered)

/-- The terminology of the SOLFUNMEME ticket ontology. -/
def tbox : List TGCI :=
  tboxStructure ++ tboxDiscussion ++ tboxTicketOnly ++ tboxWishList ++ tboxPlanning

/-! ## The ABox -/

/-- The assertions of the corpus: `C(i)` for every generated concept fact and
`r(i, j)` for every generated role fact. -/
def abox : List TAssertion :=
  conceptFacts.flatMap (fun p => p.2.map (fun c => Assertion.inst p.1 (cn c)))
    ++ roleFacts.map (fun t => Assertion.rel t.1 t.2.1 t.2.2)

/-- The knowledge base: the ontology together with the codeberg ticket
database. -/
def kb : TKB := ⟨tbox, abox⟩

/-! ## Reading facts off the corpus -/

/-- The concepts asserted of an individual by the corpus. -/
def factsOf (n : Nat) : List CN := (conceptFacts.lookup n).getD []

/-- Does the corpus assert the concept `c` of the individual `n`? -/
def hasC (n : Nat) (c : CN) : Bool := (factsOf n).contains c

private theorem mem_of_lookup {β : Type} : ∀ {l : List (Nat × β)} {a : Nat} {b : β},
    l.lookup a = some b → (a, b) ∈ l := by
  intro l
  induction l with
  | nil => intro a b h; simp [List.lookup] at h
  | cons x t ih =>
      intro a b h
      simp only [List.lookup] at h
      split at h
      · rename_i he
        have : a = x.1 := by simpa using he
        subst this
        simp at h
        subst h
        simp
      · exact List.mem_cons_of_mem _ (ih h)

/-- A concept fact of the corpus is an assertion of the ABox. -/
theorem mem_abox_of_hasC {n : Nat} {c : CN} (h : hasC n c = true) :
    Assertion.inst n (cn c) ∈ abox := by
  have hmem : c ∈ factsOf n := by simpa [hasC] using h
  have hlook : ∃ cs, conceptFacts.lookup n = some cs ∧ c ∈ cs := by
    unfold factsOf at hmem
    cases hl : conceptFacts.lookup n with
    | none => rw [hl] at hmem; simp at hmem
    | some cs => exact ⟨cs, rfl, by rw [hl] at hmem; simpa using hmem⟩
  obtain ⟨cs, hl, hc⟩ := hlook
  have hpair : (n, cs) ∈ conceptFacts := mem_of_lookup hl
  simp only [abox, List.mem_append, List.mem_flatMap]
  exact Or.inl ⟨(n, cs), hpair, List.mem_map_of_mem hc⟩

/-- The corpus asserts every concept fact it records. -/
theorem entails_of_hasC {n : Nat} {c : CN} (h : hasC n c = true) :
    kb.entails (.inst n (cn c)) :=
  KB.entails_of_mem_abox (mem_abox_of_hasC h)

end SFM.Tickets
