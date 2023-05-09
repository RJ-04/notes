import 'package:flutter/material.dart';
import 'package:project/utilities/dialogs/generic_dialog.dart';

Future<bool> showsignOutDialogue(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Signing Out",
    content: "Are you sure you wish to sign out?",
    optionBuilder: () => {
      "Sign Out": true,
      "Cancel": false,
    },
  ).then((value) => value ?? false);
}
