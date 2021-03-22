import 'dart:async';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/service.dart';

class SettingsWidget extends StatefulWidget {
  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  var _ticker = '', _token = '';
  bool working = false;
  var startText = 'Start the engines!';
  var stopText = 'Stop the Engines!';
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.fromLTRB(15, kToolbarHeight + 15, 15, 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Flexible(
                  child: TextField(
                    decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Enter your FinnHub API Key"),
                    onChanged: (v) => _token = v,
                  ),
                ),
                VerticalDivider(),
                ElevatedButton(
                    onPressed: () async {
                      var result = await Provider.of<Service>(context, listen: false).setFHToken(_token);
                      SnackBar success = SnackBar(content: Text("Success! Your token is valid."));
                      SnackBar fail = SnackBar(content: Text("Your token is not recognized!"));
                      if (result)
                        ScaffoldMessenger.of(context).showSnackBar(success);
                      else
                        ScaffoldMessenger.of(context).showSnackBar(fail);
                    },
                    child: Text("Confirm the key"))
              ],
            ),
            Divider(),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Enter stock ticker (eg GME for GameStop, won't stop)"),
                    onChanged: (v) => _ticker = v,
                  ),
                ),
                VerticalDivider(),
                ElevatedButton(
                    onPressed: () async {
                      if (Provider.of<Service>(context, listen: false).tokenConfirmed) {
                        var result = await Provider.of<Service>(context, listen: false).setTicker(_ticker);
                        SnackBar success = SnackBar(content: Text("Success! Your ticker is active."));
                        SnackBar fail = SnackBar(content: Text("Your ticker is not recognized!"));
                        if (result)
                          ScaffoldMessenger.of(context).showSnackBar(success);
                        else
                          ScaffoldMessenger.of(context).showSnackBar(fail);
                      } else {
                        SnackBar tickerNotConfirmed = SnackBar(content: Text("Please confirm your API token first"));
                        ScaffoldMessenger.of(context).showSnackBar(tickerNotConfirmed);
                      }
                    },
                    child: Text("Confirm the ticker"))
              ],
            ),
            Divider(),
            Container(
              child: Flexible(
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Update Interval",
                      hintText: "Update Interval",
                      hintStyle: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                      labelStyle: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      )),
                  onChanged: (v) {
                    Provider.of<Service>(context, listen: false).interval = int.parse(v);
                  },
                  controller: intervalC,
                ),
              ),
            ),
            Divider(),
            Container(
              child: Flexible(
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Price Difference",
                      hintText: "Price Difference",
                      hintStyle: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                      labelStyle: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      )),
                  onChanged: (v) {
                    Provider.of<Service>(context, listen: false).priceDifference = int.parse(v);
                  },
                  controller: priceDifferenceC,
                ),
              ),
            ),
            Divider(),
            Container(
              child: Flexible(
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Going up text (put an @ sign for the location of price)",
                      hintText: "Going up text (put an @ sign for the location of price)",
                      labelStyle: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      )),
                  onChanged: (v) {
                    Provider.of<Service>(context, listen: false).upText = v;
                  },
                  controller: upTextC,
                ),
              ),
            ),
            Divider(),
            Container(
              child: Flexible(
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Going down text (put an @ sign for the location of price)",
                      hintText: "Going down text (put an @ sign for the location of price)",
                      labelStyle: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      )),
                  onChanged: (v) {
                    Provider.of<Service>(context, listen: false).downText = v;
                  },
                  controller: downTextC,
                ),
              ),
            ),
            Divider(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: working ? Colors.red : Colors.green, // background
              ),
              onPressed: () async {
                setState(() {
                  if (Provider.of<Service>(context, listen: false).tokenConfirmed && Provider.of<Service>(context, listen: false).tickerConfirmed) {
                    working = !working;
                    if (working)
                      futureFetch = Timer.periodic(Duration(seconds: Provider.of<Service>(context, listen: false).interval), (Timer t) async {
                        await Provider.of<Service>(context, listen: false).engineRev();
                      });
                    else {
                      futureFetch.cancel();
                      Provider.of<Service>(context, listen: false).registeredPrice = 0;
                    }
                  }
                });
              },
              child: Text(working ? stopText : startText),
            )
          ],
        ),
      ),
    );
  }
}

var futureFetch;
TextEditingController intervalC = TextEditingController(text: "15");
TextEditingController priceDifferenceC = TextEditingController(text: "5");
TextEditingController upTextC = TextEditingController(text: "Your stock is up to @");
TextEditingController downTextC = TextEditingController(text: "Your stock is down to @");
