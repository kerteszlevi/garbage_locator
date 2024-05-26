import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/garbage.dart';
import 'garbage_repository.dart';

class FirebaseGarbageRepository implements GarbageRepository<Garbage> {
  late final CollectionReference _garbageCollection;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  @override
  Future<void> init() async {
    _garbageCollection = FirebaseFirestore.instance.collection('garbage');
  }

  @override
  Future<void> deleteGarbage(Garbage garbage) async {
    await _garbageCollection.doc(garbage.id).delete();
  }

  @override
  Future<List<Garbage>> getAllGarbage() async {
    QuerySnapshot querySnapshot = await _garbageCollection.get();
    return querySnapshot.docs
        .map((doc) => Garbage.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Garbage> getGarbage(String id) async {
    DocumentSnapshot docSnapshot = await _garbageCollection.doc(id).get();
    return Garbage.fromJson(docSnapshot.data() as Map<String, dynamic>);
  }

  @override
  Future<void> insertGarbage(Garbage garbage) async {
    final imageUrl = await uploadImage(File(garbage.imagePath));
    final garbageWithImage = garbage.copyWith(imagePath: imageUrl);
    await _garbageCollection
        .doc(garbageWithImage.id)
        .set(garbageWithImage.toJson());
  }

  Future<String> uploadImage(File imageFile) async {
    final imageName = "${Uuid().v4()}.jpg";
    final imageRef = _storage.ref().child("images/$imageName");
    await imageRef.putFile(imageFile);
    final downloadUrl = await imageRef.getDownloadURL();
    return downloadUrl;
  }

  @override
  Future<List<Garbage>> getAllAuthorGarbage(String author) async {
    QuerySnapshot querySnapshot =
        await _garbageCollection.where('author', isEqualTo: author).get();
    return querySnapshot.docs
        .map((doc) => Garbage.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Stream<List<Garbage>> getAllAuthorGarbageStream(String author) {
    return _garbageCollection
        .where('author', isEqualTo: author)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Garbage.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    }).handleError((error) {
      print('Error in getAllAuthorGarbageStream: $error');
    });
  }

  @override
  Future<void> likeGarbage(String garbageId, String userId) async {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('garbage').doc(garbageId).get();
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    List<String> likes = List<String>.from(data['likes'] ?? []);
    if (likes.contains(userId)) {
      likes.remove(userId);
    } else {
      likes.add(userId);
    }
    await FirebaseFirestore.instance.collection('garbage').doc(garbageId).update({
      'likes': likes,
      'dislikes': FieldValue.arrayRemove([userId]),
    });
  }

  @override
  Future<void> dislikeGarbage(String garbageId, String userId) async {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('garbage').doc(garbageId).get();
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    List<String> dislikes = List<String>.from(data['dislikes'] ?? []);
    if (dislikes.contains(userId)) {
      dislikes.remove(userId);
    } else {
      dislikes.add(userId);
    }
    await FirebaseFirestore.instance.collection('garbage').doc(garbageId).update({
      'likes': FieldValue.arrayRemove([userId]),
      'dislikes': dislikes,
    });
  }
}
