import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import '../account/forgetpassword.dart';
import '../home/home.dart';
import '../popup/popup.dart';
import '../provider/auth_provider.dart';
import '../signup/signup.dart';
import '../utils/cache_manager.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Login> {
 
  final _formKey = GlobalKey<FormState>();
  var confirmPass;
  
  final userController = TextEditingController();
  final pwdController = TextEditingController();
  bool _showProgress = false;

  void submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _showProgress = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(userController.text, pwdController.text);

    setState(() {
      _showProgress = false;
    });

    if (success) {
      CacheManager.setInt("loginflag", 1);
      CacheManager.setString("email", userController.text);
      CacheManager.setString("password", pwdController.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Home')),
      );
    } else {
      dialogBuilder(context, "Alert!!!!", "Login failed", "Ok", false, "cancel");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 60.00),
                  child: Center(
                    child: SizedBox(
                        width: 200,
                        height: 150,
                        child: Image.asset('assets/logo/launch_image.png')),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: userController,
                    onFieldSubmitted: (value) {},
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value!)) {
                        return 'Enter a valid email!';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: 'Enter valid email id as abc@gmail.com'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: TextFormField(
                    controller: pwdController,
                    obscureText: true,
                    onFieldSubmitted: (value) {},
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Your Password';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Enter secure password'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                (_showProgress)
                    ? const CircularProgressIndicator()
                    : FilledButton(
                        onPressed: () {
                          submit();
                        },
                        child: const Text(
                          '  Login  ',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                const SizedBox(
                  height: 10,
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const Signup())));
                  },
                  child: const Text(
                    '  Sign up  ',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: ((context) => const ForgotPassword())));
                  },
                  child: const Text(
                    'Forgot Password',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
