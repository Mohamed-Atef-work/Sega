import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:sega_game/controllers/board_controller/sega_cubit.dart';
import 'package:sega_game/widgets/square.dart';

class SquaresWidget extends StatelessWidget {
  const SquaresWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SegaCubit, SegaState>(
      builder: (_, state) {
        return Wrap(
          direction: Axis.horizontal,
          children: List.generate(
            9,
            (index) => SquareWidget(index),
          ),
        );
      },
    );
  }
}
