import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//
import 'package:task_manage/animation/fadeanimation.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback showSignUpScreen;
  const LoginScreen({Key? key, required this.showSignUpScreen})
      : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// TextFields Controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Password Controller
  bool _secureText = true;

  showHide() {
    if (this.mounted) {
      setState(() {
        _secureText = !_secureText;
      });
    }
  }

  /// Email & Password Empty
  var fSnackBar = const SnackBar(
    content: Text('The Email & Password fields Must Fill!'),
  );

  /// Email Fill & Password Empty
  var sSnackBar = const SnackBar(
    content: Text('Password field Must Fill!'),
  );

  /// Email Empty & Password Fill
  var tSnackBar = const SnackBar(
    content: Text('Email field Must Fill!'),
  );

  /// SIGNIN METHOD TO FIREBASE
  Future signIn() async {
    try {
      /// In the below, with if statement we have some simple validate
      if (_emailController.text.isNotEmpty &
          _passwordController.text.isNotEmpty) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else if (_emailController.text.isNotEmpty &
          _passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(sSnackBar);
      } else if (_emailController.text.isEmpty &
          _passwordController.text.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(tSnackBar);
      } else if (_emailController.text.isEmpty &
          _passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(fSnackBar);
      }
    } catch (e) {
      /// Showing Error with AlertDialog if the user enter the wrong Email and Password
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error Happened'),
            content: const SingleChildScrollView(
              child: Text(
                  "The Email and Password that you Entered is Not valid ,Try Enter a valid Email and Password."),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Got it'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _emailController.clear();
                  _passwordController.clear();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// currrent Width and Height
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    ///
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(183, 34, 14, 164),

        /// Body
        body: Container(
          width: w,
          height: h,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(500, 340),
                  bottomRight: Radius.elliptical(100, 100))),
          child: Padding(
            padding: const EdgeInsets.all(17),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /// FLUTTER IMAGE
                  FadeAnimation(
                    delay: 1,
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/logo.png")),
                      ),
                      height: h / 3.5,
                      width: w / 1.5,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  /// TOP TEXT
                  FadeAnimation(
                    delay: 1.5,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          const Text(
                            "Sign In",
                            style: TextStyle(
                              fontFamily: 'Cardo',
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(183, 34, 14, 164),
                            ),
                          ),
                          const Text(
                            " | ",
                            style: TextStyle(
                              fontFamily: 'Cardo',
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(183, 34, 14, 164),
                            ),
                          ),
                          GestureDetector(
                            onTap: widget.showSignUpScreen,
                            child: const Text(
                              " Sign Up ",
                              style: TextStyle(
                                fontFamily: 'Cardo',
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(79, 34, 14, 164),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  /// Email TextField
                  FadeAnimation(
                    delay: 2.0,
                    child: TextField(
                      controller: _emailController,
                      style: const TextStyle(
                        fontSize: 19,
                        color: Color.fromARGB(183, 34, 14, 164),
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                          hintText: 'E-mail',
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

                  /// Password TextField
                  FadeAnimation(
                    delay: 2.5,
                    child: TextField(
                      obscureText: _secureText,
                      controller: _passwordController,
                      style: const TextStyle(
                        fontSize: 19,
                        color: Color.fromARGB(183, 34, 14, 164),
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: showHide,
                              icon: Icon(Icons.visibility)),
                          hintText: 'Password',
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

                  /// Forgot Password TEXT
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Fitur Dalam Pengembangan")));
                          },
                          child: FadeAnimation(
                            delay: 3,
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  fontFamily: 'Product Sans',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(183, 34, 14, 164)),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  /// LOG IN BUTTON
                  FadeAnimation(
                    delay: 3.5,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(w / 1.1, h / 15),
                        primary: const Color.fromARGB(183, 34, 14, 164),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: signIn,
                      child: const Text(
                        "Log In",
                        style: TextStyle(
                          fontFamily: 'Product Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  /// REGISTER TEXT
                  GestureDetector(
                    onTap: widget.showSignUpScreen,
                    child: FadeAnimation(
                      delay: 4,
                      child: RichText(
                        text: const TextSpan(
                            text: "Don't have an account?",
                            style: TextStyle(
                                fontFamily: 'Product Sans',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff8f9db5)),
                            children: [
                              TextSpan(
                                text: " Register",
                                style: TextStyle(
                                    fontFamily: 'Product Sans',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(183, 34, 14, 164)),
                              )
                            ]),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
