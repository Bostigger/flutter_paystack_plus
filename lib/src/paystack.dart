import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack_plus/src/abstract_class.dart';
import 'package:flutter_paystack_plus/src/stub.dart'
if (dart.library.js) 'package:flutter_paystack_plus/src/paystack_interop.dart'
if (dart.library.io) 'package:flutter_paystack_plus/src/for_non_web.dart';

class FlutterPaystackPlus {
  static Future<void> openPaystackPopup({
    /// Email of the customer
    required String customerEmail,

    /// [amount] should be multiplied by 100 [eg amount * 100]
    required String amount,

    /// Alpha numeric and/or number ID to a transaction
    required String reference,

    /// URL to redirect to after payment is successful, this helps close the session.
    /// This is set up in the Dashboard of Paystack and the same URL setup is then provided here by you again.
    /// [callBackUrl] is required for mobile only
    String? callBackUrl,

    /// [publicKey] is required for web only
    String? publicKey,

    /// [secretKey] is required for Android and iOS only
    String? secretKey,

    /// Currency of the transaction
    String? currency,

    /// [context] is required for Android and iOS only
    BuildContext? context,

    /// In case your payment was set up with a subscription pattern/plan
    String? plan,

    /// Extra data for developer purposes.
    Map? metadata,

    /// [onClosed] is called when the user cancels a transaction or when there is a failed transaction
    required void Function() onClosed,

    /// [onSuccess] is called on successful transactions
    required void Function() onSuccess,

    /// Channels to use for the transaction
    List<String>? channels,
  }) async {
    final MakePlatformSpecificPayment makePlatformSpecificPayment = MakePlatformSpecificPayment();
    if (kIsWeb) {
      // because public key is needed for web
      if (publicKey == null) {
        throw Exception('Please provide your Paystack public key');
      } else if (publicKey.isEmpty) {
        throw Exception('Please provide a valid Paystack public key');
      }
    } else {
      // meaning it's running on mobile
      if (context == null) {
        // because context is needed for mobile
        throw Exception('Pass down your BuildContext');
      } else if (secretKey == null) {
        // because Secret key is needed for mobile
        throw Exception('Please provide your Paystack secret key');
      } else if (secretKey!.isEmpty) {
        throw Exception('Please provide a valid Paystack secret key');
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
