import RequestProject.Gvcs.Codec.Export

/-!
# The proof-codec artifact extractor

`lake exe codec [dir]` writes the §34 reference layout out of the Lean development:

* `schema/` — the schema documents for the proof object, inputs, outputs, errors and
  the exchange envelope;
* `codecs/` — one worked proof object written by the IPDL, XML, CSV, YAML and raw-text
  codecs;
* `canonical/` — its deterministic serialization and content hash;
* `reconcile/` — two systems compared, the structured differences and the recorded
  resolution;
* `provenance/` — where the object came from and the transformation ledger;
* `tests/` — the round-trip report and a pointer to the machine-checked suite.

Every file is produced by the functions the theorems in `RequestProject/Codec/` are
about.  The default directory is `codec`.
-/

open LifeTrac.Codec LifeTrac.Codec.Export

/-- Write one file and say so. -/
def emit (path : String) (contents : String) : IO Unit := do
  IO.FS.writeFile path contents
  IO.println s!"wrote {path}"

/-- Write the reference layout out. -/
def main (args : List String) : IO Unit := do
  let dir := args.headD "codec"
  for sub in ["", "/schema", "/codecs", "/codecs/ipdl", "/codecs/xml", "/codecs/csv",
              "/codecs/yaml", "/codecs/text", "/canonical", "/reconcile", "/provenance",
              "/tests"] do
    IO.FS.createDirAll (dir ++ sub)
  emit (dir ++ "/README.md") readme
  emit (dir ++ "/schema/proof.yaml") schemaProof
  emit (dir ++ "/schema/input.yaml") schemaInput
  emit (dir ++ "/schema/output.yaml") schemaOutput
  emit (dir ++ "/schema/error.yaml") schemaError
  emit (dir ++ "/schema/envelope.yaml") schemaEnvelope
  emit (dir ++ "/codecs/README.md") codecsReadme
  emit (dir ++ "/codecs/ipdl/proof-001.ipdl") (sampleIpdl ++ "\n")
  emit (dir ++ "/codecs/xml/proof-001.xml") (sampleXml ++ "\n")
  emit (dir ++ "/codecs/csv/proof-001.csv") sampleCsv
  emit (dir ++ "/codecs/yaml/proof-001.yaml") (sampleYaml ++ "\n")
  emit (dir ++ "/codecs/text/proof-001.txt") (sampleText ++ "\n")
  emit (dir ++ "/canonical/README.md") canonicalReadme
  emit (dir ++ "/canonical/proof-001.canonical") (sampleCanonical ++ "\n")
  emit (dir ++ "/canonical/proof-001.hash") (sampleHash ++ "\n")
  emit (dir ++ "/reconcile/left.yaml") (encodeAs .yaml sample ++ "\n")
  emit (dir ++ "/reconcile/right.yaml") (encodeAs .yaml rival ++ "\n")
  emit (dir ++ "/reconcile/diff.yaml") reconcileDiff
  emit (dir ++ "/reconcile/resolution.yaml") reconcileResolution
  emit (dir ++ "/provenance/proof-001.yaml") provenanceArtifact
  emit (dir ++ "/tests/README.md") testsReadme
  emit (dir ++ "/tests/roundtrip.yaml") roundTripReport
