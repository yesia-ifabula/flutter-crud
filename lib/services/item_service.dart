import 'dart:convert';

import 'package:flutter_crud/models/form_request.dart';
import 'package:flutter_crud/models/form_response.dart';
import 'package:flutter_crud/models/list_item_response.dart';
import 'package:flutter_crud/services/endpoint.dart';
import 'package:http/http.dart' as http;

class ItemService {
  Future<ListItemResponse> getListItem(String token) async {
    // Implementation for fetching items
    final response = await http.get(
      Uri.parse(Endpoint.items),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return ListItemResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<FormResponse> insertItem(FormRequest formRequest, String token) async {
    final response = await http.post(
        Uri.parse(Endpoint.items),
        body: jsonEncode(formRequest),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        }
    );
    return FormResponse.fromJson(jsonDecode(response.body));
  }

  Future<FormResponse> updateItem(FormRequest formRequest, String token) async {
    final response = await http.put(
        Uri.parse("${Endpoint.items}/${formRequest.id}"),
        body: jsonEncode(formRequest),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        }
    );
    return FormResponse.fromJson(jsonDecode(response.body));
  }

  Future<FormResponse> deleteItem(String id, String token) async {
    final response = await http.delete(
        Uri.parse("${Endpoint.items}/$id"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        }
    );
    return FormResponse.fromJson(jsonDecode(response.body));
  }


}