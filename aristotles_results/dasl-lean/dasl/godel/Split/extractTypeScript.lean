import Mathlib

set_option pp.all true
-- spec: extractTypeScript : Something -> (Option.{0} String)
def extractTypeScript : Something -> (Option.{0} String) :=
  fun (s : Something) => extractTypeScript.match_1.{1} (fun (s._@.RequestProject.MetaReflective.2140883331._hygCtx._hyg.8 : Something) => Option.{0} String) s (fun (_ : Unit) => Option.some.{0} String "/* TypeScript code */") (fun (x._@.RequestProject.MetaReflective.2140883331._hygCtx._hyg.17 : Something) => Option.none.{0} String)
