import 'package:flutter/material.dart';
import 'package:flutter_crud/screens/auth/auth_provider.dart';
import 'package:flutter_crud/utils/helper.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  
  const RegisterScreen({super.key});

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
                        Text("Register", style: TextStyle(fontSize: 26)),
                        SizedBox(height: 24),
                        TextFormField(
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              hintText: "Masukkan nama anda"
                          ),
                          onChanged: (value) {
                            readProvider.name = value.trim();
                          },
                          validator: (value) {
                            if (value == null || value
                                .trim()
                                .isEmpty) {
                              return "Nama tidak boleh kosong";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: "Masukkan email anda"
                          ),
                          onChanged: (value) {
                            readProvider.email = value.trim();
                          },
                          validator: (value) {
                            if (value == null || value
                                .trim()
                                .isEmpty) {
                              return "Email tidak boleh kosong";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: "Masukkan password anda"
                          ),
                          onChanged: (value) {
                            readProvider.password = value.trim();
                          },
                          validator: (value) {
                            if (value == null || value
                                .trim()
                                .isEmpty) {
                              return "Password tidak boleh kosong";
                            }
                            if (value.trim().length < 8) {
                              return "Password kurang dari 8 karakter";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: "Konfirmasi password anda"
                          ),
                          onChanged: (value) {
                            readProvider.passwordConfirmation = value.trim();
                          },
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Konfirmasi Password tidak boleh kosong";
                            }
                            if (value.trim().length < 8) {
                              return "Konfirmasi Password kurang dari 8 karakter";
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
                                  actionRegister(readProvider, context);
                               }
                              },
                              child: Text("Register")
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Sudah punya akun? Silahkan masuk "),
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                    "disini", style: TextStyle(color: Colors.blue))
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        );
  }

  void actionRegister(AuthProvider readProvider, BuildContext context) async {
    try {
      await readProvider.register().then((value) {
        // Handle successful registration
        Helper.showSnackBar(context, value.message?? "Registration successful", color: Colors.green);
        Navigator.pop(context);
      })
      .catchError((error) {
        // Handle registration error
        Helper.showSnackBar(context, error.toString());
      });
    } catch (e) {
      // Handle registration error
      Helper.showSnackBar(context, e.toString());
    }
  }

}