import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:org_auth_ui_dev/org_auth_ui_dev.dart';
import 'package:org_auth_ui_dev/src/theme/auth_textstyle.dart';
import 'package:org_auth_ui_dev/src/widgets/choose_email_or_phone_button_view.dart';
import 'package:org_auth_ui_dev/src/widgets/action_button.dart';

enum SignInType {
  emailPassword,
  phonePassword,
  phoneEmailOTP,
  emailOTP,
  phoneOTP,
}

class SignInPage extends StatefulWidget {
  static const routeName = '/org-signin';

  final Color primaryColor;
  final Color backgroundColor;
  final String fontFamily;
  final AuthFontFamily? authFontFamily;
  final String logoAsset;
  final String? signInTitle;
  final String? signInSubTitle;
  final TextStyle signInTitleStyle;
  final TextStyle signInSubTitleStyle;
  final String? phoneNoLabel;
  final String? emailLabel;
  final String? passwordLabel;
  final String? signInButtonLabel;
  final String? signUpButtonLabel;
  final String? haveNoAccountLabel;
  final Future<void> Function(String userId, {String? password}) onSubmit;
  final String version;
  final void Function() openPlayStore;
  final SignInType signInType;
  final bool isAvaliableSignUp;
  final Color textColor;
  final ValueListenable<bool> signInLoading;
  final List<Country> phoneCountries;

  const SignInPage({
    super.key,
    this.primaryColor = Colors.blue,
    this.backgroundColor = Colors.white,
    this.fontFamily = FontConstants.fontUbuntu,
    this.authFontFamily,
    required this.logoAsset,
    this.signInTitle,
    this.signInSubTitle,
    this.signInTitleStyle = const TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.w500, fontFamily: FontConstants.fontHelvetica),
    this.signInSubTitleStyle = const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500, fontFamily: FontConstants.fontHelvetica),
    this.phoneNoLabel,
    this.emailLabel,
    this.passwordLabel,
    this.signInButtonLabel,
    this.signUpButtonLabel,
    this.haveNoAccountLabel,
    required this.onSubmit,
    required this.version,
    required this.openPlayStore,
    required this.signInType,
    this.isAvaliableSignUp = true,
    this.textColor = Colors.black,
    required this.signInLoading,
    this.phoneCountries = const [
      Country(
        name: "Myanmar",
        code: "MM",
        dialCode: "95",
        minLength: 7,
        maxLength: 11,
        flag: "🇲🇲",
        nameTranslations: {},
      )
    ],
  });

  @override
  State<SignInPage> createState() => _SignInPageState();
  
  /// Get the effective font family to use
  String get effectiveFontFamily {
    return authFontFamily?.fontFamily ?? fontFamily;
  }
  
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneNoCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final ValueNotifier<bool> _withPhone = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _isActionButtonActive = ValueNotifier<bool>(false);
  bool _obscurePassword = true;

  @override
  void dispose() {
    phoneNoCtrl.dispose();
    emailCtrl.dispose();
    passwordController.dispose();
    _withPhone.dispose();
    _isActionButtonActive.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final l10n = OrgAuthLocalizations.of(context);
    final title = widget.signInTitle 
      ?? l10n?.signInTitle 
      ?? "Sign In";  // fallback English

    final subtitle = widget.signInSubTitle
      ?? l10n?.signInSubTitle
      ?? "Please enter your details below to continue";

    final phoneLabel = widget.phoneNoLabel
      ?? l10n?.phoneNumberLabel
      ?? "Phone Number";

    final emailLabel = widget.emailLabel
      ?? l10n?.emailLabel
      ?? "Email";

    final passwordLabel = widget.passwordLabel
      ?? l10n?.passwordLabel
      ?? "Password";

    final signInButton = widget.signInButtonLabel
      ?? l10n?.signInButton
      ?? "Continue";

    final signUpButton = widget.signUpButtonLabel
      ?? l10n?.signUpButton
      ?? "Sign Up";
    
    final haveNoAccount = widget.haveNoAccountLabel
      ?? l10n?.haveNoAccount
      ?? "Don't have an account? |";

    final or = l10n?.or
      ?? "or";
    
    final signInWithPhone = l10n?.signInWithPhone
      ?? "Sign In With Phone";
    
    final signInWithEmail = l10n?.signInWithEmail
      ?? "Sign In With Email";

    return AuthScaffold(
      logo: ClipRRect(
        borderRadius: BorderRadius.circular(0.0),
        child: Image.asset(widget.logoAsset, width: 110, height: 110),
      ),
      form: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: widget.signInTitleStyle,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              subtitle,
              style: widget.signInSubTitleStyle,
            ),
            const SizedBox(
              height: 20,
            ),

            ValueListenableBuilder(
              valueListenable: _withPhone,
              builder: (context, value, child) {
                return Column(
                  children: [
                    Visibility(
                      visible: (value && widget.signInType == SignInType.phoneEmailOTP) ||
                          widget.signInType == SignInType.phoneOTP ||
                          widget.signInType == SignInType.phonePassword,
                      child: IntlPhoneField(
                        controller: phoneNoCtrl,
                        countries: widget.phoneCountries,
                        initialCountryCode: 'MM', // ✅ ISO code
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          LengthLimitingTextInputFormatter(13),
                        ],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        disableLengthCheck: true,
                        dropdownIconPosition: IconPosition.trailing,
                        dropdownIcon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                        style: getText(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: widget.textColor,
                          fontFamily: widget.effectiveFontFamily,
                        ),
                        flagsButtonMargin: const EdgeInsets.only(left: 8),
                        decoration: InputDecoration(
                          labelText: phoneLabel,
                          labelStyle: getText(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: widget.textColor,
                            fontFamily: widget.effectiveFontFamily,
                          ),
                          hintText: "9XXXXXXXXX",
                          hintStyle: getText(
                            fontSize: 13,
                            color: widget.textColor.withValues(alpha: 0.25),
                            fontFamily: widget.effectiveFontFamily,
                          ),
                          filled: true,
                          fillColor: Theme.of(context).cardColor,
                          contentPadding: const EdgeInsets.only(left: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade500),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.red, width: 1.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.red, width: 1.5),
                          ),
                        ),
                        validator: (phone) {
                          if (phone == null || phone.number.trim().isEmpty) {
                            return "Phone Number cannot be empty";
                          }
                          if (phone.number.length < 7) {
                            return "Please type valid phone number";
                          }
                          return null;
                        },
                        onCountryChanged: (country) {
                          // print("Country selected: +${country.dialCode}");
                        },
                        onChanged: (phone) {
                          _isActionButtonActive.value = phone.number.isNotEmpty;
                        },
                      ),
                    ),
                    Visibility(
                      visible: (!value && widget.signInType == SignInType.phoneEmailOTP) || widget.signInType == SignInType.emailOTP || widget.signInType == SignInType.emailPassword, // Show phone field when _withPhone is true
                      child: TextFormField(
                        controller: emailCtrl,
                        style: getText(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: widget.textColor,
                          fontFamily: widget.effectiveFontFamily,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context).cardColor,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: Colors.grey.shade500),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: Colors.grey.shade500),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1.5),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          labelText: emailLabel,
                          labelStyle: Theme.of(context).textTheme.bodyMedium,
                          errorStyle: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                        validator: (value) => validateField(value, ValidationKeys.email),
                        onChanged: (email) {
                          _isActionButtonActive.value = email.isNotEmpty;
                        },
                      ),
                    ),
                  ],
                );
              },    ),
            // Password Field (only for email/password sign in)
            if (widget.signInType == SignInType.emailPassword || widget.signInType == SignInType.phonePassword) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: _obscurePassword,
                style: getText(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: widget.textColor,
                  fontFamily: widget.effectiveFontFamily,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                        color: Colors.grey.shade500),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                        color: Colors.grey.shade500),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                        color: Colors.red,
                        width: 1.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                        color: Colors.red,
                        width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  labelText: passwordLabel,
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  errorStyle: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                  hintText: "Enter your password",
                  hintStyle: getText(
                    fontSize: 13,
                    color: widget.textColor.withValues(alpha: 0.25),
                    fontFamily: widget.effectiveFontFamily,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) => validateField(value, ValidationKeys.signinpw),
              ),
            ],
          ],
        ),
      ),
      actionButton: ValueListenableBuilder<bool>(
        valueListenable: widget.signInLoading,
        builder: (context, isLoading, _) {
          return ActionButton(
            text: signInButton,
            loading: isLoading,
            isActionButtonActive: _isActionButtonActive,
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                if (_withPhone.value) {
                  await widget.onSubmit(
                    phoneNoCtrl.text,
                    password: (widget.signInType == SignInType.emailPassword  || widget.signInType == SignInType.phonePassword)
                        ? passwordController.text 
                        : null,
                  );
                  if (!isLoading) {
                    phoneNoCtrl.clear();
                    emailCtrl.clear();
                    passwordController.clear();
                    _isActionButtonActive.value = false;
                  }
                }
                else {
                  await widget.onSubmit(
                    emailCtrl.text,
                    password: (widget.signInType == SignInType.emailPassword  || widget.signInType == SignInType.phonePassword)
                        ? passwordController.text 
                        : null,
                  );
                  if (!isLoading) {
                    emailCtrl.clear();
                    passwordController.clear();
                    phoneNoCtrl.clear();
                    _isActionButtonActive.value = false;
                  }
                }
              }
            },
            primaryColor: widget.primaryColor,
          );
        },
      ),
      changeFormButton: ValueListenableBuilder<bool>(
        valueListenable: _withPhone,
        builder: (context, withPhone, _) {
          // Only show change form button when there are multiple sign-in options available
          bool shouldShowChangeButton = widget.signInType == SignInType.phoneEmailOTP;
          
          if (!shouldShowChangeButton) {
            return const SizedBox.shrink(); // Return empty widget if no change needed
          }
          
          return Column(
            children: [
              Center(
                child: Text(
                  or,
                  style: getText(
                    fontSize: 15,
                    color: widget.textColor,
                    fontFamily: widget.effectiveFontFamily,
                  ),
                )
              ),
              const SizedBox(height: 8),
              // Show the alternative option based on current state
              ChooseEmailORPhoneButtonView(
                marginValue: 20,
                text: withPhone ? signInWithEmail : signInWithPhone,
                onTap: () {
                  _withPhone.value = !withPhone;
                  phoneNoCtrl.clear();
                  emailCtrl.clear();
                  _isActionButtonActive.value = false;
                },
              ),
            ],
          );
        },
      ),
      routeButton: widget.isAvaliableSignUp ? 
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                haveNoAccount,
                style: getText(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: widget.textColor,
                  fontFamily: widget.effectiveFontFamily,
                ),
              ),
              InkWell(
                onTap: () {
                  // _navigateToSignUp(context);
                },
                child: Text(
                  signUpButton,
                  style: getText(
                    color: widget.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: widget.effectiveFontFamily,
                  ),
                ),
              ),
            ],
          ),
        ) : null,
      footer: widget.version.isNotEmpty ?
        InkWell(
          onTap: () {
            widget.openPlayStore();
          },
          child: Text(
            'Version: ${widget.version}',
            style: getText(
              fontSize: 14, 
              color: widget.textColor,
              fontFamily: widget.effectiveFontFamily,
            ),
          ),
        ) : null,
      appBarBackgroundColor: widget.backgroundColor,
      backgroundColor: widget.backgroundColor,
    );
  }
}
