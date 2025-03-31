import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qbeep_assessment/modules/service/contact_provider.dart';
import 'package:uuid/uuid.dart';

class ContactFormScreen extends StatefulWidget {
  ContactFormScreen({super.key, required this.contact});

  Map<String, dynamic> contact = {};

  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final DatabaseReference _firebaseDatabase = FirebaseDatabase.instance.ref();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool loading = true;
  bool isImageEdit = false;
  bool isEdit = false;
  bool isFavorite = false;
  String imageData = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    init();
  }

  init() async {
    if (widget.contact.isNotEmpty) {
      isEdit = true;

      if (widget.contact['favorite'] == 1) {
        isFavorite = true;
      }
    }
    await populateForm().whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  saveContact(Map<String, dynamic> data) async {
    log("widget.contact ${widget.contact.toString()}");
    if (!isEdit) {
      String newId = Uuid().v4().toString();
      log("newUID ${newId.toString()}");
      _firebaseDatabase.child("contacts/${newId.toString()}").set({
        "firstName": data['firstName'],
        "lastName": data['lastName'],
        "email": data['email'],
        "image": data['image'],
        "favorite": false,
        "id": newId.toString()
      });
    } else {
      Map<String, dynamic> updateData = {
        "firstName": data['firstName'],
        "lastName": data['lastName'],
        "email": data['email'],
        "favorite": data['favorite']
      };
      if (isImageEdit) {
        updateData['image'] = data['image'];
      }
      _firebaseDatabase.child("contacts/${widget.contact['id']}").update(updateData);
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 1),
        content: Text("${isEdit ? "Edit" : "Save"} successfully"),
        padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)),
      ),
    );
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
      // if (widget.contact['userProfile'] != null) {
      //   imageData = widget.contact['userProfile'];
      // }
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final File fileImage = File(image.path);
      final bytes = await fileImage.readAsBytes();
      final String base64Image = base64Encode(bytes);

      isImageEdit = true;

      setState(() {
        imageData = base64Image;
        widget.contact['userProfile'] = image.path;
      });
    } else {
      isImageEdit = false;
    }
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
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
              Map<String, dynamic> contact = {
                "firstName": firstNameController.text,
                "lastName": lastNameController.text,
                "email": emailController.text,
                "image": imageData,
                "favorite": isFavorite
              };
              saveContact(contact);
              Provider.of<ContactProvider>(context, listen: false).fetchContacts();
            },
            icon: Icon(
              !isFavorite ? CupertinoIcons.star_slash : CupertinoIcons.star,
              color: Colors.white,
            ),
          )
        ],
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
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                width: 2,
                                color: const Color.fromARGB(255, 231, 226, 210)
                              ) 
                            ),
                            child: SizedBox(
                              width: 120,
                              height: 120,
                              child: widget.contact['userProfile'] != null ? ClipOval(
                                child: Image.file(
                                  File(widget.contact['userProfile']),
                                  fit: BoxFit.cover
                                ),
                              ) : imageData.isEmpty ? Icon(
                                Icons.person,
                                size: 80,
                              ) : ClipOval(
                                child: Image.memory(
                                  base64Decode(imageData),
                                  fit: BoxFit.cover,
                                ),
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
                              "First Name*",
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Required";
                              }
                              return null;
                            },
                            textCapitalization: TextCapitalization.words,
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
                              "Last Name*",
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Required";
                              }
                              return null;
                            },
                            textCapitalization: TextCapitalization.words,
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
                              "Email*",
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Required";
                              }
                              if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                                return "Enter a valid email address";
                              }

                              return null;
                            },
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && (isEdit || imageData.isNotEmpty)) {
                      Map<String, dynamic> contact = {
                        "firstName": firstNameController.text,
                        "lastName": lastNameController.text,
                        "email": emailController.text,
                        "image": imageData,
                        "favorite": isFavorite
                      };

                      saveContact(contact);
                      Provider.of<ContactProvider>(context, listen: false).fetchContacts();

                      Navigator.of(context).pop(true);
                    } else {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text("Please fill in all fields and select an image"),
                          padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      );
                    }
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