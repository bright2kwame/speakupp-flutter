import 'package:speakupp/model/user/user_item.dart';

abstract class UserItemProvider {
  Future<void> insert(UserItem item);
  Future<List<UserItem>> list();
  Future<void> update(UserItem item);
  Future<void> updatePartial(Map<String, dynamic> item);
  Future<void> delete(String id);
  Future<void> deleteAll();
}
