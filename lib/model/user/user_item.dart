import 'package:speakupp/api/reponse_data_parser.dart';

class UserItem {
  String id;
  String? firstName;
  String? username;
  String? gender;
  String? avatar;
  String? lastName;
  String? phoneNumber;
  bool? isActive;
  String? birthday;
  String? authToken;
  String? backgroundImage;

  UserItem({
    required this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.authToken,
    this.birthday,
    this.username,
    this.avatar,
    this.gender,
    this.backgroundImage,
    this.isActive,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "first_name": firstName,
      "last_name": lastName,
      "phone_number": phoneNumber,
      "username": username,
      "birthday": birthday,
      "avatar": avatar,
      "gender": gender,
      "background_image": backgroundImage,
      "auth_token": authToken,
      "is_active": isActive == true ? 1 : 0,
    };
  }

  static UserItem fromMap(Map<String, dynamic> map) {
    var user = UserItem(
      id: map['id'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      username: map['username'],
      phoneNumber: map['phone_number'],
      authToken: map['auth_token'],
      backgroundImage: map['background_image'],
      birthday: map['birthday'],
      avatar: map['avatar'],
      gender: map['gender'],
      isActive: map['is_active'] == 1,
    );
    return user;
  }

  // factory method which helps to create instance of same class
  factory UserItem.fromJson(dynamic map) => UserItem(
        id: ReponseDataParser.getJsonKey(map, "id").toString(),
        firstName: ReponseDataParser.getJsonKey(map, "first_name"),
        lastName: ReponseDataParser.getJsonKey(map, "last_name"),
        phoneNumber: ReponseDataParser.getJsonKey(map, "phone_number"),
        authToken: ReponseDataParser.getJsonKey(map, "auth_token"),
        birthday: ReponseDataParser.getJsonKey(map, "birthday"),
        username: ReponseDataParser.getJsonKey(map, "username"),
        isActive: ReponseDataParser.getJsonKey(map, "is_active"),
        gender: ReponseDataParser.getJsonKey(map, "gender"),
        avatar: ReponseDataParser.getJsonKey(map, "avatar"),
        backgroundImage: ReponseDataParser.getJsonKey(map, "background_image"),
      );
}
