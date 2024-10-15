class User {
  final int id; // Corresponds to "id" in JSON
  final String employeeId;
  final String name;
  final String email;
  final int phone;
  final String role;

  User({
    required this.id,
    required this.employeeId,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
  });

  // Factory method to create a User object from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      employeeId: json['employeeId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as int,
      role: json['role'] as String,
    );
  }

  // Method to convert a User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
    };
  }
}
