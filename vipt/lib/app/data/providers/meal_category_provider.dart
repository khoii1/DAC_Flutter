import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vipt/app/core/values/values.dart';
import 'package:vipt/app/data/models/category.dart';
import 'package:vipt/app/data/providers/firestoration.dart';

class MealCategoryProvider implements Firestoration<String, Category> {
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
  String get collectionPath => AppValue.mealCategories;

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
    try {
      print('🔍 Fetching meal categories from collection: ${collectionPath}');
      QuerySnapshot<Map<String, dynamic>> raw =
          await _firestore.collection(collectionPath).get();

      print('📊 Found ${raw.docs.length} meal category documents in Firestore');

      List<Category> list = [];
      for (var element in raw.docs) {
        try {
          final data = element.data();
          if (data.isNotEmpty) {
            list.add(Category.fromMap(element.id, data));
          } else {
            print('⚠️ Meal category document ${element.id} has empty data');
          }
        } catch (e) {
          print('❌ Error parsing meal category ${element.id}: $e');
        }
      }

      print('✅ Successfully parsed ${list.length} meal categories');
      return list;
    } on FirebaseException catch (e) {
      print('❌ FirebaseException when fetching meal categories: ${e.code} - ${e.message}');
      if (e.code == 'permission-denied') {
        throw Exception(
            'Permission denied: Cannot access meal categories. Check Firestore security rules for collection "$collectionPath".');
      }
      rethrow;
    } catch (e) {
      print('❌ Error fetching meal categories: $e');
      throw Exception('Error fetching meal categories: $e');
    }
  }

  @override
  Future<Category> update(String id, Category obj) async {
    await _firestore.collection(collectionPath).doc(id).update(obj.toMap());
    return obj;
  }
}
