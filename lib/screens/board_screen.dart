import 'package:sega_game/controllers/board_controller/sega_cubit.dart';
import 'package:sega_game/utils/request_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:sega_game/widgets/square.dart';

class BoardScreen extends StatelessWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final controller = BlocProvider.of<SegaCubit>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<SegaCubit, SegaState>(
            builder: (context, state) =>
                controller.state.requestState == RequestState.loading
                    ? const LinearProgressIndicator()
                    : const SizedBox.shrink(),
          ),
          Container(
            width: width,
            height: width,
            margin: const EdgeInsets.all(5), //  to it's child from it ...
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Stack(
                children: [
                  _squares(),
                  _verticalLines(),
                  _horizontalLines(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _horizontalLines() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          4,
          (index) => Container(
            height: 1,
            color: Colors.black,
            width: double.infinity,
          ),
        ),
      );

  _verticalLines() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          4,
          (index) => Container(
            width: 1,
            color: Colors.black,
            height: double.infinity,
          ),
        ),
      );

  _squares() => BlocBuilder<SegaCubit, SegaState>(
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
