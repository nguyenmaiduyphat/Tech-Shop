// ignore_for_file: non_constant_identifier_names

class UserDetail {
  late String username;
  late String password;
  final String email;
  late String phone;
  late String address;
  late String gender;
  late String birth;
  late String CIC;
  late String bankNumber;

  UserDetail({
    required this.username,
    required this.password,
    required this.email,
    required this.phone,
    required this.address,
    required this.gender,
    required this.birth,
    required this.CIC,
    required this.bankNumber,
  });

  /// ✅ Convert object to Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'email': email,
      'phone': phone,
      'address': address,
      'gender': gender,
      'birth': birth,
      'CIC': CIC,
      'bankNumber': bankNumber,
    };
  }

  /// ✅ Create object from Map<String, dynamic>
  factory UserDetail.fromMap(Map<String, dynamic> map) {
    return UserDetail(
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      gender: map['gender'] ?? '',
      birth: map['birth'] ?? '',
      CIC: map['CIC'] ?? '',
      bankNumber: map['bankNumber'] ?? '',
    );
  }
}
