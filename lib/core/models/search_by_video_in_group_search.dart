import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

class SearchByVideoInGroupSearch extends Equatable {
  bool? found;
  List<String>? data;
  List<Dataaa>? dataCards;

  List<String>? snapshot_list;

  SearchByVideoInGroupSearch(
      {
      // this.data,

      this.found,
      this.data,
      this.snapshot_list});

  SearchByVideoInGroupSearch.fromJson(Map<String, dynamic> json) {
    found = json['Found'];
    data = json['data'].cast<String>();

    if (json['data_cards'] != []) {
      dataCards = <Dataaa>[];
      json['data_cards'].forEach((v) {
        dataCards?.add(Dataaa.fromJson(v));
      });
    }
    snapshot_list = json['snapshot_list'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.dataCards != null) {
      data['data_cards'] = this.dataCards!.map((v) => v.toJson()).toList();
    }
    data['Found'] = found;
    data['data'] = this.data;
    data['snapshot_list'] = snapshot_list;
    return data;
  }

  @override
  List<Object?> get props => [data, found, snapshot_list];
}

class Dataaa {
  String? sId;
  String? email;
  String? imagePath;
  String? name;
  String? phone;
  String? userId;
  String? blackListed;

  Dataaa(
      {this.sId,
      this.blackListed,
      this.email,
      this.imagePath,
      this.name,
      this.phone,
      this.userId});

  Dataaa.fromJson(Map<String, dynamic> json) {
    blackListed = json['blacklisted'];
    sId = json['_id'];
    email = json['email'];
    imagePath = json['image_path'];
    name = json['name'];
    phone = json['phone'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['blacklisted'] = blackListed;
    data['_id'] = sId;
    data['email'] = email;
    data['image_path'] = imagePath;
    data['name'] = name;
    data['phone'] = phone;
    data['user_id'] = userId;
    return data;
  }
}
