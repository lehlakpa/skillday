import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillday/models/user_model.dart';

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository(this.auth, this.firestore);

  // REGISTER
  Future<void> register(String fullName, String email, String password) async {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    String uid = userCredential.user!.uid;

    AppUser user = AppUser(uid: uid, fullName: fullName, email: email);

    await firestore.collection("users").doc(uid).set(user.toMap());
  }

  // LOGIN
  Future<void> login(String email, String password) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // LOGOUT
  Future<void> logout() async {
    await auth.signOut();
  }
}
