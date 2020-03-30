import 'package:chef/pages/add_ingredient.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Storage extends StatefulWidget {

  final uid;
  Storage({this.uid});

  @override
  _StorageState createState() => _StorageState();
}

class _StorageState extends State<Storage> {

  bool status = false;

  initStorage () async{
    var ref = Firestore.instance;
    var tempRecs = await ref.collection("storage").where("uid", isEqualTo: widget.uid).getDocuments();
    var recordLength = tempRecs.documents.length;
    if(recordLength== 0){
      Map<String, dynamic> storageUnit = {
        "uid": widget.uid,
        "ingredients": []
      };
      Firestore.instance.collection("storage").add(storageUnit);
      setState(() {
        status = false;
      });
    }
    else{
      setState(() {
        status = true;
      });
    }
  }

  Future getStorage() async{
    var tempStorage = await Firestore.instance.collection("storage").where("uid", isEqualTo: widget.uid).getDocuments();
    var records = tempStorage.documents;
    return records[0];
  }

  @override
  void initState() {
    initStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ingredients",
          style: TextStyle(
            fontFamily: "Product Sans"
          ),
        ),
        centerTitle: true,
      ),
      body: status ? FutureBuilder(
        future: getStorage(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            var ingredients = snapshot.data;
            if(ingredients["ingredients"].length != 0){
              return ListView.builder(
                itemCount: ingredients["ingredients"].length,
                itemBuilder: (BuildContext context, int index){
                  return ListTile(
                    title: Text(
                      ingredients["ingredients"][index]["name"].toString(),
                      style: TextStyle(
                        fontFamily: "Product Sans",
                        fontSize: 18
                      )
                    ),
                    subtitle: Text(
                      ingredients["ingredients"][index]["quantity"].toString(),
                      style: TextStyle(
                        fontFamily: "Product Sans",
                        fontSize: 15
                      )
                    ),
                  );
                }
              );
            }
            else{
              return Center(
                child: Text(
                  "Add ingredients to your fridge!",
                  style: TextStyle(
                    fontFamily: "Product Sans",
                    fontSize: 20
                  ),
                ),
              );
            }
          }
          else{
            return Center(
              child: CircularProgressIndicator()
            );
          }
        }
      ) : Center(
        child: CircularProgressIndicator()
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => AddIngredient(uid: widget.uid)
            )
          );
        },
        child: Icon(Icons.add_circle),
      ),
    );
  }
}