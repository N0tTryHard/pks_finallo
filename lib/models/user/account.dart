import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  Account(this.ID, this.Name, this.Email, this.PhoneNumber);

  int ID;
  String Name;
  String Email;
  String PhoneNumber;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}
