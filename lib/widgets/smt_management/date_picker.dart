import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

showDatePickerDialog(
    {required BuildContext context, required Function callback}) async {
  showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1970, 01, 01),
    lastDate: DateTime(3000, 01, 01),
  ).then(
    (value) {
      if (value != null) {
        final result = DateFormat('dd-MM-yyyy').format(value);
        callback(result);
      }
    },
  );
}
