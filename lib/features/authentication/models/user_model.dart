import 'package:app_health_connect/utils/formatters/formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  //Keep those values final which you do not want to update
  final String id;
  String firstName;
  String lastName;
  final String email;
  final String phoneNumber;
  String profilePicture;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
  });

  //Helper function to get the full name
  String get fullName => '$firstName $lastName';

  //Helper function to format phone number
  String get formattedPhoneNo => TFormatter.formatPhoneNumber(
      phoneNumber); // Solo para numeros de estados unidos

  //Separar fullname
  static List<String> nameParts(fullname) => fullname.split(" ");

  //Static function to generate a username from the full name
  static String generateUsername(fullname) {
    List<String> nameParts = fullname.split(" ");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";
    String cameCaseUsername = "$firstName$lastName";
    String usernameWithPrefix = "user_$cameCaseUsername";
    return usernameWithPrefix;
  }

  static UserModel empty() => UserModel(
      id: '',
      firstName: '',
      lastName: '',
      email: '',
      phoneNumber: '',
      profilePicture: '');

  // Método para convertir un UserModel a un mapa (útil para Firestore o JSON)
  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'FirstName': firstName,
      'LastName': lastName,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
          id: document.id,
          firstName: data['FirstName'] ?? '',
          lastName: data['LastName'] ?? '',
          email: data['Email'] ?? '',
          phoneNumber: data['PhoneNumber'] ?? '',
          profilePicture: data['ProfilePicture'] ?? '');
    }
    return throw Exception();
  }

  // Método para crear un UserModel desde un mapa (útil para Firestore o JSON)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      profilePicture: map['profilePicture'],
    );
  }
}
