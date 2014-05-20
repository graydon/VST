Require Import floyd.base.
Require Import floyd.assert_lemmas.
Require Import floyd.client_lemmas.

Local Open Scope logic.

Hint Unfold closed_wrt_modvars : closed.

Lemma closed_wrt_local: forall S P, closed_wrt_vars S P -> closed_wrt_vars S (local P).
Proof.
intros.
hnf in H|-*; intros.
specialize (H _ _ H0).
unfold local, lift1.
f_equal; auto.
Qed.

Lemma closed_wrtl_local: forall S P, closed_wrt_lvars S P -> closed_wrt_lvars S (local P).
Proof.
intros.
hnf in H|-*; intros.
specialize (H _ _ H0).
unfold local, lift1.
f_equal; auto.
Qed.
Hint Resolve closed_wrt_local closed_wrtl_local : closed.

Lemma closed_wrt_lift0: forall {A} S (Q: A), closed_wrt_vars S (lift0 Q).
Proof.
intros.
intros ? ? ?.
unfold lift0; auto.
Qed.
Lemma closed_wrtl_lift0: forall {A} S (Q: A), closed_wrt_lvars S (lift0 Q).
Proof.
intros.
intros ? ? ?.
unfold lift0; auto.
Qed.
Hint Resolve closed_wrt_lift0 closed_wrtl_lift0 : closed.

Lemma closed_wrt_lift0C: forall {B} S (Q: B), 
   closed_wrt_vars S (@liftx (LiftEnviron B) Q).
Proof.
intros.
intros ? ? ?.
unfold_lift; auto.
Qed.
Lemma closed_wrtl_lift0C: forall {B} S (Q: B), 
   closed_wrt_lvars S (@liftx (LiftEnviron B) Q).
Proof.
intros.
intros ? ? ?.
unfold_lift; auto.
Qed.
Hint Resolve @closed_wrt_lift0C @closed_wrtl_lift0C: closed.

Lemma closed_wrt_lift1: forall {A}{B} S (f: A -> B) P, 
        closed_wrt_vars S P -> 
        closed_wrt_vars S (lift1 f P).
Proof.
intros.
intros ? ? ?. specialize (H _ _ H0).
unfold lift1; f_equal; auto.
Qed.
Lemma closed_wrtl_lift1: forall {A}{B} S (f: A -> B) P, 
        closed_wrt_lvars S P -> 
        closed_wrt_lvars S (lift1 f P).
Proof.
intros.
intros ? ? ?. specialize (H _ _ H0).
unfold lift1; f_equal; auto.
Qed.
Hint Resolve closed_wrt_lift1 closed_wrtl_lift1 : closed.

Lemma closed_wrt_lift1C: forall {A}{B} S (f: A -> B) P, 
        closed_wrt_vars S P -> 
        closed_wrt_vars S (@liftx (Tarrow A (LiftEnviron B)) f P).
Proof.
intros.
intros ? ? ?. specialize (H _ _ H0).
unfold_lift; f_equal; auto.
Qed.
Lemma closed_wrtl_lift1C: forall {A}{B} S (f: A -> B) P, 
        closed_wrt_lvars S P -> 
        closed_wrt_lvars S (@liftx (Tarrow A (LiftEnviron B)) f P).
Proof.
intros.
intros ? ? ?. specialize (H _ _ H0).
unfold_lift; f_equal; auto.
Qed.
Hint Resolve @closed_wrt_lift1C @closed_wrtl_lift1C : closed.

Lemma closed_wrt_lift2: forall {A1 A2}{B} S (f: A1 -> A2 -> B) P1 P2, 
        closed_wrt_vars S P1 -> 
        closed_wrt_vars S P2 -> 
        closed_wrt_vars S (lift2 f P1 P2).
Proof.
intros.
intros ? ? ?.
specialize (H _ _ H1).
specialize (H0 _ _ H1).
unfold lift2; f_equal; auto.
Qed.
Lemma closed_wrtl_lift2: forall {A1 A2}{B} S (f: A1 -> A2 -> B) P1 P2, 
        closed_wrt_lvars S P1 -> 
        closed_wrt_lvars S P2 -> 
        closed_wrt_lvars S (lift2 f P1 P2).
Proof.
intros.
intros ? ? ?.
specialize (H _ _ H1).
specialize (H0 _ _ H1).
unfold lift2; f_equal; auto.
Qed.
Hint Resolve closed_wrt_lift2 closed_wrtl_lift2 : closed. 

Lemma closed_wrt_lift2C: forall {A1 A2}{B} S (f: A1 -> A2 -> B) P1 P2, 
        closed_wrt_vars S P1 -> 
        closed_wrt_vars S P2 -> 
        closed_wrt_vars S (@liftx (Tarrow A1 (Tarrow A2 (LiftEnviron B))) f P1 P2).
Proof.
intros.
intros ? ? ?.
specialize (H _ _ H1).
specialize (H0 _ _ H1).
unfold_lift; f_equal; auto.
Qed.
Lemma closed_wrtl_lift2C: forall {A1 A2}{B} S (f: A1 -> A2 -> B) P1 P2, 
        closed_wrt_lvars S P1 -> 
        closed_wrt_lvars S P2 -> 
        closed_wrt_lvars S (@liftx (Tarrow A1 (Tarrow A2 (LiftEnviron B))) f P1 P2).
Proof.
intros.
intros ? ? ?.
specialize (H _ _ H1).
specialize (H0 _ _ H1).
unfold_lift; f_equal; auto.
Qed.
Hint Resolve @closed_wrt_lift2C @closed_wrtl_lift2C : closed.

Lemma closed_wrt_lift3: forall {A1 A2 A3}{B} S (f: A1 -> A2 -> A3 -> B) P1 P2 P3, 
        closed_wrt_vars S P1 -> 
        closed_wrt_vars S P2 -> 
        closed_wrt_vars S P3 -> 
        closed_wrt_vars S (lift3 f P1 P2 P3).
Proof.
intros.
intros ? ? ?.
specialize (H _ _ H2).
specialize (H0 _ _ H2).
specialize (H1 _ _ H2).
unfold lift3; f_equal; auto.
Qed.
Lemma closed_wrtl_lift3: forall {A1 A2 A3}{B} S (f: A1 -> A2 -> A3 -> B) P1 P2 P3, 
        closed_wrt_lvars S P1 -> 
        closed_wrt_lvars S P2 -> 
        closed_wrt_lvars S P3 -> 
        closed_wrt_lvars S (lift3 f P1 P2 P3).
Proof.
intros.
intros ? ? ?.
specialize (H _ _ H2).
specialize (H0 _ _ H2).
specialize (H1 _ _ H2).
unfold lift3; f_equal; auto.
Qed.
Hint Resolve closed_wrt_lift3 closed_wrtl_lift3 : closed. 

Lemma closed_wrt_lift3C: forall {A1 A2 A3}{B} S (f: A1 -> A2 -> A3 -> B) P1 P2 P3, 
        closed_wrt_vars S P1 -> 
        closed_wrt_vars S P2 -> 
        closed_wrt_vars S P3 -> 
        closed_wrt_vars S (@liftx (Tarrow A1 (Tarrow A2 (Tarrow A3 (LiftEnviron B)))) f P1 P2 P3).
Proof.
intros.
intros ? ? ?.
specialize (H _ _ H2).
specialize (H0 _ _ H2).
specialize (H1 _ _ H2).
unfold_lift. f_equal; auto.
Qed.
Lemma closed_wrtl_lift3C: forall {A1 A2 A3}{B} S (f: A1 -> A2 -> A3 -> B) P1 P2 P3, 
        closed_wrt_lvars S P1 -> 
        closed_wrt_lvars S P2 -> 
        closed_wrt_lvars S P3 -> 
        closed_wrt_lvars S (@liftx (Tarrow A1 (Tarrow A2 (Tarrow A3 (LiftEnviron B)))) f P1 P2 P3).
Proof.
intros.
intros ? ? ?.
specialize (H _ _ H2).
specialize (H0 _ _ H2).
specialize (H1 _ _ H2).
unfold_lift. f_equal; auto.
Qed.
Hint Resolve @closed_wrt_lift3C @closed_wrtl_lift3C : closed.

Lemma closed_wrt_lift4: forall {A1 A2 A3 A4}{B} S (f: A1 -> A2 -> A3 -> A4 -> B)
       P1 P2 P3 P4,  
        closed_wrt_vars S P1 -> 
        closed_wrt_vars S P2 -> 
        closed_wrt_vars S P3 -> 
        closed_wrt_vars S P4 -> 
        closed_wrt_vars S (lift4 f P1 P2 P3 P4).
Proof.
intros.
intros ? ? ?.
specialize (H _ _ H3).
specialize (H0 _ _ H3).
specialize (H1 _ _ H3).
specialize (H2 _ _ H3).
unfold lift4; f_equal; auto.
Qed.
Lemma closed_wrtl_lift4: forall {A1 A2 A3 A4}{B} S (f: A1 -> A2 -> A3 -> A4 -> B)
       P1 P2 P3 P4,  
        closed_wrt_lvars S P1 -> 
        closed_wrt_lvars S P2 -> 
        closed_wrt_lvars S P3 -> 
        closed_wrt_lvars S P4 -> 
        closed_wrt_lvars S (lift4 f P1 P2 P3 P4).
Proof.
intros.
intros ? ? ?.
specialize (H _ _ H3).
specialize (H0 _ _ H3).
specialize (H1 _ _ H3).
specialize (H2 _ _ H3).
unfold lift4; f_equal; auto.
Qed.
Hint Resolve closed_wrt_lift4  closed_wrtl_lift4 : closed.

Lemma closed_wrt_lift4C: forall {A1 A2 A3 A4}{B} S (f: A1 -> A2 -> A3 -> A4 -> B) P1 P2 P3 P4, 
        closed_wrt_vars S P1 -> 
        closed_wrt_vars S P2 -> 
        closed_wrt_vars S P3 -> 
        closed_wrt_vars S P4 -> 
        closed_wrt_vars S (@liftx (Tarrow A1 (Tarrow A2 (Tarrow A3 (Tarrow A4 (LiftEnviron B))))) f P1 P2 P3 P4).
Proof.
intros.
intros ? ? ?.
specialize (H _ _ H3).
specialize (H0 _ _ H3).
specialize (H1 _ _ H3).
specialize (H2 _ _ H3).
unfold liftx; simpl.
unfold lift. f_equal; auto.
Qed.
Lemma closed_wrtl_lift4C: forall {A1 A2 A3 A4}{B} S (f: A1 -> A2 -> A3 -> A4 -> B) P1 P2 P3 P4, 
        closed_wrt_lvars S P1 -> 
        closed_wrt_lvars S P2 -> 
        closed_wrt_lvars S P3 -> 
        closed_wrt_lvars S P4 -> 
        closed_wrt_lvars S (@liftx (Tarrow A1 (Tarrow A2 (Tarrow A3 (Tarrow A4 (LiftEnviron B))))) f P1 P2 P3 P4).
Proof.
intros.
intros ? ? ?.
specialize (H _ _ H3).
specialize (H0 _ _ H3).
specialize (H1 _ _ H3).
specialize (H2 _ _ H3).
unfold liftx; simpl.
unfold lift. f_equal; auto.
Qed.
Hint Resolve @closed_wrt_lift4C @closed_wrtl_lift4C : closed.

Lemma closed_wrt_const: 
 forall A (P: A) S, closed_wrt_vars S (fun rho: environ => P).
Proof.
intros. hnf; intros.
simpl. auto.
Qed.
Lemma closed_wrtl_const: 
 forall A (P: A) S, closed_wrt_lvars S (fun rho: environ => P).
Proof.
intros. hnf; intros.
simpl. auto.
Qed.
Hint Resolve @closed_wrt_const @closed_wrtl_const : closed.

Lemma closed_wrt_eval_var:
  forall S id t, closed_wrt_vars S (eval_var id t).
Proof.
unfold closed_wrt_vars, eval_var; intros.
simpl.
auto.
Qed.
Hint Resolve closed_wrt_eval_var : closed.
Lemma closed_wrtl_eval_var:
  forall S id t, ~ S id -> closed_wrt_lvars S (eval_var id t).
Proof.
unfold closed_wrt_lvars, eval_var; intros.
simpl.
destruct (H0 id); [contradiction | ].
rewrite <- H1; auto.
Qed.
Hint Resolve closed_wrtl_eval_var : closed.

Definition expr_closed_wrt_lvars (S: ident -> Prop) (e: expr) : Prop := 
  forall rho ve',  
     (forall i, S i \/ Map.get (ve_of rho) i = Map.get ve' i) ->
     eval_expr e rho = eval_expr e (mkEnviron (ge_of rho) ve' (te_of rho)).

Definition lvalue_closed_wrt_lvars (S: ident -> Prop) (e: expr) : Prop := 
  forall rho ve',  
     (forall i, S i \/ Map.get (ve_of rho) i = Map.get ve' i) ->
     eval_lvalue e rho = eval_lvalue e (mkEnviron (ge_of rho) ve'  (te_of rho)).

Lemma closed_wrt_cmp_ptr : forall S e1 e2 c,
  expr_closed_wrt_vars S e1 ->
  expr_closed_wrt_vars S e2 ->
  closed_wrt_vars S (`(cmp_ptr_no_mem c) (eval_expr e1) (eval_expr e2)).
Proof.
intros. 

unfold closed_wrt_vars. intros.
super_unfold_lift. 
unfold expr_closed_wrt_vars in *. 
specialize (H rho te' H1). 
specialize (H0 rho te' H1). 
unfold cmp_ptr_no_mem. rewrite H0. rewrite H. 
reflexivity. 
Qed. 
Lemma closed_wrtl_cmp_ptr : forall S e1 e2 c,
  expr_closed_wrt_lvars S e1 ->
  expr_closed_wrt_lvars S e2 ->
  closed_wrt_lvars S (`(cmp_ptr_no_mem c) (eval_expr e1) (eval_expr e2)).
Proof.
intros. 

unfold closed_wrt_lvars. intros.
super_unfold_lift. 
unfold expr_closed_wrt_lvars in *. 
specialize (H rho ve' H1). 
specialize (H0 rho ve' H1). 
unfold cmp_ptr_no_mem. rewrite H0. rewrite H. 
reflexivity. 
Qed. 
Hint Resolve closed_wrt_cmp_ptr closed_wrtl_cmp_ptr: closed. 

Lemma closed_wrt_eval_id: forall S i,
    ~ S i -> closed_wrt_vars S (eval_id i).
Proof.
intros.
intros ? ? ?.
unfold eval_id, force_val.
simpl.
destruct (H0 i).
contradiction.
rewrite H1; auto.
Qed.
Lemma closed_wrtl_eval_id: forall S i,
    closed_wrt_lvars S (eval_id i).
Proof.
intros.
intros ? ? ?.
unfold eval_id, force_val.
simpl. auto.
Qed.
Hint Resolve closed_wrt_eval_id closed_wrtl_eval_id : closed.

Lemma closed_wrt_get_result1 :
  forall (S: ident -> Prop) i , ~ S i -> closed_wrt_vars S (get_result1 i).
Proof.
intros. unfold get_result1. simpl.
 hnf; intros.
 simpl. f_equal.
apply (closed_wrt_eval_id _ _ H); auto.
Qed.
Lemma closed_wrtl_get_result1 :
  forall (S: ident -> Prop) i , closed_wrt_lvars S (get_result1 i).
Proof.
intros. unfold get_result1. simpl.
 hnf; intros.
 simpl. f_equal.
Qed.
Hint Resolve closed_wrt_get_result1 closed_wrtl_get_result1 : closed.

Lemma closed_wrt_andp: forall S (P Q: environ->mpred),
  closed_wrt_vars S P -> closed_wrt_vars S Q ->
  closed_wrt_vars S (P && Q).
Proof.
intros; hnf in *; intros.
simpl. f_equal; eauto.
Qed.
Lemma closed_wrtl_andp: forall S (P Q: environ->mpred),
  closed_wrt_lvars S P -> closed_wrt_lvars S Q ->
  closed_wrt_lvars S (P && Q).
Proof.
intros; hnf in *; intros.
simpl. f_equal; eauto.
Qed.
Hint Resolve closed_wrt_andp closed_wrtl_andp : closed.

Lemma closed_wrt_sepcon: forall S (P Q: environ->mpred),
  closed_wrt_vars S P -> closed_wrt_vars S Q ->
  closed_wrt_vars S (P * Q).
Proof.
intros; hnf in *; intros.
simpl. f_equal; eauto.
Qed.
Lemma closed_wrtl_sepcon: forall S (P Q: environ->mpred),
  closed_wrt_lvars S P -> closed_wrt_lvars S Q ->
  closed_wrt_lvars S (P * Q).
Proof.
intros; hnf in *; intros.
simpl. f_equal; eauto.
Qed.
Hint Resolve closed_wrt_sepcon closed_wrtl_sepcon : closed.

Lemma closed_wrt_emp {A} {ND: NatDed A} {SL: SepLog A}:
  forall S, closed_wrt_vars S emp.
Proof. repeat intro. reflexivity. Qed.
Lemma closed_wrtl_emp {A} {ND: NatDed A} {SL: SepLog A}:
  forall S, closed_wrt_lvars S emp.
Proof. repeat intro. reflexivity. Qed.
Hint Resolve (@closed_wrt_emp mpred Nveric Sveric) (@closed_wrtl_emp mpred Nveric Sveric) : closed.

Lemma closed_wrt_globvars:
  forall S v, closed_wrt_vars S (globvars2pred v).
Proof.
intros.
unfold globvars2pred.
induction v; simpl map; auto with closed.
apply closed_wrt_sepcon.
clear; hnf; intros.
unfold globvar2pred; destruct a; simpl.
destruct (ge_of rho i) eqn:?; auto.
destruct p.
destruct (gvar_volatile g) eqn:?; auto.
forget (readonly2share (gvar_readonly g)) as sh.
clear - Heqb.
revert v; induction (gvar_init g); intro; simpl; f_equal; auto.
apply IHv.
Qed.

Lemma closed_wrtl_globvars:
  forall S v, closed_wrt_lvars S (globvars2pred v).
Proof.
intros.
unfold globvars2pred.
induction v; simpl map; auto with closed.
apply closed_wrtl_sepcon.
clear; hnf; intros.
unfold globvar2pred; destruct a; simpl.
destruct (ge_of rho i) eqn:?; auto.
destruct p.
destruct (gvar_volatile g) eqn:?; auto.
forget (readonly2share (gvar_readonly g)) as sh.
clear - Heqb.
revert v; induction (gvar_init g); intro; simpl; f_equal; auto.
apply IHv.
Qed.
Hint Resolve closed_wrt_globvars closed_wrtl_globvars: closed.

Lemma closed_wrt_main_pre:
  forall prog u S, closed_wrt_vars S (main_pre prog u).
Proof.
intros. apply closed_wrt_globvars. Qed.
Lemma closed_wrtl_main_pre:
  forall prog u S, closed_wrt_lvars S (main_pre prog u).
Proof.
intros. apply closed_wrtl_globvars. Qed.
Hint Resolve closed_wrt_main_pre closed_wrtl_main_pre : closed.

Lemma closed_wrt_not1:
  forall (i j: ident), 
   i<>j ->
   not (eq i j).
Proof.
intros.
hnf.
intros; subst; congruence.
Qed.
Hint Resolve closed_wrt_not1 : closed.

Lemma closed_wrt_tc_temp_id :
  forall Delta S e id t, expr_closed_wrt_vars S e ->
                         expr_closed_wrt_vars S (Etempvar id t) ->
             closed_wrt_vars S (tc_temp_id id t Delta e).
Proof.
intros.
hnf in *; intros.
specialize (H _ _ H1); specialize (H0 _ _ H1).
unfold tc_temp_id.
unfold typecheck_temp_id.
simpl in H0.
unfold eval_id in H0.
simpl in H0.
destruct ( (temp_types Delta) ! id) eqn:?; simpl; auto with closed.
destruct p.
repeat rewrite denote_tc_assert_andp.
f_equal.
destruct (is_neutral_cast (implicit_deref t) t0) eqn:?; simpl; auto with closed.
rewrite expr_lemmas.isCastR.
destruct (classify_cast (implicit_deref t) t0) eqn:?; simpl; auto with closed;
 try solve [destruct t0; simpl; auto with closed].
if_tac; simpl; auto with closed.
if_tac; simpl; auto with closed.
unfold_lift. f_equal; auto.
destruct si2; simpl; auto with closed.
unfold_lift. rewrite <- H; auto.
unfold_lift. rewrite <- H; auto.
destruct (is_long_type (implicit_deref t) && is_long_type t0)%bool; simpl; auto with closed.
Qed.

Lemma closed_wrtl_tc_temp_id :
  forall Delta S e id t, expr_closed_wrt_lvars S e ->
                         expr_closed_wrt_lvars S (Etempvar id t) ->
             closed_wrt_lvars S (tc_temp_id id t Delta e).
Proof.
intros.
hnf in *; intros.
specialize (H _ _ H1); specialize (H0 _ _ H1).
unfold tc_temp_id.
unfold typecheck_temp_id.
simpl in H0.
unfold eval_id in H0.
simpl in H0.
destruct ( (temp_types Delta) ! id) eqn:?; simpl; auto with closed.
destruct p.
repeat rewrite denote_tc_assert_andp.
f_equal.
destruct (is_neutral_cast (implicit_deref t) t0) eqn:?; simpl; auto with closed.
rewrite expr_lemmas.isCastR.
destruct (classify_cast (implicit_deref t) t0) eqn:?; simpl; auto with closed;
 try solve [destruct t0; simpl; auto with closed].
if_tac; simpl; auto with closed.
if_tac; simpl; auto with closed.
unfold_lift. f_equal; auto.
destruct si2; simpl; auto with closed.
unfold_lift. rewrite <- H; auto.
unfold_lift. rewrite <- H; auto.
destruct (is_long_type (implicit_deref t) && is_long_type t0)%bool; simpl; auto with closed.
Qed.
Hint Resolve closed_wrt_tc_temp_id closed_wrtl_tc_temp_id : closed.

Lemma expr_closed_tempvar:
 forall S i t, ~ S i -> expr_closed_wrt_vars S (Etempvar i t).
Proof.
intros.
hnf; intros.
simpl. unfold eval_id. f_equal.
destruct (H0 i); auto.
contradiction.
Qed.
Lemma expr_closedl_tempvar:
 forall S i t, expr_closed_wrt_lvars S (Etempvar i t).
Proof.
intros.
hnf; intros.
simpl. unfold eval_id. f_equal.
Qed.
Hint Resolve expr_closed_tempvar expr_closedl_tempvar : closed.

Hint Extern 1 (not (@eq ident _ _)) => (let Hx := fresh in intro Hx; inversion Hx) : closed.

Lemma expr_closed_const_int:
  forall S i t, expr_closed_wrt_vars S (Econst_int i t).
Proof.
intros. unfold expr_closed_wrt_vars. simpl; intros.
super_unfold_lift. auto.
Qed.
Lemma expr_closedl_const_int:
  forall S i t, expr_closed_wrt_lvars S (Econst_int i t).
Proof.
intros. unfold expr_closed_wrt_lvars. simpl; intros.
super_unfold_lift. auto.
Qed.
Hint Resolve expr_closed_const_int expr_closedl_const_int : closed.

Lemma expr_closed_cast: forall S e t, 
     expr_closed_wrt_vars S e -> 
     expr_closed_wrt_vars S (Ecast e t).
Proof.
 unfold expr_closed_wrt_vars; intros.
 simpl.
 super_unfold_lift.
 destruct (H rho te' H0); auto.
Qed.
Lemma expr_closedl_cast: forall S e t, 
     expr_closed_wrt_lvars S e -> 
     expr_closed_wrt_lvars S (Ecast e t).
Proof.
 unfold expr_closed_wrt_lvars; intros.
 simpl.
 super_unfold_lift.
 destruct (H rho ve' H0); auto.
Qed.
Hint Resolve expr_closed_cast expr_closedl_cast : closed.

Lemma expr_closed_field: forall S e f t,
  lvalue_closed_wrt_vars S e ->
  expr_closed_wrt_vars S (Efield e f t).
Proof.
 unfold lvalue_closed_wrt_vars, expr_closed_wrt_vars; intros.
 simpl.
 super_unfold_lift.
 f_equal.
 f_equal. apply H.  auto.
Qed.
Lemma expr_closedl_field: forall S e f t,
  lvalue_closed_wrt_lvars S e ->
  expr_closed_wrt_lvars S (Efield e f t).
Proof.
 unfold lvalue_closed_wrt_lvars, expr_closed_wrt_lvars; intros.
 simpl.
 super_unfold_lift.
 f_equal.
 f_equal. apply H.  auto.
Qed.
Hint Resolve expr_closed_field expr_closedl_field : closed.

Lemma expr_closed_binop: forall S op e1 e2 t, 
     expr_closed_wrt_vars S e1 -> 
     expr_closed_wrt_vars S e2 -> 
     expr_closed_wrt_vars S (Ebinop op e1 e2 t).
Proof.
 unfold expr_closed_wrt_vars; intros.
 simpl.
 super_unfold_lift. f_equal; auto.
Qed.
Lemma expr_closedl_binop: forall S op e1 e2 t, 
     expr_closed_wrt_lvars S e1 -> 
     expr_closed_wrt_lvars S e2 -> 
     expr_closed_wrt_lvars S (Ebinop op e1 e2 t).
Proof.
 unfold expr_closed_wrt_lvars; intros.
 simpl.
 super_unfold_lift. f_equal; auto.
Qed.
Hint Resolve expr_closed_binop expr_closedl_binop : closed.

Lemma expr_closed_unop: forall S op e t, 
     expr_closed_wrt_vars S e -> 
     expr_closed_wrt_vars S (Eunop op e t).
Proof.
 unfold expr_closed_wrt_vars; intros.
 simpl.
 super_unfold_lift. f_equal; auto.
Qed.
Lemma expr_closedl_unop: forall S op e t, 
     expr_closed_wrt_lvars S e -> 
     expr_closed_wrt_lvars S (Eunop op e t).
Proof.
 unfold expr_closed_wrt_lvars; intros.
 simpl.
 super_unfold_lift. f_equal; auto.
Qed.
Hint Resolve expr_closed_unop expr_closedl_unop : closed.

Lemma closed_wrt_stackframe_of:
  forall S f, closed_wrt_vars S (stackframe_of f).
Proof.
intros.
unfold stackframe_of.
induction (fn_vars f); auto.
apply closed_wrt_emp.
apply closed_wrt_sepcon; [ | apply IHl].
clear. destruct a; unfold var_block.
hnf; intros. reflexivity.
Qed.
Hint Resolve closed_wrt_stackframe_of : closed.
 
Definition included {U} (S S': U -> Prop) := forall x, S x -> S' x.

Lemma closed_wrt_TT:
 forall  (S: ident -> Prop),
  closed_wrt_vars S (@TT (environ -> mpred) _).
Proof.
intros. hnf; intros. reflexivity.
Qed.
Lemma closed_wrtl_TT:
 forall  (S: ident -> Prop),
  closed_wrt_lvars S (@TT (environ -> mpred) _).
Proof.
intros. hnf; intros. reflexivity.
Qed.
Hint Resolve closed_wrt_TT closed_wrtl_TT : closed.

Lemma closed_wrt_subset:
  forall (S S': ident -> Prop) (H: included S' S) B (f: environ -> B),
       closed_wrt_vars S f -> closed_wrt_vars S' f.
Proof.
intros. hnf. intros. specialize (H0 rho te').
apply H0.
intro i; destruct (H1 i); auto.
Qed.
Lemma closed_wrtl_subset:
  forall (S S': ident -> Prop) (H: included S' S) B (f: environ -> B),
       closed_wrt_lvars S f -> closed_wrt_lvars S' f.
Proof.
intros. hnf. intros. specialize (H0 rho ve').
apply H0.
intro i; destruct (H1 i); auto.
Qed.
Hint Resolve closed_wrt_subset closed_wrtl_subset : closed.

Lemma closed_wrt_Forall_subset:
  forall S S' (H: included S' S) B (f: list (environ -> B)),
 Forall (closed_wrt_vars S) f ->
 Forall (closed_wrt_vars S') f.
Proof.
induction f; simpl; auto.
intro.
inv H0.
constructor.
apply (closed_wrt_subset _ _ H). auto.
auto.
Qed.
Lemma closed_wrtl_Forall_subset:
  forall S S' (H: included S' S) B (f: list (environ -> B)),
 Forall (closed_wrt_lvars S) f ->
 Forall (closed_wrt_lvars S') f.
Proof.
induction f; simpl; auto.
intro.
inv H0.
constructor.
apply (closed_wrtl_subset _ _ H). auto.
auto.
Qed.

Lemma lvalue_closed_tempvar:
 forall S i t, ~ S i -> lvalue_closed_wrt_vars S (Etempvar i t).
Proof.
simpl; intros.
hnf; intros.
simpl. reflexivity.
Qed.
Lemma lvalue_closedl_tempvar:
 forall S i t, lvalue_closed_wrt_lvars S (Etempvar i t).
Proof.
simpl; intros.
hnf; intros.
simpl. reflexivity.
Qed.
Hint Resolve lvalue_closed_tempvar lvalue_closedl_tempvar : closed.

Lemma expr_closed_addrof: forall S e t, 
     lvalue_closed_wrt_vars S e -> 
     expr_closed_wrt_vars S (Eaddrof e t).
Proof.
 unfold lvalue_closed_wrt_vars, expr_closed_wrt_vars; intros.
 simpl.
 super_unfold_lift. apply H.  auto.
Qed.
Lemma expr_closedl_addrof: forall S e t, 
     lvalue_closed_wrt_lvars S e -> 
     expr_closed_wrt_lvars S (Eaddrof e t).
Proof.
 unfold lvalue_closed_wrt_lvars, expr_closed_wrt_lvars; intros.
 simpl.
 super_unfold_lift. apply H.  auto.
Qed.
Hint Resolve expr_closed_addrof expr_closedl_addrof : closed.

Lemma lvalue_closed_field: forall S e f t,
  lvalue_closed_wrt_vars S e ->
  lvalue_closed_wrt_vars S (Efield e f t).
Proof.
 unfold lvalue_closed_wrt_vars, expr_closed_wrt_vars; intros.
 simpl.
 super_unfold_lift. f_equal; apply H.  auto.
Qed.
Lemma lvalue_closedl_field: forall S e f t,
  lvalue_closed_wrt_lvars S e ->
  lvalue_closed_wrt_lvars S (Efield e f t).
Proof.
 unfold lvalue_closed_wrt_lvars, expr_closed_wrt_lvars; intros.
 simpl.
 super_unfold_lift. f_equal; apply H.  auto.
Qed.
Hint Resolve lvalue_closed_field lvalue_closedl_field : closed.

Lemma lvalue_closed_deref: forall S e t,
  expr_closed_wrt_vars S e ->
  lvalue_closed_wrt_vars S (Ederef e t).
Proof.
 unfold lvalue_closed_wrt_vars, expr_closed_wrt_vars; intros.
 simpl.
 super_unfold_lift. f_equal; apply H.  auto.
Qed.
Lemma lvalue_closedl_deref: forall S e t,
  expr_closed_wrt_lvars S e ->
  lvalue_closed_wrt_lvars S (Ederef e t).
Proof.
 unfold lvalue_closed_wrt_lvars, expr_closed_wrt_lvars; intros.
 simpl.
 super_unfold_lift. f_equal; apply H.  auto.
Qed.
Hint Resolve lvalue_closed_deref lvalue_closedl_deref: closed.

Fixpoint closed_eval_expr (j: ident) (e: expr) : bool :=
 match e with
 | Econst_int i ty => true
 | Econst_long i ty => true
 | Econst_float f ty => true
 | Etempvar id ty => negb (eqb_ident j id)
 | Eaddrof a ty => closed_eval_lvalue j a 
 | Eunop op a ty =>  closed_eval_expr j a
 | Ebinop op a1 a2 ty =>  andb (closed_eval_expr j a1) (closed_eval_expr j a2)
 | Ecast a ty => closed_eval_expr j a
 | Evar id ty => true
 | Ederef a ty => closed_eval_expr j a
 | Efield a i ty => closed_eval_lvalue j a
 end

 with closed_eval_lvalue (j: ident) (e: expr) : bool := 
 match e with 
 | Evar id ty => true
 | Ederef a ty => closed_eval_expr j a
 | Efield a i ty => closed_eval_lvalue j a
 | _  => false
 end.

Lemma closed_eval_expr_e: 
    forall j e, closed_eval_expr j e = true -> closed_wrt_vars (eq j) (eval_expr e)
with closed_eval_lvalue_e: 
    forall j e, closed_eval_lvalue j e = true -> closed_wrt_vars (eq j) (eval_lvalue e).
Proof.
intros j e; clear closed_eval_expr_e; induction e; intros; simpl; auto with closed.
simpl in H. destruct (eqb_ident j i) eqn:?; inv H.
apply Pos.eqb_neq in Heqb. auto with closed.
simpl in H.
rewrite andb_true_iff in H. destruct H.
auto with closed.
intros j e; clear closed_eval_lvalue_e; induction e; intros; simpl; auto with closed.
Qed.

Hint Extern 2 (closed_wrt_vars (eq _) (eval_expr _)) => (apply closed_eval_expr_e; reflexivity) : closed.
Hint Extern 2 (closed_wrt_vars (eq _) (eval_lvalue _)) => (apply closed_eval_lvalue_e; reflexivity) : closed.

Lemma closed_wrt_eval_expr: forall S e,
  expr_closed_wrt_vars S e -> 
  closed_wrt_vars S (eval_expr e).
Proof.
intros.
apply H.
Qed.
(* Hint Resolve closed_wrt_eval_expr : closed. *)

Lemma closed_wrt_lvalue: forall S e,
  access_mode (typeof e) = By_reference ->
  closed_wrt_vars S (eval_expr e) -> closed_wrt_vars S (eval_lvalue e).
Proof.
intros.
destruct e; simpl in *; auto with closed;
unfold closed_wrt_vars in *;
intros; specialize (H0 _ _ H1); clear H1; super_unfold_lift;
unfold deref_noload in *; auto; rewrite H in H0; auto.
Qed.
(* Hint Resolve closed_wrt_lvalue : closed. *)

Lemma closed_wrt_ideq: forall a b e,
  a <> b ->
  closed_eval_expr a e = true ->
  closed_wrt_vars (eq a) (fun rho => !! (eval_id b rho = eval_expr e rho)).
Proof.
intros.
hnf; intros.
simpl. f_equal.
f_equal.
specialize (H1 b).
destruct H1; [contradiction | ].
unfold eval_id; simpl. rewrite H1. auto.
clear b H.
apply closed_eval_expr_e in H0.
apply H0; auto.
Qed.

Hint Extern 2 (closed_wrt_vars (eq _) _) => 
      (apply closed_wrt_ideq; [solve [let Hx := fresh in (intro Hx; inv Hx)] | reflexivity]) : closed.

Lemma closed_wrt_tc_andp:
  forall S a b,
  closed_wrt_vars S (denote_tc_assert a) ->
  closed_wrt_vars S (denote_tc_assert b) ->
  closed_wrt_vars S (denote_tc_assert (tc_andp a b)).
Proof.
 intros.
 hnf; intros.
 repeat rewrite denote_tc_assert_andp; f_equal; auto.
Qed.
 

Lemma closed_wrt_tc_orp:
  forall S a b,
  closed_wrt_vars S (denote_tc_assert a) ->
  closed_wrt_vars S (denote_tc_assert b) ->
  closed_wrt_vars S (denote_tc_assert (tc_orp a b)).
Proof.
 intros.
 hnf; intros.
 repeat rewrite binop_lemmas.denote_tc_assert_orp.
 f_equal; auto.
Qed.

Lemma closed_wrt_tc_bool:
  forall S b e, closed_wrt_vars S (denote_tc_assert (tc_bool b e)).
Proof.
 intros.
 hnf; intros.
 destruct b; simpl; auto.
Qed.

Hint Resolve closed_wrt_tc_andp closed_wrt_tc_orp closed_wrt_tc_bool : closed.

Lemma closed_wrt_tc_isptr:
 forall S e, 
     closed_wrt_vars S (eval_expr e) -> 
     closed_wrt_vars S (denote_tc_assert (tc_isptr e)).
Proof.
 intros.
 hnf; intros.
 specialize (H _ _ H0).
 simpl. unfold_lift. f_equal; auto.
Qed.
Hint Resolve closed_wrt_tc_isptr : closed.

Lemma closed_wrt_tc_iszero:
 forall S e, 
     closed_wrt_vars S (eval_expr e) -> 
     closed_wrt_vars S (denote_tc_assert (tc_iszero e)).
Proof.
 intros.
 hnf; intros.
 specialize (H _ _ H0).
 repeat rewrite binop_lemmas.denote_tc_assert_iszero.
 rewrite <- H; auto.
Qed.
Hint Resolve closed_wrt_tc_iszero : closed.

Lemma closed_wrt_tc_nonzero:
 forall S e, 
     closed_wrt_vars S (eval_expr e) -> 
     closed_wrt_vars S (denote_tc_assert (tc_nonzero e)).
Proof.
 intros.
 hnf; intros.
 specialize (H _ _ H0).
 repeat rewrite binop_lemmas.denote_tc_assert_nonzero.
 rewrite <- H; auto.
Qed.
Hint Resolve closed_wrt_tc_nonzero : closed.

Lemma closed_wrt_binarithType:
  forall S t1 t2 t a b,
  closed_wrt_vars S (denote_tc_assert (binarithType t1 t2 t a b)).
Proof.
 intros.
 unfold binarithType.
 destruct (classify_binarith t1 t2); simpl; auto with closed.
Qed.
Hint Resolve closed_wrt_binarithType : closed.

Lemma closed_wrt_tc_samebase : 
 forall S e1 e2,
 closed_wrt_vars S (eval_expr e1) ->
 closed_wrt_vars S (eval_expr e2) ->
 closed_wrt_vars S (denote_tc_assert (tc_samebase e1 e2)).
Proof.
 intros;  hnf; intros. simpl. unfold_lift. f_equal; auto.
Qed.
Hint Resolve closed_wrt_tc_samebase : closed.

Lemma closed_wrt_tc_ilt:
  forall S e n, 
    closed_wrt_vars S (eval_expr e) ->
    closed_wrt_vars S (denote_tc_assert (tc_ilt e n)).
Proof.
 intros; hnf; intros.
 repeat rewrite binop_lemmas.denote_tc_assert_ilt'.
 simpl. unfold_lift. f_equal. auto.
Qed.
Hint Resolve closed_wrt_tc_ilt : closed.

Lemma closed_wrt_tc_Zge:
  forall S e n, 
    closed_wrt_vars S (eval_expr e) ->
    closed_wrt_vars S (denote_tc_assert (tc_Zge e n)).
Proof.
 intros; hnf; intros.
 simpl. unfold_lift; f_equal; auto.
Qed.
Hint Resolve closed_wrt_tc_Zge : closed.
Lemma closed_wrt_tc_Zle:
  forall S e n, 
    closed_wrt_vars S (eval_expr e) ->
    closed_wrt_vars S (denote_tc_assert (tc_Zle e n)).
Proof.
 intros; hnf; intros.
 simpl. unfold_lift; f_equal; auto.
Qed.
Hint Resolve closed_wrt_tc_Zle : closed.

Lemma closed_wrt_tc_nodivover : 
 forall S e1 e2,
 closed_wrt_vars S (eval_expr e1) ->
 closed_wrt_vars S (eval_expr e2) ->
 closed_wrt_vars S (denote_tc_assert (tc_nodivover e1 e2)).
Proof.
 intros;  hnf; intros.
 repeat rewrite binop_lemmas.denote_tc_assert_nodivover.
 rewrite <- H0; auto. rewrite <- H; auto.
Qed.
Hint Resolve closed_wrt_tc_nodivover : closed.

Lemma closed_wrt_tc_FF:
 forall S e, closed_wrt_vars S (denote_tc_assert (tc_FF e)).
Proof.
 intros. hnf; intros. reflexivity.
Qed.
Hint Resolve closed_wrt_tc_FF : closed.

Lemma closed_wrt_tc_TT:
 forall S, closed_wrt_vars S (denote_tc_assert (tc_TT)).
Proof.
 intros. hnf; intros. reflexivity.
Qed.
Hint Resolve closed_wrt_tc_TT : closed.

Lemma closed_wrt_tc_expr:
  forall Delta j e, closed_eval_expr j e = true ->
             closed_wrt_vars (eq j) (tc_expr Delta e)
 with closed_wrt_tc_lvalue:
  forall Delta j e, closed_eval_lvalue j e = true ->
             closed_wrt_vars (eq j) (tc_lvalue Delta e).
Proof.
* clear closed_wrt_tc_expr.
unfold tc_expr.
induction e; simpl; intros;
try solve [destruct t; simpl; auto with closed].
+
  destruct (access_mode t);  simpl; auto with closed.
  destruct (get_var_type Delta i); simpl; auto with closed.
+
  destruct (negb (type_is_volatile t)); simpl; auto with closed.
  destruct ((temp_types Delta) ! i); simpl; auto with closed.
  destruct (same_base_type t (fst p)); simpl; auto with closed.
  destruct (snd p);  simpl; auto with closed.
  clear -  H.
  hnf; intros.
  specialize (H0 i).
  pose proof (eqb_ident_spec j i).
  destruct (eqb_ident j i); inv H.
  destruct H0. apply H1 in H; inv H.
  unfold denote_tc_initialized;  simpl.
  apply exists_ext; intro v.
  f_equal. rewrite H; auto.
+
 apply closed_wrt_tc_andp; auto with closed.
 apply closed_wrt_tc_lvalue; auto.
+ 
  rewrite andb_true_iff in H. destruct H. 
 specialize (IHe1 H). specialize (IHe2 H0).
 apply closed_eval_expr_e in H; apply closed_eval_expr_e in H0.
 repeat apply closed_wrt_tc_andp; auto with closed.
 unfold isBinOpResultType.
 destruct b; auto 50 with closed;
 try solve [destruct (classify_binarith (typeof e1) (typeof e2)); 
                try destruct s;  auto with closed];
 try solve [destruct (classify_cmp (typeof e1) (typeof e2)); 
                 simpl; auto 50 with closed].
 destruct (classify_add (typeof e1) (typeof e2)); auto 50 with closed.
 destruct (classify_sub (typeof e1) (typeof e2)); auto 50 with closed.
 destruct (classify_shift (typeof e1) (typeof e2)); auto 50 with closed.
 destruct (classify_shift (typeof e1) (typeof e2)); auto 50 with closed.
+
 apply closed_wrt_tc_andp; auto with closed.
 specialize (IHe H).
 apply closed_eval_expr_e in H.
 unfold isCastResultType.
 destruct (classify_cast (typeof e) t); auto with closed;
   try solve [ destruct t; auto with closed].
 if_tac; auto with closed.
 if_tac; auto with closed.
 destruct si2; auto with closed.
 hnf; intros; reflexivity.
+
 clear IHe. 
 destruct (access_mode t); simpl; auto with closed.
 repeat apply closed_wrt_tc_andp; auto with closed.
 apply closed_wrt_tc_lvalue; auto.
 destruct (typeof e); simpl; auto with closed.
 destruct (field_offset i f); simpl; auto with closed.
*
 clear closed_wrt_tc_lvalue.
 unfold tc_lvalue.
 induction e; simpl; intros; auto with closed.
 +
 destruct (get_var_type Delta i); simpl; auto with closed.
 +
 specialize (closed_wrt_tc_expr Delta _ _ H).
 apply closed_eval_expr_e in H.
 auto 50 with closed.
 +
 specialize (IHe H).
 apply closed_eval_lvalue_e in H.
 repeat apply closed_wrt_tc_andp; auto with closed.
 destruct (typeof e); simpl; auto with closed.
 destruct (field_offset i f); simpl; auto with closed.
Qed.

Hint Resolve closed_wrt_tc_expr : closed.
Hint Resolve closed_wrt_tc_lvalue : closed.

Lemma closed_wrt_PROPx:
 forall S P Q, closed_wrt_vars S Q -> closed_wrt_vars S (PROPx P Q).
Proof.
intros.
apply closed_wrt_andp; auto.
hnf; intros. reflexivity.
Qed.
Lemma closed_wrtl_PROPx:
 forall S P Q, closed_wrt_lvars S Q -> closed_wrt_lvars S (PROPx P Q).
Proof.
intros.
apply closed_wrtl_andp; auto.
hnf; intros. reflexivity.
Qed.
Hint Resolve closed_wrt_PROPx closed_wrtl_PROPx: closed.

Lemma closed_wrt_LOCALx:
 forall S Q R, Forall (fun q => closed_wrt_vars S (local q)) Q -> 
                    closed_wrt_vars S R -> 
                    closed_wrt_vars S (LOCALx Q R).
Proof.
intros.
apply closed_wrt_andp; auto.
clear - H.
induction Q; simpl; intros.
auto with closed.
normalize.
inv H.
apply closed_wrt_andp; auto with closed.
Qed.
Lemma closed_wrtl_LOCALx:
 forall S Q R, Forall (fun q => closed_wrt_lvars S (local q)) Q -> 
                    closed_wrt_lvars S R -> 
                    closed_wrt_lvars S (LOCALx Q R).
Proof.
intros.
apply closed_wrtl_andp; auto.
clear - H.
induction Q; simpl; intros.
auto with closed.
normalize.
inv H.
apply closed_wrtl_andp; auto with closed.
Qed.
Hint Resolve closed_wrt_LOCALx closed_wrtl_LOCALx: closed.

Lemma closed_wrt_SEPx: forall S P, 
     Forall (closed_wrt_vars S) P -> closed_wrt_vars S (SEPx P).
Proof.
intros.
induction P; auto.
hnf; intros; reflexivity.
inv H.
unfold SEPx.
rewrite fold_right_cons.
apply closed_wrt_sepcon; auto.
Qed.
Lemma closed_wrtl_SEPx: forall S P, 
     Forall (closed_wrt_lvars S) P -> closed_wrt_lvars S (SEPx P).
Proof.
intros.
induction P; auto.
hnf; intros; reflexivity.
inv H.
unfold SEPx.
rewrite fold_right_cons.
apply closed_wrtl_sepcon; auto.
Qed.
Hint Resolve closed_wrt_SEPx closed_wrtl_SEPx: closed.

Lemma not_not_a_param_i:
  forall (L: list (ident * type)) i,
   In i (map (@fst _ _) L) ->
   ~ not_a_param L i.
Proof.
intros.
intro. apply H0; auto.
Qed.
Hint Resolve not_not_a_param_i : closed.

Lemma in_map_fst1:
 forall (i: ident) (t: type) L, 
   In i (map (@fst _ _) ((i,t)::L)).
Proof.
intros. left. reflexivity.
Qed.
Hint Resolve in_map_fst1 : closed.

Lemma in_map_fst2:
 forall (i: ident) a (L: list (ident*type)), 
   In i (map (@fst _ _) L) ->
   In i (map (@fst _ _) (a::L)).
Proof.
intros; right; auto.
Qed.
Hint Resolve in_map_fst2 : closed.

Ltac precondition_closed :=
 match goal with |- precondition_closed _ _ => idtac end;
 let x := fresh "x" in intro x;
 split;
  repeat match goal with 
          | |- closed_wrt_vars _ (let (y,z) := ?x in _) => is_var x; destruct x
          | |- closed_wrt_lvars _ (let (y,z) := ?x in _) => is_var x; destruct x
          end;
  [simpl not_a_param; auto 50 with closed
  | simpl is_a_local; auto 50 with closed ].