/-
# SelfPartition.lean — Self‑partitioner using PadicEntropyDAG

Walks the Lean `Environment`, assigns each declaration a CID,
maps it through the p-adic entropy DAG to a `PartitionKey`,
buckets declarations by key, and emits:
  1. A new Lean module per bucket
  2. A DAG-JSON shard manifest per bucket
  3. Deterministic structural checksums per bucket
-/

import Lean
import RequestProject.PadicEntropyDAG

open Lean
open PadicEntropyDAG

namespace SelfPartition

/-! ## §1. CID Assignment -/

/-- Compute a content-identifier for a `Name` via `mixHash`. -/
def cidOfName (n : Name) : Nat :=
  (mixHash (hash n) 0x9e3779b97f4a7c15).toNat

/-- CID of a constant, returning `none` if the name is not in the environment. -/
def cidOfConst (env : Environment) (n : Name) : Option Nat :=
  if env.contains n then some (cidOfName n) else none

/-! ## §2. Environment Walking + Bucketization -/

/-- Collect all constant names from the environment. -/
def allConstNames (env : Environment) : Array Name :=
  env.constants.fold (fun acc n _ => acc.push n) #[]

/-- A bucket is an array of declaration names sharing one `PartitionKey`. -/
abbrev Bucket := Array Name

/-- Partition every constant in `env` into buckets keyed by `PartitionKey`. -/
def bucketize (layers : DagLayers) (env : Environment)
    : Std.HashMap PartitionKey Bucket :=
  let names := allConstNames env
  names.foldl (init := ({} : Std.HashMap PartitionKey Bucket)) fun m n =>
    match cidOfConst env n with
    | none => m
    | some cid =>
      let key := partitionKeyOfCid layers cid
      let bucket := m.getD key #[]
      m.insert key (bucket.push n)

/-! ## §3. Emitting Lean Modules -/

/-- Render a minimal Lean module that re-exports the declarations in a bucket. -/
def renderModule (key : PartitionKey) (decls : Bucket) : String :=
  let header :=
    s!"-- Auto-generated partition shard\n" ++
    s!"-- PartitionKey: irrep={key.irrep} s1=({key.stage1.1},{key.stage1.2.1},{key.stage1.2.2}) " ++
    s!"s2=({key.stage2.1},{key.stage2.2.1},{key.stage2.2.2}) s3={key.stage3}\n\n"
  let body := decls.foldl (fun acc n =>
    let pfx := n.getPrefix
    if pfx.isAnonymous then acc
    else acc ++ s!"-- decl: {n}\n") ""
  header ++ body

/-- Write one `.lean` file per bucket into the `Partition/` directory. -/
def writeBuckets (m : Std.HashMap PartitionKey Bucket) : IO Unit := do
  IO.FS.createDirAll "Partition"
  for (key, decls) in m.toList do
    let fname :=
      s!"Partition/irrep_{key.irrep}_s1_{key.stage1.1}_{key.stage1.2.1}_{key.stage1.2.2}" ++
      s!"_s2_{key.stage2.1}_{key.stage2.2.1}_{key.stage2.2.2}_s3_{key.stage3}.lean"
    IO.FS.writeFile fname (renderModule key decls)

/-! ## §4. DAG-JSON Shard Emission -/

/-- Aggregate exponents over a set of CIDs by componentwise max. -/
def aggregateExponentsFromCids (cids : Array Nat) : Array ℕ :=
  let init : Array ℕ := .replicate 15 0
  cids.foldl (fun acc cid =>
    let v := padicVector cid
    (List.zipWith Nat.max acc.toList v.toList).toArray) init

private def natToJson (n : Nat) : Json := toJson n
private def floatToJson (f : Float) : Json := Json.str (toString f)

/-- Render a single shard's JSON from a `PartitionKey` and its CIDs. -/
def renderShardJson (key : PartitionKey) (cids : Array Nat) : Json := Id.run do
  let exps := aggregateExponentsFromCids cids
  let m    := computeMetrics exps
  let node := mkIrrepNode #[key.irrep] exps

  let metricsJson := Json.mkObj [
    ("sum",    natToJson m.sum),
    ("logsum", floatToJson m.logsum),
    ("bits",   floatToJson m.bits),
    ("trits",  floatToJson m.trits)
  ]

  let keyJson := Json.mkObj [
    ("stage1", Json.arr #[
      natToJson key.stage1.1,
      natToJson key.stage1.2.1,
      natToJson key.stage1.2.2]),
    ("stage2", Json.arr #[
      natToJson key.stage2.1,
      natToJson key.stage2.2.1,
      natToJson key.stage2.2.2]),
    ("stage3", natToJson key.stage3),
    ("irrep",  natToJson key.irrep)
  ]

  let expsJson := Json.arr (exps.map fun e => natToJson e)
  let scalesJson := Json.arr (node.componentLog10Scales.map fun f => floatToJson f)
  let idsJson := Json.arr (node.irrepIds.map fun i => natToJson i)

  let nodeJson := Json.mkObj [
    ("irrep_ids", idsJson),
    ("exponents", expsJson),
    ("component_log10_scales", scalesJson),
    ("metrics", metricsJson)
  ]

  Json.mkObj [
    ("partitionKey", keyJson),
    ("node", nodeJson)
  ]

/-- Write one `.dag.json` file per bucket into the `Partition/` directory. -/
def writeShardJsons (_layers : DagLayers)
    (env : Environment)
    (m : Std.HashMap PartitionKey Bucket) : IO Unit := do
  IO.FS.createDirAll "Partition"
  for (key, decls) in m.toList do
    let cids := decls.filterMap (cidOfConst env)
    let j := renderShardJson key cids
    let fname :=
      s!"Partition/irrep_{key.irrep}_s1_{key.stage1.1}_{key.stage1.2.1}_{key.stage1.2.2}" ++
      s!"_s2_{key.stage2.1}_{key.stage2.2.1}_{key.stage2.2.2}_s3_{key.stage3}.dag.json"
    IO.FS.writeFile fname (j.pretty)

/-! ## §5. Top-Level Driver -/

/-- Self-partition: import the current project, partition by p-adic entropy DAG,
    emit Lean modules and DAG-JSON shards. -/
def selfPartition : IO Unit := do
  let env ← importModules #[{ module := `RequestProject.PadicEntropyDAG }] {}
  let layers := buildFullDAG
  let buckets := bucketize layers env
  let nBuckets := buckets.size
  let nDecls := buckets.fold (fun acc _ v => acc + v.size) 0
  IO.println s!"SelfPartition: {nDecls} declarations → {nBuckets} buckets"
  writeBuckets buckets
  writeShardJsons layers env buckets
  IO.println "SelfPartition: done."

/-! ## §6. Structural Checksums -/

/-- Summary of a single partition bucket: deterministic hash fingerprint. -/
structure BucketSummary where
  /-- Hash of the `PartitionKey` itself. -/
  keyHash : UInt64
  /-- XOR-combined hash of all CIDs in the bucket (order-independent). -/
  cidHash : UInt64
  /-- Number of declarations in the bucket. -/
  size    : Nat
  deriving Repr

/-- Mix a natural number into a 64-bit hash. -/
def hashNat (n : Nat) : UInt64 :=
  mixHash (UInt64.ofNat n) 0x9e3779b97f4a7c15

/-- Deterministic hash of a `PartitionKey`, combining all stage residues and irrep. -/
def hashPartitionKey (k : PartitionKey) : UInt64 :=
  let (a, b, c) := k.stage1
  let (d, e, f) := k.stage2
  let h0 := hashNat a
  let h1 := h0 ^^^ hashNat b
  let h2 := h1 ^^^ hashNat c
  let h3 := h2 ^^^ hashNat d
  let h4 := h3 ^^^ hashNat e
  let h5 := h4 ^^^ hashNat f
  let h6 := h5 ^^^ hashNat k.stage3
  h6 ^^^ hashNat k.irrep

/-- Compute a `BucketSummary` for each bucket in the partition.
    The `cidHash` is order-independent (XOR), so bucket iteration order doesn't matter. -/
def summarizeBuckets (env : Environment) (m : Std.HashMap PartitionKey Bucket)
    : Array BucketSummary := Id.run do
  let mut out : Array BucketSummary := #[]
  for (k, decls) in m.toList do
    let keyH := hashPartitionKey k
    let cidH := decls.foldl (fun acc n =>
      match cidOfConst env n with
      | some cid => acc ^^^ hashNat cid
      | none     => acc) (0 : UInt64)
    out := out.push { keyHash := keyH, cidHash := cidH, size := decls.size }
  out

/-! ## §7. Evolution Driver -/

namespace Evo

/-- Complete summary of one evolution step: the structural fingerprint
    of every partition bucket. -/
structure EvolutionSummary where
  /-- Per-bucket structural fingerprints. -/
  bucketSummaries : Array BucketSummary
  /-- Total number of buckets. -/
  numBuckets      : Nat
  /-- Total number of declarations across all buckets. -/
  numDecls        : Nat
  deriving Repr

/-- Execute one evolution step:
    1. Import the PadicEntropyDAG module (and its transitive deps)
    2. Build the full 194-node DAG
    3. Partition the environment by `PartitionKey`
    4. Emit Lean modules + DAG-JSON shards
    5. Compute and return deterministic checksums -/
def evolveOnce : IO EvolutionSummary := do
  let env ← importModules #[{ module := `RequestProject.PadicEntropyDAG }] {}
  let layers := buildFullDAG
  let buckets := bucketize layers env
  -- Emit partitioned Lean modules
  writeBuckets buckets
  -- Emit DAG-JSON shards
  writeShardJsons layers env buckets
  -- Compute checksums
  let summaries := summarizeBuckets env buckets
  let nBuckets := buckets.size
  let nDecls := buckets.fold (fun acc _ v => acc + v.size) 0
  pure { bucketSummaries := summaries, numBuckets := nBuckets, numDecls := nDecls }

/-- Pretty-print an `EvolutionSummary`. -/
def EvolutionSummary.print (s : EvolutionSummary) : IO Unit := do
  IO.println s!"┌─ Evolution Summary ─────────────────────────"
  IO.println s!"│ Buckets: {s.numBuckets}  Declarations: {s.numDecls}"
  IO.println s!"├─ Bucket checksums:"
  for b in s.bucketSummaries do
    IO.println s!"│  keyHash={b.keyHash}  cidHash={b.cidHash}  size={b.size}"
  IO.println s!"└──────────────────────────────────────────────"

end Evo

end SelfPartition
