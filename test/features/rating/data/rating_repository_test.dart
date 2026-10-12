import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/features/rating/data/rating_repository.dart';

import '../../../support/api_env.dart';
import '../../../support/fixture.dart';

void main() {
  late ApiTestEnv env;
  late RatingRepository repo;

  setUp(() {
    env = ApiTestEnv();
    repo = RatingRepository(env.client);
  });

  test('mySummary GETs /rating/myRatingSummary', () async {
    env.adapter.onGet('/rating/myRatingSummary',
        (s) => s.reply(200, fixture('rating/my_rating_summary.json')));
    final s = await repo.mySummary();
    expect(s.avgRating, 4.6);
    expect(s.completedTripCount, 87);
  });

  test('mySummary accepts a body without the data envelope', () async {
    env.adapter.onGet(
        '/rating/myRatingSummary',
        (s) => s.reply(
            200, {'avgRating': 5, 'ratingCount': 1, 'completedTripCount': 2}));
    expect((await repo.mySummary()).ratingCount, 1);
  });

  test('pendingForTrip keeps only the rows of that trip', () async {
    env.adapter.onGet('/rating/pendingRatings',
        (s) => s.reply(200, fixture('rating/pending_ratings.json')));
    final rows = await repo.pendingForTrip('trip-001');
    expect(rows.map((r) => r.parentId), ['p-1', 'p-2']);
    expect(await repo.pendingForTrip('nope'), isEmpty);
  });

  test('pendingForTrip: an empty answer is an empty list', () async {
    env.adapter
        .onGet('/rating/pendingRatings', (s) => s.reply(200, {'data': []}));
    expect(await repo.pendingForTrip('trip-001'), isEmpty);
  });

  test('rateTrip POSTs the rating with the comment', () async {
    env.record();
    env.adapter.onPost(
      '/rating/rateTrip',
      (s) => s.reply(201, {'message': 'ok'}),
      data: {
        'tripId': 'trip-001',
        'rateeUserId': 'p-1',
        'stars': 4,
        'comment': 'Waited at the gate',
      },
    );
    await repo.rateTrip(
        tripId: 'trip-001',
        rateeUserId: 'p-1',
        stars: 4,
        comment: 'Waited at the gate');
    expect(env.lastRequest!.path, '/rating/rateTrip');
  });

  test('rateTrip leaves the comment out when empty', () async {
    env.adapter.onPost(
      '/rating/rateTrip',
      (s) => s.reply(201, {}),
      data: {'tripId': 't', 'rateeUserId': 'p', 'stars': 5},
    );
    await repo.rateTrip(tripId: 't', rateeUserId: 'p', stars: 5, comment: '');
  });

  test('server error maps to ServerException', () async {
    env.adapter.onGet('/rating/pendingRatings', (s) => s.reply(500, {}));
    await expectLater(
        repo.pendingForTrip('t'), throwsA(isA<ServerException>()));
  });
}
