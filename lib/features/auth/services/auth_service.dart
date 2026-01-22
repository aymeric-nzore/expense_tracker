import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //instance firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  //Inscription
  Future<UserCredential> signUp(
    String email,
    String password,
    String username,
  ) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    //Enregistrement dans firestore
    await _db.collection("users").doc(userCredential.user!.uid).set({
      'username' : username,
      'email' : email,
      'photoUrl' : "",
      "createdAt" : Timestamp.now(),
    });
    return userCredential;
  }

  //Connexion
  Future<UserCredential> signIn(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
  }

  //Déconnexion
  Future<void> logout() async {
    await _auth.signOut();
  }
}
