import 'package:croc_top/page/login.dart';
import 'package:croc_top/page/profile_setup.dart';
import 'package:croc_top/utils/supabase_service.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _registerUser() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      await AuthService.signUp(email, password);
      print('Registration successful');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileSetupPage()),
      );
    } catch (error) {
      print('Registration failed: $error');
    }
  }

  void _goToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[200],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('S\'incrire',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontFamily: 'Roboto')),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12.0),
                child: GestureDetector(
                  onTap: _goToLogin,
                  child: RichText(
                    text: const TextSpan(
                      text: "Vous avez déjà un compte ? ",
                      style: TextStyle(color: Colors.black, fontSize: 14.0),
                      children: [
                        TextSpan(
                          text: 'Connectez-vous',
                          style: TextStyle(color: Colors.brown),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
