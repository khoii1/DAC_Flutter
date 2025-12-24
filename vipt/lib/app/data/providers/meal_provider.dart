import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vipt/app/core/values/values.dart';
import 'package:vipt/app/data/models/meal.dart';
import 'package:vipt/app/data/providers/firestoration.dart';

class MealProvider implements Firestoration<String, Meal> {
  final _firestore = FirebaseFirestore.instance;

  /// Stream để lắng nghe thay đổi real-time từ Firestore
  Stream<List<Meal>> streamAll() {
    return _firestore.collection(collectionPath).snapshots().map((snapshot) {
      final List<Meal> meals = [];
      for (var doc in snapshot.docs) {
        try {
          meals.add(Meal.fromMap(doc.id, doc.data()));
        } catch (e) {
          // Bỏ qua các document không parse được
          print('Error parsing meal ${doc.id} in stream: $e');
        }
      }
      return meals;
    });
  }

  @override
  Future<Meal> add(Meal obj) async {
    await _firestore
        .collection(collectionPath)
        .add(obj.toMap())
        .then((value) => obj.id = value.id);
    return obj;
  }

  // Deprecated: Use seedMeals() from fake_data.dart instead
  // addFakeDate() async {
  //   for (var meal in mealFakeData) {
  //     await add(meal);
  //   }
  // }

  @override
  String get collectionPath => AppValue.mealsPath;

  @override
  Future<String> delete(String id) async {
    await _firestore.collection(collectionPath).doc(id).delete();
    return id;
  }

  @override
  Future<Meal> fetch(String id) async {
    try {
      final raw = await _firestore.collection(collectionPath).doc(id).get();
      if (!raw.exists) {
        throw Exception('Meal with id $id does not exist');
      }
      return Meal.fromMap(raw.id, raw.data() ?? {});
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        // Log một lần thay vì spam
        rethrow;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Meal>> fetchAll() async {
    try {
      print('🔍 Fetching meals from collection: ${collectionPath}');
      QuerySnapshot<Map<String, dynamic>> raw =
          await _firestore.collection(collectionPath).get();

      print('📊 Found ${raw.docs.length} meal documents in Firestore');

      List<Meal> list = [];
      for (var element in raw.docs) {
        try {
          final data = element.data();
          if (data.isNotEmpty) {
            list.add(Meal.fromMap(element.id, data));
          } else {
            print('⚠️ Meal document ${element.id} has empty data');
          }
        } catch (e) {
          // Bỏ qua các document không parse được, tiếp tục với các document khác
          print('❌ Error parsing meal ${element.id}: $e');
        }
      }

      print('✅ Successfully parsed ${list.length} meals');
      return list;
    } on FirebaseException catch (e) {
      print('❌ FirebaseException when fetching meals: ${e.code} - ${e.message}');
      if (e.code == 'permission-denied') {
        throw Exception(
            'Permission denied: Cannot access meals. Check Firestore security rules for collection "$collectionPath".');
      }
      rethrow;
    } catch (e) {
      print('❌ Error fetching meals: $e');
      throw Exception('Error fetching meals: $e');
    }
  }

  Future<String> fetchByName(String name) async {
    String result = "";
    await _firestore
        .collection(collectionPath)
        .where('name', isEqualTo: name)
        .get()
        .then((value) => result = value.docs.first.id);
    return result;
  }

  @override
  Future<Meal> update(String id, Meal obj) async {
    await _firestore.collection(collectionPath).doc(id).update(obj.toMap());
    obj.id = id;
    return obj;
  }
}
