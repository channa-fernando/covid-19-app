class CovidLiveDataDTO {
  final bool success;

  CovidLiveDataDTO({
    required this.success,
   });

  factory CovidLiveDataDTO.fromJson(Map<String, dynamic> json) {
    return CovidLiveDataDTO(
      success: json['success']
    );
  }
}