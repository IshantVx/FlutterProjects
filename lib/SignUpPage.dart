import 'package:flutter/material.dart';
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController userNameEmailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
              children: [
                SizedBox(height: 16,),
                Text("Sign Up",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.blueAccent
                ),),
                SizedBox(height: 30,),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                          child: Text("First Name"),
                          ),
                          TextField(
                            controller: firstNameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Enter Your First Name",
                              hintStyle: TextStyle(
                                color: Colors.black38
                              )
          
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 19,),
                    Expanded(
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                            child: Text("Middle/Last Name"),
                            ),
                            TextField(
                              controller: lastNameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Enter your Last Name",
                                hintStyle: TextStyle(
                                  color: Colors.black38
                                )
                              ),
                            )
                          ],
                    ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                child: Text("Email/Phone Number"),
                ),
                TextField(
                  controller: userNameEmailController,
                  decoration: InputDecoration(
          
                    border: OutlineInputBorder(),
                    hintText: "Enter your Email/Phone Number",
                    hintStyle: TextStyle(
                      color: Colors.black38
                    )
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Password"),
                ),
                TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter your strong Password",
                    hintStyle: TextStyle(
                      color: Colors.black38
                    )
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Confirm Password"),
                ),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Confirm your Password",
                    hintStyle: TextStyle(
                      color: Colors.black38
                    )
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: Text("Back")),
                    SizedBox(width: 10,),
                    ElevatedButton(onPressed: (){},
                        child: Text("Sign In"))
                  ],
                )
            ],
          ),
        ),
        ),
      ),
    );
  }

}