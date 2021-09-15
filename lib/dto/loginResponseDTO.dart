class LoginResponseDTO {
  final String userId;
  final String token;
  final String userName;
  final String address;

  LoginResponseDTO(
      {required this.userId,
      required this.token,
      required this.userName,
      required this.address});

  factory LoginResponseDTO.fromJson(Map<String, dynamic> parsedJson) {
    return LoginResponseDTO(
        userId: parsedJson['userId'],
        token: parsedJson['token'],
        userName: parsedJson['userName'],
        address: parsedJson['address']);
  }
}
