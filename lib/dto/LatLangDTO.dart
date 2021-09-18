class LatLang{
  final String latitude;
  final String longitude;

  LatLang({required this.latitude, required this.longitude});

  factory LatLang.fromJson(Map<String, dynamic> parsedJson){
    return LatLang(
        latitude:parsedJson['latitude'],
        longitude:parsedJson['longitude']
    );
  }
}