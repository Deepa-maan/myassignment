import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../db/dbhelper.dart';
import '../login/account_login.dart';
import '../popup/popup.dart';
import '../provider/auth_provider.dart';
import '../utils/cache_manager.dart';
import '../utils/common_webview.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  AccountScreen createState() => AccountScreen();
}

class AccountScreen extends State<UserInfo> {
  bool islogin = false;
  String? user;
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _changePassword(String username) async {
    final String oldPassword = _oldPasswordController.text;
    final String newPassword = _newPasswordController.text;

    if (_formKey.currentState?.validate() ?? false) {
      // Verify old password
      final user = await DatabaseHelper.instance.getUser(username);
      if (user != null && user['password'] == oldPassword) {
        // Change password
        int result = await DatabaseHelper.instance.changePassword(username, newPassword);
        if (result > 0) {
          dialogBuilder(context, "Done", "Password changed successfully", "Ok", false, "Cancel");
        } else {
          dialogBuilder(context, "Error", "Failed to change password", "Ok", false, "Cancel");
        }
      } else {
        dialogBuilder(context, "Alert!!!!", "Old password is incorrect", "Ok", false, "Cancel");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (CacheManager.getInt("loginflag") == 1) {
      setState(() {
        islogin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final username = authProvider.username;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: islogin && username != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<Map<String, dynamic>?>(
                      future: DatabaseHelper.instance.getUser(username),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return Center(child: Text('No user data found'));
                        } else {
                          final user = snapshot.data!;
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('About Me'),
                                const SizedBox(height: 10),
                                _buildProfileData('Your Name', '${user['username']}'),
                                _buildProfileData('Contact Number', '${user['contactNumber']}'),
                                _buildProfileData('Email', '${user['email']}'),
                                _buildProfileData('Start Date', '2024-01-01'),
                                _buildProfileData('Submission Date', '2024-12-31'),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildChangePasswordSection(username),
                    const SizedBox(height: 20),
                    _buildaboutUs(context),
                    const SizedBox(height: 20),
                    _buildLogoutButton(context),
                  ],
                )
              : Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 250.00),
                      child: Center(
                        child: Text('You are a Guest User'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildLogoutButton(context),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildProfileData(String title, String data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(data),
      ],
    );
  }

  Widget _buildChangePasswordSection(String username) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Change Password'),
          TextFormField(
            controller: _oldPasswordController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter old password',
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your old password';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _newPasswordController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter new password',
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a new password';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _changePassword(username),
            child: const Text('Change Password'),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          CacheManager.setInt("loginflag", 0);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const Login()),
            (route) => false,
          );
        },
        child: const Text('Logout'),
      ),
    );
  }

  Widget _buildaboutUs(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: ((context) => MyWebView(url: 'https://www.digitalmatty.com/'))));
      },
      child: const Text('Contact Us'),
    );
  }
}
