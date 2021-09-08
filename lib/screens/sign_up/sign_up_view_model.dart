import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app/services/sign_up_service.dart';

final signUpViewModelProvider = StateNotifierProvider.autoDispose(
        (ref) => SignUpViewModel(ref.read(signUpServiceProvider)));

class SignUpViewModel extends StateNotifier<AsyncValue<dynamic>> {
  final SignUpService _signUpService;

  SignUpViewModel(this._signUpService) : super(AsyncData(null));

  void signUp(String email, String password) async {
    state = AsyncLoading();
    try {
      var res = await _signUpService.signUp(email, password);
      state = AsyncData(res);
    } catch (err) {
      var error = (err as dynamic).response.data;
      if(error != null){
        state = AsyncError(error);
      }else{
        state = AsyncError("Something went wrong");
      }
    }
  }
}
