import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    required this.controller,
    required this.label,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      validator: validator,
    );
  }
}

// test/widgets/custom_text_form_field_test.dart

void main() {
  testWidgets('CustomTextFormField test', (WidgetTester tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CustomTextFormField(
          controller: controller,
          label: 'Test Field',
        ),
      ),
    ));

    expect(find.text('Test Field'), findsOneWidget);
  });
}