import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_crud/components/custom_textfield_widget.dart';
import 'package:flutter_crud/models/list_item_response.dart';
import 'package:flutter_crud/screens/form/form_provider.dart';
import 'package:flutter_crud/screens/list/list_item_provider.dart';
import 'package:flutter_crud/services/item_service.dart';
import 'package:flutter_crud/utils/helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FormScreen extends StatelessWidget {

  final Items? items;
  const FormScreen({super.key, this.items});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => FormProvider(context.read<ItemService>(), items),
        builder: (context, child){

          final readProvider = context.read<FormProvider>();
          final watchProvider = context.watch<FormProvider>();

          Widget nameFields() {
            return CustomTextFieldWidgets(
              labelText: "Item Name",
              controller: readProvider.name,
            );
          }

          Widget stockFields() {
            return CustomTextFieldWidgets(
              controller: readProvider.stock,
              keyboardType: TextInputType.number,
              labelText: "Item Stock",
            );
          }

          Widget imagePicker() {
            if (watchProvider.imageBase64 != null) {
              Uint8List bytes = base64Decode(watchProvider.imageBase64 ?? "");
              return Stack(
                children: [
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Image.memory(bytes, fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: IconButton(
                      onPressed: () {
                        readProvider.removeImage();
                      },
                      icon: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return GestureDetector(
                onTap: () async {
                  showModalImagePicker(context, readProvider);
                },
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey,
                  ),
                  child: Center(
                    child: Text(
                      'Ambil gambar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            }
          }

          Widget buttonSave() {
            return watchProvider.isLoading
                ? CircularProgressIndicator()
                : SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if(readProvider.formKey.currentState!.validate()) {
                    watchProvider.isUpdateForm
                        ? actionUpdate(readProvider, context)
                        : actionInsert(readProvider, context);
                  }
                },
                child: Text("Submit"),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(watchProvider.isUpdateForm ? "Update Item" : "Insert Item"),
              actions: [
                if(watchProvider.isUpdateForm)
                  IconButton(
                      onPressed: () {
                        actionDelete(readProvider, context);
                      },
                      icon: Icon(Icons.delete)
                  )
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: readProvider.formKey,
                  child: Column(
                    children: [
                      nameFields(),
                      SizedBox(height: 8),
                      stockFields(),
                      SizedBox(height: 8),
                      imagePicker(),
                      SizedBox(height: 16),
                      buttonSave()
                    ],
                  ),
                ),
              ),
            ),
          );
        },
    );
  }

  void showModalImagePicker(BuildContext context, FormProvider readProvider) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Galeri'),
              onTap: () {
                Navigator.pop(context);
                getImage(ImageSource.gallery, readProvider);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Kamera'),
              onTap: () {
                Navigator.pop(context);
                getImage(ImageSource.camera, readProvider);
              },
            ),
            const SizedBox(height: 30),
          ],
        );
      },
    );
  }

  Future getImage(ImageSource source, FormProvider providerRead) async {
    final pickedFile = await ImagePicker().pickImage(
      source: source,
      imageQuality: 90,
      maxHeight: 480,
      maxWidth: 640,
    );

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      List<int> imageBytes = imageFile.readAsBytesSync();
      String imgBase64 = base64Encode(imageBytes);

      providerRead.setImage(imgBase64);
    } else {
      debugPrint('No image selected.');
    }
  }
  
  void actionUpdate(FormProvider readProvider, BuildContext context) async {
    await readProvider.updateItem()
        .then((value){
          if (value.status == "success"){
            Helper.showSnackBar(context, value.message ?? "", color: Colors.green);
            Navigator.pop(context);
            context.read<ListItemProvider>().getListItem();
          } else {
            Helper.showSnackBar(context, value.message ?? "");
          }
        })
        .catchError((error){
          Helper.showSnackBar(context, "Error $error");
        });
  }

  void actionInsert(FormProvider readProvider, BuildContext context) async {
    await readProvider.insertItem()
        .then((value){
          if (value.status == "success"){
            Helper.showSnackBar(context, value.message ?? "", color: Colors.green);
            Navigator.pop(context);
            context.read<ListItemProvider>().getListItem();
          } else {
            Helper.showSnackBar(context, value.message ?? "");
          }
        })
        .catchError((error){
          Helper.showSnackBar(context, "Error $error");
        });
  }

  void actionDelete(FormProvider readProvider, BuildContext context) async {
    await readProvider.deleteItem()
        .then((value){
          if (value.status == "success"){
            Helper.showSnackBar(context, value.message ?? "", color: Colors.green);
            Navigator.pop(context);
            context.read<ListItemProvider>().getListItem();
          } else {
            Helper.showSnackBar(context, value.message ?? "");
          }
        })
        .catchError((error){
          Helper.showSnackBar(context, "Error $error");
        });
  }

}