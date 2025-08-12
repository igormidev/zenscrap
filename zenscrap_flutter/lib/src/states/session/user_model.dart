import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';

@freezed
abstract class UserModel with _$UserModel {
  factory UserModel({
    required String? imageUrl,
    required String userName,
    required String email,
  }) = _UserModel;
}
