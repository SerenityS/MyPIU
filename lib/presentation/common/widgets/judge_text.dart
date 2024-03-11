import 'package:flutter/material.dart';
import 'package:piu_util/app/config/app_typeface.dart';
import 'package:piu_util/domain/enum/judge_type.dart';

class JudgeText extends StatelessWidget {
  const JudgeText(this.type, {super.key});

  final JudgeType type;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(type.name.toUpperCase(),
            style: AppTypeFace().judge.copyWith(
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 1.5
                    ..color = Colors.white,
                )),
        Text(
          type.name.toUpperCase(),
          style: AppTypeFace().judge.copyWith(color: type.color),
        ),
      ],
    );
  }
}
