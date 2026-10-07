import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartvan_driver/core/widgets/form_widgets.dart';
import 'package:smartvan_driver/core/widgets/screen_header.dart';

import '../../support/l10n_host.dart';

void main() {
  testWidgets('LabeledField shows its label and takes input', (tester) async {
    final c = TextEditingController();
    await tester.pumpWidget(l10nHost(LabeledField(
        label: 'Full Name', controller: c, icon: Icons.person_outlined)));
    expect(find.text('Full Name'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), 'Test Driver');
    expect(c.text, 'Test Driver');
  });

  testWidgets('a password LabeledField toggles through the eye button',
      (tester) async {
    var obscure = true;
    late StateSetter set;
    final c = TextEditingController();
    await tester
        .pumpWidget(l10nHost(StatefulBuilder(builder: (context, setState) {
      set = setState;
      return LabeledField(
        label: 'Password',
        controller: c,
        icon: Icons.lock_outlined,
        obscureText: obscure,
        onToggleObscure: () => set(() => obscure = !obscure),
      );
    })));
    expect(tester.widget<EditableText>(find.byType(EditableText)).obscureText,
        isTrue);
    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pump();
    expect(tester.widget<EditableText>(find.byType(EditableText)).obscureText,
        isFalse);
  });

  testWidgets('a plain LabeledField has no eye button', (tester) async {
    await tester.pumpWidget(l10nHost(LabeledField(
        label: 'x',
        controller: TextEditingController(),
        icon: Icons.home_outlined)));
    expect(find.byType(IconButton), findsNothing);
  });

  testWidgets('PrimaryActionButton: label, tap, loading', (tester) async {
    var taps = 0;
    await tester.pumpWidget(l10nHost(PrimaryActionButton(
        label: 'Update Profile',
        trailingIcon: Icons.arrow_forward,
        onPressed: () => taps++)));
    await tester.tap(find.text('Update Profile'));
    expect(taps, 1);
    expect(find.byIcon(Icons.arrow_forward), findsOneWidget);

    await tester.pumpWidget(l10nHost(PrimaryActionButton(
        label: 'Update Profile', loading: true, onPressed: () => taps++)));
    expect(find.text('Update Profile'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.byType(ElevatedButton));
    expect(taps, 1);
  });

  testWidgets('ScreenHeader shows the title and back button works',
      (tester) async {
    var backs = 0;
    await tester.pumpWidget(
        l10nHost(ScreenHeader(title: 'Documents', onBack: () => backs++)));
    expect(find.text('Documents'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    expect(backs, 1);
  });
}
