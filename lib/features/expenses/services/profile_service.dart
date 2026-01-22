import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileService {
  final picker = ImagePicker();

  Future<void> uploadProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    File file = File(pickedFile.path);
    String uid = FirebaseAuth.instance.currentUser!.uid;

    // Upload dans Firebase Storage
    final ref = FirebaseStorage.instance.ref('profile_images/$uid.jpg');

    await ref.putFile(file);

    // Récupérer l’URL
    String photoUrl = await ref.getDownloadURL();

    // Mettre à jour Firestore
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'photoUrl': photoUrl,
    });
  }
}
