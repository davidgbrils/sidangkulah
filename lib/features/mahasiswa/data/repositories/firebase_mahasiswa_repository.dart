import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sidangkufix/features/mahasiswa/domain/models/sidang_model.dart';
import 'package:sidangkufix/features/mahasiswa/domain/repositories/mahasiswa_repository.dart';

class FirebaseMahasiswaRepository implements MahasiswaRepository {
  final FirebaseFirestore _firestore;

  FirebaseMahasiswaRepository(this._firestore);

  @override
  Stream<List<SidangModel>> getSidangByMahasiswa(String mahasiswaId) {
    return _firestore
        .collection('sidang')
        .where('mahasiswaId', isEqualTo: mahasiswaId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => SidangModel.fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }

  @override
  Future<void> daftarSidang(SidangModel sidang) async {
    await _firestore.collection('sidang').add(sidang.toFirestore());
  }

  @override
  Future<void> updateSidang(SidangModel sidang) async {
    await _firestore
        .collection('sidang')
        .doc(sidang.id)
        .update(sidang.toFirestore());
  }
}
