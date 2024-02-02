import 'package:flutter/material.dart';

class ResultsProvider extends ChangeNotifier {
  bool _hasResults = false;

  bool get hasResults => _hasResults;

  set hasResults(bool value) {
    _hasResults = value;
    notifyListeners();
  }
}
