import 'dart:convert';

import 'package:open_video/common/instance.dart';

class DouYinListModel {
  DouYinListModel({
    required this.id,
    required this.title,
    required this.alias,
    required this.picuser,
    required this.picurl,
    required this.playurl,
    required this.sec,
  });

  factory DouYinListModel.fromJson(Map<String, dynamic> json) =>
      DouYinListModel(
        id: asT<int>(json['id'])!,
        title: asT<String>(json['title'])!,
        alias: asT<String>(json['alias'])!,
        picuser: asT<String>(json['picuser'])!,
        picurl: asT<String>(json['picurl'])!,
        playurl: asT<String>(json['playurl'])!,
        sec: asT<String>(json['sec'])!,
      );

  int id;
  String title;
  String alias;
  String picuser;
  String picurl;
  String playurl;
  String sec;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'alias': alias,
        'picuser': picuser,
        'picurl': picurl,
        'playurl': playurl,
        'sec': sec,
      };
}
