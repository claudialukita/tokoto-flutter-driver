import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app/components/custom_dialog.dart';
import 'package:shop_app/screens/complete_profile/complete_profile_screen.dart';
import 'package:shop_app/screens/sign_up/sign_up_view_model.dart';

import 'components/body.dart';

class SignUpScreen extends ConsumerWidget {
  static String routeName = "/sign_up";
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var state = watch(signUpViewModelProvider);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if(state is AsyncData){
        if(state.value != null){
          Navigator.pushNamed(context, CompleteProfileScreen.routeName);
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
        title: Text("Sign Up"),
      ),
      body: Body(),
    );
  }
}
