import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//
import 'package:task_manage/animation/fadeanimation.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback showLoginScreen;
  const SignUpScreen({Key? key, required this.showLoginScreen})
      : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  /// TextFields Controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Password Controller
  bool _secureText = true;

  showHide() {
    if (this.mounted) {
      setState(() {
        _secureText = !_secureText;
      });
    }
  }

  /// Password =! ConfirmPassword
  var aSnackBar = const SnackBar(
    content: Text('The password in not match with confirm password'),
  );

  /// Password & ConfirmPassword is Empty
  var bSnackBar = const SnackBar(
    content: Text('The Password & Confirm Password fields must fill!'),
  );

  /// Confirm Password is Empty
  var cSnackBar = const SnackBar(
    content: Text('The Confirm Password field must fill!'),
  );

  /// Password is Empty
  var dSnackBar = const SnackBar(
    content: Text('The Password field must fill!'),
  );

  /// Email & Confirm Password is Empty
  var eSnackBar = const SnackBar(
    content: Text('The Email & Confirm Password fields must fill!'),
  );

  /// Email is Empty
  var fSnackBar = const SnackBar(
    content: Text('The Email field must fill!'),
  );

  /// Email & password is Empty
  var gSnackBar = const SnackBar(
    content: Text('The Email & Password fields must fill!'),
  );

  /// All Fields Empty
  var xSnackBar = const SnackBar(
    content: Text('You must fill all fields'),
  );

  /// SIGNING UP METHOD TO FIREBASE
  Future signUp() async {
    if (_emailController.text.isNotEmpty &
        _passwordController.text.isNotEmpty &
        _confirmPasswordController.text.isNotEmpty) {
      if (passwordConfirmed()) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        FirebaseAuth.instance.currentUser?.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .set({
          'uid': FirebaseAuth.instance.currentUser?.uid.toString(),
          'username': 'username',
          'instance': 'instance',
          'ImageUrl': '',
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(aSnackBar);
      }

      /// In the below, with if statement we have some simple validate
    } else if (_emailController.text.isNotEmpty &
        _passwordController.text.isEmpty &
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(bSnackBar);
    }

    ///
    else if (_emailController.text.isNotEmpty &
        _passwordController.text.isNotEmpty &
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(cSnackBar);
    }

    ///
    else if (_emailController.text.isNotEmpty &
        _passwordController.text.isEmpty &
        _confirmPasswordController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(dSnackBar);
    }

    ///
    else if (_emailController.text.isEmpty &
        _passwordController.text.isNotEmpty &
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(eSnackBar);
    }

    ///
    else if (_emailController.text.isEmpty &
        _passwordController.text.isNotEmpty &
        _confirmPasswordController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(fSnackBar);
    }

    ///
    else if (_emailController.text.isEmpty &
        _passwordController.text.isEmpty &
        _confirmPasswordController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(gSnackBar);
    }

    ///
    else {
      ScaffoldMessenger.of(context).showSnackBar(xSnackBar);
    }
  }

  /// CHECK IF PASSWORD CONFIREMD OR NOT
  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// CURRENT WIDTH AND HEIGHT
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
                  topRight: Radius.elliptical(500, 500),
                  bottomRight: Radius.elliptical(100, 100))),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /// FLUTTER IMAGE
                  FadeAnimation(
                    delay: 1,
                    child: Container(
                      margin: const EdgeInsets.only(right: 2),
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
                          GestureDetector(
                            onTap: widget.showLoginScreen,
                            child: const Text(
                              " Sign In ",
                              style: TextStyle(
                                fontFamily: 'Cardo',
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(79, 34, 14, 164),
                              ),
                            ),
                          ),
                          const Text(
                            " | ",
                            style: TextStyle(
                              fontFamily: 'Cardo',
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(79, 34, 14, 164),
                            ),
                          ),
                          const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontFamily: 'Cardo',
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(183, 34, 14, 164),
                            ),
                          ),
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
                          hintText: 'Password at least 6 characters',
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

                  /// Confrim Password TextField
                  FadeAnimation(
                    delay: 3,
                    child: TextField(
                      obscureText: true,
                      controller: _confirmPasswordController,
                      style: const TextStyle(
                        fontSize: 19,
                        color: Color.fromARGB(183, 34, 14, 164),
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                          hintText: 'Confirm Password',
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
                    height: 20,
                  ),

                  /// SIGN UP BUTTON
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
                      onPressed: signUp,
                      child: const Text(
                        "Create an Account",
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

                  /// LOGIN TEXT
                  GestureDetector(
                    onTap: widget.showLoginScreen,
                    child: FadeAnimation(
                      delay: 4,
                      child: RichText(
                        text: const TextSpan(
                            text: "Have an account?",
                            style: TextStyle(
                                fontFamily: 'Product Sans',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff8f9db5)),
                            children: [
                              TextSpan(
                                text: " Log in",
                                style: TextStyle(
                                  fontFamily: 'Product Sans',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(183, 34, 14, 164),
                                ),
                              )
                            ]),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
