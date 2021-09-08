import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app/services/forgot_password_service.dart';

final forgotPasswordViewModelProvider = StateNotifierProvider.autoDispose(
    (ref) => ForgotPasswordViewModel(ref.read(forgotPasswordServiceProvider)));

class ForgotPasswordViewModel extends StateNotifier<AsyncValue<dynamic>> {
  final ForgotPasswordService _forgotPasswordService;

  ForgotPasswordViewModel(this._forgotPasswordService) : super(AsyncData(null));

  void forgotPassword(String email) async {
    state = AsyncLoading();
    try {
      var res = await _forgotPasswordService.forgotPassword(email);
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
