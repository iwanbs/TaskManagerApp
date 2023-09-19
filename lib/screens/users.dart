import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manage/animation/fadeanimation.dart';

class usersPage extends StatefulWidget {
  const usersPage({Key? key}) : super(key: key);

  @override
  State<usersPage> createState() => _usersPageState();
}

class _usersPageState extends State<usersPage> {
  String users = '';
  String url = '';
  File? imageFile;

  final user = FirebaseAuth.instance.currentUser!;
  var _nameController = TextEditingController();
  var _instanceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    FirebaseAuth.instance.currentUser?.uid;

    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();

    if (userDoc == null) {
      return;
    } else {
      setState(() {
        _nameController = TextEditingController(text: userDoc.get('username'));
        _instanceController =
            TextEditingController(text: userDoc.get('instance'));
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: ListView(
          children: [
            FadeAnimation(
              delay: 1.0,
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/', (Route<dynamic> route) => false);
                    },
                    icon: const Icon(Icons.arrow_back)),
              ),
            ),
            FadeAnimation(
              delay: 1.5,
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  'Set Up',
                  style: TextStyle(
                    fontFamily: 'Cardo',
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0C2551),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            FadeAnimation(
              delay: 2.0,
              child: Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 100,
                      child: ClipOval(
                        child: (imageFile != null)
                            ? Image.file(imageFile!)
                            : Image.asset('assets/images/logo.png'),
                      ),
                    ),
                    Positioned(
                        bottom: 20.0,
                        right: 40.0,
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25.0))),
                              builder: ((builder) => bottomSheet()),
                            );
                          },
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 28.0,
                          ),
                        ))
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            FadeAnimation(
              delay: 2.5,
              child: TextField(
                controller: _nameController,
                style: const TextStyle(
                  fontSize: 19,
                  color: Color.fromARGB(183, 34, 14, 164),
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                    hintText: 'Name',
                    hintStyle: const TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(183, 34, 14, 164),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 27, horizontal: 25),
                    focusColor: const Color.fromARGB(183, 34, 14, 164),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(27),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(183, 34, 14, 164),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(27),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(183, 34, 14, 164),
                      ),
                    )),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            FadeAnimation(
              delay: 3.0,
              child: TextField(
                controller: _instanceController,
                style: const TextStyle(
                  fontSize: 19,
                  color: Color.fromARGB(183, 34, 14, 164),
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                    hintText: 'Instance',
                    hintStyle: const TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(183, 34, 14, 164),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 27, horizontal: 25),
                    focusColor: const Color.fromARGB(183, 34, 14, 164),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(27),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(183, 34, 14, 164),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(27),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(183, 34, 14, 164),
                      ),
                    )),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            FadeAnimation(
              delay: 3.5,
              child: SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 0, 101, 184),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () async {
                      try {
                        final user = FirebaseAuth.instance.currentUser!;
                        users = user.uid;

                        if (imageFile == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please Pick up Image')));
                          return;
                        } else if (_nameController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Username cant be empty')));
                          return;
                        } else if (_instanceController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Instance cant be empty')));
                          return;
                        } else {
                          String fileName = Path.basename(imageFile!.path);
                          final ref = FirebaseStorage.instance
                              .ref()
                              .child('users_images')
                              .child(fileName);
                          await ref.putFile(imageFile!);
                          url = await ref.getDownloadURL();

                          FirebaseAuth.instance.currentUser?.uid;
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(users)
                              .update({
                            'username': _nameController.text,
                            'instance': _instanceController.text,
                            'ImageUrl': url
                          });
                        }

                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/', (Route<dynamic> route) => false);
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error.toString())));
                      }
                    },
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        fontFamily: 'Product Sans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextButton.icon(
                  icon: const Icon(Icons.camera),
                  onPressed: () {
                    _getFromCamera();
                  },
                  label: const Text("Camera"),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.image),
                  onPressed: () {
                    _getFromGallery();
                  },
                  label: const Text("Gallery"),
                ),
              ])
        ],
      ),
    );
  }
}
