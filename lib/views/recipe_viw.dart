import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recipesapp/models/recipes_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeView extends StatefulWidget {
  final String postUrl;
  RecipeView({this.postUrl});
  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  String finalurl;
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
void initState(){
  if(widget.postUrl.contains("http://")){
    finalurl = widget.postUrl.replaceAll("http://", "https://");
  }else{
    finalurl = widget.postUrl;
  }
  super.initState();
}
  Widget build(BuildContext context) {
    return Scaffold(body:
      Container(
      child: Column(children: <Widget>[
         Container(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            decoration: BoxDecoration(
            gradient: LinearGradient(
            colors: [const Color(0xff213A50), const Color(0xff071930)])),
           width: MediaQuery.of(context).size.width,
           child: Container(
             width: MediaQuery.of(context).size.width,
             child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, //هيخلي النص في النص
                  children: <Widget>[
                    Text(
                      "AppGuy",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    Text(
                      "Recips",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue),
                    )
                  ],
                ),
           ),
         ),
     Container(
       width: MediaQuery.of(context).size.width,
       height: MediaQuery.of(context).size.height-100,
       child: WebView(
         initialUrl:finalurl,
         javascriptMode: JavascriptMode.unrestricted,
         onWebViewCreated: (WebViewController webViewController){
           setState(() {
             _controller.complete(webViewController);
           });
         },
       ),
     )
      ],
      ),
      
    ),
    );
    
 } }