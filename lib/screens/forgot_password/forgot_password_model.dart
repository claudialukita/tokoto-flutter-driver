class ForgotPasswordModel{
  final String email;

  ForgotPasswordModel(this.email);

  Map<String, dynamic> toJson() => {
    'email': email,
  };
}