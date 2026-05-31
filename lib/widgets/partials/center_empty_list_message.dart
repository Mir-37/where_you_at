import 'package:flutter/material.dart';

class CenterEmptyListMessage extends StatelessWidget {
  final String message;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  const CenterEmptyListMessage({
    super.key,
    required this.message,
    this.textColor,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: textColor ?? Theme.of(context).colorScheme.onSurface,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
