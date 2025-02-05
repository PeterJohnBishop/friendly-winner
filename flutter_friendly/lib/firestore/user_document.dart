import 'dart:convert';
import 'package:http/http.dart' as http;

class UserDocument {
  final String name;
  final String email;
  final String phone;
  final String address1;
  final String address2;
  final String city;
  final String state;
  final String zip;

  static final String _baseUrl = 'http://localhost:8080/users';

  UserDocument({
    required this.name,
    required this.email,
    required this.phone,
    required this.address1,
    required this.address2,
    required this.city,
    required this.state,
    required this.zip,
  });

  factory UserDocument.fromJson(Map<String, dynamic> json) {
    return UserDocument(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address1: json['address1'],
      address2: json['address2'],
      city: json['city'],
      state: json['state'],
      zip: json['zip'],
    );
  }

  static Future<UserDocument> createUser(String uid, UserDocument user) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/user/new/$uid'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': user.name,
        'email': user.email,
        'phone': user.phone,
        'address1': user.address1,
        'address2': user.address2,
        'city': user.city,
        'state': user.state,
        'zip': user.zip,
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData.containsKey("user")) {
        return UserDocument.fromJson(responseData["user"]);
      } else {
        throw Exception("User data missing in API response");
      }
    } else {
      throw Exception("Error creating User Document");
    }
  }

  static Future<List<UserDocument>> fetchUsers() async {
    final response = await http.get(Uri.parse('$_baseUrl/'));
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((user) => UserDocument.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<UserDocument> fetchUser(String uid) async {
    final response = await http.get(Uri.parse('$_baseUrl/user/$uid'));
    if (response.statusCode == 200) {
      return UserDocument.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  static Future<UserDocument> updateUser(String uid, UserDocument user) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/user/$uid'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': user.name,
        'email': user.email,
        'phone': user.phone,
        'address1': user.address1,
        'address2': user.address2,
        'city': user.city,
        'state': user.state,
        'zip': user.zip,
      }),
    );

    if (response.statusCode == 200) {
      return UserDocument.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  static Future<void> deleteUser(String uid) async {
    final response = await http.delete(Uri.parse('$_baseUrl/user/$uid'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete user');
    }
  }
}
