/-
# The deployment kernel as a WebAssembly module

The parts of the deployment tool that both the Lean CLI and the browser
client have to agree on are small integer functions: the content hash the
asset manifest is keyed by, the KV value-size limit, how many upload
batches a bundle needs, whether a minted token has expired.  Disagreement
there means a browser that uploads assets under keys the Worker will never
look up, or a client that believes a dead token is alive.

So they are written once, in the verified wasm fragment of
`RequestProject.Wasm.Syntax`, and `RequestProject.Wasm.Encode` emits them
as an actual `.wasm` binary (`lake exe emitwasm`).  Compiler correctness
for that fragment is `Kant.Wasm.Expr.exec_compile`; what this module adds
is the *specification* of each kernel function — a theorem saying the
expression evaluates to the Lean function of the same name.

Mathlib-free: this is the compute-only core that is extracted.
-/
import RequestProject.Edge.Wasm.Syntax
import RequestProject.Edge.Wasm.Semantics
import RequestProject.Edge.Wasm.Encode

namespace CfDeploy
namespace WasmKernel

open Kant.Wasm
open Kant.Wasm.Expr

/-! ## Constants -/

/-- The FNV-1a 64-bit prime. -/
def fnvPrime : Nat := 1099511628211

/-- The Workers KV value-size limit, 25 MiB. -/
def kvValueLimit : Nat := 25 * 1024 * 1024

/-- The Pages direct-upload batch limit, in files. -/
def uploadBatchFiles : Nat := 1000

/-! ## Lean specifications -/

/-- One FNV-1a round — the step `Bundle.fnv1a64` iterates. -/
def fnvStep (h b : UInt64) : UInt64 := (h ^^^ b) * UInt64.ofNat fnvPrime

/-- Number of KV values a payload of `n` bytes has to be split into. -/
def kvChunks (n : UInt64) : UInt64 := (n + UInt64.ofNat (kvValueLimit - 1)) / UInt64.ofNat kvValueLimit

/-- Does a payload fit in one KV value? -/
def fitsKv (n : UInt64) : UInt64 := if n ≤ UInt64.ofNat kvValueLimit then 1 else 0

/-- Number of upload batches for `n` files. -/
def uploadBatches (n : UInt64) : UInt64 :=
  (n + UInt64.ofNat (uploadBatchFiles - 1)) / UInt64.ofNat uploadBatchFiles

/-- Has a token minted at `iat` with a lifetime of `ttl` seconds expired at
`now`? -/
def tokenExpired (now iat ttl : UInt64) : UInt64 := if iat + ttl ≤ now then 1 else 0

/-- The lowercase hex digit of a nibble. -/
def hexDigit (e : UInt64) : UInt64 := 48 + e + 39 * (if 10 ≤ e then 1 else 0)

/-! ## The kernel expressions -/

def hexDigitOf (e : Expr) : Expr :=
  add (add (const 48) e) (mul (const 39) (cmp .geu e (const 10)))

/-- `hex_hi(b)` — the first hex digit of a byte. -/
def hexHiE : Expr := hexDigitOf (divC (var 0) 16)

/-- `hex_lo(b)` — the second hex digit of a byte. -/
def hexLoE : Expr := hexDigitOf (modC (var 0) 16)

/-- `fnv_offset()` — the FNV-1a offset basis `14695981039346656037`, which
exceeds `2 ^ 63` and so is assembled from two literals. -/
def fnvOffsetE : Expr := add (mul (const 2) (const 7347990519673328018)) (const 1)

/-- `fnv1a_step(h, b)`. -/
def fnvStepE : Expr := mul (Expr.xor (var 0) (var 1)) (const fnvPrime)

/-- `kv_chunks(size)`. -/
def kvChunksE : Expr := divC (add (var 0) (const (kvValueLimit - 1))) kvValueLimit

/-- `fits_kv(size)`. -/
def fitsKvE : Expr := cmp .leu (var 0) (const kvValueLimit)

/-- `upload_batches(files)`. -/
def uploadBatchesE : Expr :=
  divC (add (var 0) (const (uploadBatchFiles - 1))) uploadBatchFiles

/-- `token_expired(now, iat, ttl)`. -/
def tokenExpiredE : Expr := cmp .leu (add (var 1) (var 2)) (var 0)

/-- `ttl_seconds(minutes)`. -/
def ttlSecondsE : Expr := mul (var 0) (const 60)

/-! ## The module -/

/-- The exported deployment kernel. -/
def deployKernel : Module :=
  { funcs :=
      [ { name := "fnv_offset", arity := 0, body := fnvOffsetE },
        { name := "fnv1a_step", arity := 2, body := fnvStepE },
        { name := "hex_hi", arity := 1, body := hexHiE },
        { name := "hex_lo", arity := 1, body := hexLoE },
        { name := "kv_chunks", arity := 1, body := kvChunksE },
        { name := "fits_kv", arity := 1, body := fitsKvE },
        { name := "upload_batches", arity := 1, body := uploadBatchesE },
        { name := "token_expired", arity := 3, body := tokenExpiredE },
        { name := "ttl_seconds", arity := 1, body := ttlSecondsE } ] }

/-- The bytes of `cf_deploy_kernel.wasm`. -/
def kernelBytes : ByteArray := Encode.moduleBytes deployKernel

/-- Every function of the kernel is well formed: no out-of-range local, no
literal a signed 64-bit constant cannot hold, no possible trap. -/
theorem deployKernel_wf : Module.Wf deployKernel :=
  Module.wf_of_wfb (by decide)

/-! ## Specifications

Each theorem says: the wasm expression, run under the semantics of
`RequestProject.Wasm.Semantics`, computes the Lean function above.  With
`Expr.exec_compile` (compiler correctness) this carries over to the
instruction sequence the encoder emits. -/

theorem fnvStepE_spec (h b : UInt64) : Expr.eval [h, b] fnvStepE = some (fnvStep h b) := rfl

theorem kvChunksE_spec (n : UInt64) : Expr.eval [n] kvChunksE = some (kvChunks n) := rfl

theorem fitsKvE_spec (n : UInt64) : Expr.eval [n] fitsKvE = some (fitsKv n) := rfl

theorem uploadBatchesE_spec (n : UInt64) :
    Expr.eval [n] uploadBatchesE = some (uploadBatches n) := rfl

theorem tokenExpiredE_spec (now iat ttl : UInt64) :
    Expr.eval [now, iat, ttl] tokenExpiredE = some (tokenExpired now iat ttl) := rfl

theorem hexHiE_spec (b : UInt64) : Expr.eval [b] hexHiE = some (hexDigit (b / 16)) := rfl

theorem hexLoE_spec (b : UInt64) : Expr.eval [b] hexLoE = some (hexDigit (b % 16)) := rfl

/-- The FNV-1a offset basis, as the kernel computes it. -/
theorem fnvOffsetE_spec : Expr.eval [] fnvOffsetE = some 14695981039346656037 := rfl

end WasmKernel
end CfDeploy
