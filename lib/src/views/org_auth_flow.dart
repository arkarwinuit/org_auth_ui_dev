import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:org_auth_ui_dev/org_auth_ui_dev.dart';
class OrgAuthFlow extends StatelessWidget {
  static const routeName = '/org-auth-flow';
  final String? initialRoute;
  final String logoAsset;
  final Future<SignInResponse> Function(String userId, {String? password}) onSubmit;
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
  final bool? useOrgAuthRoute;
  final Future<bool> Function(SignUpData signUpData)? onSignUpSubmit;
  final ValueListenable<bool>? signUpLoading;
  final VoidCallback? onSignUpBack;
  final void Function()? onTermsAndConditions;

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
    this.useOrgAuthRoute,
    this.onSignUpSubmit,
    this.signUpLoading,
    this.onSignUpBack,
    this.onTermsAndConditions
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
                isAvaliableSignUp: isAvaliableSignUp ?? false,
                phoneNoLabel: phoneNoLabel,
                emailLabel: emailLabel,
                passwordLabel: passwordLabel,
                signInButtonLabel: signInButtonLabel,
                signUpButtonLabel: signUpButtonLabel,
                haveNoAccountLabel: haveNoAccountLabel,
                useOrgAuthRoute: useOrgAuthRoute!,
                onVerifyOtp: useOrgAuthRoute! ? onVerifyOtp : null,
                onResendOtp: useOrgAuthRoute! ? onResendOtp : null,
                onSuccessOTP: useOrgAuthRoute! ? onSuccessOTP : null,
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
          case SignUpPage.routeName:
            // Only show sign-up page if it's available, otherwise redirect to sign-in
            if (isAvaliableSignUp != true) {
              return MaterialPageRoute(
                builder: (_) => SignInPage(
                  logoAsset: logoAsset,
                  primaryColor: primaryColor,
                  backgroundColor: backgroundColor,
                  textColor: textColor,
                  authFontFamily: authFontFamily,
                  phoneNoLabel: phoneNoLabel,
                  emailLabel: emailLabel,
                  passwordLabel: passwordLabel,
                  signInButtonLabel: signInButtonLabel,
                  signUpButtonLabel: signUpButtonLabel,
                  haveNoAccountLabel: haveNoAccountLabel,
                  isAvaliableSignUp: isAvaliableSignUp ?? false,
                  signInLoading: signInLoading,
                  onSubmit: onSubmit,
                  version: version,
                  openPlayStore: openPlayStore,
                  signInType: signInType,
                  onVerifyOtp: useOrgAuthRoute! ? onVerifyOtp : null,
                  onResendOtp: useOrgAuthRoute! ? onResendOtp : null,
                  onSuccessOTP: useOrgAuthRoute! ? onSuccessOTP : null,
                  useOrgAuthRoute: useOrgAuthRoute!,
                ),
              );
            }
            // Provide default implementations if not provided
            return MaterialPageRoute(
              builder: (_) => SignUpPage(
                logoAsset: logoAsset,
                primaryColor: primaryColor,
                backgroundColor: backgroundColor,
                textColor: textColor,
                authFontFamily: authFontFamily,
                signUpLoading: signUpLoading ?? ValueNotifier<bool>(false),
                onSubmit: onSignUpSubmit ?? (signUpData) async {
                  return true;
                },
                onBack: onSignUpBack,
                signInType: signInType,
                version: version,
                onTermsAndConditions: onTermsAndConditions,
                openPlayStore: openPlayStore,
                useOrgAuthRoute: useOrgAuthRoute ?? false,
                onVerifyOtp: useOrgAuthRoute ?? false ? onVerifyOtp : null,
                onResendOtp: useOrgAuthRoute ?? false ? onResendOtp : null,
                onSuccessOTP: useOrgAuthRoute ?? false ? onSuccessOTP : null
              ),
            );
          default:
            // For unknown routes, redirect to sign-in page
            return MaterialPageRoute(
              builder: (_) => SignInPage(
                logoAsset: logoAsset,
                primaryColor: primaryColor,
                backgroundColor: backgroundColor,
                textColor: textColor,
                authFontFamily: authFontFamily,
                phoneNoLabel: phoneNoLabel,
                emailLabel: emailLabel,
                passwordLabel: passwordLabel,
                signInButtonLabel: signInButtonLabel,
                signUpButtonLabel: signUpButtonLabel,
                haveNoAccountLabel: haveNoAccountLabel,
                isAvaliableSignUp: isAvaliableSignUp ?? false,
                signInLoading: signInLoading,
                onSubmit: onSubmit,
                version: version,
                openPlayStore: openPlayStore,
                signInType: signInType,
                onVerifyOtp: useOrgAuthRoute! ? onVerifyOtp : null,
                onResendOtp: useOrgAuthRoute! ? onResendOtp : null,
                onSuccessOTP: useOrgAuthRoute! ? onSuccessOTP : null,
                useOrgAuthRoute: useOrgAuthRoute!,
              ),
            );
        }
      },
    );
  }
}
