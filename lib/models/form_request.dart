class FormRequest {
  int? id;
  String? name;
  num? stock;
  String? imageBase64;

  FormRequest({this.id = 0, this.name, this.stock, this.imageBase64});

  FormRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    stock = json['stock'];
    imageBase64 = json['image_base64'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['stock'] = stock;
    data['image_base64'] = imageBase64;
    return data;
  }
  
}