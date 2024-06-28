import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/home.dart';
import '../popup/popup.dart';
import '../provider/auth_provider.dart';
import '../utils/cache_manager.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => Mysignup();
}

class Mysignup extends State<Signup> {
  bool passwordVisible = false;
  bool _showProgress = false;

  final usernameController = TextEditingController();
  final userphoneController = TextEditingController();
  final useremailController = TextEditingController();
  final userpassController = TextEditingController();
  final userpassconfirmController = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  final _formKey = GlobalKey<FormState>();
  var confirmPass;

  void _submit() async {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }else{
     
      
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.register(
        usernameController.text.toString(), 
        userpassController.text.toString(),
        userphoneController.text.toString(),
        useremailController.text.toString(),
        "",
        ""

        
        );
      if (success) {
         CacheManager.setInt("loginflag", 1);
         CacheManager.setString("email", useremailController.text);
         CacheManager.setString("password", userpassController.text);
                 Navigator.push(context, MaterialPageRoute(builder: ((context) => const MyHomePage(title: 'Home',))));
                } else {
                  dialogBuilder(context,"Alter!!!!","Registeration Faild","Ok",false,"cancle");
                }


      
      
    }
   
    _formKey.currentState?.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 10, bottom: 0),
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          alignment: Alignment.topCenter,
                          child: Image.asset('assets/logo/launch_image.png')),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 10, bottom: 0),
                      child: Container(
                        child: TextFormField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Name',
                              hintText: 'Name'),
                          keyboardType: TextInputType.name,
                          onFieldSubmitted: (value) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Your Name!';
                            } else if (value.length < 3) {
                              return 'Name must be at least 3 characters long!';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 10, bottom: 0),
                      child: Container(
                        child: TextFormField(
                          controller: userphoneController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Phone',
                              hintText: 'Phone Number'),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onFieldSubmitted: (value) {},
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Your Phone Number!';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 10, bottom: 0),
                      child: Container(
                        child: TextFormField(
                          controller: useremailController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                              hintText: 'Email address'),
                          keyboardType: TextInputType.emailAddress,
                          onFieldSubmitted: (value) {},
                          validator: (value) {
                            if (value!.isEmpty ||
                                !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value!)) {
                              return 'Enter a valid email!';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 10, bottom: 0),
                      child: Container(
                        child: TextFormField(
                          controller: userpassController,
                          obscureText: passwordVisible,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Password",
                            labelText: "Password",
                            helperText: "Password must contain special character",
                            helperStyle: TextStyle(color: Colors.green),
                            suffixIcon: IconButton(
                              icon: Icon(passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(
                                  () {
                                    passwordVisible = !passwordVisible;
                                  },
                                );
                              },
                            ),
                            alignLabelWithHint: false,
                            filled: true,
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (value) {},
                          validator: (value) {
                            confirmPass = value;
                            if (value!.isEmpty) {
                              return 'Enter a valid password!';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 10, bottom: 0),
                      child: Container(
                        child: TextFormField(
                          controller: userpassconfirmController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Confirm Password',
                              hintText: 'Confirm Password'),
                          onFieldSubmitted: (value) {},
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Re-Enter New Password";
                            } else if (value != confirmPass) {
                              return "Password must be same as above";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 10, bottom: 0),
                      child: Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedDate == null
                                    ? 'Date of Birth'
                                    : "${selectedDate!.toLocal()}"
                                        .split(' ')[0],
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () async {
                                final DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2101),
                                );
                                if (pickedDate != null && pickedDate != selectedDate) {
                                  setState(() {
                                    selectedDate = pickedDate;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: FilledButton(
                        onPressed: () {
                          _submit();
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
