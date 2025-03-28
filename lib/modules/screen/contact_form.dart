import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactFormScreen extends StatefulWidget {
  ContactFormScreen({super.key, required this.contact});

  Map<String, dynamic> contact = {};

  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    init();
  }

  init() async {
    await populateForm().whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  populateForm() async {
    if (widget.contact.isNotEmpty) {
      if (widget.contact['email'] != null) {
        emailController.text = widget.contact['email'];
      }
      if (widget.contact['fullName'] != null) {
        List<dynamic> names = widget.contact['fullName'].toString().split(" ");
        firstNameController.text = names[0];
        lastNameController.text = names[1];
      }
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 222, 220, 213),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 163, 45, 37),
        centerTitle: true,
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
          widget.contact.isEmpty ? "Add Contact" : "Edit Contact",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: !loading ? Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Stack(
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
                            child: SizedBox(
                              width: 120,
                              height: 120,
                              child: widget.contact['userProfile'] != null ? Image.file(
                                File(widget.contact['userProfile']),
                                fit: BoxFit.cover
                              ) : Icon(
                                Icons.person,
                                size: 80,
                              ),
                            )
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            // left: 34,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 163, 45, 37),
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  color: const Color.fromARGB(255, 231, 226, 210)
                                )
                              ),
                              child: IconButton(
                                alignment: Alignment.center,
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  _pickImage();
                                },
                                icon: Icon(
                                  Icons.edit,
                                  size: 19,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: Text(
                              "First Name",
                              style: TextStyle(
                                fontSize: 19,
                                color: const Color.fromARGB(255, 163, 45, 37)
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: firstNameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              hintText: "First Name",
                              contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10)
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: Text(
                              "Last Name",
                              style: TextStyle(
                                fontSize: 19,
                                color: const Color.fromARGB(255, 163, 45, 37)
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: lastNameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              hintText: "Last Name",
                              contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10)
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: Text(
                              "Email",
                              style: TextStyle(
                                fontSize: 19,
                                color: const Color.fromARGB(255, 163, 45, 37)
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              hintText: "Email",
                              contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10)
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: TextButton(
                  style: ButtonStyle(
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                    backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 163, 45, 37)),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ))
                  ),
                  onPressed: () {
                    
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 19
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ) : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}