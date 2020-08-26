import 'dart:collection';

import 'package:flutter/material.dart';

import 'matchCard.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Card Stack'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ListQueue<Positioned> cardsQView;
  ListQueue<MatchCard> cardsQModel;

  void _removeCard() {
    setState(() {
      List<double> margins = cardsQModel.map((card) => card.margin).toList();
      MatchCard removed = cardsQModel.removeLast();
      cardsQModel.addFirst(removed);
      for (var i = 0; i < margins.length; i++) {
        cardsQModel.elementAt(i).margin = margins[i];
      }
      cardsQView = _getMatchCard();
    });
  }

  @override
  void initState() {
    super.initState();
    cardsQModel = new ListQueue<MatchCard>(3);
    cardsQModel.add(MatchCard(255, 0, 0, 10, 10));
    cardsQModel.add(MatchCard(0, 255, 0, 20, 20));
    cardsQModel.add(MatchCard(0, 0, 255, 30, 30));
    cardsQView = _getMatchCard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: cardsQView.toList(),
        ),
      ),
    );
  }

  ListQueue<Positioned> _getMatchCard() {
    ListQueue<Positioned> cardList = new ListQueue();

    cardsQModel.forEach((card) {
      cardList.add(
        Positioned(
          bottom: card.margin,
          right: card.margin,
          child: Draggable(
            onDragEnd: (drag) {
              _removeCard();
            },
            childWhenDragging: Container(),
            feedback: Card(
              elevation: 12,
              color: Color.fromARGB(
                  255, card.redColor, card.greenColor, card.blueColor),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                width: 240,
                height: 300,
              ),
            ),
            child: Card(
              elevation: 12,
              color: Color.fromARGB(
                  255, card.redColor, card.greenColor, card.blueColor),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                width: 240,
                height: 300,
              ),
            ),
          ),
        ),
      );
    });
    return cardList;
  }
}
