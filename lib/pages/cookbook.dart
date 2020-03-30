import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dish.dart';
// import 'dart:convert';

class RecipeScreen extends StatefulWidget {

  final name, email, displayPicURL, uid;

  RecipeScreen({this.name, this.email, this.displayPicURL, this.uid});

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CookBook",
          style: TextStyle(
            fontFamily: "Product Sans"
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection("cookbook").snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            if(snapshot.data.documents.length != 0){
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index){
                  return InkWell(
                    onTap: () async{
                      var dishName = await snapshot.data.documents[index]["name"];
                      var dishImage = await snapshot.data.documents[index]["imageURL"];
                      var steps = await snapshot.data.documents[index]["steps"];
                      var ingredients = await snapshot.data.documents[index]["ingredient"];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => DishBook(
                            name: dishName,
                            imageURL: dishImage,
                            steps: steps,
                            ingredients: ingredients,
                          )
                        )
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          snapshot.data.documents[index]["imageURL"]
                        ),
                      ),
                      title: Text(
                        snapshot.data.documents[index]["name"].toString()
                      ),
                    ),
                  );
                }
              );
            }
            else{
              return Center(
                child: Text(
                  "No records found"
                ),
              );
            }
          }
          else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}