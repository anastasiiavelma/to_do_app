import 'package:http/http.dart' as http;

class ApiService {
  Future<bool> fetchData() async {
    final response =
        await http.get(Uri.parse('https://to-do.softwars.com.ua/'));

    if (response.statusCode == 200) {
      // Successful response
      return true;
    } else {
      // Error handling
      return false;
    }
  }
}
