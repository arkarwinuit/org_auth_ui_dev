# Org Auth UI Dev

A comprehensive Flutter authentication package providing ready-to-use UI components for sign-in, sign-up, and OTP verification flows with a clean, modern design.

## Features

- 🚀 **SignInPage**: Complete sign-in screen with email/phone and OTP verification
- 🔒 **VerifyOtpPage**: Secure OTP verification with auto-submit and resend functionality
- 🎨 **Customizable Themes**: Built-in theming support for brand consistency
- 📱 **Responsive Design**: Works seamlessly on mobile, tablet, and web
- 🔄 **State Management**: Built-in loading and error states
- ✅ **Enhanced Form Validation**: Client-side validation with real-time feedback
- 🔄 **Session Management**: Handles session persistence and token management
- 🔤 **Font Family Support**: Customizable typography with predefined font families
- 🌍 **Localization Support**: Built-in support for multiple languages including Myanmar (မြန်မာ)

## 🚀 Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  org_auth_ui_dev:
    git:
      url: https://github.com/arkarwinuit/org_auth_ui_dev.git
      ref: main  # or specific version tag
```

Or using a local path:

```yaml
dependencies:
  org_auth_ui_dev:
    path: ../path_to_package/org_auth_ui_dev
```

Run `flutter pub get` to install the package.

## 🛠️ Getting Started

### 1. Setup Dependencies

First, ensure you have the required dependencies in your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5  # For state management
```

### 2. Setup Provider

Wrap your app with `ChangeNotifierProvider` to manage authentication state:

```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrgAuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
```

### 3. Implement OrgAuthFlow

Use `OrgAuthFlow` as your main authentication flow component. It handles both sign-in and OTP verification screens:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<OrgAuthProvider>(context);
    
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: OrgAuthFlow(
        logoAsset: 'assets/logo.png',
        version: '1.0.0',
        signInType: SignInType.phoneEmailOTP, // Multiple sign-in options
        primaryColor: Colors.blue,
        backgroundColor: Colors.white,
        textColor: Colors.black87,
        authFontFamily: AuthFontFamily.montserrat, // Custom font family
        signInLoading: auth.signInLoading,
        isResending: auth.isResending,
        verifyLoading: auth.verifyLoading,
        onSubmit: (userId, {password}) async {
          // Handle sign in logic
          // This is called when user submits phone/email
          // You should call your authentication API here
          // and handle the response
          // If you want route to OTP page ()
          // Navigator.push(
          //    context,
          //    MaterialPageRoute(
          //    builder: (context) => VerifyOtpPage(
          //      userId: userId,...
          // )));
        },
        onVerifyOtp: (userId, otp, session) async {
          // Handle OTP verification
          final success = await auth.otpVerify(userId, otp, session);
          if (success) {
            // Navigate to home screen on success
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, '/home');
            }
          }
          return success;
        },
        onResendOtp: (userId, session) async {
          // Handle OTP resend
          await auth.resendOtp(userId, session);
        },
        onSuccessOTP: () {
          // Handle successful OTP verification
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/home');  // If you want to loading page route to loading page
          }
        },
        openPlayStore: () {
          // Handle app store redirection
          // launch('market://details?id=your.package.name');
        },
      ),
    );
  }
}
```

### When logout
```dart
Navigator.of(context).pushNamedAndRemoveUntil(
  OrgAuthFlow.routeName,
  (Route<dynamic> route) => false,  // This removes all previous routes
);
```

### If main app already provides localization and what to use in this package

The app just needs to add your delegate + locales to its MaterialApp. Example:
```dart
MaterialApp(
  localizationsDelegates: const [
    OrgAuthLocalizations.delegate, // 👈 add your package delegate
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: const [
    Locale('en'),
    Locale('es'),
    Locale('mm'),
  ],
  home: const OrgAuthFlow(), // your package entry
);
```

## 🔤 Font Family Support

The package now supports customizable font families to match your app's typography design.

### Using Predefined Font Families

```dart
import 'package:org_auth_ui_dev/org_auth_ui_dev.dart';

OrgAuthFlow(
  authFontFamily: AuthFontFamily.montserrat, // or .inter, .ubuntu, .roboto
  // ... other parameters
)
```

### Using Custom Font Families

```dart
OrgAuthFlow(
  fontFamily: 'MyCustomFont', // Font name from pubspec.yaml
  // ... other parameters
)
```

### Available Predefined Fonts

- `AuthFontFamily.inter` - Clean, modern font
- `AuthFontFamily.montserrat` - Elegant geometric font
- `AuthFontFamily.ubuntu` - Friendly, open-source font
- `AuthFontFamily.roboto` - Default Android font

### Font Priority System

The package uses a priority system for font selection:
1. `authFontFamily` (enum) - Highest priority
2. `fontFamily` (string) - Fallback option
3. System font - Default fallback

## ✅ Form Validation

The package includes comprehensive form validation with customizable error messages.

### Validation Features

- **Real-time validation**: Validates fields as user types (configurable)
- **Custom error messages**: Localized error messages for different languages
- **Phone number validation**: Myanmar phone number format support
- **Email validation**: Standard email format validation
- **Password validation**: Basic password requirements

### Validation Modes

```dart
// Auto-validate on user interaction
autovalidateMode: AutovalidateMode.onUserInteraction,

// Only validate on form submission
autovalidateMode: AutovalidateMode.disabled,
```

### Custom Error Messages

The package supports localized error messages. Add these to your ARB files:

```json
{
  "phoneempty": "Phone Number cannot be empty",
  "phoneinvalid": "Phone Number is invalid",
  "emailempty": "Email cannot be empty",
  "emailinvalid": "Email is invalid",
  "passwordempty": "Password cannot be empty",
  "passwordinvalid": "Password is invalid"
}
```

## 📚 API Reference

### OrgAuthFlow

The main authentication flow widget that handles both sign-in and OTP verification.

#### Properties

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `logoAsset` | String | ✅ | Path to your app's logo (supports SVG, PNG, JPG) |
| `onSubmit` | Function | ✅ | Callback when user submits their ID (email/phone) |
| `onVerifyOtp` | Function | ✅ | Callback to verify OTP with signature: `Future<void> Function(String userId, String otp, String session)` |
| `onResendOtp` | Function | ✅ | Callback to resend OTP with signature: `Future<void> Function(String userId, String session)` |
| `onSuccessOTP` | VoidCallback | ✅ | Callback when OTP verification is successful |
| `signInType` | SignInType | ✅ | Type of sign-in (`phoneEmailOTP`, `phoneOTP`, `emailOTP`, `phonePassword`, `emailPassword`) |
| `signInLoading` | ValueNotifier<bool> | ✅ | Loading state for sign-in button |
| `isResending` | bool | ✅ | Loading state for resend OTP button |
| `verifyLoading` | bool | ✅ | Loading state for verify OTP button |
| `version` | String | ❌ | App version to display (default: '1.0.0') |
| `primaryColor` | Color | ❌ | Primary color for buttons and highlights (default: Colors.blue) |
| `backgroundColor` | Color | ❌ | Background color of the screen (default: Colors.white) |
| `textColor` | Color | ❌ | Color for text elements (default: Colors.black87) |
| `authFontFamily` | AuthFontFamily | ❌ | Font family for typography (default: system font) |
| `openPlayStore` | VoidCallback | ✅ | Callback when user taps on update app button |

### SignInPage

A complete sign-in screen with support for phone/email and OTP verification.

#### Properties

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `logoAsset` | String | ✅ | Path to your app's logo |
| `onSubmit` | Function | ✅ | Callback when user submits their ID |
| `version` | String | ❌ | App version to display (default: '1.0.0') |
| `signInType` | SignInType | ✅ | Type of sign-in (`phoneEmailOTP`, `phoneOTP`, `emailOTP`, `phonePassword`, `emailPassword`) |
| `primaryColor` | Color | ❌ | Primary color for buttons and highlights |
| `backgroundColor` | Color | ❌ | Background color of the screen |
| `textColor` | Color | ❌ | Color for text elements |
| `authFontFamily` | AuthFontFamily | ❌ | Font family for typography |
| `fontFamily` | String | ❌ | Custom font family name (fallback) |
| `onSuccessOTP` | Function | ✅ | Callback when OTP is successfully sent |
| `signInLoading` | ValueNotifier<bool> | ✅ | Loading state for sign-in button |
| `verifyLoading` | bool | ❌ | Loading state for OTP verification |
| `onVerifyOtp` | Function | ✅ | Callback to verify OTP |
| `onResendOtp` | Function | ✅ | Callback to resend OTP |
| `isResending` | bool | ❌ | Loading state for resend OTP button |

### VerifyOtpPage

A reusable OTP verification screen.

#### Properties

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `userId` | String | ✅ | User's email or phone number |
| `session` | String | ✅ | Session ID for verification |
| `userStatus` | int | ✅ | User status code |
| `logoAsset` | String | ✅ | Path to your app's logo |
| `version` | String | ❌ | App version to display (default: '1.0.0') |
| `onVerifyOtp` | Function | ✅ | Callback to verify OTP |
| `onResendOtp` | Function | ✅ | Callback to resend OTP |
| `verifyLoading` | bool | ❌ | Loading state for verify button |
| `isResending` | bool | ❌ | Loading state for resend button |
| `errorMessage` | String? | ❌ | Error message to display |
| `primaryColor` | Color | ❌ | Primary color for buttons |
| `backgroundColor` | Color | ❌ | Background color |
| `textColor` | Color | ❌ | Text color |

## 🚀 Example Project

Check out the [example](example/) directory for a complete implementation.

## 🤝 Contributing

Contributions are welcome! Please read our [contributing guidelines](CONTRIBUTING.md) before submitting a pull request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Maintainers

- [Arkar Win](https://github.com/arkarwinuit)

## 🙌 Acknowledgments

- Flutter Team for the amazing framework
- All contributors who helped improve this package

---

Made with ❤️ by [MIT](https://mit.com)
