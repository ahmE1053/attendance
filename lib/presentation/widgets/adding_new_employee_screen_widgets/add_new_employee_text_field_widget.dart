import 'package:flutter/material.dart';

class AddNewEmployeeTextField extends StatefulWidget {
  const AddNewEmployeeTextField({
    Key? key,
    required this.formKey,
    required this.textEditingController,
  }) : super(key: key);
  final GlobalKey<FormState> formKey;
  final TextEditingController textEditingController;
  @override
  State<AddNewEmployeeTextField> createState() =>
      _AddNewEmployeeTextFieldState();
}

class _AddNewEmployeeTextFieldState extends State<AddNewEmployeeTextField> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: TextFormField(
        onChanged: (_) {
          widget.formKey.currentState!.validate();
        },
        onTap: () {
          if (widget.textEditingController.selection ==
              TextSelection.fromPosition(TextPosition(
                  offset: widget.textEditingController.text.length - 1))) {
            setState(() {
              widget.textEditingController.selection =
                  TextSelection.fromPosition(TextPosition(
                      offset: widget.textEditingController.text.length));
            });
          }
        },
        cursorColor: Theme.of(context).colorScheme.primary,
        decoration: InputDecoration(
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          label: const Text('اسم الموظف'),
          floatingLabelStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'برجاء كتابة اسم الموظف';
          }
          return null;
        },
        controller: widget.textEditingController,
      ),
    );
  }
}
