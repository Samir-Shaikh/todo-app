import 'package:flutter/material.dart';
import 'package:todo_app/CustomWidget/ProgressDialog.dart';

showProgressDialog(BuildContext context) => showDialog(context: context, builder: (BuildContext context) => ProgressDialog());


showAlertDialog(BuildContext context, String msg) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Alert"),
    content: Text(msg),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}


showAlertDialogWithTwoAction(BuildContext context,String title, String msg,
    String button1Text, String button2Text, VoidCallback yesButtonClick) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text(button1Text),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = FlatButton(
    child: Text(button2Text),
    onPressed: () {
      Navigator.of(context).pop();

      yesButtonClick();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(msg),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
