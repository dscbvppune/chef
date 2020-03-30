import 'package:chef/pages/storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cookbook.dart';
import 'accounts.dart';
import '../utils/dishCard.dart';

class HomeScreen extends StatefulWidget {

  final name, email, photoURL, uid;
  HomeScreen({this.name, this.email, this.photoURL, this.uid});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Widget> recommendedDishes = List();

  getSuggestions() async{
    var storageUnit = await Firestore.instance.collection("storage").where("uid", isEqualTo: widget.uid).getDocuments();
    List itemNames = List();
    var ingredients = storageUnit.documents[0]["ingredients"];
    for (var i in ingredients){
      itemNames.add(i["name"]);
    }
    var dishesQuery = await Firestore.instance.collection("cookbook").getDocuments();
    var dishes = dishesQuery.documents;
    List recipes = List();
    for (var i in dishes){
      var dishIngredient = i.data["ingredient"];
      for (var j in dishIngredient) {
        Map<String, dynamic> tempMap = {
          "name": j["name"],
          "id": i.documentID
        };
        recipes.add(tempMap);
      }
    }
    List suggestedDishes = List();
    for (var i in itemNames){
      for (var j in recipes){
        if(j["name"] == i){
          suggestedDishes.add(j["id"]);
        }
      }
    }
    List dishNamesAdded = List();
    for (var i in suggestedDishes){
      Firestore.instance.collection("cookbook").document(i).get().then((val){
        var dishName = val["name"];
        int flag = 0;
        for (var j in dishNamesAdded){
          if(j == dishName){
            flag = 1;
            break;
          }
        }
        if(flag == 0){
          dishNamesAdded.add(dishName);
          var tempCard = DishCard(
            name: dishName,
            steps: val["steps"],
            photoURL: val["imageURL"],
            ingredients: val["ingredient"],
          );
          recommendedDishes.add(tempCard);
        }
      });
    }
    setState(() {
      
    });
  }

  @override
  void initState() {
    getSuggestions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Suggested Recipés",
          style: TextStyle(
            fontFamily: "Product Sans"
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => AccountScreen(
                    name: widget.name,
                    email: widget.email,
                    photoUrl: widget.photoURL,
                  )
                )
              );
            },
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.person
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 24,
              ),
              for (var item in recommendedDishes) item,
              SizedBox(
                height: 24,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "CookBook",
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => RecipeScreen(
                    name: widget.name,
                    email: widget.email,
                    displayPicURL: widget.photoURL,
                  )
                )
              );
            },
            child: Icon(Icons.library_books),
          ),
          SizedBox(
            height: 32,
          ),
          FloatingActionButton(
            heroTag: "Add ingredient",
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Storage(
                    uid: widget.uid,
                  )
                )
              );
            },
            child: Icon(Icons.add_circle),
          )
        ],
      ),
    );
  }
}