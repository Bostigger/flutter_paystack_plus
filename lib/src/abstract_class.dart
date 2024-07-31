import 'package:flutter/material.dart';

abstract class MakePlatformSpecificPayment {
  Future<void> makePayment({
    required String customerEmail,
    required String amount,
    required String reference,
    required String? publicKey,
    required String? secretKey,
    required String? currency,
    required String? callBackUrl,
    String? plan,
    required Map? metadata,
    required BuildContext? context,
    required void Function() onClosed,
    required void Function() onSuccess,
    List<String>? channels,
  });

  factory MakePlatformSpecificPayment() {
    throw UnsupportedError('Cannot create a MakePlatformSpecificPayment.');
  }
}
