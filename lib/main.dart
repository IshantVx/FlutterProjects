import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:newflutterproject/firebase_options.dart';
import 'package:newflutterproject/login_Page.dart';
import 'package:newflutterproject/tabPage.dart';
import 'package:newflutterproject/themeProvider.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized() ;
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  runApp(

    ChangeNotifierProvider(
      create: (_) =>ThemeProvider(),
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode,
      home:  StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, asyncSnapshot) {
          if(asyncSnapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(asyncSnapshot.data != null){
            return const Tabpage();
          }
          return LonginScreen();
        }
      ),
    );
  }
}
