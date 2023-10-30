import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterquizapp/Model/RoomModel.dart';

class RoomdbServices {
  Future<void> addRoom(RoomModel room) async {
    final roomCollection = FirebaseFirestore.instance.collection('room');

    try {
      await roomCollection.add(room.toMap());
    } catch (e) {
      print('Error adding item: $e');
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
