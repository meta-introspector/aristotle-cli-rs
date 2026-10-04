import Mathlib

set_option pp.all true
-- spec: IO.userError : String -> IO.Error
def IO.userError : String -> IO.Error :=
  fun (s : String) => IO.Error.userError s
