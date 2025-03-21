import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class ExchangeRateService {
  // TCMB API'sinden güncel döviz kurunu çekiyoruz.
  Future<double> fetchExchangeRate() async {
    try {
      final response = await http.get(Uri.parse('https://www.tcmb.gov.tr/kurlar/today.xml'));
      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);
        final usdElement = document.findAllElements('Currency')
            .firstWhere((element) => element.getAttribute('CurrencyCode') == 'USD');
        final usdRate = usdElement.findElements('BanknoteSelling').single.text;
        return double.parse(usdRate);
      } else {
        return 18.0;
      }
    } catch (e) {
      return 18.0;
    }
  }
}
