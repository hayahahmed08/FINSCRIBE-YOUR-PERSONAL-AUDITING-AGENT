class SignupResponseModel {
  String? accessToken;
  String? tokenType;

  SignupResponseModel({this.accessToken, this.tokenType});

  SignupResponseModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    return data;
  }
}
