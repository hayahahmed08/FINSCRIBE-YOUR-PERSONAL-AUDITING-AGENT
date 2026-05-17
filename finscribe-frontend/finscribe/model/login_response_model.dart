class LoginResponseModel{
  String? accessToken;
  String? tokenType;

  LoginResponseModel({this.accessToken, this.tokenType});

  LoginResponseModel.fromJson(Map<String, dynamic>json){
    accessToken = json['access_token'];
    tokenType = json['token_type'];
  }

  Map<String, dynamic>toJson(){
    final Map<String, dynamic>data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    return data;
  }

}