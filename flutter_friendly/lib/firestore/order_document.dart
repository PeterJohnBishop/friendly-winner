import 'dart:convert';
import 'package:flutter_friendly/firestore/item_document.dart';
import 'package:http/http.dart' as http;

class OrderDocument {
  final String orderID;
  final String userID;
  final int totalPrice;
  final List<ItemDocument> items;
  final String dateOrdered;
  final String orderStatus;
  final String dateCompleted;
  final Map<String, dynamic> metadata;

  static final String _baseUrl = 'http://localhost:8080/orders';

  OrderDocument({
    required this.orderID,
    required this.userID,
    required this.totalPrice,
    required this.items,
    required this.dateOrdered,
    required this.orderStatus,
    required this.dateCompleted,
    required this.metadata,
  });

  factory OrderDocument.fromJson(Map<String, dynamic> json) {
    return OrderDocument(
      orderID: json['order_id'],
      userID: json['user_id'],
      totalPrice: json['total_price'],
      items: json['items'],
      dateOrdered: json['date_ordered'],
      orderStatus: json['order_status'],
      dateCompleted: json['date_completed'],
      metadata: json['metadata'],
    );
  }

  static Future<OrderDocument> createOrder(OrderDocument order) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/order/new'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'order_id': order.orderID,
        'user_id': order.userID,
        'total_price': order.totalPrice,
        'items': order.items,
        'date_ordered': order.dateOrdered,
        'order_status': order.orderStatus,
        'date_completed': order.dateCompleted,
        'metadata': order.metadata,
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData.containsKey("order")) {
        return OrderDocument.fromJson(responseData["order"]);
      } else {
        throw Exception("User data missing in API response");
      }
    } else {
      throw Exception("Error creating User Document");
    }
  }

  static Future<List<OrderDocument>> fetchOrders() async {
    final response = await http.get(Uri.parse('$_baseUrl/'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData.containsKey("orders")) {
        return List<OrderDocument>.from(
          responseData["orders"].map((order) => OrderDocument.fromJson(order)),
        );
      } else {
        throw Exception("Orders data missing in API response");
      }
    } else {
      throw Exception("Error fetching Orders");
    }
  }

  static Future<OrderDocument> fetchOrder(String documentId) async {
    final response = await http.get(Uri.parse('$_baseUrl/order/$documentId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData.containsKey("order")) {
        return OrderDocument.fromJson(responseData["order"]);
      } else {
        throw Exception("Order data missing in API response");
      }
    } else {
      throw Exception("Error fetching Order Document");
    }
  }

  static Future<OrderDocument> fetchOrderByUser(String userId) async {
    final response = await http.get(Uri.parse('$_baseUrl/order/user/$userId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData.containsKey("order")) {
        return OrderDocument.fromJson(responseData["order"]);
      } else {
        throw Exception("Order data missing in API response");
      }
    } else {
      throw Exception("Error fetching Order Document");
    }
  }

  static Future<OrderDocument> fetchOrderByOrderId(String orderId) async {
    final response =
        await http.get(Uri.parse('$_baseUrl/order/orderId/$orderId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData.containsKey("order")) {
        return OrderDocument.fromJson(responseData["order"]);
      } else {
        throw Exception("Order data missing in API response");
      }
    } else {
      throw Exception("Error fetching Order Document");
    }
  }

  static Future<OrderDocument> updateOrder(
      String documentId, OrderDocument order) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/order/$documentId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'order_id': order.orderID,
        'user_id': order.userID,
        'total_price': order.totalPrice,
        'items': order.items,
        'date_ordered': order.dateOrdered,
        'order_status': order.orderStatus,
        'date_completed': order.dateCompleted,
        'metadata': order.metadata,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData.containsKey("order")) {
        return OrderDocument.fromJson(responseData["order"]);
      } else {
        throw Exception("Order data missing in API response");
      }
    } else {
      throw Exception("Error updating Order Document");
    }
  }

  static Future<void> deleteOrder(String orderID) async {
    final response = await http.delete(Uri.parse('$_baseUrl/order/$orderID'));

    if (response.statusCode != 200) {
      throw Exception("Error deleting Order Document");
    }
  }
}
