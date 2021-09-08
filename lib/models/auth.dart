class Auth{
  final String username;
  final String accessToken;
  final String refreshToken;

  Auth(this.username, this.accessToken, this.refreshToken);

  Auth.fromJson(Map<String, dynamic> json)
      : username = json["userName"],
        accessToken = json["accessToken"],
        refreshToken = json["refreshToken"];
}