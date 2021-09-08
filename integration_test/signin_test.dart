import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shop_app/components/custom_dialog.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/main.dart';
import 'package:shop_app/providers/dio_provider.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/screens/sign_in/sign_in_model.dart';

import 'mock/login_response.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('login tests', () {
    testWidgets('login success test', (WidgetTester tester) async {
      final mockDioProvider = Dio(BaseOptions());
      final dioAdapter = DioAdapter(dio: mockDioProvider);
      const path = '$SERVICE_URL/login';
      const mockedEmail = "test@gmail.com";
      const mockedPassword = "myPassword";

      SignInModel signInModel = new SignInModel(mockedEmail, mockedPassword);

      dioAdapter.onPost(
          path, (server) => server.reply(200, mockedLoginResponse),
          data: signInModel.toJson());

      runApp(ProviderScope(
          overrides: [dioProvider.overrideWithValue(mockDioProvider)],
          child: MyApp()));

      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key("sign_form_text_input_email")), mockedEmail);
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_form_text_input_password")), mockedPassword);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('login error response', (WidgetTester tester) async {
      final mockDioProvider = Dio(BaseOptions());
      final dioAdapter = DioAdapter(dio: mockDioProvider);
      const path = '$SERVICE_URL/login';
      const mockedEmail = "test@gmail.com";
      const mockedPassword = "myPassword";

      SignInModel signInModel = new SignInModel(mockedEmail, mockedPassword);

      dioAdapter.onPost(
          path, (server) => server.reply(400, mockedLoginResponseError),
          data: signInModel.toJson());

      runApp(ProviderScope(
          overrides: [dioProvider.overrideWithValue(mockDioProvider)],
          child: MyApp()));

      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_form_text_input_email")), mockedEmail);
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_form_text_input_password")), mockedPassword);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      expect(find.byType(CustomDialogBox), findsOneWidget);
    });

    testWidgets('login error null email input', (WidgetTester tester) async {
      const mockedEmail = "";
      const mockedPassword = "myPassword";

      runApp(ProviderScope(child: MyApp()));

      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_form_text_input_email")), mockedEmail);
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_form_text_input_password")), mockedPassword);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      expect(find.text(kEmailNullError), findsOneWidget);
    });

    testWidgets('login error invalid email input', (WidgetTester tester) async {
      const mockedEmail = "test";
      const mockedPassword = "myPassword";

      runApp(ProviderScope(child: MyApp()));

      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_form_text_input_email")), mockedEmail);
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_form_text_input_password")), mockedPassword);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      expect(find.text(kInvalidEmailError), findsOneWidget);
    });

    testWidgets('login error null password input', (WidgetTester tester) async {
      const mockedEmail = "admin@admin.com";
      const mockedPassword = "";

      runApp(ProviderScope(child: MyApp()));

      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_form_text_input_email")), mockedEmail);
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_form_text_input_password")), mockedPassword);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      expect(find.text(kPassNullError), findsOneWidget);
    });

    testWidgets('login error invalid password input', (WidgetTester tester) async {
      const mockedEmail = "admin@admin.com";
      const mockedPassword = "adm";

      runApp(ProviderScope(child: MyApp()));

      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_form_text_input_email")), mockedEmail);
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_form_text_input_password")), mockedPassword);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      expect(find.text(kShortPassError), findsOneWidget);
    });
  });
}
