import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import '../db/dbhelper.dart';
import '../home/home.dart';
import '../popup/popup.dart';
import '../provider/auth_provider.dart';
import '../signup/signup.dart';
import '../utils/cache_manager.dart';
import '../utils/notifi_service.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => myForgotPassword();
}

class myForgotPassword extends State<ForgotPassword> {
 
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
    final success = await authProvider.forgotpassword(userController.text);

    setState(() {
      _showProgress = false;
    });

    if (success) {
      final user = await DatabaseHelper.instance.getUser(userController.text);
      if (user != null) {
        await NotificationService().myshowNotification("Your Password",
                                                       user['password'],
                                                       "password");

      }
      
     
    } else {
      dialogBuilder(context, "Alert!!!!", "Email not found in system", "Ok", false, "cancel");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: const Text('Forgot Password'),
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
                
                const SizedBox(
                  height: 30,
                ),
                (_showProgress)
                    ? const CircularProgressIndicator()
                    : FilledButton(
                        onPressed: () {
                          submit();
                        },
                        child: const Text(
                          ' Get Password  ',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),

                      FilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          ' Back  ',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
