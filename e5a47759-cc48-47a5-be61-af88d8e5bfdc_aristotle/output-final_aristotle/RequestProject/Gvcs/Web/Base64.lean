import Mathlib

/-!
# Base64, and a keystream mask, with their round trips proved

The single-page build of the game (`RequestProject/Web/Standalone.lean`) carries
the WebAssembly module *inside* the HTML file, so that the page is one file and
loads from a `file://` URL with no fetch.  A byte string cannot be written into
an HTML document literally, so it is written as base64; and, so that the module
is not simply lying there in plain sight, the bytes are first masked with the
keystream of a linear congruential generator.

Both steps have to be undone by the JavaScript in the page, and if either is
wrong the browser instantiates something that is not the module the correctness
proofs of `RequestProject/Wasm/` are about.  This file therefore defines both
transformations and proves that they invert:

* `b64Dec_b64Enc` — decoding a base64 encoding of a byte list returns it;
* `maskFrom_maskFrom` — the keystream mask is an involution;
* `recoverBytes_payloadOf` — hence the payload string that goes into the page
  recovers exactly the bytes it was made from.

Everything is done over `List Nat` with an explicit `< 256` hypothesis, which
keeps the arithmetic inside `omega`'s reach, and lifted to `List UInt8` at the
boundary.
-/

namespace LifeTrac
namespace Web

/-! ## The alphabet -/

/-- The standard base64 alphabet, in order. -/
def b64Alphabet : List Char :=
  ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
   'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
   'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
   'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/']

/-- The digit standing for a six-bit group. -/
def b64Char (n : Nat) : Char := b64Alphabet.getD n '='

/-- The six-bit group a digit stands for. -/
def b64Val (c : Char) : Nat := b64Alphabet.idxOf c

theorem b64Val_b64Char {n : Nat} (h : n < 64) : b64Val (b64Char n) = n := by
  interval_cases n <;> decide

/-- The pad character is not a digit, so the decoder can tell padding apart from
data by looking at the character alone. -/
theorem b64Char_ne_pad {n : Nat} (h : n < 64) : b64Char n ≠ '=' := by
  interval_cases n <;> decide

/-! ## Encoding and decoding -/

/-- Base64 of a list of bytes. -/
def b64Enc : List Nat → List Char
  | [] => []
  | [a] => [b64Char (a / 4), b64Char (a % 4 * 16), '=', '=']
  | [a, b] => [b64Char (a / 4), b64Char (a % 4 * 16 + b / 16), b64Char (b % 16 * 4), '=']
  | a :: b :: c :: t =>
      b64Char (a / 4) :: b64Char (a % 4 * 16 + b / 16) :: b64Char (b % 16 * 4 + c / 64) ::
        b64Char (c % 64) :: b64Enc t

/-- The inverse reading.  Padding is recognised by the `'='` characters, which
are not digits, so the three cases do not overlap. -/
def b64Dec : List Char → List Nat
  | x :: y :: '=' :: '=' :: _ => [b64Val x * 4 + b64Val y / 16]
  | x :: y :: z :: '=' :: _ =>
      [b64Val x * 4 + b64Val y / 16, b64Val y % 16 * 16 + b64Val z / 4]
  | x :: y :: z :: w :: t =>
      (b64Val x * 4 + b64Val y / 16) :: (b64Val y % 16 * 16 + b64Val z / 4) ::
        (b64Val z % 4 * 64 + b64Val w) :: b64Dec t
  | _ => []

/-- Reading back a base64 encoding returns the bytes it was made from. -/
theorem b64Dec_b64Enc : ∀ (l : List Nat), (∀ b ∈ l, b < 256) → b64Dec (b64Enc l) = l := by
  intro l
  induction l using b64Enc.induct with
  | case1 => intro _; rfl
  | case2 a =>
      intro h
      have ha : a < 256 := h a (by simp)
      have h1 : a / 4 < 64 := by omega
      have h2 : a % 4 * 16 < 64 := by omega
      simp only [b64Enc, b64Dec]
      rw [b64Val_b64Char h1, b64Val_b64Char h2]
      simp only [List.cons.injEq, and_true]
      omega
  | case3 a b =>
      intro h
      have ha : a < 256 := h a (by simp)
      have hb : b < 256 := h b (by simp)
      have h1 : a / 4 < 64 := by omega
      have h2 : a % 4 * 16 + b / 16 < 64 := by omega
      have h3 : b % 16 * 4 < 64 := by omega
      simp only [b64Enc]
      rw [b64Dec.eq_2 _ _ _ _ (fun hp => b64Char_ne_pad h3 hp),
        b64Val_b64Char h1, b64Val_b64Char h2, b64Val_b64Char h3]
      simp only [List.cons.injEq, and_true]
      omega
  | case4 a b c t ih =>
      intro h
      have ha : a < 256 := h a (by simp)
      have hb : b < 256 := h b (by simp)
      have hc : c < 256 := h c (by simp)
      have h1 : a / 4 < 64 := by omega
      have h2 : a % 4 * 16 + b / 16 < 64 := by omega
      have h3 : b % 16 * 4 + c / 64 < 64 := by omega
      have h4 : c % 64 < 64 := by omega
      have iht : b64Dec (b64Enc t) = t := ih (fun x hx => h x (by simp [hx]))
      simp only [b64Enc]
      rw [b64Dec.eq_3 _ _ _ _ _ (fun hp _ => b64Char_ne_pad h3 hp)
            (fun hp => b64Char_ne_pad h4 hp),
        b64Val_b64Char h1, b64Val_b64Char h2, b64Val_b64Char h3, b64Val_b64Char h4, iht]
      simp only [List.cons.injEq, and_true]
      refine ⟨by omega, by omega, by omega⟩

/-! ## The keystream mask -/

/-- One step of the linear congruential generator whose keystream masks the
module. -/
def lcgNext (s : Nat) : Nat := (1103515245 * s + 12345) % 4294967296

/-- The byte the generator contributes in a given state: bits 16–23, the ones a
truncated multiplier mixes best. -/
def keyByte (s : Nat) : Nat := s / 65536 % 256

/-- Mask a byte list with the keystream started from `s`.  Being a bitwise
exclusive-or against a fixed stream, this is its own inverse. -/
def maskFrom (s : Nat) : List Nat → List Nat
  | [] => []
  | b :: t => (b ^^^ keyByte s) :: maskFrom (lcgNext s) t

theorem keyByte_lt (s : Nat) : keyByte s < 256 := Nat.mod_lt _ (by norm_num)

/-- Masking keeps bytes bytes. -/
theorem maskFrom_lt : ∀ (s : Nat) (l : List Nat), (∀ b ∈ l, b < 256) →
    ∀ b ∈ maskFrom s l, b < 256
  | _, [], _ => by simp [maskFrom]
  | s, a :: t, h => by
      intro b hb
      simp only [maskFrom, List.mem_cons] at hb
      rcases hb with rfl | hb
      · have : (256 : Nat) = 2 ^ 8 := by norm_num
        rw [this] at *
        exact Nat.xor_lt_two_pow (h a (by simp)) (by simpa [this] using keyByte_lt s)
      · exact maskFrom_lt (lcgNext s) t (fun x hx => h x (by simp [hx])) b hb

/-- The mask is an involution. -/
theorem maskFrom_maskFrom : ∀ (s : Nat) (l : List Nat), maskFrom s (maskFrom s l) = l
  | _, [] => rfl
  | s, a :: t => by
      simp [maskFrom, maskFrom_maskFrom (lcgNext s) t]

/-- The mask really does change the bytes: wherever the keystream byte is not
zero, the byte it covers comes out different. -/
theorem maskFrom_head_ne {s b : ℕ} (h : keyByte s ≠ 0) (t : List ℕ) :
    (maskFrom s (b :: t)).head? ≠ some b := by
  simp only [maskFrom, List.head?_cons, ne_eq, Option.some.injEq]
  intro hb
  exact h (by simpa using congrArg (fun x => b ^^^ x) hb)

/-! ## Running them

`b64Enc` and `maskFrom` are written the way the proofs above want to read them,
which is not a way that runs: on the twelve thousand bytes of the module each
would recurse twelve thousand frames deep.  Here are accumulator versions,
proved equal to them and installed as their implementations by `@[csimp]`, so
the extractor evaluates a loop and the proofs keep the readable definitions. -/

/-- Masking, accumulator style. -/
def maskFromGo (s : Nat) : List Nat → List Nat → List Nat
  | [], acc => acc.reverse
  | b :: t, acc => maskFromGo (lcgNext s) t ((b ^^^ keyByte s) :: acc)

theorem maskFromGo_eq : ∀ (s : Nat) (l acc : List Nat),
    maskFromGo s l acc = acc.reverse ++ maskFrom s l
  | _, [], acc => by simp [maskFromGo, maskFrom]
  | s, b :: t, acc => by
      simp [maskFromGo, maskFrom, maskFromGo_eq (lcgNext s) t]

/-- A tail-recursive `maskFrom`. -/
def maskFromTR (s : Nat) (l : List Nat) : List Nat := maskFromGo s l []

@[csimp] theorem maskFrom_eq_maskFromTR : @maskFrom = @maskFromTR := by
  funext s l
  simp [maskFromTR, maskFromGo_eq]

/-- Base64, accumulator style: the accumulator holds the digits so far, in
reverse. -/
def b64EncGo : List Nat → List Char → List Char
  | [], acc => acc.reverse
  | [a], acc => acc.reverse ++ [b64Char (a / 4), b64Char (a % 4 * 16), '=', '=']
  | [a, b], acc =>
      acc.reverse ++ [b64Char (a / 4), b64Char (a % 4 * 16 + b / 16), b64Char (b % 16 * 4), '=']
  | a :: b :: c :: t, acc =>
      b64EncGo t (b64Char (c % 64) :: b64Char (b % 16 * 4 + c / 64) ::
        b64Char (a % 4 * 16 + b / 16) :: b64Char (a / 4) :: acc)

theorem b64EncGo_eq : ∀ (l : List Nat) (acc : List Char),
    b64EncGo l acc = acc.reverse ++ b64Enc l
  | [], acc => by simp [b64EncGo, b64Enc]
  | [_], acc => by simp [b64EncGo, b64Enc]
  | [_, _], acc => by simp [b64EncGo, b64Enc]
  | a :: b :: c :: t, acc => by
      simp [b64EncGo, b64Enc, b64EncGo_eq t]

/-- A tail-recursive `b64Enc`. -/
def b64EncTR (l : List Nat) : List Char := b64EncGo l []

@[csimp] theorem b64Enc_eq_b64EncTR : @b64Enc = @b64EncTR := by
  funext l
  simp [b64EncTR, b64EncGo_eq]

/-! ## The payload -/

/-- The string that goes into the page: the bytes, masked, in base64. -/
def payloadOf (key : Nat) (bs : List UInt8) : String :=
  String.ofList (b64Enc (maskFrom key (bs.map UInt8.toNat)))

/-- What the page's JavaScript does to that string to get the module back. -/
def recoverBytes (key : Nat) (s : String) : List UInt8 :=
  (maskFrom key (b64Dec s.toList)).map (fun n => UInt8.ofNat n)

/-- **The embedding is faithful**: the bytes the page instantiates are exactly
the bytes the extractor put in it. -/
theorem recoverBytes_payloadOf (key : Nat) (bs : List UInt8) :
    recoverBytes key (payloadOf key bs) = bs := by
  have hlt : ∀ b ∈ bs.map UInt8.toNat, b < 256 := by
    intro b hb
    simp only [List.mem_map] at hb
    obtain ⟨x, -, rfl⟩ := hb
    exact x.toNat_lt_size
  have h1 : b64Dec (b64Enc (maskFrom key (bs.map UInt8.toNat)))
      = maskFrom key (bs.map UInt8.toNat) :=
    b64Dec_b64Enc _ (maskFrom_lt key _ hlt)
  unfold recoverBytes payloadOf
  rw [String.toList_ofList, h1, maskFrom_maskFrom]
  simp [Function.comp_def]

end Web
end LifeTrac
