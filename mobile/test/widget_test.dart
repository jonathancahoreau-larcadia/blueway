import 'package:flutter_test/flutter_test.dart';
import 'package:blueway/app/app.dart';
import 'package:blueway/features/home/presentation/home_screen.dart';

void main() {
  testWidgets('Affiche l’accueil BlueWay', (tester) async {
    await tester.pumpWidget(const MyApp(home: HomeScreen()));

    expect(find.text('BlueWay'), findsOneWidget);
    expect(find.text('Bienvenue sur BlueWay'), findsOneWidget);
  });

  testWidgets('Charge les signalements puis revient à l’accueil', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp(home: HomeScreen()));

    await tester.tap(find.text('Voir les signalements'));
    await tester.pumpAndSettle();

    expect(find.text('Chargement…'), findsOneWidget);
    expect(find.text('Obstacle signalé près du port'), findsNothing);

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Chargement…'), findsNothing);
    expect(find.text('Obstacle signalé près du port'), findsOneWidget);
    expect(find.text('Pollution observée au large'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('Bienvenue sur BlueWay'), findsOneWidget);
  });
}
