import 'package:flutter/material.dart';

class DishBook extends StatefulWidget {

  final imageURL, name, steps, ingredients;
  DishBook({this.imageURL, this.name, this.steps, this.ingredients});

  @override
  _DishBookState createState() => _DishBookState();
}

class _DishBookState extends State<DishBook> {

  List<Widget> listOfIngredients = List();
  List<Widget> listOfSteps = List();

  @override
  void initState() {
    for (var i in widget.ingredients) {
      var tempTile = ListTile(
        title: Text(
          i["name"].toString()
        ),
        subtitle: Row(
          children: <Widget>[
            Text(
              i["amount"] != null ? "Amount: " + i["amount"] : ""
            ),
            SizedBox(
              width: 2,
            ),
            Text(
              i["preparation"] != null ? "Preparation: " + i["preparation"] : ""
            )
          ],
        ),
      );
      listOfIngredients.add(tempTile);
    }
    for (var i in widget.steps){
      var tempTile = ListTile(
        title: Text(
          i
        )
      );
      listOfSteps.add(tempTile);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Recipe"
        ),
        backgroundColor: Colors.red,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.chevron_left,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 72,
              ),
              CircleAvatar(
                radius: 64,
                backgroundImage: NetworkImage(
                  widget.imageURL
                ),
              ),
              SizedBox(
                height: 32,
              ),
              Text(
                widget.name,
                style: TextStyle(
                  fontSize: 32
                ),
              ),
              SizedBox(
                height: 32,
              ),
              for (var i in listOfIngredients) i,
              SizedBox(
                height: 18,
              ),
              Text(
                "Steps",
                style: TextStyle(
                  fontSize: 26
                ),
              ),
              SizedBox(
                height: 18,
              ),
              for (var j in listOfSteps) j,
              SizedBox(
                height: 54,
              )
            ],
          ),
        ),
      ),
    );
  }
}