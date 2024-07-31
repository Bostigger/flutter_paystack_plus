import 'package:flutter/material.dart';
import 'package:flutter_paystack_plus/src/abstract_class.dart';
import 'package:js/js.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

@JS()
external paystackPopUp(
    String publicKey,
    String email,
    String amount,
    String ref,
    String plan,
    void Function() onClosed,
    void Function() callback,
    List<String>? channels,
    );

class PayForWeb implements MakePlatformSpecificPayment {
  @override
  Future<void> makePayment({
    required String customerEmail,
    required String amount,
    required String reference,
    String? callBackUrl,
    String? publicKey,
    String? secretKey,
    String? currency,
    metadata,
    String? plan,
    BuildContext? context,
    required void Function() onClosed,
    required void Function() onSuccess,
    List<String>? channels,
  }) async {
    js.context.callMethod(
      paystackPopUp(
        publicKey!,
        customerEmail,
        amount,
        reference,
        plan ?? '',
        js.allowInterop(onClosed),
        js.allowInterop(onSuccess),
        channels,
      ),
      [],
    );
  }
}

MakePlatformSpecificPayment makePlatformSpecificPayment() => PayForWeb();
