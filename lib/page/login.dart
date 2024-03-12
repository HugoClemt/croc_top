import 'package:croc_top/page/register.dart';
import 'package:croc_top/auth/supabase_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _loginUser() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      await AuthService.signIn(email, password, context);
    } catch (error) {
      print('Login failed: $error');
    }
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
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
                  onPressed: _loginUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[200],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('Login',
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
                  onTap: _goToRegister,
                  child: RichText(
                    text: const TextSpan(
                      text: "Vous n'avez pas de compte ? ",
                      style: TextStyle(color: Colors.black, fontSize: 14.0),
                      children: [
                        TextSpan(
                          text: 'Inscrivez-vous',
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
