import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileService {
  final picker = ImagePicker();

  Future<void> uploadProfileImage() async {
    try {
      // Demander les permissions d'accès à la galerie
      PermissionStatus status;
      
      if (Platform.isAndroid) {
        // Pour Android 13+, utiliser READ_MEDIA_IMAGES
        // Pour les versions antérieures, utiliser STORAGE
        status = await Permission.photos.request();
        
        if (status.isDenied) {
          throw Exception("Permission galerie refusée. Veuillez autoriser l'accès à la galerie.");
        } else if (status.isPermanentlyDenied) {
          openAppSettings();
          throw Exception("Permission galerie refusée définitivement. Veuillez modifier les paramètres.");
        }
      } else if (Platform.isIOS) {
        status = await Permission.photos.request();
        
        if (status.isDenied) {
          throw Exception("Permission galerie refusée. Veuillez autoriser l'accès à la galerie.");
        } else if (status.isPermanentlyDenied) {
          openAppSettings();
          throw Exception("Permission galerie refusée définitivement. Veuillez modifier les paramètres.");
        }
      }

      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile == null) {
        throw Exception("Aucune image sélectionnée");
      }

      File file = File(pickedFile.path);

      // Vérifier que le fichier existe
      if (!await file.exists()) {
        throw Exception("Le fichier image n'existe pas");
      }

      String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

      if (uid.isEmpty) {
        throw Exception("Utilisateur non authentifié");
      }

      // Supprimer l'ancienne photo si elle existe
      try {
        await FirebaseStorage.instance.ref('profile_images/$uid.jpg').delete();
      } catch (e) {
        print("Pas d'ancienne photo à supprimer: $e");
      }

      // Upload dans Firebase Storage
      print("Téléchargement de la photo pour l'utilisateur: $uid");
      final ref = FirebaseStorage.instance.ref('profile_images/$uid.jpg');
      final uploadTask = await ref.putFile(file);

      if (uploadTask.state != TaskState.success) {
        throw Exception("Erreur lors du téléchargement du fichier");
      }

      // Récupérer l'URL
      String photoUrl = await ref.getDownloadURL();

      print("URL reçue: $photoUrl");

      // Mettre à jour Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'photoUrl': photoUrl,
        'photoUrlUpdated': DateTime.now().millisecondsSinceEpoch,
      });

      print("✅ Profil mis à jour avec succès");
    } on FirebaseAuthException catch (e) {
      throw Exception("Erreur d'authentification: ${e.message}");
    } on FirebaseException catch (e) {
      throw Exception("Erreur Firebase: ${e.message}");
    } catch (e) {
      throw Exception("$e");
    }
  }
}
