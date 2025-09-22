class SignInResponse{
  bool isSuccess;
  String userId;
  String session;
  int userStatus;

  SignInResponse({
    required this.isSuccess,
    required this.userId,
    required this.session,
    required this.userStatus
  });
}