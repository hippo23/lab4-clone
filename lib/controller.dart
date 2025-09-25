import 'package:lab04_magleo_2023210907/view.dart';
import 'package:lab04_magleo_2023210907/model.dart';
import 'package:lab04_magleo_2023210907/common_types.dart';

abstract class ViewObserver {
  void onTap(int x, int y);
  void nextTurn();
  int? getTokenNumber(int x, int y);
}

class ModifiedMemoryGameController implements ViewObserver {
  late ModifiedMemoryGameModel _model;
  late ModifiedMemoryGameView _view;

  ModifiedMemoryGameController(
    ModifiedMemoryGameModel model,
    ModifiedMemoryGameView view,
  ) {
    _model = model;
    _view = view;
  }

  void start() {
    _view.setRowCount(_model.rowCount);
    _view.setColCount(_model.colCount);
    _view.run();
  }

  @override
  void onTap(int x, int y) {
    _model.selectToken(y, x);
    if (_model.isTurnOver) {
      _view.setTurnOver(true);
    }
    _view.notify();
  }

  @override
  void nextTurn() {
    if (_model.confirmTurnEnd()) {
      _view.setPlayer(_model.currentPlayer);
      _view.setGameDone(_model.isGameDone);
      _view.setScore(_model.getScore(Player.p1), _model.getScore(Player.p2));
      _view.setTurnOver(false);

      if (_model.winner != null) {
        _view.setWinner(_model.winner!);
      }

      _view.notify();
    }
  }

  @override
  int? getTokenNumber(int x, int y) {
    int? res = _model.getTokenNumber(y, x);
    return res;
  }
}
