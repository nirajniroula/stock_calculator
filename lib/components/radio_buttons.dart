import 'package:flutter/material.dart';
import 'package:stock_calculator/main.dart';

// enum TranactionType { buy, sell }

class RadioButtons extends StatelessWidget {
  const RadioButtons({
    super.key,
    required this.onValueChanged,
    required this.value,
  });

  final Function onValueChanged;
  final TranactionType value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Row(
            children: [
              Radio<TranactionType>(
                value: TranactionType.buy,
                groupValue: value,
                onChanged: (TranactionType? value) {
                  onValueChanged(value);
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Buy'),
              ),
            ],
          ),
          const SizedBox(width: 24), // give it width

          Row(
            children: [
              Radio<TranactionType>(
                value: TranactionType.sell,
                groupValue: value,
                onChanged: (TranactionType? value) {
                  onValueChanged(value);
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Sell'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
