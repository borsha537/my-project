import 'package:supabase_flutter/supabase_flutter.dart';

class MenuDatabase {
  final table = Supabase.instance.client.from('menu_table'); // supabase table: menu

  // Insert menu item
  Future<void> createMenu(String name, String recipe, double price) async {
    await table.insert({
      'name': name,
      'recipe': recipe,
      'price': price,
    });
  }

  // Update menu item
  Future<void> updateMenu(dynamic menuId, String name, String recipe, double price) async {
    await table.update({
      'name': name,
      'recipe': recipe,
      'price': price,
    }).eq('id', menuId);
  }

  // Delete menu item
  Future<void> deleteMenu(dynamic menuId) async {
    await table.delete().eq('id', menuId);
  }
}
