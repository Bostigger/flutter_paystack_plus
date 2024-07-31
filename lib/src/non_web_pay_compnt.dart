import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class PaystackPayNow extends StatefulWidget {
  final String secretKey;
  final String reference;
  final String callbackUrl;
  final String currency;
  final String email;
  final String amount;
  final String? plan;
  final dynamic metadata;
  final List<String>? paymentChannel;
  final void Function() transactionCompleted;
  final void Function() transactionNotCompleted;

  const PaystackPayNow({
    Key? key,
    required this.secretKey,
    required this.email,
    required this.reference,
    required this.currency,
    required this.amount,
    required this.callbackUrl,
    required this.transactionCompleted,
    required this.transactionNotCompleted,
    this.metadata,
    this.plan,
    this.paymentChannel,
  }) : super(key: key);

  @override
  State<PaystackPayNow> createState() => _PaystackPayNowState();
}

class _PaystackPayNowState extends State<PaystackPayNow> {
  late WebViewController _webViewController;
  bool _loading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _makePaymentRequest();
  }

  Future<void> _makePaymentRequest() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('https://api.paystack.co/transaction/initialize'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.secretKey}',
        },
        body: jsonEncode({
          "email": widget.email,
          "amount": widget.amount,
          "reference": widget.reference,
          "currency": widget.currency,
          "plan": widget.plan,
          "metadata": widget.metadata,
          "callback_url": widget.callbackUrl,
          "channels": widget.paymentChannel,
        }),
      );

      if (response.statusCode == 200) {
        final data = PaystackRequestResponse.fromJson(jsonDecode(response.body));
        _initializeWebView(data.authUrl, data.reference);
      } else {
        _handleError("Error: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      _handleError(e.toString());
    }
  }

  Future<void> _checkTransactionStatus(String ref) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.paystack.co/transaction/verify/$ref'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.secretKey}',
        },
      );

      if (response.statusCode == 200) {
        final decodedRespBody = jsonDecode(response.body);
        if (decodedRespBody["data"]["gateway_response"] == "Approved" ||
            decodedRespBody["data"]["gateway_response"] == "Successful") {
          widget.transactionCompleted();
        } else {
          widget.transactionNotCompleted();
        }
      } else {
        _handleError("Verification failed: ${response.body}");
        widget.transactionNotCompleted();
      }
    } catch (e) {
      _handleError(e.toString());
      widget.transactionNotCompleted();
    }
  }

  void _initializeWebView(String url, String reference) {
    setState(() {
      _loading = false;
    });

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent("Flutter;Webview")
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) async {
            if (request.url.contains('cancelurl.com') ||
                request.url.contains('paystack.co/close') ||
                request.url.contains(widget.callbackUrl)) {
              await _checkTransactionStatus(reference).then((_) {
                Navigator.of(context).pop();
              });
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  void _handleError(String error) {
    setState(() {
      _loading = false;
      _errorMessage = error;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $error")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
            ? Center(child: Text('Error: $_errorMessage'))
            : WebViewWidget(controller: _webViewController),
      ),
    );
  }
}

class PaystackRequestResponse {
  final bool status;
  final String authUrl;
  final String reference;

  const PaystackRequestResponse({
    required this.authUrl,
    required this.status,
    required this.reference,
  });

  factory PaystackRequestResponse.fromJson(Map<String, dynamic> json) {
    return PaystackRequestResponse(
      status: json['status'],
      authUrl: json['data']["authorization_url"],
      reference: json['data']["reference"],
    );
  }
}
