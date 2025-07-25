import 'package:flutter_test/flutter_test.dart';

import 'package:currency_textfield/currency_textfield.dart';

void main() {
  test('test_add_0_asInput_for_controller', () {
    final controller = CurrencyTextFieldController();
    controller.text = "0";
    expect(controller.text, "");
    expect(controller.doubleValue, 0.0);
  });

  test('test_add_inputNonZero_for_controller', () {
    final controller = CurrencyTextFieldController();

    controller.text = "1244";
    expect(controller.text, "R\$ 12,44");
    expect(controller.doubleValue, 12.44);
  });

  test('test_change_symbols_constructor', () {
    final controller = CurrencyTextFieldController(
        currencySymbol: "RR", decimalSymbol: ".", thousandSymbol: ",");

    expect(controller.thousandSymbol, ",");
    expect(controller.currencySymbol, "RR");
    expect(controller.decimalSymbol, ".");
  });

  test('test_invalid_input', () {
    final controller = CurrencyTextFieldController();
    controller.text = "abcl;'s";
    expect(controller.text, "");
    expect(controller.doubleValue, 0.0);
  });

  test('test_insert_input_greatherThan_maximumValue', () {
    final controller = CurrencyTextFieldController();
    controller.text = "9999999999999999";
    expect(controller.text, '');
    expect(controller.doubleValue, 0.0);
  });

  test(
      'test_insert_some_inputs_and_after_tryToInsertAValue_greatherThan_maximumValue',
      () {
    final controller = CurrencyTextFieldController();
    controller.text = "99";
    expect(controller.text, 'R\$ 0,99');
    expect(controller.doubleValue, 0.99);

    controller.text = "9999999999999999";
    expect(controller.text, 'R\$ 0,99');
    expect(controller.doubleValue, 0.99);
  });

  test('test_insert_numbers_with_symbols', () {
    final controller = CurrencyTextFieldController();
    controller.text = "-19,24.123";
    expect(controller.text, '-R\$ 19.241,23');
    expect(controller.doubleValue, -19241.23);

    controller.text = "-19?24.123";
    expect(controller.text, '-R\$ 19.241,23');
  });

  test('initDouble', () {
    final controller = CurrencyTextFieldController(initDoubleValue: 19.5);
    expect(controller.text, 'R\$ 19,50');
  });

  test('initInt', () {
    final controller = CurrencyTextFieldController(initIntValue: 195);
    expect(controller.text, 'R\$ 1,95');
    expect(controller.doubleValue, 1.95);
  });

  test('positioned_symbol', () {
    final controller =
        CurrencyTextFieldController(initIntValue: 195, currencyOnLeft: false);
    expect(controller.text, '1,95 R\$');
  });

  test('negative_and_block', () {
    final controller = CurrencyTextFieldController(initIntValue: -195);
    final controller2 =
        CurrencyTextFieldController(initIntValue: -195, enableNegative: false);
    expect(controller.text, '-R\$ 1,95');
    expect(controller2.text, 'R\$ 1,95');
  });

  test('force_value', () {
    final controller = CurrencyTextFieldController(initIntValue: 195);
    controller.forceValue(initIntValue: 100);
    expect(controller.text, 'R\$ 1,00');
    controller.forceValue(initDoubleValue: 100);
    expect(controller.text, 'R\$ 100,00');
  });

  test('get_text_without_currency', () {
    final controller = CurrencyTextFieldController(initIntValue: 195);
    final controller2 =
        CurrencyTextFieldController(initIntValue: 195, currencyOnLeft: false);
    final controller3 = CurrencyTextFieldController(
        initDoubleValue: 195, currencySymbol: 'test', currencySeparator: ' e ');
    final controller4 = CurrencyTextFieldController(
      initIntValue: 195,
      currencyOnLeft: false,
      currencySymbol: '\$',
      currencySeparator: '->',
      decimalSymbol: ':',
    );
    expect(controller.textWithoutCurrencySymbol, '1,95');
    expect(controller2.textWithoutCurrencySymbol, '1,95');
    expect(controller3.textWithoutCurrencySymbol, '195,00');
    expect(controller4.textWithoutCurrencySymbol, '1:95');
  });

  test('initInt_with_numberOfDecimals', () {
    final controller = CurrencyTextFieldController(initIntValue: 195);
    final controller2 =
        CurrencyTextFieldController(initIntValue: 1950, numberOfDecimals: 1);
    final controller3 =
        CurrencyTextFieldController(initIntValue: 19500, numberOfDecimals: 3);

    expect(controller.textWithoutCurrencySymbol, '1,95');
    expect(controller2.textWithoutCurrencySymbol, '195,0');
    expect(controller3.textWithoutCurrencySymbol, '19,500');
  });

  test('zero_Decimals', () {
    final controller =
        CurrencyTextFieldController(initIntValue: 19500, numberOfDecimals: 0);

    expect(controller.textWithoutCurrencySymbol, '19.500');
    expect(controller.doubleValue, 19500.0);
    expect(controller.intValue, 19500);
    expect(controller.doubleTextWithoutCurrencySymbol, '19500');
    expect(controller.textWithoutCurrencySymbol, '19.500');
  });

  test('maxValue', () {
    final controller =
        CurrencyTextFieldController(initDoubleValue: 300, maxValue: 400);

    controller.forceValue(initDoubleValue: 350);
    expect(controller.textWithoutCurrencySymbol, '350,00');
    controller.forceValue(initDoubleValue: 3500);
    expect(controller.textWithoutCurrencySymbol, '400,00');
  });

  test('replace_symbol', () {
    final controller = CurrencyTextFieldController(initIntValue: 195);
    controller.replaceCurrencySymbol('EUR');
    expect(controller.text, 'EUR 1,95');
    expect(controller.doubleValue, 1.95);
    expect(controller.intValue, 195);
    expect(controller.currencySymbol, 'EUR');
    expect(controller.doubleTextWithoutCurrencySymbol, '1.95');
    expect(controller.textWithoutCurrencySymbol, '1,95');

    controller.replaceCurrencySymbol('USD', resetValue: true);
    expect(controller.text, '');
    expect(controller.doubleValue, 0);
    expect(controller.intValue, 0);
    expect(controller.currencySymbol, 'USD');
    expect(controller.doubleTextWithoutCurrencySymbol, '0');
    expect(controller.textWithoutCurrencySymbol, '');
  });

  test('replace_maxValue', () {
    final controller =
        CurrencyTextFieldController(initDoubleValue: 300, maxValue: 400);

    controller.forceValue(initDoubleValue: 600);
    expect(controller.textWithoutCurrencySymbol, '400,00');
    controller.replaceMaxValue(700);
    controller.forceValue(initDoubleValue: 600);
    expect(controller.textWithoutCurrencySymbol, '600,00');
    controller.replaceMaxValue(500);
    expect(controller.textWithoutCurrencySymbol, '500,00');
  });

  test('test_allowZeroValue_shoulDisplayZeroValueFormatted', () {
    final controller =
        CurrencyTextFieldController(initIntValue: 0, showZeroValue: true);

    expect(controller.text, "R\$ 0,00");
  });

  test('test_allowZeroValue_whithoutInitialValue_shoulDisplayEmptyString', () {
    final controller = CurrencyTextFieldController(showZeroValue: true);
    final controller2 = CurrencyTextFieldController(initIntValue: 0);

    expect(controller.text, '');
    expect(controller2.text, '');
  });

  test('enableNegative + showZeroValue bug fix', () {
    final controller = CurrencyTextFieldController(showZeroValue: true);
    controller.text = "R\$ 0,00-";

    expect(controller.text, '-R\$ 0,00');
    controller.clear();
    controller.text = "R\$ 7,00-";
    expect(controller.text, "R\$ 7,00");
  });

  test('minValue', () {
    final controller =
        CurrencyTextFieldController(initDoubleValue: 300, minValue: 200);
    final controller2 =
        CurrencyTextFieldController(initDoubleValue: 100, minValue: 200);

    controller.forceValue(initDoubleValue: 100);
    expect(controller.textWithoutCurrencySymbol, '200,00');
    expect(controller2.textWithoutCurrencySymbol, '200,00');
  });

  test('replace_minValue', () {
    final controller =
        CurrencyTextFieldController(initDoubleValue: 300, minValue: 200);

    controller.forceValue(initDoubleValue: 100);
    expect(controller.textWithoutCurrencySymbol, '200,00');
    controller.replaceMinValue(0);
    controller.forceValue(initDoubleValue: 50);
    expect(controller.textWithoutCurrencySymbol, '50,00');
  });

  test('remove_symbol', () {
    final controller =
        CurrencyTextFieldController(initDoubleValue: 300, removeSymbol: true);

    expect(controller.textWithoutCurrencySymbol, '300,00');
    expect(controller.text, '300,00');
    expect(controller.currencySymbol, 'R\$');
    expect(controller.doubleValue, 300);
    expect(controller.intValue, 30000);
    expect(controller.doubleTextWithoutCurrencySymbol, '300.00');
  });

  test('clear_zero_value', () {
    final controller =
        CurrencyTextFieldController(initIntValue: 0, showZeroValue: true);

    controller.clear();
    expect(controller.text, "");
  });

  test('test_clear_input_bug_with_zero_decimals', () {
    final controller = CurrencyTextFieldController(numberOfDecimals: 0);

    // Type 123
    controller.text = "123";
    expect(controller.text, "R\$ 123");
    expect(controller.doubleValue, 123.0);

    // Try to clear - this should work but currently doesn't
    controller.clear();
    expect(controller.text, "");
    expect(controller.doubleValue, 0.0);
  });

  test('test_clear_input_works_with_decimals', () {
    final controller = CurrencyTextFieldController(numberOfDecimals: 2);

    // Type 123
    controller.text = "123";
    expect(controller.text, "R\$ 1,23");
    expect(controller.doubleValue, 1.23);

    // Try to clear - this should work
    controller.clear();
    expect(controller.text, "");
    expect(controller.doubleValue, 0.0);
  });

  test('test_delete_characters_one_by_one_with_zero_decimals', () {
    final controller = CurrencyTextFieldController(numberOfDecimals: 0);

    // Type 123
    controller.text = "123";
    expect(controller.text, "R\$ 123");
    expect(controller.doubleValue, 123.0);

    // Simulate deleting one character at a time (like backspacing)
    controller.text = "R\$ 12"; // Delete the '3'
    // This should result in "R\$ 12", but might have issues

    controller.text = "R\$ 1"; // Delete another character
    // This should result in "R\$ 1"

    controller.text = "R\$"; // Delete the last number
    // This should clear to empty string

    expect(controller.text, "");
    expect(controller.doubleValue, 0.0);
  });

  test('test_empty_string_input_with_zero_decimals', () {
    final controller = CurrencyTextFieldController(numberOfDecimals: 0);

    // Type 123
    controller.text = "123";
    expect(controller.text, "R\$ 123");
    expect(controller.doubleValue, 123.0);

    // Set text to empty string directly (simulating clearing the field)
    controller.text = "";
    expect(controller.text, "");
    expect(controller.doubleValue, 0.0);
  });

  test('test_clear_input_with_zero_decimals_and_showZeroValue', () {
    final controller =
        CurrencyTextFieldController(numberOfDecimals: 0, showZeroValue: true);

    // Type 123
    controller.text = "123";
    expect(controller.text, "R\$ 123");
    expect(controller.doubleValue, 123.0);

    // Clear the field - should work correctly now (bug fix)
    controller.text = "";
    expect(controller.text, "");
    expect(controller.doubleValue, 0.0);
  });
}
