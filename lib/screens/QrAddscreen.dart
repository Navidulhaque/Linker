import 'package:flutter/material.dart';
import 'package:textrecog/Storage/storage.dart';
import 'package:textrecog/Storage/DatabaseHelper.dart';
import 'package:textrecog/screens/homescreen.dart';

class QRAdd extends StatefulWidget {
  static String id = 'qraddscreen';
  final String inurl;
  QRAdd(this.inurl);

  @override
  _QRAddState createState() => _QRAddState();
}

class _QRAddState extends State<QRAdd> {
  String? text;
  @override
  Widget build(BuildContext context) {
    String temp = widget.inurl;
    return SafeArea(
        child: Scaffold(
      body: Container(
        color: Color(0xff757575),
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 250, 20, 30),
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
              TextFormField(
                initialValue: temp,
                autofocus: true,
                cursorColor: Colors.black,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Enter URL",
                ),
                onChanged: (value) {
                  temp = value;
                },
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    DatabaseHelper.instance.add(
                      Storage(text: text!.toUpperCase(), url: temp),
                    );
                  });
                  Navigator.popUntil(
                      context, ModalRoute.withName(HomeScreen.id));
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
      ),
    ));
  }
}
