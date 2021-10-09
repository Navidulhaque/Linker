import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:textrecog/Storage/DatabaseHelper.dart';
import 'package:textrecog/Storage/storage.dart';

class SearchScreen extends StatelessWidget {
  final String output;
  SearchScreen(this.output);
  SearchScreen.fromS({this.output = ""});
  @override
  Widget build(BuildContext context) {
    String temp = output;
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
              "Search",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: Colors.lightBlueAccent,
              ),
            ),
            TextFormField(
              initialValue: output,
              autofocus: true,
              cursorColor: Colors.black,
              textAlign: TextAlign.center,
              decoration: InputDecoration(),
              onChanged: (value) {
                temp = value;
              },
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                List<Storage> l = await DatabaseHelper.instance.datas();
                String url = "###***";
                for (Storage j in l) {
                  if (j.text == temp.toUpperCase()) {
                    url = j.url!;
                    break;
                  }
                }
                if (url != "###***") {
                  try {
                    launch(url);
                  } catch (e) {
                    print(e);
                  }
                }
                Navigator.pop(context);
              },
              child: Text("Search"),
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
