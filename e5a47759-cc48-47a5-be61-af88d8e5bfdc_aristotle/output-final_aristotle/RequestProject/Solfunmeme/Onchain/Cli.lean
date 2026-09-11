import RequestProject.Solfunmeme.Onchain.Report
import RequestProject.Solfunmeme.Onchain.Rpc

/-!
The `solana-holders` command line front end.

    solana-holders [MINT] [options]

With no arguments it ingests the SOLFUNMEME mint, reading whatever it can from
the local dataset directory and fetching the rest from the public mainnet
endpoint.  `--offline` restricts it to the dataset, so the whole pipeline runs
against a local clone with no network at all.
-/

namespace Solana.Cli

open Lean (Json)
open Solana.Holders
open Solana.Rpc

/-- The mint this program was written for. -/
def defaultMint : String := "BwUTq7fS6sfUmHDwAiCQZ3asSiPEapW5zDrsbwtapump"

/-- Parsed command line. -/
structure Options where
  /-- Mint address to ingest. -/
  mint : String := defaultMint
  /-- RPC and dataset configuration. -/
  cfg : Config := {}
  /-- Whether to run `getMultipleAccounts` to merge token accounts by wallet. -/
  resolveOwners : Bool := true
  /-- Emit JSON instead of the text report. -/
  json : Bool := false
  /-- Also report the recent-signature activity of the mint. -/
  signatures : Bool := false
  /-- Report only the signature activity, skipping holder ingestion entirely.
  Useful against a dataset that has `getSignaturesForAddress` captures but no
  `getTokenLargestAccounts` capture. -/
  activityOnly : Bool := false
  /-- Write the derived snapshot back into the dataset directory. -/
  emit : Bool := false
  /-- Offline replay from explicit files: `getTokenSupply` (or `getAccountInfo`),
  `getTokenLargestAccounts` and optionally `getMultipleAccounts`. -/
  fromFile : Option (String × String × Option String) := none
  /-- Print usage and exit. -/
  help : Bool := false
  deriving Inhabited

/-- Usage text. -/
def usage : String :=
  "solana-holders — ingest the holder distribution of an SPL token\n\n" ++
  "usage: solana-holders [MINT] [options]\n\n" ++
  "  MINT                       base-58 mint address (default: SOLFUNMEME)\n" ++
  "  --endpoint URL             JSON-RPC endpoint (default $SOLANA_URL or mainnet-beta)\n" ++
  "  --dataset DIR              directory of captured RPC responses (default rpc_cache)\n" ++
  "  --no-dataset               neither read nor write captures\n" ++
  "  --offline                  never touch the network; use the dataset only\n" ++
  "  --timeout N                curl timeout in seconds (default 30)\n" ++
  "  --retries N                retries per request (default 3)\n" ++
  "  --no-owners                skip getMultipleAccounts owner resolution\n" ++
  "  --signatures               also summarise getSignaturesForAddress activity\n" ++
  "  --activity-only            report only that activity, skipping the holder ingest\n" ++
  "  --emit                     write the derived snapshot into the dataset directory\n" ++
  "  --json                     print JSON instead of the text report\n" ++
  "  --from-file S L [O]        replay explicit response files instead\n" ++
  "  -h, --help                 this message\n"

/-- Parse the argument list. -/
partial def parseArgs (args : List String) (o : Options) : Except String Options :=
  match args with
  | [] => .ok o
  | "-h" :: _ | "--help" :: _ => .ok { o with help := true }
  | "--endpoint" :: u :: rest => parseArgs rest { o with cfg := { o.cfg with endpoint := u } }
  | "--dataset" :: d :: rest => parseArgs rest { o with cfg := { o.cfg with dataset := some d } }
  | "--no-dataset" :: rest => parseArgs rest { o with cfg := { o.cfg with dataset := none } }
  | "--offline" :: rest => parseArgs rest { o with cfg := { o.cfg with offline := true } }
  | "--timeout" :: n :: rest =>
      match n.toNat? with
      | some k => parseArgs rest { o with cfg := { o.cfg with timeout := k } }
      | none => .error s!"--timeout expects a number, got {n}"
  | "--retries" :: n :: rest =>
      match n.toNat? with
      | some k => parseArgs rest { o with cfg := { o.cfg with retries := k } }
      | none => .error s!"--retries expects a number, got {n}"
  | "--no-owners" :: rest => parseArgs rest { o with resolveOwners := false }
  | "--signatures" :: rest => parseArgs rest { o with signatures := true }
  | "--activity-only" :: rest =>
      parseArgs rest { o with signatures := true, activityOnly := true }
  | "--emit" :: rest => parseArgs rest { o with emit := true }
  | "--json" :: rest => parseArgs rest { o with json := true }
  | "--from-file" :: s :: l :: rest =>
      match rest with
      | ow :: rest' =>
          if ow.startsWith "-" then parseArgs rest { o with fromFile := some (s, l, none) }
          else parseArgs rest' { o with fromFile := some (s, l, some ow) }
      | [] => .ok { o with fromFile := some (s, l, none) }
  | a :: rest =>
      if a.startsWith "-" then .error s!"unknown option: {a}"
      else parseArgs rest { o with mint := a }

/-- Read a response file and take its `result`, so both whole RPC responses and
bare results are accepted. -/
def readResult (path : String) : IO Json := do
  match Solana.Dataset.resultOf (← IO.FS.readFile path) with
  | .ok j => return j
  | .error e => throw <| IO.userError s!"{path}: {e}"

/-- Build the snapshot the options ask for. -/
def run (o : Options) : IO Snapshot := do
  match o.fromFile with
  | some (s, l, ow) => do
      let sj ← readResult s
      let lj ← readResult l
      let oj ← match ow with
        | none => pure none
        | some p => some <$> readResult p
      match snapshotOfResults o.mint sj lj oj with
      | .ok snap => return snap
      | .error e => throw <| IO.userError e
  | none => ingest o.cfg o.mint o.resolveOwners

/-- The activity section, when `--signatures` was given. -/
def activityReport (o : Options) : IO String := do
  let rs ← getSignatures o.cfg o.mint
  return "\n" ++ Solana.Report.renderActivity (Solana.Dataset.summarize rs)

/-- Entry point. -/
def main (args : List String) : IO UInt32 := do
  let envEndpoint ← IO.getEnv "SOLANA_URL"
  let base : Options := { cfg := { endpoint := envEndpoint.getD (Config.endpoint {}) } }
  match parseArgs args base with
  | .error e => do IO.eprintln e; IO.eprint usage; return 2
  | .ok o =>
      if o.help then do IO.print usage; return 0
      else
        try
          let body ← if o.activityOnly then pure "" else do
            let snap ← run o
            if o.emit then
              match o.cfg.dataset with
              | none => IO.eprintln "warning: --emit ignored, no dataset directory"
              | some dir =>
                  let path ← Solana.Dataset.write (System.FilePath.mk dir)
                    ⟨"holderSnapshot", "address", o.mint⟩ (Solana.Report.toJsonString snap)
                  IO.eprintln s!"wrote {path}"
            pure (if o.json then Solana.Report.toJsonString snap else Solana.Report.render snap)
          let extra ← if o.signatures then activityReport o else pure ""
          IO.println ((if o.activityOnly then extra.trimAsciiStart.toString else body ++ extra))
          return 0
        catch e => do
          IO.eprintln s!"error: {e}"
          return 1

end Solana.Cli

/-- Executable entry point. -/
def main (args : List String) : IO UInt32 := Solana.Cli.main args
