import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/store_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<StoreModel>> getStores() {
    return _db.collection('stores').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => StoreModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> logClick(String storeId) async {
    await _db.collection('clicks').add({
      'storeId': storeId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
