import RequestProject.Solfunmeme.Onchain.Dataset
import RequestProject.Solfunmeme.Onchain.Decimal
import RequestProject.Solfunmeme.Onchain.Holders

/-!
Rendering an ingested `Snapshot` as text or as JSON.

All arithmetic has already happened in `RequestProject.Onchain.Holders` over `Nat`
and `Rat`; this module only turns exact values into strings.
-/

namespace Solana.Report

open Solana.Holders
open Solana.Decimal

/-- A percentage, to two decimal places. -/
def pct (q : Rat) (prec : Nat := 2) : String :=
  renderRat (q * 100) prec ++ "%"

/-- Pad a string on the right to width `w`. -/
def padRight (w : Nat) (s : String) : String :=
  s ++ String.ofList (List.replicate (w - s.length) ' ')

/-- Pad a string on the left to width `w`. -/
def padLeftStr (w : Nat) (s : String) : String :=
  String.ofList (List.replicate (w - s.length) ' ') ++ s

/-- Running totals of a list, `cumulative [a,b,c] = [a, a+b, a+b+c]`. -/
def cumulative (ns : List Nat) : List Nat :=
  (ns.foldl (fun (acc, out) n => (acc + n, (acc + n) :: out)) (0, [])).2.reverse

/-- One table row per holder: rank, address, balance, share of supply, cumulative
share of supply. -/
def holderRows (s : Snapshot) : List String :=
  let amounts := s.holders.map Holder.amount
  let cums := cumulative amounts
  (s.holders.zip cums).zipIdx.map fun ((h, c), i) =>
    padLeftStr 4 (toString (i + 1)) ++ "  "
      ++ padRight 46 h.address ++ "  "
      ++ padLeftStr 24 (render h.amount s.decimals) ++ "  "
      ++ padLeftStr 8 (pct (share h.amount s.supply)) ++ "  "
      ++ padLeftStr 8 (pct (share c s.supply))

/-- The concentration summary: top-k shares of total supply, the
Herfindahl–Hirschman index of the ingested holders, and their Nakamoto
coefficient (`—` when the ingested set does not reach half the supply). -/
def metricsLines (s : Snapshot) : List String :=
  let ks := [1, 5, 10, 20]
  let tops := ks.map fun k =>
    "top-" ++ padRight 3 (toString k) ++ " share of supply : "
      ++ padLeftStr 8 (pct (topKShare k s.holders s.supply))
  tops ++
  [ "ingested share of supply : "
      ++ padLeftStr 8 (pct (share (totalAmount s.holders) s.supply))
  , "Herfindahl–Hirschman     : "
      ++ padLeftStr 8 (renderRat (herfindahl s.holders s.supply) 4)
  , "Nakamoto coefficient     : "
      ++ padLeftStr 8 (match nakamoto s.holders s.supply with
                       | some k => toString k
                       | none => "—") ]

/-- The full human-readable report. -/
def render (s : Snapshot) : String :=
  String.intercalate "\n" <|
    [ "mint      : " ++ s.mint
    , "decimals  : " ++ toString s.decimals
    , "supply    : " ++ Solana.Decimal.render s.supply s.decimals
    , "holders   : " ++ toString s.holders.length ++ " (largest token accounts, merged by wallet)"
    , ""
    , padLeftStr 4 "#" ++ "  " ++ padRight 46 "address" ++ "  "
        ++ padLeftStr 24 "balance" ++ "  " ++ padLeftStr 8 "share" ++ "  "
        ++ padLeftStr 8 "cum." ]
    ++ holderRows s
    ++ [""] ++ metricsLines s

/-- The recent-activity section built from a page of `getSignaturesForAddress`. -/
def renderActivity (a : Solana.Dataset.ActivitySummary) : String :=
  let range (r : Option (Nat × Nat)) : String :=
    match r with
    | some (lo, hi) => toString lo ++ " … " ++ toString hi
    | none => "—"
  String.intercalate "\n"
    [ "recent signatures        : " ++ toString a.total
    , "  failed                 : " ++ toString a.failed
    , "  with memo              : " ++ toString a.memoed
    , "  slots                  : " ++ range a.slotRange
    , "  block times            : " ++ range a.timeRange ]

/-- A machine-readable rendering of the snapshot.  Amounts stay decimal strings so
that no precision is lost. -/
def toJsonString (s : Snapshot) : String :=
  let holders := String.intercalate ",\n" <| s.holders.map fun h =>
    "    {\"address\": \"" ++ h.address ++ "\", \"amount\": \"" ++ toString h.amount
      ++ "\", \"uiAmount\": \"" ++ Solana.Decimal.render h.amount s.decimals
      ++ "\", \"share\": \"" ++ renderRat (share h.amount s.supply) 8 ++ "\"}"
  String.intercalate "\n"
    [ "{"
    , "  \"mint\": \"" ++ s.mint ++ "\","
    , "  \"decimals\": " ++ toString s.decimals ++ ","
    , "  \"supply\": \"" ++ toString s.supply ++ "\","
    , "  \"holders\": ["
    , holders
    , "  ]"
    , "}" ]

end Solana.Report
