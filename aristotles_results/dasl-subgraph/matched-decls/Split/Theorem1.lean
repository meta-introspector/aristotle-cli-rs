import Split.SRewrite
import Split.of_decide_eq_true
import Split.the42Steps
import Split.SProof_steps
import Split.SProof_mk
import Split.Exists
import Split.instDecidableEqBool
import Split.SProof
import Split.instOfNatNat
import Split.Bool_true
import Split.Something_ThisQuine
import Split.And
import Split.Nat
import Split.And_intro
import Split.Exists_intro
import Split.instDecidableEqNat
import Split.isCyclicRewriteChainBool
import Split.isCyclicRewriteChain
import Split.OfNat_ofNat
import Split.Eq
import Split.List_length

-- Theorem1 from environment
-- theorem Theorem1 : Exists.{1} SProof (fun (p : SProof) => And (Eq.{1} Nat (List.length.{0} SRewrite (SProof.steps p)) (OfNat.ofNat.{0} Nat 42 (instOfNatNat 42))) (isCyclicRewriteChain Something.ThisQuine (SProof.steps p)))

-- Stub: this file represents the declaration `Theorem1`.
-- In a full split, the body would be extracted from the environment.
