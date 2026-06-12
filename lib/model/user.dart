class User {
  int? id;
  String email;
  String password;
  String student_id;
  String full_name;
  String gender;

  User({
    this.id,
    required this.email,
    required this.password,
    required this.student_id,
    required this.full_name,
    required this.gender,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'student_id': student_id,
      'full_name': full_name,
      'gender': gender,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      student_id: map['student_id'],
      full_name: map['full_name'],
      gender: map['gender'],
    );
  }
}
