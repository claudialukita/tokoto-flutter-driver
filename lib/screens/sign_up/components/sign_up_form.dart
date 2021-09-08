import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/screens/sign_up/components/sign_up_form_view_model.dart';
import 'package:shop_app/screens/sign_up/sign_up_view_model.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SignUpForm extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  final _passwordConformTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var state = watch(signUpFormViewModelProvider);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(context),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(context),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildConformPassFormField(context),
          FormError(errors: state.errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Continue",
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // if all are valid then go to success screen
//                Navigator.pushNamed(context, CompleteProfileScreen.routeName);
                context.read(signUpViewModelProvider.notifier).signUp(
                    _emailTextEditingController.text,
                    _passwordTextEditingController.text);
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildConformPassFormField(BuildContext context) {
    return TextFormField(
      key: Key("sign_up_form_text_input_confirm_password"),
      controller: _passwordConformTextEditingController,
      obscureText: true,
      onChanged: (value) {
        if (value.isNotEmpty) {
          context
              .read(signUpFormViewModelProvider.notifier)
              .removeError(kPassNullError);
        } else if (value.isNotEmpty &&
            _passwordTextEditingController.text ==
                _passwordConformTextEditingController.text) {
          context
              .read(signUpFormViewModelProvider.notifier)
              .removeError(kMatchPassError);
        }
      },
      validator: (value) {
        if (value!.isEmpty) {
          context
              .read(signUpFormViewModelProvider.notifier)
              .addError(kPassNullError);
          return "";
        } else if ((_passwordTextEditingController.text != value)) {
          context
              .read(signUpFormViewModelProvider.notifier)
              .addError(kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Confirm Password",
        hintText: "Re-enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildPasswordFormField(BuildContext context) {
    return TextFormField(
      key: Key("sign_up_form_text_input_password"),
      controller: _passwordTextEditingController,
      obscureText: true,
      onChanged: (value) {
        if (value.isNotEmpty) {
          context
              .read(signUpFormViewModelProvider.notifier)
              .removeError(kPassNullError);
        } else if (value.length >= 8) {
          context
              .read(signUpFormViewModelProvider.notifier)
              .removeError(kShortPassError);
        }
      },
      validator: (value) {
        if (value!.isEmpty) {
          context
              .read(signUpFormViewModelProvider.notifier)
              .addError(kPassNullError);
          return "";
        } else if (value.length < 8) {
          context
              .read(signUpFormViewModelProvider.notifier)
              .addError(kShortPassError);
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
      key: Key("sign_up_form_text_input_email"),
      controller: _emailTextEditingController,
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) {
        if (value.isNotEmpty) {
          context
              .read(signUpFormViewModelProvider.notifier)
              .removeError(kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          context
              .read(signUpFormViewModelProvider.notifier)
              .removeError(kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          context
              .read(signUpFormViewModelProvider.notifier)
              .addError(kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          context
              .read(signUpFormViewModelProvider.notifier)
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
    );
  }
}
