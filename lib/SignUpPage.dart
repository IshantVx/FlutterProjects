import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newflutterproject/HomePage.dart';
import 'package:newflutterproject/tabPage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}
class _SignUpPageState extends State<SignUpPage>{
  List<String> genderOptions = ['Male', 'Female' , 'Other'];
  String? selectGender;



    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController userNameEmailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();
    TextEditingController creatUserWithUserDetail = TextEditingController();
    TextEditingController genderController = TextEditingController();

    bool obscure= true;
    bool obscure2 = true;
    
    @override
    void dispose() {
      firstNameController.dispose();
      lastNameController.dispose();
      userNameEmailController.dispose();
      passwordController.dispose();
      confirmPasswordController.dispose();
      super.dispose();
    }
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Future <void> registorUser(

    {
      required String firstName,
      required String lastName,
      required String email,
      required String password,
      required String gender,

}) async{
      try{
        final String fullName = '$firstName $lastName';
        final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
            email: userNameEmailController.text.trim(),
            password: passwordController.text.trim());
        final User? user = userCredential.user;
        if(user !=null){
          await _firestore.collection('user').doc(user.uid).set(
            {
            'uid': user.uid,
            'email': user.email,
            'Password': password,
            'name': fullName,
            'gender': gender
            }
          );
          print("user registered and added to firestore");
          Fluttertoast.showToast(msg: "Signup Successful!");

        }

      }catch(e , stack){
        print("registration error : $e");
        Fluttertoast.showToast(msg: "Signup Failed: $e");
      }
    }


  @override
  Widget build(BuildContext context) {

    void signUpValidation(){
      if(firstNameController.text.isEmpty){
        Fluttertoast.showToast(msg:"Enter Your first name" );
      }else if (lastNameController.text.isEmpty){
        Fluttertoast.showToast(msg: "Enter your last name");
      }else if(userNameEmailController.text.isEmpty){
        Fluttertoast.showToast(msg: "Enter your Email/Phone Number");
      }else if(passwordController.text.isEmpty){
        Fluttertoast.showToast(msg: "Enter your Password");
        }else if (confirmPasswordController.text.isEmpty){
        Fluttertoast.showToast(msg: "Enter  your confirm password");
      }else if (passwordController.text.trim() != confirmPasswordController.text.trim()){
        Fluttertoast.showToast(msg: "The Password Doesn't Match");
      }
      else{
        registorUser(firstName: firstNameController.text.trim(),
            lastName: lastNameController.text.trim(),
            email: userNameEmailController.text.trim(),
            password:passwordController.text.trim(),
            gender: genderController.text.trim(),
        );
        Navigator.push(context, MaterialPageRoute(
            builder: (context)=>Tabpage()));
      }
    }


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
                          TextField(// first name Text field
                            controller: firstNameController,
                            decoration: InputDecoration(
                              prefixIcon:Icon(Icons.person),
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
                                prefixIcon: Icon(Icons.person),
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
                  child: Text("Gender"),
                ),
                DropdownButtonFormField<String>(
                  value: selectGender,
                  items: genderOptions.map((String gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      genderController.text = value ?? '';
                      selectGender = value;
                    });
                  },
                  decoration: InputDecoration(
                    prefix: Icon(Icons.person),
                    border: OutlineInputBorder(),
                    hintText: "Select Gender"
                  ),
                ),

                Align(
                  alignment: Alignment.centerLeft,
                child: Text("Email/Phone Number"),
                ),
                TextField(
                  controller: userNameEmailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail),

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
                  obscureText: obscure,
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter your strong Password",
                    hintStyle: TextStyle(
                      color: Colors.black38
                    ),
                    prefixIcon: Icon(Icons.password),
                    suffixIcon: GestureDetector(
                      onTap: (){
                        setState(() {
                            obscure = !obscure;
                        });
                      },
                      child:obscure ? Icon(Icons.visibility): Icon(Icons.visibility_off),
                    )

                  )
                  ,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Confirm Password"),
                ),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: obscure2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Confirm your Password",
                    hintStyle: TextStyle(
                      color: Colors.black38
                    ),
                    prefixIcon: Icon(Icons.password),
                    suffixIcon: GestureDetector(
                      onTap: (){
                      setState(() {
                        obscure2 = !obscure2;
                      });   
                      },
                      child: obscure2? Icon(Icons.visibility): Icon(Icons.visibility_off),
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
                    ElevatedButton(onPressed: () async{
                   /*   await registorUser(userNameEmailController.text.trim(), passwordController.text.trim(), firstNameController.text.trim(), phone, gender);*/
                      signUpValidation();
                    },
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

