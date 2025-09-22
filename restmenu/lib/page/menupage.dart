import 'package:flutter/material.dart';
import 'package:restmenu/db/menudb.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final _nameController = TextEditingController();
  final _recipeController = TextEditingController();
  final _priceController = TextEditingController();
  final menuDb = MenuDatabase();

  // BottomSheet for Add / Edit
  void showMenuForm({dynamic id, String? oldName, String? oldRecipe, double? oldPrice}) {
    if (id != null) {
      // Editing old values
      _nameController.text = oldName ?? "";
      _recipeController.text = oldRecipe ?? "";
      _priceController.text = oldPrice?.toString() ?? "";
    } else {
      // Adding new → clear fields
      _nameController.clear();
      _recipeController.clear();
      _priceController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(id == null ? "Add New Dish" : "Edit Dish", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            TextField(controller: _nameController, decoration: InputDecoration(labelText: "Name")),
            TextField(controller: _recipeController, decoration: InputDecoration(labelText: "Recipe")),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final name = _nameController.text.trim();
                final recipe = _recipeController.text.trim();
                final price = double.tryParse(_priceController.text) ?? 0.0;

                if (name.isEmpty || recipe.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Fill all fields")));
                  return;
                }

                try {
                  if (id == null) {
                    // Add new
                    await menuDb.createMenu(name, recipe, price);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Dish Added")));
                  } else {
                    // Update
                    await menuDb.updateMenu(id, name, recipe, price);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Dish Updated")));
                  }
                  Navigator.pop(context); // close sheet
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
                }
              },
              child: Text(id == null ? "Save" : "Update"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Restaurant Menu"), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showMenuForm(),
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: menuDb.table.stream(primaryKey: ['id']),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final menuItems = snapshot.data as List<Map<String, dynamic>>;

          if (menuItems.isEmpty) {
            return Center(child: Text("No dishes yet. Tap + to add.", style: TextStyle(fontSize: 16)));
          }

          return ListView.builder(
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              final id = item['id'];
              final name = item['name'] ?? "";
              final recipe = item['recipe'] ?? "";
              final price = (item['price'] as num).toDouble();

              return Card(
                child: ListTile(
                  title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("$recipe\n৳$price"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => showMenuForm(
                          id: id,
                          oldName: name,
                          oldRecipe: recipe,
                          oldPrice: price,
                        ),
                        icon: Icon(Icons.edit, color: Colors.blue),
                      ),
                      IconButton(
                        onPressed: () async {
                          await menuDb.deleteMenu(id);
                        },
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
