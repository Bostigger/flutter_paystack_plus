import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack_plus/src/paystack_interop.dart';
import 'package:flutter_paystack_plus/src/stub.dart'
if (dart.library.js) 'package:flutter_paystack_plus/src/paystack_interop.dart'
if (dart.library.io) 'package:flutter_paystack_plus/src/for_non_web.dart';

import 'for_non_web.dart';

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
    if (kIsWeb) {
      return PayForWeb();
    } else {
      return PayForMobile();
    }
  }
}
