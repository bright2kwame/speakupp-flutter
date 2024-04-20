class ReponseDataParser {
  static String serverErrorMessage =
      "Sorry, our encountered an error. Our engineers will resolve this soon.";

  //return the status code from the response
  static dynamic getJsonKey(Map<String, dynamic>? data, String key,
      {dynamic defaultValue = ""}) {
    var result = defaultValue;
    if (data != null) {
      if (data[key] != null) {
        result = data[key];
      }
    }
    return result;
  }
}
