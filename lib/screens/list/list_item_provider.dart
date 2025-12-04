import 'package:flutter/material.dart';
import 'package:flutter_crud/models/list_item_response.dart';
import 'package:flutter_crud/services/item_service.dart';
import 'package:flutter_crud/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListItemProvider extends ChangeNotifier {
  final ItemService _itemService;
  late List<Items> listItem = [];
  late bool _isLoading;

  ListItemProvider(this._itemService) {
    _isLoading = false;
    listItem = [];
    getListItem();
  }

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future getListItem() async {
    isLoading = true;
    try {
      final session = await SharedPreferences.getInstance();
      final token = session.getString(Helper.TOKEN);
      final result = await _itemService.getListItem(token ?? "");
      listItem = result.data?.items ?? [];
    } catch (e) {
      throw 'Failed to fetch items: $e';
    } finally {
      isLoading = false;
    }
  }

}