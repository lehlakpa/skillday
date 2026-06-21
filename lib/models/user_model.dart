class AppUser {
  final String uid;
  final String fullName;
  final String email;

  AppUser({required this.uid, required this.fullName, required this.email});

  Map<String, dynamic> toMap() {
    return {"uid": uid, "fullName": fullName, "email": email};
  }
}
