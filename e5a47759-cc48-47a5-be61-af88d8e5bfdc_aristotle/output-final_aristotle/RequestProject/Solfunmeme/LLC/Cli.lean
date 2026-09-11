import RequestProject.Solfunmeme.LLC.Sim
import RequestProject.Solfunmeme.ZKP.Schema

/-!
# `introspector-llc`: the simulated filings and the proof schema, runnable

    introspector-llc packet             the formation packet, as text
    introspector-llc calendar [YEARS]   the filing calendar (default 5 years)
    introspector-llc standing           run the calendar through the standing machine
    introspector-llc portfolio          the open-source investment criteria
    introspector-llc schema             the ZKP schema, as JSON
    introspector-llc emit DIR           write everything under DIR

`emit` writes `DIR/filings/` and `DIR/zkp/schema.json`.

Everything printed comes from the definitions the theorems in
`RequestProject/LLC/Sim.lean` and `RequestProject/ZKP/Schema.lean` are about,
so the artefacts are the model, not a description of it.

This is a simulation.  The forms, fees and deadlines are model parameters; the
output is not a filing and nothing here is legal or tax advice.
-/

namespace LLC.Cli

open LLC LLC.Sim

def usage : String :=
  "introspector-llc packet             the formation packet, as text\n" ++
  "introspector-llc calendar [YEARS]   the filing calendar (default 5 years)\n" ++
  "introspector-llc standing           run the calendar through the standing machine\n" ++
  "introspector-llc portfolio          the open-source investment criteria\n" ++
  "introspector-llc schema             the ZKP schema, as JSON\n" ++
  "introspector-llc emit DIR           write everything under DIR\n"

/-- The standing machine, run over the calendar, reported. -/
def standingText : String :=
  let r := Record.opening.run compliantEvents
  let bad := (Record.opening.run lapsedEvents)
  let cured := bad.run cureEvents
  let name : Standing → String
    | .good => "good" | .delinquent => "delinquent"
    | .revoked => "revoked" | .dissolved => "dissolved"
  "# standing machine (simulated)\n" ++
  "compliant-run-standing: " ++ name r.standing ++ "\n" ++
  "compliant-run-filings: " ++ toString r.filed.length ++ "\n" ++
  "compliant-run-outstanding: " ++ toString r.outstandingReports ++ "\n" ++
  "compliant-run-fees: " ++ renderCents r.feesPaidCents ++ "\n" ++
  "two-lapses-standing: " ++ name bad.standing ++ "\n" ++
  "two-lapses-outstanding: " ++ toString bad.outstandingReports ++ "\n" ++
  "after-cure-standing: " ++ name cured.standing ++ "\n" ++
  "after-cure-outstanding: " ++ toString cured.outstandingReports ++ "\n"

/-- The eleven scored criteria of the portfolio document, with the threshold
and the non-negotiables, as text. -/
def portfolioText : String :=
  "# open-source investment criteria\n" ++
  "threshold: " ++ toString Portfolio.threshold ++ " of 55\n" ++
  String.join (Portfolio.criteriaNames.map (fun n => "criterion: " ++ n ++ "\n")) ++
  String.join (Portfolio.nonNegotiableNames.map (fun n => "non-negotiable: " ++ n ++ "\n")) ++
  String.join (Portfolio.redFlagNames.map (fun n => "red-flag: " ++ n ++ "\n"))

/-- The whole simulated corporate record, as a list of files. -/
def filingFiles : List (String × String) :=
  [ ("filings/formation-packet.txt",
      "# introspector llc — new jersey formation packet (simulated)\n" ++
      "# not legal or tax advice; fees and deadlines are model parameters\n\n" ++
      packetText introspector),
    ("filings/calendar.txt", calendarText introspector 5),
    ("filings/standing.txt", standingText),
    ("filings/portfolio-criteria.txt", portfolioText) ]

def run : List String → IO UInt32
  | ["packet"] => do IO.print (packetText introspector); return 0
  | ["calendar"] => do IO.print (calendarText introspector 5); return 0
  | ["calendar", n] => do
      match n.toNat? with
      | some y => IO.print (calendarText introspector y); return 0
      | none => IO.eprintln usage; return 2
  | ["standing"] => do IO.print standingText; return 0
  | ["portfolio"] => do IO.print portfolioText; return 0
  | ["schema"] => do IO.print ZKP.schemaJson; return 0
  | ["emit", dir] => do
      IO.FS.createDirAll (dir ++ "/filings")
      IO.FS.createDirAll (dir ++ "/zkp")
      for (name, contents) in filingFiles do
        IO.FS.writeFile (dir ++ "/" ++ name) contents
        IO.println (dir ++ "/" ++ name ++ "  " ++ toString contents.utf8ByteSize ++ " bytes")
      IO.FS.writeFile (dir ++ "/zkp/schema.json") ZKP.schemaJson
      IO.println (dir ++ "/zkp/schema.json  " ++ toString ZKP.schemaJson.utf8ByteSize ++ " bytes")
      return 0
  | _ => do IO.eprintln usage; return 2

end LLC.Cli

def main (args : List String) : IO UInt32 := LLC.Cli.run args
