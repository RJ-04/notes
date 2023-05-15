import 'package:flutter/material.dart';
import 'package:project/utilities/dialogs/generic_dialog.dart';

Future<bool> shouldDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Delete",
    content: "Are you sure you wish to delete this note?",
    optionBuilder: () => {
      "Cancel\n\n": false,
      "delete": true,
    },
  ).then((value) => value ?? false);
}
