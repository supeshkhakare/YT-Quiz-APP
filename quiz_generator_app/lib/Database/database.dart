import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataBaseMethods {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Recieve Data and Create Documents

  static Future<void> addUser(
    Map<String, dynamic> userDetailsMap,
    String id,
  ) async {
    return await firestore.collection("User").doc(id).set(userDetailsMap);
  }

static Stream<QuerySnapshot> getUserDetails() {
    // Get the currently authenticated user
    User? user = FirebaseAuth.instance.currentUser;

    // Check if a user is logged in
    if (user == null) {
      // Return an empty stream if no user is logged in
      return Stream.empty();
    }

    // Query the 'User' collection for a document where the 'email' field matches the current user's email
    return firestore
        .collection("User")
        .where("email", isEqualTo: user.email)
        .snapshots();
  }
}
