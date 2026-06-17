import Mathlib

set_option pp.all true
-- spec: String.push : String -> Char -> String
def String.push : String -> Char -> String :=
  fun (x._@.Init.Data.String.Bootstrap.1061955010._hygCtx._hyg.7 : String) (x._@.Init.Data.String.Bootstrap.1061955010._hygCtx._hyg.8 : Char) => String.push.match_1.{1} (fun (x._@.Init.Data.String.Bootstrap.1061955010._hygCtx.7.Init.Data.String.Bootstrap.1061955010._hygCtx._hyg.26 : String) (x._@.Init.Data.String.Bootstrap.1061955010._hygCtx.8.Init.Data.String.Bootstrap.1061955010._hygCtx._hyg.29 : Char) => String) x._@.Init.Data.String.Bootstrap.1061955010._hygCtx._hyg.7 x._@.Init.Data.String.Bootstrap.1061955010._hygCtx._hyg.8 (fun (b : ByteArray) (h : ByteArray.IsValidUTF8 b) (c : Char) => String.ofByteArray (ByteArray.append b (List.utf8Encode (List.cons.{0} Char c (List.nil.{0} Char)))) (String.push._proof_5 b h c))
