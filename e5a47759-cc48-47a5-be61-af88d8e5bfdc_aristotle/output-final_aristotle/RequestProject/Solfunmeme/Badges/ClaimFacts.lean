/-
  ClaimFacts.lean — the 100 badge pages, checked against the dataset.

  `RequestProject/Badges/Data/Claims.lean` is the table the HTML pages in
  `badges/` are generated from.  This file recomputes that table from the 52
  snapshots of `RequestProject/Badges/Data/Snapshots.lean` and proves the two
  are the same object (`claims_eq_pages`), so every figure a badge page prints
  — the "senator since" date, the rank, the token-day bracket, the genesis mark
  — is what the dataset yields and not what a generator felt like writing.

  It also proves the facts the claim protocol of `Claim.lean` needs of the real
  table: the addresses are pairwise distinct 32-byte Ed25519 keys that contain
  no field separator, and the 100 challenge prefixes are pairwise distinct, so
  no signed badge can be moved from one page to another.

  Everything here is decided by the kernel; nothing is `native_decide`.
-/

import RequestProject.Solfunmeme.Badges.Data.Claims
import RequestProject.Solfunmeme.Badges.SnapshotFacts

namespace Badges.Claim

open Badges.Snapshot

set_option maxHeartbeats 4000000
set_option maxRecDepth 1000000

/-! ### Recomputing the table from the snapshots -/

/-- Days since the epoch to a proleptic-Gregorian date, by Howard Hinnant's
`civil_from_days`. -/
def civilFromDays (days : Nat) : Nat × Nat × Nat :=
  let z := days + 719468
  let era := z / 146097
  let doe := z % 146097
  let yoe := (doe - doe / 1460 + doe / 36524 - doe / 146096) / 365
  let y := yoe + era * 400
  let doy := doe - (365 * yoe + yoe / 4 - yoe / 100)
  let mp := (5 * doy + 2) / 153
  let d := doy - (153 * mp + 2) / 5 + 1
  let m := if mp < 10 then mp + 3 else mp - 9
  (if m ≤ 2 then y + 1 else y, m, d)

def pad2 (n : Nat) : String := if n < 10 then "0" ++ toString n else toString n

/-- A Unix time as the UTC calendar date `YYYY-MM-DD` printed on the badge. -/
def dateOfUnix (t : Nat) : String :=
  let (y, m, d) := civilFromDays (t / 86400)
  toString y ++ "-" ++ pad2 m ++ "-" ++ pad2 d

/-- The first snapshot of the unbroken run of Senate-tier standing that reaches
the last snapshot: one past the last snapshot at which the address was below
the cutoff, or 0 if it never was. -/
def runStart (bs : List Nat) : Nat :=
  ((List.range times.length).filter (fun i => bs[i]! < cutoffs[i]!)).foldl
    (fun _ i => i + 1) 0

/-- The badge page of the `i`-th row of the last snapshot's Senate tier. -/
def pageOf (i : Nat) (r : String × List Nat) : ClaimPage :=
  let bs := r.2
  let s := runStart bs
  { address := r.1
    rank := i + 1
    finalBalance := bs.getLast!
    sinceIndex := s
    sinceTime := times[s]!
    sinceDate := dateOfUnix times[s]!
    tokenDaysLower := toTokenDays (tokenSecondsLower bs)
    tokenDaysUpper := toTokenDays (tokenSecondsUpper bs)
    genesis := s == 0 }

/-- The 100 badge pages, computed from the snapshot table. -/
def pages : List ClaimPage := senate.zipIdx.map (fun r => pageOf r.2 r.1)

/-- **The published table is the computed one.**  The HTML badge pages carry
exactly the figures the dataset's 52 snapshots yield. -/
theorem claims_eq_pages : claims = pages := by rfl

theorem claims_length : claims.length = 100 := by rfl

/-! ### The dates are the dates -/

/-- Sanity checks on the calendar code: the epoch, a leap day, and the first
and last snapshots of the record. -/
theorem date_epoch : dateOfUnix 0 = "1970-01-01" := by rfl
theorem date_leap : dateOfUnix 1709164800 = "2024-02-29" := by rfl
theorem date_first_snapshot : dateOfUnix 1736974661 = "2025-01-15" := by rfl
theorem date_last_snapshot : dateOfUnix 1745833745 = "2025-04-28" := by rfl

/-- Every "senator since" date printed on a badge is the UTC date of the
snapshot it names. -/
theorem dates_agree :
    claims.all (fun p => dateOfUnix p.sinceTime == p.sinceDate) = true := by rfl

/-- And that snapshot is the one the index names. -/
theorem sinceTime_is_snapshot_time :
    claims.all (fun p => times[p.sinceIndex]! == p.sinceTime) = true := by rfl

/-! ### The seniority claim is backed by the data -/

/-- **"Senator since X" is true in the record.**  From the snapshot it names to
the end of the record, every badge's address held a balance at or above that
snapshot's Senate cutoff — the 100th-largest balance of the moment. -/
theorem since_backed :
    (claims.zip senate).all (fun pr =>
      (pr.1.address == pr.2.1) &&
        (List.range times.length).all (fun i =>
          decide (i < pr.1.sinceIndex) || decide (cutoffs[i]! ≤ pr.2.2[i]!))) = true := by
  decide +kernel

/-- **And it is the earliest such date.**  A badge that does not claim the
whole record claims the most it can: at the snapshot before the one it names,
its address was below the Senate cutoff. -/
theorem since_maximal :
    (claims.zip senate).all (fun pr =>
      (pr.1.sinceIndex == 0) ||
        decide (pr.2.2[pr.1.sinceIndex - 1]! < cutoffs[pr.1.sinceIndex - 1]!)) = true := by
  decide +kernel

/-! ### The genesis mark -/

/-- The genesis mark means, and only means, standing at every one of the 52
snapshots. -/
theorem genesis_iff_since_zero :
    claims.all (fun p => p.genesis == (p.sinceIndex == 0)) = true := by rfl

/-- **39 of the 100 pages carry the genesis mark** — the same 39 the snapshot
analysis found, no more. -/
theorem genesis_badge_count : (claims.filter (fun p => p.genesis)).length = 39 := by rfl

theorem genesis_badges_match_snapshots :
    (claims.filter (fun p => p.genesis)).length = genesisSenate.length := by rfl

/-- The other 61 pages date their seniority inside the window. -/
theorem non_genesis_count : (claims.filter (fun p => !p.genesis)).length = 61 := by rfl

/-! ### The standing printed on a badge -/

/-- The bracket is a bracket: the "at least" figure never exceeds the "at most"
figure. -/
theorem standing_bracket :
    claims.all (fun p => decide (p.tokenDaysLower ≤ p.tokenDaysUpper)) = true := by rfl

/-- A genesis badge's two figures coincide: with standing at every snapshot
there is no gap in the record to charge either way. -/
theorem genesis_standing_exact :
    claims.all (fun p => !p.genesis || (p.tokenDaysLower == p.tokenDaysUpper)) = true := by rfl

/-- Every page sits in the Senate tier of the proposal's rank map. -/
theorem all_pages_are_senate :
    claims.all (fun p => decide (tierOfRank p.rank = Tier.senate)) = true := by rfl

/-- The leading page, in full. -/
theorem leader_page :
    claims.head! =
      { address := "AtTjQKXo1CYTa2MuxPARtr382ZyhPU5YX4wMMpvaa1oy", rank := 1,
        finalBalance := 89484824995506, sinceIndex := 0, sinceTime := 1736974661,
        sinceDate := "2025-01-15", tokenDaysLower := 8787467393,
        tokenDaysUpper := 8787467393, genesis := true } := by rfl

/-- The statement that page mints, in full. -/
theorem leader_statement :
    statement claims.head! =
      "I am a senator of SOLFUNMEME since 2025-01-15 (snapshot 0, unix 1736974661), " ++
        "rank #1, with a standing of at least 8787467393 and at most 8787467393 " ++
        "token-days, a Genesis Senator." := by rfl

/-! ### The addresses are usable keys, and the pages are separated -/

def b58Alphabet : String := "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

/-- The number a base58 string denotes, or `none` if it is not base58. -/
def b58Num (s : String) : Option Nat :=
  s.toList.foldl
    (fun acc c =>
      match acc, b58Alphabet.toList.idxOf? c with
      | some v, some d => some (v * 58 + d)
      | _, _ => none)
    (some 0)

/-- **Every page is about a real key.**  Each address is base58 and decodes to
exactly 32 bytes with a non-zero leading byte — the shape of an Ed25519 public
key, which is what the in-page verifier needs. -/
theorem addresses_are_32_byte_keys :
    claims.all (fun p =>
      match b58Num p.address with
      | some v => decide (2 ^ 248 ≤ v ∧ v < 2 ^ 256)
      | none => false) = true := by
  decide +kernel

/-- No address contains the field separator, so the challenge really is the
concatenation of four distinguishable fields. -/
theorem addresses_have_no_separator :
    claims.all (fun p => !p.address.toList.contains '|') = true := by rfl

/-- The 100 pages are 100 different addresses. -/
theorem addresses_nodup : (claims.map (fun p => p.address)).Nodup := by
  decide +kernel

/-- Hence the pages themselves are pairwise distinct. -/
theorem claims_nodup : claims.Nodup := addresses_nodup.of_map _

/-- **No badge can be moved between pages.**  The 100 challenge prefixes are
pairwise distinct, so by `challenge_ne_of_prefix_ne` no two pages ever present
the same challenge, and a signature made for one page cannot unlock another. -/
theorem challengePrefixes_nodup : (claims.map challengePrefix).Nodup := by
  decide +kernel

/-- Spelt out: distinct pages of the table, with nonces of the same length —
the page always draws 32 random bytes — never share a challenge. -/
theorem distinct_pages_distinct_challenges {p q : ClaimPage} (hp : p ∈ claims)
    (hq : q ∈ claims) (hne : p ≠ q) {n m : String} (hlen : n.length = m.length) :
    challenge p n ≠ challenge q m := by
  refine challenge_ne_of_prefix_ne ?_ hlen
  have h := (List.nodup_map_iff_inj_on claims_nodup).mp challengePrefixes_nodup
  exact fun hpre => hne (h p hp q hq hpre)

end Badges.Claim
