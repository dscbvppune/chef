import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddIngredient extends StatefulWidget {

  final uid;
  AddIngredient({this.uid});

  @override
  _AddIngredientState createState() => _AddIngredientState();
}

class _AddIngredientState extends State<AddIngredient> {

  final formKey = GlobalKey<FormState>();
  FocusNode ingredientNameFocusNode = FocusNode();
  FocusNode quantityFocusNode = FocusNode();
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  var ingredientName, quantity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add an ingredient"
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 64,
              ),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: TextFormField(
                        autocorrect: false,
                        autofocus: true,
                        focusNode: ingredientNameFocusNode,
                        decoration: InputDecoration(
                          hintText: "For eg (Onions)",
                          labelText: "Ingredient Name"
                        ),
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        onChanged: (nameValue){
                          ingredientName = nameValue;
                        },
                        onFieldSubmitted: (ingredientname){
                          ingredientNameFocusNode.unfocus();
                          FocusScope.of(context).requestFocus(quantityFocusNode);
                        },
                        validator: (value){
                          if(value.isEmpty){
                            return 'This field is mandatory';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 48,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: TextFormField(
                        focusNode: quantityFocusNode,
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: "For eg 30g",
                          labelText: "Amount (Use standard units like g, ml)"
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        onChanged: (amountVal){
                          quantity = amountVal;
                        },
                        onFieldSubmitted: (usernameValue){
                          quantityFocusNode.unfocus();
                        },
                        validator: (value){
                          if(value.isEmpty){
                            return 'This field is mandatory';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 64,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          var storageQuery = await Firestore.instance.collection("storage").where("uid", isEqualTo: widget.uid).getDocuments();
          var results = storageQuery.documents;
          if(results.length != 0){
            var docID = results[0].documentID;
            List listOfItems;
            List updatedListOfItems = List();
            listOfItems = results[0]["ingredients"];
            Map<String, dynamic> tempItem;
            int flag = 0;
            if(listOfItems.length != 0){
              for (var i in listOfItems) {
                if(i["name"] == ingredientName){
                  quantity = i["quantity"] + int.parse(quantity);
                  tempItem = {
                    "name": ingredientName,
                    "quantity": quantity
                  };
                  flag = 1;
                }
                else{
                  tempItem = i;
                }
                updatedListOfItems.add(tempItem);
              }
              if(flag == 0){
                tempItem = {
                  "name": ingredientName,
                  "quantity": int.parse(quantity)
                };
                updatedListOfItems.add(tempItem);
              }
            }
            else{
              tempItem = {
                "name": ingredientName,
                "quantity": int.parse(quantity)
              };
              updatedListOfItems.add(tempItem);
            }
            Firestore.instance.collection("storage").document(docID).delete();
            Map<String, dynamic> tempData = {
              "uid": widget.uid,
              "ingredients": updatedListOfItems
            };
            Firestore.instance.collection("storage").add(tempData);
          }
          else{
            var snackBar = SnackBar(
              content: Text(
                "Error 404"
              )
            );
            Scaffold.of(context).showSnackBar(snackBar);
          }
          Navigator.pop(context);
        },
        child: Icon(Icons.done),
      ),
    );
  }
}