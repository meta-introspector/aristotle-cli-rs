import Mathlib

/-!
# Sealevel (Solana SBF) syscall hashes via Murmur3-32

Solana's SBF virtual machine resolves a `call` target by the 32-bit
Murmur3 hash (seed `0`) of the UTF-8 encoding of the symbol name
(see bpf.wtf, "0x03: SBF Instruction Set" / "0x04: Sealevel Syscalls").

This file gives a self-contained implementation of the Murmur3 32-bit hash
and machine-verifies the complete published syscall hash table.

All arithmetic is carried out in `UInt32`, whose operations wrap modulo
`2 ^ 32`, matching the reference algorithm exactly.
-/

namespace Murmur3

/-- Left rotation of a 32-bit word by `r` bits (`0 < r < 32`). -/
def rotl (x : UInt32) (r : UInt32) : UInt32 := (x <<< r) ||| (x >>> (32 - r))

def c1 : UInt32 := 0xcc9e2d51
def c2 : UInt32 := 0x1b873593

/-- Mixing step applied to each full 4-byte block. -/
def mixBlock (h k0 : UInt32) : UInt32 :=
  let k := k0 * c1
  let k := rotl k 15
  let k := k * c2
  let h := h ^^^ k
  let h := rotl h 13
  h * 5 + 0xe6546b64

/-- Mixing step applied to the trailing (≤ 3 byte) partial block. -/
def tailMix (h k0 : UInt32) : UInt32 :=
  let k := k0 * c1
  let k := rotl k 15
  let k := k * c2
  h ^^^ k

/-- Final avalanche / finalization mix. -/
def fmix (h0 : UInt32) : UInt32 :=
  let h := h0 ^^^ (h0 >>> 16)
  let h := h * 0x85ebca6b
  let h := h ^^^ (h >>> 13)
  let h := h * 0xc2b2ae35
  h ^^^ (h >>> 16)

/-- Process the byte stream block by block, accumulating the hash state. -/
def hashAux (h : UInt32) : List UInt8 → UInt32
  | b0 :: b1 :: b2 :: b3 :: rest =>
      let k : UInt32 :=
        (b0.toUInt32) ||| (b1.toUInt32 <<< 8) ||| (b2.toUInt32 <<< 16) ||| (b3.toUInt32 <<< 24)
      hashAux (mixBlock h k) rest
  | [b0, b1, b2] =>
      let k : UInt32 := (b0.toUInt32) ||| (b1.toUInt32 <<< 8) ||| (b2.toUInt32 <<< 16)
      tailMix h k
  | [b0, b1] =>
      let k : UInt32 := (b0.toUInt32) ||| (b1.toUInt32 <<< 8)
      tailMix h k
  | [b0] =>
      let k : UInt32 := (b0.toUInt32)
      tailMix h k
  | [] => h

/-- Murmur3 32-bit hash of a byte list with the given `seed` (default `0`). -/
def hash (bytes : List UInt8) (seed : UInt32 := 0) : UInt32 :=
  let h := hashAux seed bytes
  fmix (h ^^^ (UInt32.ofNat bytes.length))

/-- Murmur3 32-bit hash (seed `0`) of the UTF-8 encoding of a string. -/
def hashStr (s : String) : UInt32 := hash (s.toUTF8.toList)

end Murmur3

open Murmur3

/-! ## The Sealevel syscall hash table

Each theorem states that the Murmur3-32 hash of the syscall's symbol name
equals the value published in the syscall table. -/

theorem hash_abort : hashStr "abort" = 0xb6fc1a11 := by native_decide
theorem hash_sol_panic_ : hashStr "sol_panic_" = 0x686093bb := by native_decide
theorem hash_sol_log_ : hashStr "sol_log_" = 0x207559bd := by native_decide
theorem hash_sol_log_64_ : hashStr "sol_log_64_" = 0x5c2a3178 := by native_decide
theorem hash_sol_log_compute_units_ :
    hashStr "sol_log_compute_units_" = 0x52ba5096 := by native_decide
theorem hash_sol_log_pubkey : hashStr "sol_log_pubkey" = 0x7ef088ca := by native_decide
theorem hash_sol_create_program_address :
    hashStr "sol_create_program_address" = 0x9377323c := by native_decide
theorem hash_sol_try_find_program_address :
    hashStr "sol_try_find_program_address" = 0x48504a38 := by native_decide
theorem hash_sol_sha256 : hashStr "sol_sha256" = 0x11f49d86 := by native_decide
theorem hash_sol_keccak256 : hashStr "sol_keccak256" = 0xd7793abb := by native_decide
theorem hash_sol_secp256k1_recover :
    hashStr "sol_secp256k1_recover" = 0x17e40350 := by native_decide
theorem hash_sol_blake3 : hashStr "sol_blake3" = 0x174c5122 := by native_decide
theorem hash_sol_curve_validate_point :
    hashStr "sol_curve_validate_point" = 0xaa2607ca := by native_decide
theorem hash_sol_curve_group_op :
    hashStr "sol_curve_group_op" = 0xdd1c41a6 := by native_decide
theorem hash_sol_get_clock_sysvar :
    hashStr "sol_get_clock_sysvar" = 0xd56b5fe9 := by native_decide
theorem hash_sol_get_epoch_schedule_sysvar :
    hashStr "sol_get_epoch_schedule_sysvar" = 0x23a29a61 := by native_decide
theorem hash_sol_get_fees_sysvar :
    hashStr "sol_get_fees_sysvar" = 0x3b97b73c := by native_decide
theorem hash_sol_get_rent_sysvar :
    hashStr "sol_get_rent_sysvar" = 0xbf7188f6 := by native_decide
theorem hash_sol_memcpy_ : hashStr "sol_memcpy_" = 0x717cc4a3 := by native_decide
theorem hash_sol_memmove_ : hashStr "sol_memmove_" = 0x434371f8 := by native_decide
theorem hash_sol_memcmp_ : hashStr "sol_memcmp_" = 0x5fdcde31 := by native_decide
theorem hash_sol_memset_ : hashStr "sol_memset_" = 0x3770fb22 := by native_decide
theorem hash_sol_invoke_signed_c :
    hashStr "sol_invoke_signed_c" = 0xa22b9c85 := by native_decide
theorem hash_sol_invoke_signed_rust :
    hashStr "sol_invoke_signed_rust" = 0xd7449092 := by native_decide
theorem hash_sol_alloc_free_ : hashStr "sol_alloc_free_" = 0x83f00e8f := by native_decide
theorem hash_sol_set_return_data :
    hashStr "sol_set_return_data" = 0xa226d3eb := by native_decide
theorem hash_sol_get_return_data :
    hashStr "sol_get_return_data" = 0x5d2245e4 := by native_decide
theorem hash_sol_log_data : hashStr "sol_log_data" = 0x7317b434 := by native_decide
theorem hash_sol_get_processed_sibling_instruction :
    hashStr "sol_get_processed_sibling_instruction" = 0xadb8efc8 := by native_decide
theorem hash_sol_get_stack_height :
    hashStr "sol_get_stack_height" = 0x85532d94 := by native_decide
