import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';



class MyWebView extends StatefulWidget {
  final String url;

  MyWebView({required this.url});

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMART'),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: (String url) {
              setState(() {
                _isLoading = true;
              });
            },
            onPageFinished: (String url) {
              setState(() {
                _isLoading = false;
              });
            },
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(),
        ],
      ),
    );
  }
}