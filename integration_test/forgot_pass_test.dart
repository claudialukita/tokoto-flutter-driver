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
import 'package:shop_app/screens/forgot_password/forgot_password_model.dart';
import 'package:shop_app/screens/forgot_password/forgot_password_screen.dart';

import 'mock/forgot_password_response.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('forgot password tests', () {
    testWidgets('forgot password success test', (WidgetTester tester) async {
      final mockDioProvider = Dio(BaseOptions());
      final dioAdapter = DioAdapter(dio: mockDioProvider);
      const path = '$SERVICE_URL/forgotpassword';
      const mockedEmail = "test@gmail.com";

      ForgotPasswordModel forgotPasswordModel =
          new ForgotPasswordModel(mockedEmail);

      dioAdapter.onPost(
          path, (server) => server.reply(200, mockedForgotPasswordResponse),
          data: forgotPasswordModel.toJson());

      runApp(ProviderScope(
          overrides: [dioProvider.overrideWithValue(mockDioProvider)],
          child: MyApp()));

      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(GestureDetector, "Forgot Password"));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("forgot_password_form_text_input_email")), mockedEmail);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      expect(find.byType(ForgotPasswordScreen), findsOneWidget);
    });

    testWidgets('forgot password error response', (WidgetTester tester) async {
      final mockDioProvider = Dio(BaseOptions());
      final dioAdapter = DioAdapter(dio: mockDioProvider);
      const path = '$SERVICE_URL/forgotpassword';
      const mockedEmail = "test@gmail.com";

      ForgotPasswordModel forgotPasswordModel =
      new ForgotPasswordModel(mockedEmail);

      dioAdapter.onPost(
          path, (server) => server.reply(200, mockedForgotPasswordResponseError),
          data: forgotPasswordModel.toJson());

      runApp(ProviderScope(
          overrides: [dioProvider.overrideWithValue(mockDioProvider)],
          child: MyApp()));

      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(GestureDetector, "Forgot Password"));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("forgot_password_form_text_input_email")), mockedEmail);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      expect(find.byType(CustomDialogBox), findsOneWidget);
    });

    testWidgets('forgot password error null email input', (WidgetTester tester) async {
      const mockedEmail = "";

      runApp(ProviderScope(child: MyApp()));

      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(GestureDetector, "Forgot Password"));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("forgot_password_form_text_input_email")), mockedEmail);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      expect(find.text(kEmailNullError), findsOneWidget);
    });

    testWidgets('forgot password error invalid email input', (WidgetTester tester) async {
      const mockedEmail = "test";
      const mockedPassword = "myPassword";

      runApp(ProviderScope(child: MyApp()));

      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(GestureDetector, "Forgot Password"));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("forgot_password_form_text_input_email")), mockedEmail);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      expect(find.text(kInvalidEmailError), findsOneWidget);
    });

  });
}
