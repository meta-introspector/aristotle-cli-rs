import Mathlib

set_option pp.all true
-- spec: AristotleWeaver.Core.BoundingBox.x : AristotleWeaver.Core.BoundingBox -> Float
def AristotleWeaver.Core.BoundingBox.x : AristotleWeaver.Core.BoundingBox -> Float :=
  fun (self : AristotleWeaver.Core.BoundingBox) => self.1
