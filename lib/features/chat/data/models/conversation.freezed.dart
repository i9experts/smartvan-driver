// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Conversation {
  /// Backend key: `conversationId`.
  @JsonKey(readValue: _readConversationId, fromJson: looseStringOrEmpty)
  String get id;
  @JsonKey(readValue: _readOtherUser)
  ChatUser get otherUser;

  /// Names of the kids the conversation is about (`kids[].fullname`).
  @JsonKey(readValue: _readKidNames)
  List<String> get kidNames;

  /// `lastMessage.text`
  @JsonKey(readValue: _readLastText, fromJson: _text)
  String? get lastText;

  /// `lastMessage.senderType`
  @JsonKey(readValue: _readLastSender, fromJson: looseString)
  String? get lastSenderType;

  /// `lastMessage.at`, in local time.
  @JsonKey(readValue: _readLastAt, fromJson: looseLocalDateTime)
  DateTime? get lastAt;
  @JsonKey(fromJson: _unread)
  int get unread;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConversationCopyWith<Conversation> get copyWith =>
      _$ConversationCopyWithImpl<Conversation>(
          this as Conversation, _$identity);

  /// Serializes this Conversation to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Conversation &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.otherUser, otherUser) ||
                other.otherUser == otherUser) &&
            const DeepCollectionEquality().equals(other.kidNames, kidNames) &&
            (identical(other.lastText, lastText) ||
                other.lastText == lastText) &&
            (identical(other.lastSenderType, lastSenderType) ||
                other.lastSenderType == lastSenderType) &&
            (identical(other.lastAt, lastAt) || other.lastAt == lastAt) &&
            (identical(other.unread, unread) || other.unread == unread));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      otherUser,
      const DeepCollectionEquality().hash(kidNames),
      lastText,
      lastSenderType,
      lastAt,
      unread);

  @override
  String toString() {
    return 'Conversation(id: $id, otherUser: $otherUser, kidNames: $kidNames, lastText: $lastText, lastSenderType: $lastSenderType, lastAt: $lastAt, unread: $unread)';
  }
}

/// @nodoc
abstract mixin class $ConversationCopyWith<$Res> {
  factory $ConversationCopyWith(
          Conversation value, $Res Function(Conversation) _then) =
      _$ConversationCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(readValue: _readConversationId, fromJson: looseStringOrEmpty)
      String id,
      @JsonKey(readValue: _readOtherUser) ChatUser otherUser,
      @JsonKey(readValue: _readKidNames) List<String> kidNames,
      @JsonKey(readValue: _readLastText, fromJson: _text) String? lastText,
      @JsonKey(readValue: _readLastSender, fromJson: looseString)
      String? lastSenderType,
      @JsonKey(readValue: _readLastAt, fromJson: looseLocalDateTime)
      DateTime? lastAt,
      @JsonKey(fromJson: _unread) int unread});

  $ChatUserCopyWith<$Res> get otherUser;
}

/// @nodoc
class _$ConversationCopyWithImpl<$Res> implements $ConversationCopyWith<$Res> {
  _$ConversationCopyWithImpl(this._self, this._then);

  final Conversation _self;
  final $Res Function(Conversation) _then;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? otherUser = null,
    Object? kidNames = null,
    Object? lastText = freezed,
    Object? lastSenderType = freezed,
    Object? lastAt = freezed,
    Object? unread = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      otherUser: null == otherUser
          ? _self.otherUser
          : otherUser // ignore: cast_nullable_to_non_nullable
              as ChatUser,
      kidNames: null == kidNames
          ? _self.kidNames
          : kidNames // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastText: freezed == lastText
          ? _self.lastText
          : lastText // ignore: cast_nullable_to_non_nullable
              as String?,
      lastSenderType: freezed == lastSenderType
          ? _self.lastSenderType
          : lastSenderType // ignore: cast_nullable_to_non_nullable
              as String?,
      lastAt: freezed == lastAt
          ? _self.lastAt
          : lastAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      unread: null == unread
          ? _self.unread
          : unread // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatUserCopyWith<$Res> get otherUser {
    return $ChatUserCopyWith<$Res>(_self.otherUser, (value) {
      return _then(_self.copyWith(otherUser: value));
    });
  }
}

/// Adds pattern-matching-related methods to [Conversation].
extension ConversationPatterns on Conversation {
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
    TResult Function(_Conversation value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Conversation() when $default != null:
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
    TResult Function(_Conversation value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Conversation():
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
    TResult? Function(_Conversation value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Conversation() when $default != null:
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
            @JsonKey(
                readValue: _readConversationId, fromJson: looseStringOrEmpty)
            String id,
            @JsonKey(readValue: _readOtherUser) ChatUser otherUser,
            @JsonKey(readValue: _readKidNames) List<String> kidNames,
            @JsonKey(readValue: _readLastText, fromJson: _text)
            String? lastText,
            @JsonKey(readValue: _readLastSender, fromJson: looseString)
            String? lastSenderType,
            @JsonKey(readValue: _readLastAt, fromJson: looseLocalDateTime)
            DateTime? lastAt,
            @JsonKey(fromJson: _unread) int unread)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Conversation() when $default != null:
        return $default(_that.id, _that.otherUser, _that.kidNames,
            _that.lastText, _that.lastSenderType, _that.lastAt, _that.unread);
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
            @JsonKey(
                readValue: _readConversationId, fromJson: looseStringOrEmpty)
            String id,
            @JsonKey(readValue: _readOtherUser) ChatUser otherUser,
            @JsonKey(readValue: _readKidNames) List<String> kidNames,
            @JsonKey(readValue: _readLastText, fromJson: _text)
            String? lastText,
            @JsonKey(readValue: _readLastSender, fromJson: looseString)
            String? lastSenderType,
            @JsonKey(readValue: _readLastAt, fromJson: looseLocalDateTime)
            DateTime? lastAt,
            @JsonKey(fromJson: _unread) int unread)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Conversation():
        return $default(_that.id, _that.otherUser, _that.kidNames,
            _that.lastText, _that.lastSenderType, _that.lastAt, _that.unread);
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
            @JsonKey(
                readValue: _readConversationId, fromJson: looseStringOrEmpty)
            String id,
            @JsonKey(readValue: _readOtherUser) ChatUser otherUser,
            @JsonKey(readValue: _readKidNames) List<String> kidNames,
            @JsonKey(readValue: _readLastText, fromJson: _text)
            String? lastText,
            @JsonKey(readValue: _readLastSender, fromJson: looseString)
            String? lastSenderType,
            @JsonKey(readValue: _readLastAt, fromJson: looseLocalDateTime)
            DateTime? lastAt,
            @JsonKey(fromJson: _unread) int unread)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Conversation() when $default != null:
        return $default(_that.id, _that.otherUser, _that.kidNames,
            _that.lastText, _that.lastSenderType, _that.lastAt, _that.unread);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Conversation implements Conversation {
  const _Conversation(
      {@JsonKey(readValue: _readConversationId, fromJson: looseStringOrEmpty)
      this.id = '',
      @JsonKey(readValue: _readOtherUser) this.otherUser = const ChatUser(),
      @JsonKey(readValue: _readKidNames)
      final List<String> kidNames = const <String>[],
      @JsonKey(readValue: _readLastText, fromJson: _text) this.lastText,
      @JsonKey(readValue: _readLastSender, fromJson: looseString)
      this.lastSenderType,
      @JsonKey(readValue: _readLastAt, fromJson: looseLocalDateTime)
      this.lastAt,
      @JsonKey(fromJson: _unread) this.unread = 0})
      : _kidNames = kidNames;
  factory _Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);

  /// Backend key: `conversationId`.
  @override
  @JsonKey(readValue: _readConversationId, fromJson: looseStringOrEmpty)
  final String id;
  @override
  @JsonKey(readValue: _readOtherUser)
  final ChatUser otherUser;

  /// Names of the kids the conversation is about (`kids[].fullname`).
  final List<String> _kidNames;

  /// Names of the kids the conversation is about (`kids[].fullname`).
  @override
  @JsonKey(readValue: _readKidNames)
  List<String> get kidNames {
    if (_kidNames is EqualUnmodifiableListView) return _kidNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_kidNames);
  }

  /// `lastMessage.text`
  @override
  @JsonKey(readValue: _readLastText, fromJson: _text)
  final String? lastText;

  /// `lastMessage.senderType`
  @override
  @JsonKey(readValue: _readLastSender, fromJson: looseString)
  final String? lastSenderType;

  /// `lastMessage.at`, in local time.
  @override
  @JsonKey(readValue: _readLastAt, fromJson: looseLocalDateTime)
  final DateTime? lastAt;
  @override
  @JsonKey(fromJson: _unread)
  final int unread;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConversationCopyWith<_Conversation> get copyWith =>
      __$ConversationCopyWithImpl<_Conversation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ConversationToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Conversation &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.otherUser, otherUser) ||
                other.otherUser == otherUser) &&
            const DeepCollectionEquality().equals(other._kidNames, _kidNames) &&
            (identical(other.lastText, lastText) ||
                other.lastText == lastText) &&
            (identical(other.lastSenderType, lastSenderType) ||
                other.lastSenderType == lastSenderType) &&
            (identical(other.lastAt, lastAt) || other.lastAt == lastAt) &&
            (identical(other.unread, unread) || other.unread == unread));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      otherUser,
      const DeepCollectionEquality().hash(_kidNames),
      lastText,
      lastSenderType,
      lastAt,
      unread);

  @override
  String toString() {
    return 'Conversation(id: $id, otherUser: $otherUser, kidNames: $kidNames, lastText: $lastText, lastSenderType: $lastSenderType, lastAt: $lastAt, unread: $unread)';
  }
}

/// @nodoc
abstract mixin class _$ConversationCopyWith<$Res>
    implements $ConversationCopyWith<$Res> {
  factory _$ConversationCopyWith(
          _Conversation value, $Res Function(_Conversation) _then) =
      __$ConversationCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(readValue: _readConversationId, fromJson: looseStringOrEmpty)
      String id,
      @JsonKey(readValue: _readOtherUser) ChatUser otherUser,
      @JsonKey(readValue: _readKidNames) List<String> kidNames,
      @JsonKey(readValue: _readLastText, fromJson: _text) String? lastText,
      @JsonKey(readValue: _readLastSender, fromJson: looseString)
      String? lastSenderType,
      @JsonKey(readValue: _readLastAt, fromJson: looseLocalDateTime)
      DateTime? lastAt,
      @JsonKey(fromJson: _unread) int unread});

  @override
  $ChatUserCopyWith<$Res> get otherUser;
}

/// @nodoc
class __$ConversationCopyWithImpl<$Res>
    implements _$ConversationCopyWith<$Res> {
  __$ConversationCopyWithImpl(this._self, this._then);

  final _Conversation _self;
  final $Res Function(_Conversation) _then;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? otherUser = null,
    Object? kidNames = null,
    Object? lastText = freezed,
    Object? lastSenderType = freezed,
    Object? lastAt = freezed,
    Object? unread = null,
  }) {
    return _then(_Conversation(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      otherUser: null == otherUser
          ? _self.otherUser
          : otherUser // ignore: cast_nullable_to_non_nullable
              as ChatUser,
      kidNames: null == kidNames
          ? _self._kidNames
          : kidNames // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastText: freezed == lastText
          ? _self.lastText
          : lastText // ignore: cast_nullable_to_non_nullable
              as String?,
      lastSenderType: freezed == lastSenderType
          ? _self.lastSenderType
          : lastSenderType // ignore: cast_nullable_to_non_nullable
              as String?,
      lastAt: freezed == lastAt
          ? _self.lastAt
          : lastAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      unread: null == unread
          ? _self.unread
          : unread // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatUserCopyWith<$Res> get otherUser {
    return $ChatUserCopyWith<$Res>(_self.otherUser, (value) {
      return _then(_self.copyWith(otherUser: value));
    });
  }
}

// dart format on
