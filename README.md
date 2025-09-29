# Org Auth UI Dev

A comprehensive Flutter authentication package providing ready-to-use UI components for sign-in, sign-up, and OTP verification flows with a clean, modern design.

## Features

- 🚀 **SignInPage**: Complete sign-in screen with email/phone and OTP verification
- 📝 **SignUpPage**: Comprehensive registration form with KYC validation
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

dependency_overrides: # if you need to override intl version
  intl: ^0.20.2 # if you need to override intl version
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

#### Basic OrgAuthProvider Implementation

Here's a basic implementation of `OrgAuthProvider` that you can adapt for your app:

```dart
class OrgAuthProvider extends ChangeNotifier {
  bool _signInLoading = false;
  bool _verifyLoading = false;
  bool _isResending = false;
  
  bool get signInLoading => _signInLoading;
  bool get verifyLoading => _verifyLoading;
  bool get isResending => _isResending;
  
  // Handle sign-in logic
  Future<bool> signIn(String userId, {String? password}) async {
    _signInLoading = true;
    notifyListeners();
    
    try {
      // Call your authentication API here
      // Example:
      // final response = await ApiService.signIn(userId, password);
      // return response.success;
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      _signInLoading = false;
      notifyListeners();
      return true; // Return true if successful
    } catch (e) {
      _signInLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  // Handle OTP verification
  Future<bool> otpVerify(String userId, String otp, String session) async {
    _verifyLoading = true;
    notifyListeners();
    
    try {
      // Call your OTP verification API here
      // Example:
      // final response = await ApiService.verifyOtp(userId, otp, session);
      // return response.success;
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      _verifyLoading = false;
      notifyListeners();
      return true; // Return true if OTP is valid
    } catch (e) {
      _verifyLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  // Handle OTP resend
  Future<void> resendOtp(String userId, String session) async {
    _isResending = true;
    notifyListeners();
    
    try {
      // Call your OTP resend API here
      // Example:
      // await ApiService.resendOtp(userId, session);
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      _isResending = false;
      notifyListeners();
    } catch (e) {
      _isResending = false;
      notifyListeners();
    }
  }
  
  // Handle user registration
  Future<bool> registerUser(SignUpData signUpData) async {
    _signInLoading = true;
    notifyListeners();
    
    try {
      // Call your registration API here
      // Example:
      // final response = await ApiService.registerUser(signUpData);
      // return response.success;
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      _signInLoading = false;
      notifyListeners();
      return true; // Return true if registration is successful
    } catch (e) {
      _signInLoading = false;
      notifyListeners();
      return false;
    }
  }
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
          
          try {
            final success = await auth.signIn(userId, password: password);
            if (success) {
              // Sign-in successful, OTP will be sent
              // When useOrgAuthRoute is true, navigation to OTP page is automatic
              // When useOrgAuthRoute is false (default), you need to handle navigation manually
              if (!useOrgAuthRoute) {
                // Manual navigation when useOrgAuthRoute is false
                // The session ID should be returned from your signIn API
                final sessionId = "your_session_id_from_api"; // Get from API response
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VerifyOtpPage(
                      userId: userId,
                      session: sessionId,
                      userStatus: 1, // User status from API
                      onVerifyOtp: auth.otpVerify,
                      onResendOtp: auth.resendOtp,
                      verifyLoading: auth.verifyLoading,
                      isResending: auth.isResending,
                    ),
                  ),
                );
              }
            } else {
              // Handle sign-in failure
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sign-in failed. Please try again.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          } catch (e) {
            // Handle API errors
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        onVerifyOtp: (userId, otp, session) async {
          // Handle OTP verification
          // The 'session' parameter is a unique identifier for the OTP session
          // It's typically returned by your sign-in API when OTP is sent
          try {
            final success = await auth.otpVerify(userId, otp, session);
            if (success) {
              // Navigate to home screen on success
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/home');
              }
            } else {
              // Handle OTP verification failure
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Invalid OTP. Please try again.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
            return success;
          } catch (e) {
            // Handle API errors
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Verification error: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
            return false;
          }
        },
        onResendOtp: (userId, session) async {
          // Handle OTP resend
          // The 'session' parameter should be the same session from initial sign-in
          try {
            await auth.resendOtp(userId, session);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('OTP resent successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } catch (e) {
            // Handle resend errors
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to resend OTP: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        onSuccessOTP: () {
          // Handle successful OTP verification
          // This is called when OTP verification is successful
          // and useOrgAuthRoute is true (automatic routing)
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        onSignUpSubmit: (signUpData) async {
          // Handle sign-up submission
          print('Name: ${signUpData.name}');
          print('User ID: ${signUpData.userId}');
          print('KYC Type: ${signUpData.kycType}');
          print('KYC Data: ${signUpData.kycData}');
          print('Date of Birth: ${signUpData.dob}');
          if (signUpData.password != null) {
            print('Password: ${signUpData.password}');
          }
          
          try {
            // Call your registration API here
            final success = await auth.registerUser(signUpData);
            if (success) {
              // Handle successful registration
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Registration successful!'),
                    backgroundColor: Colors.green,
                  ),
                );
                // Navigate to sign-in or home screen
                Navigator.pushReplacementNamed(context, '/signin');
              }
            } else {
              // Handle registration failure
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Registration failed. Please try again.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          } catch (e) {
            // Handle API errors
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Registration error: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        signUpLoading: ValueNotifier<bool>(false),
        useOrgAuthRoute: true, // Enable automatic routing within the package
        openPlayStore: () {
          // Handle app store redirection
          // launch('market://details?id=your.package.name');
        },
      ),
    );
  }
}
```

#### Session Management Explained

The `session` parameter in OTP callbacks is a unique identifier that links the OTP verification to the initial sign-in request. Here's how it typically works:

1. **When user signs in**: Your API returns a session ID along with the success response
2. **Session storage**: Store this session ID (it can be a string, UUID, or any unique identifier)
3. **OTP verification**: Pass the same session ID when verifying the OTP
4. **Security**: The session ensures that OTP can only be used with the original sign-in request
5. **Expiration**: Sessions typically expire after a certain time (e.g., 5-15 minutes)

**Example Session Flow:**
```dart
// In your signIn API response
// {
//   "success": true,
//   "session": "abc123-def456-ghi789", // Unique session ID
//   "message": "OTP sent successfully"
// }

// Store the session and pass it to OTP verification
final sessionId = response['session'];
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => VerifyOtpPage(
      userId: userId,
      session: sessionId, // Use the session from API
      // ... other parameters
    ),
  ),
);
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
- **KYC validation**: Comprehensive NRC and passport validation

### Sign-Up Form Validation

The SignUpPage includes extensive validation for all registration fields. Here's a quick overview of what's required:

#### 🚀 Quick Start: Minimum Requirements

For a quick implementation, users need to provide:
1. **Name** - Any text (cannot be empty)
2. **Email OR Phone** - Based on toggle selection
3. **NRC OR Passport** - Choose one KYC type
4. **Date of Birth** - Must be selected from date picker

The "Continue" button is only enabled when all required fields are valid.

#### Required Fields
All users must provide:
- **Name**: Full name (cannot be empty)
- **Contact**: Email OR phone number (based on toggle selection)
- **KYC Information**: NRC (complete) OR passport number
- **Date of Birth**: Must be selected

#### NRC Validation
For NRC-type KYC, the following are validated:
- **NRC Prefix**: Must be selected from available prefixes
- **NRC Region**: Must be selected from regions corresponding to the prefix
- **NRC Postfix**: Must be selected from available postfixes
- **NRC Number**: Must be exactly 6 digits, numbers only

**NRC Number Format Requirements:**
- Exactly 6 digits (no more, no less)
- Numbers only (no letters, symbols, or spaces)
- Example: `123456`

#### Passport Validation
For passport-type KYC:
- **Passport Number**: Must follow specific format pattern

**Passport Number Format Requirements:**
- Starts with one uppercase letter
- Second character is digit 1-9 (not 0)
- Third character is digit 0-9
- Optional space allowed
- Next four characters are digits 0-9
- Last character is digit 1-9 (not 0)

**Valid Examples:**
- `A1234567` (without space)
- `A12 34567` (with space)
- `B9876543` (without space)
- `B98 76543` (with space)

**Invalid Examples:**
- `a1234567` (lowercase letter)
- `A0234567` (second digit is 0)
- `A1234560` (last digit is 0)
- `A123456` (too short)
- `A12345678` (too long)
- `AB234567` (two letters)

#### Real-time Validation
The form validates fields in real-time:
- All field changes trigger immediate validation
- The "Continue" button is only enabled when all required fields are valid
- Validation errors are displayed with clear, user-friendly messages
- KYC type switching (NRC vs Passport) triggers appropriate validation updates

#### Validation Error Messages
Common validation messages include:
- `"Required"` - For empty required fields
- `"NRC number must be exactly 6 digits"` - For invalid NRC format
- `"Invalid passport number format"` - For invalid passport format
- `"Please enter a valid phone number"` - For invalid phone format
- `"Please enter a valid email address"` - For invalid email format

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

The main authentication flow widget that handles sign-in, sign-up, and OTP verification with automatic routing capabilities.

#### Properties

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `logoAsset` | String | ✅ | Path to your app's logo (supports SVG, PNG, JPG) |
| `onSubmit` | Function | ✅ | Callback when user submits their ID (email/phone) |
| `onVerifyOtp` | Function | ✅ | Callback to verify OTP with signature: `Future<void> Function(String userId, String otp, String session)` |
| `onResendOtp` | Function | ✅ | Callback to resend OTP with signature: `Future<void> Function(String userId, String session)` |
| `onSuccessOTP` | VoidCallback | ✅ | Callback when OTP verification is successful |
| `onSignUpSubmit` | Function | ✅ | Callback for sign-up submission with signature: `Future<void> Function(SignUpData signUpData)` |
| `signInType` | SignInType | ✅ | Type of sign-in (`phoneEmailOTP`, `phoneOTP`, `emailOTP`, `phonePassword`, `emailPassword`) |
| `signInLoading` | ValueNotifier<bool> | ✅ | Loading state for sign-in button |
| `isResending` | bool | ✅ | Loading state for resend OTP button |
| `verifyLoading` | bool | ✅ | Loading state for verify OTP button |
| `signUpLoading` | ValueNotifier<bool> | ✅ | Loading state for sign-up button |
| `useOrgAuthRoute` | bool | ❌ | Enable automatic routing within package (default: false) |
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

### SignUpPage

A comprehensive registration form with KYC (Know Your Customer) validation, supporting both NRC (National Registration Card) and passport verification.

#### Properties

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `logoAsset` | String | ✅ | Path to your app's logo |
| `primaryColor` | Color | ❌ | Primary color for buttons and highlights (default: Colors.blue) |
| `backgroundColor` | Color | ❌ | Background color of the screen (default: Colors.white) |
| `textColor` | Color | ❌ | Color for text elements (default: Colors.black87) |
| `authFontFamily` | AuthFontFamily | ❌ | Font family for typography (default: system font) |
| `fontFamily` | String | ❌ | Custom font family name (fallback) |
| `onSubmit` | Function | ✅ | Callback when user submits registration with signature: `Future<void> Function(SignUpData signUpData)` |
| `onBack` | VoidCallback | ❌ | Callback when user taps back button |
| `signInType` | SignInType | ❌ | Type of sign-in (affects contact field options) |
| `version` | String | ❌ | App version to display (default: '1.0.0') |
| `signUpLoading` | ValueNotifier<bool> | ✅ | Loading state for sign-up button |
| `onTermsAndConditions` | VoidCallback | ❌ | Callback when user taps terms and conditions link |
| `openPlayStore` | VoidCallback | ❌ | Callback when user taps update app button |

#### SignUpData Model

The `onSubmit` callback receives a `SignUpData` object containing all registration information:

```dart
class SignUpData {
  final String name;        // User's full name
  final String userId;      // Email or phone number
  final String kycType;     // 'nrc' or 'passport'
  final Map<String, String> kycData; // KYC-specific data
  final DateTime dob;       // Date of birth
  final String? password;   // Optional password (for password-based flows)
}
```

#### KYC Data Structure

The `kycData` map contains different fields based on the KYC type:

**For NRC Type:**
```dart
{
  'prefix': '1/',          // NRC prefix (e.g., '1/', '2/', etc.)
  'region': 'AHGAYA',      // NRC region/township
  'postfix': '(N)',        // NRC postfix (e.g., '(N)', '(P)', etc.)
  'number': '123456'       // 6-digit NRC number
}
```

**For Passport Type:**
```dart
{
  'passportNumber': 'A1234567'  // Passport number
}
```

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
