class ValidationKeys {
  static const String vehicleNO = 'vehicleNO';
  static const String vehicleName = 'vehicleName';
  static const String useridmobile = 'Useridmobile';
  static const String confirm = 'confirm';
  static const String unconfirm = 'unconfirm';
  static const String username = 'Username';
  static const String password = 'Password';
  static const String userid = 'Userid';
  static const String signinuserid = 'singinUserid';
  static const String signinpw     = 'singinpw';
  static const String signupfirstname = 'signupfirstname';
  static const String signuplastname = 'signuplastname';
  static const String email = 'email';
}

String? validateField(String? value, String validateKey) {
  final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+', caseSensitive: false);
  final phoneRegExp = RegExp(r'^(?:\+?959|09)\d{7,9}$');
  final nvalue = value?.trim();
  
  // Convert to lowercase for case-insensitive comparison
  final lowerKey = validateKey.toLowerCase();
  
  if (lowerKey == ValidationKeys.vehicleNO.toLowerCase()) {
    return nvalue?.isEmpty ?? true ? 'Empty Vehicle Name' : null;
  } 
  if (lowerKey == ValidationKeys.vehicleName.toLowerCase()) {
    return nvalue?.isEmpty ?? true ? 'Empty Vehicle NO.' : null;
  } 
  if (lowerKey == ValidationKeys.signinuserid.toLowerCase()) {
    return nvalue?.isEmpty ?? true ? 'Invalid User ID' : null;
  } 
  if (lowerKey == ValidationKeys.signinpw.toLowerCase()) {
    return value?.isEmpty ?? true ? 'Invalid Password' : null;
  } 
  if (lowerKey == ValidationKeys.confirm.toLowerCase()) {
    return value?.isEmpty ?? true ? 'Invalid Password' : null;
  } 
  if (lowerKey == ValidationKeys.unconfirm.toLowerCase()) {
    return 'Invalid Password';
  } 
  if (lowerKey == ValidationKeys.username.toLowerCase()) {
    return nvalue?.isEmpty ?? true ? 'Invalid User Name' : null;
  } 
  if (lowerKey == ValidationKeys.password.toLowerCase()) {
    if (value?.isEmpty ?? true) return 'Invalid Password';
    if (value!.length < 8) return 'Enter at least 8 characters';
    return null;
  } 
  if (lowerKey == ValidationKeys.userid.toLowerCase()) {
    if (nvalue == null || nvalue.isEmpty || 
        !nvalue.startsWith(RegExp(r'^[a-zA-Z]')) || 
        !emailRegex.hasMatch(nvalue)) {
      return 'Invalid User ID';
    }
    return null;
  } 
  if (lowerKey == ValidationKeys.useridmobile.toLowerCase()) {
    if (nvalue == null || nvalue.isEmpty) {
      return 'Invalid User ID';
    }
    if (nvalue.startsWith(RegExp(r'^[a-zA-Z]'))) {
      if (!emailRegex.hasMatch(nvalue)) {
        return 'Invalid User ID';
      }
    } else if (!phoneRegExp.hasMatch(nvalue)) {
      return 'Invalid User ID';
    }
    return null;
  }
  if (lowerKey == ValidationKeys.signupfirstname.toLowerCase()) {
    return value?.isEmpty ?? true ? 'Please enter your first name.' : null;
  }
  if (lowerKey == ValidationKeys.signuplastname.toLowerCase()) {
    return value?.isEmpty ?? true ? 'Please enter your last name.' : null;
  }
  if (lowerKey == ValidationKeys.email.toLowerCase()) {
    if (value?.isEmpty ?? true) return 'Please enter your email address';
    if (!emailRegex.hasMatch(value!)) return 'Please enter a valid email address';
    return null;
  }
  
  return null;
}
