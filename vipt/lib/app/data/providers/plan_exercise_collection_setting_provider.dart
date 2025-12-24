import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vipt/app/core/values/values.dart';
import 'package:vipt/app/data/models/plan_exercise_collection_setting.dart';
import 'package:vipt/app/data/providers/firestoration.dart';

class PlanExerciseCollectionSettingProvider
    implements Firestoration<String, PlanExerciseCollectionSetting> {
  final _firestore = FirebaseFirestore.instance;

  @override
  String get collectionPath => AppValue.planExerciseCollectionSettingsPath;

  @override
  Future<PlanExerciseCollectionSetting> add(
      PlanExerciseCollectionSetting obj) async {
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
  Future<PlanExerciseCollectionSetting> fetch(String id) async {
    final raw = await _firestore.collection(collectionPath).doc(id).get();
    return PlanExerciseCollectionSetting.fromMap(raw.id, raw.data() ?? {});
  }

  @override
  Future<List<PlanExerciseCollectionSetting>> fetchAll() async {
    QuerySnapshot<Map<String, dynamic>> raw =
        await _firestore.collection(collectionPath).get();

    List<PlanExerciseCollectionSetting> list = [];
    for (var element in raw.docs) {
      list.add(PlanExerciseCollectionSetting.fromMap(
          element.id, element.data()));
    }

    return list;
  }

  @override
  Future<PlanExerciseCollectionSetting> update(
      String id, PlanExerciseCollectionSetting obj) async {
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
