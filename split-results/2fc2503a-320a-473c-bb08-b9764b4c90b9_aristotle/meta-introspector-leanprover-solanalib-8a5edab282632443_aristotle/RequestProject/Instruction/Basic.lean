/-
Copyright (c) 2026 Solana Foundation. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Solanalib Contributors
-/
import RequestProject.Primitives.Pubkey

/-!
# Instructions

A Solana instruction is the unit of program invocation: a target program
identified by its pubkey, a list of accounts the program may read or
write, and an opaque data payload the program interprets itself.

This module matches the on-chain layout exactly so downstream specs
about transaction processing, CPI semantics, and Anchor account
validation can reason about real instructions:

```rust
// solana-instruction
pub struct Instruction {
    pub program_id: Pubkey,
    pub accounts:   Vec<AccountMeta>,
    pub data:       Vec<u8>,
}

pub struct AccountMeta {
    pub pubkey:      Pubkey,
    pub is_signer:   bool,
    pub is_writable: bool,
}
```

## Main definitions

* `Solanalib.AccountMeta` — pubkey plus the signer/writable flags that
  declare how an instruction expects to use a given account.
* `Solanalib.Instruction` — program id, account-meta list, opaque data.
-/

namespace Solanalib

/-- Metadata about how an instruction expects to use a given account.

`isSigner = true` means the transaction must carry a signature from this
account's pubkey; `isWritable = true` means the program may mutate the
account's lamports or data. The runtime rejects the transaction if a
program tries to write an account marked read-only, or if a required
signer hasn't signed. -/
@[ext]
structure AccountMeta where
  /-- The account's address. -/
  pubkey : Pubkey
  /-- True iff the transaction must carry a valid signature for `pubkey`. -/
  isSigner : Bool
  /-- True iff the invoked program may mutate this account. -/
  isWritable : Bool
  deriving Repr, DecidableEq

/-- A Solana instruction: which program to call, which accounts to pass,
and what payload to deliver. The program interprets `data` itself. -/
@[ext]
structure Instruction where
  /-- The pubkey of the program that will execute this instruction. -/
  programId : Pubkey
  /-- The accounts the instruction reads or writes, with their access modes. -/
  accounts : List AccountMeta
  /-- Opaque bytes delivered to the program; encoding is program-specific. -/
  data : ByteArray
  deriving Repr, DecidableEq

namespace Instruction

/-- The list of accounts an instruction *requires to be signers*. -/
def signers (ix : Instruction) : List Pubkey :=
  ix.accounts.filterMap fun m => if m.isSigner then some m.pubkey else none

/-- The list of accounts an instruction *may mutate*. -/
def writables (ix : Instruction) : List Pubkey :=
  ix.accounts.filterMap fun m => if m.isWritable then some m.pubkey else none

end Instruction
end Solanalib
