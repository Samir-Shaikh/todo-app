import 'package:flutter/cupertino.dart';
import 'package:todo_app/Model/TaskModel.dart';

class ProviderAppState with ChangeNotifier {
  ProviderAppState();

  //private properties
  bool _isButtonClicked = false;
  List<TaskModel> _arrTasks = [];

  //set value
  void updateButtonAction(bool isClicked) {
    _isButtonClicked = isClicked;
    notifyListeners();
  }

  //return button state with updated value
  bool get isButtonClicked => _isButtonClicked;

  void setTaskData(List<TaskModel> arrTask) {
    _arrTasks = arrTask;
    notifyListeners();
  }

  List<TaskModel> get getAllTasks => _arrTasks;
}