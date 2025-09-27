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
    final orientation = MediaQuery.of(context).orientation;
    
    // Calculate height based on orientation for better landscape support
    double buttonHeight;
    if (orientation == Orientation.landscape) {
      // For landscape mode, use a minimum height with screen width consideration
      buttonHeight = MediaQuery.of(context).size.shortestSide * 0.08;
      buttonHeight = buttonHeight.clamp(48.0, 60.0); // Ensure reasonable bounds
    } else {
      // For portrait mode, use percentage of screen height
      buttonHeight = screenHeight * 0.06;
      buttonHeight = buttonHeight.clamp(48.0, 56.0); // Ensure reasonable bounds
    }

    return SizedBox(
      width: screenWidth,
      height: buttonHeight,
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
