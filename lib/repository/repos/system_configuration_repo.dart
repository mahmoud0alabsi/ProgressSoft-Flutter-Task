import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SystemConfigurationRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static String SYSTEM_CONFIGURATION_COLLECTION = 'system_configuration';

  static Future<void> initialSystemConfiguration() async {
    try {
      initializeMobileRegexAndCounrtyCode();
      initializePasswordRegex();
      initializeLoginMessages();
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> initializeMobileRegexAndCounrtyCode() async {
    try {
      String mobileRegex = await _firestore
          .collection(SYSTEM_CONFIGURATION_COLLECTION)
          .doc('mobile_regex')
          .get()
          .then((value) => value.data()!['regex']);

      String countryCode = await _firestore
          .collection(SYSTEM_CONFIGURATION_COLLECTION)
          .doc('country_code')
          .get()
          .then((value) => value.data()!['country_code']);

      mobileRegex = mobileRegex.replaceAll('{{country_code}}', countryCode);

      mobileRegex = RegExp(mobileRegex).pattern;

      // save to shared preference
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('mobile_regex', mobileRegex);
      prefs.setString('country_code', countryCode);
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> initializePasswordRegex() async {
    try {
      String passwordRegex = await _firestore
          .collection(SYSTEM_CONFIGURATION_COLLECTION)
          .doc('password_regex')
          .get()
          .then((value) => value.data()!['regex']);

      passwordRegex = RegExp(passwordRegex).pattern;

      // save to shared preference
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('password_regex', passwordRegex);
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> initializeLoginMessages() async {
    try {
      Map<String, dynamic> loginMessages = await _firestore
          .collection(SYSTEM_CONFIGURATION_COLLECTION)
          .doc('login_messages')
          .get()
          .then((value) => value.data()!);

      String passwordIncorrectMessage =
          loginMessages['password_incorrect_message'];
      String userNotRegisteredMessage =
          loginMessages['user_not_registered_message'];

      // save to shared preference
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('password_incorrect_message', passwordIncorrectMessage);
      prefs.setString('user_not_registered_message', userNotRegisteredMessage);
    } catch (e) {
      throw Exception(e);
    }
  }
}
