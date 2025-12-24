import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vipt/app/core/values/values.dart';
import 'package:vipt/app/data/models/plan_meal_collection.dart';
import 'package:vipt/app/data/providers/firestoration.dart';

class PlanMealCollectionProvider
    implements Firestoration<String, PlanMealCollection> {
  final _firestore = FirebaseFirestore.instance;

  @override
  String get collectionPath => AppValue.planMealCollectionsPath;

  /// Stream để lắng nghe thay đổi real-time từ Firestore cho tất cả collections
  Stream<List<PlanMealCollection>> streamAll() {
    return _firestore.collection(collectionPath).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => PlanMealCollection.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  /// Stream để lắng nghe thay đổi real-time từ Firestore theo planID
  Stream<List<PlanMealCollection>> streamByPlanID(int planID) {
    return _firestore
        .collection(collectionPath)
        .where('planID', isEqualTo: planID)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PlanMealCollection.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  @override
  Future<PlanMealCollection> add(PlanMealCollection obj) async {
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
  Future<PlanMealCollection> fetch(String id) async {
    final raw = await _firestore.collection(collectionPath).doc(id).get();
    return PlanMealCollection.fromMap(raw.id, raw.data() ?? {});
  }

  @override
  Future<List<PlanMealCollection>> fetchAll() async {
    QuerySnapshot<Map<String, dynamic>> raw =
        await _firestore.collection(collectionPath).get();

    List<PlanMealCollection> list = [];
    for (var element in raw.docs) {
      list.add(PlanMealCollection.fromMap(element.id, element.data()));
    }

    return list;
  }

  Future<List<PlanMealCollection>> fetchByPlanID(int planID) async {
    QuerySnapshot<Map<String, dynamic>> raw = await _firestore
        .collection(collectionPath)
        .where('planID', isEqualTo: planID)
        .get();

    List<PlanMealCollection> list = [];
    for (var element in raw.docs) {
      list.add(PlanMealCollection.fromMap(element.id, element.data()));
    }

    return list;
  }

  @override
  Future<PlanMealCollection> update(String id, PlanMealCollection obj) async {
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
