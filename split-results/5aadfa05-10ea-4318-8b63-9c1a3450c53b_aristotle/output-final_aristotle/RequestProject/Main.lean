import Mathlib
-- Core model
import RequestProject.AZ.TenfoldWay
import RequestProject.AZ.Classification
-- Clifford / K-theory front-end and blades
import RequestProject.AZ.CliffordK
import RequestProject.AZ.BladeClassify
import RequestProject.AZ.SpectralReduction
import RequestProject.AZ.Examples
-- Symmetry-class extensions
import RequestProject.AZ.NonHermitian
import RequestProject.AZ.Crystalline
-- Categorical structure
import RequestProject.FibredCats.Grothendieck
import RequestProject.FibredCats.BulkBoundary
-- FFI surface
import RequestProject.FFI.GradedAlgebra
import RequestProject.FFI.ExtractionReflection

/-!
# Altland–Zirnbauer tenfold-way model — top-level aggregator

This module imports the whole Altland–Zirnbauer (AZ) development so that the entire
project is exercised by the default build target.  The modules are grouped above in
dependency order; see `OVERVIEW.md` at the project root for a map of every file and
its headline theorems.

## Core model
* `RequestProject.AZ.TenfoldWay` — the ten symmetry classes, classifying groups,
  and the Bott-periodic periodic table `classify`.
* `RequestProject.AZ.Classification` — operational predicates/checks classifying an
  item from its `(T², C², S)` symmetry data.

## Clifford / K-theory front-end and blades
* `RequestProject.AZ.CliffordK` — Clifford signatures, K-theory spectra, the bridge
  `classify = classifyViaClifford`, and a CRT/simulation API.
* `RequestProject.AZ.BladeClassify` — classifying arbitrary Clifford blades and the
  implementation's self-reflection.
* `RequestProject.AZ.SpectralReduction` — degenerate/massless boundaries, domain
  walls, and integer-graded higher K-theory `kGroupN`.
* `RequestProject.AZ.Examples` — named condensed-matter models checked against the
  K-groups.

## Symmetry-class extensions
* `RequestProject.AZ.NonHermitian` — the non-Hermitian "38-fold way".
* `RequestProject.AZ.Crystalline` — crystalline/equivariant classes and hybrids.

## Categorical structure
* `RequestProject.FibredCats.Grothendieck` — the fibred category of AZ phases.
* `RequestProject.FibredCats.BulkBoundary` — the bulk–boundary correspondence.

## FFI surface
* `RequestProject.FFI.GradedAlgebra` — the C-ABI "graded algebra of fibers".
* `RequestProject.FFI.ExtractionReflection` — certified runtime extraction.
-/

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option pp.fullNames true
set_option pp.structureInstances true
set_option pp.coercions.types true
set_option pp.funBinderTypes true
set_option pp.letVarTypes true
set_option pp.piBinderTypes true

set_option grind.warning false
