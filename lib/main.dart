import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'provider/auth_provider.dart';
import 'provider/theme_provider.dart';
import 'utils/cache_manager.dart';
import 'utils/notifi_service.dart';
import 'welcome/welcome.dart';

Future<void> main() async {
   WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
   FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
   await CacheManager.init();
   NotificationService().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()..initialize()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) => MaterialApp(
          title: 'User Registration',
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.blueGrey,
            fontFamily: 'Poppins',
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.blueGrey,
            fontFamily: 'Poppins',
          ),
          themeMode: theme.themeMode,
          debugShowCheckedModeBanner: false,
          home: const Welcome(),
        ),
      ),
    );
  }
}


