import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freelancediteur/network/rest_api_call.dart';
import 'package:freelancediteur/utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../main.dart';
import 'NoInternetConnection.dart';

// ignore: must_be_immutable
class WebViewScreen extends StatefulWidget {
  String url = "";
  String? title = "";
  String? orderId = "";

  WebViewScreen(this.url, this.title, {this.orderId});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  //Completer<WebViewController> _controller = Completer<WebViewController>();
  bool mFetchingFile = true;

  @override
  void initState() {
    super.initState();
  }

  ///
  Future updateOrder() async {
    var request = {
      'set_paid': true,
      'status': "completed",
    };

    if (await isNetworkAvailable()) {
      updateOrderRestApi(request, widget.orderId).then((res) async {
        pop({'orderCompleted': true});
      }).catchError((e) {
        log("${e.toString()}");
      });
    } else {
      NoInternetConnection().launch(context);
    }
  }

  late final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {
          setState(() {
            mFetchingFile = true;
          });
        },
        onPageFinished: (String url) async {
          setState(() {
            mFetchingFile = false;
          });
          if (url.contains("checkout/order-received")) {
            setState(() {
              mFetchingFile = true;
            });
            updateOrder();
          }
        },
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }

          return NavigationDecision.navigate;
        },
      ),
    )
    ..addJavaScriptChannel(
      'Toaster',
      onMessageReceived: (JavaScriptMessage message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message.message)),
        );
      },
    )
    ..loadRequest(Uri.parse('https://flutter.dev'));

  @override
  Widget build(BuildContext context) {
    Widget mainWebView = WebViewWidget(controller: controller

        /*
      initialUrl: widget.url,
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
      },
      */

        );

    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: appBar(context, title: widget.title),
      body: Stack(
        children: <Widget>[
          Container(
            child: mainWebView,
            width: context.width(),
            height: context.height(),
          ),
          if (mFetchingFile)
            Center(
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                  padding: EdgeInsets.all(20),
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                elevation: 10,
                margin: EdgeInsets.all(30),
              ),
            )
        ],
      ),
    );
  }
}
