class FaceComparisonResponse {
  String message;
  double confidence;

  FaceComparisonResponse({required this.message, required this.confidence});

  factory FaceComparisonResponse.fromJson(Map<String, dynamic> json) {
    return FaceComparisonResponse(
      message: json['message'],
      confidence: json['confidence'].toDouble(),
    );
  }
}
