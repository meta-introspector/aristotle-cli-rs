/-
# The ATLAS of Finite Groups — Lean 4 Formalization Sketch

This project provides a formalization sketch of key structures and data from
the ATLAS of Finite Groups (Conway, Curtis, Norton, Parker, Wilson, 1985).

## Contents

- `Atlas.ClassFunction`: Class functions and characters of representations
- `Atlas.CharacterTable`: Character table structure and ATLAS entry type,
  with example entries for A₅, M₁₁, M₁₂, M₂₄
- `Atlas.Classification`: The families of finite simple groups, sporadic
  group enumeration, and the statement of the CFSG
- `Atlas.GroupOrders`: Order formulas for classical groups, verified for small cases
- `Atlas.MaximalSubgroups`: Maximal subgroup data as recorded in the ATLAS
- `Atlas.GroupExtensions`: The ATLAS's notation for group extensions (A.B, A:B, etc.)
  and Schur multiplier/outer automorphism data
- `Atlas.ProvedFacts`: Formally verified numerical facts from the ATLAS
  (order factorizations for all 26 sporadic groups, degree sum formulas,
  divisibility relations, supersingular primes)
- `Atlas.ConstructedGroups`: Concrete constructions of groups appearing
  in the ATLAS (A₅ simplicity, GL orders, symmetric group orders)
-/
import RequestProject.Atlas.ClassFunction
import RequestProject.Atlas.CharacterTable
import RequestProject.Atlas.Classification
import RequestProject.Atlas.GroupOrders
import RequestProject.Atlas.MaximalSubgroups
import RequestProject.Atlas.GroupExtensions
import RequestProject.Atlas.ProvedFacts
import RequestProject.Atlas.ConstructedGroups
