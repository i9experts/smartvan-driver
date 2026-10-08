import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smartvan_driver/core/providers/image_picker_provider.dart';
import 'package:smartvan_driver/core/network/app_exception.dart';
import 'package:smartvan_driver/features/checklist/application/checklist_providers.dart';
import 'package:smartvan_driver/features/checklist/application/submit_checklist_controller.dart';
import 'package:smartvan_driver/features/checklist/data/checklist_repository.dart';
import 'package:smartvan_driver/features/checklist/data/models/checklist_answer.dart';
import 'package:smartvan_driver/features/checklist/data/models/checklist_item_def.dart';
import 'package:smartvan_driver/features/checklist/data/models/today_checklist.dart';
import 'package:smartvan_driver/features/checklist/presentation/screens/checklist_screen.dart';
import 'package:smartvan_driver/features/profile/data/profile_repository.dart';
import 'package:smartvan_driver/core/network/json_helpers.dart';

import '../../support/fake_files.dart';
import '../../support/fixture.dart';
import '../../support/l10n_host.dart';

class _FakeChecklistRepo extends Mock implements ChecklistRepository {}

class _FakeProfileRepo extends Mock implements ProfileRepository {}

class _FakePicker extends Mock implements ImagePicker {}

void main() {
  late _FakeChecklistRepo repo;
  late _FakeProfileRepo profileRepo;
  late _FakePicker picker;
  final f = fixtureMap('checklist/checklist.json');
  late TodayChecklist today;
  late List<ChecklistItemDef> items;

  setUpAll(() {
    registerFallbackValue(File('x'));
    registerFallbackValue(<ChecklistAnswer>[]);
    registerFallbackValue(ImageSource.camera);
  });

  setUp(() {
    repo = _FakeChecklistRepo();
    profileRepo = _FakeProfileRepo();
    picker = _FakePicker();
    today = TodayChecklist.fromJson(
        Map<String, dynamic>.from(f['todayNotDone'] as Map));
    items = asJsonList(unwrapData(f['items']))
        .map(ChecklistItemDef.fromJson)
        .toList();
    when(() => repo.items()).thenAnswer((_) async => items);
    when(() => repo.today()).thenAnswer((_) async => today);
    when(() => repo.submit(
          routeId: any(named: 'routeId'),
          answers: any(named: 'answers'),
          photoUrl: any(named: 'photoUrl'),
        )).thenAnswer((_) async {});
  });

  List<Override> overrides() => [
        checklistRepositoryProvider.overrideWithValue(repo),
        profileRepositoryProvider.overrideWithValue(profileRepo),
        imagePickerProvider.overrideWithValue(picker),
      ];

  group('providers and controller', () {
    test('todayChecklist and checklistFormData load from the repository',
        () async {
      final c = ProviderContainer(overrides: overrides());
      addTearDown(c.dispose);
      expect((await c.read(todayChecklistProvider.future)).done, isFalse);
      final form = await c.read(checklistFormDataProvider.future);
      expect(form.items.map((i) => i.key), ['tyres', 'brakes']);
    });

    test('submit without a photo sends the answers and refreshes today',
        () async {
      final c = ProviderContainer(overrides: overrides());
      addTearDown(c.dispose);
      final sub = c.listen(todayChecklistProvider, (_, __) {});
      addTearDown(sub.close);
      await c.read(todayChecklistProvider.future);
      clearInteractions(repo);

      final ok = await c
          .read(submitChecklistControllerProvider.notifier)
          .submit(
              routeId: 'route-001',
              answers: const [ChecklistAnswer(key: 'tyres', ok: true)],
              existingPhotoUrl: 'https://example.test/old.png');
      expect(ok, ChecklistSubmitResult.saved);
      verify(() => repo.submit(
          routeId: 'route-001',
          answers: const [ChecklistAnswer(key: 'tyres', ok: true)],
          photoUrl: 'https://example.test/old.png')).called(1);
      verifyNever(() => profileRepo.uploadImage(any()));
      await c.read(todayChecklistProvider.future);
      verify(() => repo.today()).called(1); // refreshed
    });

    test('a new photo is uploaded first and its URL sent', () async {
      final photo = tempImage('smartvan_check_test.png');
      addTearDown(photo.deleteSync);
      when(() => profileRepo.uploadImage(any()))
          .thenAnswer((_) async => 'https://example.test/new.png');
      final c = ProviderContainer(overrides: overrides());
      addTearDown(c.dispose);
      await c.read(submitChecklistControllerProvider.notifier).submit(
          answers: const [ChecklistAnswer(key: 'tyres', ok: true)],
          photo: photo,
          existingPhotoUrl: 'https://example.test/old.png');
      verify(() => repo.submit(
          routeId: null,
          answers: const [ChecklistAnswer(key: 'tyres', ok: true)],
          photoUrl: 'https://example.test/new.png')).called(1);
    });

    test('a photo that cannot be uploaded saves nothing and says so', () async {
      final photo = tempImage('smartvan_check_test2.png');
      addTearDown(photo.deleteSync);
      when(() => profileRepo.uploadImage(any()))
          .thenThrow(const ApiError(code: 'UPLOAD_FAILED', status: 200));
      final c = ProviderContainer(overrides: overrides());
      addTearDown(c.dispose);
      final result = await c
          .read(submitChecklistControllerProvider.notifier)
          .submit(
              answers: const [ChecklistAnswer(key: 'tyres', ok: true)],
              photo: photo,
              existingPhotoUrl: 'https://example.test/old.png');
      expect(result, ChecklistSubmitResult.photoUploadFailed);
      expect(c.read(submitChecklistControllerProvider).hasError, isFalse);
      verifyNever(() => repo.submit(
          routeId: any(named: 'routeId'),
          answers: any(named: 'answers'),
          photoUrl: any(named: 'photoUrl')));
    });

    test('a network failure while uploading is also a photo failure',
        () async {
      final photo = tempImage('smartvan_check_test3.png');
      addTearDown(photo.deleteSync);
      when(() => profileRepo.uploadImage(any()))
          .thenThrow(const NetworkException());
      final c = ProviderContainer(overrides: overrides());
      addTearDown(c.dispose);
      final result = await c
          .read(submitChecklistControllerProvider.notifier)
          .submit(
              answers: const [ChecklistAnswer(key: 'tyres', ok: true)],
              photo: photo);
      expect(result, ChecklistSubmitResult.photoUploadFailed);
    });

    test('withoutPhoto skips the upload and keeps the saved photo', () async {
      final photo = tempImage('smartvan_check_test4.png');
      addTearDown(photo.deleteSync);
      final c = ProviderContainer(overrides: overrides());
      addTearDown(c.dispose);
      final result = await c
          .read(submitChecklistControllerProvider.notifier)
          .submit(
              answers: const [ChecklistAnswer(key: 'tyres', ok: true)],
              photo: photo,
              existingPhotoUrl: 'https://example.test/old.png',
              withoutPhoto: true);
      expect(result, ChecklistSubmitResult.saved);
      verifyNever(() => profileRepo.uploadImage(any()));
      verify(() => repo.submit(
          routeId: null,
          answers: any(named: 'answers'),
          photoUrl: 'https://example.test/old.png')).called(1);
    });

    test('a failing save is reported as failed', () async {
      when(() => repo.submit(
              routeId: any(named: 'routeId'),
              answers: any(named: 'answers'),
              photoUrl: any(named: 'photoUrl')))
          .thenThrow(const NetworkException());
      final c = ProviderContainer(overrides: overrides());
      addTearDown(c.dispose);
      final result = await c
          .read(submitChecklistControllerProvider.notifier)
          .submit(answers: const [ChecklistAnswer(key: 'tyres', ok: true)]);
      expect(result, ChecklistSubmitResult.failed);
    });
  });

  Widget screen({String? routeId}) => routerHost(
        {
          '/checklist': (_) => ChecklistScreen(routeId: routeId),
          '/start': (_) => Builder(
                builder: (context) => TextButton(
                  onPressed: () => context.push('/checklist'),
                  child: const Text('open'),
                ),
              ),
        },
        initial: '/start',
        overrides: overrides(),
      );

  group('ChecklistScreen', () {
    testWidgets('lists the questions; the button counts answers',
        (tester) async {
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('Daily van check'), findsOneWidget);
      expect(find.text('Check each item before your first trip today.'),
          findsOneWidget);
      expect(find.text('Tyres look fine'), findsOneWidget);
      expect(find.text('Brakes work'), findsOneWidget);
      expect(find.text('Answer all items (0/2)'), findsOneWidget);
      expect(find.text('Add a photo (optional)'), findsOneWidget);

      await tester.tap(find.text('OK').first);
      await tester.pump();
      expect(find.text('Answer all items (1/2)'), findsOneWidget);
    });

    testWidgets('all OK: submit and pop true', (tester) async {
      await tester.pumpWidget(screen(routeId: 'route-001'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK').at(0));
      await tester.tap(find.text('OK').at(1));
      await tester.pump();
      expect(find.text('Submit — all OK'), findsOneWidget);
      await tester.tap(find.text('Submit — all OK'));
      await tester.pumpAndSettle();
      verify(() => repo.submit(
          routeId: 'route-001',
          answers: const [
            ChecklistAnswer(key: 'tyres', ok: true),
            ChecklistAnswer(key: 'brakes', ok: true),
          ],
          photoUrl: null)).called(1);
      // Popped back to the page that opened it.
      expect(find.text('open'), findsOneWidget);
      expect(find.text('Daily van check'), findsNothing);
    });

    testWidgets('an issue shows a note field and reports with the note',
        (tester) async {
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK').at(0));
      await tester.tap(find.text('Issue').at(1));
      await tester.pump();
      expect(find.text('What is the problem? (optional)'), findsOneWidget);
      expect(find.text('Submit and report 1 issue'), findsOneWidget);
      await tester.enterText(find.byType(TextField), '  Pedal feels soft ');
      await tester.tap(find.text('Submit and report 1 issue'));
      await tester.pumpAndSettle();
      verify(() => repo.submit(
          routeId: null,
          answers: const [
            ChecklistAnswer(key: 'tyres', ok: true),
            ChecklistAnswer(key: 'brakes', ok: false, note: 'Pedal feels soft'),
          ],
          photoUrl: null)).called(1);
    });

    testWidgets('two issues are plural', (tester) async {
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Issue').at(0));
      await tester.tap(find.text('Issue').at(1));
      await tester.pump();
      expect(find.text('Submit and report 2 issues'), findsOneWidget);
    });

    testWidgets("re-opening today's check pre-fills the answers",
        (tester) async {
      today = TodayChecklist.fromJson(
          Map<String, dynamic>.from(f['todayDone'] as Map));
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('Submit and report 1 issue'), findsOneWidget);
      expect(find.text('Pedal feels soft'), findsOneWidget); // note
      expect(find.text('Photo added'), findsOneWidget);
      expect(find.text('Retake'), findsOneWidget);
    });

    testWidgets('a failed save shows the reason and stays', (tester) async {
      when(() => repo.submit(
              routeId: any(named: 'routeId'),
              answers: any(named: 'answers'),
              photoUrl: any(named: 'photoUrl')))
          .thenThrow(const NetworkException());
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK').at(0));
      await tester.tap(find.text('OK').at(1));
      await tester.pump();
      await tester.tap(find.text('Submit — all OK'));
      await tester.pumpAndSettle();
      expect(
          find.text(
              'No internet connection. Please check your network and try again.'),
          findsOneWidget);
      expect(find.text('Daily van check'), findsOneWidget);
    });

    group('when the photo cannot be uploaded', () {
      late File photo;

      Future<void> fillAndSubmit(WidgetTester tester) async {
        photo = tempImage('smartvan_check_widget.png');
        addTearDown(photo.deleteSync);
        when(() => picker.pickImage(
              source: any(named: 'source'),
              imageQuality: any(named: 'imageQuality'),
              maxWidth: any(named: 'maxWidth'),
            )).thenAnswer((_) async => XFile(photo.path));
        when(() => profileRepo.uploadImage(any()))
            .thenThrow(const NetworkException());
        await tester.pumpWidget(screen());
        await tester.pumpAndSettle();
        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Take'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK').at(0));
        await tester.tap(find.text('OK').at(1));
        await tester.pump();
        await tester.tap(find.text('Submit — all OK'));
        await tester.pumpAndSettle();
      }

      testWidgets('asks, and cancel keeps the form without saving',
          (tester) async {
        await fillAndSubmit(tester);
        expect(find.text('Photo could not be uploaded'), findsOneWidget);
        expect(find.text('Submit the van check without the photo?'),
            findsOneWidget);
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
        expect(find.text('Daily van check'), findsOneWidget);
        verifyNever(() => repo.submit(
            routeId: any(named: 'routeId'),
            answers: any(named: 'answers'),
            photoUrl: any(named: 'photoUrl')));
      });

      testWidgets('"Submit without photo" saves without it', (tester) async {
        await fillAndSubmit(tester);
        await tester.tap(find.text('Submit without photo'));
        await tester.pumpAndSettle();
        verify(() => repo.submit(
            routeId: null,
            answers: any(named: 'answers'),
            photoUrl: null)).called(1);
        expect(find.text('Daily van check'), findsNothing);
      });
    });

    testWidgets('load failure shows Try again', (tester) async {
      var fail = true;
      when(() => repo.items()).thenAnswer((_) async {
        if (fail) throw const ApiError(status: 500);
        return items;
      });
      await tester.pumpWidget(screen());
      await tester.pumpAndSettle();
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('Try again'), findsOneWidget);
      fail = false;
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();
      expect(find.text('Tyres look fine'), findsOneWidget);
    });
  });
}
