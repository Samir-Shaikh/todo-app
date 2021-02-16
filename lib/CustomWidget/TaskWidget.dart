import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/Model/TaskModel.dart';

class TaskWidget extends StatelessWidget {
  final TaskModel model;
  final GestureTapCallback onComplete;
  final GestureTapCallback onDelete;
  final Function(String) onEditDone;

  TaskWidget(this.model, this.onDelete, this.onEditDone, this.onComplete);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 5),
        Row(children: <Widget>[
          Expanded(
              child: Padding(
            child: model.completedAt == null
                ? TextField(
                    textInputAction: TextInputAction.done,
                    maxLines: null,
                    onSubmitted: (newValue) {
                      onEditDone(newValue);
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    controller:
                        TextEditingController(text: model.description ?? ''))
                : Text(model.description ?? '',
                    style: TextStyle(decoration: TextDecoration.lineThrough)),
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          )),
          model.completedAt == null
              ? IconButton(
                  icon: Icon(Icons.done, color: Colors.blue),
                  iconSize: 30,
                  onPressed: this.onComplete,
                )
              : Container(),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.blue),
            iconSize: 30,
            onPressed: this.onDelete,
          )
        ]),
        SizedBox(height: 5),
        Container(height: 1, color: Colors.grey)
      ],
    ));
  }
}
