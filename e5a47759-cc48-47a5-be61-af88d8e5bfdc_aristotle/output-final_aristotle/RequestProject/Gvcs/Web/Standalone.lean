import RequestProject.Gvcs.Web.Html
import RequestProject.Gvcs.Web.Base64
import RequestProject.Gvcs.Web.Fhe
import RequestProject.Gvcs.Wasm.DecodeCorrect

/-!
# The single-page build

`web/lifetrac.html` is the whole game in one file: the shell, the tables, and
the WebAssembly module itself, with nothing to fetch.  Opening the file from
disk is enough to play it.

Getting the module into the file takes three transformations, and each of them
has to be undone exactly by the JavaScript in the page:

1. the bytes are masked with the keystream of a linear congruential generator
   (`RequestProject/Web/Base64.lean`), so the module is not sitting in the file
   in plain sight;
2. the masked bytes are written as base64, because a byte string cannot be put
   into an HTML document literally;
3. the *seed* of that keystream is not written into the file either.  Two
   ciphertexts are, under the somewhat-homomorphic bit cipher of
   `RequestProject/Web/Fhe.lean`; the page recovers the seed by running a
   ripple-carry adder **on the ciphertexts** and decrypting the sixteen output
   bits.  Nothing in the page holds the seed, and no part of the loading path
   can be skipped: get the homomorphic evaluation wrong and the keystream is
   wrong, the bytes are wrong, and `WebAssembly.instantiate` refuses them.

`standalone_page_runs_gameMod` is the statement that all three undo each other:
the bytes the page ends up handing to the browser are the bytes of `gameMod`,
the module every correctness theorem in `RequestProject/Wasm/` is about, and
they parse back to it.

*What this is and is not.*  It is obfuscation with a proof of correctness, not
secrecy: the page must be able to decrypt, so it carries the modulus, and a
reader with this file can run the same three steps.  What is bought is that the
module is not extractable by inspection, and — the part that is actually
verified — that the recovery is right.
-/

namespace LifeTrac
namespace Web

open Wasm

/-! ## The keystream seed, delivered under encryption -/

/-- The secret modulus of the bit cipher: the Mersenne prime `2⁸⁹ - 1`. -/
def heP : ℤ := 2 ^ 89 - 1

/-- The bound on the encryption noise. -/
def heR : ℤ := 7

/-- The low half of the keystream seed. -/
def seedLo : ℤ := 51237

/-- The high half. -/
def seedHi : ℤ := 39628

/-- Deterministic noise for the encryptions: the low three bits of a generator
give the noise `r`, and a scrambled copy of the state gives the multiple `q` of
the modulus that hides it. -/
def noiseStream (s : ℕ) : ℕ → List (ℤ × ℤ)
  | 0 => []
  | n + 1 => (((s % 8 : ℕ) : ℤ), (((s * 2654435761 + 7) % 1099511627776 : ℕ) : ℤ)) ::
      noiseStream (lcgNext s) n

theorem noiseStream_bounds : ∀ (s n : ℕ), ∀ z ∈ noiseStream s n, 0 ≤ z.1 ∧ z.1 ≤ heR
  | _, 0 => by simp [noiseStream]
  | s, n + 1 => by
      intro z hz
      simp only [noiseStream, List.mem_cons] at hz
      rcases hz with rfl | hz
      · refine ⟨by positivity, ?_⟩
        have : s % 8 < 8 := Nat.mod_lt _ (by norm_num)
        simp only [heR]
        omega
      · exact noiseStream_bounds (lcgNext s) n z hz

/-- The encryption of the low half of the seed, bit by bit. -/
def ctLo : List ℤ := encBits heP (bitsOf seedLo 16) (noiseStream 20250831 16)

/-- The encryption of the high half. -/
def ctHi : List ℤ := encBits heP (bitsOf seedHi 16) (noiseStream 91125511 16)

/-- **The seed, as the page obtains it**: add the two encrypted halves with the
ripple-carry circuit — on the ciphertexts — decrypt the outputs, and read them
as a binary numeral. -/
def heKey : ℤ := valBits ((addBits ctLo ctHi 0).map (decBit heP))

/-- The homomorphic evaluation is correct: the page's seed is the sum of the two
halves that were encrypted. -/
theorem heKey_eq : heKey = seedLo + seedHi := by
  refine he_add_correct (R := heR) (n := 16) (by norm_num [heR])
    (by norm_num [seedLo]) (by norm_num [seedLo]) (by norm_num [seedHi])
    (by norm_num [seedHi]) (noiseStream_bounds _ _) (noiseStream_bounds _ _) ?_
  norm_num [sumBound, carryBoundN, carryBound, heR, heP]

/-- The seed as the mask wants it. -/
def standaloneKey : ℕ := heKey.toNat

theorem standaloneKey_eq : standaloneKey = 90865 := by
  simp [standaloneKey, heKey_eq, seedLo, seedHi]

/-- The masking is not a no-op: this seed's first keystream byte is `1`, so the
first byte of the payload is not the first byte of the module.  (The page's
module begins `00 61 73 6D`, the WebAssembly magic; the payload does not.) -/
theorem standalone_masks_first_byte (b : ℕ) (t : List ℕ) :
    (maskFrom standaloneKey (b :: t)).head? ≠ some b :=
  maskFrom_head_ne (by rw [standaloneKey_eq]; decide) t

/-! ## The payload -/

/-- The module, masked with the keystream of `standaloneKey` and written in
base64: the string the page carries. -/
def standalonePayload : String := payloadOf standaloneKey (encodeMod gameMod)

/-- **The single page runs the verified module.**  The seed the page computes
homomorphically is the intended one; unmasking the payload with it returns
exactly the bytes of `gameMod`; and those bytes parse back to `gameMod` — one
page of memory, its data segment, and its six entry points. -/
theorem standalone_page_runs_gameMod :
    heKey = seedLo + seedHi ∧
    recoverBytes heKey.toNat standalonePayload = encodeMod gameMod ∧
    decodeMod (modFuel gameMod) (recoverBytes heKey.toNat standalonePayload) =
      some ⟨gameMod.memPages, imageBytes gameMod.image, gameMod.funcs.map (fun f =>
        (⟨f.name.toUTF8.toList, f.params, f.locals, f.returns, f.body⟩ : DecFunc))⟩ := by
  have hbytes : recoverBytes heKey.toNat standalonePayload = encodeMod gameMod :=
    recoverBytes_payloadOf _ _
  exact ⟨heKey_eq, hbytes, by rw [hbytes]; exact decodeMod_encodeMod_gameMod⟩

/-! ## The page -/

/-- A list of integers as a JavaScript array of `BigInt` literals. -/
def bigIntArrayJs (l : List ℤ) : String :=
  "[" ++ String.intercalate ", " (l.map (fun c => toString c ++ "n")) ++ "]"

/-- The loader: the ciphertexts, the homomorphic adder, the decryption, the
keystream, and the instantiation. -/
def standaloneLoaderJs : String :=
  "\n// ---- the module, sealed ----\n" ++
  "const HE_P = " ++ toString heP ++ "n;\n" ++
  "const CT_LO = " ++ bigIntArrayJs ctLo ++ ";\n" ++
  "const CT_HI = " ++ bigIntArrayJs ctHi ++ ";\n" ++
  "const PAYLOAD = \"" ++ standalonePayload ++ "\";\n" ++
  r####"
// A ripple-carry adder, evaluated on ciphertext: `+` is exclusive-or of the
// encrypted bits and `*` is conjunction, so the circuit below is the same
// expression tree the Lean development proves correct (addBits_rep,
// addBits_val, he_add_correct in RequestProject/Web/Fhe.lean).
function heAddBits(cs, ds, cin) {
  const out = [];
  let carry = cin;
  const n = Math.min(cs.length, ds.length);
  for (let i = 0; i < n; i++) {
    const c = cs[i], d = ds[i];
    out.push(c + d + carry);
    carry = c * d + (c + d) * carry;
  }
  out.push(carry);
  return out;
}

// Decryption: reduce modulo the secret modulus, then modulo two.
function heDec(c) { return (((c % HE_P) + HE_P) % HE_P) % 2n; }

// The keystream seed: never written down, always recomputed.
function heSeed() {
  const bits = heAddBits(CT_LO, CT_HI, 0n).map(heDec);
  let v = 0n;
  for (let i = bits.length - 1; i >= 0; i--) v = v * 2n + bits[i];
  return v;
}

// Undo the mask and the base64: the bytes of the module.
function moduleBytes(seed) {
  const raw = atob(PAYLOAD);
  const out = new Uint8Array(raw.length);
  let s = seed;
  for (let i = 0; i < raw.length; i++) {
    out[i] = raw.charCodeAt(i) ^ Number((s / 65536n) % 256n);
    s = (1103515245n * s + 12345n) % 4294967296n;
  }
  return out;
}

function heNote(seed, n) {
  const d = document.createElement("div");
  d.className = "note";
  d.textContent = "One file: the rule book travelled in " + PAYLOAD.length +
    " characters of base64, masked with the keystream of seed " + seed +
    ", and that seed is not in this file either — the page added two " +
    "ciphertexts with a homomorphic adder and decrypted the " + n +
    " output bits to get it.";
  document.getElementById("wrap").appendChild(d);
}

(function () {
  const seed = heSeed();
  const bytes = moduleBytes(seed);
  WebAssembly.instantiate(bytes.buffer).then(function (res) {
    start(res);
    heNote(seed.toString(), CT_LO.length + 1);
  });
})();
"####

/-- The whole single-page build. -/
def standaloneHtml : String :=
  htmlHead ++ materialsJs ++ partsJs ++ cropsJs ++ layoutJs ++ htmlDraw ++
    standaloneLoaderJs ++ htmlStart

end Web
end LifeTrac
