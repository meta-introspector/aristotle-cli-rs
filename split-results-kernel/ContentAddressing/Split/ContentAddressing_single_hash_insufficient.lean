import Split.instDecidableNot
import Split.False
import Split.Nat_instMulZeroClass
import Split.of_decide_eq_true
import Split.ContentAddressing_identifiedByFamily
import Split.List_Mem_tail
import Split.String
import Split.List_map
import Split.List_sum
import Split.Char_toNat
import Split.Membership_mem
import Split.Exists
import Split.id
import Split.List_cons
import Split.Bool_true
import Split.List
import Split.And
import Split.absurd
import Split.ContentAddressing_HashFunction_mk
import Split.List_instMembership
import Split.Nat
import Split.ContentAddressing_HashFunction
import Split.String_toList
import Split.And_intro
import Split.ContentAddressing_suggestedIdentity
import Split.Exists_intro
import Split.List_Mem_head
import Split.String_length
import Split.Bool
import Split.instAddNat
import Split.Eq_refl
import Split.ContentAddressing_HashFunction_apply
import Split.instDecidableEqNat
import Split.Char
import Split.Decidable_decide
import Split.Eq
import Split.Not
import Split.MulZeroClass_toZero
import Split.List_nil

-- ContentAddressing.single_hash_insufficient from environment
-- theorem ContentAddressing.single_hash_insufficient : Exists.{1} (List.{0} ContentAddressing.HashFunction) (fun (hashFns : List.{0} ContentAddressing.HashFunction) => Exists.{1} ContentAddressing.HashFunction (fun (h : ContentAddressing.HashFunction) => Exists.{1} String (fun (s : String) => Exists.{1} String (fun (t : String) => And (Membership.mem.{0, 0} ContentAddressing.HashFunction (List.{0} ContentAddressing.HashFunction) (List.instMembership.{0} ContentAddressing.HashFunction) hashFns h) (And (ContentAddressing.suggestedIdentity h s t) (Not (ContentAddressing.identifiedByFamily hashFns s t)))))))

-- Stub: this file represents the declaration `ContentAddressing.single_hash_insufficient`.
-- In a full split, the body would be extracted from the environment.
