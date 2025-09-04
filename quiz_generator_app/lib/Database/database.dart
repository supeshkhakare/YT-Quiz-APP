import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataBaseMethods {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  

  static Future<void> addUser(
    Map<String, dynamic> userDetailsMap,
    String id,
  ) async {
    return await firestore.collection("User").doc(id).set(userDetailsMap);
  }

static Stream<QuerySnapshot> getUserDetails() {
  
    User? user = FirebaseAuth.instance.currentUser;

  
    if (user == null) {
    
      return Stream.empty();
    }

   
    return firestore
        .collection("User")
        .where("email", isEqualTo: user.email)
        .snapshots();
  }
}
