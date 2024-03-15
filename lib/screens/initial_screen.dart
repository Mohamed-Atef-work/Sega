import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:sega_game/controllers/board_controller/sega_cubit.dart';
import 'package:sega_game/controllers/initial_controller/initial_controller.dart';
import 'package:sega_game/screens/board_screen.dart';

class InitialSegaScreen extends StatefulWidget {
  const InitialSegaScreen({super.key});

  @override
  State<InitialSegaScreen> createState() => _InitialSegaScreenState();
}

class _InitialSegaScreenState extends State<InitialSegaScreen> {
  final controller = InitialController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: controller.areYouX ? Colors.white : Colors.black,
              ),
              child: TextButton(
                onPressed: () async {
                  controller.areYouX = true;
                  await controller.uploadIsX();
                  setState(() {});
                },
                child: Text(
                  "X",
                  style: TextStyle(
                      color: controller.areYouX ? Colors.black : Colors.white),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () async {
                  final result = await controller.start();
                  if (result) {
                    _startSuccess();
                  }
                },
                child: const Text(
                  "Start",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: !controller.areYouX ? Colors.white : Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () async {
                  controller.areYouX = false;
                  await controller.uploadIsX();
                  setState(() {});
                },
                child: Text(
                  "O",
                  style: TextStyle(
                      color: !controller.areYouX ? Colors.black : Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startSuccess() {
    final initial = InitialParams(
      opponentId: controller.opponentId!,
      areYouX: controller.areYouX,
      yourId: controller.yourId!,
    );
    BlocProvider.of<SegaCubit>(context).initial(initial);
    BlocProvider.of<SegaCubit>(context).getData();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => const BoardScreen(),
      ),
    );
  }
}
