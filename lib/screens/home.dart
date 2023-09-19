import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//
import 'package:task_manage/animation/fadeanimation.dart';
import 'package:task_manage/screens/task.dart';
import 'package:task_manage/screens/users.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// CURRENT FIREBASE USER
  String _name = '';
  String _instance = '';
  String _ImageUrl = '';

  final _namamapelController = TextEditingController();
  final _namapengajarController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  CollectionReference mapel = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('mapel');

  var aSnackBar = const SnackBar(
    content: Text('The Nama Mapel & Nama Pengajar fields must fill'),
  );

  var bSnackBar = const SnackBar(
    content: Text('The Nama Mapel fields must fill'),
  );

  var cSnackBar = const SnackBar(
    content: Text('The Nama Pengajar fields must fill'),
  );

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future AddMapel() async {
    if (_namamapelController.text.isNotEmpty &
        _namapengajarController.text.isNotEmpty) {
      FirebaseAuth.instance.currentUser?.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('mapel')
          .add({
        'nama_mapel': _namamapelController.text,
        'nama_pengajar': _namapengajarController.text,
      });
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    } else if (_namamapelController.text.isEmpty &
        _namapengajarController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(bSnackBar);
      return;
    } else if (_namamapelController.text.isNotEmpty &
        _namapengajarController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(cSnackBar);
      return;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(aSnackBar);
      return;
    }
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
        _name = userDoc.get('username');
        _instance = userDoc.get('instance');
        _ImageUrl = userDoc.get('ImageUrl');
      });
    }
  }

  Widget build(BuildContext context) {
    /// CURRENT WIDTH AND HEIGHT
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    ///
    return Scaffold(
      backgroundColor: const Color.fromARGB(183, 34, 14, 164),

      /// APP BAR
      body: SingleChildScrollView(
        child: SizedBox(
          width: w,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),

              /// FLUTTER ICONS
              FadeAnimation(
                delay: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Fitur Dalam Pengembangan')));
                        },
                        icon: const Icon(
                          Icons.notifications,
                          color: Colors.white70,
                        )),
                    IconButton(
                        onPressed: () async {
                          FirebaseAuth.instance.signOut();
                        },
                        icon: const Icon(Icons.logout_outlined,
                            color: Colors.white70))
                  ],
                ),
              ),

              /// FLUTTER CIRCULAR AVATAR
              FadeAnimation(
                delay: 1,
                child: InkWell(
                  onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const usersPage())),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(_ImageUrl),
                      maxRadius: 40,
                    ),
                  ),
                ),
              ),

              /// WELCOME TEXT
              FadeAnimation(
                delay: 1.5,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 1),
                  child: FadeAnimation(
                    delay: 1.5,
                    child: Text(
                      _name,
                      style: const TextStyle(
                        fontFamily: 'Cardo',
                        color: Colors.white70,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),

              /// SIGN IN TEXT
              FadeAnimation(
                delay: 2,
                child: Text(
                  _instance,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Cardo',
                    color: Colors.white70,
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              Container(
                height: 531,
                width: w,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(100, 50),
                        topRight: Radius.elliptical(100, 50))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, right: 8, left: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FutureBuilder<QuerySnapshot>(
                        future: mapel.get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var alldata = snapshot.data!.docs;
                            return alldata.length != 0
                                ? Expanded(
                                    child: ListView.builder(
                                        itemCount: alldata.length,
                                        scrollDirection: Axis.vertical,
                                        physics: const ScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15.0,
                                                horizontal: 20.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              child: Container(
                                                height: 80,
                                                color: const Color.fromARGB(
                                                    153, 162, 161, 161),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      color:
                                                          const Color.fromARGB(
                                                              183, 34, 14, 164),
                                                      width: 70,
                                                      height: 110,
                                                      child: const Icon(
                                                          Icons.bookmark,
                                                          color: Colors.white),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          ListTile(
                                                            title: Text(
                                                                alldata[index][
                                                                    'nama_mapel'],
                                                                style:
                                                                    const TextStyle(
                                                                  fontFamily:
                                                                      'Cardo',
                                                                  fontSize: 25,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          183,
                                                                          34,
                                                                          14,
                                                                          164),
                                                                )),
                                                            subtitle: Text(
                                                                alldata[index][
                                                                    'nama_pengajar'],
                                                                style:
                                                                    const TextStyle(
                                                                  fontFamily:
                                                                      'Cardo',
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 10),
                                                        child: IconButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          taskPage(
                                                                            id: snapshot.data!.docs[index].id,
                                                                          )),
                                                            );
                                                          },
                                                          icon: const Icon(
                                                              Icons
                                                                  .arrow_forward_ios,
                                                              color: Color
                                                                  .fromARGB(
                                                                      183,
                                                                      34,
                                                                      14,
                                                                      164)),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  )
                                : const Center(
                                    child: Text(
                                      'No Data',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  );
                          } else {
                            return const Center(child: Text("Loading...."));
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(25.0))),
            builder: ((builder) => bottomSheet()),
          );
        },
        icon: const Icon(Icons.add_task),
        label: const Text(
          "Add",
          style: TextStyle(
            fontFamily: 'Cardo',
          ),
        ),
        backgroundColor: const Color.fromARGB(183, 34, 14, 164),
      ),
    );
  }

  Widget bottomSheet() {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              "Mapel",
              style: TextStyle(
                fontFamily: 'Cardo',
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(183, 34, 14, 164),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            TextField(
              controller: _namamapelController,
              style: const TextStyle(
                fontSize: 19,
                color: Color.fromARGB(183, 34, 14, 164),
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                  hintText: 'Nama Pelajaran',
                  hintStyle: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(183, 34, 14, 164),
                    fontFamily: 'Cardo',
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 27, horizontal: 25),
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
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _namapengajarController,
              style: const TextStyle(
                fontSize: 19,
                color: Color.fromARGB(183, 34, 14, 164),
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                  hintText: 'Pengajar',
                  hintStyle: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(183, 34, 14, 164),
                    fontFamily: 'Cardo',
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 27, horizontal: 25),
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
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(w / 1.1, h / 15),
                primary: const Color.fromARGB(183, 34, 14, 164),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                AddMapel();
              },
              child: const Text(
                "Tambah",
                style: TextStyle(
                  fontFamily: 'Product Sans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
