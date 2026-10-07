// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatMessage {
  /// Backend key: `messageId`.
  @JsonKey(readValue: _readMessageId, fromJson: looseStringOrEmpty)
  String get id;
  @JsonKey(fromJson: looseStringOrEmpty)
  String get conversationId;

  /// `parent` | `driver`.
  @JsonKey(fromJson: looseStringOrEmpty)
  String get senderType;

  /// Kept exactly as sent (no trimming).
  @JsonKey(fromJson: _text)
  String get text;

  /// Local time. A missing / broken timestamp becomes "now".
  @JsonKey(fromJson: _createdAt)
  DateTime get createdAt;

  /// Local time; null while unread.
  @JsonKey(fromJson: looseLocalDateTime)
  DateTime? get readAt;

  /// Local-only: still sending. Never comes from or goes to the backend.
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get pending;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChatMessageCopyWith<ChatMessage> get copyWith =>
      _$ChatMessageCopyWithImpl<ChatMessage>(this as ChatMessage, _$identity);

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatMessage &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.senderType, senderType) ||
                other.senderType == senderType) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.pending, pending) || other.pending == pending));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, conversationId, senderType,
      text, createdAt, readAt, pending);

  @override
  String toString() {
    return 'ChatMessage(id: $id, conversationId: $conversationId, senderType: $senderType, text: $text, createdAt: $createdAt, readAt: $readAt, pending: $pending)';
  }
}

/// @nodoc
abstract mixin class $ChatMessageCopyWith<$Res> {
  factory $ChatMessageCopyWith(
          ChatMessage value, $Res Function(ChatMessage) _then) =
      _$ChatMessageCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(readValue: _readMessageId, fromJson: looseStringOrEmpty)
      String id,
      @JsonKey(fromJson: looseStringOrEmpty) String conversationId,
      @JsonKey(fromJson: looseStringOrEmpty) String senderType,
      @JsonKey(fromJson: _text) String text,
      @JsonKey(fromJson: _createdAt) DateTime createdAt,
      @JsonKey(fromJson: looseLocalDateTime) DateTime? readAt,
      @JsonKey(includeFromJson: false, includeToJson: false) bool pending});
}

/// @nodoc
class _$ChatMessageCopyWithImpl<$Res> implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._self, this._then);

  final ChatMessage _self;
  final $Res Function(ChatMessage) _then;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? senderType = null,
    Object? text = null,
    Object? createdAt = null,
    Object? readAt = freezed,
    Object? pending = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _self.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      senderType: null == senderType
          ? _self.senderType
          : senderType // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      readAt: freezed == readAt
          ? _self.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pending: null == pending
          ? _self.pending
          : pending // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [ChatMessage].
extension ChatMessagePatterns on ChatMessage {
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
    TResult Function(_ChatMessage value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChatMessage() when $default != null:
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
    TResult Function(_ChatMessage value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatMessage():
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
    TResult? Function(_ChatMessage value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatMessage() when $default != null:
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
            @JsonKey(readValue: _readMessageId, fromJson: looseStringOrEmpty)
            String id,
            @JsonKey(fromJson: looseStringOrEmpty) String conversationId,
            @JsonKey(fromJson: looseStringOrEmpty) String senderType,
            @JsonKey(fromJson: _text) String text,
            @JsonKey(fromJson: _createdAt) DateTime createdAt,
            @JsonKey(fromJson: looseLocalDateTime) DateTime? readAt,
            @JsonKey(includeFromJson: false, includeToJson: false)
            bool pending)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChatMessage() when $default != null:
        return $default(_that.id, _that.conversationId, _that.senderType,
            _that.text, _that.createdAt, _that.readAt, _that.pending);
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
            @JsonKey(readValue: _readMessageId, fromJson: looseStringOrEmpty)
            String id,
            @JsonKey(fromJson: looseStringOrEmpty) String conversationId,
            @JsonKey(fromJson: looseStringOrEmpty) String senderType,
            @JsonKey(fromJson: _text) String text,
            @JsonKey(fromJson: _createdAt) DateTime createdAt,
            @JsonKey(fromJson: looseLocalDateTime) DateTime? readAt,
            @JsonKey(includeFromJson: false, includeToJson: false) bool pending)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatMessage():
        return $default(_that.id, _that.conversationId, _that.senderType,
            _that.text, _that.createdAt, _that.readAt, _that.pending);
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
            @JsonKey(readValue: _readMessageId, fromJson: looseStringOrEmpty)
            String id,
            @JsonKey(fromJson: looseStringOrEmpty) String conversationId,
            @JsonKey(fromJson: looseStringOrEmpty) String senderType,
            @JsonKey(fromJson: _text) String text,
            @JsonKey(fromJson: _createdAt) DateTime createdAt,
            @JsonKey(fromJson: looseLocalDateTime) DateTime? readAt,
            @JsonKey(includeFromJson: false, includeToJson: false)
            bool pending)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatMessage() when $default != null:
        return $default(_that.id, _that.conversationId, _that.senderType,
            _that.text, _that.createdAt, _that.readAt, _that.pending);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ChatMessage implements ChatMessage {
  const _ChatMessage(
      {@JsonKey(readValue: _readMessageId, fromJson: looseStringOrEmpty)
      this.id = '',
      @JsonKey(fromJson: looseStringOrEmpty) this.conversationId = '',
      @JsonKey(fromJson: looseStringOrEmpty) this.senderType = '',
      @JsonKey(fromJson: _text) this.text = '',
      @JsonKey(fromJson: _createdAt) required this.createdAt,
      @JsonKey(fromJson: looseLocalDateTime) this.readAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.pending = false});
  factory _ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  /// Backend key: `messageId`.
  @override
  @JsonKey(readValue: _readMessageId, fromJson: looseStringOrEmpty)
  final String id;
  @override
  @JsonKey(fromJson: looseStringOrEmpty)
  final String conversationId;

  /// `parent` | `driver`.
  @override
  @JsonKey(fromJson: looseStringOrEmpty)
  final String senderType;

  /// Kept exactly as sent (no trimming).
  @override
  @JsonKey(fromJson: _text)
  final String text;

  /// Local time. A missing / broken timestamp becomes "now".
  @override
  @JsonKey(fromJson: _createdAt)
  final DateTime createdAt;

  /// Local time; null while unread.
  @override
  @JsonKey(fromJson: looseLocalDateTime)
  final DateTime? readAt;

  /// Local-only: still sending. Never comes from or goes to the backend.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool pending;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ChatMessageCopyWith<_ChatMessage> get copyWith =>
      __$ChatMessageCopyWithImpl<_ChatMessage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ChatMessageToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ChatMessage &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.senderType, senderType) ||
                other.senderType == senderType) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.pending, pending) || other.pending == pending));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, conversationId, senderType,
      text, createdAt, readAt, pending);

  @override
  String toString() {
    return 'ChatMessage(id: $id, conversationId: $conversationId, senderType: $senderType, text: $text, createdAt: $createdAt, readAt: $readAt, pending: $pending)';
  }
}

/// @nodoc
abstract mixin class _$ChatMessageCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory _$ChatMessageCopyWith(
          _ChatMessage value, $Res Function(_ChatMessage) _then) =
      __$ChatMessageCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(readValue: _readMessageId, fromJson: looseStringOrEmpty)
      String id,
      @JsonKey(fromJson: looseStringOrEmpty) String conversationId,
      @JsonKey(fromJson: looseStringOrEmpty) String senderType,
      @JsonKey(fromJson: _text) String text,
      @JsonKey(fromJson: _createdAt) DateTime createdAt,
      @JsonKey(fromJson: looseLocalDateTime) DateTime? readAt,
      @JsonKey(includeFromJson: false, includeToJson: false) bool pending});
}

/// @nodoc
class __$ChatMessageCopyWithImpl<$Res> implements _$ChatMessageCopyWith<$Res> {
  __$ChatMessageCopyWithImpl(this._self, this._then);

  final _ChatMessage _self;
  final $Res Function(_ChatMessage) _then;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? senderType = null,
    Object? text = null,
    Object? createdAt = null,
    Object? readAt = freezed,
    Object? pending = null,
  }) {
    return _then(_ChatMessage(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _self.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      senderType: null == senderType
          ? _self.senderType
          : senderType // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      readAt: freezed == readAt
          ? _self.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pending: null == pending
          ? _self.pending
          : pending // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
