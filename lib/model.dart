import 'package:lab04_magleo_2023210907/common_types.dart';
import 'package:lab04_magleo_2023210907/other_common_types.dart';
import 'package:lab04_magleo_2023210907/turnorder_class.dart';
import 'package:lab04_magleo_2023210907/matching_class.dart';
import 'dart:math';

class ModifiedMemoryGameModel {
  Player _player = Player.p1;
  late TurnOrder _turnOrder;
  late MatchingMechanism _matchingMechanism;
  late int _groupSize;
  Player? _winner;
  bool _isTurnOver = false;

  final List<List<List<int>>> _gameState = [];
  final List<List<int>> _turnGuesses = [];
  final List<int> _score = [0, 0];

  bool _isGameDone = false;
  int? _lastPick;

  ModifiedMemoryGameModel(
    int r,
    int c,
    int k,
    int s,
    TurnOrder turnOrder,
    MatchingMechanism matchingMechanism,
  ) {
    // put the mechanisms in place
    _turnOrder = turnOrder;
    _matchingMechanism = matchingMechanism;
    _groupSize = k;

    // if the number of cells cannot be dvided into groups of k
    // we throw an error
    if ((r * c) % k != 0) throw "Invalid grid";

    // otherwise, we go ahead and create the grid
    // each cell has two numbers, one representing its group, one representing
    // whether it is flipped.

    int group = 0;
    int groupCtr = 0;
    List<List<int>> flatCells = [];
    for (int i = 0; i < r; i++) {
      for (int j = 0; j < c; j++) {
        if (groupCtr % k == 0) {
          groupCtr = 0;
          group += 1;
        }

        List<int> cell = [0, group];
        flatCells.add(cell);

        groupCtr += 1;
      }
    }

    Random rand = Random(s);
    for (int i = flatCells.length - 1; i > 0; i--) {
      int j = rand.nextInt(i + 1);
      List<int> temp = flatCells[i];
      flatCells[i] = flatCells[j];
      flatCells[j] = temp;
    }

    for (int i = 0; i < r; i++) {
      _gameState.add(flatCells.sublist(i * c, (i + 1) * c));
    }
  }

  int getScore(Player player) {
    if (player == Player.p1) {
      return _score[0];
    } else {
      return _score[1];
    }
  }

  bool selectToken(int row, int col) {
    // NOTE: check this
    if (_isGameDone == true) return false;
    // check boundaries
    if (row < 0 || row >= _gameState.length) return false;
    if (col < 0 || col >= _gameState[0].length) return false;
    if (_gameState[row][col][0] == 1) return false;

    // we can run the matching mechanism now, it will return the result
    // and stay that way in subsequent calls, so we don't need to check
    // if the player has already selected K tokens

    if (_isTurnOver) return false;

    _gameState[row][col][0] = 1;
    _turnGuesses.add([row, col]);

    if (_matchingMechanism.nextStage(_lastPick, _gameState[row][col][1])) {
      _isTurnOver = true;
    }

    // make sure to set lastPick
    _lastPick = _gameState[row][col][1];

    return true;
  }

  bool confirmTurnEnd() {
    // NOTE: check this
    if (_isGameDone) return false;
    if (_matchingMechanism.stage == MatchingStage.matching) return false;

    _isTurnOver = false;

    if (_matchingMechanism.stage == MatchingStage.success) {
      _score[_playerIndex] += 1;
    } else if (_matchingMechanism.stage == MatchingStage.failed) {
      // reset all the cards flipped
      for (List<int> guess in _turnGuesses) {
        _gameState[guess[0]][guess[1]][0] = 0;
      }
    }

    // next, we run a function to check if the game is done (if the sum of the scores is equal to all the possible groups)
    if (_score[0] + _score[1] == (rowCount * colCount) / _groupSize) {
      _isGameDone = true;
      if (_score[0] > _score[1]) {
        _winner = Player.p1;
      } else if (_score[0] < _score[1]) {
        _winner = Player.p2;
      }
    } else {
      // and also reset the guesses made
      _turnGuesses.clear();
      _player = _turnOrder.nextPlayer(_matchingMechanism.stage, _player);

      // lastly, we reset the state of the matching
      _matchingMechanism.resetMatching();
    }

    return true;
  }

  int? getTokenNumber(int row, int col) {
    if (row < 0 || row >= _gameState.length) return null;
    if (col < 0 || col >= _gameState[0].length) return null;
    List<int> cell = _gameState[row][col];

    if (cell[0] == 0) return null;

    return cell[1];
  }

  Player get currentPlayer => _player;
  bool get isGameDone => _isGameDone;
  int get _playerIndex => _player == Player.p1 ? 0 : 1;
  int get rowCount => _gameState.length;
  int get colCount => _gameState[0].length;
  Player? get winner => _winner;
  bool get isTurnOver => _isTurnOver;
}
