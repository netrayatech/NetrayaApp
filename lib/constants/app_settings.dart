import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppSettings {
  static const appLinearGradient = LinearGradient(
    colors: [
      Color.fromRGBO(255, 61, 75, 1),
      Color.fromRGBO(141, 22, 32, 1),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const appMainPadding = 16.0;
  static DateFormat appDateFormatWithDayName = DateFormat('EEEE, dd MMMM yyyy', 'id');
  static DateFormat appDateFormat = DateFormat('dd MMMM yyyy', 'id');
  static DateFormat appDateTimeFormat = DateFormat('dd MMMM yyyy (hh:mm WIB)', 'id');
  static DateFormat simpleDateFormat = DateFormat('dd-MM-yyyy', 'id');
  static DateFormat dateGetTime = DateFormat('hh:mm');
}

class AppCode {
  static const submitted = 0;
  static const approved = 1;
  static const rejected = 2;
}

class AppEndpoint {
  static const baseUrl = 'https://asia-southeast2-netrayasmt.cloudfunctions.net/app';
  static const picControllingInquiry = '$baseUrl/pic-controlling/inquiry';
  static const picControllingExecute = '$baseUrl/pic-controlling/execute';
}

class MapConfig {
  static const List<String> markerNames = ['START', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N'];
}

class ErrorMessage {
  static const general = 'Opps, something wrong';
}
