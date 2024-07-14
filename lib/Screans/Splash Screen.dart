import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internshala_search_page/Screans/Internship%20Page.dart';

class splash_screen extends StatefulWidget {
  const splash_screen({super.key});

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {

  double opacity = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(milliseconds: 500),(){
      setState(() {
        opacity = 1.0 ;
      });
    });
    Timer(
        Duration(milliseconds: 2500),()=>Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder:(BuildContext context) =>internship_page()))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:null,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: AnimatedOpacity(
                opacity:opacity,
                duration: Duration(milliseconds: 700),
                child: Image.asset('assets/images/logo.jpg',scale: 5,)),
          )
        ],
      ),
    );
  }
}
