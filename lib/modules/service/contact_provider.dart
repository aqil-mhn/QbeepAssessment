import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:qbeep_assessment/configs/database_config.dart';
import 'package:qbeep_assessment/modules/service/contact_service.dart';
import 'package:sqflite/sqflite.dart';

class ContactProvider extends ChangeNotifier {
  ContactProvider() {
    _startListening();
    // fetchContacts();
  }
  List<Map<String, dynamic>> _contacts = [];
  List<Map<String, dynamic>> get contacts => _contacts;

  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  StreamSubscription<DatabaseEvent>? _contactsSubscription;

  bool _loading = true;
  bool get loading => _loading;

  void _startListening() {
    _contactsSubscription = _database.child('contacts').onValue.listen((event) async {
      var data = event.snapshot.value as Map<dynamic, dynamic>?;

      log("MAKIMA IS LISTENING");

      if (data != null) {
        _contacts = data.entries.map((entry) {
          return Map<String, dynamic>.from(entry.value as Map);
        }).toList();
        await Future.forEach(_contacts, (contact) async {
          await insertLDB(contact, contact['image']);
        });
        // for (int i = 0; i < contacts.length; i++) {
        //   insertLDB(contacts[i], contacts[i]['image']);
        // }

        await fetchContacts();
      } else {
        _contacts = [];
      }

      // fetchContacts();

      _loading = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _contactsSubscription?.cancel();
    super.dispose();
  }

  Future<void> fetchContacts() async {
    _loading = true;
    notifyListeners();

    // try {
      var db = await openDatabase(
        dbPath,
        version: 1
      );
      List<Map<String, dynamic>> queryResult = await db.query('contact');

      _contacts = queryResult.map((contact) {
        return {
          'id': contact['id'],
          'fullName': contact['name'],
          'email': contact['email'],
          'userProfile': contact['imagePath'],
          'favorite': contact['favorite'] ?? 'false',
        };
      }).toList();
    // } catch (e) {
    //   log("ERROR IN FETCHING CONTACTS: ${e.toString()}");
    // }

    log("FETCHCONTACTS CALLED ${_contacts.length.toString()}");

    _loading = false;
    notifyListeners();
  }
}