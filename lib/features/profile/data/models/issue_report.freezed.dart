// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'issue_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IssueReport {
  @JsonKey(unknownEnumValue: IssueType.unknown)
  IssueType get issueType;
  @JsonKey(fromJson: looseStringOrEmpty)
  String get description;

  /// Always `driverReport` for this app.
  String get type;

  /// Hosted URL from `/upload/image`; left out of the body when null.
  @JsonKey(includeIfNull: false, fromJson: looseString)
  String? get image;

  /// Create a copy of IssueReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IssueReportCopyWith<IssueReport> get copyWith =>
      _$IssueReportCopyWithImpl<IssueReport>(this as IssueReport, _$identity);

  /// Serializes this IssueReport to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IssueReport &&
            (identical(other.issueType, issueType) ||
                other.issueType == issueType) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.image, image) || other.image == image));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, issueType, description, type, image);

  @override
  String toString() {
    return 'IssueReport(issueType: $issueType, description: $description, type: $type, image: $image)';
  }
}

/// @nodoc
abstract mixin class $IssueReportCopyWith<$Res> {
  factory $IssueReportCopyWith(
          IssueReport value, $Res Function(IssueReport) _then) =
      _$IssueReportCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(unknownEnumValue: IssueType.unknown) IssueType issueType,
      @JsonKey(fromJson: looseStringOrEmpty) String description,
      String type,
      @JsonKey(includeIfNull: false, fromJson: looseString) String? image});
}

/// @nodoc
class _$IssueReportCopyWithImpl<$Res> implements $IssueReportCopyWith<$Res> {
  _$IssueReportCopyWithImpl(this._self, this._then);

  final IssueReport _self;
  final $Res Function(IssueReport) _then;

  /// Create a copy of IssueReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? issueType = null,
    Object? description = null,
    Object? type = null,
    Object? image = freezed,
  }) {
    return _then(_self.copyWith(
      issueType: null == issueType
          ? _self.issueType
          : issueType // ignore: cast_nullable_to_non_nullable
              as IssueType,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      image: freezed == image
          ? _self.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [IssueReport].
extension IssueReportPatterns on IssueReport {
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
    TResult Function(_IssueReport value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _IssueReport() when $default != null:
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
    TResult Function(_IssueReport value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IssueReport():
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
    TResult? Function(_IssueReport value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IssueReport() when $default != null:
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
            @JsonKey(unknownEnumValue: IssueType.unknown) IssueType issueType,
            @JsonKey(fromJson: looseStringOrEmpty) String description,
            String type,
            @JsonKey(includeIfNull: false, fromJson: looseString)
            String? image)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _IssueReport() when $default != null:
        return $default(
            _that.issueType, _that.description, _that.type, _that.image);
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
            @JsonKey(unknownEnumValue: IssueType.unknown) IssueType issueType,
            @JsonKey(fromJson: looseStringOrEmpty) String description,
            String type,
            @JsonKey(includeIfNull: false, fromJson: looseString) String? image)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IssueReport():
        return $default(
            _that.issueType, _that.description, _that.type, _that.image);
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
            @JsonKey(unknownEnumValue: IssueType.unknown) IssueType issueType,
            @JsonKey(fromJson: looseStringOrEmpty) String description,
            String type,
            @JsonKey(includeIfNull: false, fromJson: looseString)
            String? image)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IssueReport() when $default != null:
        return $default(
            _that.issueType, _that.description, _that.type, _that.image);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _IssueReport implements IssueReport {
  const _IssueReport(
      {@JsonKey(unknownEnumValue: IssueType.unknown)
      this.issueType = IssueType.other,
      @JsonKey(fromJson: looseStringOrEmpty) this.description = '',
      this.type = 'driverReport',
      @JsonKey(includeIfNull: false, fromJson: looseString) this.image});
  factory _IssueReport.fromJson(Map<String, dynamic> json) =>
      _$IssueReportFromJson(json);

  @override
  @JsonKey(unknownEnumValue: IssueType.unknown)
  final IssueType issueType;
  @override
  @JsonKey(fromJson: looseStringOrEmpty)
  final String description;

  /// Always `driverReport` for this app.
  @override
  @JsonKey()
  final String type;

  /// Hosted URL from `/upload/image`; left out of the body when null.
  @override
  @JsonKey(includeIfNull: false, fromJson: looseString)
  final String? image;

  /// Create a copy of IssueReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$IssueReportCopyWith<_IssueReport> get copyWith =>
      __$IssueReportCopyWithImpl<_IssueReport>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$IssueReportToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _IssueReport &&
            (identical(other.issueType, issueType) ||
                other.issueType == issueType) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.image, image) || other.image == image));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, issueType, description, type, image);

  @override
  String toString() {
    return 'IssueReport(issueType: $issueType, description: $description, type: $type, image: $image)';
  }
}

/// @nodoc
abstract mixin class _$IssueReportCopyWith<$Res>
    implements $IssueReportCopyWith<$Res> {
  factory _$IssueReportCopyWith(
          _IssueReport value, $Res Function(_IssueReport) _then) =
      __$IssueReportCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(unknownEnumValue: IssueType.unknown) IssueType issueType,
      @JsonKey(fromJson: looseStringOrEmpty) String description,
      String type,
      @JsonKey(includeIfNull: false, fromJson: looseString) String? image});
}

/// @nodoc
class __$IssueReportCopyWithImpl<$Res> implements _$IssueReportCopyWith<$Res> {
  __$IssueReportCopyWithImpl(this._self, this._then);

  final _IssueReport _self;
  final $Res Function(_IssueReport) _then;

  /// Create a copy of IssueReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? issueType = null,
    Object? description = null,
    Object? type = null,
    Object? image = freezed,
  }) {
    return _then(_IssueReport(
      issueType: null == issueType
          ? _self.issueType
          : issueType // ignore: cast_nullable_to_non_nullable
              as IssueType,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      image: freezed == image
          ? _self.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
