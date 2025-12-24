import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vipt/app/core/values/values.dart';
import 'package:vipt/app/data/models/library_section.dart';
import 'package:vipt/app/data/providers/firestoration.dart';

class LibrarySectionProvider implements Firestoration<String, LibrarySection> {
  final _firestore = FirebaseFirestore.instance;

  /// Stream để lắng nghe thay đổi real-time từ Firestore
  Stream<List<LibrarySection>> streamAll() {
    return _firestore
        .collection(collectionPath)
        .orderBy('order')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => LibrarySection.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  @override
  Future<LibrarySection> add(LibrarySection obj) async {
    await _firestore
        .collection(collectionPath)
        .add(obj.toMap())
        .then((value) => obj.id = value.id);
    return obj;
  }

  @override
  String get collectionPath => AppValue.librarySectionsPath;

  @override
  Future<String> delete(String id) async {
    await _firestore.collection(collectionPath).doc(id).delete();
    return id;
  }

  @override
  Future<LibrarySection> fetch(String id) async {
    final raw = await _firestore.collection(collectionPath).doc(id).get();
    return LibrarySection.fromMap(raw.id, raw.data() ?? {});
  }

  @override
  Future<List<LibrarySection>> fetchAll() async {
    QuerySnapshot<Map<String, dynamic>> raw = await _firestore
        .collection(collectionPath)
        .orderBy('order')
        .get();

    List<LibrarySection> list = [];
    for (var element in raw.docs) {
      list.add(LibrarySection.fromMap(element.id, element.data()));
    }

    return list;
  }

  /// Lấy danh sách sections đang active, sắp xếp theo order
  Future<List<LibrarySection>> fetchActiveSections() async {
    QuerySnapshot<Map<String, dynamic>> raw = await _firestore
        .collection(collectionPath)
        .where('isActive', isEqualTo: true)
        .orderBy('order')
        .get();

    List<LibrarySection> list = [];
    for (var element in raw.docs) {
      list.add(LibrarySection.fromMap(element.id, element.data()));
    }

    return list;
  }

  @override
  Future<LibrarySection> update(String id, LibrarySection obj) async {
    await _firestore.collection(collectionPath).doc(id).update(obj.toMap());
    obj.id = id;
    return obj;
  }
}










