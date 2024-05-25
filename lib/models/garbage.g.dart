// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garbage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Garbage _$GarbageFromJson(Map<String, dynamic> json) => Garbage(
      id: json['id'] as String?,
      imagePath: json['imagePath'] as String,
      location: json['location'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      comment: json['comment'] as String,
    );

Map<String, dynamic> _$GarbageToJson(Garbage instance) => <String, dynamic>{
      'id': instance.id,
      'imagePath': instance.imagePath,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'comment': instance.comment,
      'location': instance.location,
    };
