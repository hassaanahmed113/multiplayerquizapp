import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterquizapp/Model/RoomModel.dart';

class RoomdbServices {
  Future<DocumentReference?> addRoom(RoomModel room) async {
    final roomCollection = FirebaseFirestore.instance.collection('room');

    try {
      // Add the room to Firestore and return the DocumentReference
      DocumentReference docRef = await roomCollection.add(room.toMap());
      return docRef;
    } catch (e) {
      print('Error adding item: $e');
      return null;
    }
  }

  Future<void> updateRoom(RoomModel room) async {
    final roomCollection = FirebaseFirestore.instance.collection('room');

    try {
      QuerySnapshot querySnapshot = await roomCollection
          .where('currentUserid', isEqualTo: room.currentUserid)
          .get();

      for (var doc in querySnapshot.docs) {
        // Update each document that matches the condition
        roomCollection.doc(doc.id).update(room.toMap());
      }
    } catch (e) {
      print('Error updating items: $e');
    }
  }
}
