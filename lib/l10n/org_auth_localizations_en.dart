// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'org_auth_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class OrgAuthLocalizationsEn extends OrgAuthLocalizations {
  OrgAuthLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get signInTitle => 'Sign In';

  @override
  String get signInSubTitle => 'Please enter your details below to continue';

  @override
  String get phoneNumberLabel => 'Phone Number';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get signInButton => 'Continue';

  @override
  String get signUpButton => 'Sign Up';

  @override
  String get haveNoAccount => 'Don\'t have an account? | ';

  @override
  String get or => 'or';

  @override
  String get signInWithPhone => 'Sign In With Phone Number';

  @override
  String get signInWithEmail => 'Sign In With Email';

  @override
  String get phoneempty => 'Phone Number cannot be empty';

  @override
  String get phoneinvalid => 'Phone Number is invalid';

  @override
  String get emailempty => 'Email cannot be empty';

  @override
  String get emailinvalid => 'Email is invalid';

  @override
  String get passwordempty => 'Password cannot be empty';

  @override
  String get passwordinvalid => 'Password is invalid';
}
