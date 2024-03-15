//import 'package:collection/collection.dart'; // imports package that compare to sorted lists;

class LogicHelper {
  /// search in a List on a value and return -------> if it exists..............
  static bool doesItExist({
    required int value,
    required List<int> inThisList,
  }) {
    for (var element in inThisList) {
      if (element == value) {
        return true;
      }
    }

    return false;
  }

  /// compare {two Lists} and return -------> if there is a change .............
  static bool isThereAChange({
    required List<int> andThis,
    required List<int> betweenThis,
  }) {
    for (int i = 0; i < andThis.length; i++) {
      if (betweenThis[i] != andThis[i]) {
        return true;
      }
    }
    return false;
  }

  /// compare {two Lists} and return -------> value changed from the {First}....
  static int getWhoChanged({
    required List<int> newOne,
    required List<int> oldOne,
  }) {
    if (oldOne.length == oldOne.length) {
      for (var item in newOne) {
        bool isExisted = doesItExist(value: item, inThisList: oldOne);
        print("${item}-----isExisted------>${isExisted}");
        if (!isExisted) {
          return item;
        }
      }
    }
    print("Check getWhoChanged method in LOGICHELPER");
    return -1; // this line can cause an Error;

/*    for (int i = 0; i < newOne.length; i++) {
      if (newOne[i] != oldOne[i]) {
        return newOne[i];
      }
    }
    return 0;*/
  }

  static List<int> remove({
    required List<int> thisList,
    required List<int> fromThisList,
  }) {
    for (var item in thisList) {
      fromThisList.removeWhere((element) => element == item);
    }
    return fromThisList;
  }

  static int getTotal(List<int> list) {
    int total = 0;
    for (int element in list) {
      total = total + element;
    }
    print("total is -----------> ${total}");

    return total;
  }

  static bool areEqual({
    required List<int> list,
    required List<int> ruler,
  }) {
    if (list.length == ruler.length) {
      double length = 0;

      for (var item in list) {
        bool isExisted = doesItExist(value: item, inThisList: ruler);
        print("${item}-----isExisted------>${isExisted}");
        if (isExisted) {
          length = length + 1;
        } else {
          break;
        }
      }
      if (length == list.length) {
        print(" -------------------> fits ");
        return true;
      } else {
        print(" -------------------> does not fits ");
        return false;
      }
    }
    return false;
    //return const DeepCollectionEquality().equals(list, ruler); // the list must be sorted;
  }

  static bool doesItEqualAnyWinningPattern(List<int> list) {
    final total = getTotal(list);
    switch (total) {
      case 3:
        {
          return areEqual(list: list, ruler: [0, 1, 2]);
        }
      case 9:
        {
          return areEqual(list: list, ruler: [0, 3, 6]);
        }

      case 12:
        {
          if (areEqual(list: list, ruler: [0, 4, 8])) {
            return true;
          } else if (areEqual(list: list, ruler: [1, 4, 7])) {
            return true;
          } else if (areEqual(list: list, ruler: [3, 4, 5])) {
            return true;
          } else {
            return areEqual(list: list, ruler: [2, 4, 6]);
          }
        }
      case 15:
        {
          return areEqual(list: list, ruler: [2, 5, 8]);
        }
      case 21:
        {
          return areEqual(list: list, ruler: [6, 7, 8]);
        }
      default:
        {
          return false;
        }
    }
  }

  static bool hasWon({
    required int numberOfMoves,
    required List<int> squares,
    required List<bool> hasMoved,
  }) {
    if (numberOfMoves >= 3 &&
        hasMoved[squares[0]] == true &&
        hasMoved[squares[1]] == true &&
        hasMoved[squares[2]] == true) {
      print("number of Moves ---------------------> ${numberOfMoves}}");
      print("searching process ---------------------> get in");
      return doesItEqualAnyWinningPattern(squares);
    } else {
      print("number of Moves ---------------------> ${numberOfMoves}}");
      print("searching process ---------------------> get out");
      return false;
    }
  }
}
