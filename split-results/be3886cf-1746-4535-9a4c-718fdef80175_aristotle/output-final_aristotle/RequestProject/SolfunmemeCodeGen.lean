/-
# Solfunmeme IPLD Code Generation

This module hooks the solfunmeme IPLD Schema into the existing code
generation pipeline to produce:
1. Lean 4 source text for all 121 solfunmeme types
2. SCC analysis of the concept dependency graph
3. Debug info about mutual recursion clusters
-/

import RequestProject.IPLDCodeGen
import RequestProject.SolfunmemeSchema

namespace Solfunmeme.CodeGen

open IPLD
open Solfunmeme

-- ============================================================================
-- § 1  Dependency analysis
-- ============================================================================

/-- Print the SCC structure of the solfunmeme schema. -/
def solfunmemeDebugInfo : String :=
  IPLD.CodeGen.debugInfo solfunmemeSchema

-- Uncomment to see the full SCC analysis:
-- #eval IO.println solfunmemeDebugInfo

-- ============================================================================
-- § 2  Generated Lean 4 source text
-- ============================================================================

/-- Generate Lean 4 source code for all solfunmeme types. -/
def solfunmemeGeneratedSource : String :=
  IPLD.CodeGen.generate solfunmemeSchema "SolfunmemeGen"

-- ============================================================================
-- § 3  Statistics
-- ============================================================================

/-- Count the number of SCCs in the solfunmeme type graph. -/
def sccCount : Nat :=
  let typeLookup := solfunmemeSchema.types
  let typeNames := typeLookup.map (·.1)
  let adj (name : String) : List String :=
    match typeLookup.find? (·.1 == name) with
    | some (_, td) => (IPLD.CodeGen.typeDefnDeps td).filter typeNames.contains
    | none => []
  (IPLD.CodeGen.computeSCCs typeNames adj).length

/-- Count mutual blocks needed. -/
def mutualBlockCount : Nat :=
  let typeLookup := solfunmemeSchema.types
  let typeNames := typeLookup.map (·.1)
  let adj (name : String) : List String :=
    match typeLookup.find? (·.1 == name) with
    | some (_, td) => (IPLD.CodeGen.typeDefnDeps td).filter typeNames.contains
    | none => []
  let sccs := IPLD.CodeGen.computeSCCs typeNames adj
  sccs.filter (fun scc => IPLD.CodeGen.needsMutualBlock scc adj) |>.length

#eval IO.println s!"Solfunmeme schema: {schemaTypeCount} types, {sccCount} SCCs, {mutualBlockCount} mutual blocks"

end Solfunmeme.CodeGen
