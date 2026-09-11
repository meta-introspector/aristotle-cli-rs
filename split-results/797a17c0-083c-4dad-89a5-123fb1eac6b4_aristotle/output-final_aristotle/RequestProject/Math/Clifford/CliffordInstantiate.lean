/-
# CliffordInstantiate — Instantiation Guide for the Generic Framework

## How to verify Cl(0,n) using CliffordGenericProof

### What you need (per-level data):
1. SPerm generators via Kronecker doubling
2. Generator relation checks (native_decide)
3. Gram orthogonality blocks (native_decide)

### What you get for free (from CliffordGenericProof):
- `GramEngine.forward` — algebra homomorphism `Cl0 n →ₐ[ℝ] M_N(ℝ)`
- `GramEngine.forward_injective` — injectivity
- `GramEngine.finrank_eq` — `finrank ℝ (Cl0 n) = 2^n`

### Template:

```lean
-- 1. Import the generic framework + your SPerm generators + Gram blocks
import RequestProject.Math.Clifford.CliffordGenericProof
import RequestProject.Math.Clifford.CliffordCl10SPerm
import RequestProject.Math.Clifford.CliffordCl10Gram

-- 2. Build an SPermRep
def cl10Rep : SPermRep 10 64 where
  generators := gamSP64
  gen_bijective := gamSP64_is_perm

-- 3. Build a GramEngine
def cl10Engine : GramEngine 10 64 where
  rep := cl10Rep
  gram_check := gram10_orthogonality  -- assembled from Gram blocks
  sq_neg_id := gamSP64_sq_neg_id
  anticommute := gamSP64_anticommute

-- 4. Get everything for free
theorem cl10_injective : Function.Injective cl10Engine.forward :=
  cl10Engine.forward_injective (by norm_num)

theorem cl10_dim : Module.finrank ℝ (Cl0 10) = 1024 :=
  cl10Engine.finrank_eq
```

### For Cl(0,11) and beyond:
Simply Kronecker-double the generators and verify new Gram blocks.
The proof framework handles everything else.
-/

-- This file is documentation only — no imports needed.
