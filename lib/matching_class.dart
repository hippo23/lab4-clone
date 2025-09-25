import 'other_common_types.dart';

abstract class MatchingMechanism {
  int _turnCtr = 0;
  MatchingStage _stage = MatchingStage.matching;

  void resetMatching() {
    _turnCtr = 0;
    _stage = MatchingStage.matching;
  }

  bool nextStage(int? lastPick, int pick);

  MatchingStage get stage => _stage;
}

class RegularMatchingMechanism extends MatchingMechanism {
  @override
  bool nextStage(int? lastPick, int pick) {
    _turnCtr += 1;
    if (_turnCtr == 1) {
      _stage = MatchingStage.matching;
      return false;
    } else if (pick == lastPick) {
      _stage = MatchingStage.success;
      return true;
    } else {
      _stage = MatchingStage.failed;
      return true;
    }
  }
}

class ExtraOneMatchingMechanism extends MatchingMechanism {
  @override
  bool nextStage(int? lastPick, int pick) {
    _turnCtr += 1;
    if (_turnCtr < 3) {
      if (_turnCtr == 1 || lastPick == pick) {
        _stage = MatchingStage.matching;
      } else if (lastPick != pick) {
        _stage = MatchingStage.failed;
      }
      return false;
    } else {
      if (_stage == MatchingStage.matching) {
        if (lastPick == pick) {
          _stage = MatchingStage.success;
        } else {
          _stage = MatchingStage.failed;
        }
      }
      return true;
    }
  }
}

class ExtraTwoMatchingMechanism extends MatchingMechanism {
  @override
  bool nextStage(int? lastPick, int pick) {
    _turnCtr += 1;

    if (_turnCtr == 1) return false;

    if (_stage == MatchingStage.matching) {
      if (lastPick == pick && _turnCtr < 3) {
        return false;
      } else if (lastPick != pick && _turnCtr < 3) {
        _stage = MatchingStage.failed;
        return true;
      } else if (lastPick == pick && _turnCtr == 3) {
        _stage = MatchingStage.success;
        return true;
      } else {
        _stage = MatchingStage.failed;
        return true;
      }
    } else {
      return true;
    }
  }
}
