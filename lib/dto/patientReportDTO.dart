class PatientReportDTO {
  final String report;
  final String basicQuestions;
  final String patientName;
  final String patientId;
  final String dateOfSubmission;

  PatientReportDTO(
      {required this.report,
      required this.patientName,
        required this.dateOfSubmission,
        required this.basicQuestions,
      required this.patientId});

  factory PatientReportDTO.fromJson(Map<String, dynamic> parsedJson) {
    return PatientReportDTO(
        report: parsedJson['report'],
        patientName: parsedJson['patientName'],
        basicQuestions: parsedJson['basicQuestions'],
        dateOfSubmission: parsedJson['dateOfSubmission'],
        patientId: parsedJson['patientId']);
  }
}
