import 'package:flutter/material.dart';
import 'package:piu_util/app/config/app_typeface.dart';
import 'package:piu_util/domain/enum/title_type.dart';

class TitleText extends StatelessWidget {
  const TitleText(this.text, this.type, {super.key});
  final String text;
  final TitleType type;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(text,
            style: AppTypeFace.title.copyWith(
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1.8
                ..color = Colors.white,
            )),
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [type.startColor, type.endColor],
            ).createShader(bounds);
          },
          child: Text(text, style: AppTypeFace.title),
        ),
      ],
    );
  }
}
