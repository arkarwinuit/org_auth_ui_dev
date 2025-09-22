import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:org_auth_ui_dev/org_auth_ui_dev.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Org Auth UI Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
      home: const AuthFlowDemo(),
    );
  }
}

class AuthProvider extends ChangeNotifier {
  final bool _isLoading = false;
  String? _errorMessage;
  String _sessionId = 'demo_session_${DateTime.now().millisecondsSinceEpoch}';
  
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get sessionId => _sessionId;
  
  final ValueNotifier<bool> signInLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isResending = ValueNotifier<bool>(false);
  final ValueNotifier<bool> verifyLoading = ValueNotifier<bool>(false);

  Future<SignInResponse> submitAuth(String userId, {String? password}) async {
    signInLoading.value = true;
    _errorMessage = null;
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      final signInResponse = SignInResponse(isSuccess: true, userId: userId, session: _sessionId, userStatus: 0);
      // In a real app, you would call your authentication API here
      // and handle the response
      debugPrint('Submitted auth for: $userId');
      
      return signInResponse;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      signInLoading.value = false;
    }
  }
  
  Future<bool> verifyOtp(String userId, String otp, String session) async {
    verifyLoading.value = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // In a real app, you would verify the OTP with your backend
      debugPrint('Verifying OTP: $otp for user: $userId');
      
      // Simulate successful verification
      return true;
    } catch (e) {
      _errorMessage = 'Failed to verify OTP';
      rethrow;
    } finally {
      verifyLoading.value = false;
      notifyListeners();
    }
  }
  
  Future<void> resendOtp(String userId, String session) async {
    isResending.value = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Generate a new session ID
      _sessionId = 'new_session_${DateTime.now().millisecondsSinceEpoch}';
      
      debugPrint('Resent OTP to: $userId');
    } catch (e) {
      _errorMessage = 'Failed to resend OTP';
      rethrow;
    } finally {
      isResending.value = false;
      notifyListeners();
    }
  }
}

class AuthFlowDemo extends StatelessWidget {
  const AuthFlowDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    
    return Scaffold(
      body: OrgAuthFlow(
        logoAsset: 'assets/logo.png',
        version: '1.0.0',
        signInType: SignInType.phoneEmailOTP, // or SignInType.email
        primaryColor: const Color(0xFF2563EB),
        backgroundColor: Colors.white,
        textColor: Colors.black87,
        signInLoading: auth.signInLoading,
        isResending: auth.isResending,
        verifyLoading: auth.verifyLoading,
        onSubmit: (userId, {password}) => auth.submitAuth(userId, password: password),
        onVerifyOtp: (userId, otp, session) => auth.verifyOtp(userId, otp, session),
        onResendOtp: (userId, session) => auth.resendOtp(userId, session),
        onSuccessOTP: () {
          // Navigate to home screen on successful authentication
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        },
        openPlayStore: () {
          // Handle app store redirection
          debugPrint('Redirecting to app store');
          // launch('market://details?id=your.package.name');
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Successfully Authenticated!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
