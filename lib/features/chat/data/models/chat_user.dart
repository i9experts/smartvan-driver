import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';

part 'chat_user.freezed.dart';
part 'chat_user.g.dart';

/// The other side of a conversation.
@freezed
abstract class ChatUser with _$ChatUser {
  const factory ChatUser({
    @JsonKey(fromJson: looseStringOrEmpty) @Default('') String id,

    /// `parent` | `driver`.
    @JsonKey(fromJson: looseStringOrEmpty) @Default('') String type,
    @JsonKey(fromJson: looseStringOrEmpty) @Default('') String name,
    @JsonKey(fromJson: looseString) String? image,
  }) = _ChatUser;

  factory ChatUser.fromJson(Map<String, dynamic> json) =>
      _$ChatUserFromJson(json);
}
