import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:newflutterproject/HomePage.dart';
import 'package:newflutterproject/SignUpPage.dart';
import 'package:newflutterproject/tabPage.dart';
import 'package:newflutterproject/utils/constants/images_strings.dart';
import 'package:newflutterproject/utils/constants/text_strings.dart';
import 'package:newflutterproject/utils/helpers/helper_function.dart';

class LonginScreen extends StatefulWidget {
  const LonginScreen({super.key});

  @override
  State<LonginScreen> createState() => _LonginScreenState();
}
List<BiometricType> _availableBiometrics = [];
bool _canCheckBiometrics = false;
class _LonginScreenState extends State<LonginScreen> {
  //Missing concrete implementation of 'State.build'.

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final LocalAuthentication auth = LocalAuthentication();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscure = true;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
    signInOption: SignInOption.standard,
  );

  Future<UserCredential?> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = _googleSignIn.currentUser;
      googleUser ??= await _googleSignIn.signIn();
      if (googleUser == null) {
        log("Google sign-in was cancelled by the user.");
        return null;
      }
      log("Google User Selected:");
      log("Email: ${googleUser.email}");
      log("Display Name: ${googleUser.displayName}");
      log("ID: ${googleUser.id}");
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Tabpage()));
        log("Firebase User Info:");
        log("UID: ${user.uid}");
        log("Email: ${user.email}");
        log("Name: ${user.displayName}");
        log("Photo URL: ${user.photoURL}");
      }
      return userCredential;
    } catch (e, stacktrace) {
      print("Google Sign-In Error: $e");
      print("StackTrace: $stacktrace");
      Fluttertoast.showToast(msg: "Invalid user credential $e" );

    }
  }

  // Future postLogin() async {
  //
  //   final response = await http.post(
  //     Uri.parse('https://api-barrel.sooritechnology.com.np/api/v1/user-app/login'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //     },
  //     body: json.encode(
  //         {
  //           "userName": userNameController.text,
  //           "password": passwordController.text
  //         }
  //     ),
  //   );
  //   if(response.statusCode==200){
  //     log(jsonDecode(response.body)['userName']);
  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Tabpage()));
  //   }else{
  //     Fluttertoast.showToast(msg: "Invalid");
  //   }
  //   return response;
  // }
  //
  //
  //   void _validation() {
  //     if (userNameController.text.isEmpty) {
  //       Fluttertoast.showToast(msg: "Please Enter the email");
  //     } else if (passwordController.text.isEmpty) {
  //       Fluttertoast.showToast(msg: "Please Enter the Password");
  //     } else {
  //      postLogin();
  //     }
  //   }
  @override
  void dispose() {
    super.dispose();
    userNameController.dispose();
    passwordController.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkBiometrics();
  }
  //checking biometrics
  Future<void> _checkBiometrics() async {
    try {
      _canCheckBiometrics = await auth.canCheckBiometrics;
      _availableBiometrics = await auth.getAvailableBiometrics();
      log("Available Biometrics: $_availableBiometrics");
    } on PlatformException catch (e) {
      debugPrint("Biometric error: $e");
    }
    setState(() {});
  }

  Future<void> loginUserWithEmailAndPassword() async {
    if (userNameController.text.isEmpty || passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: "please enter your login details");
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userNameController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Tabpage()),
      );
      Fluttertoast.showToast(msg: "Login Successful");
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to login',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
      if(didAuthenticate){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> homePage()));
      }else{
        Fluttertoast.showToast(msg: "Wrong credential");
      }
    } on PlatformException catch (e) {
      if (e.code == 'LockedOut') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Too many failed attempts. Please try again in 30 seconds.",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        debugPrint(e.toString());
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    Image(image: AssetImage(dark ? IImages.lightAppLogo : IImages.darkAppLogo))
                  ]
                ),
                SizedBox(height: 69),
                Text(ITextStrings.homeAppBarTitle , style: Theme.of(context).textTheme.headlineMedium,
                ),

                SizedBox(height: 25),
                Text(
                  "Please Enter your login details",
                  style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                ),
                SizedBox(height: 40),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Email/Phone Number"),
                ),

                TextField(
                  controller: userNameController,
                  decoration: InputDecoration(
                    hintText: "Enter your Email/Phone Number",
                    prefixIcon: Icon(Icons.email),
                    hintStyle: TextStyle(color: Colors.black38),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 24),
                Align(alignment: Alignment.centerLeft, child: Text("Password")),
                TextField(
                  // password text field
                  controller: passwordController,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.password),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscure = !_obscure;
                        });
                        log("I am click");
                      },
                      child:
                          _obscure
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off),
                    ),
                    hintText: "Enter your password",
                    hintStyle: TextStyle(color: Colors.black38),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: () {}, child: Text("Cancel")),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await loginUserWithEmailAndPassword();

                        //_validation();
                      },
                      child: Text("Login"),
                    ),
                    IconButton(onPressed: _authenticateWithBiometrics, icon: Icon(Icons.fingerprint))
                  ],
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: Center(child: Text("New user")),
                ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    setState(() {

                    });

                    UserCredential? userCredential = await signInWithGoogle();

                    if (userCredential != null) {
                      // Success logic
                    } else {
                      Fluttertoast.showToast(
                        msg: "Google Sign-In failed. Please try again.",
                        toastLength: Toast.LENGTH_SHORT,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                    }
                  },
                  label: const Text("Sign in with Google"),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),
            ),


            ],
            ),
          ),
        ),
      ),
    );
  }
}
