import 'package:lab04_magleo_2023210907/matching_class.dart';
import 'package:lab04_magleo_2023210907/model.dart';
import 'package:lab04_magleo_2023210907/other_common_types.dart';
import 'package:test/test.dart';
import 'package:lab04_magleo_2023210907/common_types.dart';
import 'package:lab04_magleo_2023210907/turnorder_class.dart';

// test turn classes
void testTurns() {
  test('testRoundRobin', () {
    Player player = Player.p1;
    RoundRobin turnOrder = RoundRobin();

    player = turnOrder.nextPlayer(MatchingStage.matching, player);
    expect(player, equals(Player.p2));

    player = turnOrder.nextPlayer(MatchingStage.matching, player);
    expect(player, equals(Player.p1));
  });

  test('testUntilIncorrect', () {
    Player player = Player.p1;
    UntilIncorrect turnOrder = UntilIncorrect();

    player = turnOrder.nextPlayer(MatchingStage.matching, player);
    expect(player, equals(Player.p1));

    player = turnOrder.nextPlayer(MatchingStage.failed, player);
    expect(player, equals(Player.p2));

    player = turnOrder.nextPlayer(MatchingStage.success, player);
    expect(player, equals(Player.p2));
  });
}

// test matching classes
void testMatching() {
  test('testRegularSuccess', () {
    RegularMatchingMechanism matching = RegularMatchingMechanism();
    int? lastPick;
    int pick = 0;

    expect(matching.nextStage(lastPick, pick), equals(false));
    expect(matching.stage, equals(MatchingStage.matching));

    lastPick = pick;
    pick = 0;

    expect(matching.nextStage(lastPick, pick), equals(true));
    expect(matching.stage, equals(MatchingStage.success));
  });

  test('testRegularFailed', () {
    RegularMatchingMechanism matching = RegularMatchingMechanism();
    int? lastPick;
    int pick = 0;

    expect(matching.nextStage(lastPick, pick), equals(false));
    expect(matching.stage, equals(MatchingStage.matching));

    lastPick = pick;
    pick = 1;

    expect(matching.nextStage(lastPick, pick), equals(true));
    expect(matching.stage, equals(MatchingStage.failed));
  });

  test('testExtraOneSuccess', () {
    ExtraOneMatchingMechanism matching = ExtraOneMatchingMechanism();
    int? lastPick;
    int pick = 0;

    expect(matching.nextStage(lastPick, pick), equals(false));
    expect(matching.stage, equals(MatchingStage.matching));

    lastPick = pick;
    pick = 0;

    expect(matching.nextStage(lastPick, pick), equals(false));
    expect(matching.stage, equals(MatchingStage.matching));

    lastPick = pick;
    pick = 0;

    expect(matching.nextStage(lastPick, pick), equals(true));
    expect(matching.stage, equals(MatchingStage.success));
  });

  test('testExtraOneFailed', () {
    // first fail scenario, we fail at the end
    ExtraOneMatchingMechanism matching = ExtraOneMatchingMechanism();
    int? lastPick;
    int pick = 0;

    expect(matching.nextStage(lastPick, pick), equals(false));
    expect(matching.stage, equals(MatchingStage.matching));

    lastPick = pick;
    pick = 0;

    expect(matching.nextStage(lastPick, pick), equals(false));
    expect(matching.stage, equals(MatchingStage.matching));

    lastPick = pick;
    pick = 1;

    expect(matching.nextStage(lastPick, pick), equals(true));
    expect(matching.stage, equals(MatchingStage.failed));
  });

  test('testExtraOneFailed', () {
    // first fail scenario, we fail at the end
    ExtraOneMatchingMechanism matching = ExtraOneMatchingMechanism();
    int? lastPick;
    int pick = 0;

    expect(matching.nextStage(lastPick, pick), equals(false));
    expect(matching.stage, equals(MatchingStage.matching));

    lastPick = pick;
    pick = 0;

    expect(matching.nextStage(lastPick, pick), equals(false));
    expect(matching.stage, equals(MatchingStage.matching));

    lastPick = pick;
    pick = 1;

    expect(matching.nextStage(lastPick, pick), equals(true));
    expect(matching.stage, equals(MatchingStage.failed));

    matching.resetMatching();

    lastPick = null;
    pick = 0;

    expect(matching.nextStage(lastPick, pick), equals(false));
    expect(matching.stage, equals(MatchingStage.matching));

    lastPick = pick;
    pick = 1;

    expect(matching.nextStage(lastPick, pick), equals(false));
    expect(matching.stage, equals(MatchingStage.failed));

    lastPick = pick;
    pick = 0;

    expect(matching.nextStage(lastPick, pick), equals(true));
    expect(matching.stage, equals(MatchingStage.failed));
  });

  test('testExtraTwoSuccess', () {
    ExtraTwoMatchingMechanism matching = ExtraTwoMatchingMechanism();
    int? lastPick;
    int pick = 0;

    expect(matching.nextStage(lastPick, pick), equals(false));
    expect(matching.stage, equals(MatchingStage.matching));

    lastPick = pick;
    pick = 0;

    expect(matching.nextStage(lastPick, pick), equals(false));
    expect(matching.stage, equals(MatchingStage.matching));

    lastPick = pick;
    pick = 0;

    expect(matching.nextStage(lastPick, pick), equals(true));
    expect(matching.stage, equals(MatchingStage.success));
  });

  test('testExtraTwoFailed', () {
    ExtraTwoMatchingMechanism matching = ExtraTwoMatchingMechanism();
    int? lastPick;
    int pick = 0;

    expect(matching.nextStage(lastPick, pick), equals(false));
    expect(matching.stage, equals(MatchingStage.matching));

    lastPick = pick;
    pick = 1;

    expect(matching.nextStage(lastPick, pick), equals(true));
    expect(matching.stage, equals(MatchingStage.failed));

    expect(matching.nextStage(lastPick, pick), equals(true));

    matching.resetMatching();

    lastPick = pick;
    pick = 0;

    expect(matching.nextStage(lastPick, pick), equals(false));
    expect(matching.stage, equals(MatchingStage.matching));

    lastPick = pick;
    pick = 0;

    expect(matching.nextStage(lastPick, pick), equals(false));
    expect(matching.stage, equals(MatchingStage.matching));

    lastPick = pick;
    pick = 1;

    expect(matching.nextStage(lastPick, pick), equals(true));
    expect(matching.stage, equals(MatchingStage.failed));

    expect(matching.nextStage(lastPick, pick), equals(true));
    expect(matching.stage, equals(MatchingStage.failed));
  });
}

void testGameplay() {
  test('testFaultyModel', () {
    RoundRobin turnOrder = RoundRobin();
    RegularMatchingMechanism matching = RegularMatchingMechanism();
    expect(
      () => ModifiedMemoryGameModel(0, 5, 150, turnOrder, matching),
      throwsA(equals("Invalid grid")),
    );

    expect(
      () => ModifiedMemoryGameModel(3, 5, 150, turnOrder, matching),
      throwsA(equals("Invalid grid")),
    );
  });

  test('testGameplayDraw', () {
    RoundRobin turnOrder = RoundRobin();
    RegularMatchingMechanism matching = RegularMatchingMechanism();
    ModifiedMemoryGameModel model = ModifiedMemoryGameModel(
      3,
      4,
      150,
      turnOrder,
      matching,
    );

    expect(model.currentPlayer, equals(Player.p1));
    expect(model.isGameDone, equals(false));
    expect(model.rowCount, equals(3));
    expect(model.colCount, equals(4));
    expect(model.winner, equals(null));

    // turn for player one: group 4
    expect(model.confirmTurnEnd(), equals(false));

    expect(model.getTokenNumber(0, 0), equals(null));
    expect(model.getTokenNumber(-1, 0), equals(null));
    expect(model.getTokenNumber(0, -1), equals(null));

    expect(model.selectToken(0, 0), equals(true));

    expect(model.getTokenNumber(0, 0), equals(4));

    expect(model.selectToken(0, 0), equals(false));
    expect(model.selectToken(10, 10), equals(false));
    expect(model.selectToken(-5, 0), equals(false));
    expect(model.selectToken(0, -5), equals(false));
    expect(model.selectToken(2, 1), equals(true));

    expect(model.isTurnOver, equals(true));
    expect(model.confirmTurnEnd(), equals(true));

    expect(model.currentPlayer, equals(Player.p2));
    expect(model.getScore(Player.p1), equals(1));
    expect(model.getScore(Player.p2), equals(0));

    expect(model.isTurnOver, equals(false));

    // take another turn for player two: group 5
    expect(model.selectToken(0, 1), equals(true));
    expect(model.selectToken(0, 3), equals(true));

    expect(model.isTurnOver, equals(true));
    expect(model.confirmTurnEnd(), equals(true));

    expect(model.currentPlayer, equals(Player.p1));
    expect(model.getScore(Player.p1), equals(1));
    expect(model.getScore(Player.p2), equals(1));

    // take another turn for player two: group 6
    expect(model.selectToken(2, 3), equals(true));
    expect(model.selectToken(0, 2), equals(true));

    expect(model.isTurnOver, equals(true));
    expect(model.confirmTurnEnd(), equals(true));

    expect(model.currentPlayer, equals(Player.p2));
    expect(model.getScore(Player.p1), equals(2));
    expect(model.getScore(Player.p2), equals(1));

    // take another turn for player two: group 1
    expect(model.selectToken(1, 0), equals(true));
    expect(model.selectToken(1, 3), equals(true));

    expect(model.isTurnOver, equals(true));
    expect(model.confirmTurnEnd(), equals(true));

    expect(model.currentPlayer, equals(Player.p1));
    expect(model.getScore(Player.p1), equals(2));
    expect(model.getScore(Player.p2), equals(2));

    // take another turn for player one: group 2
    expect(model.selectToken(1, 1), equals(true));
    expect(model.selectToken(1, 2), equals(true));

    expect(model.isTurnOver, equals(true));
    expect(model.confirmTurnEnd(), equals(true));

    expect(model.currentPlayer, equals(Player.p2));
    expect(model.getScore(Player.p1), equals(3));
    expect(model.getScore(Player.p2), equals(2));

    // take another turn for player two: group 3 (DRAW)
    expect(model.selectToken(2, 2), equals(true));
    expect(model.selectToken(2, 0), equals(true));

    expect(model.isTurnOver, equals(true));
    expect(model.confirmTurnEnd(), equals(true));

    expect(model.currentPlayer, equals(Player.p2));
    expect(model.getScore(Player.p1), equals(3));
    expect(model.getScore(Player.p2), equals(3));

    expect(model.isGameDone, equals(true));
    expect(model.winner, equals(null));
  });

  test('testGameplayWinPlayerTwo', () {
    RoundRobin turnOrder = RoundRobin();
    RegularMatchingMechanism matching = RegularMatchingMechanism();
    ModifiedMemoryGameModel model = ModifiedMemoryGameModel(
      3,
      4,
      150,
      turnOrder,
      matching,
    );

    expect(model.currentPlayer, equals(Player.p1));
    expect(model.isGameDone, equals(false));
    expect(model.rowCount, equals(3));
    expect(model.colCount, equals(4));
    expect(model.winner, equals(null));

    // turn for player one: group 4
    expect(model.confirmTurnEnd(), equals(false));

    expect(model.getTokenNumber(0, 0), equals(null));
    expect(model.getTokenNumber(-1, 0), equals(null));
    expect(model.getTokenNumber(0, -1), equals(null));

    expect(model.selectToken(0, 0), equals(true));

    expect(model.getTokenNumber(0, 0), equals(4));

    expect(model.selectToken(0, 0), equals(false));
    expect(model.selectToken(10, 10), equals(false));
    expect(model.selectToken(-5, 0), equals(false));
    expect(model.selectToken(0, -5), equals(false));
    expect(model.selectToken(2, 1), equals(true));

    expect(model.isTurnOver, equals(true));
    expect(model.confirmTurnEnd(), equals(true));

    expect(model.currentPlayer, equals(Player.p2));
    expect(model.getScore(Player.p1), equals(1));
    expect(model.getScore(Player.p2), equals(0));

    expect(model.isTurnOver, equals(false));

    // take another turn for player two: group 5 (FAIL)
    expect(model.selectToken(0, 1), equals(true));
    expect(model.selectToken(0, 2), equals(true));

    expect(model.isTurnOver, equals(true));
    expect(model.confirmTurnEnd(), equals(true));

    expect(model.currentPlayer, equals(Player.p1));
    expect(model.getScore(Player.p1), equals(1));
    expect(model.getScore(Player.p2), equals(0));

    // take another turn for player one: group 5
    expect(model.selectToken(0, 1), equals(true));
    expect(model.selectToken(0, 3), equals(true));

    expect(model.isTurnOver, equals(true));
    expect(model.confirmTurnEnd(), equals(true));

    expect(model.currentPlayer, equals(Player.p2));
    expect(model.getScore(Player.p1), equals(2));
    expect(model.getScore(Player.p2), equals(0));

    // take another turn for player two: group 6
    expect(model.selectToken(2, 3), equals(true));
    expect(model.selectToken(0, 2), equals(true));

    expect(model.isTurnOver, equals(true));
    expect(model.confirmTurnEnd(), equals(true));

    expect(model.currentPlayer, equals(Player.p1));
    expect(model.getScore(Player.p1), equals(2));
    expect(model.getScore(Player.p2), equals(1));

    // take another turn for player one: group 1
    expect(model.selectToken(1, 0), equals(true));
    expect(model.selectToken(1, 3), equals(true));

    expect(model.isTurnOver, equals(true));
    expect(model.confirmTurnEnd(), equals(true));

    expect(model.currentPlayer, equals(Player.p2));
    expect(model.getScore(Player.p1), equals(3));
    expect(model.getScore(Player.p2), equals(1));

    // take another turn for player two: group 2
    expect(model.selectToken(1, 1), equals(true));
    expect(model.selectToken(1, 2), equals(true));

    expect(model.isTurnOver, equals(true));
    expect(model.confirmTurnEnd(), equals(true));

    expect(model.currentPlayer, equals(Player.p1));
    expect(model.getScore(Player.p1), equals(3));
    expect(model.getScore(Player.p2), equals(2));

    // take another turn for player one: group 3 (WIN)
    expect(model.selectToken(2, 0), equals(true));
    expect(model.selectToken(2, 2), equals(true));

    expect(model.isTurnOver, equals(true));
    expect(model.confirmTurnEnd(), equals(true));

    expect(model.currentPlayer, equals(Player.p1));
    expect(model.getScore(Player.p1), equals(4));
    expect(model.getScore(Player.p2), equals(2));

    expect(model.isGameDone, equals(true));
    expect(model.winner, equals(Player.p1));
  });

  test('testGameplayWinPlayerTwo', () {
    RoundRobin turnOrder = RoundRobin();
    RegularMatchingMechanism matching = RegularMatchingMechanism();
    ModifiedMemoryGameModel model = ModifiedMemoryGameModel(
      3,
      4,
      150,
      turnOrder,
      matching,
    );

    expect(model.currentPlayer, equals(Player.p1));
    expect(model.isGameDone, equals(false));
    expect(model.rowCount, equals(3));
    expect(model.colCount, equals(4));
    expect(model.winner, equals(null));

    // turn for player one: group 4
    expect(model.confirmTurnEnd(), equals(false));

    expect(model.getTokenNumber(0, 0), equals(null));
    expect(model.getTokenNumber(-1, 0), equals(null));
    expect(model.getTokenNumber(0, -1), equals(null));

    expect(model.selectToken(0, 0), equals(true));

    expect(model.getTokenNumber(0, 0), equals(4));

    expect(model.selectToken(0, 0), equals(false));
    expect(model.selectToken(10, 10), equals(false));
    expect(model.selectToken(-5, 0), equals(false));
    expect(model.selectToken(0, -5), equals(false));
    expect(model.selectToken(2, 1), equals(true));

    expect(model.isTurnOver, equals(true));
    expect(model.confirmTurnEnd(), equals(true));

    expect(model.currentPlayer, equals(Player.p2));
    expect(model.getScore(Player.p1), equals(1));
    expect(model.getScore(Player.p2), equals(0));

    expect(model.isTurnOver, equals(false));

    // take another turn for player two: group 5
    expect(model.selectToken(0, 1), equals(true));
    expect(model.selectToken(0, 3), equals(true));

    expect(model.isTurnOver, equals(true));
    expect(model.confirmTurnEnd(), equals(true));

    expect(model.currentPlayer, equals(Player.p1));
    expect(model.getScore(Player.p1), equals(1));
    expect(model.getScore(Player.p2), equals(1));

    // take another turn for player one: group 6 (FAIL)
    expect(model.selectToken(2, 3), equals(true));
    expect(model.selectToken(2, 2), equals(true));

    expect(model.isTurnOver, equals(true));
    expect(model.confirmTurnEnd(), equals(true));

    expect(model.currentPlayer, equals(Player.p2));
    expect(model.getScore(Player.p1), equals(1));
    expect(model.getScore(Player.p2), equals(1));

    // take another turn for player two: group 6
    expect(model.selectToken(2, 3), equals(true));
    expect(model.selectToken(0, 2), equals(true));

    expect(model.isTurnOver, equals(true));
    expect(model.confirmTurnEnd(), equals(true));

    expect(model.currentPlayer, equals(Player.p1));
    expect(model.getScore(Player.p1), equals(1));
    expect(model.getScore(Player.p2), equals(2));

    // take another turn for player one: group 1 (FAIL)
    expect(model.selectToken(1, 0), equals(true));
    expect(model.selectToken(1, 2), equals(true));

    expect(model.isTurnOver, equals(true));
    expect(model.confirmTurnEnd(), equals(true));

    expect(model.currentPlayer, equals(Player.p2));
    expect(model.getScore(Player.p1), equals(1));
    expect(model.getScore(Player.p2), equals(2));

    // take another turn for player two: group 1
    expect(model.selectToken(1, 0), equals(true));
    expect(model.selectToken(1, 3), equals(true));

    expect(model.isTurnOver, equals(true));
    expect(model.confirmTurnEnd(), equals(true));

    expect(model.currentPlayer, equals(Player.p1));
    expect(model.getScore(Player.p1), equals(1));
    expect(model.getScore(Player.p2), equals(3));

    // take another turn for player one: group 2
    expect(model.selectToken(1, 1), equals(true));
    expect(model.selectToken(1, 2), equals(true));

    expect(model.isTurnOver, equals(true));
    expect(model.confirmTurnEnd(), equals(true));

    expect(model.currentPlayer, equals(Player.p2));
    expect(model.getScore(Player.p1), equals(2));
    expect(model.getScore(Player.p2), equals(3));

    // take another turn for player two: group 3 (WIN)
    expect(model.selectToken(2, 2), equals(true));
    expect(model.selectToken(2, 0), equals(true));

    expect(model.isTurnOver, equals(true));
    expect(model.confirmTurnEnd(), equals(true));

    expect(model.currentPlayer, equals(Player.p2));
    expect(model.getScore(Player.p1), equals(2));
    expect(model.getScore(Player.p2), equals(4));

    expect(model.isGameDone, equals(true));
    expect(model.winner, equals(Player.p2));
  });
}

// test actual gameplay
void main() {
  testTurns();
  testMatching();
  testGameplay();
}
