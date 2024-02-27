import 'package:equatable/equatable.dart';

class AddCompanyModel extends Equatable {
  String? companyName;
  // String? sourceType;
  // String? source;

  AddCompanyModel({
    this.companyName,

    // this.sourceType, this.source
  });

  AddCompanyModel.fromJson(Map<String, dynamic> json) {
    companyName = json['companyName'];
    // sourceType = json['sourceType'];
    // source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['companyName'] = companyName;
    // data['sourceType'] = sourceType;
    // data['source'] = source;
    return data;
  }

  @override
  List<Object?> get props => [
        companyName,
        // sourceType,
        // source,
      ];
}
