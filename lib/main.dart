import 'dart:async';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Metastasis Model App',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'MobileLookNet'),
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
  List<XFile>? _mediaFileList;
  int _counter = 0;

  void _setImageFileListFromFile(XFile? value){
    _mediaFileList = value == null ? null : <XFile>[value];
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  dynamic _pickImageError;
  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();

  Future<void> _onImageButtonPressed(
      ImageSource source, {
        required BuildContext context,
        bool isMultiImage = false,
        bool isMedia = false,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      setState(() {
        _setImageFileListFromFile(pickedFile);
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: _mediaFileList != null
            ? Semantics(
          label: 'image_picker_example_picked_images',
          child: ListView.builder(
            key: UniqueKey(),
            itemBuilder: (BuildContext context, int index) {
              final String? mime =
              lookupMimeType(_mediaFileList![index].path);

              return Semantics(
                label: 'image_picker_example_picked_image',
                child: mime == null || mime.startsWith('image/')
                    ? Image.file(
                  File(_mediaFileList![index].path),
                  errorBuilder: (BuildContext context,
                      Object error, StackTrace? stackTrace) {
                    return const Center(
                        child: Text(
                            'This image type is not supported'));
                  },
                )
                    : Container(), // For non-image files
              );
            },
            itemCount: _mediaFileList!.length,
          ),
        )
            : _pickImageError != null
            ? Text(
          'Pick image error: $_pickImageError',
          textAlign: TextAlign.center,
        )
            : const Text(
          'You have not yet picked an image.',
          textAlign: TextAlign.center,
        ),
      ),
    bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onImageButtonPressed(ImageSource.gallery, context: context);
        },
        tooltip: 'Pick Image from gallery',
        child: const Icon(Icons.photo),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    );
  }
}
