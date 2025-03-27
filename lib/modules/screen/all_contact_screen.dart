import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:qbeep_assessment/configs/database_config.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    init();
  }

  init() async {
    await queryDatabase();
  }

  queryDatabase() async {
    var db = await openDatabase(
      dbPath,
      version: 1
    );

    contacts = await db.query(
      'contact'
    );

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
    item['favorite'] = user['favorite'] ?? 'true';

    items.add(item);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Slidable(
            endActionPane: ActionPane(
              extentRatio: 1/5,
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    
                  },
                  backgroundColor: const Color.fromARGB(255, 163, 45, 37),
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                )
              ],
            ),
            child: ListTile(
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
                    bottom: 0,
                    right: 0,
                    left: 34,
                    child: Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                  ): SizedBox()
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
      )
    );
  }
}