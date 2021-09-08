
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/providers/dio_provider.dart';
import 'package:shop_app/screens/sign_up/sign_up_model.dart';

final signUpServiceProvider = Provider((ref) => SignUpService(ref.container.read(dioProvider)));

class SignUpService {
  final Dio _dio;

  SignUpService(this._dio);

  Future<String> signUp(String email, String password) async {
    try{
      SignUpModel signUpModel = new SignUpModel(email, password);
      var response = await _dio.post('$SERVICE_URL/signup', data: signUpModel.toJson());
      return response.data;
    }catch(err){
      throw err;
    }
  }
}