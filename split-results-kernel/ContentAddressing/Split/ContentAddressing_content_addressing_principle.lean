import Split.ContentAddressing_identifiedByFamily
import Split.String
import Split.Membership_mem
import Split.Exists
import Split.List
import Split.And
import Split.List_instMembership
import Split.Nat
import Split.ContentAddressing_single_hash_insufficient
import Split.ContentAddressing_HashFunction
import Split.And_intro
import Split.ContentAddressing_suggestedIdentity
import Split.ContentAddressing_HashFunction_apply
import Split.Eq
import Split.Not

-- ContentAddressing.content_addressing_principle from environment
-- theorem ContentAddressing.content_addressing_principle : And (forall (h : ContentAddressing.HashFunction) (s : String) (t : String), (ContentAddressing.suggestedIdentity h s t) -> (Eq.{1} Nat (ContentAddressing.HashFunction.apply h s) (ContentAddressing.HashFunction.apply h t))) (Exists.{1} (List.{0} ContentAddressing.HashFunction) (fun (hashFns : List.{0} ContentAddressing.HashFunction) => Exists.{1} ContentAddressing.HashFunction (fun (h : ContentAddressing.HashFunction) => Exists.{1} String (fun (s : String) => Exists.{1} String (fun (t : String) => And (Membership.mem.{0, 0} ContentAddressing.HashFunction (List.{0} ContentAddressing.HashFunction) (List.instMembership.{0} ContentAddressing.HashFunction) hashFns h) (And (ContentAddressing.suggestedIdentity h s t) (Not (ContentAddressing.identifiedByFamily hashFns s t))))))))

-- Stub: this file represents the declaration `ContentAddressing.content_addressing_principle`.
-- In a full split, the body would be extracted from the environment.
