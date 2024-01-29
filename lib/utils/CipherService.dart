import 'package:encrypt/encrypt.dart';

class CipherService {
  static String encryptKey = "Sa@adaaa@2645751";
  static final key = Key.fromUtf8(encryptKey);
  static final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  static final initVector =
      IV.fromUtf8(encryptKey.substring(0, encryptKey.length));

  static String Decrypt(String encryptedText) {
    final encryptedData = Encrypted.fromBase64(encryptedText);
    return encrypter.decrypt(encryptedData, iv: initVector);
  }

  static String Encrypt(String plainText) {
    Encrypted encryptedData = encrypter.encrypt(plainText, iv: initVector);
    return encryptedData.base64;
  }
}
