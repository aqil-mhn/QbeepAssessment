import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoDataScreen extends StatefulWidget {
  const NoDataScreen({
    Key? key,
  }) : super(key: key);
  State<NoDataScreen> createState() => _NoDataScreen();
}

class _NoDataScreen extends State<NoDataScreen> {
  bool _visible = false;

  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _visible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double widths = MediaQuery.of(context).size.width;

    return Scaffold(
      body: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  'assets/images/no_data_found.png',
                ),
              ),
              Text(
                "No Record Found :(",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              // Flexible(
              //   child: Text(
              //     AppLocalizations.of(context)!.noDataHint,
              //     textAlign: TextAlign.center,
              //     style: const TextStyle(fontSize: 15),
              //   ),
              // ),
              // SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }
}
