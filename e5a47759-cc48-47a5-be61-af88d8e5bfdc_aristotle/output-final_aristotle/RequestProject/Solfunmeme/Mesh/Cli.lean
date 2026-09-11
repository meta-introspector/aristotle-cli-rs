import RequestProject.Solfunmeme.Mesh.Net
import RequestProject.Solfunmeme.Mesh.Chart
import RequestProject.Solfunmeme.Mesh.Skin
import RequestProject.Solfunmeme.Mesh.Bundle

/-!
# `solfunmeme-mesh`: the verifying twin of the mesh services

Every service in this game — the browser page, the Termux node, the Linux
daemon, the Cloudflare worker — speaks the format proved in `Mesh.*`.  This
executable is that format, compiled from the very same definitions, so any
card, link, QR set, chart or served page can be re-checked off-line by anybody
who builds this repository.

    solfunmeme-mesh board    QUOTES          merge readings and print the tape
    solfunmeme-mesh gossip   BOARDS SCHED    run a mesh round and print each node
    solfunmeme-mesh card     CODE            decode a card and describe it
    solfunmeme-mesh message  CODE            print the exact signed text
    solfunmeme-mesh check    CODE            structural check and re-encode
    solfunmeme-mesh cosign   CODE KEY SIG    add a co-signature, print new code
    solfunmeme-mesh url      BASE CODE       print a shareable link
    solfunmeme-mesh qr       K CODE          cut the card into QR fragments
    solfunmeme-mesh assemble FRAG...         put fragments back together
    solfunmeme-mesh chart    W H CODE        render the view as SVG
    solfunmeme-mesh weave    RUNTIMEHEX CODE mix runtime and data into a payload
    solfunmeme-mesh unweave  HEX            take a served payload apart
    solfunmeme-mesh vectors                  emit the conformance vectors as JSON

`QUOTES` is a comma separated list of `token:venue:slot:price:size`.
`BOARDS` is `;`-separated lists of quotes, one per node; `SCHED` is a comma
separated list of `i>j` meetings.  A `CODE` is the base-58 card text printed by
`vectors`, `cosign` or the page.
-/

namespace Mesh.Cli

open Mesh Mesh.Codec

/-! ## Small parsers and printers -/

/-- Parse `token:venue:slot:price:size`. -/
def parseQuote (s : String) : Option Quote :=
  match (s.splitOn ":").map String.toNat? with
  | [some t, some v, some sl, some p, some z] =>
      some { token := t, venue := v, slot := sl, price := p, size := z }
  | _ => none

/-- Parse a comma separated list of quotes; the empty text is the empty board. -/
def parseBoard (s : String) : Option Board :=
  let parts := (s.splitOn ",").filter (fun t => !t.trimAscii.toString.isEmpty)
  parts.mapM (fun t => parseQuote t.trimAscii.toString)

/-- Print one quote in the parser's own syntax. -/
def quoteText (q : Quote) : String :=
  String.intercalate ":" [toString q.token, toString q.venue, toString q.slot,
    toString q.price, toString q.size]

/-- Print a board. -/
def boardText (b : Board) : String := String.intercalate "," (b.map quoteText)

/-- Parse `i>j`. -/
def parseMeet (s : String) : Option (Nat × Nat) :=
  match (s.splitOn ">").map String.toNat? with
  | [some i, some j] => some (i, j)
  | _ => none

/-- Parse a gossip schedule. -/
def parseSchedule (s : String) : Option (List (Nat × Nat)) :=
  let parts := (s.splitOn ",").filter (fun t => !t.trimAscii.toString.isEmpty)
  parts.mapM (fun t => parseMeet t.trimAscii.toString)

/-- Parse `;`-separated per-node boards. -/
def parseNet (s : String) : Option Net := (s.splitOn ";").mapM parseBoard

/-- One hex digit. -/
def hexDigit (n : Nat) : Char := "0123456789abcdef".toList[n % 16]!

/-- Bytes as lowercase hex. -/
def hexOfBytes (bs : List UInt8) : String :=
  String.ofList (bs.flatMap (fun b => [hexDigit (b.toNat / 16), hexDigit (b.toNat % 16)]))

/-- The value of a hex digit. -/
def hexValue (c : Char) : Option Nat :=
  "0123456789abcdef".toList.idxOf? c <|> "0123456789ABCDEF".toList.idxOf? c

/-- Hex text back to bytes; `none` on a stray character or an odd length. -/
def bytesOfHex (s : String) : Option (List UInt8) :=
  let rec go : List Char → Option (List UInt8)
    | [] => some []
    | [_] => none
    | a :: b :: rest => do
        let hi ← hexValue a
        let lo ← hexValue b
        let tl ← go rest
        pure (UInt8.ofNat (hi * 16 + lo) :: tl)
  go s.toList

/-- Print a fragment as `idx/total:body`. -/
def fragText (f : Frag) : String := toString f.idx ++ "/" ++ toString f.total ++ ":" ++ f.body

/-- Read a fragment back. -/
def parseFrag (s : String) : Option Frag :=
  match s.splitOn ":" with
  | pos :: rest =>
      match (pos.splitOn "/").map String.toNat? with
      | [some i, some t] => some { idx := i, total := t, body := String.intercalate ":" rest }
      | _ => none
  | _ => none

/-! ## Reports -/

/-- What the tape of a board says about one token. -/
def boardReport (t : Nat) (b : Board) : String :=
  let sel := forToken t b
  "quotes    " ++ toString b.length ++ "\n" ++
  "token     " ++ toString t ++ "\n" ++
  "forToken  " ++ toString sel.length ++ "\n" ++
  "latest    " ++ (match latest t b with
                   | some q => quoteText q
                   | none => "-") ++ "\n" ++
  "size      " ++ toString (totalSize sel) ++ "\n" ++
  "value     " ++ toString (totalValue sel) ++ "\n" ++
  "vwap      " ++ toString (vwap sel) ++ "\n" ++
  "board     " ++ boardText b ++ "\n"

/-- Describe a decoded card. -/
def cardReport (sp : SignedPost) : String :=
  let v := sp.post.view
  "author    " ++ sp.post.author ++ "\n" ++
  "seq       " ++ toString sp.post.seq ++ "\n" ++
  "time      " ++ toString sp.post.time ++ "\n" ++
  "imports   " ++ String.intercalate "," sp.post.imports ++ "\n" ++
  "title     " ++ v.title ++ "\n" ++
  "token     " ++ toString v.token ++ "\n" ++
  "window    " ++ toString v.fromSlot ++ ".." ++ toString v.toSlot ++ "\n" ++
  "quotes    " ++ boardText v.quotes ++ "\n" ++
  "vwap      " ++ toString (vwap v.quotes) ++ "\n" ++
  "signers   " ++ String.intercalate "," (signers sp) ++ "\n" ++
  "wf        " ++ (if Mesh.wf sp.post then "yes" else "no") ++ "\n" ++
  "cardwf    " ++ (if cardWfB sp then "yes" else "no") ++ "\n" ++
  "bytes     " ++ toString (encCard sp).length ++ "\n" ++
  "room      " ++ toString (Mesh.Skin.room sp) ++ "\n" ++
  "message   " ++ message sp.post ++ "\n"

/-! ## Conformance vectors -/

/-- Escape a string for JSON: the fields here are ASCII, so only the quote and
the backslash need care. -/
def jsonEscape (s : String) : String :=
  String.ofList (s.toList.flatMap (fun c =>
    if c = '"' then ['\\', '"'] else if c = '\\' then ['\\', '\\'] else [c]))

/-- A JSON string literal. -/
def js (s : String) : String := "\"" ++ jsonEscape s ++ "\""

/-- A JSON array of strings. -/
def jsList (l : List String) : String := "[" ++ String.intercalate "," (l.map js) ++ "]"

/-- The quotes the vectors are built from. -/
def vq1 : Quote := { token := 1, venue := 7, slot := 314266534, price := 1250, size := 4000000 }
/-- A later reading from the other venue. -/
def vq2 : Quote := { token := 1, venue := 9, slot := 314266536, price := 1310, size := 1500000 }
/-- The newest reading. -/
def vq3 : Quote := { token := 1, venue := 7, slot := 314266540, price := 1290, size := 900000 }

/-- The three-node mesh the vectors gossip over. -/
def vnet : Net := [[vq1, vq2], [vq3], []]

/-- The gossip schedule of the vectors. -/
def vsched : List (Nat × Nat) := [(0, 1), (1, 2)]

/-- The view the vectors publish. -/
def vview : View :=
  { title := "SOLFUNMEME 5m", token := 1, fromSlot := 314266534, toSlot := 314266540,
    quotes := [vq1, vq2, vq3] }

/-- The post the vectors publish. -/
def vpost : Post :=
  { author := "AuthorKey11111111111111111111111", seq := 1, time := 1736974661,
    imports := [], view := vview }

/-- The author's card. -/
def vcard1 : SignedPost :=
  { post := vpost,
    sigs := [{ signer := "AuthorKey11111111111111111111111", sig := "AuthorSig" }] }

/-- The co-signed card. -/
def vcard2 : SignedPost :=
  cosign vcard1 { signer := "ReaderKey1111111111111111111111", sig := "ReaderSig" }

/-- The chart geometry the vectors use. -/
def vgeom : Chart.Geom := { width := 640, height := 240 }

/-- A deterministic cover image for the stego vector. -/
def vcover : List Nat := (List.range (Mesh.Skin.room vcard2)).map (fun i => (i * 7 + 13) % 256)

/-- The page the vectors serve. -/
def vbundle : Mesh.Runtime.Bundle :=
  { runtime := [1, 2, 3, 4, 5], payload := encCard vcard2 }

/-- The conformance vectors, as a JSON document.  `scripts/mesh.js` must
reproduce every field of this from the same inputs. -/
def vectorsJson : String :=
  let carrier := Mesh.Skin.hide vcover vcard2
  "{\"protocol\":" ++ js "solfunmeme-mesh-1" ++
  ",\"domainTag\":" ++ js Mesh.domainTag ++
  ",\"siteTag\":" ++ js Mesh.Runtime.siteTag ++
  ",\"quotes\":" ++ jsList [quoteText vq1, quoteText vq2, quoteText vq3] ++
  ",\"net\":" ++ jsList (vnet.map boardText) ++
  ",\"schedule\":" ++ js "0>1,1>2" ++
  ",\"delivered\":" ++ jsList ((deliver vsched vnet).map boardText) ++
  ",\"unionAll\":" ++ js (boardText (unionAll vnet)) ++
  ",\"latest\":" ++ js (match latest 1 (unionAll vnet) with
                        | some q => quoteText q | none => "-") ++
  ",\"vwap\":" ++ toString (vwap (unionAll vnet)) ++
  ",\"message\":" ++ js (message vpost) ++
  ",\"card1\":" ++ js (toCode vcard1) ++
  ",\"card2\":" ++ js (toCode vcard2) ++
  ",\"cardBytes\":" ++ toString (encCard vcard2).length ++
  ",\"cardHex\":" ++ js (hexOfBytes (encCard vcard2)) ++
  ",\"signers\":" ++ jsList (signers vcard2) ++
  ",\"url\":" ++ js (toUrl "https://solfunmeme.com/m" vcard2) ++
  ",\"fragments\":" ++ jsList ((fragments 120 (toCode vcard2)).map fragText) ++
  ",\"chart\":" ++ js (Chart.render vgeom vview) ++
  ",\"points\":" ++ jsList ((Chart.points vgeom vview).map
      (fun p => toString p.1 ++ "," ++ toString p.2)) ++
  ",\"room\":" ++ toString (Mesh.Skin.room vcard2) ++
  ",\"carrierSum\":" ++ toString (carrier.foldl (· + ·) 0) ++
  ",\"carrierHead\":" ++ jsList ((carrier.take 32).map toString) ++
  ",\"weaveHex\":" ++ js (hexOfBytes (Mesh.Runtime.weave vbundle)) ++
  "}"

/-! ## Entry point -/

/-- Usage text. -/
def usage : String :=
  "solfunmeme-mesh — the verifying twin of the SOLFUNMEME market mesh\n\n" ++
  "  solfunmeme-mesh board    TOKEN QUOTES        merge readings and print the tape\n" ++
  "  solfunmeme-mesh gossip   BOARDS SCHED        run a mesh round, print each node\n" ++
  "  solfunmeme-mesh card     CODE                decode a card and describe it\n" ++
  "  solfunmeme-mesh message  CODE                print the exact signed text\n" ++
  "  solfunmeme-mesh check    CODE                structural check and re-encode\n" ++
  "  solfunmeme-mesh cosign   CODE KEY SIG        add a co-signature\n" ++
  "  solfunmeme-mesh url      BASE CODE           print a shareable link\n" ++
  "  solfunmeme-mesh fragment URL                 the card code inside a link\n" ++
  "  solfunmeme-mesh qr       K CODE              cut the card into QR fragments\n" ++
  "  solfunmeme-mesh assemble FRAG...             put fragments back together\n" ++
  "  solfunmeme-mesh chart    W H CODE            render the view as SVG\n" ++
  "  solfunmeme-mesh weave    RUNTIMEHEX CODE     mix runtime and data\n" ++
  "  solfunmeme-mesh unweave  HEX                 take a served payload apart\n" ++
  "  solfunmeme-mesh vectors                      emit conformance vectors as JSON\n\n" ++
  "QUOTES is token:venue:slot:price:size, comma separated.\n" ++
  "BOARDS is such a list per node, separated by ';'.  SCHED is i>j, comma separated.\n"

/-- Entry point. -/
def main (args : List String) : IO UInt32 := do
  match args with
  | ["vectors"] => IO.println vectorsJson; return 0
  | ["board", tok, qs] =>
      match tok.toNat?, parseBoard qs with
      | some t, some b => IO.print (boardReport t (ingest [] b)); return 0
      | _, _ => IO.eprintln "could not parse board"; return 1
  | ["gossip", boards, sched] =>
      match parseNet boards, parseSchedule sched with
      | some n, some s =>
          let out := deliver s n
          for i in List.range out.length do
            IO.println (toString i ++ "  " ++ boardText (get out i))
          IO.println ("all " ++ boardText (unionAll n))
          return 0
      | _, _ => IO.eprintln "could not parse mesh"; return 1
  | ["card", code] =>
      match ofCode code with
      | some sp => IO.print (cardReport sp); return 0
      | none => IO.eprintln "could not parse card"; return 1
  | ["message", code] =>
      match ofCode code with
      | some sp => IO.println (message sp.post); return 0
      | none => IO.eprintln "could not parse card"; return 1
  | ["check", code] =>
      match ofCode code with
      | none => IO.println "REJECTED unreadable"; return 1
      | some sp =>
          if !cardWfB sp then IO.println "REJECTED not well formed"; return 1
          else if toCode sp != code then
            IO.println "REJECTED not canonical"
            IO.println ("canonical " ++ toCode sp)
            return 1
          else
            IO.println "CARD OK"
            IO.println ("signers   " ++ String.intercalate "," (signers sp))
            IO.println ("message   " ++ message sp.post)
            return 0
  | ["cosign", code, key, sig] =>
      match ofCode code with
      | none => IO.eprintln "could not parse card"; return 1
      | some sp =>
          let sp' := cosign sp { signer := key, sig := sig }
          if signers sp' == signers sp then
            IO.println "REFUSED already signed by that key"
            return 1
          else
            IO.println (toCode sp')
            return 0
  | ["url", base, code] =>
      match ofCode code with
      | some sp => IO.println (toUrl base sp); return 0
      | none => IO.eprintln "could not parse card"; return 1
  | ["fragment", u] => IO.println (fragment u); return 0
  | ["qr", k, code] =>
      match k.toNat? with
      | none => IO.eprintln "could not parse K"; return 1
      | some n =>
          if n == 0 then IO.eprintln "K must be positive"; return 1
          else
            for f in fragments n code do IO.println (fragText f)
            return 0
  | "assemble" :: rest =>
      match rest.mapM parseFrag with
      | none => IO.eprintln "could not parse fragments"; return 1
      | some fs =>
          match assemble fs with
          | some code => IO.println code; return 0
          | none => IO.println "REJECTED incomplete or out of order"; return 1
  | ["chart", w, h, code] =>
      match w.toNat?, h.toNat?, ofCode code with
      | some wn, some hn, some sp =>
          IO.println (Chart.render { width := wn, height := hn } sp.post.view); return 0
      | _, _, _ => IO.eprintln "could not parse chart request"; return 1
  | ["weave", rt, code] =>
      match bytesOfHex rt, ofCode code with
      | some r, some sp =>
          IO.println (hexOfBytes (Mesh.Runtime.weave { runtime := r, payload := encCard sp }))
          return 0
      | _, _ => IO.eprintln "could not parse page"; return 1
  | ["unweave", hex] =>
      match bytesOfHex hex with
      | none => IO.eprintln "could not parse hex"; return 1
      | some bs =>
          match Mesh.Runtime.unweave bs with
          | none => IO.println "REJECTED unreadable payload"; return 1
          | some b =>
              IO.println ("runtime   " ++ hexOfBytes b.runtime)
              match readCard b.payload with
              | some (sp, _) => IO.println ("card      " ++ toCode sp); return 0
              | none => IO.println "card      (unreadable)"; return 1
  | _ => IO.print usage; return 0

end Mesh.Cli

/-- `lake exe solfunmeme-mesh` -/
def main (args : List String) : IO UInt32 := Mesh.Cli.main args
