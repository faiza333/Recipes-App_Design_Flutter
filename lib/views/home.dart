import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipesapp/models/recipes_model.dart';
import 'package:recipesapp/views/recipe_viw.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<RecipeModel> recipes = new List<RecipeModel>();
  TextEditingController textEditingController = new TextEditingController();
  getrecipes(String query) async {
    String url =
        "https://api.edamam.com/search?q=$query&app_id=8914649b&app_key=2fc3d296817ab05065b5b4737d607b17";
    var response = await http.get(url);
    Map<String, dynamic> jsondata = jsonDecode(response.body);
    jsondata["hits"].forEach(
      (element) {
        //print(element.toString());
        // ignore: unused_local_variable
        RecipeModel recipeModel = new RecipeModel();
        recipeModel=RecipeModel.formMap(element['recipe']);
        recipes.add(recipeModel);
      },
    );
    setState(() {
      
    });
    print("${recipes.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [const Color(0xff213A50), const Color(0xff071930)])),
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, //هيخلي النص وكل حاجة تبدا من الاول
          children: <Widget>[
            Row(
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
            SizedBox(height: 30),
            Text(
              "what will you cook today",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "just intere the ingridient that you have and we will show you best recipe for you",
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                          hintText: "Intere ingrident",
                          hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.5))),
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors
                              .white), //FOR THE WORDS THAT WE WILL WRITE IT
                    ),
                  ),
                  SizedBox(width: 16),
                  InkWell(
                    onTap: () {
                      if (textEditingController.text.isNotEmpty) {
                        getrecipes(textEditingController.text);
                        print("just do it");
                      } else {
                        print("just dont do it");
                      }
                    },
                    child: Container(
                        child: Icon(
                          Icons.search,
                           color: Colors.white)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30,),
            Expanded(
                          child: Container(
                child:GridView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: ClampingScrollPhysics(),

                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 10.0,
                    
                    ),
                    children: 
                      List.generate(recipes.length, (index) {
                        return GridTile(child: RecipieTile(
                          title: recipes[index].label,
                          desc: recipes[index].source,
                          imgUrl: recipes[index].image,
                          url: recipes[index].url,
                        ),);

                      })
                    
                  )
              ),
            )
          ],
        ),
      ),
    ]));
  }
}

class RecipieTile extends StatefulWidget {
  final String title, desc, imgUrl, url;

  RecipieTile({this.title, this.desc, this.imgUrl, this.url});

  @override
  _RecipieTileState createState() => _RecipieTileState();
}

class _RecipieTileState extends State<RecipieTile> {
  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (kIsWeb) {
              _launchURL(widget.url);
            } else {
              print(widget.url + " this is what we are going to see");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeView(
                            postUrl: widget.url,
                          )));
            }
          },
          child: Container(
            margin: EdgeInsets.all(8),
            child: Stack(
              children: <Widget>[
                Image.network(
                  widget.imgUrl,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 200,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                             // fontFamily: 'Overpass'
                             ),
                        ),
                        Text(
                          widget.desc,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                             // fontFamily: 'OverpassRegular'
                              ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

