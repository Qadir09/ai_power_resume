import 'dart:convert';
import 'package:ai_power_resume/resume_model.dart';
import 'package:http/http.dart' as http;

class GeminiApiService {
  static const String _apiKey = 'AIzaSyC0x5lLvMSgN_LLoZHULF0sMRpcJ7-G4_8';
  static const String _url =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$_apiKey';

  static Future<String> getResumeSuggestions(ResumeModel resume) async {
    final prompt = '''
Suggest improvements or additions to this resume content:
${resume.toPromptString()}
Be concise and professional.
''';

    final body = {
      "contents": [
        {
          "parts": [
            {"text": prompt},
          ],
        },
      ],
    };

    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['candidates'] != null) {
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        return "Failed to get AI suggestion.";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
