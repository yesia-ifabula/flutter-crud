import 'package:flutter/material.dart';
import 'package:flutter_crud/screens/auth/auth_provider.dart';
import 'package:flutter_crud/screens/auth/register_screen.dart';
import 'package:flutter_crud/screens/list/list_item_screen.dart';
import 'package:flutter_crud/utils/helper.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(context.read()),
       builder: (context, asyncSnapshot) {
            final readProvider = context.read<AuthProvider>();
            final watchProvider = context.watch<AuthProvider>();

            return Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: readProvider.formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 24),
                        Text("Login", style: TextStyle(fontSize: 26)),
                        SizedBox(height: 24),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Masukkan email anda",
                          ),
                          onChanged: (value) {
                            readProvider.email = value.trim();
                          },
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Email tidak boleh kosong";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Masukkan password anda",
                          ),
                          onChanged: (value) {
                            readProvider.password = value.trim();
                          },
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Password tidak boleh kosong";
                            }
                            if (value.trim().length < 8) {
                              return "Password kurang dari 8 karakter";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8),
                        watchProvider.isLoading ? 
                         CircularProgressIndicator()
                         :
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              if (readProvider.formKey.currentState!.validate()) {
                                actionLogin(readProvider, context);
                              } 
                            },
                            child: Text("Login"),
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Belum punya akun? Silahkan daftar "),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>
                                          RegisterScreen()
                                      )
                                  );
                                },
                                child: Text("disini", style: TextStyle(color: Colors.blue))
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
      },
    );

  }
  
  void actionLogin(AuthProvider readProvider, BuildContext context) {
    try {
      readProvider.login().then((value) {
        // Handle successful login
        Helper.showSnackBar(context, value.message?? "Login successful", color: Colors.green);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ListItemScreen()),
          (route) => false,
        );
      })
      .catchError((error) {
        // Handle login error
        Helper.showSnackBar(context, error.toString());
      });
      
    } catch (e) {
      Helper.showSnackBar(context, e.toString());
    }
  }

}