import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syariah/utils/constants.dart' as Constants;
import 'package:syariah/utils/flutter_masked_text.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: HomePage(),
      theme: CupertinoThemeData(brightness: Brightness.light),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Group of CONTROLLER
  final tfPriceController = MoneyMaskedTextController();
  final tfDownPaymentController = MoneyMaskedTextController();
  final tfMarginController = MoneyMaskedTextController();
  final tfTenorController = MoneyMaskedTextController();
  final tfMonthlyBillController = MoneyMaskedTextController();

  @override
  void dispose() {
    tfPriceController.dispose();
    tfDownPaymentController.dispose();
    tfMarginController.dispose();
    tfTenorController.dispose();
    tfMonthlyBillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This app is designed only to work vertically
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        middle: Text(Constants.APP_NAME),
      ),
      child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text('Harga Rumah',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ),
                CupertinoTextField(
                  controller: tfPriceController,
                  padding: EdgeInsets.all(10),
                  keyboardType: TextInputType.number,
                  prefix: Text(
                    Constants.PADDING + Constants.CURRENCY,
                    style: TextStyle(color: Colors.grey),
                  ),
                  placeholder: '0',
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5, top: 15),
                  child: Text('Uang Muka',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ),
                CupertinoTextField(
                  controller: tfDownPaymentController,
                  padding: EdgeInsets.all(10),
                  keyboardType: TextInputType.number,
                  prefix: Text(
                    Constants.PADDING + Constants.CURRENCY,
                    style: TextStyle(color: Colors.grey),
                  ),
                  placeholder: '0',
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5, top: 15),
                  child: Text('Margin (%)',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ),
                CupertinoTextField(
                  controller: tfMarginController,
                  padding: EdgeInsets.all(10),
                  keyboardType: TextInputType.number,
                  prefix: Text(
                    Constants.PADDING + Constants.CURRENCY,
                    style: TextStyle(color: Colors.grey),
                  ),
                  placeholder: '0',
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5, top: 15),
                  child: Text('Lama Cicilan (Tahun)',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ),
                CupertinoTextField(
                  controller: tfTenorController,
                  padding: EdgeInsets.all(10),
                  keyboardType: TextInputType.number,
                  prefix: Text(
                    Constants.PADDING + Constants.CURRENCY,
                    style: TextStyle(color: Colors.grey),
                  ),
                  placeholder: '0',
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5, top: 15),
                  child: Text('Perkiraan Cicilan / Bulan',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ),
                CupertinoTextField(
                  controller: tfMonthlyBillController,
                  readOnly: true,
                  padding: EdgeInsets.all(10),
                  keyboardType: TextInputType.number,
                  prefix: Text(
                    Constants.PADDING + Constants.CURRENCY,
                    style: TextStyle(color: Colors.grey),
                  ),
                  placeholder: '0',
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    onPressed: _countMonthlyBill,
                    disabledColor: Colors.blue,
                    color: Colors.blue,
                    child: Text('Hitung'.toUpperCase()),
                  ),
                )
              ],
            ),
          )),
    );
  }

  // Group of EVENT METHOD
  void _countMonthlyBill() {
    setState(() {
      int price = getIntValue(tfPriceController);
      int downPayment = getIntValue(tfDownPaymentController);
      double margin = getIntValue(tfMarginController) / 100;
      int tenor = getIntValue(tfTenorController);

      int remainingPrice = price - downPayment;
      double mainBill = remainingPrice / (tenor * 12);
      double billInterest = mainBill + (margin * remainingPrice / 12);
      double myBill = ((margin * mainBill) + billInterest + mainBill) / 2;
      tfMonthlyBillController.text = myBill.round().toString();
    });
  }

  int getIntValue(MoneyMaskedTextController controller) {
    return int.tryParse(controller.text.replaceAll(".", "")) ?? 0;
  }
}
