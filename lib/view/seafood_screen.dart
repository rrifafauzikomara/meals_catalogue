import 'package:flutter/material.dart';
import 'package:meals_catalogue/animation/hero_animation.dart';
import 'package:meals_catalogue/api/meals_api.dart';
import 'package:meals_catalogue/models/meals.dart';
import 'package:toast/toast.dart';

import '../main.dart';
import 'detail_screen.dart';

class SeafoodScreen extends StatefulWidget {
  @override
  _SeafoodScreenState createState() => _SeafoodScreenState();
}

class _SeafoodScreenState extends State<SeafoodScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getListSeafood());
  }

  getListSeafood() {
    return Container(
      color: Color.fromRGBO(58, 66, 86, 1.0),
      child: Center(
        child: FutureBuilder(
          future: MealsApi().getMealsList('Seafood'),
          builder: (context, AsyncSnapshot<MealsResult> snapshot) {
            if (snapshot.hasData) {
              return _showListSeafood(snapshot);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
          },
        ),
      ),
    );
  }

  Widget _showListSeafood(AsyncSnapshot<MealsResult> snapshot) =>
      GridView.builder(
        itemCount: snapshot == null ? 0 : snapshot.data.meals.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              margin: EdgeInsets.all(10),
              child: GridTile(
                child: HeroAnimation(
                  tag: snapshot.data.meals[index].strMeal,
                  onTap: () {
                    showToast(context, snapshot.data.meals[index].strMeal,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 777),
                          pageBuilder: (BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secondaryAnimation) =>
                              DetailScreen(
                                  idMeal: snapshot.data.meals[index].idMeal,
                                  strMeal: snapshot.data.meals[index].strMeal,
                                  strMealThumb:
                                      snapshot.data.meals[index].strMealThumb),
                        ));
                  },
                  photo: snapshot.data.meals[index].strMealThumb,
                ),
                footer: Container(
                  color: Colors.white70,
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    snapshot.data.meals[index].strMeal,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.deepOrange),
                  ),
                ),
              ),
            ),
          );
        },
      );
}
