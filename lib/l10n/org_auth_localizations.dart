import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'org_auth_localizations_en.dart';
import 'org_auth_localizations_my.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of OrgAuthLocalizations
/// returned by `OrgAuthLocalizations.of(context)`.
///
/// Applications need to include `OrgAuthLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/org_auth_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: OrgAuthLocalizations.localizationsDelegates,
///   supportedLocales: OrgAuthLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the OrgAuthLocalizations.supportedLocales
/// property.
abstract class OrgAuthLocalizations {
  OrgAuthLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static OrgAuthLocalizations? of(BuildContext context) {
    return Localizations.of<OrgAuthLocalizations>(context, OrgAuthLocalizations);
  }

  static const LocalizationsDelegate<OrgAuthLocalizations> delegate = _OrgAuthLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('my')
  ];

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInTitle;

  /// No description provided for @signInSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter your details below to continue'**
  String get signInSubTitle;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumberLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @signInButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get signInButton;

  /// No description provided for @signUpButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpButton;

  /// No description provided for @haveNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? | '**
  String get haveNoAccount;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @signInWithPhone.
  ///
  /// In en, this message translates to:
  /// **'Sign In With Phone Number'**
  String get signInWithPhone;

  /// No description provided for @signInWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Sign In With Email'**
  String get signInWithEmail;

  /// No description provided for @phoneempty.
  ///
  /// In en, this message translates to:
  /// **'Phone Number cannot be empty'**
  String get phoneempty;

  /// No description provided for @phoneinvalid.
  ///
  /// In en, this message translates to:
  /// **'Phone Number is invalid'**
  String get phoneinvalid;

  /// No description provided for @emailempty.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be empty'**
  String get emailempty;

  /// No description provided for @emailinvalid.
  ///
  /// In en, this message translates to:
  /// **'Email is invalid'**
  String get emailinvalid;

  /// No description provided for @passwordempty.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty'**
  String get passwordempty;

  /// No description provided for @passwordinvalid.
  ///
  /// In en, this message translates to:
  /// **'Password is invalid'**
  String get passwordinvalid;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get signUpTitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @passportRadio.
  ///
  /// In en, this message translates to:
  /// **'Passport'**
  String get passportRadio;

  /// No description provided for @nrcRadio.
  ///
  /// In en, this message translates to:
  /// **'NRC'**
  String get nrcRadio;

  /// No description provided for @passportLabel.
  ///
  /// In en, this message translates to:
  /// **'Passport Number'**
  String get passportLabel;

  /// No description provided for @nrcLabel.
  ///
  /// In en, this message translates to:
  /// **'NRC Number'**
  String get nrcLabel;

  /// No description provided for @dobLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dobLabel;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @registerWithPhone.
  ///
  /// In en, this message translates to:
  /// **'Register with Phone'**
  String get registerWithPhone;

  /// No description provided for @registerWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Register with Email'**
  String get registerWithEmail;

  /// No description provided for @nameempty.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get nameempty;

  /// No description provided for @nametoolong.
  ///
  /// In en, this message translates to:
  /// **'Name cannot exceed 70 characters'**
  String get nametoolong;

  /// No description provided for @emailtoolong.
  ///
  /// In en, this message translates to:
  /// **'Email cannot exceed 50 characters'**
  String get emailtoolong;

  /// No description provided for @passwordtooshort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordtooshort;

  /// No description provided for @confirmpasswordempty.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmpasswordempty;

  /// No description provided for @passwordmismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordmismatch;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @nrcnumberinvalid.
  ///
  /// In en, this message translates to:
  /// **'NRC number must be exactly 6 digits'**
  String get nrcnumberinvalid;

  /// No description provided for @passportnumberinvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid passport number format'**
  String get passportnumberinvalid;

  /// No description provided for @phoneinvalidshort.
  ///
  /// In en, this message translates to:
  /// **'Please type valid phone number'**
  String get phoneinvalidshort;
}

class _OrgAuthLocalizationsDelegate extends LocalizationsDelegate<OrgAuthLocalizations> {
  const _OrgAuthLocalizationsDelegate();

  @override
  Future<OrgAuthLocalizations> load(Locale locale) {
    return SynchronousFuture<OrgAuthLocalizations>(lookupOrgAuthLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'my'].contains(locale.languageCode);

  @override
  bool shouldReload(_OrgAuthLocalizationsDelegate old) => false;
}

OrgAuthLocalizations lookupOrgAuthLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return OrgAuthLocalizationsEn();
    case 'my': return OrgAuthLocalizationsMy();
  }

  throw FlutterError(
    'OrgAuthLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
