import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:qbeep_assessment/configs/database_config.dart';
import 'package:sqflite/sqflite.dart';

getContact() async {
  var response = await http.get(
    Uri.parse(
      "https://dummyjson.com/users"
    )
  );

  switch (response.statusCode) {
    case 200:
      return serviceImplement(jsonDecode(response.body));
    default:
      return [];
  }
}

Future<void> serviceImplement(Map<String, dynamic> response) async {
  List<dynamic> users = [];
  int numItem = 0;

  log("${response['users'].length}");

  if (response['users'] != null) {
    for (int i = 0; i < response['users'].length; i++) {
      await downloadImageAndPath(response['users'][i]['image'], "${response['users'][i]['firstName']}${response['users'][i]['lastName']}").then((path) async {
        await insertLDB(response['users'][i], path);
      });
      // await insertLDB(response['users'][i]);
    }
  }
}

Future<int> insertLDB(Map<String, dynamic> user, String imagePath) async {
  var db = await openDatabase(
    dbPath,
    version: 1
  );

  try {
    List<Map<String, Object?>> query = await db.query(
      'contact',
      where: "id=?",
      whereArgs: [user['id']]
    );

    if (query.isNotEmpty) {
      int updateLBD = await db.update(
        'contact',
        conflictAlgorithm: ConflictAlgorithm.replace,
        {
          'name': "${user['firstName']} ${user['lastName']}",
          'email': user['email'].toString(),
          'datasource': jsonEncode(user),
          'dateInsert': DateTime.now().toLocal().toString(),
          'favorite': null,
          'imagePath': imagePath
        },
        where: 'id=?',
        whereArgs: [user['id']]
      );
    } else {
      int updateLBD = await db.insert(
        'contact',
        conflictAlgorithm: ConflictAlgorithm.replace,
        {
          'id': user['id'],
          'name': "${user['firstName']} ${user['lastName']}",
          'email': user['email'].toString(),
          'datasource': jsonEncode(user),
          'dateInsert': DateTime.now().toLocal().toString(),
          'favorite': null,
          'imagePath': imagePath
        },
      );
    }
  } catch (e, stackTrace) {
    log("error (insertLDB contact) => ${e.toString()} | ${stackTrace.toString()}");
  }
  return 0;
}

downloadImageAndPath(String url, String name) async {
  var response = await http.get(
    Uri.parse(
      url
    )
  );

  switch (response.statusCode) {
    case 200:
      final Directory directory = await getApplicationDocumentsDirectory();
      final userProfileDirectoryPath = '${directory.path}/userProfile';

      final filePath = '${userProfileDirectoryPath}/${name}';
      final Directory userProfileDir = Directory(userProfileDirectoryPath);

      if (!await userProfileDir.exists()) {
        await userProfileDir.create(recursive: true);
      }

      final File userProfile = File(filePath);
      await userProfile.writeAsBytes(response.bodyBytes);
      return userProfile.path;
    default:
      return '';
  }
}