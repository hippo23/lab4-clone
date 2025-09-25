import 'package:lab04_magleo_2023210907/matching_class.dart';
import 'package:lab04_magleo_2023210907/model.dart';
import 'package:lab04_magleo_2023210907/controller.dart';
import 'package:lab04_magleo_2023210907/turnorder_class.dart';
import 'package:lab04_magleo_2023210907/view.dart';

void main(List<String> args) {
  int r = int.parse(args[0]);
  int c = int.parse(args[1]);
  int s = int.parse(args[2]);
  int k;

  String matchingModeString = args[3];
  String turnOrderString = args[4];

  TurnOrder turnOrder;
  MatchingMechanism matchingMechanism;

  if (turnOrderString == "roundrobin") {
    turnOrder = RoundRobin();
  } else if (turnOrderString == "untilincorrect") {
    turnOrder = UntilIncorrect();
  } else {
    return;
  }

  if (matchingModeString == "regular") {
    k = 2;
    matchingMechanism = RegularMatchingMechanism();
  } else if (matchingModeString == "extra1") {
    k = 3;
    matchingMechanism = ExtraOneMatchingMechanism();
  } else if (matchingModeString == "extra2") {
    k = 3;
    matchingMechanism = ExtraTwoMatchingMechanism();
  } else {
    return;
  }

  try {
    ModifiedMemoryGameModel model = ModifiedMemoryGameModel(
      r,
      c,
      k,
      s,
      turnOrder,
      matchingMechanism,
    );
    ModifiedMemoryGameView view = ModifiedMemoryGameView();
    // create the controller
    ModifiedMemoryGameController controller = ModifiedMemoryGameController(
      model,
      view,
    );
    view.attachObserver(controller);
  } catch (e) {
    return;
  }
}
