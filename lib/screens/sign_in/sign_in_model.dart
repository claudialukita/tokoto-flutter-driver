class SignInModel{
  final String login;
  final String password;

  SignInModel(this.login, this.password);

  Map<String, dynamic> toJson() => {
    'login': login,
    'password': password,
  };
}