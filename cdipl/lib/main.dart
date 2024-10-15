import 'dart:convert';

import 'package:cdipl/auth/login.dart';
import 'package:cdipl/helpers/tokenmanager.dart';
import 'package:cdipl/home/home.dart';
import 'package:cdipl/models/usermodel.dart';
import 'package:cdipl/providers/call_log_provider.dart';
import 'package:cdipl/providers/userprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cdipl/constants.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  return runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => CallLogProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  // initState() {
  //   super.initState();
  //   fetchData();
  // }

  String token = '';
  Future<void> fetchData() async {
    token = await TokenManager.getToken() ?? '';
    print('$token,token');
    try {
      final response = await http.get(
        Uri.parse('${serverurl}/userdetail'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print(response.body);

      if (response.statusCode == 200) {
        print('app line302');
        var data = jsonDecode(response.body);

        print(data);
        final userdata = User.fromJson(data['user']);

        Provider.of<UserProvider>(context, listen: false).setUser(userdata);

        print('Data: $data');
      } else {
        await TokenManager.removeToken();
        Provider.of<UserProvider>(context, listen: false).logout();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      }
    } catch (e) {
      print('Error during data fetching: $e');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Provider.of<UserProvider>(context).user != null
              ? HomePage()
              : LoginScreen();
        }
      },
    ));
  }
}
