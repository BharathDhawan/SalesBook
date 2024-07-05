class TemplateResponseModel {
  int? id;
  String? name;
  String? templateData;

  TemplateResponseModel({this.name, this.templateData});

  TemplateResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Label'];
    templateData = json['templateData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Label'] = this.name;
    data['templateData'] = this.templateData;
    return data;
  }
}
