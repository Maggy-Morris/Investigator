import 'package:flutter/material.dart';

class NumberButton extends StatelessWidget {
  const NumberButton(
      {Key? key,
      required this.buttonText,
      required this.onTap,
      required this.isSelected,
      required this.size,
      required this.selectionColor,
      required this.notSelectedColor})
      : super(key: key);

  final String buttonText;
  final void Function() onTap;
  final bool isSelected;
  final double size;
  final Color selectionColor;
  final Color notSelectedColor;

  double _transformSize(double size) {
    return (this.size * size) / 44.0;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      hoverColor: Colors.transparent,
      child: Container(
        height: _transformSize(44.0),
        width: _transformSize(44.0),
        decoration: BoxDecoration(
          color: isSelected ? selectionColor : notSelectedColor,
          borderRadius: BorderRadius.circular(_transformSize(8.0)),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: _transformSize(18.0),
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
        alignment: AlignmentDirectional.center,
      ),
    );
  }
}