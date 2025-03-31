import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qbeep_assessment/modules/screen/contact_form.dart';
import 'package:qbeep_assessment/modules/service/contact_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SendEmailScreen extends StatefulWidget {
  SendEmailScreen({super.key, required this.contact});

  Map<String, dynamic> contact = {};

  @override
  State<SendEmailScreen> createState() => _SendEmailScreenState();
}

class _SendEmailScreenState extends State<SendEmailScreen> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    
    init();
  }

  init() async {
    Future.delayed(Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    var contactProvider = Provider.of<ContactProvider>(context);
    Map<String, dynamic> contactInfo = contactProvider.contacts.firstWhere((contact) => contact['id'] == widget.contact['id']);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 222, 220, 213),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 163, 45, 37),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Profile",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: !loading ? SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(50, 50, 50, 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              width: 2,
                              color: const Color.fromARGB(255, 231, 226, 210)
                            ) 
                          ),
                          child: SizedBox(
                            width: 120,
                            height: 120,
                            child: contactInfo['userProfile'] != null ? ClipOval(
                              child: Image.file(
                                File(contactInfo['userProfile']),
                                fit: BoxFit.cover
                              ),
                            ) : Icon(
                              Icons.person,
                              size: 80,
                            )
                          )
                        ),
                        if (contactInfo['favorite'] == 1)
                        Positioned(
                          bottom: 0,
                          right: 5,
                          // left: 34,
                          child: Icon(
                            Icons.star,
                            size: 40,
                            color: const Color.fromARGB(255, 163, 45, 37),
                          )
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    contactInfo['fullName'] ?? "-",
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextButton(
                    style: ButtonStyle(
                      side: WidgetStatePropertyAll(BorderSide(
                        color: const Color.fromARGB(255, 163, 45, 37)
                      )),
                      padding: WidgetStatePropertyAll(EdgeInsets.fromLTRB(30, 10, 30, 10)),
                      backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 232, 193, 190)),
                      foregroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 163, 45, 37))
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ContactFormScreen(
                            contact: contactInfo,
                          )
                        )
                      );
                    },
                    child: Text(
                      "Edit profile"
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.email_outlined,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        contactInfo['email'],
                        style: TextStyle(
                          fontSize: 15
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              TextButton(
                style: ButtonStyle(
                  side: WidgetStatePropertyAll(BorderSide(
                    color: const Color.fromARGB(255, 163, 45, 37)
                  )),
                  padding: WidgetStatePropertyAll(EdgeInsets.fromLTRB(30, 10, 30, 10)),
                  backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 163, 45, 37)),
                  foregroundColor: WidgetStatePropertyAll(Colors.white)
                ),
                onPressed: () {
                  launchUrl(Uri.parse("mailto:${contactInfo['email']}"));
                },
                child: Text(
                  "Send Email",
                  style: TextStyle(
                    fontSize: 17
                  ),
                ),
              ),
            ],
          ),
        ),
      ) : Center(
        child: CircularProgressIndicator(
          color: const Color.fromARGB(255, 163, 45, 37),
        ),
      ),
    );
  }
}