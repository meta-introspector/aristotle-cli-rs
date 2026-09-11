/-
# Reading a tar archive

The second half of "read the `.tar.gz`": once `Inflate.gunzip` has given
back the tar stream, this module walks the 512-byte headers of the POSIX
ustar format and returns the regular files it contains, with their paths
and contents.

GNU long names (`typeflag = 'L'`) and the `prefix` field are both handled,
because Aristotle bundles nest paths several directories deep.  Anything
that is not a regular file — directories, links, pax headers — is skipped
rather than guessed at.

The octal field parser comes with a round-trip proof against the octal
*writer*, which is the property that says the sizes the tool believes are
the sizes the archive states.
-/

namespace CfDeploy
namespace Tar

/-- One archive member. -/
structure Entry where
  path : String
  contents : ByteArray
  /-- the mode bits, as recorded in the header -/
  mode : Nat
  deriving Inhabited

/-! ## Octal header fields -/

/-- Decimal value of an ASCII octal digit; other bytes contribute nothing
(tar pads its fields with spaces and NULs). -/
def digitVal (b : UInt8) : Option Nat :=
  if 48 ≤ b.toNat && b.toNat ≤ 55 then some (b.toNat - 48) else none

/-- Parse a list of bytes as an octal number, ignoring padding. -/
def parseOctList (bs : List UInt8) : Nat :=
  bs.foldl (fun v b => match digitVal b with | some d => v * 8 + d | none => v) 0

/-- `len` octal digits of `n`, most significant first. -/
def octDigits : Nat → Nat → List UInt8
  | 0, _ => []
  | len + 1, n => octDigits len (n / 8) ++ [UInt8.ofNat (48 + n % 8)]

theorem digitVal_ofNat {d : Nat} (h : d < 8) :
    digitVal (UInt8.ofNat (48 + d)) = some d := by
  simp [digitVal, UInt8.toNat_ofNat, Nat.mod_eq_of_lt (show 48 + d < 256 by omega)]
  omega

theorem parseOctList_append_digit (bs : List UInt8) {d : Nat} (h : d < 8) :
    parseOctList (bs ++ [UInt8.ofNat (48 + d)]) = parseOctList bs * 8 + d := by
  unfold parseOctList
  rw [List.foldl_append, List.foldl_cons, List.foldl_nil, digitVal_ofNat h]

/-- **The octal codec round-trips.**  A size written into a tar header
field is the size read back out of it. -/
theorem parseOctList_octDigits : ∀ (len n : Nat), n < 8 ^ len →
    parseOctList (octDigits len n) = n
  | 0, n, h => by
      simp at h
      simp [octDigits, parseOctList, h]
  | len + 1, n, h => by
      have hdiv : n / 8 < 8 ^ len := by
        have hp : 8 ^ (len + 1) = 8 ^ len * 8 := Nat.pow_succ 8 len
        omega
      rw [octDigits, parseOctList_append_digit _ (Nat.mod_lt _ (by omega)),
        parseOctList_octDigits len (n / 8) hdiv]
      omega

/-- Parse an octal header field. -/
def parseOctal (data : ByteArray) (off len : Nat) : Nat :=
  parseOctList ((List.range len).map (fun i => data[off + i]!))

/-- Write a number into a tar octal field of `len` bytes: `len - 1` octal
digits and a NUL terminator. -/
def writeOctal (n len : Nat) : ByteArray :=
  ⟨(octDigits (len - 1) n ++ [0]).toArray⟩

/-! ## Header fields -/

/-- Read a NUL-terminated string field. -/
def readStr (data : ByteArray) (off len : Nat) : String := Id.run do
  let mut cs : List Char := []
  let mut stop := false
  for i in [0:len] do
    if !stop then
      let b := data[off + i]!
      if b == 0 then
        stop := true
      else
        cs := Char.ofNat b.toNat :: cs
  return String.ofList cs.reverse

/-- Is this header block all zeroes (the end-of-archive marker)? -/
def isZeroBlock (data : ByteArray) (off : Nat) : Bool := Id.run do
  let mut z := true
  for i in [0:512] do
    if data[off + i]! != 0 then
      z := false
  return z

/-- The entries of a tar archive, in order. -/
def entries (data : ByteArray) : List Entry := Id.run do
  let mut out : Array Entry := #[]
  let mut off := 0
  let mut longName : Option String := none
  for _ in [0:data.size / 512 + 1] do
    if off + 512 ≤ data.size && !isZeroBlock data off then
      let name := readStr data off 100
      let prefix' := readStr data (off + 345) 155
      let size := parseOctal data (off + 124) 12
      let mode := parseOctal data (off + 100) 8
      let typeflag := data[off + 156]!
      let dataOff := off + 512
      let padded := (size + 511) / 512 * 512
      if typeflag == 76 then
        -- 'L': the next header's name is stored in this member's data
        let raw := data.extract dataOff (dataOff + size)
        longName := some (readStr raw 0 size)
        off := dataOff + padded
      else
        let fullName :=
          match longName with
          | some n => n
          | none => if prefix'.isEmpty then name else prefix' ++ "/" ++ name
        longName := none
        if typeflag == 48 || typeflag == 0 then
          -- '0' or NUL: a regular file
          out := out.push
            { path := fullName, contents := data.extract dataOff (dataOff + size), mode := mode }
        off := dataOff + padded
  return out.toList

end Tar
end CfDeploy
