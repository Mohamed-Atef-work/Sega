import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:sega_game/controllers/board_controller/sega_cubit.dart';
import 'package:sega_game/widgets/o_x_widget.dart';

class SquareWidget extends StatelessWidget {
  final int index;

  const SquareWidget(this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final controller = BlocProvider.of<SegaCubit>(context);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          print(index);
          controller.squareClicked(index);
        },
        child: Container(
          width: (width - 5 - 15 - 4 - 8 - 4 - 8 - 15 - 5) / 3,
          height: (width - 15 - 4 - 8 - 4 - 8 - 15) / 3,
          //margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: controller.state.squaresColors[index],
          ),
          child: controller.isBusySquare(index)
              ? controller.isMyPiece(index)
                  ? _xOrO(controller.state.areYouX!, index)
                  : _xOrO(!controller.state.areYouX!, index)
              : null,
        ),
      ),
    );
  }

  _xOrO(bool areYouX, int index) => areYouX ? XWidget(index) : OWidget(index);
}
