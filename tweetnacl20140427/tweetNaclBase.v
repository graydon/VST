Require Import Recdef.
Require Import floyd.proofauto.
Local Open Scope logic.
Require Import List. Import ListNotations.
Require Import general_lemmas.

Require Import split_array_lemmas.
(*Require Import fragments.*)
Require Import ZArith. 

Lemma Zlength_list_repeat' {A} n (v:A): Zlength (list_repeat n v) = Z.of_nat n.
Proof. rewrite Zlength_correct, length_list_repeat; trivial. Qed.

Lemma Zlength_cons' {A} (a:A) l: Zlength (a::l) = 1 + Zlength l.
  do 2 rewrite Zlength_correct. simpl. rewrite Zpos_P_of_succ_nat,<- Z.add_1_l; trivial. Qed.

Lemma isptrD v: isptr v -> exists b ofs, v = Vptr b ofs.
Proof. intros. destruct v; try contradiction. exists b, i; trivial. Qed.

Lemma firstn_Zlength {A} (l:list A) n: (n <= length l)%nat -> Zlength (firstn n l) = Z.of_nat n.
Proof. intros. rewrite Zlength_correct, firstn_length, Min.min_l; trivial. Qed.

Lemma skipn_Zlength {A} (l:list A) n: (n <= length l)%nat -> Zlength (skipn n l) = Zlength l - (Z.of_nat n).
Proof. intros.
       rewrite Zlength_correct, skipn_length.
       rewrite Zlength_correct, Nat2Z.inj_sub; trivial.
Qed.

Lemma map_cons_inv {A B} (f:A -> B) a l fT: 
 (f a:: fT) = map f l -> exists b T, l = b :: T /\ f a = f b /\ fT = map f T.
Proof. destruct l; simpl; intros; inv H.
  exists a0, l. auto. Qed.

Lemma inj_le':
  forall n m : nat, (Z.of_nat n <= Z.of_nat m <-> (n <= m)%nat).
Proof. intros. specialize (Z2Nat.inj_le (Z.of_nat n) (Z.of_nat m)). repeat rewrite Nat2Z.id.
  intros X; apply X; clear X. omega. omega.
Qed.
Lemma Byte_max_unsigned_Int_max_unsigned: Byte.max_unsigned < Int.max_unsigned.
  unfold Byte.max_unsigned, Int.max_unsigned. simpl. omega. Qed.

Lemma force_lengthn_map {A B} (f:A->B) n: forall l d fd,
      fd = f d ->
      force_lengthn n (map f l) fd =
      map f (force_lengthn n l d).
Proof. 
  induction n; simpl; intros. trivial. subst.
  destruct l; simpl; f_equal. erewrite (IHn nil); reflexivity.
  apply IHn; trivial.
Qed.
Lemma force_lengthn_mapN {A B} (f:A->B) n: forall l d fd,
      (n < length l)%nat ->
      force_lengthn n (map f l) fd =
      map f (force_lengthn n l d).
Proof. 
  induction n; simpl; intros. trivial.
  destruct l; simpl in *. omega.
  f_equal. apply IHn; trivial. omega.
Qed.

Lemma In_force_lengthn {A} d u: forall n l, @In A u (force_lengthn n l d) -> In u l \/ u=d.
  Proof. induction n; simpl; intros. contradiction. 
    destruct l. destruct H. subst. right; trivial. apply IHn in H. trivial.
    destruct H. left; left; trivial. apply IHn in H. destruct H. left; right; trivial. right; trivial.
  Qed.
Lemma In_force_lengthn_n {A} d u: forall n l (L:(length l >=n)%nat), @In A u (force_lengthn n l d) -> In u l.
  Proof. induction n; simpl; intros. contradiction. 
    destruct l; simpl in *. omega.
    destruct H. left; trivial. apply IHn in H. right; trivial. omega.
  Qed.
Lemma In_skipn {A} (u:A): forall n l, In u (skipn n l) -> In u l.
  Proof. Transparent skipn.
    induction n; simpl; intros. apply H.
    destruct l. trivial. apply IHn in H. right; trivial.
Qed. 

Lemma nth_force_lengthn':
  forall (A : Type) (n i : nat) (xs : list A) (default d: A) (N: (n < length xs)%nat),
  (0 <= i < n)%nat ->
  @nth A i (@force_lengthn A n xs default) d = @nth A i xs d.
Proof. intros A.
  induction n; simpl; intros. omega. 
  destruct xs; simpl in *. omega. destruct i. trivial.
  rewrite IHn. trivial. omega. omega.
Qed.

Lemma app_Znth1: forall (A : Type) (l l' : list A) (d : A) (n :Z),
           (n < Zlength l) -> Znth n (l ++ l') d = Znth n l d.
Proof. intros. unfold Znth. destruct (zlt n 0). trivial.
       apply app_nth1. apply Z2Nat.inj_lt in H.
         rewrite ZtoNat_Zlength in H. trivial.
         omega.
         apply Zlength_nonneg.
Qed.
         
Lemma app_Znth2: forall (A : Type) (l l' : list A) (d : A) (n : Z),
               (Zlength l <= n) -> Znth n (l ++ l') d = Znth (n - Zlength l) l' d.
Proof. intros. specialize (Zlength_nonneg l); intros. unfold Znth.
       destruct (zlt n 0). omega.
       destruct (zlt (n - Zlength l) 0).
         destruct (Z.sub_le_mono_r (Zlength l) n (Zlength l)) as [? _].
         specialize (H1 H). rewrite Z.sub_diag in H1. remember (n - Zlength l). clear - l0 H1. omega.
       rewrite app_nth2.
        rewrite Z2Nat.inj_sub, ZtoNat_Zlength; trivial.
        apply Z2Nat.inj_le in H; trivial. rewrite ZtoNat_Zlength in H; trivial. clear - g; omega.
Qed.

Lemma nth_extensional {A}: forall l1 l2 (L:length l1 = length l2) (d:A)
         (N: forall i, (0<=i<length l1)%nat -> nth i l1 d = nth i l2 d), l1=l2.
induction l1; intros.
  destruct l2; simpl in L. trivial. omega. 
  destruct l2; simpl in L. omega.
  rewrite (IHl1 l2) with (d:=d).
    specialize (N O). simpl in N. rewrite N; trivial. omega.
    omega.
    intros. apply (N (S i)). simpl; omega.
Qed. 

Lemma Znth_extensional {A} (l1 l2 : list A):
       Zlength l1 = Zlength l2 -> forall d,
       (forall i,
        (0 <= i < Zlength l1) -> Znth i l1 d = Znth i l2 d) -> l1 = l2.
Proof. intros.
  assert (HH: Z.to_nat (Zlength l1) = Z.to_nat (Zlength l2)).
    rewrite H; trivial.
  do 2 rewrite Zlength_correct, Nat2Z.id in HH.
  eapply nth_extensional with (d0:=d). trivial.
  intros. 
  assert (I: 0 <= (Z.of_nat i) < Zlength l1).
    split. apply (Nat2Z.inj_le 0). apply H1. rewrite Zlength_correct. apply Nat2Z.inj_lt. apply H1.
  specialize (H0 _ I). unfold Znth in H0.
  destruct (zlt (Z.of_nat i) 0). omega.
  rewrite Nat2Z.id in H0. trivial.
Qed.

Lemma force_lengthn_app1 {A}: forall n l1 l2 (d:A), length l1 =n -> force_lengthn n (l1 ++ l2) d = l1.
Proof.
  induction n; simpl; intros. destruct l1; simpl in *; trivial. omega.
  destruct l1; simpl in *. omega. rewrite IHn; trivial. omega. 
Qed.   
Lemma map_Znth {A B : Type} (f : A -> B) l d n:
      Znth n (map f l) (f d) = f (Znth n l d).
Proof. unfold Znth. destruct (zlt n 0); simpl. trivial. apply map_nth. Qed.

Lemma Znth_map' {A B : Type} (f : A -> B) d d' i al:
        (0<= i < Zlength al)%Z -> Znth i (map f al) d = f (Znth i al d').
Proof. unfold Znth; intros. destruct (zlt i 0); simpl. omega. apply nth_map'.
  destruct H. rewrite Zlength_correct in H0. apply Z2Nat.inj_lt in H0.
   rewrite Nat2Z.id in H0. assumption. assumption. omega.
Qed.

Lemma listD16 {A} (l:list A): Zlength l = 16 -> 
  exists v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15,
  l = [v0; v1; v2; v3; v4; v5; v6; v7; v8; v9; v10; v11; v12; v13; v14; v15].
Proof. intros.
destruct l. rewrite Zlength_nil in H; omega. exists a. rewrite Zlength_cons' in H.
destruct l. rewrite Zlength_nil in H; omega. exists a0. rewrite Zlength_cons' in H.
destruct l. rewrite Zlength_nil in H; omega. exists a1. rewrite Zlength_cons' in H.
destruct l. rewrite Zlength_nil in H; omega. exists a2. rewrite Zlength_cons' in H.
destruct l. rewrite Zlength_nil in H; omega. exists a3. rewrite Zlength_cons' in H.
destruct l. rewrite Zlength_nil in H; omega. exists a4. rewrite Zlength_cons' in H.
destruct l. rewrite Zlength_nil in H; omega. exists a5. rewrite Zlength_cons' in H.
destruct l. rewrite Zlength_nil in H; omega. exists a6. rewrite Zlength_cons' in H.
destruct l. rewrite Zlength_nil in H; omega. exists a7. rewrite Zlength_cons' in H.
destruct l. rewrite Zlength_nil in H; omega. exists a8. rewrite Zlength_cons' in H.
destruct l. rewrite Zlength_nil in H; omega. exists a9. rewrite Zlength_cons' in H.
destruct l. rewrite Zlength_nil in H; omega. exists a10. rewrite Zlength_cons' in H.
destruct l. rewrite Zlength_nil in H; omega. exists a11. rewrite Zlength_cons' in H.
destruct l. rewrite Zlength_nil in H; omega. exists a12. rewrite Zlength_cons' in H.
destruct l. rewrite Zlength_nil in H; omega. exists a13. rewrite Zlength_cons' in H.
destruct l. rewrite Zlength_nil in H; omega. exists a14. rewrite Zlength_cons' in H.
destruct l; trivial.
rewrite Zlength_cons' in H. specialize (Zlength_nonneg l); intros. omega.
Qed.

Lemma listGE16 {A} (l:list A): 16 <= Zlength l ->
  exists v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 t,
  l = [v0; v1; v2; v3; v4; v5; v6; v7; v8; v9; v10; v11; v12; v13; v14; v15] ++ t
  /\ Zlength t = Zlength l - 16.
Proof. intros.
destruct (listD16 (firstn 16 l)) as 
  [v0 [v1 [v2 [v3 [v4 [v5 [v6 [v7 [v8 [v9 [v10 [v11 [v12 [v13 [v14 [v15 V]]]]]]]]]]]]]]]].
  rewrite (Zlength_firstn 16), Z.max_r, Z.min_l; omega.
  exists v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, (skipn 16 l).
  rewrite <- V, firstn_skipn, (Zlength_skipn 16), (Z.max_r 0 16), Z.max_r; try omega.
  split; trivial.
Qed.

Definition bind {A B} (aopt: option A) (f: A -> option B): option B :=
  match aopt with None => None | Some a => f a end.

Section CombineList.
Variable A: Type.
Variable f: A -> A -> A.

Fixpoint combinelist xs ys :=
  match xs, ys with
    nil, nil => Some nil
  | (u::us),(v::vs) => bind (combinelist us vs) (fun l => Some (f u v :: l))
  | _, _ => None
  end.

Lemma combinelist_Zlength: forall xs ys zs,
  combinelist xs ys = Some zs -> Zlength zs = Zlength xs /\ Zlength ys = Zlength xs.
Proof.
  induction xs; intros; destruct ys; simpl in H; inv H.
  split; trivial.
  unfold bind in *.
  remember (combinelist xs ys). symmetry in Heqo.
  destruct o; inv H1. destruct (IHxs _ _ Heqo). repeat rewrite Zlength_cons'. 
  rewrite H, H0. split; trivial.
Qed.

Lemma combinelist_Some: forall xs ys, length xs = length ys ->
      exists l, combinelist xs ys = Some l.
Proof.
  induction xs; simpl; intros.
    destruct ys; simpl in *. exists nil; trivial. omega.
  destruct ys; simpl in *. omega.
   inversion H; clear H.
   destruct (IHxs _ H1). rewrite H. simpl. eexists; reflexivity.
Qed.

Lemma combinelist_SomeInv: forall xs ys l, combinelist xs ys = Some l -> 
      Zlength xs = Zlength ys.
Proof.
  induction xs; simpl; intros.
    destruct ys; simpl in *. trivial. inversion H.
    destruct ys; simpl in *. inversion H.
    remember (combinelist xs ys). destruct o; symmetry in Heqo; simpl in H.
      inversion H; clear H. apply IHxs in Heqo. do 2 rewrite Zlength_cons'; rewrite Heqo. trivial.
    inversion H.  
Qed.

Lemma combinelist_length:
  forall xs ys l, Some l = combinelist xs ys -> length l = length ys.
Proof. induction xs; intros; destruct ys; simpl in *.
  inv H; trivial. inv H. inv H.
  remember (combinelist xs ys) as q. destruct q; simpl in *. inv H. simpl. rewrite (IHxs _ _ Heqq). trivial.
  inv H.
Qed.

Lemma combinelist_symm (C: forall a b, f a b = f b a): 
      forall xs ys, combinelist xs ys = combinelist ys xs.
Proof. induction xs; intros.
  destruct ys; simpl; trivial.
  destruct ys; simpl; trivial. rewrite C, IHxs. trivial.
Qed.

Lemma combinelist_char_nth: forall xs ys l, combinelist xs ys = Some l ->
  forall i d, (0 <= i < length l)%nat -> nth i l d = f (nth i xs d) (nth i ys d).
Proof. 
  induction xs; simpl; intros.
  destruct ys; inv H; simpl in *. omega.
  destruct ys; inv H; simpl in *.
  remember (combinelist xs ys) as s. symmetry in Heqs.
  destruct s; inv H2. specialize (IHxs _ _ Heqs). simpl in *.
  destruct i; trivial.
  apply IHxs. omega.
Qed.

Lemma combinelist_char_Znth xs ys l (C: combinelist xs ys = Some l)
      i d (L:0 <= i < Zlength l): Znth i l d = f (Znth i xs d) (Znth i ys d).
Proof.
  unfold Znth. 
  destruct (zlt i 0). omega.
  rewrite (combinelist_char_nth _ _ _ C); trivial. 
  split. omega. destruct (Z2Nat.inj_lt i (Zlength l)). omega. omega. 
  rewrite ZtoNat_Zlength in H; apply H. omega.
Qed.
End CombineList.

Lemma shift_two_8 z:
 match z with
 | 0 => 0
 | Z.pos y' => Z.pos y'~0~0~0~0~0~0~0~0
 | Z.neg y' => Z.neg y'~0~0~0~0~0~0~0~0
 end = (z * two_p 8)%Z.
 destruct z; simpl; trivial. f_equal.
  rewrite shift_pos_equiv. simpl; xomega. 
  rewrite shift_pos_equiv. simpl; xomega.
Qed.
Lemma shift_two_8_2 z:
  match z with
  | 0 => 0
  | Z.pos y' => Z.pos y'~0~0~0~0~0~0~0~0~0~0~0~0~0~0~0~0
  | Z.neg y' => Z.neg y'~0~0~0~0~0~0~0~0~0~0~0~0~0~0~0~0
  end = (z * two_p 8 * two_p 8)%Z.
 destruct z; simpl; trivial. f_equal.
  rewrite shift_pos_equiv. simpl; xomega. 
  rewrite shift_pos_equiv. simpl; xomega.
Qed.
Lemma shift_two_8_3 z:
  match z with
  | 0 => 0
  | Z.pos y' => Z.pos y'~0~0~0~0~0~0~0~0~0~0~0~0~0~0~0~0~0~0~0~0~0~0~0~0
  | Z.neg y' => Z.neg y'~0~0~0~0~0~0~0~0~0~0~0~0~0~0~0~0~0~0~0~0~0~0~0~0
  end = (z * two_p 8 * two_p 8 * two_p 8)%Z.
 destruct z; simpl; trivial. f_equal.
  rewrite shift_pos_equiv. simpl; xomega. 
  rewrite shift_pos_equiv. simpl; xomega.
Qed.

Fixpoint iterShr8 u n :=
  match n with O => u
   | S n' => Int.shru (iterShr8 u n') (Int.repr 8)
  end.

Lemma Znth_mapVint: forall l i v, 0<=i< Zlength l -> exists x, Znth i (map Vint l) v = Vint x.
Proof. unfold Znth.
  induction l; simpl; intros.
  rewrite Zlength_correct in H; simpl in *. omega.
  destruct (zlt i 0); subst; simpl in *. omega. clear g.
  remember (Z.to_nat i). destruct n. exists a; trivial.
  rewrite Zlength_cons in H. 
  destruct (zeq i 0); subst.  simpl in Heqn. omega.
  destruct (IHl (i-1) v). omega.
  destruct (zlt (i - 1) 0). subst;  omega.
  rewrite Z2Nat.inj_sub in H0. rewrite <- Heqn in H0. simpl in H0. rewrite <- minus_n_O in H0. 
     rewrite H0. exists x; trivial. omega.
Qed.
(*
Definition upd_intlist i l (v:int) :=
  force_lengthn (nat_of_Z i) l Int.zero ++ v :: skipn (nat_of_Z (i + 1)) l.

(*Lemma upd_intlist_upd_reptype_array i l v il:
      l = map Vint il -> (nat_of_Z i < length il)%nat ->
      upd_reptype_array tuint i l (Vint v) = map Vint (upd_intlist i il v).
Proof. intros. unfold upd_reptype_array, upd_intlist. subst l.
  rewrite map_app, sha_lemmas.skipn_map.
  erewrite <- force_lengthn_mapN; trivial.
Qed.*)
Lemma upd_intlist_length i l v:
  0 <= i -> (Z.to_nat i < length l)%nat ->
  length (upd_intlist i l v) = length l.
Proof. unfold upd_intlist, nat_of_Z; intros.
  rewrite app_length, force_lengthn_length_n; simpl.
  rewrite skipn_length, Z2Nat.inj_add; simpl; trivial.
    rewrite minus_Sn_m. 2: omega.
    assert ((Z.to_nat i + 1 = S(Z.to_nat i))%nat). rewrite plus_comm.  trivial.
    rewrite H1, NPeano.Nat.sub_succ; clear H1.
    rewrite <- le_plus_minus; trivial. omega. omega.
Qed.
Lemma upd_ilist_lookup K: forall l (L:length l = K%nat) i (I: (0<=i<K)%nat) j (J: (0<=j<K)%nat) d v,
   (i=j /\ nth i (upd_intlist (Z.of_nat j) l v) d = v) \/
   (i<>j /\ nth i (upd_intlist (Z.of_nat j) l v) d = nth i l d).
intros. unfold upd_intlist, nat_of_Z; simpl. repeat rewrite Z2Nat.inj_add, Nat2Z.id; try omega.
remember (beq_nat i j) as b. symmetry in Heqb.
destruct b. left. apply beq_nat_true in Heqb. subst; split; trivial. 
  rewrite app_nth2; rewrite force_lengthn_length_n. 2:omega. rewrite minus_diag. trivial.
right. apply beq_nat_false in Heqb. split; trivial. 
destruct (lt_dec i j).
  rewrite app_nth1. simpl in *. rewrite nth_force_lengthn'. trivial. omega. omega. 
  rewrite force_lengthn_length_n. trivial. 
assert ((j < i)%nat) by omega. clear n Heqb. 
  rewrite app_nth2; rewrite force_lengthn_length_n. 2: omega. 
  assert (exists k, (i-j)%nat = S k). exists (pred (i-j)). rewrite <- NPeano.Nat.sub_succ_r, minus_Sn_m, NPeano.Nat.sub_succ; trivial.
  destruct H0. rewrite H0. simpl. rewrite nth_skipn.
  assert ((x + (j + 1) = i)%nat). rewrite plus_comm. rewrite <- plus_assoc.
    assert ((1+x)%nat = S x) by reflexivity. rewrite H1, <- H0, <-le_plus_minus; trivial. clear - H; omega.
  rewrite H1. trivial.
Qed. 
Lemma upd_ilist_Znth_same: forall i l u v, 0<= i< Zlength l -> 
      Znth i (upd_intlist i l u) v = u.
   intros. unfold Znth. if_tac. omega.
   assert (0 <= Z.to_nat i < length l)%nat.
     split; try omega. destruct H. apply Z2Nat.inj_lt in H1. rewrite Zlength_correct, Nat2Z.id in H1. trivial. trivial. omega.
   destruct (upd_ilist_lookup _ l (eq_refl _) _ H1 _ H1 v u); simpl.
      rewrite Z2Nat.id in H2. apply H2. omega.
      destruct H2; omega.
Qed.
Lemma upd_ilist_Znth_diff: forall i j l u v, 0<= i< Zlength l -> 0<= j< Zlength l -> i<>j -> Znth i (upd_intlist j l u) v = Znth i l v.
   intros. unfold Znth. if_tac; trivial.
   assert (0 <= Z.to_nat i < length l)%nat.
     split; try omega. destruct H. apply Z2Nat.inj_lt in H3. rewrite Zlength_correct, Nat2Z.id in H3. trivial. trivial. omega.
   assert (0 <= Z.to_nat j < length l)%nat.
     split; try omega. destruct H0. apply Z2Nat.inj_lt in H4. rewrite Zlength_correct, Nat2Z.id in H4. trivial. trivial. omega.
     
   destruct (upd_ilist_lookup _ l (eq_refl _) _ H3 _ H4 v u).
     destruct H5 as [X _]. assert (Z.of_nat (Z.to_nat i) = Z.of_nat (Z.to_nat j)). rewrite X; trivial.
       do 2 rewrite Z2Nat.id in H5. elim H1; trivial.
       omega. omega. omega.
      rewrite Z2Nat.id in H5. apply H5. omega.
Qed.

Lemma upd_ilist_nth_same: forall i l u v, 0<= i< Zlength l -> 
      nth (Z.to_nat i) (upd_intlist i l u) v = u.
   intros.
   assert (0 <= Z.to_nat i < length l)%nat.
     split; try omega. destruct H. apply Z2Nat.inj_lt in H0. rewrite Zlength_correct, Nat2Z.id in H0. trivial. trivial. omega.
   destruct (upd_ilist_lookup _ l (eq_refl _) _ H0 _ H0 v u); simpl.
      rewrite Z2Nat.id in H1. apply H1. omega.
      destruct H1; omega.
Qed.
Lemma upd_ilist_nth_diff: forall i j l u v, 0<= i< Zlength l -> 0<= j< Zlength l -> i<>j -> nth (Z.to_nat i) (upd_intlist j l u) v = nth (Z.to_nat i) l v.
   intros. 
   assert (0 <= Z.to_nat i < length l)%nat.
     split; try omega. destruct H. apply Z2Nat.inj_lt in H2. rewrite Zlength_correct, Nat2Z.id in H2. trivial. trivial. omega.
   assert (0 <= Z.to_nat j < length l)%nat.
     split; try omega. destruct H0. apply Z2Nat.inj_lt in H3. rewrite Zlength_correct, Nat2Z.id in H3. trivial. trivial. omega.
     
   destruct (upd_ilist_lookup _ l (eq_refl _) _ H2 _ H3 v u).
     destruct H4 as [X _]. assert (Z.of_nat (Z.to_nat i) = Z.of_nat (Z.to_nat j)). rewrite X; trivial.
       do 2 rewrite Z2Nat.id in H4. elim H1; trivial.
       omega. omega. omega.
      rewrite Z2Nat.id in H4. apply H4. omega.
Qed.

(*
Lemma upd_reptype_array_Zlength t i (l : list (reptype t)) (v : reptype t):
  0 <= i < Zlength l -> Zlength (upd_reptype_array t i l v) = Zlength l.
Proof. intros.
  do 2 rewrite Zlength_correct. rewrite (upd_reptype_array_length t); trivial. omega.
  rewrite <- ZtoNat_Zlength. apply Z2Nat.inj_lt; omega.
Qed.
*)
Lemma upd_intlist_Zlength: forall (i : Z) (l : list int) (v : int),
  0 <=i < Zlength l -> Zlength (upd_intlist i l v) = Zlength l.
Proof. intros. do 2 rewrite Zlength_correct. erewrite upd_intlist_length; trivial. omega.
  rewrite <- ZtoNat_Zlength. apply Z2Nat.inj_lt; omega.
Qed.*)