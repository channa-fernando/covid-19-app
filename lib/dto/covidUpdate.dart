class CovidUpdate {
  final String date;
  final String localNewCases;
  final String localTotalCases;
  final String localNewDeaths;
  final String localTotalDeaths;


  CovidUpdate({
    required this.date, required this.localNewCases, required this.localTotalCases,
    required this.localNewDeaths, required this.localTotalDeaths
});

  factory CovidUpdate.fromJson(Map<String, dynamic> parsedJson) {
    return CovidUpdate(
        date: parsedJson['date'],
        localNewCases: parsedJson['localNewCases'],
        localTotalCases: parsedJson['localTotalCases'],
        localNewDeaths: parsedJson['localNewDeaths'],
        localTotalDeaths: parsedJson['localTotalDeaths']
    );
  }
}
