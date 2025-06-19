import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'SignupPage.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {

  Future<void> loginUserWithEmailAndPassword() async{
    try{
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userNameController.text.trim(),
          password: passwordController.text.trim()
      );
      print(userCredential);

    } on FirebaseAuthException catch(e){
      print(e.message);
    }
  }
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscure = true;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(

                child: Column(
                  children: [
                    SizedBox(height: 69,),
                    Text("Welcome to Facebook",
                      style: TextStyle(
                          fontSize: 30
                          ,
                          color: Colors.blueAccent
                      ),
                    ),
                    SizedBox(height: 25,),
                    Text(
                      "Please Enter your login details",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.blueAccent
                      ),
                    ),
                    SizedBox(height: 40,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "Email/Phone Number"
                      ),
                    ),


                    TextField(
                        controller: userNameController,
                        decoration: InputDecoration(
                            hintText: "Enter your Email/Phone Number",
                            prefixIcon: Icon(Icons.email),
                            hintStyle: TextStyle(
                                color: Colors.black38
                            ),
                            border: OutlineInputBorder()
                        )

                    ),
                    SizedBox(height: 24,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Password"),
                    ),
                    TextField( // password text field
                      controller: passwordController,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.password),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscure = !_obscure;
                              });

                            },
                            child: _obscure ? Icon(Icons.visibility) : Icon(
                                Icons.visibility_off),
                          ),
                          hintText: "Enter your password",
                          hintStyle: TextStyle(
                              color: Colors.black38
                          ),
                          border: OutlineInputBorder()
                      ),
                    ),
                    SizedBox(height: 24,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        ElevatedButton(
                            onPressed: () {},
                            child: Text("Cancel")
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                            onPressed: () async{
                              await loginUserWithEmailAndPassword();

                              //_validation();
                            },
                            child: Text("Login"))
                      ],
                    ),
                    SizedBox(height: 20,),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()));
                      },
                      child: Center(
                        child: Text("New user"),
                      ),
                    )
                  ],

                ),
              )
          )


      ),
    );
  }
  }

