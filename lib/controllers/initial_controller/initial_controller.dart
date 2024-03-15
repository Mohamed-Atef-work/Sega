import 'package:sega_game/utils/repo.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InitialController {
  final repo = SegaRepoImpl();

  bool areYouX = true;
  String? opponentId;
  bool? isOpponentX;
  String? yourId;

  Future<bool> start() async {
    if (yourId != null) {
      final opponent = await repo.getOpponentId(yourId!);
      await repo.uploadYourSquares(yourSquares: [8, 7, 6], yourId: yourId!);
      opponentId = opponent;

      if (opponent != null) {
        final isOpponentX = await _getOpponentIsX();

        if (isOpponentX != areYouX) {
          return true;
        } else {
          Fluttertoast.showToast(msg: "Opponent is the same, Change...");
          return false;
        }
      }
      Fluttertoast.showToast(msg: "There is no opponent yet");
      return false;
    }
    Fluttertoast.showToast(msg: "Select X or O");
    return false;
  }

  Future<void> uploadIsX() async {
    final id = await repo.uploadIsX(isX: areYouX, yourId: yourId);
    yourId = id;
  }

  Future<bool> _getOpponentIsX() async {
    final isX = await repo.getOpponentIsX(opponentId!);
    isOpponentX = isX;
    return isX;
  }
}
