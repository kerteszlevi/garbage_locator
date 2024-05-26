// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garbage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Garbage _$GarbageFromJson(Map<String, dynamic> json) => Garbage(
      id: json['id'] as String?,
      author: json['author'] as String,
      imagePath: json['imagePath'] as String,
      location: json['location'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      comment: json['comment'] as String,
      likes:
          (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList(),
      dislikes: (json['dislikes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$GarbageToJson(Garbage instance) => <String, dynamic>{
      'id': instance.id,
      'imagePath': instance.imagePath,
      'author': instance.author,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'comment': instance.comment,
      'location': instance.location,
      'likes': instance.likes,
      'dislikes': instance.dislikes,
    };
