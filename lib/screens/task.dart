// ignore_for_file: unnecessary_this
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//
import 'package:task_manage/animation/fadeanimation.dart';

class taskPage extends StatefulWidget {
  const taskPage({Key? key, this.id}) : super(key: key);

  final String? id;

  @override
  State<taskPage> createState() => _taskPageState();
}

class _taskPageState extends State<taskPage> {
  var _nama_mapel = '';
  var _nama_pengajar = '';
  final _namataskController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _dateController = TextEditingController();

  DateTime selectDate = DateTime.now();

  final user = FirebaseAuth.instance.currentUser!;

  FirebaseFirestore firebase = FirebaseFirestore.instance;
  CollectionReference? mapel;

  Future AddTask() async {
    if (_namataskController.text.isNotEmpty &
        _deskripsiController.text.isNotEmpty) {
      FirebaseAuth.instance.currentUser?.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('mapel')
          .doc(widget.id)
          .collection('task')
          .add({
        'nama_task': _namataskController.text,
        'deskripsi': _deskripsiController.text,
        'dateline_day': _dateController.text,
      });
      Navigator.pop(context);
    } else if (_namataskController.text.isEmpty &
        _deskripsiController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(bSnackBar);
      return;
    } else if (_namataskController.text.isNotEmpty &
        _deskripsiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(cSnackBar);
      return;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(aSnackBar);
      return;
    }
  }

  var aSnackBar = const SnackBar(
    content: Text('The Nama Mapel & Nama Pengajar fields must fill'),
  );

  var bSnackBar = const SnackBar(
    content: Text('The Nama Mapel fields must fill'),
  );

  var cSnackBar = const SnackBar(
    content: Text('The Nama Pengajar fields must fill'),
  );

  void getData() async {
    //get users collection from firebase
    //collection is table in mysql
    mapel = firebase
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('mapel');

    //if have id
    if (widget.id != null) {
      //get users data based on id document
      var data = await mapel!.doc(widget.id).get();

      //we get data.data()
      //so that it can be accessed, we make as a map
      var item = data.data() as Map<String, dynamic>;

      //set state to fill data controller from data firebase
      setState(() {
        _nama_mapel = item['nama_mapel'];
        _nama_pengajar = item['nama_pengajar'];
      });
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    getData();
    super.initState();
  }

  Widget build(BuildContext context) {
    /// CURRENT WIDTH AND HEIGHT
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    CollectionReference task = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('mapel')
        .doc(widget.id)
        .collection('task');

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
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/', (Route<dynamic> route) => false);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white70,
                        )),
                  ],
                ),
              ),

              /// WELCOME TEXT
              FadeAnimation(
                delay: 1.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 1, left: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _nama_mapel,
                              style: const TextStyle(
                                fontFamily: 'Cardo',
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              _nama_pengajar,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Cardo',
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: IconButton(
                        onPressed: () {
                          mapel!.doc(widget.id).delete();

                          //back to main page
                          // '/' is home
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/', (Route<dynamic> route) => false);
                        },
                        icon: const Icon(Icons.delete),
                        iconSize: 35,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              Container(
                height: 620,
                width: w,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(20, 20),
                        topRight: Radius.elliptical(20, 20))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, right: 8, left: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FutureBuilder<QuerySnapshot>(
                        future: task.get(),
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
                                                vertical: 10.0,
                                                horizontal: 10.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              child: Container(
                                                height: 200,
                                                color: const Color.fromARGB(
                                                    153, 162, 161, 161),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      color:
                                                          const Color.fromARGB(
                                                              183, 34, 14, 164),
                                                      width: 50,
                                                      height: 200,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            alldata[index][
                                                                'nama_task'][0],
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    'Cardo',
                                                                fontSize: 30,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
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
                                                                    'nama_task'],
                                                                style:
                                                                    const TextStyle(
                                                                  fontFamily:
                                                                      'Cardo',
                                                                  fontSize: 20,
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
                                                            subtitle: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    alldata[index]
                                                                        [
                                                                        'deskripsi'],
                                                                    style:
                                                                        const TextStyle(
                                                                      fontFamily:
                                                                          'Cardo',
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    )),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),
                                                                const Text(
                                                                    'Dateline :',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Cardo',
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Color.fromARGB(
                                                                            183,
                                                                            34,
                                                                            14,
                                                                            164))),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                        alldata[index]
                                                                            [
                                                                            'dateline_day'],
                                                                        style:
                                                                            const TextStyle(
                                                                          fontFamily:
                                                                              'Cardo',
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        )),
                                                                    IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          task
                                                                              .doc(alldata[index].id)
                                                                              .delete();
                                                                          setState(
                                                                              () {
                                                                            return;
                                                                          });
                                                                        },
                                                                        icon: const Icon(
                                                                            Icons.delete)),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
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
                            return const Text('loading.....');
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
            builder: ((builder) => bottomSheet1()),
          );
        },
        icon: const Icon(Icons.add_circle),
        label: const Text(
          "Task",
          style: TextStyle(
            fontFamily: 'Cardo',
          ),
        ),
        backgroundColor: const Color.fromARGB(183, 34, 14, 164),
      ),
    );
  }

  Widget bottomSheet1() {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              "Task",
              style: TextStyle(
                fontFamily: 'Cardo',
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(183, 34, 14, 164),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: _namataskController,
              style: const TextStyle(
                fontSize: 19,
                color: Color.fromARGB(183, 34, 14, 164),
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.task,
                    color: Color.fromARGB(183, 34, 14, 164),
                  ),
                  hintText: 'Nama Task',
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
              controller: _deskripsiController,
              style: const TextStyle(
                fontSize: 19,
                color: Color.fromARGB(183, 34, 14, 164),
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.description,
                    color: Color.fromARGB(183, 34, 14, 164),
                  ),
                  hintText: 'Deskripsi Task',
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
              controller: _dateController,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2050));

                if (pickedDate != null) {
                  setState(() {
                    _dateController.text =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                  });
                }
              },
              style: const TextStyle(
                fontSize: 19,
                color: Color.fromARGB(183, 34, 14, 164),
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.calendar_month,
                    color: Color.fromARGB(183, 34, 14, 164),
                  ),
                  hintText: 'Dateline Day',
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
              height: 30,
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
                AddTask();
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
