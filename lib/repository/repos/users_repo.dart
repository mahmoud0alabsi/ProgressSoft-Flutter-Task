import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progress_soft_app/repository/models/CustomUser.dart';

class UsersRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const USERS_COLLECTION = 'users';
  static String currentUserUID = '';

  static void setNewUserDate(String uid, String fullName, String mobileNumber,
      int age, String gender, String password) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'fullName': fullName,
        'mobileNumber': mobileNumber,
        'age': age,
        'gender': gender,
        'password': password
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<CustomUser> checkIfUserExists(
      String mobileNumber, String password) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(USERS_COLLECTION)
          .where('mobileNumber', isEqualTo: mobileNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        currentUserUID = querySnapshot.docs[0].id;
        return CustomUser.fromDocument(
            querySnapshot.docs[0], querySnapshot.docs[0].id);
      } else {
        return CustomUser.emptyObject();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<CustomUser> getCurrentUser() async {
    DocumentSnapshot querySnapshot =
        await _firestore.collection(USERS_COLLECTION).doc(currentUserUID).get();

    return CustomUser.fromDocument(querySnapshot, querySnapshot.id);
  }
}
