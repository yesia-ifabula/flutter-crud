class AuthRequest {
  String? name;
  String? email;
  String? password;
  String? passwordConfirmation;

  AuthRequest(
      {
        this.name = '',
        this.email = '',
        this.password = '',
        this.passwordConfirmation = ''
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['password_confirmation'] = passwordConfirmation;
    return data;
  }
}