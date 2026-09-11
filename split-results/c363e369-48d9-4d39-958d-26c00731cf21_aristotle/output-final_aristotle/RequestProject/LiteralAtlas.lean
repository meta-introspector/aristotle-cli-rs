import Mathlib
import RequestProject.HarmonicPatterns

/-!
# Literal Atlas — extracting, ranking and sorting the integer constants

This file answers the request to **extract, rank and sort every integer
literal constant** that occurs inside the *kernel expressions* of the
verified A001379 / Monster results, and to expose the **duplicate
expressions** (different structural facts that resolve to the very same
integer).

The work is done in two layers.

* A small piece of **metaprogramming** walks the kernel `Expr` of chosen
  declarations and harvests every `Nat` literal.  In Lean's kernel a numeral
  `n : Nat` is stored either as a raw `Expr.lit (.natVal n)` or, more usually,
  as `@OfNat.ofNat _ (Expr.lit (.natVal n)) _`.  `collectLits` recognises both
  and counts each *written* numeral exactly once (it skips the duplicate copy
  that hides inside the `instOfNatNat n` instance argument).

* The harvested numbers are frozen into ordinary computable `List Nat`
  definitions (`structuralLits`, `dataLits`) by a code-generating command, so
  that the **ranking, sorting and duplicate analysis is itself
  kernel-checkable**: the headline facts at the bottom of the file are proved
  by `decide` / `native_decide`.

Two corpora are analysed:

* `structuralLits` — the literals appearing in the **statements** (the kernel
  *types*) of every theorem in `HarmonicPatterns.lean` and
  `GeometricPatterns.lean`.  These are the *structural* constants: grid bounds,
  totals, plateau metrics, … exactly the numbers the surrounding notes talk
  about (`15`, `17`, `26`, `194`, `442`, `5237`, …).

* `dataLits` — the literals of the raw data table `Monster.matrix` itself,
  i.e. every one of the `194 × 15` p-adic valuation cells.
-/

open Lean Elab Command Meta

namespace LiteralAtlas

/-! ## Layer 1 — kernel literal extraction (metaprogramming) -/

/-- Collect every `Nat` literal occurring in a kernel expression.

A numeral written in source as `n` elaborates to `@OfNat.ofNat _ (lit n) inst`;
the same `n` also occurs inside `inst = instOfNatNat n`.  To count each written
numeral once we special-case the `OfNat.ofNat` head and only read its literal
argument, never descending into the instance.  Bare kernel `Nat` literals
(`Expr.lit (.natVal n)`) are also collected. -/
partial def collectLits (e : Expr) (acc : Array Nat) : Array Nat :=
  match e.getAppFnArgs with
  | (``OfNat.ofNat, args) =>
      if h : args.size = 3 then
        match args[1]'(by omega) with
        | .lit (.natVal n) => acc.push n
        | other => collectLits other acc
      else descend e acc
  | _ =>
    match e with
    | .lit (.natVal n) => acc.push n
    | _ => descend e acc
where
  /-- Recurse into the immediate sub-expressions. -/
  descend (e : Expr) (acc : Array Nat) : Array Nat :=
    match e with
    | .app f a => collectLits a (collectLits f acc)
    | .lam _ t b _ => collectLits b (collectLits t acc)
    | .forallE _ t b _ => collectLits b (collectLits t acc)
    | .letE _ t v b _ => collectLits b (collectLits v (collectLits t acc))
    | .mdata _ b => collectLits b acc
    | .proj _ _ b => collectLits b acc
    | _ => acc

/-- Is this constant a theorem/lemma (as opposed to a `def`)? -/
def isThm (ci : ConstantInfo) : Bool := match ci with | .thmInfo _ => true | _ => false

/-- Literals of a single constant.  For theorems we only read the *statement*
(the kernel type), never the auto-generated proof term; for `def`s we read the
value as well (that is where data tables such as `Monster.matrix` live). -/
def litsOfConst (env : Environment) (n : Name) : Array Nat := Id.run do
  let some ci := env.find? n | return #[]
  let mut acc := collectLits ci.type #[]
  if !isThm ci then
    if let some v := ci.value? then
      acc := collectLits v acc
  return acc

/-- All theorem-statement literals contributed by the given modules. -/
def thmLitsOfModules (env : Environment) (mods : Array Name) : Array Nat := Id.run do
  let mut all : Array Nat := #[]
  for m in mods do
    if let some idx := env.header.moduleNames.findIdx? (· == m) then
      let md := env.header.moduleData[idx]!
      for n in md.constNames do
        if let some ci := env.find? n then
          if isThm ci then
            all := all ++ collectLits ci.type #[]
  return all

/-- `gen_lits_thms name from M₁ M₂ …` generates
`def name : List Nat := [...]`, the sorted multiset of every literal occurring
in the *statement* of every theorem of the named modules. -/
syntax (name := genLitsThms) "gen_lits_thms " ident " from " ident+ : command

@[command_elab genLitsThms]
def elabGenLitsThms : CommandElab := fun stx => do
  match stx with
  | `(gen_lits_thms $nm from $[$mods]*) => do
      let env ← getEnv
      let modNames := mods.map (·.getId)
      let all := thmLitsOfModules env modNames
      let sorted := all.qsort (· < ·)
      let elems := sorted.map Syntax.mkNatLit
      elabCommand (← `(def $nm : List Nat := [$elems,*]))
  | _ => throwUnsupportedSyntax

/-- `gen_lits name from d₁ d₂ …` generates `def name : List Nat := [...]`, the
sorted multiset of every literal of the named declarations (theorem statements
*and* def bodies). -/
syntax (name := genLits) "gen_lits " ident " from " ident+ : command

@[command_elab genLits]
def elabGenLits : CommandElab := fun stx => do
  match stx with
  | `(gen_lits $nm from $[$ids]*) => do
      let env ← getEnv
      let mut all : Array Nat := #[]
      for id in ids do
        let n ← liftCoreM <| realizeGlobalConstNoOverloadCore id.getId
        all := all ++ litsOfConst env n
      let sorted := all.qsort (· < ·)
      let elems := sorted.map Syntax.mkNatLit
      elabCommand (← `(def $nm : List Nat := [$elems,*]))
  | _ => throwUnsupportedSyntax

/-! ## Layer 2 — the two frozen corpora -/

-- `structuralLits`: every integer literal appearing in the *statement* of
-- every theorem of the two pattern files.
gen_lits_thms structuralLits from RequestProject.HarmonicPatterns RequestProject.GeometricPatterns

-- `dataLits`: every integer literal of the raw `194 × 15` data table.
gen_lits dataLits from Monster.matrix

/-! ## Layer 3 — ranking, sorting and duplicate analysis (pure, decidable) -/

/-- Number of occurrences of `x` in `l`. -/
def litCount (l : List Nat) (x : Nat) : Nat := (l.filter (· == x)).length

/-- The distinct values of `l`, sorted ascending. -/
def distinctVals (l : List Nat) : List Nat := l.dedup.mergeSort (fun a b => decide (a ≤ b))

/-- The full tally `(value, count)`, sorted ascending by value. -/
def tally (l : List Nat) : List (Nat × Nat) :=
  (distinctVals l).map (fun x => (x, litCount l x))

/-- The tally ranked by descending frequency (ties broken by ascending value):
the "ranking" the request asks for. -/
def rankByFreq (l : List Nat) : List (Nat × Nat) :=
  (tally l).mergeSort (fun a b => decide (b.2 < a.2) || (decide (a.2 = b.2) && decide (a.1 ≤ b.1)))

/-- The duplicate expressions: values that occur at least twice, ranked by
frequency. -/
def dups (l : List Nat) : List (Nat × Nat) :=
  (rankByFreq l).filter (fun p => decide (2 ≤ p.2))

/-- A `(value, count)` list is sorted by non-increasing count. -/
def freqSorted (l : List (Nat × Nat)) : Bool :=
  (l.zip l.tail).all (fun p => decide (p.2.2 ≤ p.1.2))

/-- Total number of literal occurrences in `l`. -/
def total (l : List Nat) : Nat := l.length

/-! ## Human-readable report (printed at build time) -/

#eval show CommandElabM Unit from do
  logInfo m!"structuralLits: {total structuralLits} occurrences, {(distinctVals structuralLits).length} distinct"
  logInfo m!"  tally (value, count): {tally structuralLits}"
  logInfo m!"  ranked by frequency: {rankByFreq structuralLits}"
  logInfo m!"  duplicates (count ≥ 2): {dups structuralLits}"
  logInfo m!"dataLits: {total dataLits} occurrences, {(distinctVals dataLits).length} distinct"
  logInfo m!"  tally (value, count): {tally dataLits}"
  logInfo m!"  ranked by frequency: {rankByFreq dataLits}"

/-! ## Layer 4 — kernel-verified ranking / duplicate facts

Everything below is proved by `native_decide`, so the extraction, sorting and
duplicate analysis is machine-checked, not merely printed. -/

/-- The statement corpus has `406` literal occurrences spread over `47`
distinct values. -/
theorem structuralLits_size :
    structuralLits.length = 406 ∧ (distinctVals structuralLits).length = 47 := by
  native_decide

/-- The most frequent structural literal is `0`, occurring `56` times. -/
theorem structuralLits_top :
    (rankByFreq structuralLits).head? = some (0, 56) := by native_decide

/-- The ranking really is sorted by non-increasing frequency. -/
theorem structuralLits_ranked :
    freqSorted (rankByFreq structuralLits) = true := by native_decide

/-- **Every** distinct structural constant occurs at least twice: there is no
literal that is used in only a single theorem statement.  Equivalently, the
list of duplicates *is* the whole ranking. -/
theorem structuralLits_all_duplicated :
    (∀ p ∈ tally structuralLits, 2 ≤ p.2) ∧
    dups structuralLits = rankByFreq structuralLits ∧
    (dups structuralLits).length = 47 := by native_decide

/-- The headline structural constants and their multiplicities.  Note in
particular the two genuine coincidences the analysis was looking for: the grid
width and the number of distinct plateau signatures are both `15`, and the
plateau length and the binary-switch prime are both `17`. -/
theorem structuralLits_key_counts :
    litCount structuralLits 15 = 13 ∧
    litCount structuralLits 17 = 8 ∧
    litCount structuralLits 26 = 10 ∧
    litCount structuralLits 194 = 25 ∧
    litCount structuralLits 320 = 4 ∧
    litCount structuralLits 122 = 4 ∧
    litCount structuralLits 5237 = 3 := by native_decide

/-- The total plateau mass `442` is **never written as a literal** anywhere in
the statements: it only ever appears factored, as `320 + 122` and as `17 * 26`.
Its two summands `320` and `122` each occur `4` times. -/
theorem plateau_mass_442_never_literal :
    litCount structuralLits 442 = 0 ∧
    litCount structuralLits 320 = 4 ∧ litCount structuralLits 122 = 4 := by
  native_decide

/-- The largest literal used in any statement is the grand total mass `5237`. -/
theorem structuralLits_max :
    (distinctVals structuralLits).getLast? = some 5237 := by native_decide

/-- The data table contributes `2910 = 194 · 15` literal occurrences over `27`
distinct cell values. -/
theorem dataLits_size :
    dataLits.length = 2910 ∧ (distinctVals dataLits).length = 27 := by native_decide

/-- The two most frequent cell values are `1` (1455 times) and `0` (845 times):
the matrix is overwhelmingly binary. -/
theorem dataLits_top2 :
    (rankByFreq dataLits).take 2 = [(1, 1455), (0, 845)] := by native_decide

/-- Of the `2910` cells, `2300` are `0` or `1`. -/
theorem dataLits_binary_mass :
    litCount dataLits 0 + litCount dataLits 1 = 2300 := by native_decide

/-- The literals of the data table sum to `5237` — the same grand total mass
certified by `Monster.total_mass`.  So the extracted multiset of cell literals
really is the whole valuation grid. -/
theorem dataLits_sum : dataLits.sum = 5237 := by native_decide

/-- The largest cell value is `46` (the maximal 2-adic valuation). -/
theorem dataLits_max :
    (distinctVals dataLits).getLast? = some 46 := by native_decide

end LiteralAtlas
