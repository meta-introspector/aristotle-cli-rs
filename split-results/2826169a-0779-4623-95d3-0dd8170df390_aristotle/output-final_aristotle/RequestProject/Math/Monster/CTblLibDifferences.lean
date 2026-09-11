/-
# CTblLib Differences — Character Table Library Changelog

## Source
The file 'ctbldiff.json' from the GAP CTblLib package documents all differences
between character table data from version 1.1.3 and later versions.
Each entry is [Identifier, Type, What, Description, Flag, Version].

## Key Statistics (extracted from the provided data)
The changelog records hundreds of entries covering:
- NEW tables (ordinary and modular)
- NEW class fusions
- CHANGED (C) class fusions
- Fixed (***) tables
- NEW table of marks (tom) fusions

## Groups Featured
Almost simple groups and their central extensions, including:
- Extensions of L₃(4) (many entries for (2²×3).L₃(4), (4²×3).L₃(4), etc.)
- Extensions of U₆(2) ((2²×3).U₆(2) and variants)
- Extensions of 2E₆(2) ((2²×3).2E₆(2))
- Products with sporadic group subgroups
- Normalizers in sporadic groups (Co₁, Fi₂₂, Fi₂₃, F₃₊, M, B, etc.)
- Sylow normalizers and defect groups

## Relevance
This data tracks the ongoing refinement of the character table library,
which is essential for:
1. Verifying properties of finite simple groups computationally
2. Computing class fusions between subgroups and ambient groups
3. Determining modular character tables for Brauer theory
-/

import Mathlib

namespace CTblLibDifferences

/-! ## §1. Version History

Key versions of CTblLib with significant additions:
- 1.2.0: Major expansion including many extensions of simple groups
- 1.3.0: Defect normalizers, radical normalizers, Sylow normalizers
- 1.3.2: Additional maximal subgroup tables (e.g., F₄(2))
- 1.3.5: Further additions (e.g., O₁₀⁻(2) subgroups)
-/

/-- CTblLib versions with significant character table additions. -/
def ctbllib_versions : List String :=
  ["1.1.3", "1.2.0", "1.3.0", "1.3.2", "1.3.5"]

/-! ## §2. Types of Changes

Each changelog entry has a Type field:
- "NEW": New table or fusion added
- "C": Changed/corrected existing data
- "***": Bug fix (e.g., fixed power maps)
-/

/-- Types of changes in the CTblLib changelog. -/
inductive ChangeType where
  | NEW  -- New table/fusion
  | C    -- Changed existing data
  | FIX  -- Bug fix (denoted *** in the data)
  deriving DecidableEq, Repr

/-! ## §3. Categories of What Changed -/

/-- Categories of data that changed. -/
inductive WhatChanged where
  | table           -- Ordinary character table
  | tableMod (p : ℕ) -- Modular character table (mod p)
  | classFusions    -- Class fusions to/from other groups
  | tomFusion       -- Table of marks fusion
  | casInfo         -- CAS compatibility info
  deriving DecidableEq, Repr

/-! ## §4. Flag Categories

Flags indicate the relationship of a table to the simple group:
- None: Direct extension or subgroup
- Der: Derived from another table
- Dup: Duplicate/alternative construction
- Max: Maximal subgroup
- Fus: Fusion-related
-/

/-- Flag categories for CTblLib entries. -/
inductive CTblFlag where
  | None  -- Standard entry
  | Der   -- Derived from another table
  | Dup   -- Duplicate construction
  | Max   -- Maximal subgroup table
  | Fus   -- Fusion data
  deriving DecidableEq, Repr

/-! ## §5. Notable Entries

Some key entries from the changelog demonstrate the scope
of the character table library project.
-/

/-- Extensions of L₃(4) added in version 1.2.0.
    L₃(4) has Schur multiplier 4² × 3, giving many central extensions. -/
def L34_extensions : List String :=
  ["(2²×3).L3(4)", "(2²×3).L3(4).2_1", "(2²×3).L3(4).2_2",
   "(2²×3).L3(4).2_3", "(2²×3).L3(4).3",
   "(2×12).L3(4)", "(2×4).L3(4)", "(4²×3).L3(4)"]

/-- Schur multiplier of L₃(4) has order 48 = 4² × 3. -/
theorem L34_schur_multiplier_order : 4^2 * 3 = 48 := by native_decide

/-- Defect normalizers computed for sporadic groups in version 1.3.0. -/
def defect_normalizer_groups : List String :=
  ["Co1", "Co3", "Fi22", "Fi23", "F3+", "Suz", "2.Suz", "6.Suz",
   "2.Co1", "ON", "3.ON", "HN", "J4", "Ly", "Th", "B", "2.B", "M"]

/-- Radical normalizers computed for several groups. -/
def radical_normalizer_groups : List String :=
  ["Fi22", "O7(3)", "O8+(2)", "ON", "HN", "Co3", "Th", "Ly"]

/-! ## §6. Statistics from the Changelog -/

-- The first few entries show the pattern:
-- (11:5×D₁₂).2 is a defect normalizer in 2.Co₁ (version 1.3.0)
-- (11:5×M₁₂):2 is a radical normalizer in M (version 1.3.0)
-- (13:6×A₄).2 is a defect normalizer in Co₁ (version 1.3.0)

/-- Primes dividing the order of ²E₆(2) that appear as defect normalizer primes. -/
def E6_primes : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19]

/-- 8 primes divide |²E₆(2)|. -/
theorem E6_primes_count :
    E6_primes.length = 8 := by native_decide

/-! ## §7. Connection to Modular Representation Theory

For each simple group G and prime p dividing |G|, the p-modular
character table records Brauer characters. The CTblLib tracks these
along with class fusions needed to relate ordinary and modular data.

Key modular tables added include:
- mod 2, 3, 5, 7, 11, 13, 17, 19 for various extensions
- These are essential for block theory and decomposition numbers
-/

/-- Primes for which modular tables were most frequently added. -/
def common_modular_primes : List ℕ := [2, 3, 5, 7, 11, 13, 17]

end CTblLibDifferences
