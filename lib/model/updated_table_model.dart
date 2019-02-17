import 'package:json_annotation/json_annotation.dart';

part 'updated_table_model.g.dart';

@JsonSerializable()
class UpdatedTableModel {
  @JsonKey(nullable: false)
  final String id;
  @JsonKey(nullable: false)
  final String tableName; //标题
  @JsonKey(nullable: false)
  final String method;
  @JsonKey(nullable: false)
  final int isUpToDate;

  UpdatedTableModel(this.id, this.tableName, this.method, this.isUpToDate);

  factory UpdatedTableModel.fromJson(Map<String, dynamic> json) =>
      _$UpdatedTableModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdatedTableModelToJson(this);
}
