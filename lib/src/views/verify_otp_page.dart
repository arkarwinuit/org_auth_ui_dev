import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyOtpPage extends StatefulWidget {
  static const routeName = '/org-verify-otp';
  
  final String session;
  final String userId;
  final int userStatus;
  final String logoAsset;
  final String version;
  final ValueListenable<bool> verifyLoading;
  final ValueListenable<bool> isResending;
  final String? errorMessage;
  final Future<bool> Function(String userId, String otp, String session) onVerifyOtp;
  final Future<void> Function(String userId, String session) onResendOtp;
  final VoidCallback onSuccessOTP;
  final Color backgroundColor;
  final Color textColor;
  final Color primaryColor;

  const VerifyOtpPage({
    super.key,
    required this.session,
    required this.userId,
    required this.userStatus,
    required this.logoAsset,
    required this.onVerifyOtp,
    required this.onResendOtp,
    required this.onSuccessOTP,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.primaryColor = Colors.blue,
    this.version = '1.0.0',
    required this.verifyLoading,
    required this.isResending,
    this.errorMessage,
  });

  static Map<String, dynamic> createArguments({
    required String userId,
    required String session,
    required int userStatus,
    required String logoAsset,
    String version = '1.0.0',
    required ValueListenable<bool> isResending,
    String? errorMessage,
  }) {
    return {
      'userId': userId,
      'session': session,
      'userStatus': userStatus,
      'logoAsset': logoAsset,
      'version': version,
      'isResending': isResending.value,
      if (errorMessage != null) 'errorMessage': errorMessage,
    };
  }

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final TextEditingController _otpCodeController = TextEditingController();

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // _errorMessage = widget.errorMessage;
    // print(widget.errorMessage);
    // Auto-focus the OTP field when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });
  }

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    // _otpCodeController.dispose();
    super.dispose();
  }

  // Helper method to create the OTP input field
  Widget _buildOtpInput() {
    return PinCodeTextField(
      appContext: context,
      controller: _otpCodeController,
      length: 6,
      keyboardType: TextInputType.number,
      cursorColor: Theme.of(context).primaryColor,
      textStyle: TextStyle(color: widget.textColor, fontSize: 18),
      enableActiveFill: true,
      onChanged: (value) async {
        if (_errorMessage != null) {
          setState(() {
            _errorMessage = null;
          });
        }
      },
      pinTheme: PinTheme(
        fieldHeight: 56,
        fieldWidth: 46,
        activeColor: Colors.grey[300]!,
        selectedColor: Theme.of(context).primaryColor,
        inactiveColor: Colors.grey[300]!,
        activeFillColor: widget.backgroundColor,
        inactiveFillColor: widget.backgroundColor,
        selectedFillColor: widget.backgroundColor,
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(8),
        borderWidth: 1,
        fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 4),
      ),
      onCompleted: (value) async {
        if (!_isDisposed) {
          try {
            final success = await widget.onVerifyOtp(widget.userId, value, widget.session);
            if (success) {
              widget.onSuccessOTP();
            } else {
              setState(() {
                _errorMessage = "Invalid OTP. Please try again.";
              });
            }
          } catch (e) {
            setState(() {
              _errorMessage = "Something went wrong. Please try again.";
            });
          }
        } 
      },
    );
  }

  // Helper method to create the resend button
  Widget _buildResendButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.isResending,
      builder: (context, isResending, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Didn't receive the code? ",
              style: TextStyle(color: widget.textColor.withValues(alpha: 0.5), fontSize: 14),
            ),
            TextButton(
              onPressed: isResending ? null : ()
              {
                widget.onResendOtp(widget.userId, widget.session);
                _otpCodeController.clear();
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: isResending
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(widget.primaryColor),
                      ),
                    )
                  : Text(
                      "Resend",
                      style: TextStyle(
                        color: widget.primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEmail = widget.userId.contains('@');

    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: widget.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: widget.backgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(
                        widget.logoAsset,
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    isEmail 
                        ? 'Enter the 6-digit code we sent to your email address'
                        : 'Enter the 6-digit code we sent to your mobile number',
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: 16,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatPhoneNumber(widget.userId),
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const SizedBox(height: 24),
                _buildOtpInput(),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 12),
                _buildResendButton(),
                const SizedBox(height: 16),
                ValueListenableBuilder<bool>(
                  valueListenable: widget.verifyLoading,
                  builder: (context, verifyLoading, _) {
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: verifyLoading ? null : () async {
                          if (_otpCodeController.text.isEmpty) {
                            setState(() {
                              _errorMessage = "OTP is required";
                            });
                            return;
                          }
                          if (_otpCodeController.text.length < 6) {
                            setState(() {
                              _errorMessage = "OTP must be 6 digits";
                            });
                            return;
                          }
                          try {
                            final success = await widget.onVerifyOtp(widget.userId, _otpCodeController.text, widget.session);

                            if (success) {
                              widget.onSuccessOTP();
                            } else {
                              setState(() {
                                _errorMessage = "Invalid OTP. Please try again.";
                              });
                            }
                          } catch (e) {
                            setState(() {
                              _errorMessage = "Something went wrong. Please try again.";
                            });
                          }
                          _otpCodeController.clear();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: verifyLoading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(widget.textColor),
                                ),
                              )
                            : Text(
                                'Confirm OTP',
                                style: TextStyle(
                                  color: widget.primaryColor != Colors.white ? Colors.white : widget.textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 80),
                Center(
                  child: Text(
                    'Version ${widget.version}',
                    style: TextStyle(
                      color: widget.textColor.withValues(alpha: 0.5),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],)
            ),
          ),
        ),
      )
    );
  }

  String _formatPhoneNumber(String phone) {
    // Format phone number for display
    if (phone.length == 11 && phone.startsWith('09')) {
      return '+95 ${phone.substring(1, 4)} ${phone.substring(4, 7)} ${phone.substring(7)}';
    } else if (phone.contains('@')) {
      // For email, just return as is
      return phone;
    }
    return phone;
  }
}
