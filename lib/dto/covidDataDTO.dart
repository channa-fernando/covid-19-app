class CovidDataDTO {
  final String update_date_time;
  final int local_new_cases;
  final int local_total_cases;
  final int local_new_deaths;
  final int local_deaths;

  CovidDataDTO({
    required this.update_date_time,
    required this.local_new_cases,
    required this.local_total_cases,
    required this.local_new_deaths,
    required this.local_deaths
  });

  factory CovidDataDTO.fromJson(Map<String, dynamic> parsedJson) {
    return CovidDataDTO(
        update_date_time: parsedJson['update_date_time'],
        local_new_cases: parsedJson['local_new_cases'],
        local_total_cases: parsedJson['local_total_cases'],
        local_new_deaths: parsedJson['local_new_deaths'],
        local_deaths: parsedJson['local_deaths']
    );
  }
}
