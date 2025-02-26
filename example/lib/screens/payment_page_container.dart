/*
 * Copyright (c) Juspay Technologies.
 *
 * This source code is licensed under the AGPL 3.0 license found in the
 * LICENSE file in the root directory of this source tree.
 */

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:juspayglobalsdkflutter/juspayglobalsdkflutter.dart';

import '../utils/generate_payload.dart';
import './success.dart';
import './failed.dart';

class ContainerPaymentPage extends StatefulWidget {
  final HyperSDK hyperSDK;
  final String amount;
  final Map<String, dynamic> merchantDetails;
  final Map<String, dynamic> customerDetails;
  const ContainerPaymentPage(
      {Key? key,
      required this.hyperSDK,
      required this.amount,
      required this.merchantDetails,
      required this.customerDetails})
      : super(key: key);

  @override
  _ContainerPaymentPageState createState() => _ContainerPaymentPageState();
}

class _ContainerPaymentPageState extends State<ContainerPaymentPage> {
  var showLoader = false;
  var processCalled = false;
  var paymentSuccess = false;
  var paymentFailed = false;

  var orderId = "";
  @override
  Widget build(BuildContext context) {
    // if (!processCalled) {
    //   callProcess();
    // }

    navigateAfterPayment(context);
    var processPayload = getProcessPayload(
        widget.amount, widget.merchantDetails, widget.customerDetails);

    // Overriding onBackPressed to handle hardware backpress
    // block:start:onBackPressed
    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          var backpressResult = await widget.hyperSDK.onBackPress();

          if (backpressResult.toLowerCase() == "true") {
            return false;
          } else {
            return true;
          }
        } else {
          return true;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(children: [
          Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Center(
                child: showLoader
                    ? const CircularProgressIndicator()
                    : Container(
                        // color: Colors.deepPurple,
                        // padding: const EdgeInsets.all(20.0),
                        child: FutureBuilder(
                            future: processPayload,
                            builder: (BuildContext context,
                                AsyncSnapshot<Map<String, dynamic>> snapshot) {
                              if (snapshot.hasData) {
                                var processPayload = snapshot.requireData;
                                var payload = processPayload["payload"];
                                var orderDetails = payload["orderDetails"];
                                orderId = jsonDecode(orderDetails)["order_id"];
                                return widget.hyperSDK.HyperSdkView(
                                    processPayload, hyperSDKCallbackHandler);
                              } else {
                                return const CircularProgressIndicator();
                              }
                            }),
                      )),
          ),
        ]),
      ),
    );
  }

  void callProcess() async {
    processCalled = true;

    // Get process payload from backend
    // block:start:fetch-process-payload
    var processPayload = await getProcessPayload(
        widget.amount, widget.merchantDetails, widget.customerDetails);
    var payload = processPayload["payload"];
    var orderDetails = payload["orderDetails"];
    orderId = jsonDecode(orderDetails)["order_id"];
    // block:end:fetch-process-payload

    // Calling process on hyperSDK to open payment page
    // block:start:process-sdk
    print('The process payload $processPayload');
    await widget.hyperSDK.process(processPayload, hyperSDKCallbackHandler);
    //block:end:process-sdk
  }

  void openPaymentPage() async {
    // Get sdk payload from backend
    var sdkPayload = await getProcessPayload(
        widget.amount, widget.merchantDetails, widget.customerDetails);

    // Calling openPaymentPage on hyperSDK to open payment page
    await widget.hyperSDK.openPaymentPage(sdkPayload, hyperSDKCallbackHandler);
    // block:end:process-sdk
  }

  // Define handler for callbacks from hyperSDK
  // block:start:callback-handler
  void hyperSDKCallbackHandler(MethodCall methodCall) {
    switch (methodCall.method) {
      case "hide_loader":
        setState(() {
          showLoader = false;
        });
        break;
      case "button_click":
        try {
          var args = json.decode(methodCall.arguments);
          var innerPayload = args["payload"] ?? {};
          if (innerPayload["button_name"] == "view_details") {
            _showBottomSheetForUpdateOrder(context);
          }
        } catch (e) {
          print(e);
        }
        break;
      case "paymentAttempt":
        print("Calling _showBottomSheetForUpdateOrder ");
        _showBottomSheetForUpdateOrder(context);
        break;
      case "process_result":
        var args = {};

        try {
          args = json.decode(methodCall.arguments);
        } catch (e) {
          print(e);
        }

        var error = args["error"] ?? false;

        var innerPayload = args["payload"] ?? {};

        var status = innerPayload["status"] ?? " ";
        var pi = innerPayload["paymentInstrument"] ?? " ";
        var pig = innerPayload["paymentInstrumentGroup"] ?? " ";
        print("$pi, $pig");

        if (!error) {
          switch (status) {
            case "charged":
              {
                // block:start:check-order-status
                // Successful Transaction
                // check order status via S2S API
                // block:end:check-order-status
                setState(() {
                  paymentSuccess = true;
                  paymentFailed = false;
                });
              }
              break;
            case "cod_initiated":
              {
                // User opted for cash on delivery option displayed on payment page
              }
              break;
          }
        } else {
          var errorCode = args["errorCode"] ?? " ";
          var errorMessage = args["errorMessage"] ?? " ";
          print("$errorCode, $errorMessage");

          switch (status) {
            case "backpressed":
              {
                // user back-pressed from PP without initiating any txn
                setState(() {
                  paymentFailed = true;
                  paymentSuccess = false;
                });
              }
              break;
            case "user_aborted":
              {
                // user initiated a txn and pressed back
                // check order status via S2S API
                setState(() {
                  paymentFailed = true;
                  paymentSuccess = false;
                });
              }
              break;
            case "pending_vbv":
              {}
              break;
            case "authorizing":
              {
                // txn in pending state
                // check order status via S2S API
              }
              break;
            case "authorization_failed":
              {
                setState(() {
                  paymentFailed = true;
                  paymentSuccess = false;
                });
              }
              break;
            case "authentication_failed":
              {
                setState(() {
                  paymentFailed = true;
                  paymentSuccess = false;
                });
              }
              break;
            case "api_failure":
              {
                // txn failed
                // check order status via S2S API
                setState(() {
                  paymentFailed = true;
                  paymentSuccess = false;
                });
              }
              break;
            case "new":
              {
                // order created but txn failed
                // check order status via S2S API
                setState(() {
                  paymentFailed = true;
                  paymentSuccess = false;
                });
              }
              break;
            default:
              {
                setState(() {
                  paymentFailed = true;
                  paymentSuccess = false;
                });
              }
              break;
          }
        }
    }
  }
  // block:end:callback-handler

  // Define your callback function
  Future<void> _showBottomSheetForUpdateOrder(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return BottomSheetContent(
                hyperSDK: widget.hyperSDK,
                amount: widget.amount,
                orderId: orderId,
                merchantDetails: widget.merchantDetails,
                customerDetails: widget.customerDetails,
                callback: hyperSDKCallbackHandler);
          },
        );
      },
    );
  }

  void navigateAfterPayment(BuildContext context) {
    if (paymentSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SuccessScreen()));
      });
    } else if (paymentFailed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const FailedScreen()));
      });
    }
  }
}

typedef HyperSDKCallback = void Function(MethodCall methodCall);

class BottomSheetContent extends StatefulWidget {
  final HyperSDK hyperSDK;
  final String amount;
  final Map<String, dynamic> merchantDetails;
  final Map<String, dynamic> customerDetails;
  final String orderId;
  final HyperSDKCallback callback;

  const BottomSheetContent({
    Key? key,
    required this.hyperSDK,
    required this.amount,
    required this.orderId,
    required this.merchantDetails,
    required this.customerDetails,
    required this.callback,
  }) : super(key: key);

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  late TextEditingController _myController;
  late String _newAmount;

  @override
  void initState() {
    super.initState();
    _myController = TextEditingController(text: widget.amount);
    _newAmount = widget.amount;
  }

  @override
  void dispose() {
    _myController.dispose();
    super.dispose();
  }

  void _resetState() {
    _myController.text = widget.amount;
    _newAmount = widget.amount;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          TextField(
            controller: _myController,
            onChanged: (value) => _newAmount = value,
            decoration: const InputDecoration(
              labelText: 'Enter Amount',
              border: UnderlineInputBorder(),
            ),
            autofocus: true,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () async {
              var updateOrderPayload = await getUpdateOrderPayload(
                widget.orderId,
                widget.merchantDetails,
                widget.customerDetails,
                _newAmount,
              );
              print("Called updated order");
              widget.hyperSDK.process(updateOrderPayload, widget.callback);
              Navigator.of(context).pop();
              _resetState(); // Reset the state here
            },
            child: const Text('Call Update Order'),
          ),
        ],
      ),
    );
  }
}
