import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/helper/keyboard.dart';
import 'package:shop_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:shop_app/screens/sign_in/components/sign_form_state.dart';
import 'package:shop_app/screens/sign_in/components/sign_form_view_model.dart';
import 'package:shop_app/screens/sign_in/sign_in_view_model.dart';

import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    SignFormState state = watch(signFormViewModelProvider);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(context),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(context),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              Checkbox(
                value: state.isRemember,
                activeColor: kPrimaryColor,
                onChanged: (value) {},
              ),
              Text("Remember me"),
              Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: state.errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Continue",
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // if all are valid then go to success screen
                KeyboardUtil.hideKeyboard(context);
                context.read(signInViewModelProvider.notifier).login(_emailTextController.text, _passwordTextController.text);
//                Navigator.pushNamed(context, HomeScreen.routeName);
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField(BuildContext context) {
    return TextFormField(
      key: Key("sign_form_text_input_password"),
      obscureText: true,
      controller: _passwordTextController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          context.read(signFormViewModelProvider.notifier).removeError(kPassNullError);
        } else if (value.length >= 4) {
          context.read(signFormViewModelProvider.notifier).removeError(kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          context.read(signFormViewModelProvider.notifier).addError(kPassNullError);
          return "";
        } else if (value.length < 4) {
          context.read(signFormViewModelProvider.notifier).addError(kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField(BuildContext context) {
    return TextFormField(
      key: Key("sign_form_text_input_email"),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          context.read(signFormViewModelProvider.notifier).removeError(kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          context.read(signFormViewModelProvider.notifier).removeError(kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          context.read(signFormViewModelProvider.notifier).addError(kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          context.read(signFormViewModelProvider.notifier).addError(kInvalidEmailError);
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
    );
  }
}
