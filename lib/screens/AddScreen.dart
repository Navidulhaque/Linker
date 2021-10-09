import 'package:flutter/material.dart';
import 'package:textrecog/Storage/storage.dart';
import 'package:textrecog/Storage/DatabaseHelper.dart';

class AddScreen extends StatefulWidget {
  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  String? text;
  String? url;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Add URL",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: Colors.lightBlueAccent,
              ),
            ),
            TextField(
              autofocus: true,
              cursorColor: Colors.black,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "Enter Label",
              ),
              onChanged: (value) {
                text = value;
              },
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              autofocus: true,
              cursorColor: Colors.black,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "Enter URL",
              ),
              onChanged: (value) {
                url = value;
              },
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  DatabaseHelper.instance.add(
                    Storage(text: text!.toUpperCase(), url: url),
                  );
                });

                Navigator.pop(context);
              },
              child: Text("Add"),
              style: ElevatedButton.styleFrom(
                primary: Colors.lightBlueAccent,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            )
          ],
        ),
      ),
    );
  }
}
