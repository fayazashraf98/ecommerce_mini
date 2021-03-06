class SignupResponse {
  String? message;
  int? statusCode;
  SignupData? data;

  SignupResponse({this.message, this.statusCode, this.data});

  SignupResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? new SignupData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['statusCode'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class SignupData {
  int? id;
  String? email;
  String? phone;
  String? password;
  String? accessToken;

  SignupData({this.id, this.email, this.phone, this.password, this.accessToken});

  SignupData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['accessToken'] = this.accessToken;
    return data;
  }
}
