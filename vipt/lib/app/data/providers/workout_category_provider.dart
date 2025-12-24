import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vipt/app/core/values/values.dart';
import 'package:vipt/app/data/models/category.dart';
import 'package:vipt/app/data/providers/firestoration.dart';

class WorkoutCategoryProvider implements Firestoration<String, Category> {
  final _firestore = FirebaseFirestore.instance;

  /// Stream để lắng nghe thay đổi real-time từ Firestore
  Stream<List<Category>> streamAll() {
    return _firestore.collection(collectionPath).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Category.fromMap(doc.id, doc.data())).toList();
    });
  }

  @override
  Future<Category> add(Category obj) async {
    await _firestore
        .collection(collectionPath)
        .add(obj.toMap())
        .then((value) => obj.id = value.id);
    return obj;
  }

  @override
  String get collectionPath => AppValue.workoutCategoriesPath;

  @override
  Future<String> delete(String id) async {
    await _firestore.collection(collectionPath).doc(id).delete();
    return id;
  }

  @override
  Future<Category> fetch(String id) async {
    final raw = await _firestore.collection(collectionPath).doc(id).get();
    return Category.fromMap(raw.id, raw.data() ?? {});
  }

  @override
  Future<List<Category>> fetchAll() async {
    QuerySnapshot<Map<String, dynamic>> raw =
        await _firestore.collection(collectionPath).get();

    List<Category> list = [];
    for (var element in raw.docs) {
      list.add(Category.fromMap(element.id, element.data()));
    }

    return list;
  }

  @override
  Future<Category> update(String id, Category obj) async {
    await _firestore.collection(collectionPath).doc(id).update(obj.toMap());
    return obj;
  }
}
