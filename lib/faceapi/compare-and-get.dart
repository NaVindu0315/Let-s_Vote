import "compare.dart";

void compareFacesAndShowResult() async {
  String faceUrl1 =
      "https://firebasestorage.googleapis.com/v0/b/navindu-store.appspot.com/o/face-api%20images%2Fnngi_2.jpeg?alt=media&token=af022352-c7f2-4b21-9f4a-036bc857e6b0";
  String faceUrl2 =
      "https://firebasestorage.googleapis.com/v0/b/navindu-store.appspot.com/o/face-api%20images%2Fnngi_1.jpeg?alt=media&token=8525b947-ce30-471b-98d3-d2f2ed9afcdb";

  try {
    final response = await compareFaces(faceUrl1, faceUrl2);
    print(response.message);
    print(response.confidence);
    // Display the result in your UI
  } catch (error) {
    print(error);
    // Handle errors appropriately
  }
}
