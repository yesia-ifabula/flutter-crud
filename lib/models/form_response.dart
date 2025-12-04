class FormResponse {
  String? status;
  String? message;
  Data? data;

  FormResponse({this.status, this.message, this.data});

  FormResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class Data {
  int? userId;
  String? name;
  int? stock;
  String? imageBase64;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.userId,
        this.name,
        this.stock,
        this.imageBase64,
        this.updatedAt,
        this.createdAt,
        this.id});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    stock = json['stock'];
    imageBase64 = json['image_base64'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }
  
}