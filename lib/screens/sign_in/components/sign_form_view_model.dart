import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app/screens/sign_in/components/sign_form_state.dart';

final signFormViewModelProvider = StateNotifierProvider<SignFormViewModel, SignFormState>((ref) => SignFormViewModel());

class SignFormViewModel extends StateNotifier<SignFormState>{
  SignFormViewModel() : super(new SignFormState(false, []));

  void addError(String error) {
    if (!state.errors.contains(error)){
      List<String> errors = state.errors;
      errors.add(error);
      state = new SignFormState(state.isRemember, errors);
    }
  }

  void removeError(String error) {
    if (state.errors.contains(error)){
      List<String> errors = state.errors;
      errors.remove(error);
      state = new SignFormState(state.isRemember, errors);
    }
  }

  void setIsRemember(){
    bool isRemember = !state.isRemember;
    state = new SignFormState(isRemember, state.errors);
  }
}