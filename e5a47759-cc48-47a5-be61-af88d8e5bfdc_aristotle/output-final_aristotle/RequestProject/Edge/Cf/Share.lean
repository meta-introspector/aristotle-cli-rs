/-
# Sharing a workflow

A workflow is a value, so it can be written down, sent to somebody else,
and pasted into their tool — that is what makes deployment recipes
composable *and* shareable: `w₁.seq w₂` of two shared recipes is again a
shared recipe.

The format is a flat list of tokens, one per line, with `\` and newlines
escaped.  The point of this module is `unshare_share`: the text form is
lossless, so a recipe that arrives over a chat window is exactly the
recipe that was sent — including the permission contract it implies,
since that is computed from the workflow.
-/
import RequestProject.Edge.Cf.Workflow
import RequestProject.Edge.Cf.Digits

namespace CfDeploy
namespace Share

/-! ## Assets -/

def encAsset (x : Asset) : List String :=
  [x.path, x.contentType, Digits.natStr x.size, x.hash]

def parseAsset : List String → Option (Asset × List String)
  | p :: c :: s :: h :: rest =>
      match Digits.natOf s with
      | some n => some (⟨p, c, n, h⟩, rest)
      | none => none
  | _ => none

theorem parseAsset_encAsset (x : Asset) (rest : List String) :
    parseAsset (encAsset x ++ rest) = some (x, rest) := by
  cases x with
  | mk path ct size hash => simp [encAsset, parseAsset]

def parseAssets : Nat → List String → Option (List Asset × List String)
  | 0, ts => some ([], ts)
  | n + 1, ts =>
      match parseAsset ts with
      | some (x, r) =>
          match parseAssets n r with
          | some (xs, r') => some (x :: xs, r')
          | none => none
      | none => none

theorem parseAssets_enc (xs : List Asset) (rest : List String) :
    parseAssets xs.length (xs.flatMap encAsset ++ rest) = some (xs, rest) := by
  induction xs generalizing rest with
  | nil => simp [parseAssets]
  | cons x xs ih =>
      simp only [List.flatMap_cons, List.length_cons, List.append_assoc, parseAssets,
        parseAsset_encAsset x (xs.flatMap encAsset ++ rest)]
      have : xs.length + 1 = xs.length + 1 := rfl
      simp [ih rest]

/-! ## Actions -/

/-- Token form of an action. -/
def encAction : Action → List String
  | .verifyToken => ["verify"]
  | .listPermissionGroups => ["groups"]
  | .mintRoleToken r => ["mint", r]
  | .revokeRoleToken r => ["revoke", r]
  | .getPagesProject a p => ["pages-get", a, p]
  | .createPagesProject a p b => ["pages-new", a, p, b]
  | .createUploadToken a p => ["upload-token", a, p]
  | .checkMissingAssets a p => ["assets-check", a, p]
  | .uploadAssets a p xs =>
      ["assets-put", a, p, Digits.natStr xs.length] ++ xs.flatMap encAsset
  | .createDeployment a p => ["deploy", a, p]
  | .addPagesDomain a p d => ["domain", a, p, d]
  | .putKvValue a n k => ["kv", a, n, k]
  | .putR2Object a b k => ["r2", a, b, k]
  | .putWorkerScript a s => ["worker", a, s]
  | .putDnsRecord a z n t => ["dns", a, z, n, t]
  | .purgeCache a z => ["purge", a, z]

/-- Read an action back. -/
def parseAction : List String → Option (Action × List String)
  | "verify" :: r => some (.verifyToken, r)
  | "groups" :: r => some (.listPermissionGroups, r)
  | "mint" :: role :: r => some (.mintRoleToken role, r)
  | "revoke" :: role :: r => some (.revokeRoleToken role, r)
  | "pages-get" :: a :: p :: r => some (.getPagesProject a p, r)
  | "pages-new" :: a :: p :: b :: r => some (.createPagesProject a p b, r)
  | "upload-token" :: a :: p :: r => some (.createUploadToken a p, r)
  | "assets-check" :: a :: p :: r => some (.checkMissingAssets a p, r)
  | "assets-put" :: a :: p :: n :: r =>
      match Digits.natOf n with
      | some k =>
          match parseAssets k r with
          | some (xs, r') => some (.uploadAssets a p xs, r')
          | none => none
      | none => none
  | "deploy" :: a :: p :: r => some (.createDeployment a p, r)
  | "domain" :: a :: p :: d :: r => some (.addPagesDomain a p d, r)
  | "kv" :: a :: n :: k :: r => some (.putKvValue a n k, r)
  | "r2" :: a :: b :: k :: r => some (.putR2Object a b k, r)
  | "worker" :: a :: s :: r => some (.putWorkerScript a s, r)
  | "dns" :: a :: z :: n :: t :: r => some (.putDnsRecord a z n t, r)
  | "purge" :: a :: z :: r => some (.purgeCache a z, r)
  | _ => none

theorem parseAction_encAction (a : Action) (rest : List String) :
    parseAction (encAction a ++ rest) = some (a, rest) := by
  cases a with
  | uploadAssets acct proj xs =>
      simp only [encAction, List.cons_append, List.nil_append,
        parseAction, Digits.natOf_natStr, parseAssets_enc xs rest]
  | _ => simp [encAction, parseAction]

/-! ## Workflows -/

/-- Number of nodes, used as the parser's fuel. -/
def size : Workflow → Nat
  | .nil => 1
  | .act _ => 1
  | .seq w₁ w₂ => size w₁ + size w₂ + 1

/-- Token form of a workflow (prefix notation). -/
def encode : Workflow → List String
  | .nil => ["nil"]
  | .act a => "act" :: encAction a
  | .seq w₁ w₂ => "seq" :: (encode w₁ ++ encode w₂)

/-- Read a workflow back, with fuel bounding the tree depth. -/
def parse : Nat → List String → Option (Workflow × List String)
  | 0, _ => none
  | _ + 1, "nil" :: r => some (.nil, r)
  | _ + 1, "act" :: r =>
      match parseAction r with
      | some (a, r') => some (.act a, r')
      | none => none
  | fuel + 1, "seq" :: r =>
      match parse fuel r with
      | some (w₁, r₁) =>
          match parse fuel r₁ with
          | some (w₂, r₂) => some (.seq w₁ w₂, r₂)
          | none => none
      | none => none
  | _ + 1, _ => none

theorem parse_encode (w : Workflow) :
    ∀ (fuel : Nat), size w ≤ fuel → ∀ (rest : List String),
      parse fuel (encode w ++ rest) = some (w, rest) := by
  induction w with
  | nil =>
      intro fuel hfuel rest
      cases fuel with
      | zero => simp [size] at hfuel
      | succ f => simp [encode, parse]
  | act a =>
      intro fuel hfuel rest
      cases fuel with
      | zero => simp [size] at hfuel
      | succ f =>
          simp only [encode, List.cons_append, parse, parseAction_encAction a rest]
  | seq w₁ w₂ ih₁ ih₂ =>
      intro fuel hfuel rest
      cases fuel with
      | zero => simp [size] at hfuel
      | succ f =>
          have h₁ : size w₁ ≤ f := by simp [size] at hfuel; omega
          have h₂ : size w₂ ≤ f := by simp [size] at hfuel; omega
          simp only [encode, List.cons_append, List.append_assoc, parse,
            ih₁ f h₁ (encode w₂ ++ rest), ih₂ f h₂ rest]

/-- Decode a token list into a workflow; `none` if it is malformed or has
trailing junk. -/
def decodeTokens (ts : List String) : Option Workflow :=
  match parse ts.length ts with
  | some (w, []) => some w
  | _ => none

theorem length_encode_ge_size (w : Workflow) : size w ≤ (encode w).length := by
  induction w with
  | nil => simp [size, encode]
  | act a => simp [size, encode]
  | seq w₁ w₂ ih₁ ih₂ => simp [size, encode]; omega

theorem decodeTokens_encode (w : Workflow) : decodeTokens (encode w) = some w := by
  unfold decodeTokens
  have h := parse_encode w (encode w).length (length_encode_ge_size w) []
  simp only [List.append_nil] at h
  rw [h]

/-! ## Text form -/

/-- Escape one character of a token: `\` and newline are the only
characters that cannot appear literally. -/
def escC (c : Char) : List Char :=
  if c = '\\' then ['\\', '\\']
  else if c = '\n' then ['\\', 'n']
  else [c]

def encTok (cs : List Char) : List Char := cs.flatMap escC

/-- The text of a token list: every token escaped and newline-terminated. -/
def encChars (ts : List String) : List Char :=
  ts.flatMap (fun t => encTok t.toList ++ ['\n'])

/-- The reader: `cur` is the token being read (reversed), `acc` the
tokens read so far (reversed). -/
def decGo : List Char → List Char → List String → Option (List String)
  | [], cur, acc => if cur.isEmpty then some acc.reverse else none
  | c :: rest, cur, acc =>
      if c = '\n' then decGo rest [] (String.ofList cur.reverse :: acc)
      else if c = '\\' then
        match rest with
        | [] => none
        | d :: rest' => decGo rest' ((if d = 'n' then '\n' else d) :: cur) acc
      else decGo rest (c :: cur) acc
termination_by cs => cs.length
decreasing_by
  · simp
  · simp; omega
  · simp

def decChars (cs : List Char) : Option (List String) := decGo cs [] []

theorem decGo_nl (rest cur : List Char) (acc : List String) :
    decGo ('\n' :: rest) cur acc = decGo rest [] (String.ofList cur.reverse :: acc) := by
  rw [decGo.eq_def]; simp

theorem decGo_esc (d : Char) (rest cur : List Char) (acc : List String) :
    decGo ('\\' :: d :: rest) cur acc
      = decGo rest ((if d = 'n' then '\n' else d) :: cur) acc := by
  rw [decGo.eq_def]; simp

theorem decGo_other {c : Char} (h1 : c ≠ '\n') (h2 : c ≠ '\\')
    (rest cur : List Char) (acc : List String) :
    decGo (c :: rest) cur acc = decGo rest (c :: cur) acc := by
  rw [decGo.eq_def]; simp [h1, h2]

theorem decGo_encTok (t : List Char) :
    ∀ (rest : List Char) (cur : List Char) (acc : List String),
      decGo (encTok t ++ rest) cur acc = decGo rest (t.reverse ++ cur) acc := by
  induction t with
  | nil => intro rest cur acc; simp [encTok]
  | cons c t ih =>
      intro rest cur acc
      have hstep : ∀ (r : List Char) (cu : List Char) (ac : List String),
          decGo (escC c ++ r) cu ac = decGo r (c :: cu) ac := by
        intro r cu ac
        by_cases h1 : c = '\\'
        · subst h1; simpa [escC] using decGo_esc '\\' r cu ac
        · by_cases h2 : c = '\n'
          · subst h2; simpa [escC] using decGo_esc 'n' r cu ac
          · simpa [escC, h1, h2] using decGo_other h2 h1 r cu ac
      calc decGo (encTok (c :: t) ++ rest) cur acc
          = decGo (escC c ++ (encTok t ++ rest)) cur acc := by
            simp [encTok, List.append_assoc]
        _ = decGo (encTok t ++ rest) (c :: cur) acc := hstep _ _ _
        _ = decGo rest (t.reverse ++ (c :: cur)) acc := ih _ _ _
        _ = decGo rest ((c :: t).reverse ++ cur) acc := by simp

theorem decChars_encChars (ts : List String) : decChars (encChars ts) = some ts := by
  have key : ∀ (ts : List String) (acc : List String),
      decGo (encChars ts) [] acc = some (acc.reverse ++ ts) := by
    intro ts
    induction ts with
    | nil => intro acc; simp [encChars, decGo]
    | cons t ts ih =>
        intro acc
        have hsplit : encChars (t :: ts) = encTok t.toList ++ ('\n' :: encChars ts) := by
          simp [encChars]
        rw [hsplit, decGo_encTok t.toList ('\n' :: encChars ts) [] acc, decGo_nl]
        simp only [List.append_nil, List.reverse_reverse, String.ofList_toList]
        rw [ih (t :: acc)]
        simp
  simpa [decChars] using key ts []

/-! ## The shareable text of a workflow -/

/-- Serialize a workflow to shareable text. -/
def share (w : Workflow) : String := String.ofList (encChars (encode w))

/-- Read a shared workflow back. -/
def unshare (s : String) : Option Workflow :=
  match decChars s.toList with
  | some ts => decodeTokens ts
  | none => none

/-- **Sharing is lossless.**  A workflow read back from its shared text is
the workflow that was shared — so the permissions the recipient's tool
will ask for are exactly the ones the sender's recipe implies. -/
theorem unshare_share (w : Workflow) : unshare (share w) = some w := by
  unfold unshare share
  rw [String.toList_ofList, decChars_encChars]
  exact decodeTokens_encode w

/-- Composition survives sharing: sharing two recipes and composing the
results is the same as composing and sharing. -/
theorem unshare_share_seq (w₁ w₂ : Workflow) :
    (do
      let a ← unshare (share w₁)
      let b ← unshare (share w₂)
      pure (Workflow.seq a b)) = some (Workflow.seq w₁ w₂) := by
  simp [unshare_share]

end Share
end CfDeploy
