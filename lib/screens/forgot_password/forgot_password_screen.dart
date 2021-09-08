import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app/components/custom_dialog.dart';
import 'package:shop_app/screens/forgot_password/forgot_password_view_model.dart';

import 'components/body.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  static String routeName = "/forgot_password";
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var state = watch(forgotPasswordViewModelProvider);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if(state is AsyncData){
        if(state.value != null){
          showDialog(
              context: context,
              builder: (context) => CustomDialogBox(
                  title: "Success",
                  descriptions: "Password reset success",
                  text: "OK"));
        }
      }else if(state is AsyncError){
        showDialog(
            context: context,
            builder: (context) => CustomDialogBox(
                title: "Error",
                descriptions: state.error.toString(),
                text: "OK"));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
      body: Body(),
    );
  }
}
