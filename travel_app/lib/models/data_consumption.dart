import 'dart:ffi';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';

class Travel {
  final String month;
  final double numbers;
  final charts.Color barColor;

  Travel(
      {@required this.month, @required this.numbers, @required this.barColor});
}