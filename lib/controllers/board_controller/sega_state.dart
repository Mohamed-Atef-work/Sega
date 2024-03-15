part of 'sega_cubit.dart';

@immutable
class SegaState {
  final int from;
  final bool? areYouX;
  final String yourId;
  final String message;
  final bool isYourTurn;
  final String opponentId;
  final List<int> mySquares;
  final List<int> opponentSquares;
  final RequestState requestState;
  final List<Color> squaresColors;

  const SegaState({
    this.areYouX,
    this.from = -1,
    this.yourId = "",
    this.message = "",
    this.opponentId = "",
    this.isYourTurn = false,
    this.mySquares = const [8, 7, 6],
    this.opponentSquares = const [0, 1, 2],
    this.requestState = RequestState.initial,
    this.squaresColors = const [
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
    ],
  });

  SegaState copyWith({
    int? from,
    bool? areYouX,
    String? yourId,
    String? message,
    bool? isYourTurn,
    String? opponentId,
    List<int>? mySquares,
    List<int>? opponentSquares,
    RequestState? requestState,
    List<Color>? squaresColors,
  }) =>
      SegaState(
        from: from ?? this.from,
        yourId: yourId ?? this.yourId,
        message: message ?? this.message,
        areYouX: areYouX ?? this.areYouX,
        mySquares: mySquares ?? this.mySquares,
        isYourTurn: isYourTurn ?? this.isYourTurn,
        opponentId: opponentId ?? this.opponentId,
        requestState: requestState ?? this.requestState,
        squaresColors: squaresColors ?? this.squaresColors,
        opponentSquares: opponentSquares ?? this.opponentSquares,
      );
}
