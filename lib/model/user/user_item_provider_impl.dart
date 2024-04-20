import 'package:speakupp/model/user/user_item.dart';
import 'package:speakupp/model/user/user_item_provider.dart';
import 'package:sqflite/sqflite.dart';

class UserItemProviderImpl implements UserItemProvider {
  final String _tableName = "users";
  Database appDatabase;
  UserItemProviderImpl({required this.appDatabase});

  @override
  Future<void> insert(UserItem item) async {
    final db = appDatabase;
    await db.insert(
      _tableName,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return;
  }

  @override
  Future<List<UserItem>> list() async {
    // Get a reference to the database.
    final db = appDatabase;
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return UserItem.fromMap(maps[i]);
    });
  }

  @override
  Future<void> update(UserItem item) async {
    final db = appDatabase;
    await db.update(
      _tableName,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
    return;
  }

  @override
  Future<void> updatePartial(Map<String, dynamic> item) async {
    final db = appDatabase;
    final users = await list();
    await db.update(
      _tableName,
      item,
      where: 'id = ?',
      whereArgs: [users[0].id],
    );
    return;
  }

  @override
  Future<void> delete(String id) async {
    final db = appDatabase;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return;
  }

  @override
  Future<void> deleteAll() async {
    final db = appDatabase;
    await db.delete(
      _tableName,
    );
    return;
  }
}
