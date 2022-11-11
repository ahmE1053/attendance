import 'package:flutter/material.dart';

import '../../../core/providers/app_provider.dart';

class OffDaysSelectorWidget extends StatelessWidget {
  const OffDaysSelectorWidget({
    Key? key,
    required this.weekDaysProvider,
    required this.mq,
  }) : super(key: key);
  final AppProvider weekDaysProvider;
  final Size mq;

  @override
  Widget build(BuildContext context) {
    /*
    هنا عملنا column عشان نعمل فيه ايام الاسبوع وبيتم اختيار ايام الاجازة للموظف منهم وخليناها column عشان الايام بالعربي كبيرة على انها تتحط ف سطر واحد
    وعملنا ليست ف ملف ال constants فيها ايام الاسبوع وجينا ف اول سطر خدنا اول اربع ايام وتاني سطر خدنا اخر تلاتة بس عكسنا الليست عشان تاخد تلاتة من ورا
    بعدها عكسناها تاني عشان تعدل ترتيبهم
    وهعمل animatedContainer تغير اللون بانيميشن ظريف كده لما يداس عليها عشان تحدد ان اليوم ده تم اختياره
    وبعدها كل الايام بتتسيف ف قايمة والقايمة دي بتتبعت لما بيتم تسجيل موظف جديد
    وطبعا هعمل state management عشان تبقى الشاشة الاساسية اللي فيها الويدجت عارفة توصل لليست دي وتبعتها فعلا لما يتسجل الموظف
    مع اني كنت عاوز اعمله من غير state management بس نعمل ايه :(
     */
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FittedBox(
            alignment: Alignment.center,
            fit: BoxFit.scaleDown,
            child: Text(
              'أيام الأجازة الخاصة بالموظف',
              style: TextStyle(
                fontSize: mq.width * 0.07,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Row(
            children: weekDaysProvider.weekDays.entries.take(4).map(
              (e) {
                final weekDayName = e.key;
                final isSelected = e.value['isSelected'] as bool;
                return Expanded(
                  child: DayWidget(
                    weekDayProvider: weekDaysProvider,
                    isSelected: isSelected,
                    mq: mq,
                    weekDayName: weekDayName,
                  ),
                );
              },
            ).toList(),
          ),
          Row(
            children: weekDaysProvider.weekDays.entries
                .toList()
                .reversed
                .take(3)
                .toList()
                .reversed
                .map(
              (e) {
                final weekDayName = e.key;
                final isSelected = e.value['isSelected'] as bool;
                return Expanded(
                  child: DayWidget(
                    weekDayProvider: weekDaysProvider,
                    isSelected: isSelected,
                    mq: mq,
                    weekDayName: weekDayName,
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}

class DayWidget extends StatelessWidget {
  const DayWidget({
    Key? key,
    required this.weekDayName,
    required this.isSelected,
    required this.mq,
    required this.weekDayProvider,
  }) : super(key: key);
  final String weekDayName;
  final bool isSelected;
  final Size mq;
  final AppProvider weekDayProvider;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
        weekDayProvider.onTap(weekDayName, isSelected);
      },
      child: AnimatedContainer(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(20),
        duration: const Duration(
          milliseconds: 500,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
          ),
          shape: BoxShape.circle,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            weekDayName,
            style: TextStyle(
              fontSize: mq.width * 0.05,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
