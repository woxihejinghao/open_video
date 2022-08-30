import 'dart:convert';

import 'package:open_video/common/instance.dart';

class ListVideoModel {
  ListVideoModel({
    required this.id,
    required this.title,
    required this.username,
    required this.userpic,
    required this.coverurl,
    required this.playurl,
    required this.duration,
  });

  factory ListVideoModel.fromJson(Map<String, dynamic> json) => ListVideoModel(
        id: asT<int>(json['id'])!,
        title: asT<String>(json['title'])!,
        username: asT<String>(json['userName'])!,
        userpic: asT<String>(json['userPic'])!,
        coverurl: asT<String>(json['coverUrl'])!,
        playurl: asT<String>(json['playUrl'])!,
        duration: asT<String>(json['duration'])!,
      );

  int id;
  String title;
  String username;
  String userpic;
  String coverurl;
  String playurl;
  String duration;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'userName': username,
        'userPic': userpic,
        'coverUrl': coverurl,
        'playUrl': playurl,
        'duration': duration,
      };
}
