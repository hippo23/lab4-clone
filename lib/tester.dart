import 'package:lab04_magleo_2023210907/common_types.dart';
import 'package:lab04_magleo_2023210907/matching_class.dart';
import 'package:lab04_magleo_2023210907/model.dart';
import 'package:lab04_magleo_2023210907/turnorder_class.dart';

ModifiedMemoryGameModel? make(
  int r,
  int c,
  int s,
  MatchingModeTag matchingModeTag,
  TurnOrderTag turnOrderTag,
) {
  try {
    MatchingMechanism matchingMechanism;
    TurnOrder turnOrder;

    // the groupings

    if (turnOrderTag == TurnOrderTag.roundRobin) {
      turnOrder = RoundRobin();
    } else {
      turnOrder = UntilIncorrect();
    }

    if (matchingModeTag == MatchingModeTag.regular) {
      matchingMechanism = RegularMatchingMechanism();
    } else if (matchingModeTag == MatchingModeTag.extra1) {
      matchingMechanism = ExtraOneMatchingMechanism();
    } else {
      matchingMechanism = ExtraTwoMatchingMechanism();
    }

    ModifiedMemoryGameModel model = ModifiedMemoryGameModel(
      r,
      c,
      s,
      turnOrder,
      matchingMechanism,
    );

    return model;
  } catch (e) {
    return null;
  }
}
