class SignUpData {
  final String name;
  final String userId;
  final String kycType;
  final Map<String, String> kycData;
  final DateTime dob;
  final String? password;

  SignUpData({
    required this.name,
    required this.userId,
    required this.kycType,
    required this.kycData,
    required this.dob,
    this.password,
  });

  @override
  String toString() {
    return 'SignUpData(name: $name, userId: $userId, kycType: $kycType, kycData: $kycData, dob: $dob, password: ${password != null ? '***' : 'null'})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is SignUpData &&
      other.name == name &&
      other.userId == userId &&
      other.kycType == kycType &&
      other.kycData.toString() == kycData.toString() &&
      other.dob == dob &&
      other.password == password;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      name,
      userId,
      kycType,
      kycData,
      dob,
      password,
    ]);
  }
}
