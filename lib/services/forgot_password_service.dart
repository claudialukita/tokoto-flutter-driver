import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/providers/dio_provider.dart';
import 'package:shop_app/screens/forgot_password/forgot_password_model.dart';

final forgotPasswordServiceProvider = Provider((ref) => ForgotPasswordService(ref.container.read(dioProvider)));

class ForgotPasswordService {
  final Dio _dio;

  ForgotPasswordService(this._dio);

  Future<String> forgotPassword(String email) async {
    try{
      ForgotPasswordModel forgotPasswordModel = new ForgotPasswordModel(email);
      var response = await _dio.post('$SERVICE_URL/forgotpassword', data: forgotPasswordModel.toJson());
      return response.data;
    }catch(err){
      throw err;
    }
  }
}