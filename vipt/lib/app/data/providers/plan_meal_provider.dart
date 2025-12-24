import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vipt/app/core/values/values.dart';
import 'package:vipt/app/data/models/plan_meal.dart';
import 'package:vipt/app/data/providers/firestoration.dart';

class PlanMealProvider implements Firestoration<String, PlanMeal> {
  final _firestore = FirebaseFirestore.instance;

  @override
  String get collectionPath => AppValue.planMealsPath;

  @override
  Future<PlanMeal> add(PlanMeal obj) async {
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
  Future<PlanMeal> fetch(String id) async {
    final raw = await _firestore.collection(collectionPath).doc(id).get();
    return PlanMeal.fromMap(raw.id, raw.data() ?? {});
  }

  @override
  Future<List<PlanMeal>> fetchAll() async {
    QuerySnapshot<Map<String, dynamic>> raw =
        await _firestore.collection(collectionPath).get();

    List<PlanMeal> list = [];
    for (var element in raw.docs) {
      list.add(PlanMeal.fromMap(element.id, element.data()));
    }

    return list;
  }

  Future<List<PlanMeal>> fetchByListID(String listID) async {
    QuerySnapshot<Map<String, dynamic>> raw = await _firestore
        .collection(collectionPath)
        .where('listID', isEqualTo: listID)
        .get();

    List<PlanMeal> list = [];
    for (var element in raw.docs) {
      list.add(PlanMeal.fromMap(element.id, element.data()));
    }

    return list;
  }

  @override
  Future<PlanMeal> update(String id, PlanMeal obj) async {
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
