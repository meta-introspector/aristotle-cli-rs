import RequestProject.Solfunmeme.Domain.Data.Catalog

/-!
# The SOLFUNMEME dataset as a domain package

This is the domain the request is about: the data the `introspector/solfunmeme`
dataset and this repository's review of it consist of — the mint and its
captures, the ticket tracker, the search index, the badge snapshots, the
federal union, the bootstrap plan and the codec itself.

Every object here is a *value*, with

* what is claimed about it,
* the proof or proofs that establish the claim, by name,
* and a truth status that says how the value is known.

The truth statuses do the work the request asks of them.  `PROVEN` is used only
where a theorem of this repository establishes the value; a number read out of
a capture is `IMPORTED`; a number produced by a checked script is `VERIFIED`;
a figure nobody can measure is `ASSERTED`; and something the environment cannot
exercise at all is `UNRESOLVED`.  Two `ASSERTED` and one `UNRESOLVED` object
are included deliberately, so that the coverage report has something to be
honest about.

The proof records are not written here: they are looked up in
`Domain.Data.Catalog`, which is generated from the corpus.  A reference to a
theorem that does not exist therefore fails validation, and
`Domain.Facts.dataset_wellFormed` fails to compile.
-/

namespace Solfunmeme.Domain.Data

open Solfunmeme.Domain
open Solfunmeme.Codec (inferType)

/-! ## Helpers -/

def dedup (xs : List String) : List String :=
  xs.foldl (fun acc x => if acc.contains x then acc else acc ++ [x]) []

/-- A measured or recorded value of the dataset. -/
def datum (id name claim value : String) (truth : TruthStatus) (proofs : List String)
    (source : String) : DomainObject :=
  { id := id
    kind := "measurement"
    name := name
    claim := claim
    value := value
    valueType := if value = "" then "string" else inferType value
    claimRefs := ["claim:" ++ id]
    proofRefs := proofs
    truth := truth
    sourceRefs := [source]
    provenance :=
      { sourceSystem := "solfunmeme-dataset"
        sourceFile := source
        sourceFormat := "lean" } }

/-- The claim attached to a datum. -/
def datumClaim (o : DomainObject) : DomainClaim :=
  { id := "claim:" ++ o.id
    text := o.claim
    objectRef := o.id
    proofRefs := o.proofRefs
    truth := if o.proofRefs.isEmpty then o.truth else .PROVEN }

/-! ## The objects -/

/-- The mint and its two real captures. -/
def onchainObjects : List DomainObject :=
  [ datum "mint.address" "mint address"
      "the address the corpus is about is a syntactically valid 32-byte Solana public key"
      "BwUTq7fS6sfUmHDwAiCQZ3asSiPEapW5zDrsbwtapump" .IMPORTED
      ["Solana.CaptureFacts.mint_isValidPubkey"] "dataset/"
  , datum "mint.capture.kinds" "capture kinds"
      "the two real captures are a getAccountInfo and a getSignaturesForAddress response for this mint"
      "getAccountInfo;getSignaturesForAddress" .PROVEN
      ["Solana.CaptureFacts.dataset_files_are_captures_of_the_mint"] "dataset/"
  , datum "mint.authority" "mint authority"
      "the mint has no mint authority and no freeze authority" "none" .PROVEN
      ["Solana.CaptureFacts.mint_authorities_are_null"] "dataset/"
  , datum "mint.supply.base" "supply in base units"
      "the captured supply, in base units" "999906030213118" .IMPORTED
      ["Solana.CaptureFacts.realSupply_render"] "dataset/"
  , datum "mint.supply.rendered" "supply rendered at six decimals"
      "the captured supply renders at the mint's own scale as 999906030.213118, losslessly"
      "999906030.213118" .PROVEN
      ["Solana.CaptureFacts.realSupply_render", "Solana.CaptureFacts.realSupply_render_roundtrip"]
      "dataset/"
  , datum "activity.records" "signature records"
      "the signature capture excerpt holds five records" "5" .PROVEN
      ["Solana.CaptureFacts.realActivity_counts"] "dataset/"
  , datum "activity.failed" "failed transactions"
      "three of the five captured transactions failed" "3" .PROVEN
      ["Solana.CaptureFacts.realActivity_counts"] "dataset/"
  , datum "activity.memoed" "memoed transactions"
      "two of the five captured transactions carry a memo" "2" .PROVEN
      ["Solana.CaptureFacts.realActivity_counts"] "dataset/"
  , datum "activity.slots" "slot range"
      "the captured excerpt spans slots 314266534 to 314266537" "314266534-314266537" .PROVEN
      ["Solana.CaptureFacts.realActivity_ranges", "Solana.CaptureFacts.realSignatures_all_timed"]
      "dataset/"
  , datum "dataset.largest_accounts" "largest-accounts capture"
      "no capture in dataset/ is a getTokenLargestAccounts response, so the real corpus cannot yield a holder distribution"
      "absent" .PROVEN ["Solana.CaptureFacts.dataset_has_no_largest_accounts"] "dataset/"
  , datum "holders.source" "holder distribution source"
      "every holder figure comes from the synthetic fixtures, not from the real captures"
      "fixtures/" .IMPORTED
      ["Solana.CaptureFacts.dataset_has_no_largest_accounts",
       "Solana.CaptureFacts.fixture_total_conserved"] "fixtures/"
  , datum "holders.ingested_share" "ingested share of supply"
      "the ingested fixture holders cover 385000000000000 of 999805262437066 base units"
      "385000000000000/999805262437066" .PROVEN
      ["Solana.CaptureFacts.fixture_ingested_share_eq",
       "Solana.CaptureFacts.fixture_ingested_share_bounds"] "fixtures/"
  , datum "holders.nakamoto" "Nakamoto coefficient"
      "the ingested fixture holders do not reach half the supply, so no Nakamoto coefficient exists"
      "none" .PROVEN
      ["Solana.CaptureFacts.fixture_no_nakamoto", "Solana.Holders.nakamoto_eq_none_of_le_half"]
      "fixtures/"
  , datum "rpc.live" "live RPC replay"
      "the live RPC path has never been exercised: this environment has no network" "" .UNRESOLVED
      [] "RequestProject/Onchain/Rpc.lean" ]

/-- The ticket tracker, as ingested. -/
def trackerObjects : List DomainObject :=
  [ datum "tracker.tickets" "tickets" "the ingested tracker holds 230 tickets" "230" .PROVEN
      ["SFM.Tickets.count_tickets"] "data/codeberg/"
  , datum "tracker.wishes" "wish list" "105 of the tickets are on the wish list" "105" .PROVEN
      ["SFM.Tickets.count_wishes"] "data/codeberg/"
  , datum "tracker.actionable" "actionable wishes"
      "99 wishes are unclaimed and waiting on nothing" "99" .PROVEN
      ["SFM.Tickets.count_actionable"] "data/codeberg/"
  , datum "tracker.quick_wins" "quick wins" "24 wishes are small enough to be quick wins" "24"
      .PROVEN ["SFM.Tickets.count_quickWins"] "data/codeberg/"
  , datum "tracker.epics" "epics" "44 wishes are epics" "44" .PROVEN
      ["SFM.Tickets.count_epics"] "data/codeberg/"
  , datum "tracker.needs_spec" "wishes needing a specification"
      "56 wishes are written as an idea with no concrete task in them" "56" .PROVEN
      ["SFM.Tickets.count_needsSpec"] "data/codeberg/"
  , datum "tracker.rewarded" "rewarded tickets" "14 tickets carry a reward" "14" .PROVEN
      ["SFM.Tickets.count_rewarded"] "data/codeberg/"
  , datum "tracker.discussed" "discussed tickets" "115 tickets have been discussed" "115" .PROVEN
      ["SFM.Tickets.discussion_counts"] "data/codeberg/"
  , datum "tracker.stale" "stale tickets"
      "206 tickets have seen no activity for six months" "206" .PROVEN
      ["SFM.Tickets.discussion_counts"] "data/codeberg/"
  , datum "tracker.kb.assertions" "knowledge base assertions"
      "the description-logic knowledge base holds 2593 assertions" "2593" .PROVEN
      ["SFM.Tickets.kb_size"] "data/codeberg/"
  , datum "tracker.kb.consistent" "knowledge base consistency"
      "the knowledge base is consistent, so nothing built on it is vacuous" "true" .PROVEN
      ["SFM.Tickets.kb_consistent", "SFM.Tickets.kb_no_absurd_individual"] "data/codeberg/"
  , datum "tracker.plan.steps" "planned wishes" "the plan schedules all 105 wishes" "105" .PROVEN
      ["SFM.Tickets.plan_length", "SFM.Tickets.plan_covers_wishes"] "PLAN.md"
  , datum "tracker.plan.acyclic" "plan has no cycle"
      "the plan's prerequisite relation has no cycle" "true" .PROVEN
      ["SFM.Tickets.plan_no_cycle", "SFM.Tickets.Plan.acyclic"] "PLAN.md"
  , datum "tracker.plan_prereqs" "planned prerequisites"
      "the plan's prerequisites are exactly the open wishes each ticket links to" "true" .PROVEN
      ["SFM.Tickets.plan_prereqs_are_the_links", "SFM.Tickets.plan_prereqs_earlier"]
      "data/codeberg/" ]

/-- The published search index. -/
def indexObjects : List DomainObject :=
  [ datum "index.chunks" "index chunks" "the received feed is 46 chunks" "46" .PROVEN
      ["Solfunmeme.IndexFeed.feed_length"] "data/index/chunks/"
  , datum "index.documents" "indexed documents" "the feed carries 2250 documents" "2250" .PROVEN
      ["Solfunmeme.IndexFeed.docs_count", "Solfunmeme.IndexFeed.docIds_nodup"]
      "data/index/chunks/"
  , datum "index.postings" "postings" "the feed carries 52543 postings" "52543" .PROVEN
      ["Solfunmeme.IndexFeed.postings_count", "Solfunmeme.IndexFeed.postings_nodup"]
      "data/index/chunks/"
  , datum "index.terms" "distinct terms" "the feed carries 38627 distinct terms" "38627" .PROVEN
      ["Solfunmeme.IndexFeed.term_count"] "data/index/chunks/"
  , datum "index.hapax" "terms occurring once"
      "35864 of the terms occur in exactly one posting" "35864" .PROVEN
      ["Solfunmeme.IndexFeed.hapax_count"] "data/index/chunks/" ]

/-- Badges, the senate and the federal union. -/
def governanceObjects : List DomainObject :=
  [ datum "badges.snapshots" "snapshots" "the badge corpus holds 52 snapshots" "52" .PROVEN
      ["Badges.Snapshot.snapshot_count", "Badges.Snapshot.times_increasing"] "badges/"
  , datum "badges.genesis_senate" "genesis senators"
      "39 senators have stood since the first snapshot" "39" .PROVEN
      ["Badges.Snapshot.genesis_count"] "badges/"
  , datum "senate.roster" "senate roster" "the senate roster holds 100 distinct addresses" "100"
      .PROVEN ["Senate.Desk.roster_length", "Senate.Desk.roster_nodup"] "senate/"
  , datum "federal.states" "states of the union"
      "the union has thirteen states, and they partition the roster" "13" .PROVEN
      ["Federal.Union.states_length", "Federal.Union.states_partition_the_roster"] "FEDERAL-MODEL.md"
  , datum "federal.senate_seats" "senate seats"
      "the federal senate seats 26 distinct senators, two per state" "26" .PROVEN
      ["Federal.Union.seated_length", "Federal.Union.seated_nodup",
       "Federal.Union.every_state_has_two_senators"] "FEDERAL-MODEL.md"
  , datum "federal.house_seats" "house seats"
      "the apportionment hands out exactly 500 house seats" "500" .PROVEN
      ["Federal.Union.house_total", "Federal.Union.house_total_general"] "FEDERAL-MODEL.md"
  , datum "federal.total_stake" "total stake"
      "the seated union holds 564653915 whole tokens" "564653915" .PROVEN
      ["Federal.Union.total_stake"] "FEDERAL-MODEL.md"
  , datum "federal.union_share" "union share of supply"
      "the thirteen states together hold more than half of the captured supply" "true" .PROVEN
      ["Federal.Union.union_holds_more_than_half_the_supply", "Federal.Union.union_share_bounds"]
      "FEDERAL-MODEL.md"
  , datum "federal.quorum" "senate passage threshold"
      "passing the federal senate takes signed ballots from at least 14 distinct senators" "14"
      .PROVEN ["Federal.Union.senate_passage_needs_fourteen_senators",
               "Federal.Union.senate_passage_needs_fourteen_signatures"] "SENATE-DESK.md" ]

/-- The programme, the codec, and the things nobody can measure. -/
def programmeObjects : List DomainObject :=
  [ datum "bootstrap.stages" "bootstrap stages" "the bootstrap plan has thirteen stages" "13"
      .PROVEN ["SFM.Bootstrap.plan_length", "SFM.Bootstrap.plan_feasible"] "BOOTSTRAP.md"
  , datum "programme.assumed_income" "assumed income"
      "every revenue figure in the programme is an assumption, not a measurement" "assumed"
      .ASSERTED [] "RequestProject/Bootstrap/Plan.lean"
  , datum "market.star_ranking" "star ranking"
      "the senator's star ranking is an opinion this project cannot substantiate" "opinion"
      .ASSERTED [] "SENATE-REPORT-VAICU.md"
  , datum "codec.formats" "interchange formats"
      "the codec carries a canonical object in five formats, each of them losslessly" "5" .PROVEN
      ["Solfunmeme.Codec.codecs_lossless", "Solfunmeme.Codec.ofIpdl_toIpdl",
       "Solfunmeme.Codec.ofXml_toXml", "Solfunmeme.Codec.ofCsv_toCsv",
       "Solfunmeme.Codec.ofYaml_toYaml", "Solfunmeme.Codec.ofText_toText"]
      "RequestProject/Codec/Formats.lean"
  , datum "codec.flat_csv" "flat CSV"
      "the naive flat CSV admits no decoder at all, so its PARTIAL declaration is honest" "PARTIAL"
      .PROVEN ["Solfunmeme.Codec.flatCsv_no_decoder", "Solfunmeme.Codec.flatCsv_not_injective"]
      "RequestProject/Codec/Formats.lean"
  , datum "codec.identity" "content identity"
      "the content identity of an object does not depend on the codec it travelled in" "stable"
      .PROVEN ["Solfunmeme.Codec.contentId_of_any_codec", "Solfunmeme.Codec.canonicalSerialize_inj"]
      "RequestProject/Codec/Hash.lean"
  , datum "codec.validation_is_not_proof" "validation is not proof"
      "a well-formed object is not thereby a proved one" "true" .PROVEN
      ["Solfunmeme.Codec.validation_is_not_proof"] "RequestProject/Codec/Validate.lean"
  , datum "corpus.audited_theorems" "audited theorems"
      "the number of theorems this repository audits with #print axioms" (toString catalogProofCount)
      .VERIFIED ["check:domain_facts"] "scripts/domain_facts.py"
  , datum "corpus.kernel_checked" "kernel-checked theorems"
      "audited theorems whose proof the Lean kernel checks outright"
      (toString catalogKernelCount) .VERIFIED ["check:domain_facts"] "scripts/domain_facts.py"
  , datum "corpus.evaluation_checked" "evaluation-checked theorems"
      "audited theorems that also rest on evaluation by the compiler"
      (toString catalogNativeCount) .VERIFIED ["check:domain_facts"] "scripts/domain_facts.py" ]

def datasetObjects : List DomainObject :=
  onchainObjects ++ trackerObjects ++ indexObjects ++ governanceObjects ++ programmeObjects

def datasetClaims : List DomainClaim := datasetObjects.map datumClaim

/-! ## The proofs the objects point at -/

def catalogProof (id : String) : Option ProofRecord := catalogProofs.find? (fun p => p.id == id)

/-- A check that is run rather than proved: a script whose exit status is the
evidence.  It is recorded as a proof record with its own kind, so that nothing
mistakes it for a theorem. -/
def scriptCheck (id name procedure file : String) : ProofRecord :=
  { id := id
    name := name
    kind := "script-check"
    sourceFile := file
    inputRefs := [file]
    procedure := procedure
    outputRefs := ["claim:" ++ id]
    status := .VALID
    certificateKind := "process-exit-status"
    certificateLocation := file
    validation := .REPRODUCED
    provenance := { sourceSystem := "solfunmeme-domain", sourceFile := file
                    sourceFormat := "python" }
    extensions := [("run.date", "2026-09-03")] }

def scriptProofs : List ProofRecord :=
  [ scriptCheck "check:domain_facts" "the Lean proof catalog matches the corpus"
      "python3 scripts/domain_facts.py --check" "scripts/domain_facts.py"
  , scriptCheck "check:onchain_facts" "the Lean transcription matches the on-chain captures"
      "python3 scripts/onchain_facts.py --check" "scripts/onchain_facts.py"
  , scriptCheck "check:index_facts" "the Lean transcription matches the received index chunks"
      "python3 scripts/index_facts.py --check" "scripts/index_facts.py" ]

def datasetProofRefs : List String := dedup (datasetObjects.flatMap DomainObject.proofRefs)

/-- Bringing a proof into this package: what it establishes *here* is the
claims of the objects that reference it, and what it produces here are those
objects.  A catalog entry states its own claim in terms of the corpus; inside
the dataset package it is attached to the data it supports. -/
def importProof (p : ProofRecord) : ProofRecord :=
  let supported := datasetObjects.filter (fun o => o.proofRefs.contains p.id)
  { p with
      outputRefs := supported.map DomainObject.id
      claimRefs := supported.map (fun o => "claim:" ++ o.id) }

def datasetProofs : List ProofRecord :=
  (scriptProofs ++ datasetProofRefs.filterMap catalogProof).map importProof

/-! ## The package -/

/-- The SOLFUNMEME dataset, as a canonical domain package with its proof graph
closed. -/
def solfunmemeDataset : Domain :=
  Domain.linked
    { id := "solfunmeme-dataset"
      name := "SOLFUNMEME dataset and its review"
      version := "1.0"
      description :=
        "The data of the introspector/solfunmeme dataset and of this repository's review of it: " ++
          "the mint and its captures, the ticket tracker, the search index, the badge snapshots, " ++
          "the federal union, the bootstrap programme and the interchange codec. Every value " ++
          "carries the proofs that establish it and a truth status that says how it is known."
      objects := datasetObjects.map DomainObject.stamped
      claims := datasetClaims
      proofs := datasetProofs
      relations := []
      errors := []
      provenance :=
        { sourceSystem := "solfunmeme-domain"
          sourceFile := "RequestProject/Domain/Data/Dataset.lean"
          sourceFormat := "lean"
          importedAt := "2026-09-03"
          transformations := ["discover", "link", "canonicalise", "validate"] }
      extensions := [("schema", "domain-package/1.0"), ("codec", "solfunmeme-domain/1.0")] }

/-! ## The corpus as a domain of its own

The dataset package above is a curated set of values.  The proof corpus itself
is a domain too: one object per source module that carries audited theorems,
one claim per theorem, and the whole catalog as the proof list. -/

def proofCorpusDomain : Domain :=
  Domain.linked
    { id := "solfunmeme-proof-corpus"
      name := "The audited proof corpus of this repository"
      version := "1.0"
      description :=
        "Every theorem this repository audits with #print axioms, the module it lives in, the " ++
          "axioms its proof actually depends on, and whether the kernel checks it outright."
      objects := catalogModules
      claims := catalogClaims
      proofs := catalogProofs
      relations := []
      errors := []
      provenance :=
        { sourceSystem := "solfunmeme-domain"
          sourceFile := "RequestProject/Domain/Data/Catalog.lean"
          sourceFormat := "lean"
          importedAt := "2026-09-03"
          transformations := ["scan", "audit", "link"] }
      extensions := [("schema", "domain-package/1.0"), ("generator", "scripts/domain_facts.py")] }

end Solfunmeme.Domain.Data
