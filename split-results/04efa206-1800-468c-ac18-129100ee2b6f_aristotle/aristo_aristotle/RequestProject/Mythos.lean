/-
  Mythos typeclass and Greek mythology instance.
  Translation of the Coq mythos class and greek_athena_mythos instance.
-/
import RequestProject.Network
-- Mythos typeclass
class Mythos
    (t_author : Type)
    (t_mythos : Type)
    (t_archetypes : Type)
    (t_authority : Type)
    (t_authorization : Type)
    (t_region : Type)
    (t_epoch : Type)
    (t_language : Type)
    (t_emotions : Type)
    (t_names : Type)
    (t_prompt_type : Type)
    (t_response_type : Type) where
  create : t_author → t_mythos
  invoke : t_prompt_type → t_response_type
  evoke  : t_prompt_type → t_emotions
  reify  : t_mythos → t_archetypes
-- Archetype classes
class ArchetypeWarriorClass
    (t_warrior : Type)
    (t_monster : Type)
    (t_outcome : Type) where
  fight : t_warrior → t_monster → t_outcome
class ArchetypeWomanClass
    (t_woman : Type)
    (t_man : Type)
    (t_embryo : Type)
    (t_baby : Type) where
  concieve_a : t_woman → t_embryo
  concieve_s : t_woman → t_man → t_embryo
  carry_baby : t_woman → t_embryo → t_baby
  give_birth : t_woman → t_baby
-- Marker classes for regions/epochs/languages/names
class TNamesNil
class TRegionGreece
class TEpochClassical
class TLanguageClassicalGreek
-- Concrete archetype types
inductive ArchetypeWarrior : Type where
  | cadet
  | warrior
inductive ArchetypeWoman : Type where
  | girl
  | woman
inductive ArchetypeWarriorWoman : Type where
  | warriorWoman (a : ArchetypeWarrior) (b : ArchetypeWoman)
-- Greek mythology types
inductive GreekAuthors : Type where
  | otherAuthor
  | homer
inductive GreekMythos : Type where
  | otherMythos
  | mythosOfAthena
inductive GreekKings : Type where
  | otherKing
  | pisistratus
inductive Authorization : Type where
  | authorized
  | unauthorized
inductive Emotions : Type where
  | happy
  | joy
  | sad
-- Total3 record (pair of two types)
structure Total3 (T : Type) (T2 : Type) where
  pra1 : T
  pra2 : T2
def warrior_woman2 := Total3 ArchetypeWarrior ArchetypeWoman
def warrior_woman := ArchetypeWarriorWoman
-- Greek Athena Mythos instance
instance greekAthenaMythos :
    Mythos
      GreekAuthors          -- t_author
      GreekMythos           -- t_mythos
      ArchetypeWarriorWoman -- t_archetypes
      GreekKings            -- t_authority
      Authorization         -- t_authorization
      TRegionGreece         -- t_region
      TEpochClassical       -- t_epoch
      TLanguageClassicalGreek -- t_language
      Emotions              -- t_emotions
      TNamesNil             -- t_names
      SimpleString          -- t_prompt_type
      SimpleString          -- t_response_type
    where
  create (_auth : GreekAuthors) := GreekMythos.mythosOfAthena
  invoke (_prompt : SimpleString) := SimpleString.someString
  evoke (_a : SimpleString) := Emotions.joy
  reify (_a : GreekMythos) := ArchetypeWarriorWoman.warriorWoman ArchetypeWarrior.warrior ArchetypeWoman.woman
-- Archetype typeclass
class ArchetypeType
    (t_name : Type)
    (t_attributes : Type)
    (t_attribute : Type)
    (t_stories : Type)
    (t_story : Type)
    (t_embodiments : Type)
    (t_embodiment : Type)
    (t_identity : Type) where
  attr               : t_identity → t_name → t_attributes
  pay_tribute        : t_identity → t_name → t_attributes
  pay_homage         : t_identity → t_name → t_attributes
  archetype_instance : t_identity → t_name → t_embodiment
  story              : t_name → t_story
