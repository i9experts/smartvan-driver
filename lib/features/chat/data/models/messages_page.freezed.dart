// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'messages_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessagesPage {
  List<ChatMessage> get messages;

  /// `hasMore` — older messages exist.
  bool get hasMore;

  /// Create a copy of MessagesPage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MessagesPageCopyWith<MessagesPage> get copyWith =>
      _$MessagesPageCopyWithImpl<MessagesPage>(
          this as MessagesPage, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MessagesPage &&
            const DeepCollectionEquality().equals(other.messages, messages) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(messages), hasMore);

  @override
  String toString() {
    return 'MessagesPage(messages: $messages, hasMore: $hasMore)';
  }
}

/// @nodoc
abstract mixin class $MessagesPageCopyWith<$Res> {
  factory $MessagesPageCopyWith(
          MessagesPage value, $Res Function(MessagesPage) _then) =
      _$MessagesPageCopyWithImpl;
  @useResult
  $Res call({List<ChatMessage> messages, bool hasMore});
}

/// @nodoc
class _$MessagesPageCopyWithImpl<$Res> implements $MessagesPageCopyWith<$Res> {
  _$MessagesPageCopyWithImpl(this._self, this._then);

  final MessagesPage _self;
  final $Res Function(MessagesPage) _then;

  /// Create a copy of MessagesPage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messages = null,
    Object? hasMore = null,
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
    ));
  }
}

/// Adds pattern-matching-related methods to [MessagesPage].
extension MessagesPagePatterns on MessagesPage {
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
    TResult Function(_MessagesPage value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MessagesPage() when $default != null:
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
    TResult Function(_MessagesPage value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MessagesPage():
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
    TResult? Function(_MessagesPage value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MessagesPage() when $default != null:
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
    TResult Function(List<ChatMessage> messages, bool hasMore)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MessagesPage() when $default != null:
        return $default(_that.messages, _that.hasMore);
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
    TResult Function(List<ChatMessage> messages, bool hasMore) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MessagesPage():
        return $default(_that.messages, _that.hasMore);
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
    TResult? Function(List<ChatMessage> messages, bool hasMore)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MessagesPage() when $default != null:
        return $default(_that.messages, _that.hasMore);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MessagesPage implements MessagesPage {
  const _MessagesPage(
      {final List<ChatMessage> messages = const <ChatMessage>[],
      this.hasMore = false})
      : _messages = messages;

  final List<ChatMessage> _messages;
  @override
  @JsonKey()
  List<ChatMessage> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  /// `hasMore` — older messages exist.
  @override
  @JsonKey()
  final bool hasMore;

  /// Create a copy of MessagesPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MessagesPageCopyWith<_MessagesPage> get copyWith =>
      __$MessagesPageCopyWithImpl<_MessagesPage>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MessagesPage &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_messages), hasMore);

  @override
  String toString() {
    return 'MessagesPage(messages: $messages, hasMore: $hasMore)';
  }
}

/// @nodoc
abstract mixin class _$MessagesPageCopyWith<$Res>
    implements $MessagesPageCopyWith<$Res> {
  factory _$MessagesPageCopyWith(
          _MessagesPage value, $Res Function(_MessagesPage) _then) =
      __$MessagesPageCopyWithImpl;
  @override
  @useResult
  $Res call({List<ChatMessage> messages, bool hasMore});
}

/// @nodoc
class __$MessagesPageCopyWithImpl<$Res>
    implements _$MessagesPageCopyWith<$Res> {
  __$MessagesPageCopyWithImpl(this._self, this._then);

  final _MessagesPage _self;
  final $Res Function(_MessagesPage) _then;

  /// Create a copy of MessagesPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? messages = null,
    Object? hasMore = null,
  }) {
    return _then(_MessagesPage(
      messages: null == messages
          ? _self._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<ChatMessage>,
      hasMore: null == hasMore
          ? _self.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
