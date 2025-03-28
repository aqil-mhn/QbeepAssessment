import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:qbeep_assessment/configs/database_config.dart';
import 'package:qbeep_assessment/modules/screen/contact_form.dart';
import 'package:qbeep_assessment/modules/service/contact_service.dart';
import 'package:sqflite/sqflite.dart';

class AllContactScreen extends StatefulWidget {
  const AllContactScreen({super.key});

  @override
  State<AllContactScreen> createState() => _AllContactScreenState();
}

class _AllContactScreenState extends State<AllContactScreen> {
  List<dynamic> contacts = [];
  List<Map<String, dynamic>> items = [];

  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    init();
  }

  init() async {
    await queryDatabase().whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  queryDatabase() async {
    var db = await openDatabase(
      dbPath,
      version: 1
    );

    contacts = await db.query(
      'contact'
    );
    items.clear();

    for (int i = 0; i < contacts.length; i++) {
      masssage(contacts[i]);
    }

    setState(() {
      contacts;
    });
  }

  masssage(dynamic user) async {
    Map<String, dynamic> item = {};

    item['fullName'] = user['name'];
    item['email'] = user['email'];
    item['userProfile'] = user['imagePath'];
    item['id'] = user['id'].toString();
    item['favorite'] = user['favorite'] ?? 'true';

    items.add(item);
  }

  deleteItem(String idSelected) async {
    var db = await openDatabase(
      dbPath,
      version: 1
    );

    await db.delete(
      'contact',
      where: "id=?",
      whereArgs: [idSelected]
    );

    await queryDatabase().whenComplete(() {
      setState(() {
        contacts;
        loading = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: !loading ? ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Slidable(
            endActionPane: ActionPane(
              extentRatio: 1/3,
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  onPressed: (context) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ContactFormScreen(
                          contact: items[index],
                        )
                      )
                    );
                  },
                  backgroundColor: const Color.fromARGB(255, 142, 68, 62),
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                ),
                SlidableAction(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  onPressed: (context) {
                    setState(() {
                      loading = true;
                    });
                    deleteItem(items[index]['id']);
                  },
                  backgroundColor: const Color.fromARGB(255, 163, 45, 37),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                )
              ],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              title: Text(
                items[index]['fullName']
              ),
              subtitle: Text(
                items[index]['email'],
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12
                ),
              ),
              leading: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        width: 2,
                        color: const Color.fromARGB(255, 231, 226, 210)
                      ) 
                    ),
                    child: Image.file(
                      File(items[index]['userProfile']),
                      scale: 3,
                    ),
                  ),
                  items[index]['favorite'] == 'true' ? Positioned(
                    bottom: 5,
                    right: 5,
                    // left: 34,
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        Icons.star,
                        color: const Color.fromARGB(255, 229, 207, 10),
                      ),
                    )
                  ) : SizedBox()
                ],
              ),
              trailing: IconButton(
                onPressed: () {
                  
                },
                icon: Icon(
                  Icons.send_outlined,
                  color: const Color.fromARGB(255, 181, 172, 142)
                ),
              ),
            ),
          );
        },
      ) : Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}