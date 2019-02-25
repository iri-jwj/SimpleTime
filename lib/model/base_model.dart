import 'package:json_annotation/json_annotation.dart';

abstract class BaseModel {
  @JsonKey(nullable: false)
  final String id;

  Map<String, dynamic> toJson();

  BaseModel(this.id);
}
