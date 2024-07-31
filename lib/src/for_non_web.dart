import 'package:flutter/material.dart';
import 'package:flutter_paystack_plus/src/abstract_class.dart';


import 'non_web_pay_compnt.dart';

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
    Navigator.push(
      context!,
      MaterialPageRoute(
        builder: (context) => PaystackPayNow(
          secretKey: secretKey!,
          email: customerEmail,
          reference: reference,
          currency: currency!,
          amount: double.parse(amount).toString(),
          callbackUrl: callBackUrl!,
          transactionCompleted: onSuccess,
          transactionNotCompleted: onClosed,
          metadata: metadata,
          plan: plan,
          paymentChannel: channels,
        ),
      ),
    );
  }
}
