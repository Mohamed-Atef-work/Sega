import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sega_game/utils/constants.dart';

abstract class SegaRepo {
  //Future<String?> uploadData(DataModel model);
  Future<String?> getOpponentId(String yourId);
  Future<bool> getOpponentIsX(String opponentId);
  Stream<List<int>> getOpponentSquares(opponentId);
  Future<String> uploadIsX({String? yourId, required bool isX});
  Future<void> uploadYourSquares(
      {required List<int> yourSquares, required String yourId});
}

class SegaRepoImpl implements SegaRepo {
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  @override
  Stream<List<int>> getOpponentSquares(opponentId) {
    final result = _store
        .collection(kSega)
        .doc(opponentId)
        .collection(kSquares)
        .doc(kSquares)
        .snapshots();
    return result.map(
      (documentSnap) {
        if (documentSnap.data() != null) {
          final squares = List.from(documentSnap.data()![kSquares]);
          print("----------------> squares = ${squares.toString()}");
          return squares.map((e) => _revers(e)).toList();
        } else {
          return const [];
        }
      },
    );
  }

  int _revers(int square) {
    int result = 8 - square;
    if (result < 0) {
      return result * -1;
    }
    return result;
  }

  @override
  Future<String?> getOpponentId(String yourId) async {
    final result = await _store.collection(kSega).get();
    for (var doc in result.docs) {
      if (doc.id != yourId) {
        return doc.id;
      }
    }
    return null;
  }

  @override
  Future<bool> getOpponentIsX(String opponentId) async {
    final result = await _store.collection(kSega).doc(opponentId).get();
    return result[kIsX];
  }

  @override
  Future<void> uploadYourSquares({
    required List<int> yourSquares,
    required String yourId,
  }) async {
    await _store
        .collection(kSega)
        .doc(yourId)
        .collection(kSquares)
        .doc(kSquares)
        .set({kSquares: yourSquares});
  }

  @override
  Future<String> uploadIsX({String? yourId, required bool isX}) async {
    if (yourId == null) {
      final result = await _store.collection(kSega).add({kIsX: isX});
      return result.id;
    } else {
      await _store.collection(kSega).doc(yourId).set({kIsX: isX});
      return yourId;
    }
  }
}

/*class DataModel {
  final List<int> yourSquares;
  final String? yourId;
  final bool isX;

  DataModel({
    required this.yourSquares,
    required this.isX,
    this.yourId,
  });

  Map<String, dynamic> toJson() => {
        kSquares: yourSquares,
        kIsX: isX,
      };
  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        yourSquares: List.from(json[kSquares]),
        isX: json[kIsX],
      );
}*/
