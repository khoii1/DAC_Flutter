import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vipt/app/core/values/values.dart';
import 'package:vipt/app/data/models/plan_exercise_collection.dart';
import 'package:vipt/app/data/providers/firestoration.dart';

class PlanExerciseCollectionProvider
    implements Firestoration<String, PlanExerciseCollection> {
  final _firestore = FirebaseFirestore.instance;

  @override
  String get collectionPath => AppValue.planExerciseCollectionsPath;

  /// Stream để lắng nghe thay đổi real-time từ Firestore cho tất cả collections
  Stream<List<PlanExerciseCollection>> streamAll() {
    return _firestore.collection(collectionPath).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => PlanExerciseCollection.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  /// Stream để lắng nghe thay đổi real-time từ Firestore theo planID
  Stream<List<PlanExerciseCollection>> streamByPlanID(int planID) {
    return _firestore
        .collection(collectionPath)
        .where('planID', isEqualTo: planID)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PlanExerciseCollection.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  @override
  Future<PlanExerciseCollection> add(PlanExerciseCollection obj) async {
    await _firestore
        .collection(collectionPath)
        .add(obj.toMap())
        .then((value) => obj.id = value.id);
    return obj;
  }

  @override
  Future<String> delete(String id) async {
    await _firestore.collection(collectionPath).doc(id).delete();
    return id;
  }

  @override
  Future<PlanExerciseCollection> fetch(String id) async {
    final raw = await _firestore.collection(collectionPath).doc(id).get();
    return PlanExerciseCollection.fromMap(raw.id, raw.data() ?? {});
  }

  @override
  Future<List<PlanExerciseCollection>> fetchAll() async {
    QuerySnapshot<Map<String, dynamic>> raw =
        await _firestore.collection(collectionPath).get();

    List<PlanExerciseCollection> list = [];
    for (var element in raw.docs) {
      list.add(PlanExerciseCollection.fromMap(element.id, element.data()));
    }

    return list;
  }

  Future<List<PlanExerciseCollection>> fetchByPlanID(int planID) async {
    QuerySnapshot<Map<String, dynamic>> raw = await _firestore
        .collection(collectionPath)
        .where('planID', isEqualTo: planID)
        .get();

    List<PlanExerciseCollection> list = [];
    for (var element in raw.docs) {
      list.add(PlanExerciseCollection.fromMap(element.id, element.data()));
    }

    return list;
  }

  @override
  Future<PlanExerciseCollection> update(
      String id, PlanExerciseCollection obj) async {
    await _firestore.collection(collectionPath).doc(id).update(obj.toMap());
    return obj;
  }

  Future<void> deleteAll() async {
    final snapshot = await _firestore.collection(collectionPath).get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
