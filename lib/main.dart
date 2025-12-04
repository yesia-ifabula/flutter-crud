import 'package:flutter/material.dart';
import 'package:flutter_crud/screens/auth/login_screen.dart';
import 'package:flutter_crud/screens/list/list_item_provider.dart';
import 'package:flutter_crud/screens/list/list_item_screen.dart';
import 'package:flutter_crud/services/auth_service.dart';
import 'package:flutter_crud/services/item_service.dart';
import 'package:flutter_crud/utils/helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => AuthService()),
        Provider(create: (context) => ItemService()),
        ChangeNotifierProvider(
          create: (context) => ListItemProvider(context.read<ItemService>()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        ),
        home: FutureBuilder(
          future: isLoggedIn(), 
          builder: (context, snapshot) {
            if (snapshot.data == true) {
              return ListItemScreen();
            } 
            return const LoginScreen();
            
          }
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  Future<bool> isLoggedIn () async {
    // Simulate some initialization work
    final session = await SharedPreferences.getInstance();
    final isLogin = session.getBool(Helper.IS_LOGIN) ?? false;
    
    return isLogin;
  }
}
