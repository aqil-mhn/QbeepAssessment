import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

String dbName = "db.local";
String dbPath = "";
int version = 1;

Future<void> initiateDatabase() async {
  dbPath = join(await getDatabasesPath(), dbName);
  var database = await openDatabase(
    dbPath,
    version: version
  );

  String contact = "CREATE TABLE IF NOT EXISTS contact (id TEXT PRIMARY KEY, datasource TEXT, name TEXT, email TEXT, imagePath TEXT, dateInsert TEXT, favorite TEXT)";
  await database.execute(contact);
}

Future<void> dropDatabase() async {
  dbPath = join(await getDatabasesPath(), dbName);

  var database = await openDatabase(
    dbPath,
    version: version
  );

  database.execute("DROP TABLE IF EXISTS contact");

  initiateDatabase();
}