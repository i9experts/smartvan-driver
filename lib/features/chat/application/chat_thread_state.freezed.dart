// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_thread_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatThreadState {
  /// Newest first.
  List<ChatMessage> get messages;

  /// Older messages exist on the server.
  bool get hasMore;
  bool get loadingMore;
  bool get sending;

  /// Create a copy of ChatThreadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChatThreadStateCopyWith<ChatThreadState> get copyWith =>
      _$ChatThreadStateCopyWithImpl<ChatThreadState>(
          this as ChatThreadState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatThreadState &&
            const DeepCollectionEquality().equals(other.messages, messages) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.loadingMore, loadingMore) ||
                other.loadingMore == loadingMore) &&
            (identical(other.sending, sending) || other.sending == sending));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(messages),
      hasMore,
      loadingMore,
      sending);

  @override
  String toString() {
    return 'ChatThreadState(messages: $messages, hasMore: $hasMore, loadingMore: $loadingMore, sending: $sending)';
  }
}

/// @nodoc
abstract mixin class $ChatThreadStateCopyWith<$Res> {
  factory $ChatThreadStateCopyWith(
          ChatThreadState value, $Res Function(ChatThreadState) _then) =
      _$ChatThreadStateCopyWithImpl;
  @useResult
  $Res call(
      {List<ChatMessage> messages,
      bool hasMore,
      bool loadingMore,
      bool sending});
}

/// @nodoc
class _$ChatThreadStateCopyWithImpl<$Res>
    implements $ChatThreadStateCopyWith<$Res> {
  _$ChatThreadStateCopyWithImpl(this._self, this._then);

  final ChatThreadState _self;
  final $Res Function(ChatThreadState) _then;

  /// Create a copy of ChatThreadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messages = null,
    Object? hasMore = null,
    Object? loadingMore = null,
    Object? sending = null,
  }) {
    return _then(_self.copyWith(
      messages: null == messages
          ? _self.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<ChatMessage>,
      hasMore: null == hasMore
          ? _self.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      loadingMore: null == loadingMore
          ? _self.loadingMore
          : loadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      sending: null == sending
          ? _self.sending
          : sending // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [ChatThreadState].
extension ChatThreadStatePatterns on ChatThreadState {
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
    TResult Function(_ChatThreadState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChatThreadState() when $default != null:
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
    TResult Function(_ChatThreadState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatThreadState():
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
    TResult? Function(_ChatThreadState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatThreadState() when $default != null:
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
    TResult Function(List<ChatMessage> messages, bool hasMore, bool loadingMore,
            bool sending)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChatThreadState() when $default != null:
        return $default(
            _that.messages, _that.hasMore, _that.loadingMore, _that.sending);
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
    TResult Function(List<ChatMessage> messages, bool hasMore, bool loadingMore,
            bool sending)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatThreadState():
        return $default(
            _that.messages, _that.hasMore, _that.loadingMore, _that.sending);
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
    TResult? Function(List<ChatMessage> messages, bool hasMore,
            bool loadingMore, bool sending)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatThreadState() when $default != null:
        return $default(
            _that.messages, _that.hasMore, _that.loadingMore, _that.sending);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ChatThreadState implements ChatThreadState {
  const _ChatThreadState(
      {final List<ChatMessage> messages = const <ChatMessage>[],
      this.hasMore = false,
      this.loadingMore = false,
      this.sending = false})
      : _messages = messages;

  /// Newest first.
  final List<ChatMessage> _messages;

  /// Newest first.
  @override
  @JsonKey()
  List<ChatMessage> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  /// Older messages exist on the server.
  @override
  @JsonKey()
  final bool hasMore;
  @override
  @JsonKey()
  final bool loadingMore;
  @override
  @JsonKey()
  final bool sending;

  /// Create a copy of ChatThreadState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ChatThreadStateCopyWith<_ChatThreadState> get copyWith =>
      __$ChatThreadStateCopyWithImpl<_ChatThreadState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ChatThreadState &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.loadingMore, loadingMore) ||
                other.loadingMore == loadingMore) &&
            (identical(other.sending, sending) || other.sending == sending));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_messages),
      hasMore,
      loadingMore,
      sending);

  @override
  String toString() {
    return 'ChatThreadState(messages: $messages, hasMore: $hasMore, loadingMore: $loadingMore, sending: $sending)';
  }
}

/// @nodoc
abstract mixin class _$ChatThreadStateCopyWith<$Res>
    implements $ChatThreadStateCopyWith<$Res> {
  factory _$ChatThreadStateCopyWith(
          _ChatThreadState value, $Res Function(_ChatThreadState) _then) =
      __$ChatThreadStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<ChatMessage> messages,
      bool hasMore,
      bool loadingMore,
      bool sending});
}

/// @nodoc
class __$ChatThreadStateCopyWithImpl<$Res>
    implements _$ChatThreadStateCopyWith<$Res> {
  __$ChatThreadStateCopyWithImpl(this._self, this._then);

  final _ChatThreadState _self;
  final $Res Function(_ChatThreadState) _then;

  /// Create a copy of ChatThreadState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? messages = null,
    Object? hasMore = null,
    Object? loadingMore = null,
    Object? sending = null,
  }) {
    return _then(_ChatThreadState(
      messages: null == messages
          ? _self._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<ChatMessage>,
      hasMore: null == hasMore
          ? _self.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      loadingMore: null == loadingMore
          ? _self.loadingMore
          : loadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      sending: null == sending
          ? _self.sending
          : sending // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
