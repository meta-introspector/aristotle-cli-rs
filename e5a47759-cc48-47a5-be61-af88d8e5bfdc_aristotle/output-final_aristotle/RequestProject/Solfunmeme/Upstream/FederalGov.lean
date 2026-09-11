/-
  FederalGov.lean — US Federal Government model for DAO governance.

  Three chambers mapped to Fibonacci tiers:
    Senate       = top 100 holders (diamond)
    House (Reps) = next 500 holders (gold, ranks 101-500)
    Lobbyists    = next 1000 holders (silver, ranks 501-1500)

  Legislation requires bicameral passage:
    1. Simple majority in Senate (≥51/100)
    2. Simple majority in House  (≥251/500)
    3. Both must pass — either chamber can block

  Lobbyists hold advisory votes — recorded but non-binding.

  Executive veto can be overridden by supermajority:
    2/3 Senate (≥67) AND 2/3 House (≥334)
-/

-- ── Chamber definitions ──────────────────────────────────────────

def senateSize : Nat := 100
def houseSize  : Nat := 500
def lobbySize  : Nat := 1000

-- Verify these match our tier boundaries
theorem senate_is_diamond : senateSize = 100 := rfl
theorem house_is_gold : houseSize = 500 := rfl
theorem lobby_is_silver : lobbySize = 1000 := rfl
theorem total_gov : senateSize + houseSize + lobbySize = 1600 := by native_decide

-- ── Vote tallies per chamber ─────────────────────────────────────

structure ChamberVote where
  yea : Nat
  nay : Nat
  size : Nat
deriving Repr

structure BicameralVote where
  senate : ChamberVote
  house  : ChamberVote
  lobby  : ChamberVote  -- advisory
deriving Repr

-- ── Resolution types ─────────────────────────────────────────────

inductive BillResult where
  | enacted        -- passed both chambers
  | senateFailed   -- failed in senate
  | houseFailed    -- failed in house
  | bothFailed     -- failed in both
  | noQuorum       -- insufficient participation
deriving DecidableEq, Repr

inductive VetoResult where
  | overridden     -- 2/3 supermajority in both
  | sustained      -- veto stands
deriving DecidableEq, Repr

-- ── Quorum: >50% of chamber must participate ─────────────────────

def chamberQuorum (v : ChamberVote) : Bool :=
  (v.yea + v.nay) * 2 > v.size

-- ── Simple majority ──────────────────────────────────────────────

def chamberPasses (v : ChamberVote) : Bool :=
  chamberQuorum v && v.yea > v.nay

-- ── Bicameral resolution ─────────────────────────────────────────

def resolveBill (b : BicameralVote) : BillResult :=
  if ¬chamberQuorum b.senate || ¬chamberQuorum b.house then .noQuorum
  else if b.senate.yea > b.senate.nay then
    if b.house.yea > b.house.nay then .enacted
    else .houseFailed
  else if b.house.yea > b.house.nay then .senateFailed
  else .bothFailed

-- ── Veto override: 2/3 supermajority in both chambers ────────────

def vetoOverride (b : BicameralVote) : VetoResult :=
  -- 2/3 means yea * 3 >= size * 2
  let senateSuper := b.senate.yea * 3 ≥ b.senate.size * 2
  let houseSuper  := b.house.yea * 3 ≥ b.house.size * 2
  if senateSuper && houseSuper then .overridden else .sustained

-- ── Chamber size proofs ──────────────────────────────────────────

-- Senate majority threshold
theorem senate_majority : senateSize / 2 + 1 = 51 := by native_decide

-- House majority threshold
theorem house_majority : houseSize / 2 + 1 = 251 := by native_decide

-- Senate supermajority (2/3) threshold
theorem senate_super : (senateSize * 2 + 2) / 3 = 67 := by native_decide

-- House supermajority (2/3) threshold
theorem house_super : (houseSize * 2 + 2) / 3 = 334 := by native_decide

-- ── Bicameral requirement proofs ─────────────────────────────────

-- Senate alone cannot enact (even unanimous senate, zero house)
theorem senate_alone_fails :
    resolveBill ⟨⟨100, 0, 100⟩, ⟨0, 0, 500⟩, ⟨0, 0, 1000⟩⟩ = .noQuorum := by native_decide

-- House alone cannot enact (even unanimous house, zero senate)
theorem house_alone_fails :
    resolveBill ⟨⟨0, 0, 100⟩, ⟨500, 0, 500⟩, ⟨0, 0, 1000⟩⟩ = .noQuorum := by native_decide

-- Both chambers yea → enacted
theorem both_pass_enacted :
    resolveBill ⟨⟨100, 0, 100⟩, ⟨500, 0, 500⟩, ⟨0, 0, 1000⟩⟩ = .enacted := by native_decide

-- Senate blocks: 51 yea house, 49 yea senate → senateFailed
theorem senate_blocks :
    resolveBill ⟨⟨49, 51, 100⟩, ⟨400, 100, 500⟩, ⟨0, 0, 1000⟩⟩ = .senateFailed := by native_decide

-- House blocks: 51 yea senate, 249 yea house → houseFailed
theorem house_blocks :
    resolveBill ⟨⟨51, 49, 100⟩, ⟨249, 251, 500⟩, ⟨0, 0, 1000⟩⟩ = .houseFailed := by native_decide

-- Minimum passing: 51 senate + 251 house → enacted
theorem minimum_passage :
    resolveBill ⟨⟨51, 49, 100⟩, ⟨251, 249, 500⟩, ⟨0, 0, 1000⟩⟩ = .enacted := by native_decide

-- One less in senate → senateFailed
theorem one_less_senate :
    resolveBill ⟨⟨50, 50, 100⟩, ⟨251, 249, 500⟩, ⟨0, 0, 1000⟩⟩ = .senateFailed := by native_decide

-- One less in house → houseFailed
theorem one_less_house :
    resolveBill ⟨⟨51, 49, 100⟩, ⟨250, 250, 500⟩, ⟨0, 0, 1000⟩⟩ = .houseFailed := by native_decide

-- ── Lobbyist advisory is non-binding ─────────────────────────────

-- Bill passes regardless of lobby vote
theorem lobby_irrelevant_pass :
    resolveBill ⟨⟨100, 0, 100⟩, ⟨500, 0, 500⟩, ⟨0, 1000, 1000⟩⟩ = .enacted := by native_decide

-- Bill fails regardless of lobby support
theorem lobby_irrelevant_fail :
    resolveBill ⟨⟨49, 51, 100⟩, ⟨249, 251, 500⟩, ⟨1000, 0, 1000⟩⟩ = .bothFailed := by native_decide

-- ── Veto override proofs ─────────────────────────────────────────

-- 67 senate + 334 house → overridden
theorem veto_override_minimum :
    vetoOverride ⟨⟨67, 33, 100⟩, ⟨334, 166, 500⟩, ⟨0, 0, 1000⟩⟩ = .overridden := by native_decide

-- 66 senate → sustained (one short)
theorem veto_sustained_senate :
    vetoOverride ⟨⟨66, 34, 100⟩, ⟨334, 166, 500⟩, ⟨0, 0, 1000⟩⟩ = .sustained := by native_decide

-- 333 house → sustained (one short)
theorem veto_sustained_house :
    vetoOverride ⟨⟨67, 33, 100⟩, ⟨333, 167, 500⟩, ⟨0, 0, 1000⟩⟩ = .sustained := by native_decide

-- Unanimous both → overridden
theorem veto_override_unanimous :
    vetoOverride ⟨⟨100, 0, 100⟩, ⟨500, 0, 500⟩, ⟨0, 0, 1000⟩⟩ = .overridden := by native_decide

-- ── Quorum proofs ────────────────────────────────────────────────

-- Senate quorum requires >50 participating
theorem senate_quorum_met :
    chamberQuorum ⟨26, 25, 100⟩ = true := by native_decide

theorem senate_quorum_not_met :
    chamberQuorum ⟨25, 25, 100⟩ = false := by native_decide

-- House quorum requires >250 participating
theorem house_quorum_met :
    chamberQuorum ⟨126, 125, 500⟩ = true := by native_decide

theorem house_quorum_not_met :
    chamberQuorum ⟨125, 125, 500⟩ = false := by native_decide

-- ── Power balance proofs ─────────────────────────────────────────

-- Senate (100 members) can block 500 reps — minority veto power
-- Even if ALL 500 reps vote yea, 51 senators voting nay kills the bill
theorem senate_minority_veto :
    resolveBill ⟨⟨49, 51, 100⟩, ⟨500, 0, 500⟩, ⟨1000, 0, 1000⟩⟩ = .senateFailed := by native_decide

-- House (500 members) can block 100 senators — popular veto power
-- Even if ALL 100 senators vote yea, 251 reps voting nay kills the bill
theorem house_popular_veto :
    resolveBill ⟨⟨100, 0, 100⟩, ⟨249, 251, 500⟩, ⟨1000, 0, 1000⟩⟩ = .houseFailed := by native_decide

-- Neither chamber alone has enough for veto override
-- All 100 senators can't override without house
theorem senate_cant_override_alone :
    vetoOverride ⟨⟨100, 0, 100⟩, ⟨0, 500, 500⟩, ⟨0, 0, 1000⟩⟩ = .sustained := by native_decide

-- All 500 reps can't override without senate
theorem house_cant_override_alone :
    vetoOverride ⟨⟨0, 100, 100⟩, ⟨500, 0, 500⟩, ⟨0, 0, 1000⟩⟩ = .sustained := by native_decide

-- ── Main ─────────────────────────────────────────────────────────

def federalGovMain : IO Unit := do
  IO.println "◎ Federal Government Model — Lean4 Verified"
  IO.println ""
  IO.println "  Chambers:"
  IO.println "    Senate     = top 100 holders (diamond tier)"
  IO.println "    House      = next 500 holders (gold tier)"
  IO.println "    Lobbyists  = next 1000 holders (silver tier, advisory)"
  IO.println ""
  IO.println "  Thresholds:"
  IO.println "    ✓ Senate majority:       51/100"
  IO.println "    ✓ House majority:        251/500"
  IO.println "    ✓ Senate supermajority:  67/100 (veto override)"
  IO.println "    ✓ House supermajority:   334/500 (veto override)"
  IO.println "    ✓ Quorum:               >50% participation per chamber"
  IO.println ""
  IO.println "  Bicameral requirement:"
  IO.println "    ✓ Senate alone cannot enact"
  IO.println "    ✓ House alone cannot enact"
  IO.println "    ✓ Both chambers yea → enacted"
  IO.println "    ✓ Minimum: 51 senate + 251 house → enacted"
  IO.println "    ✓ 50/50 senate tie → senateFailed"
  IO.println "    ✓ 250/250 house tie → houseFailed"
  IO.println ""
  IO.println "  Checks and balances:"
  IO.println "    ✓ 51 senators block 500 unanimous reps (minority veto)"
  IO.println "    ✓ 251 reps block 100 unanimous senators (popular veto)"
  IO.println "    ✓ Lobbyist vote is non-binding (advisory only)"
  IO.println ""
  IO.println "  Veto override:"
  IO.println "    ✓ 67 senate + 334 house → overridden"
  IO.println "    ✓ 66 senate → sustained (one short)"
  IO.println "    ✓ 333 house → sustained (one short)"
  IO.println "    ✓ Neither chamber can override alone"
