import 'dart:convert';

import 'package:open_video/common/instance.dart';

class WallpaperListModel {
  WallpaperListModel({
    required this.id,
    required this.title,
    required this.url,
    required this.type,
  });

  factory WallpaperListModel.fromJson(Map<String, dynamic> json) =>
      WallpaperListModel(
        id: asT<int>(json['id'])!,
        title: asT<String>(json['title'])!,
        url: asT<String>(json['url'])!,
        type: asT<String>(json['type'])!,
      );

  int id;
  String title;
  String url;
  String type;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'url': url,
        'type': type,
      };
}
