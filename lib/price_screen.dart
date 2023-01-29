import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'coin_rate.dart';
import 'package:flutter/services.dart';
import 'package:currency_exchange/coin_data.dart';

class PriceScreen extends StatefulWidget {
  PriceScreen({this.priceData});
  final priceData;
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  String selectedExchange = 'ILS';
  var exchangeCoinRate;
  String enteredValue = '0';
  double calculatedValue = 0.0;

  @override
  void initState() {
    super.initState();
    calculateExchange();
    getExchangeToUpdateUI();

    updateUI(widget.priceData);
  }

  void updateUI(dynamic RateData) {
    setState(() {
      if (RateData == null) {
        exchangeCoinRate = 0;

        return;
      }

      exchangeCoinRate = RateData['rate'];
    });
  }

  CoinExchange coinExchange = CoinExchange();

  void getExchangeToUpdateUI() async {
    var coinRateData = await coinExchange.getCoinRate(
        currencyName: selectedCurrency, exchangeName: selectedExchange);

    updateUI(coinRateData);
  }

  void calculateExchange() async {
    double enteredValueDouble = await double.parse(enteredValue);
    calculatedValue = await (enteredValueDouble * exchangeCoinRate);
    calculatedValue = double.parse(calculatedValue.toStringAsFixed(3));
  }

  DropdownButton<String> androidDropDownCurrency() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
        value: selectedCurrency,
        items: dropDownItems,
        onChanged: (value) {
          setState(() {
            selectedCurrency = value!;
            calculateExchange();
            getExchangeToUpdateUI();
          });
        });
  }

  DropdownButton<String> androidDropDownExchange() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
        value: selectedExchange,
        items: dropDownItems,
        onChanged: (value) {
          setState(() {
            selectedExchange = value!;

            calculateExchange();
            getExchangeToUpdateUI();
          });
        });
  }

  CupertinoPicker IOSPickerCurrency() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);
      pickerItems.add(newItem);
    }
    return CupertinoPicker(
        itemExtent: 32,
        onSelectedItemChanged: (selectedIndex) {
          selectedCurrency = selectedIndex.toString();

          calculateExchange();
          getExchangeToUpdateUI();
        },
        children: pickerItems);
  }

  CupertinoPicker IOSPickerExchange() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);
      pickerItems.add(newItem);
    }
    return CupertinoPicker(
        itemExtent: 32,
        onSelectedItemChanged: (selectedIndex) {
          selectedExchange = selectedIndex.toString();

          calculateExchange();
          getExchangeToUpdateUI();
        },
        children: pickerItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                margin: EdgeInsets.all(15),
                width: 200,
                height: 50,
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      enteredValue = value;
                      calculateExchange();
                    });
                  },
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '0.0',
                      hintStyle: TextStyle(color: Colors.black12),

                      // labelText: "Enter value",
                      labelStyle: TextStyle(color: Colors.black)),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '$enteredValue $selectedCurrency = $calculatedValue  $selectedExchange',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            // child: Platform.isIOS ? IOSPicker() : androidDropDown(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Platform.isIOS
                    ? IOSPickerCurrency()
                    : androidDropDownCurrency(),
                IconButton(
                    onPressed: () {
                      String temporaryCurrency = selectedExchange;
                      selectedExchange = selectedCurrency;
                      selectedCurrency = temporaryCurrency;
                      exchangeCoinRate = 1 / exchangeCoinRate;
                      calculateExchange();
                      getExchangeToUpdateUI();
                    },
                    icon: Icon(Icons.swap_horiz)),
                Platform.isIOS
                    ? IOSPickerExchange()
                    : androidDropDownExchange(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
