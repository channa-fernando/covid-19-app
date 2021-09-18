import 'package:untitled/dto/LatLangDTO.dart';

class CircleResponseDTO {
  final List<LatLang> latLangList;

  CircleResponseDTO({required this.latLangList});

  factory CircleResponseDTO.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['latLangList'] as List;
    print(list.runtimeType);
    List<LatLang> latLangListCreated = list.map((i) => LatLang.fromJson(i)).toList();


    return CircleResponseDTO(
      latLangList:latLangListCreated
    );
  }
}
