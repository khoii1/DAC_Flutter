import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vipt/app/core/values/values.dart';
import 'package:vipt/app/data/models/vipt_user.dart';
import 'package:vipt/app/data/providers/firestoration.dart';

class UserProvider implements Firestoration<String, ViPTUser> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<ViPTUser> add(ViPTUser obj) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception(
            'Permission denied: User must be authenticated to create user data.');
      }
      if (currentUser.uid != obj.id) {
        throw Exception(
            'Permission denied: User ID mismatch. Cannot create user data for different user ID.');
      }
      await _firestore.collection(collectionPath).doc(obj.id).set(obj.toMap());
      return obj;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) {
          throw Exception(
              'Permission denied: User must be authenticated. Please sign in first.');
        }
        if (currentUser.uid != obj.id) {
          throw Exception(
              'Permission denied: User ID mismatch. You can only create data for your own user ID (${currentUser.uid}).');
        }
        throw Exception(
            'Permission denied: Cannot create user. Check Firestore security rules.');
      }
      rethrow;
    }
  }

  @override
  Future<String> delete(String id) {
    throw UnimplementedError();
  }

  @override
  Future<ViPTUser> fetch(String id) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception(
            'Permission denied: User must be authenticated to fetch user data.');
      }
      if (currentUser.uid != id) {
        throw Exception(
            'Permission denied: User ID mismatch. Cannot fetch data for different user ID.');
      }
      final rawData = await _firestore.collection(collectionPath).doc(id).get();
      if (!rawData.exists) {
        throw Exception(
            'User not found: Document with id "$id" does not exist.');
      }
      final data = rawData.data();
      if (data == null) {
        throw Exception(
            'User data is null: Document with id "$id" has no data.');
      }
      return ViPTUser.fromMap(data);
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) {
          throw Exception(
              'Permission denied: User must be authenticated. Please sign in first.');
        }
        if (currentUser.uid != id) {
          throw Exception(
              'Permission denied: User ID mismatch. You can only access your own user data (your ID: ${currentUser.uid}, requested ID: $id).');
        }
        throw Exception(
            'Permission denied: Cannot access user data. Check Firestore security rules.');
      }
      rethrow;
    }
  }

  @override
  Future<ViPTUser> update(String id, ViPTUser obj) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception(
            'Permission denied: User must be authenticated to update user data.');
      }
      if (currentUser.uid != id) {
        throw Exception(
            'Permission denied: User ID mismatch. Cannot update data for different user ID.');
      }
      await _firestore
          .collection(collectionPath)
          .doc(id)
          .update(obj.toMap())
          .then((value) => obj.id = id);
      return obj;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) {
          throw Exception(
              'Permission denied: User must be authenticated. Please sign in first.');
        }
        if (currentUser.uid != id) {
          throw Exception(
              'Permission denied: User ID mismatch. You can only update your own user data (your ID: ${currentUser.uid}, requested ID: $id).');
        }
        throw Exception(
            'Permission denied: Cannot update user. Check Firestore security rules.');
      }
      rethrow;
    }
  }

  @override
  String get collectionPath => AppValue.usersPath;

  Future<bool> checkIfUserExist(String uid) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        // Nếu user chưa đăng nhập, không thể kiểm tra, trả về false
        return false;
      }
      if (currentUser.uid != uid) {
        // Nếu uid không khớp với current user, không thể kiểm tra, trả về false
        return false;
      }
      var doc = await _firestore.collection(collectionPath).doc(uid).get();
      return doc.exists;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        // Nếu permission denied, giả sử user chưa tồn tại (trả về false)
        // Điều này cho phép app tiếp tục flow tạo user mới
        return false;
      }
      // Với các lỗi khác, trả về false để tránh crash
      return false;
    } catch (e) {
      // Với bất kỳ lỗi nào khác, trả về false
      return false;
    }
  }

  @override
  Future<List<ViPTUser>> fetchAll() {
    throw UnimplementedError();
  }
}
