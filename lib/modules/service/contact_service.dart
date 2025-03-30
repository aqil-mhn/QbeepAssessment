import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:qbeep_assessment/configs/database_config.dart';
import 'package:sqflite/sqflite.dart';

Future<int> insertLDB(Map<String, dynamic> user, String image) async {
  var db = await openDatabase(
    dbPath,
    version: 1
  );

  String imageProfile = "";
  await convertImageAndPath(image, "${user['firstName']}${user['lastName']}").then((value) {
    imageProfile = value;
  });
  log("imageProfile in convertImage ${imageProfile.toString()}");

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
          'favorite': user['favorite'],
          'imagePath': imageProfile
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
          'favorite': user['favorite'],
          'imagePath': imageProfile
        },
      );
    }
  } catch (e, stackTrace) {
    log("error (insertLDB contact) => ${e.toString()} | ${stackTrace.toString()}");
  }
  return 0;
}

convertImageAndPath(String base64Image, String name) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final userProfileDirectoryPath = '${directory.path}/userProfile';

  final filePath = '${userProfileDirectoryPath}/${name}';
  final Directory userProfileDir = Directory(userProfileDirectoryPath);

  if (!await userProfileDir.exists()) {
    await userProfileDir.create(recursive: true);
  }

  final File userProfile = File(filePath);
  final bytes = base64Decode(base64Image);
  await userProfile.writeAsBytes(bytes);
  return userProfile.path;
}