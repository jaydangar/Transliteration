import 'dart:async';
import 'dart:io';

import 'package:transliteration/response/transliteration_response.dart';
import 'package:transliteration/src/utility.dart';
import 'package:transliteration/transliteration.dart';

/// The Fundamental class that provides static method to transliterate given string.
class Transliteration {
  /// This function transliterates english text to the given language code.
  /// Exception will be thrown if user is not connected to internet or server is not responding.
  /// Returns Input String and top 5 suggestions in a list for transliteration.
  static Future<TransliterationResponse> transliterate(
    String inputString,
    Languages languageCode,
  ) async {
    TransliterationResponse _transliterationResponse =
        TransliterationResponse();
    String srcLanCode = Utility.getLanguageCode(Languages.ENGLISH);
    String descLanCode = Utility.getLanguageCode(languageCode);
    String lowerCaseSrcString = inputString.toLowerCase();
    final transliterationURL =
        '${Utility.transliterationBaseURL}?langpair=$srcLanCode|$descLanCode&text=$lowerCaseSrcString';
    HttpClient _client = new HttpClient();

    try {
      HttpClient _client = HttpClient();
      HttpClientRequest _request =
          await _client.getUrl(Uri.parse(transliterationURL));
      HttpClientResponse _response = await _request.close();
      List<dynamic> jsonResponse = await Utility.readResponse(_response);
      _client.close();
      dynamic data = jsonResponse.first;
      _transliterationResponse.sourceString = data['ew'];
      _transliterationResponse.transliterationSuggestions = data['hws'];
      return _transliterationResponse;
    } on SocketException {
      _client.close();
      throw ('SocketException: No Internet connection 😑');
    } on HttpException {
      _client.close();
      throw ('SocketException: Couldn\'t find the request location 😱');
    } on FormatException {
      _client.close();
      throw ('FormatException: Bad response format 👎');
    }
  }
}
