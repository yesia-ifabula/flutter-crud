import 'package:flutter/material.dart';
import 'package:flutter_crud/models/form_request.dart';
import 'package:flutter_crud/models/form_response.dart';
import 'package:flutter_crud/models/list_item_response.dart';
import 'package:flutter_crud/services/item_service.dart';
import 'package:flutter_crud/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormProvider extends ChangeNotifier{

  final ItemService _itemService;
  final Items? _items;
  late TextEditingController name;
  late TextEditingController stock;
  late String? imageBase64;
  late bool _isLoading;
  String? _token;
  final formKey = GlobalKey<FormState>();

  FormProvider(this._itemService, this._items){
    _isLoading = false;
    name = TextEditingController(text: _items?.name);
    stock = TextEditingController(text: _items?.stock.toString());
    imageBase64 = _items?.imageBase64;
    _getToken();
  }

  Future _getToken() async {
    final session = await SharedPreferences.getInstance();
    _token = session.getString(Helper.TOKEN);
  }

  bool get isLoading => _isLoading;
  set isLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }

  void setImage(String base64){
    imageBase64 = base64;
    notifyListeners();
  }

  void removeImage(){
    imageBase64 = null;
    notifyListeners();
  }

  bool get isUpdateForm => _items != null;

  Future<FormResponse> insertItem() async {
    isLoading = true;
    try{
      final request = FormRequest(
          name: name.text,
          stock: int.parse(stock.text),
          imageBase64: imageBase64
      );
      final response = await _itemService.insertItem(request, _token ?? '');
      return response;
    } catch (exc){
      throw "Insert Item gagal: ${exc.toString()}";
    } finally {
      isLoading = false;
    }
  }

  Future<FormResponse> updateItem() async {
    isLoading = true;
    try{
      final request = FormRequest(
          id: _items?.id,
          name: name.text,
          stock: int.parse(stock.text),
          imageBase64: imageBase64
      );
      final response = await _itemService.updateItem(request, _token ?? '');
      return response;
    } catch (exc){
      throw "Update Item gagal: ${exc.toString()}";
    } finally {
      isLoading = false;
    }
  }

  Future<FormResponse> deleteItem() async {
    isLoading = true;
    try{
      final response = await _itemService.deleteItem(_items?.id.toString() ?? '', _token ?? '');
      return response;
    } catch (exc){
      throw "Delete Item gagal: ${exc.toString()}";
    } finally {
      isLoading = false;
    }
  }


}