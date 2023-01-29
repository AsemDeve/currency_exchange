import 'networking.dart';

const apiKeys = '3584BD4F-9508-4E7A-999C-594E1791D73A';
const coinApiURL = 'https://rest.coinapi.io/v1/exchangerate/';

class CoinExchange {
  Future<dynamic> getCoinRate(
      {required String currencyName, required String exchangeName}) async {
    NetworkHelper networkHelper =
        NetworkHelper('$coinApiURL$currencyName/$exchangeName?apikey=$apiKeys');

    var coinRateData = await networkHelper.getData();

    return coinRateData;
  }
}
