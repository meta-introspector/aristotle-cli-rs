/-
# Hardware-Software Interplay: Tenstorrent Architecture Model

This module formalizes the Tenstorrent Grayskull e150 architecture using
inductive types and small-step operational semantics. We model Tensix cores,
RISC-V CPUs, mesh topologies, and prove correctness properties for
parallelism strategies.
-/
import RequestProject.Basic

open scoped BigOperators

/-! ## Core Hardware Types -/

/-- A register file for the RISC-V CPU. -/
structure RegFile where
  /-- 32 general-purpose registers. -/
  regs : Fin 32 → ℤ

/-- Memory model: a mapping from addresses to values. -/
def Memory := ℕ → ℤ

/-- State of a Tensix AI core. -/
structure TensixCore where
  /-- Core identifier in the mesh. -/
  coreId : ℕ × ℕ
  /-- Local SRAM contents. -/
  localMem : Memory
  /-- Whether the core is currently active. -/
  active : Bool
  /-- Current tensor operation being executed (if any). -/
  currentOp : Option TensorOp
  /-- Cycle counter. -/
  cycle : ℕ

/-- High-level tensor operations that can be dispatched to cores. -/
inductive TensorOp where
  | matmul (m n k : ℕ) : TensorOp
  | conv2d (h w c_in c_out : ℕ) : TensorOp
  | elementwise (op : ElementwiseOp) (size : ℕ) : TensorOp
  | reduce (op : ReduceOp) (size : ℕ) : TensorOp

/-- Elementwise operations. -/
inductive ElementwiseOp where
  | add | mul | relu | sigmoid | tanh

/-- Reduction operations. -/
inductive ReduceOp where
  | sum | max | min | mean

/-- State of a RISC-V control CPU. -/
structure RISCV_CPU where
  /-- Register file. -/
  rf : RegFile
  /-- Program counter. -/
  pc : ℕ
  /-- Main memory reference. -/
  mem : Memory
  /-- Instruction count executed. -/
  instrCount : ℕ

/-- RISC-V instruction set (simplified). -/
inductive RISCVInstr where
  | add (rd rs1 rs2 : Fin 32) : RISCVInstr
  | load (rd : Fin 32) (addr : ℕ) : RISCVInstr
  | store (rs : Fin 32) (addr : ℕ) : RISCVInstr
  | dispatch (op : TensorOp) (coreId : ℕ × ℕ) : RISCVInstr
  | fence : RISCVInstr
  | nop : RISCVInstr

/-! ## Mesh Topology -/

/-- A mesh of Tensix cores arranged in a rows × cols grid. -/
structure Mesh where
  rows : ℕ
  cols : ℕ
  cores : Fin rows → Fin cols → TensixCore
  /-- All cores have correct IDs. -/
  id_consistent : ∀ r c, (cores r c).coreId = (r.val, c.val)

/-- The standard Grayskull e150 mesh: 8 rows × 12 columns. -/
def grayskullDims : ℕ × ℕ := (8, 12)

/-- Two cores are adjacent in the mesh if they differ by 1 in exactly one coordinate. -/
def meshAdjacent (p q : ℕ × ℕ) : Prop :=
  (p.1 = q.1 ∧ (p.2 + 1 = q.2 ∨ q.2 + 1 = p.2)) ∨
  (p.2 = q.2 ∧ (p.1 + 1 = q.1 ∨ q.1 + 1 = p.1))

/-- Manhattan distance between two mesh positions. -/
def meshDistance (p q : ℕ × ℕ) : ℕ :=
  Int.natAbs (p.1 - q.1) + Int.natAbs (p.2 - q.2)

/-! ## Small-Step Operational Semantics -/

/-- A system state encompasses the RISC-V CPU and all Tensix cores. -/
structure SystemState where
  cpu : RISCV_CPU
  mesh : Mesh

/-- Small-step transition for the RISC-V CPU executing a single instruction. -/
inductive CPUStep : RISCV_CPU → RISCVInstr → RISCV_CPU → Prop where
  | step_add : ∀ cpu rd rs1 rs2,
      CPUStep cpu (.add rd rs1 rs2)
        { cpu with
          rf := { regs := Function.update cpu.rf.regs rd (cpu.rf.regs rs1 + cpu.rf.regs rs2) }
          pc := cpu.pc + 1
          instrCount := cpu.instrCount + 1 }
  | step_nop : ∀ cpu,
      CPUStep cpu .nop
        { cpu with pc := cpu.pc + 1, instrCount := cpu.instrCount + 1 }

/-! ## Parallelism Strategies -/

/-- Data parallelism: each core processes a shard of the data.
    The global gradient is the sum of local gradients. -/
def dataParallelCorrect {dim : ℕ} {K : ℕ}
    (localGrads : Fin K → Vec dim) (globalGrad : Vec dim) : Prop :=
  ∀ i, globalGrad i = ∑ k, localGrads k i

/-- Tensor parallelism: a weight matrix is sharded across cores.
    Correctness means reconstruction yields the original. -/
def tensorParallelCorrect {m n : ℕ} {K : ℕ}
    (original : Fin m → Fin n → ℝ)
    (shards : Fin K → Fin m → Fin n → ℝ)
    (reconstruct : (Fin K → Fin m → Fin n → ℝ) → Fin m → Fin n → ℝ) : Prop :=
  reconstruct shards = original

/-- Pipeline parallelism: stages are executed in order.
    Correct sequencing means output of stage i feeds into stage i+1. -/
def pipelineCorrect {α : Type*} {K : ℕ}
    (stages : Fin K → α → α) (input : α) (output : α) : Prop :=
  output = (List.ofFn stages).foldl (fun acc f => f acc) input

/-
Row-major sharding: splitting a matrix into row-blocks.
    Reconstruction by concatenation recovers the original.
-/
theorem row_shard_reconstruct {n : ℕ} {K : ℕ} (_hK : 0 < K)
    (original : Fin K → Fin n → ℝ) :
    tensorParallelCorrect (fun (k : Fin K) (j : Fin n) => original k j)
      (fun k => fun k' j => if k = k' then original k' j else 0)
      (fun shards k j => ∑ k', shards k' k j) := by
  exact funext fun k => funext fun j => by simp +decide