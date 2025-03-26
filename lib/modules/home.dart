import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchContactController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 222, 220, 213),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Icon(
                Icons.contacts,
                color: Colors.white,
              ),
            ),
            Expanded(
              flex: 14,
              child: Text(
                "My Contact",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}