
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/auth.dart';
import 'package:shop_app/providers/dio_provider.dart';
import 'package:shop_app/screens/sign_in/sign_in_model.dart';

final signInServiceProvider = Provider((ref) => SignInService(ref.container.read(dioProvider)));

class SignInService {
  final Dio _dio;

  SignInService(this._dio);

  Future<Auth> login(String name, String password) async {
    try{
      SignInModel signInModel = new SignInModel(name, password);
      var response = await _dio.post('$SERVICE_URL/login', data: signInModel.toJson());
      return Auth.fromJson(response.data);
    }catch(err){
      throw err;
    }
  }
}