import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../home/home.dart';
import '../login/account_login.dart';
import '../signup/signup.dart';
import '../utils/cache_manager.dart';

void main() {
runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     // title: 'Flutter Demo',
     debugShowCheckedModeBanner: false,
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 58, 183, 89)),
        useMaterial3: true,
      ),
     home: const Login(),
    );
  }
}


class  Welcome extends StatefulWidget {
    const Welcome({super.key});


  @override
  State<Welcome> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Welcome> {


  @override
  void initState() {
    super.initState();
     FlutterNativeSplash.remove();
      WidgetsBinding.instance!.addPostFrameCallback((_) {
      checkLogin();
    });
     
  }
  void checkLogin(){
    if(CacheManager.getInt("loginflag") == 1){
      Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const MyHomePage(title: 'Home')),
            (route) => false,
          );
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body:SingleChildScrollView(
              child: Center(
                   child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 250.00),
                                child: Center(
                                       child: SizedBox(
                                         width: 200,
                                         height: 150,
                                      child: Image.asset('assets/logo/launch_image.png')),
                               ),
                              ),
                             
                  const SizedBox(
                  height: 10,),
                    FilledButton(
                      onPressed: () {
                       Navigator.push(context, MaterialPageRoute(builder: ((context) => const Login())));
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
                  onPressed: (){
                    CacheManager.clearbykey("loginflag");
            
                    Navigator.push(context, MaterialPageRoute(builder: ((context) => const MyHomePage(title: 'Home',))));
                   },
              child: const Text(
                'Guest User',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
              const SizedBox(
                  height: 10,),



                      // const Text('New User? Create Account')
                      ],
                    ),

                ),
                  ),
  );
}
}

