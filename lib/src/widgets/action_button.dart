// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:org_auth_ui_dev/src/theme/auth_textstyle.dart';

class ActionButton extends StatelessWidget {
  final bool loading;
  final ValueNotifier<bool> isActionButtonActive;
  final void Function()? onTap;
  final String text;
  final Color primaryColor;
  const ActionButton(
      {super.key,
      required this.loading,
      required this.isActionButtonActive,
      required this.text,
      required this.onTap,
      required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth,
      height: screenHeight * 0.06,
      child: ValueListenableBuilder<bool>(
        valueListenable: isActionButtonActive,
        builder: (context, isActive, _) {
          return TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.center,
              foregroundColor: Colors.white,
              backgroundColor: isActive ? primaryColor : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: loading
                    ? Row(
                        children: [
                          Text(text, style: getText(color: Colors.white, fontSize: 16)),
                          const SizedBox(
                            height: 10,
                            child: SpinKitThreeBounce(
                              color: Colors.white,
                              size: 15,
                            )
                          )
                        ],
                      )
                    : Text(text,
                        style: getText(color: Colors.white, fontSize: 16)),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
