import 'package:flutter/material.dart';
import 'package:flutter_paystack_plus/src/abstract_class.dart';

class PaystackStub implements MakePlatformSpecificPayment {
  @override
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
  }) async {
    throw UnsupportedError('Cannot make payment on this platform');
  }
}

MakePlatformSpecificPayment makePlatformSpecificPayment() => PaystackStub();
