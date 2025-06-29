import 'package:finshyt/utility/dialogs/show_generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title: 'An Error Occured',
    content: text,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}