
Require Import ListSet.

Require Import sepcomp.core_semantics.
Require Import sepcomp.forward_simulations.

Require Import Values.
Require Import Globalenvs.
Require Import Memory.
Require Import AST.
Require Import Events.

Set Implicit Arguments.

Definition runnable {G C M D} (csem: CoreSemantics G C M D) (c: C) :=
  match at_external csem c, safely_halted csem c with 
  | None, None => true
  | _, _ => false
  end.

Local Open Scope Z_scope.

(*This is an [F,V]-independent definition of meminj_preserves_globals*)
Definition meminj_preserves_globals_ind (globals: (block->Prop)*(block->Prop)) f :=
  (forall b, fst globals b -> f b = Some (b, 0)) /\
  (forall b, snd globals b -> f b = Some (b, 0)) /\
  (forall b1 b2 delta, snd globals b2 -> f b1 = Some (b2, delta) -> b1=b2).

Definition genv2blocks {F V: Type} (ge: Genv.t F V) := 
  (fun b => exists id, Genv.find_symbol ge id = Some b,
   fun b => exists gv, Genv.find_var_info ge b = Some gv).

(** RelyGuarantee Simulations *)

Module RelyGuaranteeSimulation. Section RelyGuaranteeSimulation.
 Variables (F1 V1 C1 INIT1 G2 C2 INIT2: Type).
 Variables 
  (sourceC: EffectfulSemantics (Genv.t F1 V1) C1 INIT1)
  (targetC: EffectfulSemantics G2 C2 INIT2) 
  (ge1: Genv.t F1 V1) (ge2: G2) 
  (entry_points: list (val * val * signature))
  (core_data: Type)
  (match_state: core_data -> reserve -> meminj -> C1 -> mem -> C2 -> mem -> Prop).

 Import Forward_simulation_inj_exposed.

 Inductive Sig: Type := Make: forall
  (match_state_runnable: forall cd r j c1 m1 c2 m2,
    match_state cd r j c1 m1 c2 m2 -> 
    runnable sourceC c1 = runnable targetC c2)

  (match_state_inj: forall cd r j c1 m1 c2 m2,
    match_state cd r j c1 m1 c2 m2 -> Mem.inject j m1 m2)

  (match_state_preserves_globals: forall cd r j c1 m1 c2 m2,
    match_state cd r j c1 m1 c2 m2 -> 
    meminj_preserves_globals ge1 j),
  Sig.

End RelyGuaranteeSimulation. End RelyGuaranteeSimulation.

Module StableRelyGuaranteeSimulation. Section StableRelyGuaranteeSimulation.
 Variables (F1 V1 C1 INIT1 G2 C2 INIT2: Type).
 Variables 
  (sourceC: EffectfulSemantics (Genv.t F1 V1) C1 INIT1)
  (targetC: EffectfulSemantics G2 C2 INIT2) 
  (ge1: Genv.t F1 V1) (ge2: G2) 
  (entry_points: list (val * val * signature))
  (core_data: Type)
  (match_state: core_data -> reserve -> meminj -> C1 -> mem -> C2 -> mem -> Prop).

 Import Forward_simulation_inj_exposed.

 Inductive Sig: Type := Make: forall
  (match_state_runnable: forall cd r j c1 m1 c2 m2,
    match_state cd r j c1 m1 c2 m2 -> 
    runnable sourceC c1 = runnable targetC c2)

  (match_state_inj: forall cd r j c1 m1 c2 m2,
    match_state cd r j c1 m1 c2 m2 -> Mem.inject j m1 m2)

  (match_state_preserves_globals: forall cd r j c1 m1 c2 m2,
    match_state cd r j c1 m1 c2 m2 -> 
    meminj_preserves_globals ge1 j)

  (stable: forall (ge1: Genv.t F1 V1) cdC m1 m1' r r' f f' m2 m2' c1 c2,
    (** Rely *)
    Mem.inject f m1 m2 -> 
    meminj_preserves_globals_ind (genv2blocks ge1) f -> 
    Mem.inject f' m1' m2' -> 
    rely sourceC r c1 m1 m1' -> 
    rely sourceC (inject_reserve f r) c1 m2 m2' -> 
    inject_incr f f' -> 
    inject_separated f f' m1 m2 -> 
    reserve_incr r r' -> 
    reserve_separated r r' f' m1 m2 -> 

    (** Match is stable *)
    match_state cdC r f c1 m1 c2 m2 -> 
    match_state cdC r' f' c1 m1' c2 m2'),
  Sig.

End StableRelyGuaranteeSimulation. End StableRelyGuaranteeSimulation.
