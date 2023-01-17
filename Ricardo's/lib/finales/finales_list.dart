import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';

import 'arc_text.dart';
import 'finales_db_worker.dart';
import 'finales_model.dart';

class FinalesList extends StatefulWidget {
  @override
  _FinalesList createState() => _FinalesList();
}

class _FinalesList extends State<FinalesList> {
  _deleteFinale(BuildContext context, FinalesModel model, Finale finale) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext alertContext) {
          return AlertDialog(
            title: const Text('Delete Finale'),
            content: Text('Are you sure you want to delete ${finale.title}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(alertContext).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () async {
                  await FinalesDBWorker.db.delete(finale.id);
                  Navigator.of(alertContext).pop();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                      content: Text('Finale deleted'),
                    ),
                  );
                  model.loadData(FinalesDBWorker.db);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<FinalesModel>(
        builder: (BuildContext context, Widget child, FinalesModel model) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            model.entityBeingEdited = Finale();
            model.setStackIndex(1);
          },
        ),
        body: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: model.entityList.length,
            itemBuilder: (BuildContext context, int index) {
              Finale finale = model.entityList[index];
              return Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Slidable(
                  actionPane: const SlidableDrawerActionPane(),
                  actionExtentRatio: .25,
                  secondaryActions: [
                    IconSlideAction(
                      caption: "Delete",
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () => _deleteFinale(context, model, finale),
                    ),
                  ],
                  child: ArcText(
                    radius: 100,
                    text: '',
                    textStyle: TextStyle(fontSize: 18, color: Colors.black),
                    startAngle: -pi / 2,
                  ),
                ),
              );
            }),
      );
    });
  }
}
