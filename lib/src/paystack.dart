import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack_plus/src/abstract_class.dart';

class FlutterPaystackPlus {
  static Future<void> openPaystackPopup({
    required String customerEmail,
    required String amount,
    required String reference,
    String? callBackUrl,
    String? publicKey,
    String? secretKey,
    String? currency,
    BuildContext? context,
    String? plan,
    Map? metadata,
    required void Function() onClosed,
    required void Function() onSuccess,
    List<String>? channels,
  }) async {
    final makePlatformSpecificPayment = MakePlatformSpecificPayment();

    if (kIsWeb) {
      if (publicKey == null || publicKey.isEmpty) {
        throw Exception('Please provide your Paystack public key');
      }
    } else {
      if (context == null) {
        throw Exception('Pass down your BuildContext');
      }
      if (secretKey == null || secretKey.isEmpty) {
        throw Exception('Please provide your Paystack secret key');
      }
    }

    final cancelMetaData = {"cancel_action": "cancelurl.com"};
    if (metadata == null) {
      metadata = cancelMetaData;
    } else {
      metadata.addEntries(cancelMetaData.entries);
    }

    return await makePlatformSpecificPayment.makePayment(
      customerEmail: customerEmail,
      context: context,
      currency: currency,
      publicKey: publicKey,
      secretKey: secretKey,
      amount: amount,
      metadata: metadata,
      plan: plan,
      reference: reference,
      onClosed: onClosed,
      onSuccess: onSuccess,
      callBackUrl: callBackUrl,
      channels: channels,
    );
  }
}
