import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/providers/app_provider.dart';

class AllowedDelayWidget extends StatefulWidget {
  const AllowedDelayWidget(
      {required this.isPortrait, Key? key, required this.mq})
      : super(key: key);
  final Size mq;
  final bool isPortrait;

  @override
  State<AllowedDelayWidget> createState() => _AllowedDelayWidgetState();
}

class _AllowedDelayWidgetState extends State<AllowedDelayWidget> {
  final _hoursTextFieldController = TextEditingController(),
      _minutesTextFieldController = TextEditingController();
  final FocusNode _hoursFocusNode = FocusNode(),
      _minutesFocusNode = FocusNode();
  String previousValueMinutes = '0', previousValueHours = '0';

  @override
  Widget build(BuildContext context) {
    final mq = widget.mq;
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    _hoursTextFieldController.text = appProvider.allowedDelayHours;
    _hoursTextFieldController.selection = TextSelection.fromPosition(
        TextPosition(offset: _hoursTextFieldController.text.length));
    _minutesTextFieldController.text = appProvider.allowedDelayMinutes;
    _minutesTextFieldController.selection = TextSelection.fromPosition(
        TextPosition(offset: _minutesTextFieldController.text.length));

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          strokeAlign: StrokeAlign.outside,
          width: 3,
        ),
      ),
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'المدة المسموح للموظف التأخر بها\n قبل احتسابه غائب لليوم',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: mq.width * 0.06,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      focusNode: _minutesFocusNode,
                      decoration: InputDecoration(
                        hintText: '0',
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 3,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        labelText: 'دقيقة',
                      ),
                      controller: _minutesTextFieldController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      onChanged: (value) {
                        if (RegExp(r'(^(|[0-9]|[0-5][0-9])$)')
                            .hasMatch(value)) {
                          previousValueMinutes = value;
                          appProvider.allowedDelayMinutes = value;
                        } else {
                          _minutesTextFieldController.text =
                              previousValueMinutes;
                          _minutesTextFieldController.selection =
                              TextSelection.fromPosition(
                            TextPosition(
                              offset:
                                  _minutesTextFieldController.value.text.length,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  FittedBox(
                    alignment: Alignment.topCenter,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      ':',
                      style: TextStyle(
                        fontSize: mq.width * 0.05,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,

                      //SameThing

                      // onSubmitted: (_) {
                      //   FocusScope.of(context).requestFocus(_minutesFocusNode);
                      // },

                      textAlign: TextAlign.center,
                      focusNode: _hoursFocusNode,
                      controller: _hoursTextFieldController,
                      onChanged: (value) {
                        if (RegExp(r'(^(|[0-9]|[0][1-9])$)').hasMatch(value)) {
                          previousValueHours = value;
                          appProvider.allowedDelayHours = value;
                        } else {
                          _hoursTextFieldController.text = previousValueHours;
                          _hoursTextFieldController.selection =
                              TextSelection.fromPosition(
                            TextPosition(
                              offset:
                                  _hoursTextFieldController.value.text.length,
                            ),
                          );
                        }
                      },
                      // onChanged: (value) {
                      //   appProvider.allowedDelayHours = value;
                      // },

                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        hintText: '0',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 3,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        labelText: 'ساعة',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
