import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MyDatabase {
  MyDatabase._();

  static final _instance = MyDatabase._();

  static MyDatabase get instance => _instance;
  static late Database database;
  static String tableName = "chat";

  static Future<Database> dbCreate() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, "chat.db");
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE $tableName(id TEXT, title TEXT)");
    }, onUpgrade: (db, oldVersion, newVersion) async {
      await db.execute("alter table $tableName");
    });
    return database;
  }

  Future<int> insertData({required Map<String, dynamic> listData}) async {
    return database.insert(tableName, listData).catchError((error) {
      print(error);
    });
    // return await database
    //     .rawInsert("insert into $tableName(data) values ('$data')")
    //     .catchError((error) {
    //   print("Error : = $error");
    // });
  }

  Future<int> updateDataBase(
      {required Map<String, dynamic> listData, required String id}) {
    return database
        .update(tableName, listData, where: "id = ?", whereArgs: [id]);
  }

  Future<dynamic> getChatData({required String id}) async {
    return await database.rawQuery(
      "select * from $tableName WHERE id = ?",
      [id],
    );
  }
}
