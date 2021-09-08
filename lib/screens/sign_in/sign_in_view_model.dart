import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app/services/sign_in_service.dart';

final signInViewModelProvider = StateNotifierProvider.autoDispose(
    (ref) => SignInViewModel(ref.read(signInServiceProvider)));

class SignInViewModel extends StateNotifier<AsyncValue<dynamic>> {
  final SignInService _signInService;
  SignInViewModel(this._signInService) : super(AsyncData(null));

  void login(String name, String password) async {
    state = AsyncLoading();
    try {
      var res = await _signInService.login(name, password);
      state = AsyncData(res);
    } catch (err) {
      state = AsyncError(err);
    }
  }
}
