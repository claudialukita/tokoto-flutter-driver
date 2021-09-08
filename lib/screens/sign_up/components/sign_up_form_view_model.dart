import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app/screens/sign_up/components/sign_up_form_state.dart';

final signUpFormViewModelProvider = StateNotifierProvider.autoDispose<SignUpFormViewModel, SignUpFormState>((ref) => SignUpFormViewModel());

class SignUpFormViewModel extends StateNotifier<SignUpFormState>{
  SignUpFormViewModel() : super(SignUpFormState([]));

  void addError(String error) {
    if (!state.errors.contains(error)){
      List<String> errors = state.errors;
      errors.add(error);
      state = new SignUpFormState(errors);
    }
  }

  void removeError(String error) {
    if (state.errors.contains(error)){
      List<String> errors = state.errors;
      errors.remove(error);
      state = new SignUpFormState(errors);
    }
  }
}