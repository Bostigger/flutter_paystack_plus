import 'package:flutter/material.dart';
import 'package:flutter_paystack_plus/src/abstract_class.dart';

class PayForMobile implements MakePlatformSpecificPayment {
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
    // Mobile-specific implementation
    // Here you will add the logic to use the channels parameter
  }
}

MakePlatformSpecificPayment makePlatformSpecificPayment() => PayForMobile();
