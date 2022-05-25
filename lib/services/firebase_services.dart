import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static Future<DocumentSnapshot> getData() async {
    return await FirebaseFirestore.instance
        .collection('prompter_app')
        .doc('1EESEtyLtTy447I2qL8K')
        .get();
  }

  static Future<bool> updatePrompterSettings(
      Map<String, dynamic> prompterSettings) async {
    await FirebaseFirestore.instance
        .collection('prompter_app')
        .doc('1EESEtyLtTy447I2qL8K')
        .update({'prompter_settings': prompterSettings}).whenComplete(() {
      return true;
    });
    return false;
  }

  static Future<bool> updateTextStyle(Map<String, dynamic> textStyle) async {
    await FirebaseFirestore.instance
        .collection('prompter_app')
        .doc('1EESEtyLtTy447I2qL8K')
        .update({'text_style': textStyle}).whenComplete(() {
      return true;
    });
    return false;
  }

  static Future<bool> UpdateKeys(List<String> keys) async {
    await FirebaseFirestore.instance
        .collection('prompter_app')
        .doc('1EESEtyLtTy447I2qL8K')
        .update({'key_settings': keys}).whenComplete(() {
      return true;
    });
    return false;
  }
}
