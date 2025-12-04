import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_crud/models/list_item_response.dart';

class GridItemWidget extends StatelessWidget {

  final Items item;

  const GridItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: item.imageBase64?.isNotEmpty == true
                ? Image.memory(
              base64Decode(item.imageBase64 ?? ""),
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.error),
            )
                : Center(
              child: const Icon(Icons.image_not_supported, size: 100),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.name ?? "",
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("${item.stock} buah"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}