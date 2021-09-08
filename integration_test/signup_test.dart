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
import 'package:shop_app/screens/complete_profile/complete_profile_screen.dart';
import 'package:shop_app/screens/sign_up/sign_up_model.dart';

import 'mock/signup_response.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('sign up tests', () {
    testWidgets('sign up success test', (WidgetTester tester) async {
      final mockDioProvider = Dio(BaseOptions());
      final dioAdapter = DioAdapter(dio: mockDioProvider);
      const path = '$SERVICE_URL/signup';
      const mockedEmail = "test@gmail.com";
      const mockedPassword = "myPassword";

      SignUpModel signUpModel = new SignUpModel(mockedEmail, mockedPassword);

      dioAdapter.onPost(
          path, (server) => server.reply(200, mockedSignUpResponse),
          data: signUpModel.toJson());

      runApp(ProviderScope(
          overrides: [dioProvider.overrideWithValue(mockDioProvider)],
          child: MyApp()));

      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(GestureDetector, "Sign Up"));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_up_form_text_input_email")), mockedEmail);
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_up_form_text_input_password")), mockedPassword);
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_up_form_text_input_confirm_password")), mockedPassword);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      expect(find.byType(CompleteProfileScreen), findsOneWidget);
    });

    testWidgets('sign up null input', (WidgetTester tester) async {

      runApp(ProviderScope(child: MyApp()));

      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(GestureDetector, "Sign Up"));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      expect(find.text(kEmailNullError), findsOneWidget);
      expect(find.text(kPassNullError), findsOneWidget);
    });

    testWidgets('sign up null email input', (WidgetTester tester) async {
      const mockedPassword = "myPassword";

      runApp(ProviderScope(child: MyApp()));

      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(GestureDetector, "Sign Up"));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_up_form_text_input_password")), mockedPassword);
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_up_form_text_input_confirm_password")), mockedPassword);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      expect(find.text(kEmailNullError), findsOneWidget);
    });

    testWidgets('sign up wrong email format input', (WidgetTester tester) async {
      const mockedEmail = "email";
      const mockedPassword = "myPassword";

      runApp(ProviderScope(child: MyApp()));

      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(GestureDetector, "Sign Up"));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_up_form_text_input_email")), mockedEmail);
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_up_form_text_input_password")), mockedPassword);
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_up_form_text_input_confirm_password")), mockedPassword);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      expect(find.text(kInvalidEmailError), findsOneWidget);
    });

    testWidgets('sign up null password input', (WidgetTester tester) async {
      const mockedEmail = "dummysignup@gmail.com";

      runApp(ProviderScope(child: MyApp()));

      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(GestureDetector, "Sign Up"));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_up_form_text_input_email")), mockedEmail);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      expect(find.text(kPassNullError), findsOneWidget);
    });

    testWidgets('sign up not match password input', (WidgetTester tester) async {
      const mockedEmail = "dummysignup@gmail.com";
      const mockedPassword = "myPassword";
      const mockedConfirmPassword = "myConfirmPassword";

      runApp(ProviderScope(child: MyApp()));

      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(GestureDetector, "Sign Up"));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_up_form_text_input_email")), mockedEmail);
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_up_form_text_input_password")), mockedPassword);
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_up_form_text_input_confirm_password")), mockedConfirmPassword);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      expect(find.text(kMatchPassError), findsOneWidget);
    });

    testWidgets('sign up null confirm password input', (WidgetTester tester) async {
      const mockedEmail = "dummysignup@gmail.com";
      const mockedPassword = "myPassword";

      runApp(ProviderScope(child: MyApp()));

      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(GestureDetector, "Sign Up"));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_up_form_text_input_email")), mockedEmail);
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_up_form_text_input_password")), mockedPassword);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      expect(find.text(kPassNullError), findsOneWidget);
    });

  });

  group('complete profile tests', () {
    testWidgets('complete profile success test', (WidgetTester tester) async {
      final mockDioProvider = Dio(BaseOptions());
      final dioAdapter = DioAdapter(dio: mockDioProvider);
      const path = '$SERVICE_URL/signup';
      const mockedFirstName = "dummyFirstName";
      const mockedLastName = "dummyLastName";
      const mockedPhoneNumber = "dummyPhoneNumber";
      const mockedAddress = "dummyAddress";
      const mockedEmail = "test@gmail.com";
      const mockedPassword = "myPassword";

      SignUpModel signUpModel = new SignUpModel(mockedEmail, mockedPassword);

      dioAdapter.onPost(
          path, (server) => server.reply(200, mockedSignUpResponse),
          data: signUpModel.toJson());

      runApp(ProviderScope(
          overrides: [dioProvider.overrideWithValue(mockDioProvider)],
          child: MyApp()));

      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(GestureDetector, "Sign Up"));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_up_form_text_input_email")), mockedEmail);
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_up_form_text_input_password")), mockedPassword);
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_up_form_text_input_confirm_password")), mockedPassword);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("complete_profile_form_text_input_first_name")), mockedFirstName);
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("complete_profile_form_text_input_last_name")), mockedLastName);
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("complete_profile_form_text_input_phone_number")), mockedPhoneNumber);
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("complete_profile_form_text_input_address")), mockedAddress);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "continue"));
      await tester.pumpAndSettle();
      expect(find.byType(CustomDialogBox), findsOneWidget);
    });

    testWidgets('complete profile null input', (WidgetTester tester) async {

      final mockDioProvider = Dio(BaseOptions());
      final dioAdapter = DioAdapter(dio: mockDioProvider);
      const path = '$SERVICE_URL/signup';
      const mockedEmail = "test@gmail.com";
      const mockedPassword = "myPassword";

      SignUpModel signUpModel = new SignUpModel(mockedEmail, mockedPassword);

      dioAdapter.onPost(
          path, (server) => server.reply(200, mockedSignUpResponse),
          data: signUpModel.toJson());

      runApp(ProviderScope(
          overrides: [dioProvider.overrideWithValue(mockDioProvider)],
          child: MyApp()));

      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(GestureDetector, "Sign Up"));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_up_form_text_input_email")), mockedEmail);
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_up_form_text_input_password")), mockedPassword);
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("sign_up_form_text_input_confirm_password")), mockedPassword);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "Continue"));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DefaultButton, "continue"));
      await tester.pumpAndSettle();
      expect(find.text(kNamelNullError), findsOneWidget);
      expect(find.text(kPhoneNumberNullError), findsOneWidget);
      expect(find.text(kAddressNullError), findsOneWidget);
    });
  });

}
