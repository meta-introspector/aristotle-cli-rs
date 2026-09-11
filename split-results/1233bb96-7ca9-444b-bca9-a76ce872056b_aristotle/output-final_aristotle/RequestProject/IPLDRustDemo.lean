/-
# IPLD Rust Code Generation Demo

This file demonstrates the Rust code generator by producing Rust type
definitions from the self-describing `ipldSchemaSchema`.

Run `#eval IO.println (IPLD.RustCodeGen.generate IPLD.ipldSchemaSchema)` to see
the full output.
-/

import RequestProject.IPLDRustCodeGen

-- Preview: generate Rust source for the IPLD schema-schema
-- Uncomment to see output:
-- #eval IO.println (IPLD.RustCodeGen.generate IPLD.ipldSchemaSchema)

/-- Check if `needle` appears as a substring of `haystack`. -/
private def containsSub (haystack needle : String) : Bool :=
  (haystack.splitOn needle).length != 1

-- Quick smoke test: the generator runs and produces non-empty output
#eval do
  let code := IPLD.RustCodeGen.generate IPLD.ipldSchemaSchema
  IO.println s!"Generated {code.length} characters of Rust source"
  IO.println s!"Contains 'pub struct Schema': {containsSub code "pub struct Schema"}"
  IO.println s!"Contains 'pub enum TypeDefn': {containsSub code "pub enum TypeDefn"}"
  IO.println s!"Contains 'Box<': {containsSub code "Box<"}"
  IO.println s!"Contains 'Vec<': {containsSub code "Vec<"}"
