class ApiRequest {
  late Map<String, dynamic> data;
  late String url;

  ApiRequest({required this.url, required this.data});

  Map<String, dynamic> toJson() {
    return data;
  }
}
