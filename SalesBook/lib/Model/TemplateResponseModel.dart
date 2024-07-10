class TemplateRequestModel {
  String? label;
  String? templateData;

  TemplateRequestModel({this.label, this.templateData});

  TemplateRequestModel.fromJson(Map<String, dynamic> json) {
    label = json['Label'];
    templateData = json['templateData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Label'] = this.label;
    data['templateData'] = this.templateData;
    return data;
  }
}

class TemplateResponseModel {
  String? id;
  String? label;
  String? templateData;

  TemplateResponseModel({this.label, this.templateData, this.id});

  TemplateResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['Label'];
    templateData = json['templateData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Label'] = this.label;
    data['templateData'] = this.templateData;
    return data;
  }
}
