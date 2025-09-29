import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:org_auth_ui_dev/org_auth_ui_dev.dart';
import 'package:org_auth_ui_dev/src/theme/auth_textstyle.dart';
import 'package:org_auth_ui_dev/src/widgets/choose_email_or_phone_button_view.dart';
import 'package:org_auth_ui_dev/src/widgets/action_button.dart';
import 'package:org_auth_ui_dev/src/utils/nrc_data.dart';
import 'package:dropdown_search/dropdown_search.dart';

enum KYCType { nrc, passport }

class SignUpPage extends StatefulWidget {
  static const routeName = '/org-signup';

  final Color primaryColor;
  final Color backgroundColor;
  final String fontFamily;
  final AuthFontFamily? authFontFamily;
  final String logoAsset;
  final String? signUpTitle;
  final String? signUpSubTitle;
  final TextStyle signUpTitleStyle;
  final TextStyle signUpSubTitleStyle;
  final List<Country> phoneCountries;
  final SignInType signInType;
  final Color textColor;
  final ValueListenable<bool> signUpLoading;
  final Future<bool> Function(SignUpData signUpData) onSubmit;
  final bool withEmail;
  final VoidCallback? onBack;
  final String? version;
  final void Function()? onTermsAndConditions;
  final void Function()? openPlayStore;
  final bool useOrgAuthRoute;
  final Future<bool> Function(String userId, String otp, String session)? onVerifyOtp;
  final Future<void> Function(String userId, String session)? onResendOtp;
  final VoidCallback? onSuccessOTP;

  const SignUpPage({
    super.key,
    this.primaryColor = Colors.blue,
    this.backgroundColor = Colors.white,
    this.fontFamily = FontConstants.fontUbuntu,
    this.authFontFamily,
    required this.logoAsset,
    required this.signInType,
    this.signUpTitle,
    this.signUpSubTitle,
    this.signUpTitleStyle = const TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.w500, fontFamily: FontConstants.fontHelvetica),
    this.signUpSubTitleStyle = const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500, fontFamily: FontConstants.fontHelvetica),
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
    this.textColor = Colors.black,
    required this.signUpLoading,
    required this.onSubmit,
    this.withEmail = false,
    this.onBack,
    this.version,
    this.onTermsAndConditions,
    this.openPlayStore,
    this.useOrgAuthRoute = false,
    this.onVerifyOtp,
    this.onResendOtp,
    this.onSuccessOTP
  });

  String get effectiveFontFamily => authFontFamily?.fontFamily ?? fontFamily;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneNoCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController passportCtrl = TextEditingController();
  final TextEditingController nrcNumberCtrl = TextEditingController();
  final TextEditingController dobCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmPasswordCtrl = TextEditingController();

  final ValueNotifier<bool> _withPhone = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _isActionButtonActive = ValueNotifier<bool>(false);
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? nrcRegion;
  String? nrcTownship;
  String? nrcType;
  KYCType _kycType = KYCType.nrc;
  DateTime? _selectedDob;
  
  // NRC prefix and postfix structure
  String? selectedPrefix = NrcData().nrcPrefix.first;
  List<String> selectedRegionList = NrcData().regionOne;
  String? selectedRegion = "AHGAYA";
  String? selectedPostfix = NrcData().nrcPostfix.first;

  @override
  void dispose() {
    phoneNoCtrl.dispose();
    emailCtrl.dispose();
    nameCtrl.dispose();
    passportCtrl.dispose();
    nrcNumberCtrl.dispose();
    dobCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    _withPhone.dispose();
    _isActionButtonActive.dispose();
    super.dispose();
  }

  void _navigateToVerifyOtp(String userId, String session) {
    if (widget.useOrgAuthRoute) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyOtpPage(
            session: session,
            userId: userId,
            userStatus: 1, // Default user status for signup
            logoAsset: widget.logoAsset,
            version: widget.version ?? '',
            verifyLoading: ValueNotifier<bool>(false),
            isResending: ValueNotifier<bool>(false),
            onVerifyOtp: widget.onVerifyOtp ?? (userId, otp, session) async {
              // Default implementation - returns false if no callback provided
              return false;
            },
            onResendOtp: widget.onResendOtp ?? (userId, session) async {
              // Default implementation - does nothing if no callback provided
            },
            onSuccessOTP: widget.onSuccessOTP ?? () {
              // Default implementation - does nothing if no callback provided
            },
            backgroundColor: widget.backgroundColor,
            textColor: widget.textColor,
            primaryColor: widget.primaryColor,
          ),
        ),
      );
    }
  }

  void _pickDob() async {
    DateTime selectedDate = DateTime.now();
    DateTime currentDate = DateTime.now();

    final picked = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      locale: const Locale("en", "US"),
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: currentDate,
      confirmText: "ok",
      cancelText: "cancel",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: const TextTheme(
              bodyLarge: TextStyle(fontWeight: FontWeight.normal),
              bodyMedium: TextStyle(fontWeight: FontWeight.normal),
              bodySmall: TextStyle(fontWeight: FontWeight.normal),
            ),
            datePickerTheme: const DatePickerThemeData(
              backgroundColor: Colors.white,
            ),
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Theme.of(context).primaryColor,
                  surfaceTint: Colors.transparent,
                ),
          ),
          child: Center(child: child),
        );
      },
    );
    if (picked != null) {
      if (picked.isBefore(currentDate)) {
        _selectedDob = picked;
        dobCtrl.text =
            '${picked.day.toString()} ${DateFormat('MMM').format(picked)} ${picked.year.toString()}';
        if (mounted) {
          validateButton();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid selected date")),
          );
        }
      }
    }
  }

  selectRegion() {
    switch (selectedPrefix) {
      case "1/":
        selectedRegionList = NrcData().regionOne;
        break;
      case "2/":
        selectedRegionList = NrcData().regionTwo;
        break;
      case "3/":
        selectedRegionList = NrcData().regionThree;
        break;
      case "4/":
        selectedRegionList = NrcData().regionFour;
        break;
      case "5/":
        selectedRegionList = NrcData().regionFive;
        break;
      case "6/":
        selectedRegionList = NrcData().regionSix;
        break;
      case "7/":
        selectedRegionList = NrcData().regionSeven;
        break;
      case "8/":
        selectedRegionList = NrcData().regionEight;
        break;
      case "9/":
        selectedRegionList = NrcData().regionNine;
        break;
      case "10/":
        selectedRegionList = NrcData().regionTen;
        break;
      case "11/":
        selectedRegionList = NrcData().regionEleven;
        break;
      case "12/":
        selectedRegionList = NrcData().regionTwelve;
        break;
      case "13/":
        selectedRegionList = NrcData().regionThirdteen;
        break;
      case "14/":
        selectedRegionList = NrcData().regionFourteen;
        break;
      default:
        break;
    }
    setState(() {
      selectedRegion =
          selectedRegionList.isNotEmpty ? selectedRegionList.first : "";
      validateButton();
    });
  }

  void validateButton() {
    bool isValid = true;

    // Check name field (required)
    bool isNameValid = nameCtrl.text.trim().isNotEmpty;
    
    // Check phone or email field (required - either phone or email based on toggle)
    bool isContactValid = (phoneNoCtrl.text.trim().isNotEmpty && _withPhone.value) ||
                         (emailCtrl.text.trim().isNotEmpty && !_withPhone.value);
    
    // Check date of birth field (required)
    bool isDobValid = dobCtrl.text.isNotEmpty;
    
    // Check KYC fields based on type (required - either NRC or Passport)
    bool isKycValid = false;
    if (_kycType == KYCType.nrc) {
      // For NRC: prefix, region, postfix, and number must all be provided
      isKycValid = selectedPrefix?.isNotEmpty == true && 
                  selectedRegion?.isNotEmpty == true &&
                  selectedPostfix?.isNotEmpty == true &&
                  nrcNumberCtrl.text.trim().isNotEmpty;
    } else if (_kycType == KYCType.passport) {
      // For Passport: passport number must be provided
      isKycValid = passportCtrl.text.trim().isNotEmpty;
    }
    
    // Check password fields (only for email/password and phone/password sign up)
    bool isPasswordValid = true;
    if (widget.signInType == SignInType.emailPassword || widget.signInType == SignInType.phonePassword) {
      isPasswordValid = passwordCtrl.text.trim().isNotEmpty && 
                       passwordCtrl.text.length >= 6 &&
                       confirmPasswordCtrl.text.trim().isNotEmpty &&
                       passwordCtrl.text == confirmPasswordCtrl.text;
    }
    
    // All required fields must be valid: Name, (Email or Phone), (NRC or Passport), DOB, (Password if applicable)
    isValid = isNameValid && isContactValid && isDobValid && isKycValid && isPasswordValid;
    _isActionButtonActive.value = isValid;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = OrgAuthLocalizations.of(context);
    final title = widget.signUpTitle ?? l10n?.signUpTitle ?? "Register";
    final subtitle = widget.signUpSubTitle ?? l10n?.signInSubTitle ?? "Please enter your details below to continue";
    final phoneLabel = l10n?.phoneNumberLabel ?? "Phone Number";
    final emailLabel = l10n?.emailLabel ?? "Email";
    final nameLabel = l10n?.nameLabel ?? "Name";
    final nrcRadio = l10n?.nrcRadio ?? "NRC";
    final passportRadio = l10n?.passportRadio ?? "Passport";
    final passportLabel = l10n?.passportLabel ?? "Passport Number";
    final nrcLabel = l10n?.nrcLabel ?? "NRC Number";
    final dobLabel = l10n?.dobLabel ?? "Date of Birth";
    final passwordLabel = l10n?.passwordLabel ?? "Password";
    final continueLabel = l10n?.continueLabel ?? "Continue";
    final or = l10n?.or ?? "or";
    final registerWithPhone = l10n?.registerWithPhone ?? "Register with Phone";
    final registerWithEmail = l10n?.registerWithEmail ?? "Register with Email";

    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        backgroundColor: widget.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: widget.textColor,
          onPressed: () {
            if (widget.onBack != null) {
              widget.onBack!();
            } else {
              // When not using OrgAuthFlow, navigate directly to sign-in page
              Navigator.pushReplacementNamed(context, '/org-signin');
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8).copyWith(bottom: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0.0),
                    child: Image.asset(widget.logoAsset, width: 110, height: 110),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: widget.signUpTitleStyle,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  subtitle,
                  style: widget.signUpSubTitleStyle,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: nameCtrl,
                  style: getText(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: widget.textColor,
                    fontFamily: widget.effectiveFontFamily,
                  ),
                  decoration: InputDecoration(
                    labelText: nameLabel,
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
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
                    labelStyle: getText(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: widget.textColor,
                      fontFamily: widget.effectiveFontFamily,
                    ),
                    hintStyle: getText(
                      fontSize: 13,
                      color: widget.textColor.withValues(alpha: 0.25),
                      fontFamily: widget.effectiveFontFamily,
                    ),
                    hintText: "Enter your name",
                    errorStyle: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(70),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n?.nameempty ?? "Name cannot be empty";
                    }
                    if (value.length > 70) {
                      return l10n?.nametoolong ?? "Name cannot exceed 70 characters";
                    }
                    return null;
                  },
                  onChanged: (name) {
                    // Update action button state based on name and current phone/email field
                    if (_withPhone.value) {
                      _isActionButtonActive.value = name.isNotEmpty && phoneNoCtrl.text.isNotEmpty;
                    } else {
                      _isActionButtonActive.value = name.isNotEmpty && emailCtrl.text.isNotEmpty;
                    }
                  },
                ),
                const SizedBox(height: 16),
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
                            initialCountryCode: 'MM',
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
                                fontWeight: FontWeight.w500,
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
                              errorStyle: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                            validator: (phone) {
                              if (phone == null || phone.number.trim().isEmpty) {
                                return l10n?.phoneempty ?? "Phone Number cannot be empty";
                              }
                              if (phone.number.length < 7) {
                                return l10n?.phoneinvalidshort ?? "Please type valid phone number";
                              }
                              return null;
                            },
                            onCountryChanged: (country) {
                            },
                            onChanged: (phone) {
                              _isActionButtonActive.value = phone.number.isNotEmpty && nameCtrl.text.isNotEmpty;
                            },
                          ),
                        ),
                        Visibility(
                          visible: (!value && widget.signInType == SignInType.phoneEmailOTP) || widget.signInType == SignInType.emailOTP || widget.signInType == SignInType.emailPassword,
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
                              labelStyle: getText(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: widget.textColor,
                                fontFamily: widget.effectiveFontFamily,
                              ),
                              hintStyle: getText(
                                fontSize: 13,
                                color: widget.textColor.withValues(alpha: 0.25),
                                fontFamily: widget.effectiveFontFamily,
                              ),
                              hintText: "Enter your email",
                              errorStyle: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50),
                            ],
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n?.emailempty ?? "Email cannot be empty";
                              }
                              if (value.length > 50) {
                                return l10n?.emailtoolong ?? "Email cannot exceed 50 characters";
                              }
                              return validateField(value, ValidationKeys.email);
                            },
                            onChanged: (email) {
                              _isActionButtonActive.value = email.isNotEmpty && nameCtrl.text.isNotEmpty;
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                // Password Fields (only for email/password and phone/password sign up)
                if (widget.signInType == SignInType.emailPassword || widget.signInType == SignInType.phonePassword) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordCtrl,
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
                      labelStyle: getText(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: widget.textColor,
                        fontFamily: widget.effectiveFontFamily,
                      ),
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
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n?.passwordempty ?? "Password cannot be empty";
                      }
                      if (value.length < 6) {
                        return l10n?.passwordtooshort ?? "Password must be at least 6 characters";
                      }
                      return null;
                    },
                    onChanged: (password) {
                      validateButton();
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: confirmPasswordCtrl,
                    obscureText: _obscureConfirmPassword,
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
                      labelText: "Confirm Password",
                      labelStyle: getText(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: widget.textColor,
                        fontFamily: widget.effectiveFontFamily,
                      ),
                      errorStyle: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                      hintText: "Confirm your password",
                      hintStyle: getText(
                        fontSize: 13,
                        color: widget.textColor.withValues(alpha: 0.25),
                        fontFamily: widget.effectiveFontFamily,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n?.confirmpasswordempty ?? "Please confirm your password";
                      }
                      if (value != passwordCtrl.text) {
                        return l10n?.passwordmismatch ?? "Passwords do not match";
                      }
                      return null;
                    },
                    onChanged: (password) {
                      validateButton();
                    },
                  ),
                ],
                const SizedBox(height: 5),
                Row(
                  children: [
                    Radio<KYCType>(
                      value: KYCType.nrc,
                      groupValue: _kycType,
                      onChanged: (v) {
                        setState(() {
                          _kycType = v!;
                          validateButton();
                        });
                      },
                    ),
                    Text(nrcRadio, style: getText(fontSize: 15, color: widget.textColor)),
                    const SizedBox(width: 16),
                    Radio<KYCType>(
                      value: KYCType.passport,
                      groupValue: _kycType,
                      onChanged: (v) {
                        setState(() {
                          _kycType = v!;
                          validateButton();
                        });
                      },
                    ),
                    Text(passportRadio, style: getText(fontSize: 15, color: widget.textColor)),
                  ],
                ),
                if (_kycType == KYCType.nrc) ...[
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: DropdownSearch<String>(
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            fit: FlexFit.tight,
                            showSelectedItems: true,
                            searchDelay: Duration.zero,
                            constraints: const BoxConstraints(maxHeight: 300),
                            searchFieldProps: TextFieldProps(
                              padding: EdgeInsets.zero,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                constraints: const BoxConstraints(maxHeight: 45.0),
                              ),
                            ),
                            containerBuilder: (context, popupWidget) {
                              return Container(
                                color: Colors.grey.shade300,
                                child: popupWidget,
                              );
                            },
                            itemBuilder: (context, String item, bool isDisabled, bool isSelected) {
                              return SizedBox(
                                height: 45,
                                child: ListTile(
                                  title: Text(
                                    item,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? Theme.of(context).primaryColor
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          decoratorProps: DropDownDecoratorProps(
                            baseStyle: getText(
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
                                  color: Theme.of(context).primaryColor,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 1.0,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 1.5,
                                ),
                              ),
                              hintText: "",
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          items: (filter, loadProps) async => NrcData().nrcPrefix,
                          selectedItem: selectedPrefix,
                          onChanged: (String? value) {
                            setState(() {
                              selectedPrefix = value;
                              selectRegion();
                              validateButton();
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        flex: 2,
                        child: DropdownSearch<String>(
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            fit: FlexFit.tight,
                            showSelectedItems: true,
                            searchDelay: Duration.zero,
                            constraints: const BoxConstraints(maxHeight: 300),
                            searchFieldProps: TextFieldProps(
                              padding: EdgeInsets.zero,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                constraints: const BoxConstraints(maxHeight: 45.0),
                              ),
                            ),
                            containerBuilder: (context, popupWidget) {
                              return Container(
                                color: Colors.grey.shade300,
                                child: popupWidget,
                              );
                            },
                            itemBuilder: (context, String item, bool isDisabled, bool isSelected) {
                              return SizedBox(
                                height: 45,
                                child: ListTile(
                                  title: Text(
                                    item,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Theme.of(context).primaryColor
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          decoratorProps: DropDownDecoratorProps(
                            baseStyle: getText(
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
                                  color: Theme.of(context).primaryColor,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 1.0,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 1.5,
                                ),
                              ),
                              hintText: "",
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          items: (filter, loadProps) async => selectedRegionList,
                          selectedItem: selectedRegion,
                          onChanged: (String? value) {
                            setState(() {
                              selectedRegion = value;
                              validateButton();
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        flex: 1,
                        child: DropdownSearch<String>(
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            fit: FlexFit.tight,
                            showSelectedItems: true,
                            searchDelay: Duration.zero,
                            constraints: const BoxConstraints(maxHeight: 300),
                            searchFieldProps: TextFieldProps(
                              padding: EdgeInsets.zero,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                constraints: const BoxConstraints(maxHeight: 45.0),
                              ),
                            ),
                            containerBuilder: (context, popupWidget) {
                              return Container(
                                color: Colors.grey.shade300,
                                child: popupWidget,
                              );
                            },
                            itemBuilder: (context, String item, bool isDisabled, bool isSelected) {
                              return SizedBox(
                                height: 45,
                                child: ListTile(
                                  title: Text(
                                    item,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Theme.of(context).primaryColor
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          decoratorProps: DropDownDecoratorProps(
                            baseStyle: getText(
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
                                  color: Theme.of(context).primaryColor,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 1.0,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 1.5,
                                ),
                              ),
                              hintText: "",
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          items: (filter, loadProps) async => NrcData().nrcPostfix,
                          selectedItem: selectedPostfix,
                          onChanged: (String? value) {
                            setState(() {
                              selectedPostfix = value;
                              validateButton();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: nrcNumberCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    decoration: InputDecoration(
                      labelText: nrcLabel,
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
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
                      labelStyle: getText(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: widget.textColor,
                        fontFamily: widget.effectiveFontFamily,
                      ),
                        errorStyle: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                    onChanged: (v) => validateButton(),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return l10n?.required ?? "Required";
                      }
                      if (!RegExp(r'^[0-9]{6}$').hasMatch(v.trim())) {
                        return l10n?.nrcnumberinvalid ?? "NRC number must be exactly 6 digits";
                      }
                      return null;
                    },
                  ),
                ] else ...[
                  TextFormField(
                    controller: passportCtrl,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: passportLabel,
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
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
                      labelStyle: getText(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: widget.textColor,
                        fontFamily: widget.effectiveFontFamily,
                      ),
                        errorStyle: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                    onChanged: (v) => validateButton(),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return l10n?.required ?? "Required";
                      }
                      if (!RegExp(r'^[a-zA-Z0-9 ]{6,30}$').hasMatch(v.trim())) {
                        return l10n?.passportnumberinvalid ?? "Invalid passport number format";
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 16),
                TextFormField(
                  controller: dobCtrl,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: dobLabel,
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
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
                    labelStyle: getText(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: widget.textColor,
                      fontFamily: widget.effectiveFontFamily,
                    ),
                    errorStyle: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                    suffixIcon: Icon(Icons.calendar_today, color: widget.textColor),
                  ),
                  onTap: _pickDob,
                  validator: (v) => v == null || v.trim().isEmpty ? l10n?.required ?? "Required" : null,
                ),
                const SizedBox(height: 24),
                ValueListenableBuilder<bool>(
                  valueListenable: widget.signUpLoading,
                  builder: (context, isLoading, _) {
                    return ValueListenableBuilder<bool>(
                      valueListenable: _isActionButtonActive,
                      builder: (context, isActionButtonActive, _) {
                        return ActionButton(
                          text: continueLabel,
                          loading: isLoading,
                          isActionButtonActive: ValueNotifier<bool>(isActionButtonActive),
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              final kycData = _kycType == KYCType.nrc
                                  ? {
                                      'prefix': selectedPrefix ?? '',
                                      'region': selectedRegion ?? '',
                                      'postfix': selectedPostfix ?? '',
                                      'nrcNumber': nrcNumberCtrl.text,
                                    }
                                  : {
                                      'passport': passportCtrl.text,
                                    };
                              final signUpData = SignUpData(
                                name: nameCtrl.text,
                                userId: _withPhone.value ? phoneNoCtrl.text : emailCtrl.text,
                                kycType: _kycType == KYCType.nrc ? 'nrc' : 'passport',
                                kycData: kycData,
                                dob: _selectedDob!,
                                password: (widget.signInType == SignInType.emailPassword || widget.signInType == SignInType.phonePassword) ? passwordCtrl.text : null,
                              );
                              // Call onSubmit and check the boolean return value
                              final bool isSignUpSuccessful = await widget.onSubmit(signUpData);
                              if (isSignUpSuccessful) {
                                // Navigate to verify OTP if useOrgAuthRoute is true and sign-in type is OTP-related
                                if (widget.useOrgAuthRoute && 
                                    (widget.signInType == SignInType.phoneEmailOTP || 
                                     widget.signInType == SignInType.emailOTP || 
                                     widget.signInType == SignInType.phoneOTP)) {
                                  // For signup, we'll use a default session since the onSubmit doesn't return one
                                  // In a real implementation, the onSubmit should return a session or success response
                                  _navigateToVerifyOtp(signUpData.userId, 'default-session');
                                }
                              } else {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Sign up failed')),
                                );
                              }
                            }
                          },
                          primaryColor: widget.primaryColor,
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder<bool>(
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
                          ),
                        ),
                        const SizedBox(height: 16),
                        ChooseEmailORPhoneButtonView(
                            marginValue: 20,
                            text: withPhone ? registerWithEmail : registerWithPhone,
                            onTap: () {
                              setState(() {
                                _withPhone.value = !withPhone;
                                phoneNoCtrl.clear();
                                emailCtrl.clear();
                                // Reset action button state when toggling
                                _isActionButtonActive.value = nameCtrl.text.isNotEmpty && 
                                    (withPhone ? emailCtrl.text.isNotEmpty : phoneNoCtrl.text.isNotEmpty);
                              });
                            },
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: getText(
                        fontSize: 16,
                        color: widget.textColor,
                        fontFamily: widget.effectiveFontFamily,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/org-signin');
                      },
                      child: Text(
                        "Login",
                        style: getText(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: widget.primaryColor,
                          fontFamily: widget.effectiveFontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
                if (widget.onTermsAndConditions != null) ...[
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "By signing up, you agree to our ",
                        style: getText(
                          fontSize: 12,
                          color: widget.textColor.withValues(alpha: 0.6),
                          fontFamily: widget.effectiveFontFamily,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.onTermsAndConditions?.call();
                        },
                        child: Text(
                          "Terms and Conditions.",
                          style: getText(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: widget.primaryColor,
                            fontFamily: widget.effectiveFontFamily,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                Center(
                  child: widget.version?.isNotEmpty ?? false ?
                    InkWell(
                      onTap: () {
                        widget.openPlayStore?.call();
                      },
                      child: Text(
                        'Version: ${widget.version}',
                        style: getText(
                          fontSize: 12, 
                          color: widget.textColor.withValues(alpha: 0.6),
                          fontFamily: widget.effectiveFontFamily,
                        ),
                      ),
                    ) : null,
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
