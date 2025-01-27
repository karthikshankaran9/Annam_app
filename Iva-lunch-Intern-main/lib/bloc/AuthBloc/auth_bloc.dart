import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:food_preorder_app/API/API_methods.dart';
import 'package:food_preorder_app/API/APIinfos.dart';
import 'package:food_preorder_app/UserModel.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthenticateUser>((event, emit) async {
      if (event.username.isEmpty) {
        emit(AuthFailed(errorMessage: "Please fill UserName"));
      } else if (event.password.isEmpty) {
        emit(AuthFailed(errorMessage: "Pleas fill Your Password"));
      } else if (event.username.length > 15) {
        emit(AuthFailed(
            errorMessage: "UserName should be at less than 15 characters"));
      } else {
        emit(AuthLoading());
      try {
          final response = await http.post(
            Uri.parse('$Baseurl/api/user/login?username=${event.username}&password=${event.password}'),
          );
     
          if (response.statusCode == 200) {
            final Map<String, dynamic> fulldata = json.decode(response.body);

            if (fulldata['result'] == 'success') {
              final Map<String, dynamic> data = fulldata['data'];

              emit(GettingUserInfo());
              Add_data(data);

              // Example: Assuming 'Id' comes from 'data'
              int Id = data['id'];
              Orders_completed = await Get_orders_completed(Id);
              await Get_Pre_Orders(Id);
              emit(AuthSuccessfull(
                successMessage: "You have Logged in Successfully!!",
              ));
            } else {
              emit(AuthFailed(
                errorMessage: fulldata['message'] ?? 'Login failed due to an error',
              ));
            }
          } else {
            emit(AuthFailed(
              errorMessage: 'Error: ${response.reasonPhrase ?? response.statusCode}',
            ));
          }
        } catch (e) {
          emit(AuthFailed(
            errorMessage: 'An unexpected error occurred: $e',
          ));
        }
      }
    });
  }
}
