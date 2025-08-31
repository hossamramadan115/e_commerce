import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ImageUploadService {
  final String apiKey = "42ca111207b9d4ca04f847a4d847acb2";

  Future<String?> uploadImageToImgbb(File imageFile) async {
    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse("https://api.imgbb.com/1/upload?key=$apiKey"),
      );

      request.files.add(await http.MultipartFile.fromPath("image", imageFile.path));

      final response = await request.send();
      final resBody = await response.stream.bytesToString();
      final data = jsonDecode(resBody);

      if (response.statusCode == 200) {
        return data["data"]["url"]; // 🔗 الرابط المباشر للصورة
      } else {
        throw "Upload failed: ${data['error']['message']}";
      }
    } catch (e) {
      throw "Error uploading image: $e";
    }
  }
}

// تتبعت أوتوماتيك على imgbb → يرجعلك URL مباشر.

// يتحفظ في Firestore مع باقي بيانات المنتج.

// بعدين تقدر تعرض المنتج في أي مكان باستخدام الرابط.

// تحب أكتبلك نسخة كاملة مدمجة مع كودك الحالي بحيث تبقى تلزقها Copy/Paste وتشتغل على طول؟
// اعمل دا 