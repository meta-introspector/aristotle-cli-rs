/-
# The CSV codec

CSV is a *tabular projection* of the canonical model.  Arbitrary proof
structures are not flat, so rather than pretend otherwise the table
carries the shape explicitly, in the columns the specification
recommends:

```text
object_id,object_type,field,value,value_type,parent_id
```

Every canonical node becomes one row.  A container's row records how
many children follow it, and the children follow immediately, each
naming its parent — so the tree can be rebuilt by a single left-to-right
pass, and the projection is *lossless* rather than partial.  Quoting is
the RFC-4180 convention (every cell quoted, embedded quotes doubled), so
commas, newlines and quotes inside a value survive.

```text
"object_id","object_type","field","value","value_type","parent_id"
"r","obj","","2","obj",""
"r.n","value","n","144","int","r"
"r.note","value","note","hello","str","r"
```

Both layers are proved:

* `parseTable_renderTable` — the table syntax round-trips;
* `decode_encode` — the whole canonical value round-trips.
-/
import RequestProject.Edge.Codec.Value

namespace CfDeploy
namespace Codec
namespace Csv

/-! ## Rows -/

/-- One row of the canonical tabular projection. -/
structure Row where
  objectId : String
  objectType : String
  field : String
  value : String
  valueType : String
  parentId : String
  deriving DecidableEq, Repr, Inhabited

/-- The header row: the column names of the specification. -/
def header : Row :=
  ⟨"object_id", "object_type", "field", "value", "value_type", "parent_id"⟩

/-! ## The table syntax -/

/-- A quoted cell. -/
def renderCell (s : String) : List Char := '"' :: (Parse.escDbl '"' s.toList ++ ['"'])

/-- Read a quoted cell. -/
def parseCell : List Char → Option (String × List Char)
  | '"' :: r => (Parse.readDbl '"' r).map (fun p => (String.ofList p.1, p.2))
  | _ => none

/-- Consume one expected character. -/
def expectChar (c : Char) : List Char → Option (List Char)
  | d :: r => if d = c then some r else none
  | [] => none

theorem parseCell_renderCell (s : String) (rest : List Char)
    (hrest : ∀ c ∈ rest.head?, c ≠ '"') :
    parseCell (renderCell s ++ rest) = some (s, rest) := by
  simp only [renderCell, parseCell, List.cons_append, List.append_assoc, List.cons_append,
    List.nil_append]
  rw [Parse.readDbl_escDbl s.toList rest hrest]
  simp [String.ofList_toList]

/-- The six cells of a row, in the order of the header. -/
def toCells (r : Row) : List String :=
  [r.objectId, r.objectType, r.field, r.value, r.valueType, r.parentId]

/-- Render a comma-separated list of cells. -/
def renderCells : List String → List Char
  | [] => []
  | [c] => renderCell c
  | c :: cs => renderCell c ++ ',' :: renderCells cs

/-- Read `n` comma-separated cells. -/
def parseCellsN : Nat → List Char → Option (List String × List Char)
  | 0, cs => some ([], cs)
  | 1, cs => (parseCell cs).map (fun p => ([p.1], p.2))
  | n + 2, cs =>
      match parseCell cs with
      | some (a, r) =>
          match expectChar ',' r with
          | some r' => (parseCellsN (n + 1) r').map (fun p => (a :: p.1, p.2))
          | none => none
      | none => none

theorem parseCellsN_renderCells : ∀ (cs : List String) (rest : List Char), cs ≠ [] →
    (∀ c ∈ rest.head?, c ≠ '"') →
    parseCellsN cs.length (renderCells cs ++ rest) = some (cs, rest) := by
  intro cs
  induction cs with
  | nil => intro _ h; exact absurd rfl h
  | cons a as ih =>
      intro rest _ hrest
      cases as with
      | nil =>
          simp only [renderCells, List.length_cons, List.length_nil, parseCellsN]
          rw [parseCell_renderCell a rest hrest]
          rfl
      | cons b bs =>
          have hcomma : ∀ c ∈ ((',' : Char) :: (renderCells (b :: bs) ++ rest)).head?,
              c ≠ '"' := by
            intro c hc; simp at hc; subst hc; decide
          have hlen : (b :: bs).length = bs.length + 1 := rfl
          simp only [renderCells, List.length_cons, List.append_assoc, List.cons_append]
          rw [show bs.length + 1 + 1 = bs.length + 2 from rfl, parseCellsN]
          rw [parseCell_renderCell a _ hcomma]
          simp only [expectChar, if_true]
          rw [show bs.length + 1 = (b :: bs).length from rfl,
            ih rest (by simp) hrest]
          rfl

/-- Render one row: six quoted cells and a newline. -/
def renderRow (r : Row) : List Char := renderCells (toCells r) ++ ['\n']

/-- Parse one row. -/
def parseRow (cs : List Char) : Option (Row × List Char) :=
  match parseCellsN 6 cs with
  | some ([a, b, c, d, e, f], r) =>
      match expectChar '\n' r with
      | some r' => some (⟨a, b, c, d, e, f⟩, r')
      | none => none
  | _ => none

theorem parseRow_renderRow (r : Row) (rest : List Char) :
    parseRow (renderRow r ++ rest) = some (r, rest) := by
  obtain ⟨a, b, c, d, e, f⟩ := r
  have hnl : ∀ x ∈ (('\n' : Char) :: rest).head?, x ≠ '"' := by
    intro x hx; simp at hx; subst hx; decide
  have h6 : (toCells ⟨a, b, c, d, e, f⟩).length = 6 := rfl
  simp only [renderRow, List.append_assoc, List.cons_append, List.nil_append, parseRow]
  rw [show (6 : Nat) = (toCells (⟨a, b, c, d, e, f⟩ : Row)).length from h6.symm,
    parseCellsN_renderCells _ _ (by simp [toCells]) hnl]
  simp only [toCells, expectChar, if_true]

/-- Render a table. -/
def renderRows : List Row → List Char
  | [] => []
  | r :: rs => renderRow r ++ renderRows rs

/-- Parse a table; `none` if any row is malformed. -/
def parseRows : Nat → List Char → Option (List Row)
  | _, [] => some []
  | 0, _ => none
  | f + 1, cs =>
      match parseRow cs with
      | some (r, rest) => (parseRows f rest).map (fun rs => r :: rs)
      | none => none

theorem renderRow_length (r : Row) : 1 ≤ (renderRow r).length := by
  simp [renderRow]

theorem length_le_renderRows (rs : List Row) : rs.length ≤ (renderRows rs).length := by
  induction rs with
  | nil => simp [renderRows]
  | cons r rs ih =>
      have := renderRow_length r
      simp only [renderRows, List.length_append, List.length_cons]
      omega

/-- **The table syntax round-trips.**  Cells that contain commas,
newlines or quotes are recovered exactly. -/
theorem parseRows_renderRows : ∀ (f : Nat) (rs : List Row), rs.length ≤ f →
    parseRows f (renderRows rs) = some rs := by
  intro f
  induction f with
  | zero => intro rs h; cases rs with
    | nil => rfl
    | cons r rs => simp at h
  | succ f ih =>
      intro rs h
      cases rs with
      | nil => rfl
      | cons r rs =>
          have hne : renderRows (r :: rs) ≠ [] := by
            have h1 := renderRow_length r
            intro hc
            have h2 := congrArg List.length hc
            simp only [renderRows, List.length_append, List.length_nil] at h2
            omega
          have hlen : rs.length ≤ f := by simp at h; omega
          cases hcs : renderRows (r :: rs) with
          | nil => exact absurd hcs hne
          | cons c t =>
              have : parseRow (c :: t) = some (r, renderRows rs) := by
                rw [← hcs]
                simpa [renderRows] using parseRow_renderRow r (renderRows rs)
              rw [parseRows, this] <;> simp [ih rs hlen]

/-! ## The canonical value as rows -/

open CVal

mutual

/-- The rows of a canonical value: one for the node itself, then the
rows of its children. -/
def rows (v : CVal) (oid fld par : String) : List Row :=
  match v with
  | .null => [⟨oid, "value", fld, "", "null", par⟩]
  | .bool b => [⟨oid, "value", fld, if b then "true" else "false", "bool", par⟩]
  | .int i => [⟨oid, "value", fld, Parse.intStr i, "int", par⟩]
  | .num m e => [⟨oid, "value", fld, Parse.intPairStr m e, "dec", par⟩]
  | .str s => [⟨oid, "value", fld, s, "str", par⟩]
  | .ref r => [⟨oid, "value", fld, r, "ref", par⟩]
  | .list xs =>
      ⟨oid, "list", fld, Parse.intStr xs.length, "list", par⟩ :: rowsItems xs oid 0
  | .obj fs =>
      ⟨oid, "obj", fld, Parse.intStr fs.length, "obj", par⟩ :: rowsFields fs oid

def rowsItems (xs : List CVal) (oid : String) (i : Nat) : List Row :=
  match xs with
  | [] => []
  | x :: xs =>
      rows x (oid ++ "." ++ Parse.intStr i) (Parse.intStr i) oid ++ rowsItems xs oid (i + 1)

def rowsFields (fs : List (String × CVal)) (oid : String) : List Row :=
  match fs with
  | [] => []
  | (k, v) :: fs => rows v (oid ++ "." ++ k) k oid ++ rowsFields fs oid

end

/-! ## Rebuilding the value from the rows -/

mutual

/-- Read the value whose rows start here, and return what follows. -/
def readRow : Nat → List Row → Option (CVal × List Row)
  | 0, _ => none
  | _ + 1, [] => none
  | f + 1, r :: rest =>
      if r.valueType = "null" then some (.null, rest)
      else if r.valueType = "bool" then
        if r.value = "true" then some (.bool true, rest)
        else if r.value = "false" then some (.bool false, rest)
        else none
      else if r.valueType = "int" then
        (Parse.parseIntStr r.value).map (fun i => (CVal.int i, rest))
      else if r.valueType = "dec" then
        (Parse.parseIntPairStr r.value).map (fun p => (CVal.num p.1 p.2, rest))
      else if r.valueType = "str" then some (.str r.value, rest)
      else if r.valueType = "ref" then some (.ref r.value, rest)
      else if r.valueType = "list" then
        match Parse.parseIntStr r.value with
        | some n => (readItems f n.toNat rest).map (fun p => (CVal.list p.1, p.2))
        | none => none
      else if r.valueType = "obj" then
        match Parse.parseIntStr r.value with
        | some n => (readFields f n.toNat rest).map (fun p => (CVal.obj p.1, p.2))
        | none => none
      else none

def readItems : Nat → Nat → List Row → Option (List CVal × List Row)
  | _, 0, rs => some ([], rs)
  | 0, _ + 1, _ => none
  | f + 1, n + 1, rs =>
      match readRow f rs with
      | some (x, rs') => (readItems f n rs').map (fun p => (x :: p.1, p.2))
      | none => none

def readFields : Nat → Nat → List Row → Option (List (String × CVal) × List Row)
  | _, 0, rs => some ([], rs)
  | 0, _ + 1, _ => none
  | f + 1, n + 1, rs =>
      match rs with
      | [] => none
      | r :: _ =>
          match readRow f rs with
          | some (v, rs') => (readFields f n rs').map (fun p => ((r.field, v) :: p.1, p.2))
          | none => none

end

/-! ## The projection is lossless -/

theorem read_rows_all : ∀ f : Nat,
    (∀ (v : CVal) (oid fld par : String) (rest : List Row), size v ≤ f →
        readRow f (rows v oid fld par ++ rest) = some (v, rest)) ∧
    (∀ (xs : List CVal) (oid : String) (i : Nat) (rest : List Row), sizeItems xs ≤ f →
        readItems f xs.length (rowsItems xs oid i ++ rest) = some (xs, rest)) ∧
    (∀ (fs : List (String × CVal)) (oid : String) (rest : List Row), sizeFields fs ≤ f →
        readFields f fs.length (rowsFields fs oid ++ rest) = some (fs, rest)) := by
  intro f
  induction f with
  | zero =>
      refine ⟨?_, ?_, ?_⟩
      · intro v _ _ _ _ h; exact absurd h (by have := size_pos v; omega)
      · intro xs _ _ _ h; exact absurd h (by have := sizeItems_pos xs; omega)
      · intro fs _ _ h; exact absurd h (by have := sizeFields_pos fs; omega)
  | succ f ih =>
      obtain ⟨ihV, ihI, ihF⟩ := ih
      refine ⟨?_, ?_, ?_⟩
      · intro v oid fld par rest hv
        cases v with
        | null => simp [rows, readRow]
        | bool b => cases b <;> simp [rows, readRow]
        | int i => simp [rows, readRow]
        | num m e => simp [rows, readRow]
        | str s => simp [rows, readRow]
        | ref r => simp [rows, readRow]
        | list xs =>
            have hxs : sizeItems xs ≤ f := by simp [size] at hv; omega
            simp only [rows, List.cons_append, readRow]
            simp only [Parse.parseIntStr_intStr, Int.toNat_natCast]
            simp only [ihI xs oid 0 rest hxs]
            simp
        | obj fs =>
            have hfs : sizeFields fs ≤ f := by simp [size] at hv; omega
            simp only [rows, List.cons_append, readRow]
            simp only [Parse.parseIntStr_intStr, Int.toNat_natCast]
            simp only [ihF fs oid rest hfs]
            simp
      · intro xs oid i rest hxs
        cases xs with
        | nil => simp [rowsItems, readItems]
        | cons x xs =>
            have hx : size x ≤ f := by simp [sizeItems] at hxs; omega
            have hxs' : sizeItems xs ≤ f := by simp [sizeItems] at hxs; omega
            simp only [rowsItems, List.length_cons, List.append_assoc, readItems]
            rw [ihV x _ _ _ _ hx]
            simp [ihI xs oid (i + 1) rest hxs']
      · intro fs oid rest hfs
        cases fs with
        | nil => simp [rowsFields, readFields]
        | cons p fs =>
            obtain ⟨k, v⟩ := p
            have hv : size v ≤ f := by simp [sizeFields] at hfs; omega
            have hfs' : sizeFields fs ≤ f := by simp [sizeFields] at hfs; omega
            have hne : rows v (oid ++ "." ++ k) k oid ≠ [] := by
              cases v <;> simp [rows]
            simp only [rowsFields, List.length_cons, List.append_assoc, readFields]
            cases hr : rows v (oid ++ "." ++ k) k oid with
            | nil => exact absurd hr hne
            | cons r t =>
                have hrow : readRow f (r :: (t ++ (rowsFields fs oid ++ rest)))
                    = some (v, rowsFields fs oid ++ rest) := by
                  have := ihV v (oid ++ "." ++ k) k oid (rowsFields fs oid ++ rest) hv
                  rwa [hr, List.cons_append] at this
                have hfield : r.field = k := by
                  cases v <;> simp [rows] at hr <;> simp [← hr.1]
                simp [List.cons_append, hrow, hfield, ihF fs oid rest hfs']

theorem read_rows (v : CVal) (oid fld par : String) (rest : List Row) (f : Nat)
    (h : size v ≤ f) : readRow f (rows v oid fld par ++ rest) = some (v, rest) :=
  (read_rows_all f).1 v oid fld par rest h

/-! ## Enough fuel -/

theorem size_le_rows_all :
    (∀ (v : CVal) (oid fld par : String), size v + 1 ≤ 3 * (rows v oid fld par).length) ∧
    (∀ (fs : List (String × CVal)) (oid : String),
        sizeFields fs ≤ 3 * (rowsFields fs oid).length + 1) ∧
    (∀ (xs : List CVal) (oid : String) (i : Nat),
        sizeItems xs ≤ 3 * (rowsItems xs oid i).length + 1) := by
  refine @rows.mutual_induct
    (fun v oid fld par => size v + 1 ≤ 3 * (rows v oid fld par).length)
    (fun fs oid => sizeFields fs ≤ 3 * (rowsFields fs oid).length + 1)
    (fun xs oid i => sizeItems xs ≤ 3 * (rowsItems xs oid i).length + 1)
    ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;> intros <;>
    simp_all [size, sizeItems, sizeFields, rows, rowsItems, rowsFields] <;> omega

/-! ## The codec -/

/-- Encode a canonical value as a CSV table, header included. -/
def encode (v : CVal) : String :=
  String.ofList (renderRows (header :: rows v "r" "" ""))

/-- Decode a CSV table.  The header row is required, and the rows must
describe exactly one value. -/
def decode (s : String) : Option CVal :=
  match parseRows s.length s.toList with
  | some (h :: rs) =>
      if h = header then
        match readRow (3 * rs.length) rs with
        | some (v, []) => some v
        | _ => none
      else none
  | _ => none

/-- **The CSV projection is lossless.**  The six-column convention, with
child counts and parent links, carries the complete canonical value: the
table decodes back to exactly the value that produced it. -/
theorem decode_encode (v : CVal) : decode (encode v) = some v := by
  have hrows : parseRows (String.ofList (renderRows (header :: rows v "r" "" ""))).length
      (String.ofList (renderRows (header :: rows v "r" "" ""))).toList
      = some (header :: rows v "r" "" "") := by
    rw [String.toList_ofList, String.length_ofList]
    exact parseRows_renderRows _ _ (length_le_renderRows _)
  have hfuel : size v ≤ 3 * (rows v "r" "" "").length := by
    have := size_le_rows_all.1 v "r" "" ""
    omega
  have hread : readRow (3 * (rows v "r" "" "").length) (rows v "r" "" "") = some (v, []) := by
    have := read_rows v "r" "" "" [] _ hfuel
    simpa using this
  simp only [decode, encode, hrows, hread, if_true]

end Csv
end Codec
end CfDeploy
