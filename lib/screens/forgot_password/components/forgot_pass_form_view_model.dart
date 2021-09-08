import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app/screens/forgot_password/components/forgot_pass_form_state.dart';

final forgotPassFormViewModelProvider = StateNotifierProvider<ForgotPassFormViewModel, ForgotPassFormState>((ref) => ForgotPassFormViewModel());

class ForgotPassFormViewModel extends StateNotifier<ForgotPassFormState>{
  ForgotPassFormViewModel() : super(new ForgotPassFormState([]));

  void addError(String error) {
    if (!state.errors.contains(error)){
      List<String> errors = state.errors;
      errors.add(error);
      state = new ForgotPassFormState(errors);
    }
  }

  void removeError(String error) {
    if (state.errors.contains(error)){
      List<String> errors = state.errors;
      errors.remove(error);
      state = new ForgotPassFormState(errors);
    }
  }
}