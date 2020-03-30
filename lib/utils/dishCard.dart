import 'package:flutter/material.dart';
import '../pages/dish.dart';

class DishCard extends StatelessWidget {

  final photoURL, name, steps, ingredients;
  DishCard({this.photoURL, this.name, this.steps, this.ingredients});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 32,
      child: GestureDetector(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => DishBook(
                imageURL: this.photoURL,
                name: this.name,
                steps: this.steps,
                ingredients: this.ingredients,
              )
            )
          );
        },
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Stack(
            children: <Widget>[
              Image.network(
                this.photoURL,
                fit: BoxFit.contain,
              ),
              Positioned(
                bottom: 20,
                left: 32,
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: Colors.red[200],
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12
                          ),
                          child: Text(
                            this.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: "Product Sans",
                              color: Colors.black
                            ),
                          ),
                        )
                      )
                    ),
                  ],
                )
              )
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              16
            )
          ),
          elevation: 5,
          margin: EdgeInsets.all(12),
        ),
      ),
    );
  }
}