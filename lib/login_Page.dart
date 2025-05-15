

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newflutterproject/SignUpPage.dart';
class LonginScreen extends StatefulWidget {
  const LonginScreen({super.key});

  @override
  State<LonginScreen> createState() => _LonginScreenState();
}

class _LonginScreenState extends State<LonginScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              children: [
                SizedBox(height: 69,),
                Text("Welcome to Facebook",
                  style: TextStyle(
                      fontSize: 40,
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
                  ) ,
                ),


                TextField(
                  controller: userNameController,
                  decoration: InputDecoration(
                    hintText: "Enter your Email/Phone Number",
                    hintStyle: TextStyle(
                      color: Colors.black38
                    ),
                    border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 24,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Password"),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
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
                       onPressed: (){},
                       child: Text("Cancel")),
                   SizedBox(width: 20),
                   ElevatedButton(
                       onPressed: (){
                         Fluttertoast.showToast(msg: "Your Credential have been taken");
                       },
                       child: Text("Login"))
                 ],
               ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap:(){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context)=>SignUpPage()));
                  },
                  child:  Center(
                    child: Text("New user"),
                  ),
                )
              ],

            ),
        ),


      ),
    );
  }
}
