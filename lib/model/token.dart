class Token {
  String access;
  String id;

  Token.fromMap(Map json) {
    access = json['access_token'];
    id = json['user_id'].toString();
  }
}