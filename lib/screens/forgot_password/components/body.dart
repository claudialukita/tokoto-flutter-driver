import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/components/no_account_text.dart';
import 'package:shop_app/screens/forgot_password/components/forgot_pass_form_view_model.dart';
import 'package:shop_app/screens/forgot_password/forgot_password_view_model.dart';
import 'package:shop_app/size_config.dart';

import '../../../constants.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Please enter your email and we will send \nyou a link to return to your account",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var state = watch(forgotPassFormViewModelProvider);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            key: Key("forgot_password_form_text_input_email"),
            keyboardType: TextInputType.emailAddress,
            controller: _emailTextController,
            onChanged: (value) {
              if (value.isNotEmpty && state.errors.contains(kEmailNullError)) {
                context
                    .read(forgotPassFormViewModelProvider.notifier)
                    .removeError(kEmailNullError);
              } else if (emailValidatorRegExp.hasMatch(value) &&
                  state.errors.contains(kInvalidEmailError)) {
                context
                    .read(forgotPassFormViewModelProvider.notifier)
                    .removeError(kInvalidEmailError);
              }
              return null;
            },
            validator: (value) {
              if (value!.isEmpty && !state.errors.contains(kEmailNullError)) {
                context
                    .read(forgotPassFormViewModelProvider.notifier)
                    .addError(kEmailNullError);
                return "";
              } else if (!emailValidatorRegExp.hasMatch(value)) {
                context
                    .read(forgotPassFormViewModelProvider.notifier)
                    .addError(kInvalidEmailError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: state.errors),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          DefaultButton(
            text: "Continue",
            press: () {
              if (_formKey.currentState!.validate()) {
                print("masuk");
                context
                    .read(forgotPasswordViewModelProvider.notifier)
                    .forgotPassword(_emailTextController.text);
              }
            },
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          NoAccountText(),
        ],
      ),
    );
  }
}
