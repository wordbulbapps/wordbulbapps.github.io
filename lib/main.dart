import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stock_announcer/settings_widget.dart';

import 'services/service.dart';

void main() {
  runApp(ChangeNotifierProvider<Service>(create: (context) => Service(), child: MyApp()));
  querySelector(".lds-grid").remove();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stock Announcer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Consumer<Service>(
          builder: (context, service, child) => Text(
              service.tickerConfirmed
                  ? "\$${service.ticker.toUpperCase()} TO THE MOON 💎🤲 -- ${service.currentPrice}"
                  : "WHATEVER YOU\'RE INVESTING IN TO THE MOON!",
              style: GoogleFonts.playfairDisplay(color: Colors.black, fontSize: 25)),
        ),
        backgroundColor: Colors.grey.withOpacity(0.4),
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(Icons.menu_book_sharp, color: Colors.black),
              onPressed: () {
                showAboutDialog(
                    context: context,
                    applicationName: "Stock Tracker by Wordbulb",
                    applicationVersion: "0.0.1",
                    applicationLegalese: "HODL and ENJOY the TENDIES");
              })
        ],
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('assets/background.png'),
        //     alignment: Alignment.center,
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Container(color: Colors.grey.withOpacity(0.5), child: Center(child: SettingsWidget())),
      ),
    );
  }
}
