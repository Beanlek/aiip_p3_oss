// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'dart:typed_data';
import 'dart:io';

import 'package:aiip_p3_oss/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_oss_aliyun/flutter_oss_aliyun.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//file and image picker library
import 'package:file_picker/file_picker.dart';

import 'auth.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  Client.init(
      ossEndpoint: "oss-ap-southeast-3.aliyuncs.com",
      bucketName: "flutterbucket-test1-imran",
      authGetter: authGetter);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Uint8List? fileBytes;
  PlatformFile? pickedFile;
  String? fileName;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(withData: true);

    setState(() {
      pickedFile = result?.files.first;
      fileBytes = result?.files.first.bytes;
      fileName = result?.files.first.name;
    });
  }

  Future uploadFile() async {
    await Client().putObject(
      fileBytes!,
      fileName!,
      option: PutRequestOption(
        onSendProgress: (count, total) {
          print("send: count = $count, and total = $total");
        },
        onReceiveProgress: (count, total) {
          print("receive: count = $count, and total = $total");
        },
        override: false,
        aclModel: AclMode.publicRead,
        storageType: StorageType.ia,
        headers: {"cache-control": "no-cache"},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: pickedFile != null ? 200 : 20,
                child: pickedFile != null
                    // ? Image.memory(fileBytes!)
                    ? Image.file(File(pickedFile!.path!))
                    : Text('Select an image')),
            pickedFile != null ? Text(fileName!) : SizedBox(),
            spaceVertical(15),
            ElevatedButton(
                child: Text('Select File'),
                onPressed: () {
                  // getImage();
                  selectFile();
                }),
            spaceVertical(15),
            ElevatedButton(
                child: Text('Upload File'),
                onPressed: () {
                  // getImage();
                  uploadFile();
                }),
            pickedFile != null ? spaceVertical(15) : SizedBox(),
            pickedFile != null
                ? SizedBox(
                    height: 300,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                              'pickedFile:\n ${pickedFile.toString().substring(0, pickedFile.toString().indexOf('bytes'))}${pickedFile.toString().substring(pickedFile.toString().indexOf('readStream:'))}\n---\n'),
                          Text(
                              'fileBytes:\n ${fileBytes.toString().substring(0, 200)} ...\n\n... ${fileBytes.toString().substring(fileBytes!.toString().length - 200)}\n---\n'),
                          Text('fileName:\n ${fileName.toString()}\n'),
                        ],
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
