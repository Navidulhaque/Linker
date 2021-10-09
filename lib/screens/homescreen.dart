import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:textrecog/Storage/storage.dart';
import 'package:textrecog/Storage/DatabaseHelper.dart';
import 'package:textrecog/widget/texttile.dart';
import 'Searchscreen.dart';
import 'Qrscanner.dart';
import 'AddScreen.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'homescreen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker? _picker = ImagePicker();
  String? text;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  void _press(String s) async {
    XFile? pickedFile = await _picker!.pickImage(
        source: s == "camera" ? ImageSource.camera : ImageSource.gallery);
    if (pickedFile != null) {
      final File? file = File(pickedFile.path);
      final File? croppedFile = await ImageCropper.cropImage(
          sourcePath: file!.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      final File? imageFile = croppedFile;
      final GoogleVisionImage? visionImage =
          GoogleVisionImage.fromFile(imageFile!);
      final TextRecognizer textRecognizer =
          GoogleVision.instance.textRecognizer();
      final VisionText? visionText =
          await textRecognizer.processImage(visionImage!);
      String? imgtext = visionText!.text;
      setState(() {
        text = imgtext;
        showModalBottomSheet(
            context: context, builder: (context) => SearchScreen(text!));
      });
      textRecognizer.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
              ),
              child: Text(
                'Linker',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Messages'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.lightBlueAccent,
      floatingActionButton: FabCircularMenu(
          ringDiameter: 300,
          fabOpenIcon: Icon(
            Icons.text_fields_outlined,
          ),
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.camera),
              onPressed: () {
                _press("camera");
              },
            ),
            IconButton(
              icon: Icon(Icons.image),
              onPressed: () {
                _press("gallery");
              },
            ),
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) => AddScreen()).then((dynamic value) {
                  setState(() {});
                });
              },
              icon: Icon(Icons.add),
            ),
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => SearchScreen.fromS());
                },
                icon: Icon(Icons.search)),
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Qrscanner()));
                },
                icon: Icon(Icons.qr_code)),
            IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: Icon(Icons.refresh)),
          ]),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 60,
              bottom: 30,
              left: 30,
              right: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: TextButton(
                    onPressed: () {
                      _scaffoldKey.currentState!.openDrawer();
                      setState(() {});
                    },
                    child: Icon(
                      Icons.list,
                      color: Colors.lightBlueAccent,
                      size: 30,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Linker',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                ),
              ),
              child: Container(
                width: double.infinity,
                child: FutureBuilder<List<Storage>>(
                    future: DatabaseHelper.instance.datas(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Storage>> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: Text('No labels in List.'));
                      }
                      return snapshot.data!.isEmpty
                          ? Center(child: Text('No labels in List.'))
                          : ListView(
                              children: snapshot.data!.map((storage) {
                                return Center(
                                  child: TextTile(
                                    title: storage.text,
                                    openurl: storage.url,
                                  ),
                                );
                              }).toList(),
                            );
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
