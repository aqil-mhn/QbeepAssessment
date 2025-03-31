import 'dart:developer';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qbeep_assessment/modules/screen/all_contact_screen.dart';
import 'package:qbeep_assessment/modules/screen/contact_form.dart';
import 'package:qbeep_assessment/modules/screen/favorite_contact_screen.dart';
import 'package:qbeep_assessment/modules/screen/no_data_screen.dart';
import 'package:qbeep_assessment/modules/screen/send_email_screen.dart';
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
  List<dynamic> filteredContacts = [];
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ContactProvider>(context, listen: false).fetchContacts();
    });
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
            SearchAnchor(
              isFullScreen: false,
              dividerColor: const Color.fromARGB(255, 163, 45, 37),
              viewBackgroundColor: const Color.fromARGB(255, 222, 220, 213),
              viewConstraints: BoxConstraints(
                minHeight: 240,
                // minWidth: 1
              ),
              builder: (context, controller) {
                return SearchBar(
                  controller: searchContactController,
                  hintText: "Search contact",
                  onTap: () {
                    controller.openView();
                  },
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
                );
              },
              suggestionsBuilder: (context, controller) {
                String query = controller.text.toString().toLowerCase();
                filteredContacts = contactProvider.contacts.where((contact) {
                  String fullName = contact['fullName'].toLowerCase() ?? '';
                  String email = contact['email']?.toLowerCase() ?? '';

                  return fullName.contains(query) || email.contains(query);
                }).toList();

                if (filteredContacts.isEmpty) {
                  return [
                    Container(
                      height: 240,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                          child: Text(
                            "No Data Found",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.7)
                            ),
                          ),
                        ),
                      ),
                    )
                  ];
                } else {
                  return List.generate(filteredContacts.length, (index) {
                    var contactData = filteredContacts[index];
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        title: Text(
                          contactData['fullName'] ?? '-'
                        ),
                        subtitle: Text(
                          contactData['email'],
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12
                          ),
                        ),
                        leading: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            SizedBox(
                              height: 60,
                              width: 55,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    width: 2,
                                    color: const Color.fromARGB(255, 231, 226, 210)
                                  ) 
                                ),
                                child: ClipOval(
                                  child: Builder(
                                    builder: (context) {
                                      try {
                                        return Image.file(
                                          File(contactData['userProfile']),
                                          fit: BoxFit.cover,
                                        );
                                      } catch (e) {
                                        return Icon(
                                          Icons.person,
                                          // color: Colors.red,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            if (contactData['favorite'] == 1)
                            Positioned(
                              bottom: 5,
                              right: 5,
                              // left: 34,
                              child: CircleAvatar(
                                radius: 9,
                                backgroundColor: Colors.transparent,
                                child: Icon(
                                  Icons.star,
                                  color: const Color.fromARGB(255, 163, 45, 37),
                                ),
                              )
                            )
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SendEmailScreen(
                                  contact: contactData,
                                )
                              )
                            );
                          },
                          icon: Icon(
                            Icons.send_outlined,
                            color: const Color.fromARGB(255, 181, 172, 142)
                          ),
                        ),
                      ),
                    );
                  });
                }
              },
              // controller: searchContactController,
              // hintText: "Search contact",
              // onChanged: (value) {
              //   filterContact(value);
              // },
              // trailing: [
              //   Padding(
              //     padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              //     child: Icon(
              //       Icons.search,
              //       size: 30,
              //     ),
              //   )
              // ],
              // shadowColor: WidgetStatePropertyAll(Color.fromARGB(0, 63, 60, 51)),
              // backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 222, 220, 213)),
              // side: WidgetStatePropertyAll(BorderSide(
              //   color: Colors.black
              // )),
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
                  FavoriteContactScreen()
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