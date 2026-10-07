import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/l10n/error_text.dart';
import 'package:smartvan_driver/l10n/l10n.dart';

import '../support/l10n_host.dart';

void main() {
  late AppLocalizations l10n;
  setUpAll(() async => l10n = await loadL10n());

  test('network and server defaults come from the ARB', () {
    expect(errorText(l10n, const NetworkException()),
        'No internet connection. Please check your network and try again.');
    expect(errorText(l10n, const ServerException()),
        'Server is having trouble right now. Please try again shortly.');
    expect(errorText(l10n, const UnauthorizedException()),
        'Your session has expired. Please log in again.');
  });

  test('the server message wins over everything', () {
    expect(
        errorText(l10n, const ApiError(status: 400, message: 'Phone in use'),
            fallback: 'fb'),
        'Phone in use');
    expect(errorText(l10n, const ServerException('Boom', 500)), 'Boom');
    expect(errorText(l10n, const UnauthorizedException('Wrong password')),
        'Wrong password');
  });

  test('without a server message the screen fallback is used', () {
    expect(
        errorText(l10n, const ApiError(status: 404),
            fallback: 'Could not load your stats.'),
        'Could not load your stats.');
    expect(
        errorText(l10n, const UnknownException(), fallback: 'Could not load.'),
        'Could not load.');
  });

  test('no fallback gives the generic sentence', () {
    expect(errorText(l10n, const ApiError(status: 404)),
        'Something went wrong. Please try again.');
    expect(errorText(l10n, StateError('x')),
        'Something went wrong. Please try again.');
  });

  test('client-defined codes use ARB texts', () {
    expect(
        errorText(l10n,
            const ApiError(code: 'NO_TOKEN', status: 200, message: 'english')),
        'Login failed. Please try again.');
    expect(errorText(l10n, const ApiError(code: 'UPLOAD_FAILED', status: 200)),
        'Image upload failed. Please try again.');
  });

  test('raw DioException is converted first', () {
    final req = RequestOptions(path: '/x');
    final e = DioException(
        requestOptions: req, type: DioExceptionType.connectionError);
    expect(errorText(l10n, e), l10n.commonNoInternet);
  });
}
