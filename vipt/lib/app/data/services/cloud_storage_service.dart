import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CloudStorageService {
  CloudStorageService._privateConstuctor();
  static final CloudStorageService instance =
      CloudStorageService._privateConstuctor();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final String _storageLink = 'gs://vipt-506b2.appspot.com';
  String get storageLink => _storageLink;
  
  /// Upload image from File and return download URL
  Future<String> uploadImage(File file, String path) async {
    try {
      final ref = storage.ref().child(path);
      final uploadTask = await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }
  
  Future<String> uploadImageBytes(Uint8List bytes, String path) async {
    try {
      final ref = storage.ref().child(path);
      final uploadTask = await ref.putData(bytes);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> deleteFile(String path) async {
    try {
      final ref = storage.ref().child(path);
      await ref.delete();
    } catch (e) {
      rethrow;
    }
  }
}
