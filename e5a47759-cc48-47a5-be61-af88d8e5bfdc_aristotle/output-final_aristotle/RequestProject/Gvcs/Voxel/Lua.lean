import RequestProject.Gvcs.Voxel.Bricks

/-!
# Compiling the voxel model to Roblox Lua

The last step of the pipeline: the bricks of
`RequestProject/Voxel/Bricks.lean` are turned into a Lua module that Roblox
Studio can run.  The Lua is not built by pasting strings together — it is built
as a small Lua *syntax tree* (`LExpr`, `LStmt`) and printed, so the generated
file is well-formed by construction.

Coordinates.  The Lean model has `x` forward, `y` to the left and `z` up;
Roblox has `Y` up and a left-handed frame, so a voxel `(x, y, z)` is placed at
`(x, z, -y)` in studs, scaled by `VOXEL` studs per voxel.  `robloxOf` is that
map, and `robloxOf_injective` says the model is not folded onto itself by it.

What the generated module contains:

* `M.BODIES` — one entry per body of the machine, with its name, colour,
  material and the bricks of each keyframe of the loader;
* `M.build(parent, frame)` — build the machine into `parent` at keyframe
  `frame`, one Roblox `Part` per brick, grouped into one `Model` per body.
-/

namespace LifeTrac
namespace Voxel

open Solid

/-! ## Where a voxel goes in Roblox -/

/-- A voxel of the Lean model, as Roblox axes: `x` stays, the Lean `z` (up)
becomes Roblox `Y`, and the Lean `y` (left) becomes `-Z`. -/
def robloxOf (v : Vox) : Vox := (v.x, v.z, -v.y)

theorem robloxOf_injective : Function.Injective robloxOf := by
  intro a b hab
  simp only [robloxOf, Prod.ext_iff, Vox.x, Vox.y, Vox.z] at hab
  obtain ⟨h1, h2, h3⟩ := hab
  exact Prod.ext h1 (Prod.ext (by omega) h2)

/-! ## A little Lua -/

/-- An expression of the fragment of Lua we generate. -/
inductive LExpr where
  /-- An integer literal. -/
  | num : ℤ → LExpr
  /-- A decimal literal `mantissa / 10 ^ places`. -/
  | real : ℤ → ℕ → LExpr
  /-- A string literal. -/
  | str : String → LExpr
  /-- A boolean literal. -/
  | bool : Bool → LExpr
  /-- `nil`. -/
  | nilE : LExpr
  /-- A variable. -/
  | var : String → LExpr
  /-- `e.field`. -/
  | dot : LExpr → String → LExpr
  /-- `e[i]`. -/
  | idx : LExpr → LExpr → LExpr
  /-- `f(a, b, …)`. -/
  | call : LExpr → List LExpr → LExpr
  /-- An infix operator. -/
  | bin : String → LExpr → LExpr → LExpr
  /-- Unary minus. -/
  | neg : LExpr
      → LExpr
  /-- An array-like table `{a, b, …}`. -/
  | arr : List LExpr → LExpr
  /-- A record-like table `{k = v, …}`. -/
  | record : List (String × LExpr) → LExpr
deriving Inhabited

/-- A statement of the fragment of Lua we generate. -/
inductive LStmt where
  /-- A comment line. -/
  | comment : String → LStmt
  /-- A blank line. -/
  | blank : LStmt
  /-- `local n = e`. -/
  | localDef : String → LExpr → LStmt
  /-- `lhs = rhs`. -/
  | set : LExpr → LExpr → LStmt
  /-- An expression evaluated for its effect. -/
  | expr : LExpr → LStmt
  /-- `local function n(args) … end`. -/
  | localFun : String → List String → List LStmt → LStmt
  /-- `function obj.n(args) … end`. -/
  | fieldFun : String → String → List String → List LStmt → LStmt
  /-- `if c then … end`. -/
  | ifThen : LExpr → List LStmt → LStmt
  /-- `for k, v in ipairs(e) do … end`. -/
  | forIn : String → String → LExpr → List LStmt → LStmt
  /-- `return e`. -/
  | ret : LExpr → LStmt
deriving Inhabited

namespace LExpr

/-- Escape a Lua string literal. -/
def escape (s : String) : String :=
  s.foldl (fun acc c =>
    acc ++ (match c with
      | '\\' => "\\\\"
      | '"' => "\\\""
      | '\n' => "\\n"
      | _ => c.toString)) ""

/-- A decimal literal from a mantissa and a number of decimal places. -/
def decimal (m : ℤ) (places : ℕ) : String :=
  let sign := if m < 0 then "-" else ""
  let digits := toString m.natAbs
  let pad := if digits.length ≤ places then
      String.ofList (List.replicate (places + 1 - digits.length) '0') ++ digits
    else digits
  if places = 0 then sign ++ pad
  else sign ++ pad.take (pad.length - places) ++ "." ++ pad.drop (pad.length - places)

/-- Print an expression. -/
partial def render : LExpr → String
  | num n => toString n
  | real m p => decimal m p
  | str s => "\"" ++ escape s ++ "\""
  | bool b => if b then "true" else "false"
  | nilE => "nil"
  | var n => n
  | dot e f => render e ++ "." ++ f
  | idx e i => render e ++ "[" ++ render i ++ "]"
  | call f args => render f ++ "(" ++ String.intercalate ", " (args.map render) ++ ")"
  | bin op a b => "(" ++ render a ++ " " ++ op ++ " " ++ render b ++ ")"
  | neg a => "-" ++ render a
  | arr es => "{" ++ String.intercalate ", " (es.map render) ++ "}"
  | record fs => "{" ++ String.intercalate ", " (fs.map (fun kv => kv.1 ++ " = " ++ render kv.2)) ++ "}"

end LExpr

namespace LStmt

/-- `n` spaces. -/
def indent (n : ℕ) : String := String.ofList (List.replicate n ' ')

/-- Print a statement at an indentation. -/
partial def render (ind : ℕ) : LStmt → String
  | comment s => indent ind ++ "-- " ++ s
  | blank => ""
  | localDef n e => indent ind ++ "local " ++ n ++ " = " ++ e.render
  | set l r => indent ind ++ l.render ++ " = " ++ r.render
  | expr e => indent ind ++ e.render
  | localFun n args body =>
      indent ind ++ "local function " ++ n ++ "(" ++ String.intercalate ", " args ++ ")\n" ++
        String.intercalate "\n" (body.map (render (ind + 2))) ++ "\n" ++ indent ind ++ "end"
  | fieldFun obj n args body =>
      indent ind ++ "function " ++ obj ++ "." ++ n ++ "(" ++ String.intercalate ", " args ++ ")\n" ++
        String.intercalate "\n" (body.map (render (ind + 2))) ++ "\n" ++ indent ind ++ "end"
  | ifThen c body =>
      indent ind ++ "if " ++ c.render ++ " then\n" ++
        String.intercalate "\n" (body.map (render (ind + 2))) ++ "\n" ++ indent ind ++ "end"
  | forIn k v e body =>
      indent ind ++ "for " ++ k ++ ", " ++ v ++ " in ipairs(" ++ e.render ++ ") do\n" ++
        String.intercalate "\n" (body.map (render (ind + 2))) ++ "\n" ++ indent ind ++ "end"
  | ret e => indent ind ++ "return " ++ e.render

end LStmt

/-- Print a chunk of Lua. -/
def luaChunk (stmts : List LStmt) : String :=
  String.intercalate "\n" (stmts.map (LStmt.render 0)) ++ "\n"

/-! ## The machine as Lua data -/

/-- The window the model is compiled in: big enough for the machine at any
lift the loader allows. -/
def modelLo : Vox := (-4, -24, -2)
/-- The far corner of that window. -/
def modelHi : Vox := (56, 24, 56)

/-- The lift commands the generated module carries geometry for. -/
def keyLifts : List ℤ := [0, 7, 13, 20, 26]

/-- The bricks of one body at one lift. -/
def bodyBricks (b : Body) (lift : ℤ) : List Brick :=
  bricksOf (b.shape lift) modelLo modelHi

/-- Does this body change shape as the loader moves? -/
def bodyMoves (b : Body) : Bool :=
  keyLifts.any (fun l => bodyBricks b l ≠ bodyBricks b 0)

/-- One brick, as Lua: `{x0, len, y, z}`. -/
def brickExpr (b : Brick) : LExpr :=
  .arr [.num b.x0, .num b.len, .num b.y, .num b.z]

/-- One body, as Lua data. -/
def bodyExpr (b : Body) : LExpr :=
  let frames : List LExpr :=
    if bodyMoves b then keyLifts.map (fun l => .arr ((bodyBricks b l).map brickExpr))
    else [.arr ((bodyBricks b 0).map brickExpr)]
  .record
    [ ("name", .str b.name)
    , ("material", .str b.material)
    , ("colour", .arr [.num b.colour.r, .num b.colour.g, .num b.colour.b])
    , ("moves", .bool (bodyMoves b))
    , ("frames", .arr frames) ]

/-- The body of the `makeBrick` helper: one Roblox `Part` per brick. -/
def makeBrickBody : List LStmt :=
  let p : LExpr := .var "p"
  let b : LExpr := .var "b"
  let v : LExpr := .var "voxel"
  let comp : ℕ → LExpr := fun i => .idx b (.num (i : ℤ))
  [ .localDef "p" (.call (.dot (.var "Instance") "new") [.str "Part"])
  , .set (.dot p "Anchored") (.bool true)
  , .set (.dot p "Name") (.var "name")
  , .set (.dot p "Size")
      (.call (.dot (.var "Vector3") "new")
        [ .bin "*" (comp 2) v, v, v ])
  , .set (.dot p "Position")
      (.call (.dot (.var "Vector3") "new")
        [ .bin "*" (.bin "+" (comp 1) (.bin "/" (.bin "-" (comp 2) (.num 1)) (.num 2))) v
        , .bin "*" (.bin "+" (comp 4) (.real 5 1)) v
        , .neg (.bin "*" (.bin "+" (comp 3) (.real 5 1)) v) ])
  , .set (.dot p "Color")
      (.call (.dot (.var "Color3") "fromRGB")
        [ .idx (.var "colour") (.num 1), .idx (.var "colour") (.num 2)
        , .idx (.var "colour") (.num 3) ])
  , .set (.dot p "Material") (.dot (.dot (.var "Enum") "Material") "SmoothPlastic")
  , .set (.dot p "TopSurface") (.dot (.dot (.var "Enum") "SurfaceType") "Smooth")
  , .set (.dot p "BottomSurface") (.dot (.dot (.var "Enum") "SurfaceType") "Smooth")
  , .set (.dot p "Parent") (.var "parent")
  , .ret p ]

/-- What the generated module claims about a body is true: inside the model
window, the bricks it carries for a lift are exactly the voxels of that body at
that lift. -/
theorem bodyBricks_correct (b : Body) (lift : ℤ) (v : Vox)
    (hw : modelLo.x ≤ v.x ∧ v.x ≤ modelHi.x ∧ modelLo.y ≤ v.y ∧ v.y ≤ modelHi.y ∧
      modelLo.z ≤ v.z ∧ v.z ≤ modelHi.z) :
    bricksSolid (bodyBricks b lift) v = b.shape lift v :=
  bricksOf_correct (b.shape lift) modelLo modelHi v hw

/-- And a brick of the generated module never claims material the body does
not have, anywhere in the lattice — not just inside the window. -/
theorem bodyBricks_sound (b : Body) (lift : ℤ) (v : Vox)
    (h : bricksSolid (bodyBricks b lift) v = true) : b.shape lift v = true :=
  bricksSolid_bricksOf_sound (b.shape lift) modelLo modelHi v h

/-- The generated Lua module, as a syntax tree. -/
def machineChunk : List LStmt :=
  let m : LExpr := .var "M"
  [ .comment "LifeTrac, one Roblox part per run of voxels."
  , .comment "Generated from the Lean development: RequestProject/Voxel/Lua.lean."
  , .comment "Each body is a function of the loader lift; the frames below are its"
  , .comment "geometry at the lift commands in M.LIFTS."
  , .blank
  , .localDef "M" (.record [])
  , .blank
  , .comment "Studs per voxel; one voxel of the model is 5 cm."
  , .set (.dot m "VOXEL") (.real 18 2)
  , .set (.dot m "LIFTS") (.arr (keyLifts.map (fun l => LExpr.num l)))
  , .blank
  , .set (.dot m "BODIES") (.arr (bodies.map bodyExpr))
  , .blank
  , .localFun "makeBrick" ["parent", "b", "colour", "voxel", "name"] makeBrickBody
  , .blank
  , .fieldFun "M" "buildBody" ["body", "frame", "parent"]
      [ .localDef "model" (.call (.dot (.var "Instance") "new") [.str "Model"])
      , .set (.dot (.var "model") "Name") (.dot (.var "body") "name")
      , .localDef "bricks" (.idx (.dot (.var "body") "frames") (.var "frame"))
      , .ifThen (.bin "==" (.var "bricks") .nilE)
          [ .set (.var "bricks") (.idx (.dot (.var "body") "frames") (.num 1)) ]
      , .forIn "_" "b" (.var "bricks")
          [ .expr (.call (.var "makeBrick")
              [ .var "model", .var "b", .dot (.var "body") "colour", .dot m "VOXEL"
              , .dot (.var "body") "name" ]) ]
      , .set (.dot (.var "model") "Parent") (.var "parent")
      , .ret (.var "model") ]
  , .blank
  , .comment "Build the whole machine at keyframe `frame` (1 .. #M.LIFTS)."
  , .fieldFun "M" "build" ["parent", "frame"]
      [ .localDef "root" (.call (.dot (.var "Instance") "new") [.str "Model"])
      , .set (.dot (.var "root") "Name") (.str "LifeTrac")
      , .forIn "_" "body" (.dot m "BODIES")
          [ .expr (.call (.dot m "buildBody") [.var "body", .var "frame", .var "root"]) ]
      , .set (.dot (.var "root") "Parent") (.var "parent")
      , .ret (.var "root") ]
  , .blank
  , .ret m ]

/-- The generated Lua module. -/
def machineLua : String := luaChunk machineChunk

/-! ## The same geometry as plain data

The harness in `tools/check_roblox_lua.py` runs the generated Lua against a
stub of the Roblox API and compares the parts it creates with this dump of the
occupancy function itself — the two are computed by different routes, one
through the brick compiler and one straight from the solid. -/

/-- The occupied voxels of the machine at one lift, inside the model window. -/
def occupiedVoxels (lift : ℤ) : List Vox :=
  (rowList modelLo.x modelHi.x).flatMap (fun x =>
    (rowList modelLo.y modelHi.y).flatMap (fun y =>
      (rowList modelLo.z modelHi.z).filterMap (fun z =>
        if machine ⟨lift, 0⟩ (x, y, z) then some (x, y, z) else none)))

/-- One voxel, as JSON. -/
def voxJson (v : Vox) : String :=
  "[" ++ toString v.x ++ "," ++ toString v.y ++ "," ++ toString v.z ++ "]"

/-- The occupancy of every keyframe, as JSON. -/
def occupancyJson : String :=
  "{\"lifts\":[" ++ String.intercalate "," (keyLifts.map toString) ++ "],\n \"frames\":[\n" ++
  String.intercalate ",\n"
    (keyLifts.map (fun l =>
      "  [" ++ String.intercalate "," ((occupiedVoxels l).map voxJson) ++ "]")) ++
  "\n ]}\n"

/-! ## What comes out

These are the numbers the generated files carry, checked by evaluating the
model itself. -/

/-- The machine at rest fills 6810 voxels of the model window — about 0.85 m³
of material at 5 cm to the voxel. -/
theorem occupiedVoxels_nominal_length : (occupiedVoxels 0).length = 6810 := by
  native_decide

/-- With the loader all the way up the machine fills 6906 voxels: raising it
exposes 96 more voxels of cylinder rod. -/
theorem occupiedVoxels_raised_length : (occupiedVoxels liftMax).length = 6906 := by
  native_decide

/-- The module builds 1545 Roblox parts for the machine at rest — one per run
of voxels, against 6810 voxels. -/
theorem emitted_parts_nominal : ((bodies.map (fun b => (bodyBricks b 0).length)).sum) = 1545 := by
  native_decide

end Voxel
end LifeTrac
