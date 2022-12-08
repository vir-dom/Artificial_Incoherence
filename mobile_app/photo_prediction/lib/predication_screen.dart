import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class PredicationScreen extends StatefulWidget {
  const PredicationScreen({Key? key}) : super(key: key);
  final String url = 'http://ip172-18-0-95-ce8n1s60qau000fjt6hg-5000.direct.labs.play-with-docker.com:5000/predictions';

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
        options: Options(receiveTimeout: 0, headers: {'Connection': 'keep-alive', "Content-type": "multipart/form-data, application/json"}),
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

  _doUpload() async {
    if (image != null) {
      setState(() {
        loadingdone = false;
      });
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(widget.url),
      );
      print("request exist here");
      Map<String, String> headers = {"Content-type": "multipart/form-data"};
      request.files.add(
        http.MultipartFile(
          'image',
          image!.readAsBytes().asStream(),
          image!.lengthSync(),
          filename: "filename",
          contentType: MediaType('image', 'jpeg'),
        ),
      );
      request.headers.addAll(headers);
      print(request.url.toString());
      print("request: " + request.toString());
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      setState(() {
        print(response.body.toString());
        loadingdone = true;
        buttonState = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Artificial Incoherence"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Center(
                child: Container(
                  child: _age == null
                      ? const Text(
                          "Give me a photo.",
                          style: TextStyle(fontSize: 28.0),
                        )
                      : Text(
                          'The person is a $_age year old $_race $_gender',
                          style: const TextStyle(fontSize: 20.0),
                        ),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    width: MediaQuery.of(context).size.width,
                    child: image == null ? const Center(child: Icon(Icons.photo)) : Image.file(image!),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Visibility(
                        visible: !loadingdone,
                        child: const Card(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: !buttonState,
                child: ElevatedButton(
                  onPressed: pickImageFromGallery,
                  child: const Text("From gallery"),
                ),
              ),
              const SizedBox(
                width: 30.0,
              ),
              Visibility(
                visible: !buttonState,
                child: ElevatedButton(
                  onPressed: pickImageFromCamera,
                  child: const Text("Open Camera"),
                ),
              ),
              Visibility(
                visible: buttonState,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      _uploadImage(image);
                      //_doUpload();
                    },
                    child: const Text("Predict!"),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
