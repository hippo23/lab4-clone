// this just takes in the last result of the player
// and decides who's turn it is. It does not care IF
// the player should be able to move to the next turn
// that is managed by the MachingMechanism class.

import 'common_types.dart';
import 'other_common_types.dart';

abstract class TurnOrder {
  Player nextPlayer(MatchingStage result, Player currentPlayer);
}

class RoundRobin implements TurnOrder {
  @override
  Player nextPlayer(MatchingStage result, Player currentPlayer) {
    if (currentPlayer == Player.p1) {
      return Player.p2;
    } else {
      return Player.p1;
    }
  }
}

class UntilIncorrect implements TurnOrder {
  @override
  Player nextPlayer(MatchingStage result, Player currentPlayer) {
    if (result == MatchingStage.success || result == MatchingStage.matching) {
      // return the regular player if matching is still in matching stage, its up to the
      // model to address this properly
      return currentPlayer;
    } else {
      if (currentPlayer == Player.p1) {
        return Player.p2;
      } else {
        return Player.p1;
      }
    }
  }
}
