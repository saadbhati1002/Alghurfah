import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../widgets/security.dart';
import 'Constant.dart';

class ApiException implements Exception {
  ApiException(this.errorMessage);

  String errorMessage;

  @override
  String toString() {
    return errorMessage;
  }
}

class ApiBaseHelper {
  Future<dynamic> postAPICall(Uri url, Map param) async {
    var responseJson;
    print(responseJson);
    print(param);

    try {
      print("testing kasdghjka");

      final response = await post(url,
          body: param.isNotEmpty ? param : [], headers: headers);
      print("testing 1");
      print(
          'response api****$url********$param*********${response.statusCode}');

      responseJson = _response(response);
    } on SocketException {
      print("testing 2");

      throw ApiException('No Internet connection');
    } on TimeoutException {
      print("testing 2");

      throw ApiException('Something went wrong, Server not Responding');
    } on Exception catch (e) {
      print("testing 4");

      throw ApiException('Something Went wrong with ${e.toString()}');
    }
    error(e) {
      print("saad bhati");

      print(e.toString());
    }

    print("saad bhati");
    return responseJson;
  }

  dynamic _response(Response response) {
    print("testing tets");

    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode: ${response.statusCode}');
    }
  }
}

class CustomException implements Exception {
  final String? message;
  final String? prefix;

  CustomException([this.message, this.prefix]);

  @override
  String toString() {
    return '$prefix$message';
  }
}

class FetchDataException extends CustomException {
  FetchDataException([message])
      : super(message, 'Error During Communication: ');
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, 'Invalid Request: ');
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, 'Unauthorised: ');
}

class InvalidInputException extends CustomException {
  InvalidInputException([message]) : super(message, 'Invalid Input: ');
}
