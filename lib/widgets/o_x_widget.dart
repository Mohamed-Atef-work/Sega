import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:sega_game/controllers/board_controller/sega_cubit.dart';

class XWidget extends StatelessWidget {
  final int index;
  const XWidget(this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    final controller = BlocProvider.of<SegaCubit>(context);
    return Center(
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Text(
          "X",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: controller.state.areYouX!
                ? controller.haveYouMoved[index]
                    ? Colors.white
                    : Colors.black
                : controller.hasOpponentMoved[index]
                    ? Colors.yellow
                    : Colors.black,
          ),
        ),
      ),
    );
  }
}

class OWidget extends StatelessWidget {
  final int index;
  const OWidget(this.index, {super.key});
  @override
  Widget build(BuildContext context) {
    final controller = BlocProvider.of<SegaCubit>(context);

    return Center(
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Text(
          "O",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: !controller.state.areYouX!
                ? controller.haveYouMoved[index]
                    ? Colors.white
                    : Colors.black
                : controller.hasOpponentMoved[index]
                    ? Colors.yellow
                    : Colors.black,
          ),
        ),
      ),
    );
  }
}
