/*
 * Copyright (c) Juspay Technologies.
 *
 * This source code is licensed under the AGPL 3.0 license found in the
 * LICENSE file in the root directory of this source tree.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:juspayglobalsdkflutter/juspayglobalsdkflutter.dart';
import 'package:uuid/uuid.dart';

import './checkout.dart';

import '../widgets/app_bar.dart';
import '../widgets/bottom_button.dart';

class HomeScreen extends StatefulWidget {
  final HyperSDK hyperSDK;

  const HomeScreen({Key? key, required this.hyperSDK}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var countProductOne = 0;
  var countProductTwo = 0;

  var customerDetails = {
    "customerId": "test_customer",
    "customerPhone": "9742144874",
    "customerEmail": "test@gmail.com"
  };

  var merchantDetails = {
    "clientId": "geddit",
    "merchantId": "picasso",
    "action": "paymentPage",
    "returnUrl": "",
    "currency": "INR",
    "privateKey":
        "MIIEpQIBAAKCAQEA4NT4NODZl6kHeO3wbpNBPP/GnIal0YaNDcg3/4a95PP8p6NS\n6tQH7jSY9o+gg8OU52g04BvWzkteQBU7jwQxwwzrSRQJFMzwJGTpZp7OAvOZ4krG\nHjfhPjxs5D+LDSsl9c3zcSpHLw/vKeZGBzZ40zjFIY0dlX9nrIE9at066+fWjy/S\n7pi0Uvairi5NOArWxu+FBixnw6P0W7Nu3zQa6BJB9No6XAgJce12GECXLCVA9oww\n7OiBOOwtezgAgz2RSiNKwfQkzbVDaLuxGwDZoqguQUyL26c6nRez1YnpokHy9nir\nwzjGMPWMR/TFyn5+f/7YeCoUxDiAGmS8mSM5WwIDAQABAoIBAQDIzq5ZXDI7+KZJ\n5gqGWFM+ThxwFPrpJsm484jAWvIkGZ8hgwg94N6sbKHqJeHxja/i9vmy6Gp0mnA1\nwEEPvWlMkq9a9+AcieY6Oz8Tfub1T+mzaaGFv9cXpRSE0BQ70Lv4zNePzXkCmbK8\ns4T8UDSeQugezVENA1vvgQb/+VP0+dGeMZOeqqDKTtFM0NlxrjtCxMVlXML9IEtB\nLS7rGBmNSHvoJtrGTxIiIx+B1BwIDfTscO65Uv0YpnttCeyAchRhPWUuO6B7wOV6\nkp6HEXfRT/np+lynbTSnULcBWOhJe7qh7E0TZbQUF7mzjcCUrn03QL1GVgffBB8H\n+8j1up2xAoGBAPio8T15PtwkEHhGRgNQmA8jmW0z2u/+uC2+4TvZkaHh0xpKiAZ1\n3Xe1BDn91arlewZgYl/sRV7wJPPm7DDYHlyFWtGIRqEefziexJJcUzx/7K66GUqn\ncA9ZRO2ZvClhpbzxFwkHvCcdPkTwf2VMogJ2LqB69Gs73cTnBd5o8BtHAoGBAOd3\n9xPVsttasoHcS4XapOM4zAvdHsJ4NCfxf9hrN+5KQ3z/sGMO4DDwESzlixzbQE53\nheZ5sp1HNt85bQRb7G0GIiEFirTsnj2KqZcUVE+vlA+i0nu5AVAj5jwyMyg8UvZy\n7yQg+/RclqcvreZYjOd/O+bAIcm8FaNY1KSS1VNNAoGBAPe3Fdyv1LdqFh47o7PZ\nriImzMnFRu6fSswHxEnjTPmABtXCOhB1itOeOT+saBd/1Tdc/aOhtNoHUkjIW7Ot\nGVICZ58lq3cG8qZtRFaqMyGqLxdBvcBpXXFs9QXeiVyQMpQveUs9sWsl7squ67r2\nxM6+/WRSGPxa/2sQ2v/eepQxAoGBAI/80HZGOTy67tBZeaGKoYe3jTbUFo5iuA8g\n66Z1DBXvnIvlgpQcbNoEfKqxIBiTSy2ErIbyrWmpIzk5P9e2Vxx69EAWcnKZvtYJ\nq/WPb+MiFbikUMsmCusPaemIUMp2vCUS2jBfVFxuPElEH6lq7DwVqe2hF2Om3M8A\nM0ctEAcBAoGABpkIjJX0dtFEiM5BSWtXhq/hgy1EivH+C0iTgfmqpEmzheWyydxl\nbQ7ZZn9XK1ByAOmwBC7b0aTrsoQ8xvnOYhtTuByYdz9lzkODM/1ZTzrOmNLPuO2e\ndCm1L2O9Gyg+QBMWtP7PE86YJiUd2pcyGMVViIJnesVvf7nwXbbKves=",
    "merchantKeyId": "8321",
    "environment": "sandbox",
    "service": "hyperpay"
  };

  @override
  Widget build(BuildContext context) {
    initiateHyperSDK();

    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: customAppBar(text: "Home Screen"),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            color: const Color(0xFFF8F5F5),
            height: screenHeight / 12,
            child: Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                child: const Text(
                  "Juspay Payments SDK should be initiated on this screen",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                )),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20, top: 15),
            child: const Text(
              "Products",
              style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFfFB8D33),
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: screenHeight / 1.75,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                singleProduct(screenHeight / 1.75, "one", countProductOne),
                singleProduct(screenHeight / 1.75, "two", countProductTwo)
              ],
            ),
          ),
          BottomButton(
              height: screenHeight / 10,
              text: "Go to Cart",
              onpressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CheckoutScreen(
                          productOneCount: countProductOne,
                          productTwoCount: countProductTwo,
                          hyperSDK: widget.hyperSDK,
                          merchantDetails: merchantDetails,
                          customerDetails: customerDetails))))
        ],
      ),
    );
  }

  void initiateHyperSDK() async {
    // Check whether hyperSDK is already initialised
    if (!await widget.hyperSDK.isInitialised()) {
      // Getting initiate payload
      // block:start:get-initiate-payload
      var initiatePayload = {
        "requestId": const Uuid().v4(),
        "service": merchantDetails["service"],
        "payload": {
          "action": "initiate",
          "merchantId": merchantDetails["merchantId"],
          "clientId": merchantDetails["clientId"],
          "environment": merchantDetails["environment"]
        }
      };
      // block:end:get-initiate-payload

      // Calling initiate on hyperSDK instance to boot up payment engine.
      // block:start:initiate-sdk
      await widget.hyperSDK.initiate(initiatePayload, initiateCallbackHandler);
      // block:end:initiate-sdk
    }
  }

  // Define handler for inititate callback
  // block:start:initiate-callback-handler

  void initiateCallbackHandler(MethodCall methodCall) {
    if (methodCall.method == "initiate_result") {
      print("Debug initiate_result " + methodCall.arguments);
    } else if (methodCall.method == "process_result") {
      print("Debug process_result " + methodCall.arguments);
    }
  }

  // block:end:initiate-callback-handler

  Widget singleProduct(double height, String text, int itemCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      height: height / 2,
      child: Column(
        children: [
          Container(
            height: height / 4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFf5f5f5)),
          ),
          Container(
            height: height / 4,
            color: const Color(0xFFFFFFFF),
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Product $text",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: RichText(
                          text: TextSpan(children: [
                        const TextSpan(
                            text: "Price: Rs. 1/item",
                            style:
                                TextStyle(fontSize: 12, color: Colors.black)),
                        const TextSpan(text: "\n"),
                        const TextSpan(
                            text: "Awesome product description for",
                            style:
                                TextStyle(fontSize: 12, color: Colors.black)),
                        TextSpan(
                            text: "\nproduct $text",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black)),
                      ])),
                    ),
                    Expanded(
                        flex: 2,
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            height: height / 12,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border:
                                    Border.all(color: Colors.black, width: 2)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () => decreaseItemQuantity(text),
                                  child: const Icon(
                                    Icons.horizontal_rule_rounded,
                                    color: Color(0xFF115390),
                                  ),
                                ),
                                Text(
                                  itemCount.toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFB8D33)),
                                ),
                                GestureDetector(
                                    onTap: () => increaseItemQuantity(text),
                                    child: const Icon(Icons.add,
                                        color: Color(0xFF115390)))
                              ],
                            ),
                          ),
                        )),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void increaseItemQuantity(String text) {
    if (text == "one") {
      setState(() {
        countProductOne += 1;
      });
    } else {
      setState(() {
        countProductTwo += 1;
      });
    }
  }

  void decreaseItemQuantity(String text) {
    if (text == "one") {
      setState(() {
        if (countProductOne != 0) {
          countProductOne -= 1;
        }
      });
    } else {
      setState(() {
        if (countProductTwo != 0) {
          countProductTwo -= 1;
        }
      });
    }
  }
}
