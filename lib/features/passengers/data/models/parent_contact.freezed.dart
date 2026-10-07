// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parent_contact.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParentContact {
  @JsonKey(fromJson: looseString)
  String? get phoneNo;
  @JsonKey(fromJson: looseString)
  String? get alternatePhoneNo;
  @JsonKey(fromJson: looseString)
  String? get address;

  /// Create a copy of ParentContact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ParentContactCopyWith<ParentContact> get copyWith =>
      _$ParentContactCopyWithImpl<ParentContact>(
          this as ParentContact, _$identity);

  /// Serializes this ParentContact to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ParentContact &&
            (identical(other.phoneNo, phoneNo) || other.phoneNo == phoneNo) &&
            (identical(other.alternatePhoneNo, alternatePhoneNo) ||
                other.alternatePhoneNo == alternatePhoneNo) &&
            (identical(other.address, address) || other.address == address));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, phoneNo, alternatePhoneNo, address);

  @override
  String toString() {
    return 'ParentContact(phoneNo: $phoneNo, alternatePhoneNo: $alternatePhoneNo, address: $address)';
  }
}

/// @nodoc
abstract mixin class $ParentContactCopyWith<$Res> {
  factory $ParentContactCopyWith(
          ParentContact value, $Res Function(ParentContact) _then) =
      _$ParentContactCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseString) String? phoneNo,
      @JsonKey(fromJson: looseString) String? alternatePhoneNo,
      @JsonKey(fromJson: looseString) String? address});
}

/// @nodoc
class _$ParentContactCopyWithImpl<$Res>
    implements $ParentContactCopyWith<$Res> {
  _$ParentContactCopyWithImpl(this._self, this._then);

  final ParentContact _self;
  final $Res Function(ParentContact) _then;

  /// Create a copy of ParentContact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNo = freezed,
    Object? alternatePhoneNo = freezed,
    Object? address = freezed,
  }) {
    return _then(_self.copyWith(
      phoneNo: freezed == phoneNo
          ? _self.phoneNo
          : phoneNo // ignore: cast_nullable_to_non_nullable
              as String?,
      alternatePhoneNo: freezed == alternatePhoneNo
          ? _self.alternatePhoneNo
          : alternatePhoneNo // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ParentContact].
extension ParentContactPatterns on ParentContact {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ParentContact value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ParentContact() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ParentContact value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ParentContact():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ParentContact value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ParentContact() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @JsonKey(fromJson: looseString) String? phoneNo,
            @JsonKey(fromJson: looseString) String? alternatePhoneNo,
            @JsonKey(fromJson: looseString) String? address)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ParentContact() when $default != null:
        return $default(_that.phoneNo, _that.alternatePhoneNo, _that.address);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @JsonKey(fromJson: looseString) String? phoneNo,
            @JsonKey(fromJson: looseString) String? alternatePhoneNo,
            @JsonKey(fromJson: looseString) String? address)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ParentContact():
        return $default(_that.phoneNo, _that.alternatePhoneNo, _that.address);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @JsonKey(fromJson: looseString) String? phoneNo,
            @JsonKey(fromJson: looseString) String? alternatePhoneNo,
            @JsonKey(fromJson: looseString) String? address)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ParentContact() when $default != null:
        return $default(_that.phoneNo, _that.alternatePhoneNo, _that.address);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ParentContact implements ParentContact {
  const _ParentContact(
      {@JsonKey(fromJson: looseString) this.phoneNo,
      @JsonKey(fromJson: looseString) this.alternatePhoneNo,
      @JsonKey(fromJson: looseString) this.address});
  factory _ParentContact.fromJson(Map<String, dynamic> json) =>
      _$ParentContactFromJson(json);

  @override
  @JsonKey(fromJson: looseString)
  final String? phoneNo;
  @override
  @JsonKey(fromJson: looseString)
  final String? alternatePhoneNo;
  @override
  @JsonKey(fromJson: looseString)
  final String? address;

  /// Create a copy of ParentContact
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ParentContactCopyWith<_ParentContact> get copyWith =>
      __$ParentContactCopyWithImpl<_ParentContact>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ParentContactToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ParentContact &&
            (identical(other.phoneNo, phoneNo) || other.phoneNo == phoneNo) &&
            (identical(other.alternatePhoneNo, alternatePhoneNo) ||
                other.alternatePhoneNo == alternatePhoneNo) &&
            (identical(other.address, address) || other.address == address));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, phoneNo, alternatePhoneNo, address);

  @override
  String toString() {
    return 'ParentContact(phoneNo: $phoneNo, alternatePhoneNo: $alternatePhoneNo, address: $address)';
  }
}

/// @nodoc
abstract mixin class _$ParentContactCopyWith<$Res>
    implements $ParentContactCopyWith<$Res> {
  factory _$ParentContactCopyWith(
          _ParentContact value, $Res Function(_ParentContact) _then) =
      __$ParentContactCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: looseString) String? phoneNo,
      @JsonKey(fromJson: looseString) String? alternatePhoneNo,
      @JsonKey(fromJson: looseString) String? address});
}

/// @nodoc
class __$ParentContactCopyWithImpl<$Res>
    implements _$ParentContactCopyWith<$Res> {
  __$ParentContactCopyWithImpl(this._self, this._then);

  final _ParentContact _self;
  final $Res Function(_ParentContact) _then;

  /// Create a copy of ParentContact
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? phoneNo = freezed,
    Object? alternatePhoneNo = freezed,
    Object? address = freezed,
  }) {
    return _then(_ParentContact(
      phoneNo: freezed == phoneNo
          ? _self.phoneNo
          : phoneNo // ignore: cast_nullable_to_non_nullable
              as String?,
      alternatePhoneNo: freezed == alternatePhoneNo
          ? _self.alternatePhoneNo
          : alternatePhoneNo // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
