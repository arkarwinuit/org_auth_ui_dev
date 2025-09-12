import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'signin_page.dart';
import 'verify_otp_page.dart';
import '../theme/auth_font_family.dart';

class OrgAuthFlow extends StatelessWidget {
  static const routeName = '/org-auth-flow';
  final String? initialRoute;
  final String logoAsset;
  final Future<void> Function(String userId, {String? password}) onSubmit;
  final String version;
  final void Function() openPlayStore;
  final SignInType signInType;
  final Color primaryColor;
  final Color backgroundColor;
  final Color textColor;
  final AuthFontFamily? authFontFamily;
  final String? phoneNoLabel;
  final String? emailLabel;
  final String? passwordLabel;
  final String? signInButtonLabel;
  final String? signUpButtonLabel;
  final String? haveNoAccountLabel;
  final ValueListenable<bool> isResending;
  final ValueListenable<bool> verifyLoading;
  final ValueListenable<bool> signInLoading;
  final Future<bool> Function(String userId, String otp, String session) onVerifyOtp;
  final Future<void> Function(String userId, String session) onResendOtp;
  final VoidCallback onSuccessOTP;
  final bool? isAvaliableSignUp;

  const OrgAuthFlow({
    super.key,
    this.initialRoute = SignInPage.routeName,
    required this.logoAsset,
    required this.onSubmit,
    required this.version,
    required this.openPlayStore,
    required this.signInType,
    required this.primaryColor,
    required this.backgroundColor,
    required this.textColor,
    this.authFontFamily,
    this.phoneNoLabel,
    this.emailLabel,
    this.passwordLabel,
    this.signInButtonLabel,
    this.signUpButtonLabel,
    this.haveNoAccountLabel,
    required this.signInLoading,
    required this.isResending,
    required this.verifyLoading,
    required this.onVerifyOtp,
    required this.onResendOtp,
    required this.onSuccessOTP,
    this.isAvaliableSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: initialRoute,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case SignInPage.routeName:
            return MaterialPageRoute(
              builder: (_) => SignInPage(
                logoAsset: logoAsset,
                onSubmit: onSubmit,
                version: version,
                openPlayStore: openPlayStore,
                signInType: signInType,
                primaryColor: primaryColor,
                backgroundColor: backgroundColor,
                textColor: textColor,
                authFontFamily: authFontFamily,
                signInLoading: signInLoading,
                isAvaliableSignUp: isAvaliableSignUp ?? true,
                phoneNoLabel: phoneNoLabel,
                emailLabel: emailLabel,
                passwordLabel: passwordLabel,
                signInButtonLabel: signInButtonLabel,
                signUpButtonLabel: signUpButtonLabel,
                haveNoAccountLabel: haveNoAccountLabel,
              ),
            );
          case VerifyOtpPage.routeName:
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => VerifyOtpPage(
                userId: args['userId'],
                session: args['session'],
                userStatus: args['userStatus'],
                logoAsset: logoAsset,
                version: version,
                isResending: isResending,
                verifyLoading: verifyLoading,
                onVerifyOtp: onVerifyOtp,
                onResendOtp: onResendOtp,
                onSuccessOTP: onSuccessOTP,
              ),
            );
          default:
            return null;
        }
      },
    );
  }
}
