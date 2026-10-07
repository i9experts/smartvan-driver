import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/json_helpers.dart';

part 'parent_contact.freezed.dart';
part 'parent_contact.g.dart';

/// How to reach a kid's parent. Built from `parent{...}` or, on older
/// responses, from flat keys on the kid itself (see [readParentContact]).
@freezed
abstract class ParentContact with _$ParentContact {
  const factory ParentContact({
    @JsonKey(fromJson: looseString) String? phoneNo,
    @JsonKey(fromJson: looseString) String? alternatePhoneNo,
    @JsonKey(fromJson: looseString) String? address,
  }) = _ParentContact;

  factory ParentContact.fromJson(Map<String, dynamic> json) =>
      _$ParentContactFromJson(json);
}

/// `parent.phoneNo | parentPhone | phoneNo`,
/// `parent.alternatePhoneNo | alternatePhone`, `parent.address | address`.
Object? readParentContact(Map<dynamic, dynamic> m, String key) => {
      'phoneNo': readParentPhone(m, key),
      'alternatePhoneNo': readParentAlternatePhone(m, key),
      'address': readParentAddress(m, key),
    };
