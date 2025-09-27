import 'package:flutter/material.dart';
import 'package:org_auth_ui_dev/org_auth_ui_dev.dart';

class FontFamilyUsageExample extends StatelessWidget {
  const FontFamilyUsageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Font Family Usage Examples'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('1. Using Predefined Font Families'),
            _buildPredefinedFontExample(context),
            const SizedBox(height: 32),
            
            _buildSectionTitle('2. Using Custom Font Family'),
            _buildCustomFontExample(context),
            const SizedBox(height: 32),
            
            _buildSectionTitle('3. Available Font Families'),
            _buildFontFamilyList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildPredefinedFontExample(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Example with Inter font:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '''OrgAuthFlow(
                  authFontFamily: AuthFontFamily.inter,
                  primaryColor: Colors.blue,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  // ... other required parameters
                )''',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to auth flow with Inter font
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrgAuthFlow(
                      authFontFamily: AuthFontFamily.inter,
                      primaryColor: Colors.blue,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      logoAsset: 'assets/logo.png',
                      onSubmit: (userId, {password}) async {
                        return SignInResponse(isSuccess: true, userId: userId, session: 'session', userStatus: 0);
                      },
                      version: '1.0.0',
                      openPlayStore: () {},
                      signInType: SignInType.emailPassword,
                      signInLoading: ValueNotifier<bool>(false),
                      isResending: ValueNotifier<bool>(false),
                      verifyLoading: ValueNotifier<bool>(false),
                      onVerifyOtp: (userId, otp, session) async => true,
                      onResendOtp: (userId, session) async {},
                      onSuccessOTP: () {}, onSignUpSubmit: (signUpData) async {
                        return true;
                      },
                      signUpLoading: ValueNotifier<bool>(false),
                    ),
                  ),
                );
              },
              child: const Text('Try Inter Font'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomFontExample(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Example with custom font:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '''OrgAuthFlow(
                  authFontFamily: AuthFontFamily.roboto,
                  primaryColor: Colors.blue,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  // ... other required parameters
                )''',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to auth flow with custom font
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrgAuthFlow(
                      authFontFamily: AuthFontFamily.roboto, // Custom font name
                      primaryColor: Colors.green,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      logoAsset: 'assets/logo.png',
                      onSubmit: (userId, {password}) async {
                        return SignInResponse(isSuccess: true, userId: userId, session: 'session', userStatus: 0);
                      },
                      version: '1.0.0',
                      openPlayStore: () {},
                      signInType: SignInType.emailPassword,
                      signInLoading: ValueNotifier<bool>(false),
                      isResending: ValueNotifier<bool>(false),
                      verifyLoading: ValueNotifier<bool>(false),
                      onVerifyOtp: (userId, otp, session) async => true,
                      onResendOtp: (userId, session) async {},
                      onSuccessOTP: () {}, onSignUpSubmit: (signUpData) async {
                        return true;
                      },
                      signUpLoading: ValueNotifier<bool>(false),
                    ),
                  ),
                );
              },
              child: const Text('Try Custom Font'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFontFamilyList() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available predefined font families:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...AuthFontFamily.values.map((fontFamily) {
              if (fontFamily == AuthFontFamily.custom) return const SizedBox.shrink();
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  children: [
                    Text(
                      '• ${fontFamily.name}: ',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text('"${fontFamily.fontFamily}"'),
                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}

/// Extension to provide easy access to font family usage
extension AuthFontFamilyExtension on AuthFontFamily {
  /// Get a description of the font family
  String get description {
    switch (this) {
      case AuthFontFamily.inter:
        return 'Modern, clean font suitable for minimalist designs';
      case AuthFontFamily.ubuntu:
        return 'Friendly, rounded font with great readability';
      case AuthFontFamily.helveticaNeue:
        return 'Classic, professional font for corporate apps';
      case AuthFontFamily.roboto:
        return 'Android default font, versatile and widely supported';
      case AuthFontFamily.openSans:
        return 'Neutral, highly readable font for content-heavy apps';
      case AuthFontFamily.lato:
        return 'Elegant, warm font with friendly appearance';
      case AuthFontFamily.montserrat:
        return 'Geometric, modern font for contemporary designs';
      case AuthFontFamily.poppins:
        return 'Geometric, friendly font with excellent legibility';
      case AuthFontFamily.nunito:
        return 'Rounded, friendly font perfect for casual apps';
      case AuthFontFamily.custom:
        return 'Custom font family - specify your own font name';
    }
  }
}
