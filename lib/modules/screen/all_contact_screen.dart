import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qbeep_assessment/modules/service/contact_service.dart';

class AllContactScreen extends StatefulWidget {
  const AllContactScreen({super.key});

  @override
  State<AllContactScreen> createState() => _AllContactScreenState();
}

class _AllContactScreenState extends State<AllContactScreen> {
  List<dynamic> contacts = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    init();
  }

  init() async {
    contacts = await getContact();
    log("contacts ${contacts.toString()}");

    setState(() {
      contacts;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Text(
          contacts.toString()
        ),
      ),
    );
  }
}