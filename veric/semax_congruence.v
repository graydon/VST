Require Import veric.base.
Require Import msl.normalize.
Require Import msl.rmaps.
Require Import msl.rmaps_lemmas.
Require Import veric.compcert_rmaps.
Import Mem.
Require Import msl.msl_standard.
Require Import veric.juicy_mem veric.juicy_mem_lemmas veric.juicy_mem_ops.
Require Import veric.res_predicates.
Require Import veric.seplog.
Require Import veric.assert_lemmas.
Require Import veric.Clight_new.
Require Import sepcomp.extspec.
Require Import sepcomp.step_lemmas.
Require Import veric.juicy_extspec.
Require Import veric.expr veric.expr_lemmas.
Require Import veric.semax.
Require Import veric.semax_lemmas.
Require Import veric.Clight_lemmas.
Require Import Coq.Classes.RelationClasses.
(*Require Import veric.SeparationLogicSoundness. *)

Open Local Scope pred.
Open Local Scope nat_scope.

Section extensions.
Context (Espec : OracleKind).

Definition assert_safe_equiv c1 c2 :=
  forall k1 k2,
   (forall gx vx tx,
      assert_safe Espec gx vx tx k1 (construct_rho (filter_genv gx) vx tx) =
      assert_safe Espec gx vx tx k2 (construct_rho (filter_genv gx) vx tx)) ->
   (forall gx vx tx,
      assert_safe Espec gx vx tx (Kseq c1 :: k1) (construct_rho (filter_genv gx) vx tx) =
      assert_safe Espec gx vx tx (Kseq c2 :: k2) (construct_rho (filter_genv gx) vx tx)).

Definition modifiedvars_equiv c1 c2 :=
  forall S, modifiedvars' c1 S = modifiedvars' c2 S.

Definition update_tycon_equiv c1 c2 :=
  forall Delta, update_tycon Delta c1 = update_tycon Delta c2.

Definition semax_equiv c1 c2 :=
  assert_safe_equiv c1 c2 /\
  modifiedvars_equiv c1 c2 /\
  update_tycon_equiv c1 c2.

Lemma safeN_step_jsem_spec: forall gx vx tx n k ora jm,
  @safeN_ _ _ _ _ _ juicy_safety.Hrel (juicy_core_sem cl_core_sem) OK_spec
    gx (S n) ora (State vx tx k) jm <->
  exists c' m', (cl_step gx (State vx tx k) (m_dry jm) c' (m_dry m') /\
  resource_decay (nextblock (m_dry jm)) (m_phi jm) (m_phi m') /\
  level jm = S (level m') /\
  @safeN_ _ _ _ _ _ juicy_safety.Hrel (juicy_core_sem cl_core_sem) OK_spec gx n ora c' m').
Proof.
  intros.
  split; intros.
  - inversion H; subst.
    * exists c', m'.
      simpl in H1.
      unfold jstep in H1.
      destruct H1 as [? [? ?]].
      simpl in H0.
      auto.
    * inversion H1.
    * inversion H0.
  - destruct H as [c' [m' [? [? [? ?]]]]].
    eapply safeN_step; [| eauto].
    simpl.
    unfold jstep.
    auto.
Qed.

Lemma safeN_step_jsem_seq: forall gx vx tx n c1 c2 k ora jm,
  @safeN_ _ _ _ _ _ juicy_safety.Hrel (juicy_core_sem cl_core_sem) OK_spec
    gx (S n) ora (State vx tx (Kseq (Ssequence c1 c2) :: k)) jm =
  @safeN_ _ _ _ _ _ juicy_safety.Hrel (juicy_core_sem cl_core_sem) OK_spec
    gx (S n) ora (State vx tx (Kseq c1 :: Kseq c2 :: k)) jm.
Proof.
  intros.
  apply prop_ext.
  rewrite !safeN_step_jsem_spec.
  split; intros; destruct H as [c' [m' [? ?]]]; exists c', m'; (split; [| auto]); clear H0.
  + inversion H; subst.
    auto.
  + apply step_seq.
    auto.
Qed.

Lemma pred_ext'': forall {A} {agA: ageable A} (P Q: pred A),
  (forall w: A, P w <-> Q w) <-> P = Q.
Proof.
  intros.
  split; intros.
  + apply pred_ext; intro w; rewrite H; auto.
  + rewrite H.
    reflexivity.
Qed.

Lemma assert_safe_equiv_seq: forall c1 c2 c3 c4,
  assert_safe_equiv c1 c2 ->
  assert_safe_equiv c3 c4 ->
  assert_safe_equiv (Ssequence c1 c3) (Ssequence c2 c4).
Proof.
  unfold assert_safe_equiv.
  intros ? ? ? ? ?H ?H k1 k2.
  specialize (H (Kseq c3 :: k1) (Kseq c4 :: k2)).
  specialize (H0 k1 k2).

  intro HH; specialize (H (H0 HH)); clear - H.
  intros gx vx tx; specialize (H gx vx tx).
  apply pred_ext''.
  intros.
  apply (proj2 (@pred_ext'' compcert_rmaps.R.rmap _ _ _)) with (w0 := w) in H.

  unfold assert_safe in H |- *.
  simpl in H |- *.
  split; intros ? ? ? _ ?.

  + unfold jsafeN, juicy_safety.safeN in H, H0 |- *.
    destruct (level w) as [| n]; [apply safeN_0 |].
    rewrite safeN_step_jsem_seq.
    apply H with (ora := ora) (jm := jm); auto; clear - H0.

    intros ? ? _ ?.
    rewrite <- safeN_step_jsem_seq.
    apply H0; auto.

  + unfold jsafeN, juicy_safety.safeN in H, H0 |- *.
    destruct (level w) as [| n]; [apply safeN_0 |].
    rewrite safeN_step_jsem_seq.
    apply H with (ora := ora) (jm := jm); auto; clear - H0.

    intros ? ? _ ?.
    rewrite <- safeN_step_jsem_seq.
    apply H0; auto.
Qed.

Lemma modifiedvars_equiv_seq: forall c1 c2 c3 c4,
  modifiedvars_equiv c1 c2 ->
  modifiedvars_equiv c3 c4 ->
  modifiedvars_equiv (Ssequence c1 c3) (Ssequence c2 c4).
Proof.
  unfold modifiedvars_equiv.
  intros.
  simpl.
  rewrite H0, H.
  reflexivity.
Qed.

Lemma update_tycon_equiv_seq: forall c1 c2 c3 c4,
  update_tycon_equiv c1 c2 ->
  update_tycon_equiv c3 c4 ->
  update_tycon_equiv (Ssequence c1 c3) (Ssequence c2 c4).
Proof.
  unfold update_tycon_equiv.
  intros.
  simpl.
  rewrite H0, H.
  reflexivity.
Qed.

Lemma semax_equiv_seq: forall c1 c2 c3 c4,
  semax_equiv c1 c2 ->
  semax_equiv c3 c4 ->
  semax_equiv (Ssequence c1 c3) (Ssequence c2 c4).
Proof.
  unfold semax_equiv.
  intros.
  repeat split.
  + apply assert_safe_equiv_seq; tauto.
  + apply modifiedvars_equiv_seq; tauto.
  + apply update_tycon_equiv_seq; tauto.
Qed.

Lemma semax_equiv_spec: forall c1 c2,
  semax_equiv c1 c2 ->
  (forall P Q Delta, semax Espec Delta P c1 Q -> semax Espec Delta P c2 Q).
Proof.
  rewrite semax_unfold.
  unfold semax_equiv, assert_safe_equiv, modifiedvars_equiv, update_tycon_equiv.
  intros ? ? [A_EQUIV [M_EQUIV T_EQUIV]] P Q Delta Hc1; intros.
  specialize (Hc1 psi Delta' w TS Prog_OK k F).
  spec Hc1.
  Focus 1. {
    clear - H M_EQUIV.
    unfold closed_wrt_modvars, modifiedvars in H |- *.
    rewrite M_EQUIV.
    assumption.
  } Unfocus.
  spec Hc1.
  Focus 1. {
    clear - H0 T_EQUIV.
    replace (exit_tycon c1 Delta') with (exit_tycon c2 Delta'); [assumption |].
    extensionality ek.
    destruct ek; auto.
    simpl.
    rewrite T_EQUIV; reflexivity.
  } Unfocus.
  clear - A_EQUIV Hc1.
  unfold guard in Hc1 |- *.
  intros te ve ? ? ? ? ?.
  specialize (Hc1 te ve y H a' H0 H1).
    (* This step uses that fact that current function has nothing to do with c1 and c2. *)
  clear - A_EQUIV Hc1.
  specialize (A_EQUIV k k (fun _ _ _ => eq_refl)).
  rewrite <- A_EQUIV.
  assumption.
Qed.




Definition semax_stronger c1 c2 :=
  (forall P Q Delta, semax Espec Delta P c1 Q -> semax Espec Delta P c2 Q) /\
  (forall F, closed_wrt_modvars c2 F -> closed_wrt_modvars c1 F).

Definition semax_equiv c1 c2 := forall P Q Delta,
  semax Espec Delta P c1 Q = semax Espec Delta P c2 Q.

Lemma closed_wrt_modvars_seq_left: forall c1 c2 c3 F,
  (closed_wrt_modvars c2 F -> closed_wrt_modvars c1 F) ->
  (closed_wrt_modvars (Ssequence c2 c3) F -> closed_wrt_modvars (Ssequence c1 c3) F).
Admitted.

Lemma split_and_right_first: forall (P Q: Prop), Q /\ (Q -> P) -> P /\ Q.
Proof.
  intros.
  tauto.
Qed.

Check semax_unfold.
Print guard.
Print funassert.
Print assert_safe.
Print construct_rho.

Lemma semax_equiv_seq_left: forall c1 c2 c3,
  semax_stronger c1 c2 -> semax_stronger (Ssequence c1 c3) (Ssequence c2 c3).
Proof.
  unfold semax_stronger.
  rewrite semax_unfold.
  intros ? ? ? [?H Hclose].

  (* Step 1 *)
  apply split_and_right_first; split.
  Focus 1. {
    clear H.
    intro F; specialize (Hclose F).
    intro; eapply closed_wrt_modvars_seq_left; eauto.
  } Unfocus.
  intros.
  specialize (H1 psi Delta' w TS Prog_OK k F (H0 F H2)).
Print
Print guard.
  pose proof (fun P Q Delta
  specialize (H P Q Delta).
  intros.
*)
End extensions.