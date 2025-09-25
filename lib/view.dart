import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lab04_magleo_2023210907/common_types.dart';
import 'package:lab04_magleo_2023210907/controller.dart';

class ModifiedMemoryGameView {
  final ViewState _viewState = ViewState();
  late ViewObserver _viewObserver;

  void run() {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ViewState>.value(value: _viewState),
          Provider<ViewObserver>.value(value: _viewObserver),
        ],
        child: MyApp(),
      ),
    );
  }

  void attachObserver(ViewObserver observer) {
    _viewObserver = observer;
  }

  void setWinner(Player player) {
    _viewState.setWinner(player);
  }

  void setTurnOver(bool state) {
    _viewState.setTurnOver(state);
  }

  void setScore(int p1, int p2) {
    _viewState.setScore(p1, p2);
  }

  void setPlayer(Player player) {
    _viewState.setPlayer(player);
  }

  void setGameDone(bool state) {
    _viewState.setGameDone(state);
  }

  void setRowCount(int n) {
    _viewState.setRowCount(n);
  }

  void setColCount(int n) {
    _viewState.setColCount(n);
  }

  void notify() {
    _viewState.notify();
  }
}

class ViewState extends ChangeNotifier {
  bool _isGameDone = false;
  Player? _winner;
  final List<int> _score = [0, 0];
  Player _player = Player.p1;
  bool _isTurnOver = false;
  late int _rowCount;
  late int _colCount;

  Player get player => _player;
  List<int> get score => _score;
  bool get isGameDone => _isGameDone;
  Player? get winner => _winner;
  int get rowCount => _rowCount;
  int get colCount => _colCount;
  bool get isTurnOver => _isTurnOver;

  void setGameDone(bool state) {
    _isGameDone = state;
  }

  void setWinner(Player newWinner) {
    _winner = newWinner;
  }

  void setScore(int p1, int p2) {
    _score[0] = p1;
    _score[1] = p2;
  }

  void setPlayer(Player player) {
    _player = player;
  }

  void setTurnOver(bool state) {
    _isTurnOver = state;
  }

  void setRowCount(int n) {
    _rowCount = n;
  }

  void setColCount(int n) {
    _colCount = n;
  }

  void notify() {
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Space Mono',
      ),
      home: GamePage(),
    );
  }
}

// need to create the default page of cards
class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final observer = context.read<ViewObserver>();
    return Consumer<ViewState>(
      builder: (context, viewState, child) {
        return Column(
          children: [
            // Your row with a full-width button
            Padding(
              padding: const EdgeInsets.all(8.0), // optional spacing
              child: Row(
                children: [
                  if (viewState.isTurnOver == true)
                    Expanded(
                      // makes the button take full width of the row
                      child: ElevatedButton(
                        onPressed: () {
                          observer.nextTurn();
                        },
                        child: Text('End Turn'),
                      ),
                    ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0), // optional spacing
              child: Row(
                children: [
                  Center(
                    child: Text(
                      'Player 1: ${viewState.score[0]}, Player 2: ${viewState.score[1]}',
                    ),
                  ),
                ],
              ),
            ),

            // The game grid fills the remaining space
            if (!viewState.isGameDone)
              Expanded(
                child: GameGrid(
                  rowCount: viewState.rowCount,
                  colCount: viewState.colCount,
                ),
              ),

            if (viewState.isGameDone)
              Expanded(
                child: Center(
                  child: Text(
                    viewState.winner != null
                        ? "YOU WIN ${viewState.winner == Player.p1 ? 1 : 2}"
                        : "It was a draw :(",
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class GameGrid extends StatelessWidget {
  final int colCount;
  final int rowCount;
  const GameGrid({super.key, required this.colCount, required this.rowCount});

  @override
  Widget build(BuildContext context) {
    final observer = context.read<ViewObserver>();
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: colCount,
      children: <Widget>[
        for (int y = 0; y < rowCount; y++)
          for (int x = 0; x < colCount; x++)
            GridCell(x: x, y: y, number: observer.getTokenNumber(x, y)),
      ],
    );
  }
}

class GridCell extends StatelessWidget {
  final int? number;
  final int x;
  final int y;
  const GridCell({
    super.key,
    required this.x,
    required this.y,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    final observer = context.read<ViewObserver>();
    return GestureDetector(
      onTap: () {
        observer.onTap(x, y);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: SizedBox.expand(
          child: Container(
            color: Colors.amber,
            child: Center(
              child: Text(
                number == null ? '' : '$number',
                style: const TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
