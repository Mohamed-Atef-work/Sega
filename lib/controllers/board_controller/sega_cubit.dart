import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sega_game/utils/logic_helper.dart';
import 'package:sega_game/utils/repo.dart';
import 'package:sega_game/utils/request_state.dart';


part 'sega_state.dart';

class SegaCubit extends Cubit<SegaState> {
  SegaCubit() : super(const SegaState());

  final repo = SegaRepoImpl();

  int yourMoves = 0;
  int opponentMoves = 0;
  bool checkFirst = true;
  List<bool> haveYouMoved = List.generate(9, (index) => false);
  List<bool> hasOpponentMoved = List.generate(9, (index) => false);

  void initial(InitialParams params) {
    emit(
      state.copyWith(
        yourId: params.yourId,
        areYouX: params.areYouX,
        isYourTurn: params.areYouX,
        opponentId: params.opponentId,
      ),
    );
  }

  bool isBusySquare(int square) =>
      LogicHelper.doesItExist(value: square, inThisList: _busySquares());

  bool isMyPiece(int square) =>
      LogicHelper.doesItExist(value: square, inThisList: state.mySquares);

  void getData() {
    final stream = repo.getOpponentSquares(state.opponentId);
    stream.listen(
      (opponentSquares) {
        if (checkFirst) {
          bool areEqual = LogicHelper.areEqual(
            list: state.opponentSquares,
            ruler: opponentSquares,
          );
          if (opponentSquares.isNotEmpty && !areEqual) {
            checkFirst = false;
            _listener(opponentSquares);
          } else {
            checkFirst = true;
          }
        } else {
          _listener(opponentSquares);
        }
      },
    );
  }

  void _listener(List<int> opponentSquares) {
    final moved = LogicHelper.getWhoChanged(
      oldOne: state.opponentSquares,
      newOne: opponentSquares,
    );

    opponentMoves++;
    hasOpponentMoved[moved] = true;

    emit(
      state.copyWith(isYourTurn: true, opponentSquares: opponentSquares),
    );
    _haseOpponentWon();
  }

  _haseOpponentWon() {
    final won = LogicHelper.hasWon(
      hasMoved: hasOpponentMoved,
      numberOfMoves: opponentMoves,
      squares: state.opponentSquares,
    );
    if (won) {
      Fluttertoast.showToast(msg: "Opponent Won....");
      emit(state.copyWith(isYourTurn: false));
    }
    print("Your squares ----------> ${state.mySquares.toString()}");
    print("opponent squares ----------> ${state.opponentSquares.toString()}");
  }

  _haveYouWon() {
    final won = LogicHelper.hasWon(
      squares: state.mySquares,
      numberOfMoves: yourMoves,
      hasMoved: haveYouMoved,
    );
    if (won) {
      Fluttertoast.showToast(msg: "You Won...");

      emit(state.copyWith(isYourTurn: false));
    }
    print("Your squares ----------> ${state.mySquares.toString()}");
    print("opponent squares ----------> ${state.opponentSquares.toString()}");
  }

  void squareClicked(int index) {
    if (state.isYourTurn) {
      _myTurn(index);
    } else {
      Fluttertoast.showToast(msg: "Not your turn...");

      /// show Illegal .....
    }
  }

  void _myTurn(int index) {
    if (isMyPiece(index) && state.from == index) {
      _reset();
    } else if (isMyPiece(index)) {
      _moveFrom(index);
    } else if (!isBusySquare(index) &&
        state.squaresColors[index] == Colors.white) {
      /// Move ----->
      _moveTo(index);
    }
  }

  void _moveTo(int square) async {
    var yourSquares = List.generate(3, (index) => state.mySquares[index]);

    yourSquares = yourSquares
        .map((element) => element == state.from ? square : element)
        .toList();

//// ----------> code in the line 230...

    await _uploadData(
      squareMovingTo: square,
      yourSquares: yourSquares,
    );
  }

  void _moveFrom(int square) {
    var colors = _colorYourBusySquaresWhileMovingFrom(square);
    colors = _colorNotBusySquareWhileMovingFrom(colors);

    emit(
      state.copyWith(from: square, squaresColors: colors),
    );
  }

  List<Color> _colorYourBusySquaresWhileMovingFrom(int from) {
    var colors = List.generate(9, (index) => state.squaresColors[index]);

    for (var element in state.mySquares) {
      if (element == from) {
        colors[element] = Colors.grey;
      } else {
        colors[element] = Colors.transparent;
      }
    }
    return colors;
  }

  List<Color> _colorNotBusySquareWhileMovingFrom(List<Color> colors) {
    final notBusyList = _notBusySquares();
    for (var element in notBusyList) {
      colors[element] = Colors.white;
    }
    return colors;
  }

  _colorLoadingSquares(int movedTo) {
    var loadingColors = _resetColors();

    loadingColors[movedTo] = Colors.grey;
    loadingColors[state.from] = Colors.grey;

    emit(state.copyWith(squaresColors: loadingColors));
  }

  Future<void> _uploadData({
    required int squareMovingTo,
    required List<int> yourSquares,
  }) async {
    emit(state.copyWith(requestState: RequestState.loading));

    _colorLoadingSquares(squareMovingTo);

    await repo
        .uploadYourSquares(yourId: state.yourId, yourSquares: yourSquares)
        .then((_) {
      _uploadSuccess(
        yourSquares,
        squareMovingTo,
      );
      _haveYouWon();
    }).catchError((error) {
      _uploadError(error);
    });
  }

  _uploadSuccess(List<int> yourSquares, int squareMovingTo) {
    yourMoves++;
    haveYouMoved[squareMovingTo] = true;
    emit(
      state.copyWith(
        from: -1,
        isYourTurn: false,
        mySquares: yourSquares,
        squaresColors: _resetColors(),
        requestState: RequestState.success,
      ),
    );
  }

  _uploadError(String error) {
    emit(
      state.copyWith(
        from: -1,
        message: error.toString(),
        squaresColors: _resetColors(),
        requestState: RequestState.error,
      ),
    );
  }

  void _reset() => emit(
        state.copyWith(squaresColors: _resetColors(), from: -1),
      );

  List<Color> _resetColors() => List.generate(9, (index) => Colors.transparent);

  List<int> _notBusySquares() => LogicHelper.remove(
        thisList: _busySquares(),
        fromThisList: List.generate(9, (index) => index),
      );

  List<int> _busySquares() => state.mySquares + state.opponentSquares;

  void previousState(SegaState previousState) => emit(previousState);
}

/*for (int i = 0; i < yourSquares.length; i++) { // ----------> line 126
      if (yourSquares[i] == state.from) {
        yourSquares[i] = square;
      }
    }*/
class InitialParams {
  final String opponentId;
  final String yourId;
  final bool areYouX;

  InitialParams({
    required this.opponentId,
    required this.yourId,
    required this.areYouX,
  });
}
