import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscure = true;

  Future<void> createUserWithEmailAndPassword() async{
    try{

      final userCredential =   await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userNameController.text.trim(),
          password: passwordController.text.trim()
      );
      print(userCredential);
    }on FirebaseAuthException catch(e){
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Padding(padding: EdgeInsets.all(12),
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
              "Please Enter your SignIn details",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.blueAccent
              ),
            ),
            SizedBox(height: 40,),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  "Email"
              ),
            ),


            TextField(
                controller: userNameController,
                decoration: InputDecoration(
                    hintText: "Enter your Email",
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
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")
                ),
                SizedBox(width: 20),
                ElevatedButton(
                    onPressed: () async{
                      await createUserWithEmailAndPassword();

                      //_validation();
                    },
                    child: Text("Sign In"))
              ],
            ),

          ],
      ),
      ),
    ));
  }
}
