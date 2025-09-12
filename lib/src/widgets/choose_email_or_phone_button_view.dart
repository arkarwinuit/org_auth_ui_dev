import 'package:flutter/material.dart';

class ChooseEmailORPhoneButtonView extends StatelessWidget {
  const ChooseEmailORPhoneButtonView({
    super.key,
    required this.text,
    required this.onTap,
    required this.marginValue,
  });

  final String text;
  final Function onTap;
  final double marginValue;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: screenWidth,
      height: screenHeight * 0.06,
      child: TextButton(
        onPressed: () async {
          onTap();
        },
        style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(50, 30),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            alignment: Alignment.center,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(
                    width: 1, color: Theme.of(context).primaryColor))),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
