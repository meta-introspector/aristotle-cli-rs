import RequestProject.MonsterWalk

/-!
# The Monster order as fixed-point rational quotients in every base `2 … 72`

This module formalizes the follow-up idea:

> *View `|𝕄|` as a fixed-point number — drop a radix point into its digit string, e.g.
> `8.08017424…` or the segmented forms `[8, 0.8, 0.17424…, …]` — and express the pieces as
> exact rational quotients. Repeat this for every base `2 … 72`.*

## The construction

Fix a base `B ≥ 2`. The Monster order has a base-`B` digit string of length
`L = (Nat.digits B |𝕄|).length`. Placing the radix point **after the first digit**
turns the whole number into the fixed-point value

`fixedPointQuotient B = |𝕄| / B ^ (L − 1)  ∈  ℚ`,

i.e. `d₀.d₁d₂…`. This is an *exact rational quotient*. Reducing to lowest terms gives the
`(numerator, denominator)` pairs tabulated in `baseTable` for every base `2 … 72`:

* `fixedPointQuotient_eq_table` — for each base, `fixedPointQuotient B` equals the listed
  reduced fraction `num / den`;
* `baseTable_reduced` — every listed fraction is already in lowest terms (`gcd = 1`);
* `baseTable_bases` — the table covers exactly the bases `2, 3, …, 72`.

## The general principle

Any contiguous block of base-`B` digits, read with a radix point after `intLen` of them, is
a rational quotient `numerator / B ^ (fractional length)`:

* `fpReading` — the value of such a reading;
* `fpReading_is_quotient` — it is always a quotient of two naturals with positive
  denominator;
* `fixedPointQuotient_eq_reading` — the whole-number fixed point is the reading of the full
  base-`B` digit string with radix after the first digit.

## The two segmented decimal views from the request

The two suggested segmentations of the decimal digit string,

`[8, 0.8, 0.174247945128758864599, 0.496171, 0.757, 0.05754368, 0.00000000]`  and
`[8.0, 8.017424794512875886459, 9.049617, 1.075, 7.00575436, 8.000000000]`,

are recorded as `exampleSeg₁` / `exampleSeg₂` (lists of big-endian digit blocks). We prove:

* `exampleSeg₁_reconstructs` / `exampleSeg₂_reconstructs` — concatenating the blocks gives
  back the base-`10` digit string of `|𝕄|` exactly;
* `exampleSeg₁_values` / `exampleSeg₂_values` — reading each block as a fixed point with the
  radix after the first digit yields exactly the listed rationals;
* `exampleSeg_are_quotients` — every segment value is a rational quotient.

All computational claims are checked by the kernel-backed `decide` / `native_decide`.
-/

namespace MonsterBaseQuotients

open MonsterWalk

/-! ## The fixed-point quotient of `|𝕄|` in a base -/

/-- The number of base-`B` digits of the Monster order. -/
def digitLen (B : ℕ) : ℕ := (Nat.digits B monsterOrder).length

/-- The fixed-point value of `|𝕄|` in base `B` with the radix point after the first
digit: `d₀.d₁d₂… = |𝕄| / B ^ (L − 1)`, where `L` is the number of base-`B` digits. -/
def fixedPointQuotient (B : ℕ) : ℚ := (monsterOrder : ℚ) / (B : ℚ) ^ (digitLen B - 1)

/-- A natural-number cross-multiplication criterion for equality of rational quotients. -/
theorem div_eq_div_of_cross {a b c d : ℕ} (hb : 0 < b) (hd : 0 < d)
    (h : a * d = c * b) : (a : ℚ) / (b : ℚ) = (c : ℚ) / (d : ℚ) := by
  rw [div_eq_div_iff (by exact_mod_cast hb.ne') (by exact_mod_cast hd.ne')]
  exact_mod_cast h

/-! ## Reading any digit block as a quotient -/

/-- Read a list of base-`B` digits `ds` (most-significant first) as a fixed-point number,
with the radix point placed after the first `intLen` digits. The value is
`(integer value of the digits) / B ^ (number of fractional digits)`. -/
def fpReading (B : ℕ) (ds : List ℕ) (intLen : ℕ) : ℚ :=
  ((Nat.ofDigits B ds.reverse : ℕ) : ℚ) / (B : ℚ) ^ (ds.length - intLen)

/-- **Every fixed-point reading is a rational quotient.** For any base `B > 0`, digit block
`ds`, and integer-part length `intLen`, the value `fpReading B ds intLen` is an exact
quotient `n / d` of two naturals with positive denominator (a power of the base). -/
theorem fpReading_is_quotient (B : ℕ) (hB : 0 < B) (ds : List ℕ) (intLen : ℕ) :
    ∃ n d : ℕ, 0 < d ∧ fpReading B ds intLen = (n : ℚ) / (d : ℚ) :=
  ⟨Nat.ofDigits B ds.reverse, B ^ (ds.length - intLen), pow_pos hB _, by
    simp [fpReading]⟩

/-- The whole-number fixed-point quotient is the reading of the full base-`B` digit string
of `|𝕄|` (most-significant first) with the radix point after the first digit. -/
theorem fixedPointQuotient_eq_reading (B : ℕ) :
    fixedPointQuotient B = fpReading B (Nat.digits B monsterOrder).reverse 1 := by
  unfold fixedPointQuotient fpReading digitLen
  simp [List.reverse_reverse, Nat.ofDigits_digits, List.length_reverse]

/-! ## The reduced-fraction table for bases `2 … 72`

Each row is `(B, numerator, denominator)` of the reduced fraction equal to
`fixedPointQuotient B = |𝕄| / B ^ (L − 1)`. -/

/-- `(base, numerator, denominator)` of `fixedPointQuotient B` in lowest terms, for every
base `B = 2 … 72`. -/
def baseTable : List (ℕ × ℕ × ℕ) :=
  [(2, 11482618231106483731969943632999939453125, 10889035741470030830827987437816582766592),
   (3, 231737134238290082302814542435975168000000000, 78551672112789411833022577315290546060373041),
   (4, 11482618231106483731969943632999939453125, 5444517870735015415413993718908291383296),
   (5, 413704921494790592453867471340395907586946236416, 338813178901720135627329000271856784820556640625),
   (6, 3293182746777604312211658203125, 2007388267578592053659606974464),
   (7, 6868034788179354485685895374900855570432000000000, 1481113296616977741464105532513750734030421355207),
   (8, 11482618231106483731969943632999939453125, 2722258935367507707706996859454145691648),
   (9, 231737134238290082302814542435975168000000000, 78551672112789411833022577315290546060373041),
   (10, 5879100534326519670768611140095969, 727595761418342590332031250000000),
   (11, 6677829956979445255259999214559593033105408000000000, 1067189571633593786424240872639621090354383081702091),
   (12, 3293182746777604312211658203125, 309083741926783601990820691968),
   (13, 367782168773105542051187940355808264454144000000000, 134106816713249934153658112422086110743809315028093),
   (14, 97600644553769974517164987658203125, 89135280652726391800380091949136014),
   (15, 118649412730004522139041045727219286016, 12329672018575365655124187469482421875),
   (16, 11482618231106483731969943632999939453125, 1361129467683753853853498429727072845824),
   (17, 47530436752618404463909406174218279823867904000000000, 4773695331839566234818968439734627784374274207965089),
   (18, 52690923948441668995386531250000, 3433683820292512484657849089281),
   (19, 42527232883921730309813679208511092473987072000000000, 26847115986241183138017674520015691090350184323352819),
   (20, 5879100534326519670768611140095969, 1600000000000000000000000000000000),
   (21, 1969733140428648626871580229632000000000, 188694158142734186952338621346543616449),
   (22, 6073450965213346767322945392661125000000, 3740434344477351388916475705363381856681),
   (23, 35131192382370125038541734998335250304598016000000000, 5567468501746134532846058029734065138452687762629169),
   (24, 3293182746777604312211658203125, 2744312298045852107919920726016),
   (25, 413704921494790592453867471340395907586946236416, 67762635780344027125465800054371356964111328125),
   (26, 1337983735622785541822624292238500000000, 972786042517719014174576083150881262357),
   (27, 231737134238290082302814542435975168000000000, 26183890704263137277674192438430182020124347),
   (28, 97600644553769974517164987658203125, 42352506622098041988396815176695808),
   (29, 27862669820500443996084824309024508862267392000000000, 1527319604909066255442244538517804134059453082180549),
   (30, 1726576195942536609640825856, 320723064243793487548828125),
   (31, 26065078219177834706014835643926153451798528000000000, 15763740762379653595732059660839887422817189186451551),
   (32, 11482618231106483731969943632999939453125, 680564733841876926926749214863536422912),
   (33, 1915182927589174233907558201950208000000000, 333255580831609109449077252944834663969817),
   (34, 1383317772782710510769084974140228000000000, 684326450885775034048946719925754910487329),
   (35, 3516433811547829496671178431949238052061184, 137086670561057317548036873340606689453125),
   (36, 3293182746777604312211658203125, 334564711263098675609934495744),
   (37, 808017424794512875886459904961710757005754368000000000, 208381240119593773598371865160915107617069000520604889),
   (38, 2475410751295376703481520480040408000000000, 1580770532156861979997149793605296459437459),
   (39, 105478895875416514475564197740544000000000, 4177119314570911199068801902048685180827),
   (40, 5879100534326519670768611140095969, 536870912000000000000000000000000),
   (41, 19707742068158850631377070852724652609896448000000000, 4065214023175683899921868126254722311886802750234881),
   (42, 229307117456180116496000000000, 104766730700517064114916614389),
   (43, 808017424794512875886459904961710757005754368000000000, 802525857116673306810957202573831816754829436253827243),
   (44, 94897671331458543239421021760330078125, 4574256108374958360116279051236409344),
   (45, 118649412730004522139041045727219286016, 11739383961959019099247455596923828125),
   (46, 8179618134715157802808502455785696000000000, 1635170022196481349560959748587682926364327),
   (47, 17191860102010912252903402233227888446930944000000000, 6839645551362303414388150265494367657880760229559503),
   (48, 3293182746777604312211658203125, 2569890986007272572940099518464),
   (49, 6868034788179354485685895374900855570432000000000, 211587613802425391637729361787678676290060193601),
   (50, 192646366308811396571745849838664712192, 11102230246251565404236316680908203125),
   (51, 13631596131664122488400855437410304000000000, 1451447872930908274046871620247455192443803),
   (52, 5226498967276506022744626141556640625, 1016000204155282798363904252675424256),
   (53, 808017424794512875886459904961710757005754368000000000, 283499278281258657725525680568509306972713148562602397),
   (54, 107911012246408538102551616000000000, 67585198634817523235520443624317923),
   (55, 3419048937973475970693119597854511632949968896, 68764656117677323359334976234912872314453125),
   (56, 97600644553769974517164987658203125, 3370332665065233120494708448034816),
   (57, 12196691275699478015937607496630272000000000, 716253858958498960695910084810576581159771),
   (58, 25949133392889466133047662963182208000000000, 2567686153161211134561828214731016126483469),
   (59, 13695210589737506370956947541723911135690752000000000, 2263123934140265506778412097585867652047852542844139),
   (60, 1686109566350133407852369, 461320312500000000000000),
   (61, 808017424794512875886459904961710757005754368000000000, 362990325539372200679554918670984996723331903112927801),
   (62, 24274995754638532834141362126847872000000000, 17761887753093897979823770061456102763834271),
   (63, 1969733140428648626871580229632000000000, 36971119354906439206589160249709810527),
   (64, 11482618231106483731969943632999939453125, 340282366920938463463374607431768211456),
   (65, 188304470411830037530208225462173831400521728, 8748372096373426118698083496952056884765625),
   (66, 3567306189963918614960384000000000, 258044015671293129414870724482393),
   (67, 808017424794512875886459904961710757005754368000000000, 90400176482989643789462022480435378712807721041576147),
   (68, 675448131241557866586467272529408203125, 116126074785250102836142519771394215936),
   (69, 10075527575577829665339762714607616000000000, 2645274229217830393967976553912333610555523),
   (70, 6549868381671289907155890822316032, 2610087141044704088497161865234375),
   (71, 11380527109781871491358590210728320521207808000000000, 6842798698940938981814244812733146152009703886272161),
   (72, 3293182746777604312211658203125, 2970554341965274237297521328128)]

/-- The table covers exactly the bases `2, 3, …, 72`. -/
theorem baseTable_bases : baseTable.map (·.1) = List.range' 2 71 := by native_decide

/-- There are `71` rows, one for each base `2 … 72`. -/
theorem baseTable_length : baseTable.length = 71 := by native_decide

/-- Every listed fraction is already in lowest terms. -/
theorem baseTable_reduced : ∀ row ∈ baseTable, Nat.Coprime row.2.1 row.2.2 := by
  native_decide

/-- Every listed denominator is positive. -/
theorem baseTable_den_pos : ∀ row ∈ baseTable, 0 < row.2.2 := by native_decide

/-- Every listed base is positive. -/
theorem baseTable_base_pos : ∀ row ∈ baseTable, 0 < row.1 := by native_decide

/-- **The cross-multiplication identity.** For each base, the listed reduced fraction
`num / den` cross-multiplies against the defining fraction `|𝕄| / B ^ (L − 1)`. -/
theorem baseTable_cross : ∀ row ∈ baseTable,
    monsterOrder * row.2.2 =
      row.2.1 * row.1 ^ ((Nat.digits row.1 monsterOrder).length - 1) := by
  native_decide

/-- **The base sweep, `2 … 72`.** For every base in the table, the fixed-point quotient of
`|𝕄|` equals the listed reduced fraction `num / den`. -/
theorem fixedPointQuotient_eq_table : ∀ row ∈ baseTable,
    fixedPointQuotient row.1 = (row.2.1 : ℚ) / (row.2.2 : ℚ) := by
  intro row hrow
  unfold fixedPointQuotient digitLen
  have hbpos : (0 : ℚ) < (row.1 : ℚ) := by exact_mod_cast baseTable_base_pos row hrow
  have hdpos : (0 : ℚ) < (row.2.2 : ℚ) := by exact_mod_cast baseTable_den_pos row hrow
  rw [div_eq_div_iff (by positivity) hdpos.ne']
  exact_mod_cast baseTable_cross row hrow

/-! ## The two segmented decimal views from the request -/

/-- The base-`10` digit string of `|𝕄|`, most-significant first. -/
def bigEndianDecimal : List ℕ := (Nat.digits 10 monsterOrder).reverse

/-- First suggested segmentation:
`[8, 0.8, 0.174247945128758864599, 0.496171, 0.757, 0.05754368, 0.00000000]`,
as a list of big-endian decimal digit blocks. -/
def exampleSeg₁ : List (List ℕ) :=
  [[8],
   [0, 8],
   [0, 1, 7, 4, 2, 4, 7, 9, 4, 5, 1, 2, 8, 7, 5, 8, 8, 6, 4, 5, 9, 9],
   [0, 4, 9, 6, 1, 7, 1],
   [0, 7, 5, 7],
   [0, 0, 5, 7, 5, 4, 3, 6, 8],
   [0, 0, 0, 0, 0, 0, 0, 0, 0]]

/-- Second suggested segmentation:
`[8.0, 8.017424794512875886459, 9.049617, 1.075, 7.00575436, 8.000000000]`,
as a list of big-endian decimal digit blocks. -/
def exampleSeg₂ : List (List ℕ) :=
  [[8, 0],
   [8, 0, 1, 7, 4, 2, 4, 7, 9, 4, 5, 1, 2, 8, 7, 5, 8, 8, 6, 4, 5, 9],
   [9, 0, 4, 9, 6, 1, 7],
   [1, 0, 7, 5],
   [7, 0, 0, 5, 7, 5, 4, 3, 6],
   [8, 0, 0, 0, 0, 0, 0, 0, 0, 0]]

/-- The first segmentation's blocks concatenate to the full decimal digit string of `|𝕄|`. -/
theorem exampleSeg₁_reconstructs : exampleSeg₁.flatten = bigEndianDecimal := by native_decide

/-- The second segmentation's blocks concatenate to the full decimal digit string of `|𝕄|`. -/
theorem exampleSeg₂_reconstructs : exampleSeg₂.flatten = bigEndianDecimal := by native_decide

/-- Reading each block of the first segmentation as a fixed point (radix after the first
digit) yields exactly the listed rationals. -/
theorem exampleSeg₁_values :
    exampleSeg₁.map (fun b => fpReading 10 b 1) =
      [8,
       4 / 5,
       174247945128758864599 / 1000000000000000000000,
       496171 / 1000000,
       757 / 1000,
       22478 / 390625,
       0] := by native_decide

/-- Reading each block of the second segmentation as a fixed point (radix after the first
digit) yields exactly the listed rationals. -/
theorem exampleSeg₂_values :
    exampleSeg₂.map (fun b => fpReading 10 b 1) =
      [8,
       8017424794512875886459 / 1000000000000000000000,
       9049617 / 1000000,
       43 / 40,
       175143859 / 25000000,
       8] := by native_decide

/-- **Every segment value is a rational quotient.** Each block of either suggested
segmentation, read as a fixed point in base `10`, is an exact quotient of two naturals. -/
theorem exampleSeg_are_quotients :
    (∀ b ∈ exampleSeg₁, ∃ n d : ℕ, 0 < d ∧ fpReading 10 b 1 = (n : ℚ) / (d : ℚ)) ∧
    (∀ b ∈ exampleSeg₂, ∃ n d : ℕ, 0 < d ∧ fpReading 10 b 1 = (n : ℚ) / (d : ℚ)) :=
  ⟨fun b _ => fpReading_is_quotient 10 (by norm_num) b 1,
   fun b _ => fpReading_is_quotient 10 (by norm_num) b 1⟩

/-! ## The base-`B` digit length and head / mid / tail segments (the CSV columns)

The published CSV records, for each base `2 … 72`, the base-`B` *digit length* `L` and three
`[:10]` slices of the big-endian representation: the first ten digits (`head`), the first ten
digits of the middle third (`mid`, starting at `L / 3`), and the first ten of the last third
(`tail`, starting at `2 * L / 3`). We capture these as verified data. -/

/-- The big-endian base-`B` digit string of `|𝕄|` (most-significant digit first). -/
def bigEndianDigits (B : ℕ) : List ℕ := (Nat.digits B monsterOrder).reverse

/-- `head` slice: the first ten base-`B` digits. -/
def headSeg (B : ℕ) : List ℕ := (bigEndianDigits B).take 10

/-- `mid` slice: ten digits starting at the middle third `L / 3`. -/
def midSeg (B : ℕ) : List ℕ := ((bigEndianDigits B).drop (digitLen B / 3)).take 10

/-- `tail` slice: ten digits starting at the last third `2 * L / 3`. -/
def tailSeg (B : ℕ) : List ℕ := ((bigEndianDigits B).drop (2 * digitLen B / 3)).take 10

/-- The CSV `digit_length` column: `(base, L)` for every base `2 … 72`. -/
def digitLenTable : List (ℕ × ℕ) :=
  [(2, 180), (3, 113), (4, 90), (5, 78), (6, 70), (7, 64), (8, 60), (9, 57), (10, 54),
   (11, 52), (12, 50), (13, 49), (14, 48), (15, 46), (16, 45), (17, 44), (18, 43),
   (19, 43), (20, 42), (21, 41), (22, 41), (23, 40), (24, 40), (25, 39), (26, 39),
   (27, 38), (28, 38), (29, 37), (30, 37), (31, 37), (32, 36), (33, 36), (34, 36),
   (35, 35), (36, 35), (37, 35), (38, 35), (39, 34), (40, 34), (41, 34), (42, 34),
   (43, 34), (44, 33), (45, 33), (46, 33), (47, 33), (48, 33), (49, 32), (50, 32),
   (51, 32), (52, 32), (53, 32), (54, 32), (55, 31), (56, 31), (57, 31), (58, 31),
   (59, 31), (60, 31), (61, 31), (62, 31), (63, 30), (64, 30), (65, 30), (66, 30),
   (67, 30), (68, 30), (69, 30), (70, 30), (71, 30), (72, 30)]

/-- The digit-length table covers exactly the bases `2, 3, …, 72`. -/
theorem digitLenTable_bases : digitLenTable.map (·.1) = List.range' 2 71 := by native_decide

/-- **The CSV `digit_length` column is correct.** For every base in the table, the listed
length really is the number of base-`B` digits of `|𝕄|`. -/
theorem digitLenTable_correct : ∀ row ∈ digitLenTable, digitLen row.1 = row.2 := by
  native_decide

/-- **Every `head` / `mid` / `tail` slice has exactly ten digits**, across all bases
`2 … 72`. (This holds because the smallest base-`B` length is `30 ≥ 30`, so the last third
starting at `2 * L / 3 ≤ L - 10` still leaves ten digits.) -/
theorem seg_lengths : ∀ B ∈ List.range' 2 71,
    (headSeg B).length = 10 ∧ (midSeg B).length = 10 ∧ (tailSeg B).length = 10 := by
  native_decide

/-- The base-`10` head / mid / tail slices match the published CSV row
(`8080174247`, `8864599049`, `0057543680`). -/
theorem decimal_segments :
    headSeg 10 = [8, 0, 8, 0, 1, 7, 4, 2, 4, 7] ∧
    midSeg 10 = [8, 8, 6, 4, 5, 9, 9, 0, 4, 9] ∧
    tailSeg 10 = [0, 0, 5, 7, 5, 4, 3, 6, 8, 0] := by native_decide

/-! ## Summary -/

/-- **Summary.** (1) Any fixed-point reading of a base-`B` digit block is a rational
quotient. (2) For every base `2 … 72`, the fixed-point quotient of `|𝕄|` is the listed
reduced fraction. (3) Both suggested decimal segmentations reconstruct `|𝕄|` and consist of
rational quotients. -/
theorem monster_base_quotients_summary :
    (∀ (B : ℕ), 0 < B → ∀ (ds : List ℕ) (intLen : ℕ),
        ∃ n d : ℕ, 0 < d ∧ fpReading B ds intLen = (n : ℚ) / (d : ℚ)) ∧
    (∀ row ∈ baseTable, fixedPointQuotient row.1 = (row.2.1 : ℚ) / (row.2.2 : ℚ)) ∧
    (exampleSeg₁.flatten = bigEndianDecimal ∧ exampleSeg₂.flatten = bigEndianDecimal) :=
  ⟨fun B hB ds intLen => fpReading_is_quotient B hB ds intLen,
   fixedPointQuotient_eq_table,
   ⟨exampleSeg₁_reconstructs, exampleSeg₂_reconstructs⟩⟩

end MonsterBaseQuotients
