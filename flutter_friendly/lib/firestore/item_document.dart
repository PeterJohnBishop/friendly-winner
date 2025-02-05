import 'dart:convert';
import 'package:http/http.dart' as http;

class ItemDocument {
  final String itemId;
  final List<String> images;
  final String name;
  final String description;
  final String category;
  final double price;
  final bool featured;
  final int quantity;
  final List<String> tags;
  final Map<String, dynamic> metadata;

  static final String _baseUrl = 'http://localhost:8080/items';

  ItemDocument({
    required this.itemId,
    required this.images,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.featured,
    required this.quantity,
    required this.tags,
    required this.metadata,
  });

  factory ItemDocument.fromJson(Map<String, dynamic> json) {
    return ItemDocument(
      itemId: json['item_id'],
      images: json['images'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      price: json['price'],
      featured: json['featured'],
      quantity: json['quantity'],
      tags: json['tags'],
      metadata: json['metadata'],
    );
  }

  static Future<ItemDocument> createItem(ItemDocument item) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/item/new'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'item_id': item.itemId,
        'images': item.images,
        'name': item.name,
        'description': item.description,
        'category': item.category,
        'price': item.price,
        'featured': item.featured,
        'quantity': item.quantity,
        'tags': item.tags,
        'metadata': item.metadata,
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData.containsKey("item")) {
        return ItemDocument.fromJson(responseData["item"]);
      } else {
        throw Exception("User data missing in API response");
      }
    } else {
      throw Exception("Error creating User Document");
    }
  }

  static Future<List<ItemDocument>> fetchItems() async {
    final response = await http.get(Uri.parse('$_baseUrl/'));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((json) => ItemDocument.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch items');
    }
  }

  static Future<ItemDocument> fetchItem(String documentId) async {
    final response = await http.get(Uri.parse('$_baseUrl/item/$documentId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return ItemDocument.fromJson(responseData);
    } else {
      throw Exception('Failed to get item');
    }
  }

  static Future<ItemDocument> updateItem(
      String documentId, ItemDocument item) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/item/$documentId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'item_id': item.itemId,
        'images': item.images,
        'name': item.name,
        'description': item.description,
        'category': item.category,
        'price': item.price,
        'featured': item.featured,
        'quantity': item.quantity,
        'tags': item.tags,
        'metadata': item.metadata,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return ItemDocument.fromJson(responseData);
    } else {
      throw Exception('Failed to update item');
    }
  }

  static Future<void> deleteItem(String documentId) async {
    final response = await http.delete(Uri.parse('$_baseUrl/item/$documentId'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete item');
    }
  }
}
