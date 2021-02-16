import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/CustomWidget/TaskWidget.dart';
import 'package:todo_app/Helper/APIManager.dart';
import 'package:todo_app/Model/TaskModel.dart';
import 'package:todo_app/Provider/ProviderAppState.dart';
import 'package:todo_app/Utilities/Utilities.dart';

class ToDoListScreen extends StatefulWidget {
  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  TextEditingController _editingController;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: "");

    Future.delayed(const Duration(milliseconds: 100), () {
      getTaskList();
    });
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ProviderAppState>(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('ToDo App')),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            appState.isButtonClicked
                ? TextField(
                    decoration:
                        InputDecoration(labelText: 'Enter Task Description'),
                    controller: _editingController,
                    autofocus: true,
                    onSubmitted: (newValue) {
                      if (_editingController.text.trim().length > 0) {
                        appState.updateButtonAction(false);
                        //call create api
                        createTask();
                      } else {
                        // text is empty so just update UI no api call
                        appState.updateButtonAction(false);
                      }
                    })
                : Container(
                    alignment: Alignment.centerLeft,
                    child: FlatButton(
                        onPressed: () {
                          appState.updateButtonAction(true);
                        },
                        child: Text('+ Add to List...')),
                  ),
            Expanded(
              child: ListView.builder(
                itemCount: appState.getAllTasks.length,
                itemBuilder: (context, index) {
                  return TaskWidget(appState.getAllTasks[index], () {
                    //delete
                    showAlertDialogWithTwoAction(context, "Alert",
                        "Are you sure want to delete?", "No", "Yes", () {
                      deleteTask(appState.getAllTasks[index].id);
                    });
                  }, (newValue) {
                    //edit
                    editTask(appState.getAllTasks[index].id, newValue);
                  }, () {
                    //complete task
                    showAlertDialogWithTwoAction(
                        context,
                        "Alert",
                        "Are you sure want to complete this task?",
                        "No",
                        "Yes", () {
                      completeTask(appState.getAllTasks[index].id);
                    });
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  createTask() {
    APIManger.shared.makeRequest(
        context: context,
        endPoint: APIConstant.createTask,
        method: RequestType.POST,
        params: {
          "task": {'description': _editingController.text}
        },
        callback: (result) {
          if (result is SuccessState) {
            _editingController.clear();
            getTaskList();
          } else if (result is ErrorState) {
            showAlertDialog(context, result.msg);
          }
        });
  }

  getTaskList() {
    APIManger.shared.makeRequest(
        context: context,
        endPoint: APIConstant.getTasksList,
        method: RequestType.GET,
        callback: (result) {
          if (result is SuccessState) {
            List arrAllTask = result.value as List;
            List<TaskModel> arrTemp =
                arrAllTask.map((task) => TaskModel.fromJSON(task)).toList();

            var arrCompleted =
                arrTemp.where((i) => i.completedAt != null).toList();

            var arrUnCompleted =
                arrTemp.where((i) => i.completedAt == null).toList();

            //sorting uncompleted
            arrUnCompleted.sort(
                (task1, task2) => task2.createdAt.compareTo(task1.createdAt));

            //desc sorting completed desc
            arrCompleted.sort(
                (task1, task2) => task1.createdAt.compareTo(task2.createdAt));

            //append uncompleted first
            List<TaskModel> arrFinal = [];
            arrFinal.addAll(arrUnCompleted);
            arrFinal.addAll(arrCompleted);

            //update state
            Provider.of<ProviderAppState>(context).setTaskData(arrFinal);
          } else if (result is ErrorState) {
            showAlertDialog(context, result.msg);
          }
        });
  }

  deleteTask(int taskId) {
    APIManger.shared.makeRequest(
        context: context,
        endPoint: APIConstant.deleteTask + '/$taskId',
        method: RequestType.DELETE,
        callback: (result) {
          if (result is SuccessState) {
            getTaskList();
          } else if (result is ErrorState) {
            showAlertDialog(context, result.msg);
          }
        });
  }

  completeTask(int taskId) {
    String url = APIConstant.deleteTask + '/$taskId' + '/completed';
    APIManger.shared.makeRequest(
        context: context,
        endPoint: url,
        method: RequestType.PUT,
        callback: (result) {
          if (result is SuccessState) {
            getTaskList();
          } else if (result is ErrorState) {
            showAlertDialog(context, result.msg);
          }
        });
  }

  editTask(int taskId, String text) {
    APIManger.shared.makeRequest(
        context: context,
        endPoint: APIConstant.editTask + '/$taskId',
        params: {
          "task": {'description': text}
        },
        method: RequestType.PUT,
        callback: (result) {
          if (result is SuccessState) {
            getTaskList();
          } else if (result is ErrorState) {
            showAlertDialog(context, result.msg);
          }
        });
  }
}
