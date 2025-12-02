import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:the_friendz_zone/screens/onboarding/onboarding_screen.dart';
import '../config/app_config.dart';
import '../utils/app_function.dart';
import '../utils/app_strings.dart';
import 'api_utils.dart';

/// All the apis are post and using formdata
/// Endpoint is being sent inside the formdata with a key named request

class ApiManager {
  static Future<Map<String, dynamic>> callGet({
    Map<String, String>? headers,
    String? endPoint,
    Map<String, dynamic>? queryParams,
  }) async {
    bool isNet = await AppFunctions.checkInternet();
    if (!isNet) throw AppStrings.checkConnection;

    try {
      Uri url;
      if (endPoint != null) {
        url = Uri.parse('${ApiUtils.baseUrl}${endPoint}');
      } else {
        url = Uri.parse('${ApiUtils.baseUrl}');
      }
      // Add query parameters if present
      if (queryParams != null && queryParams.isNotEmpty) {
        url = url.replace(
          queryParameters:
              queryParams.map((key, value) => MapEntry(key, value.toString())),
        );
      }

      debugPrint('GET URL: $url');

      final response = await http.get(url, headers: headers);
      final Map<String, dynamic> finalResponse = checkResponse(response);
      checkTokenValidity(finalResponse);

      log('API: $endPoint, Response: $finalResponse');
      debugPrint('API: $endPoint, Response: $finalResponse');
      return finalResponse;
    } on SocketException {
      throw AppStrings.checkConnection;
    }
  }

  static Future<Map<String, dynamic>> callPost(
    Map<String, String> body, {
    String? endPoint,
  }) async {
    bool isNet = await AppFunctions.checkInternet();
    if (isNet) {
      try {
        debugPrint(body.toString());
        Map<String, dynamic> finalresponse;
        Uri url = Uri.parse('${ApiUtils.baseUrl}$endPoint');
        debugPrint('url: $url');
        http.Response response = await http.post(url, body: body);

        finalresponse = checkResponse(response);
        return finalresponse;
      } on SocketException catch (_) {
        throw AppStrings.checkConnection;
      }
    } else {
      throw AppStrings.checkConnection;
    }
  }

  static Map<String, String> predefinedHeaders = {
    'Content-Type':
        'application/x-www-form-urlencoded', // Default Content-Type for form data
    'Authorization':
        'Bearer YOUR_AUTH_TOKEN', // Example token (replace with actual token)
    // Add more common headers here
  };

  // Method to get the auth token from storage and update predefined headers
  static Future<void> setAuthToken() async {
    String? token = await StorageHelper().getAuthToken;
    if (token != null && token.isNotEmpty) {
      predefinedHeaders['Authorization'] =
          'Bearer $token'; // Set the token in the header dynamically
      print('Token set in headers: Bearer $token');
    } else {
      print('No token found in storage');
    }
  }

  // Method to merge custom headers with predefined headers
  static Map<String, String> mergeHeaders(Map<String, String>? customHeaders) {
    if (customHeaders == null) {
      return predefinedHeaders;
    }
    // Merging custom headers with predefined headers
    return {...predefinedHeaders, ...customHeaders};
  }

  // Modified method with support for dynamic headers
  static Future<Map<String, dynamic>> callPostWithFormData({
    required Map<String, dynamic> body, // Form data as key-value pairs
    required String endPoint, // Optional endpoint parameter
    Map<String, String>? headers, // Custom headers for the request (optional)
    String? fileKey, // Optional: field name for the file
    List<String>? filePaths, // Optional: path to the file
    Map<String, List<String>?>?
        multipartFile, // add aditional file key or data if neccessary or needed
  }) async {
    await setAuthToken(); // This fetches the token and sets it in predefinedHeaders

    bool isNet = await AppFunctions.checkInternet();
    if (isNet) {
      try {
        Map<String, dynamic> finalresponse;
        Uri url = Uri.parse(ApiUtils.baseUrl); // Base URL without the endpoint

        var request = http.MultipartRequest('POST', url);

        // Add the 'request' key with the endpoint as a string
        request.fields['request'] = endPoint; // Just the endpoint string
        // Add other form fields to the request body
        body.forEach((key, value) {
          if (value is List) {
            if (key.endsWith('[]')) {
              // Send as repeated form fields: category_id[]=1, category_id[]=2
              for (var item in value) {
                request.fields.addAll({key: item.toString()});
              }
            } else {
              // Send as a single comma-separated string: "1,2,3"
              request.fields[key] = value.join(',');
            }
          } else {
            request.fields[key] = value.toString();
          }
        });

        debugPrint('Outgoing FormData Fields: ${request.fields}');

        // Merge predefined headers with any custom headers passed into the request
        Map<String, String> mergedHeaders = mergeHeaders(headers);
        request.headers.addAll(mergedHeaders);

        //  Add file if both fileKey and filePath are provided
        //  Handle multiple files with the same key
        if (fileKey != null && filePaths != null && filePaths.isNotEmpty) {
          for (String path in filePaths) {
            if (path.isNotEmpty) {
              final file = await http.MultipartFile.fromPath(fileKey, path);
              request.files.add(file);
            }
          }
        }

        // adding aditional files if have more than one file to and key to add
        if (multipartFile != null) {
          for (var entry in multipartFile.entries) {
            final key = entry.key;
            final value = entry.value;

            if (value != null && value.isNotEmpty) {
              for (String path in value) {
                if (path.isNotEmpty) {
                  final file = await http.MultipartFile.fromPath(key, path);
                  request.files.add(file);
                }
              }
            } else {
              // Add an empty placeholder file with the key
              final emptyFile =
                  http.MultipartFile.fromString(key, '', filename: '');
              request.files.add(emptyFile);
            }
          }
        }

        // Perform the request
        var response   = await request.send();

        // Wait for the response and convert the streamed response to a string
        final respStr = await response.stream.bytesToString();

        // Check the response (check if status code is 200)
        if (response.statusCode == 200) {
          log('api ==== $endPoint , request === ${request.fields} ,,,,, response ======= $respStr');
          debugPrint(
              'api ==== $endPoint , request === ${request.fields} ,,,,, response ======= $respStr');

          final responseJson = json.decode(respStr);
          checkTokenValidity(responseJson);
          finalresponse = responseJson;
        }
        // handle any non 200 code response
        else {
          log('api ==== $endPoint , request === ${request.fields} ,,,,, response ======= $respStr');
          debugPrint(
              'api ==== $endPoint , request === ${request.fields} ,,,,, response ======= $respStr');

          final responseJson = json.decode(respStr);
          checkTokenValidity(responseJson);

          finalresponse = responseJson;
        }
        return finalresponse;
      } on SocketException {
        throw AppStrings.checkConnection;
      } catch (_) {
        debugPrint('error api manager ${_.toString()}');
        throw ErrorMessages.somethingWrong;
      }
    } else {
      throw AppStrings.checkConnection;
    }
  }
}

void checkTokenValidity(Map<String, dynamic> response) {
  try {
    if (response['message'].toLowerCase() == ErrorMessages.invalidToken) {
      StorageHelper().removeData();
      Get.offAll(() => OnboardingScreen());
    }
  } catch (e) {}
}

Map<String, dynamic> checkResponse(http.Response response) {
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw ErrorMessages.somethingWrong;
  }
}
