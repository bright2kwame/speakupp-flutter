class DetailItem {
  String? result;

  DetailItem({
    required this.result,
  });

  static DetailItem fromJson(dynamic map) {
    var detail = DetailItem(
      result: map['detail'] != null ? map['detail'].toString() : "",
    );
    return detail;
  }

  static DetailItem fromMessageJson(dynamic map) {
    var detail = DetailItem(
      result: map['message'] != null ? map['message'].toString() : "",
    );
    return detail;
  }

  static DetailItem fromPaymentJson(dynamic map) {
    var detail = DetailItem(
      result: map['payment_link'] != null ? map['payment_link'].toString() : "",
    );
    return detail;
  }

  static DetailItem fromFileJson(dynamic map) {
    var detail = DetailItem(
      result: map['file_url'] != null
          ? map['file_url'].toString()
          : map['image_url'].toString(),
    );
    return detail;
  }
}
