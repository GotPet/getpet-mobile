import 'package:flutter/widgets.dart';
import 'package:getpet/pets.dart';

class MatchEngine extends ChangeNotifier {
  final List<PetMatch> _matches;
  int _currentMatchIndex;
  int _nextMatchIndex;

  MatchEngine({
    List<PetMatch> matches,
  }) : _matches = matches {
    _currentMatchIndex = 0;
    _nextMatchIndex = 1;
  }

  PetMatch get currentMatch => _matches[_currentMatchIndex];

  PetMatch get nextMatch => _matches[_nextMatchIndex];

  void cycleMatch() {
    if (currentMatch.decision != Decision.undecided) {
      currentMatch.reset();

      _currentMatchIndex = _nextMatchIndex;
      _nextMatchIndex = _nextMatchIndex < _matches.length - 1 ? _nextMatchIndex + 1 : 0;
      print('Current match: $_currentMatchIndex, Next match: $_nextMatchIndex');

      notifyListeners();
    }
  }
}

