import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class PredicationScreen extends StatefulWidget {
  const PredicationScreen({Key? key}) : super(key: key);
  final String url = 'http://ec2-18-195-21-24.eu-central-1.compute.amazonaws.com//predictions';

  @override
  State<PredicationScreen> createState() => _PredicationScreenState();
}

class _PredicationScreenState extends State<PredicationScreen> {
  bool loadingdone = true;
  File? image;
  String? _age;
  String? _race;
  String? _gender;
  bool buttonState = false;

  Future pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        this.image = imageTemp;
        buttonState = true;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImageFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        this.image = imageTemp;
        buttonState = true;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  _uploadImage(File? image) async {
    if (image != null) {
      setState(() {
        loadingdone = false;
      });
      String path = image.path;
      var name = path.substring(path.lastIndexOf("/") + 1, path.length);
      //var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
      FormData formData = FormData.fromMap({"image": await MultipartFile.fromFile(path, filename: name)});

      Dio dio = Dio();
      var response = await dio.post(
        widget.url,
        data: formData,
        options: Options(
            receiveTimeout: 0,
            headers: {'Connection': 'keep-alive', "Content-type": "multipart/form-data, application/json"}),
      );
      if (response.statusCode == 200) {
        setState(() {
          _age = jsonDecode(response.data.toString())['Age'];
          _gender = jsonDecode(response.data.toString())['Gender'];
          _race = jsonDecode(response.data.toString())['Race'];
          loadingdone = true;
          buttonState = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                child: Center(
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: _age == null
                          ? const Text(
                              "Take a picture, or select from gallery.",
                              style: TextStyle(fontSize: 28.0),
                            )
                          : Text(
                              'This person is a ${_age!.split('.')[0]} years old $_race $_gender',
                              style: const TextStyle(fontSize: 20.0),
                            ),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width,
                      child: image == null
                          ? const Center(
                              child: Icon(
                              Icons.photo,
                              size: 60,
                            ))
                          : Card(elevation: 5, child: Image.file(image!)),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width,
                      child: Visibility(
                        visible: !loadingdone,
                        child: const Card(
                          color: Colors.transparent,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Stack(
                children: [
                  Visibility(
                    visible: buttonState && loadingdone,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          _uploadImage(image);
                        },
                        child: const Text("Predict!", style: TextStyle(fontSize: 18),),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !buttonState,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: pickImageFromGallery,
                            child: const Text(" Gallery ", style: TextStyle(fontSize: 18),),
                          ),
                          const SizedBox(
                            width: 32.0,
                          ),
                          ElevatedButton(
                            onPressed: pickImageFromCamera,
                            child: const Text(" Camera ", style: TextStyle(fontSize: 18),),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
