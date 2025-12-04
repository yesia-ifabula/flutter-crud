import 'package:flutter/material.dart';
import 'package:flutter_crud/components/grid_item_widget.dart';
import 'package:flutter_crud/screens/auth/login_screen.dart';
import 'package:flutter_crud/screens/form/form_screen.dart';
import 'package:flutter_crud/screens/list/list_item_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListItemScreen extends StatelessWidget {
  const ListItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Item Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              // Action for adding a new item
              final session = await SharedPreferences.getInstance();
              session.clear();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Consumer <ListItemProvider>(
        builder: (context, listItemProvider, Widget) {
          return listItemProvider.isLoading
              ? Center(child: CircularProgressIndicator())
              : listItemProvider.listItem.isEmpty
                  ? Center(child: Text('No items available'))
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2
                      ),
                      itemCount: listItemProvider.listItem.length,
                      itemBuilder: (context, index){
                        final item = listItemProvider.listItem[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FormScreen(items: item),
                              ),
                            );
                          },
                          child: GridItemWidget(item: item),
                        );
                      }
                    );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for adding a new item
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => FormScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}