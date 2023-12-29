import 'package:flutter/material.dart';
import 'package:freelancediteur/utils/flutterwave/core/transaction_status.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils.dart';

class FlutterwaveWebview extends StatefulWidget {
  final String _url;
  final String _redirectUrl;
  final bool _isTestMode;

  FlutterwaveWebview(this._url, this._redirectUrl, this._isTestMode);

  @override
  _FlutterwaveWebviewState createState() => _FlutterwaveWebviewState();
}

class _FlutterwaveWebviewState extends State<FlutterwaveWebview> {
  @override
  void initState() {
    super.initState();
  }

  late final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: this._pageStarted,
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }

          if (_hasCompletedTransaction(request.url)) {
            _processTransactionData(request.url);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('https://flutter.dev'));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: widget._isTestMode,
      home: Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: WebViewWidget(
              controller: controller,
            ),
          ),
        ),
      ),
    );
  }

  String _getRedirectUrl() {
    return this.widget._redirectUrl.isEmpty
        ? Utils.DEFAULT_URL
        : this.widget._redirectUrl;
  }

  void _processTransactionData(String url) {
    final uri = Uri.parse(url);
    final String? status = uri.queryParameters["status"];
    final Map<String, dynamic> result = Map();
    if ("successful" == status) {
      result["tx_ref"] = uri.queryParameters["tx_ref"];
      result["transaction_id"] = uri.queryParameters["transaction_id"];
      result["status"] = TransactionStatus.SUCCESSFUL;
    } else if ("cancelled" == status) {
      result["status"] = TransactionStatus.CANCELLED;
    } else {
      result["status"] = TransactionStatus.ERROR;
    }
    result["success"] = TransactionStatus.SUCCESSFUL == status;
    return Navigator.pop(this.context, result);
  }

  bool _hasCompletedTransaction(url) {
    final uri = Uri.parse(url);
    final String? status = uri.queryParameters["status"];
    return url.contains(_getRedirectUrl()) && status != null;
  }

  void _pageStarted(String url) {
    final redirectUrl = _getRedirectUrl();

    final bool startsWithMyRedirectUrl =
        url.toString().indexOf(redirectUrl.toString()) == 0;

    if (url != this.widget._url && startsWithMyRedirectUrl) {
      return this._onValidationSuccessful(url);
    }
  }

  void _onValidationSuccessful(String url) {
    _processTransactionData(url);
  }
}
