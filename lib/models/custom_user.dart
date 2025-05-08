class CustomUser {
  final String uid;
  final String displayName;
  final String email;
  final String? photoURL;

  const CustomUser({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.photoURL
  });

  factory CustomUser.fromMap(Map<String, dynamic> map) {
    return CustomUser(
      uid: map['uid'],
      displayName: map['displayName'],
      email: map['email'],
      photoURL: map['photoUrl']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoURL
    };
  }
}
