import Mathlib

set_option pp.all true
-- spec: mkPanicMessageWithDecl : String -> String -> Nat -> Nat -> String -> String
def mkPanicMessageWithDecl : String -> String -> Nat -> Nat -> String -> String :=
  fun (modName : String) (declName : String) (line : Nat) (col : Nat) (msg : String) => String.Internal.append (String.Internal.append (String.Internal.append (String.Internal.append (String.Internal.append (String.Internal.append (String.Internal.append (String.Internal.append (String.Internal.append "PANIC at " declName) " ") modName) ":") (ToString.toString.{0} Nat instToStringNat line)) ":") (ToString.toString.{0} Nat instToStringNat col)) ": ") msg
