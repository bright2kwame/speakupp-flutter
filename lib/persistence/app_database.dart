import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Future<Database> init() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'speakupp_database.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE users(id TEXT PRIMARY KEY, first_name TEXT, phone_number TEXT, birthday TEXT, last_name TEXT, auth_token TEXT, is_active INTEGER, username TEXT, avatar TEXT, background_image TEXT, gender TEXT)',
        );
        return;
      },
      version: 1,
    );
    return database;
  }
}
