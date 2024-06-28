import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../account/account.dart';
import '../db/dbhelper.dart';
import '../model/item.dart';
import '../popup/popup.dart';
import '../provider/auth_provider.dart';
import '../provider/theme_provider.dart';
import '../utils/cache_manager.dart';
import 'additem.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void addItem() {
    if (CacheManager.getInt("loginflag") == 0) {
      dialogBuilder(context, "Alert!!!!", "Please login to add item", "Ok", false, "Cancel");
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddItemScreen()),
      ).then((_) {
        setState(() {
          _items = DatabaseHelper().getItems();
        });
      });
    }
  }

  void editItem(Item item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddItemScreen(item: item)),
    ).then((_) {
      setState(() {
        _items = DatabaseHelper().getItems();
      });
    });
  }

  late Future<List<Item>> _items;

  @override
  void initState() {
    super.initState();
    _items = DatabaseHelper().getItems();
    getuser();
  }
  
   void getuser() async {
    debugPrint(CacheManager.getString("email"));
    debugPrint(CacheManager.getString("password"));
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(CacheManager.getString("email"), CacheManager.getString("password"));


    if (success) {
        const SnackBar(content: Text('  Welcome to back'));
    } else {
      const SnackBar(content: Text('Log out'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Consumer<ThemeProvider>(builder: (context, theme, _) {
              var currentTheme = theme.currentTheme;
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: IconButton(
                  onPressed: () {
                    currentTheme == "light" ? theme.changeTheme("dark") : theme.changeTheme("light");
                  },
                  icon: Icon(currentTheme == "light" ? Icons.dark_mode : Icons.light_mode),
                  splashRadius: 26,
                  key: ValueKey(currentTheme),
                ),
              );
            }),
          ),
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 1,
                child: Text('My Account'),
              ),
            ],
            onSelected: (value) => {
              if (value == 1)
                {
                  Navigator.push(context, MaterialPageRoute(builder: ((context) => const UserInfo()))),
                }
            },
          ),
        ],
      ),
      body: (CacheManager.getInt("loginflag") == 1)
          ? FutureBuilder<List<Item>>(
              future: _items,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No items found'));
                } else {
                  return ListView.separated(
                    itemCount: snapshot.data!.length,
                    
                    itemBuilder: (context, index) {
                      final item = snapshot.data![index];
                      return ListTile(
                        leading: ClipOval(
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(item.imageUrl),
                          ),
                        ),
                        title: Text(item.name),
                        subtitle: Text(item.description),
                        trailing: Text('Rating: ${item.rating}'),
                        onTap: () => editItem(item),
                      );
                       
                    },
                     separatorBuilder: (context, index) => const Divider(), 
                  );
                  
                }
              },
            )
          : const Column(
              children: [
                Padding(
                                padding:  EdgeInsets.only(top: 250.00),
                                child: Center(
                  child: Text('Hi Guest User'),
                )
                               
                              ),
                
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addItem();
        },
        child: Icon(Icons.add),
      ),
    );
  }}