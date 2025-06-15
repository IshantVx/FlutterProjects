
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newflutterproject/HomePage.dart';
import 'package:newflutterproject/SignUpPage.dart';
import 'package:newflutterproject/tabPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LonginScreen extends StatefulWidget {
  const LonginScreen({super.key});

  @override
  State<LonginScreen> createState() => _LonginScreenState();
}

class _LonginScreenState extends State<LonginScreen> {//Missing concrete implementation of 'State.build'.

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscure = true;


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
    void dispose(){
    super.dispose();
    userNameController.dispose();
    passwordController.dispose();
    }


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
                                log("I am click");
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
                              onPressed: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Tabpage()));
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

