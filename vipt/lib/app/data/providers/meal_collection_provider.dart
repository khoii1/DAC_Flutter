import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vipt/app/core/values/values.dart';
import 'package:vipt/app/data/models/meal_collection.dart';
import 'package:vipt/app/data/providers/firestoration.dart';

class MealCollectionProvider implements Firestoration<String, MealCollection> {
  final _firestore = FirebaseFirestore.instance;

  /// Stream để lắng nghe thay đổi real-time từ Firestore
  Stream<List<MealCollection>> streamAll() {
    return _firestore.collection(collectionPath).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => MealCollection.fromMap(doc.id, doc.data())).toList();
    });
  }
  @override
  Future<MealCollection> add(MealCollection obj) async {
    await _firestore
        .collection(collectionPath)
        .add(obj.toMap())
        .then((value) => obj.id = value.id);
    return obj;
  }

  @override
  String get collectionPath => AppValue.mealCollections;

  @override
  Future<String> delete(String id) async {
    await _firestore.collection(collectionPath).doc(id).delete();
    return id;
  }

  @override
  Future<MealCollection> fetch(String id) async {
    final raw = await _firestore.collection(collectionPath).doc(id).get();
    return MealCollection.fromMap(raw.id, raw.data() ?? {});
  }

  @override
  Future<List<MealCollection>> fetchAll() async {
    QuerySnapshot<Map<String, dynamic>> raw =
        await _firestore.collection(collectionPath).get();

    List<MealCollection> list = [];
    for (var element in raw.docs) {
      list.add(MealCollection.fromMap(element.id, element.data()));
    }

    return list;
  }

  @override
  Future<MealCollection> update(String id, MealCollection obj) async {
    await _firestore.collection(collectionPath).doc(id).update(obj.toMap());
    return obj;
  }
}
