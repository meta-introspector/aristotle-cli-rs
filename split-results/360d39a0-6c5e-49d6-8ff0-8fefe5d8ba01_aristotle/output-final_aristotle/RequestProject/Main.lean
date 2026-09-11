/-
  Main.lean — Hub file importing all formalized modules.

  This Lean 4 project is a formalization of key mathematical structures
  from the DASHI project, including:
    • The original Agda modules (Base369, LogicTlurey, Overflow)
    • The Monster group / Moonshine mathematics
    • The dashiCORE mathematical specification (Carrier, Kernel, Defect,
      Admissibility, Hierarchy, Annihilation)

  Modules:
    — Original Agda ports —
    • Base369: Triadic/hexadic/nonary truth values with rotation
    • KernelAlgebra: Ternary carrier, state space, involution, kernel operators
    • UltrametricSpace: Discrete ultrametric spaces, contractions, fixed points
    • LogicTlurey: Dialectical stages with 4-periodicity
    • Overflow: Voxel threshold guards with correctness proofs
    • FascisticSystem: Projection vs invertible operators
    • MonsterMask: Factor masks, Hamming ultrametric, projections
    • SupersingularPrimes: The 15 SSPs, Monster order, Bott periodicity
    • MonsterMoonshine: j-invariant, McKay's observation, Hecke operators
    • CRTPeriod: Digit function periodicity via CRT
    • TenfoldBridges: 10-fold way classification, Clifford dimensions
    • MoonshineEarn: FRACTRAN earning chains, Ramanujan taxi number
    • BottPeriodicity: Bott clock, Clifford dimensions, AZ classification

    — dashiCORE mathematical specification —
    • DashiCarrier: Balanced ternary carrier, support×sign factorization, PQ encoding
    • DashiKernel: Kernel operators, idempotence, defect, mock kernels
    • DashiDefect: Defect semantics, contractivity, iteration convergence
    • DashiAdmissibility: Admissibility quotient, equivalence relation, MDL
    • DashiAnnihilation: Signed filament annihilation, interface count
    • DashiHierarchy: M-levels, lift/project, tensor product, backend invariance
-/
import RequestProject.Base369
import RequestProject.KernelAlgebra
import RequestProject.UltrametricSpace
import RequestProject.LogicTlurey
import RequestProject.Overflow
import RequestProject.FascisticSystem
import RequestProject.MonsterMask
import RequestProject.SupersingularPrimes
import RequestProject.MonsterMoonshine
import RequestProject.CRTPeriod
import RequestProject.TenfoldBridges
import RequestProject.MoonshineEarn
import RequestProject.BottPeriodicity
import RequestProject.DashiCarrier
import RequestProject.DashiKernel
import RequestProject.DashiDefect
import RequestProject.DashiAdmissibility
import RequestProject.DashiAnnihilation
import RequestProject.DashiHierarchy
