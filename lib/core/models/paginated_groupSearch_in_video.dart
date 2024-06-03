import 'package:equatable/equatable.dart';

class PaginatedSearchByVideoInGroupSearch extends Equatable {
  // bool? found;
  // List<String>? data;
  // List<String>? timestamps;
  // String? global_path;
  // int? response_count;
  List<Dataaa>? dataCards;

  int? n_page;
  // int? count;

  // List<String>? snapshot_list;

  PaginatedSearchByVideoInGroupSearch({
    this.n_page,
    this.dataCards,
    // this.count,
    // this.global_path,
    // this.response_count,
    // this.timestamps,
    // this.found,
    // this.data,
    //  this.snapshot_list
  });

  PaginatedSearchByVideoInGroupSearch.fromJson(Map<String, dynamic> json) {
    n_page = json['n_page'];
    // count = json['count'];
    // found = json['Found'];
    // data = json['data'].cast<String>();
    // timestamps = json['timestamps'].cast<String>();
    // global_path = json['global_path'];
    // response_count = json['response_count'];

    if (json['data'] != []) {
      dataCards = <Dataaa>[];
      json['data'].forEach((v) {
        dataCards?.add(Dataaa.fromJson(v));
      });
    }
    // snapshot_list = json['snapshot_list'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (dataCards != null) {
      data['data'] = dataCards!.map((v) => v.toJson()).toList();
    }
    data['n_page'] = n_page;
    // data['count'] = count;
    // data['Found'] = found;
    // data['global_path'] = global_path;
    // data['response_count'] = response_count;

    // data['timestamps'] = timestamps;

    // data['data'] = this.data;
    // data['snapshot_list'] = snapshot_list;
    return data;
  }

  @override
  List<Object?> get props => [
        n_page, dataCards,
        // global_path, response_count, data, found,
        //  snapshot_list,
        // timestamps
      ];
}

class Dataaa {
  String? sId;
  String? email;
  String? imagePath;
  String? name;
  String? phone;
  String? userId;
  String? blackListed;
  List<String>? roomsAccesseble;

  Dataaa(
      {this.roomsAccesseble,
      this.sId,
      this.blackListed,
      this.email,
      this.imagePath,
      this.name,
      this.phone,
      this.userId});

  Dataaa.fromJson(Map<String, dynamic> json) {
    roomsAccesseble =
        json['IAM'] != null ? List<String>.from(json['IAM']) : null;

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
    data['IAM'] = roomsAccesseble;

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
