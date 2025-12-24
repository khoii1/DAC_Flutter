import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vipt/app/core/values/values.dart';
import 'package:vipt/app/data/models/plan_exercise.dart';
import 'package:vipt/app/data/providers/firestoration.dart';

class PlanExerciseProvider implements Firestoration<String, PlanExercise> {
  final _firestore = FirebaseFirestore.instance;

  @override
  String get collectionPath => AppValue.planExercisesPath;

  @override
  Future<PlanExercise> add(PlanExercise obj) async {
    try {
      await _firestore
          .collection(collectionPath)
          .add(obj.toMap())
          .then((value) => obj.id = value.id);
      return obj;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw Exception(
            'Permission denied: Cannot create plan exercise. Check Firestore security rules.');
      }
      rethrow;
    }
  }

  @override
  Future<String> delete(String id) async {
    try {
      await _firestore.collection(collectionPath).doc(id).delete();
      return id;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw Exception(
            'Permission denied: Cannot delete plan exercise. Check Firestore security rules.');
      }
      rethrow;
    }
  }

  @override
  Future<PlanExercise> fetch(String id) async {
    try {
      final raw = await _firestore.collection(collectionPath).doc(id).get();
      if (!raw.exists || raw.data() == null) {
        throw Exception('PlanExercise not found: $id');
      }
      return PlanExercise.fromMap(raw.id, raw.data()!);
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw Exception(
            'Permission denied: Cannot access plan exercises. Check Firestore security rules.');
      }
      rethrow;
    }
  }

  @override
  Future<List<PlanExercise>> fetchAll() async {
    try {
      QuerySnapshot<Map<String, dynamic>> raw =
          await _firestore.collection(collectionPath).get();

      List<PlanExercise> list = [];
      for (var element in raw.docs) {
        list.add(PlanExercise.fromMap(element.id, element.data()));
      }

      return list;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print(
            '⚠️ Permission denied: Cannot access plan exercises. Returning empty list.');
        return [];
      }
      rethrow;
    }
  }

  Future<List<PlanExercise>> fetchByListID(String listID) async {
    try {
      QuerySnapshot<Map<String, dynamic>> raw = await _firestore
          .collection(collectionPath)
          .where('listID', isEqualTo: listID)
          .get();

      List<PlanExercise> list = [];
      for (var element in raw.docs) {
        list.add(PlanExercise.fromMap(element.id, element.data()));
      }

      return list;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print(
            '⚠️ Permission denied: Cannot access plan exercises with listID: $listID. Returning empty list.');
        return [];
      }
      rethrow;
    }
  }

  @override
  Future<PlanExercise> update(String id, PlanExercise obj) async {
    try {
      await _firestore.collection(collectionPath).doc(id).update(obj.toMap());
      return obj;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw Exception(
            'Permission denied: Cannot update plan exercise. Check Firestore security rules.');
      }
      rethrow;
    }
  }

  Future<void> deleteAll() async {
    try {
      final snapshot = await _firestore.collection(collectionPath).get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw Exception(
            'Permission denied: Cannot delete plan exercises. Check Firestore security rules.');
      }
      rethrow;
    }
  }
}
