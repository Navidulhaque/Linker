import 'package:flutter/material.dart';
import 'package:textrecog/Storage/DatabaseHelper.dart';
import 'package:url_launcher/url_launcher.dart';

class TextTile extends StatelessWidget {
  final String? title;
  final String? openurl;
  TextTile({this.title, this.openurl});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            DatabaseHelper.instance.remove(title!);
          },
        ),
        leading: Icon(Icons.open_in_browser),
        onTap: () {
          try {
            launch(openurl!);
          } catch (e) {
            print(e);
          }
        },
        title: Text(
          title!,
        ),
      ),
    );
  }
}
