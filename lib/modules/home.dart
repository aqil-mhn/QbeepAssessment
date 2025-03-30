import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qbeep_assessment/modules/screen/all_contact_screen.dart';
import 'package:qbeep_assessment/modules/screen/contact_form.dart';
import 'package:qbeep_assessment/modules/screen/no_data_screen.dart';
import 'package:qbeep_assessment/modules/service/contact_provider.dart';
import 'package:qbeep_assessment/modules/service/contact_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  TextEditingController searchContactController = TextEditingController();

  int? segmentControlValue = 0;
  List<dynamic> contacts = [];
  List<dynamic> tabs = [
    "All",
    "Favourites",
  ];

  String selectedTab = "All";

  bool loading = true;
  bool loadingTab = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<ContactProvider>(context, listen: false).fetchContacts();
    // });
    // init();
  }

  init() async {
    setState(() {
      loading = true;
    });
  }
  @override
  Widget build(BuildContext context) {
    var contactProvider = Provider.of<ContactProvider>(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 222, 220, 213),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ContactFormScreen(
                contact: {},
              )
            )
          );

          if (result == true) {
            Future.delayed(Duration(milliseconds: 2000), () {
              contactProvider.fetchContacts();
            });
          }
        },
        backgroundColor: const Color.fromARGB(255, 163, 45, 37),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100)
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 163, 45, 37),
        centerTitle: true,
        title: Text(
          "My Contact",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
      body: !contactProvider.loading ? Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SearchBar(
              controller: searchContactController,
              hintText: "Search contact",
              trailing: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Icon(
                    Icons.search,
                    size: 30,
                  ),
                )
              ],
              shadowColor: WidgetStatePropertyAll(Color.fromARGB(0, 63, 60, 51)),
              backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 222, 220, 213)),
              side: WidgetStatePropertyAll(BorderSide(
                color: Colors.black
              )),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildTabs(tabs[0]),
                  SizedBox(
                    width: 5,
                  ),
                  _buildTabs(tabs[1]),
                ],
              )
            ),
            Expanded(
              child: IndexedStack(
                index: selectedTab == "All" ? 0 : 1,
                children: [
                  AllContactScreen(),
                  NoDataScreen()
                ],
              ),
            )
          ],
        ),
      ) : Center(
        child: CircularProgressIndicator(
          color: const Color.fromARGB(255, 163, 45, 37),
        ),
      ),
    );
  }

  _buildTabs(String title) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedTab = title;
          loadingTab = true;
        });

        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            loadingTab = false;
          });
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: selectedTab == title ? Color.fromARGB(255, 163, 45, 37) : Color.fromARGB(255, 230, 224, 204),
          borderRadius: BorderRadius.circular(7)
        ),
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selectedTab == title ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}