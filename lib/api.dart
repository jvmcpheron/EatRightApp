import 'package:http/http.dart' as http;

Future<void> testRequest() async {
  var request = http.Request('GET', Uri.parse('https://api.spoonacular.com/recipes/complexSearch?apiKey=91f181e349cb474082bcd508f8c39a07&query=steak'));
  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  }
  else {
    print(response.reasonPhrase);
  }
}

