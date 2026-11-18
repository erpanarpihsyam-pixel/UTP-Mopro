import 'package:flutter_test/flutter_test.dart';
import 'package:mopro_utp/main.dart';

void main() {
  testWidgets('Aplikasi SeduhKopi dapat dimuat dengan baik', (WidgetTester tester) async {
    // Build aplikasi SeduhKopi
    await tester.pumpWidget(const SeduhKopiApp());

    // Verifikasi bahwa judul aplikasi muncul di AppBar
    expect(find.text('SeduhKopi'), findsOneWidget);
  });
}
