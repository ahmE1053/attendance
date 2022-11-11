import 'package:flutter/material.dart';

String minutesTextAdjustor(int lateInMinutes) {
  const defaultText = 'التأخر الكلي للموظف: ';
  if (lateInMinutes == 0) {
    return '$defaultText لا يوجد';
  } else if (lateInMinutes == 1) {
    return '$defaultText دقيقة';
  } else if (lateInMinutes == 2) {
    return '$defaultText دقيقتين';
  }
  double z = lateInMinutes.toDouble();
  bool isMinutesOrMinute = false;
  /*
  هنا احنا عاوزين نعرف هل الرقم ده ايا كان هو كبير قد ايه بينتهي برقم من تلاتة لحد عشرة ولا لا
  ف هنعمل لووب هتطرح الارقام من تلاتة لحد عشرة كل مرة من الرقم بتاعنا وتشوف هل هو بعد م نقسمه على عشرة هيقبل القسمة على عشرة ولا لا
  لو قبل يبقى كده تمام لو مقبلش يبقى لا دول مش من الارقام دي
  طب ده بناءاً على ايه
  مبني على حتة ان اي رقم هينتهي ب تلاتة لعشرة هيببقى صفر لو العدد تلاتة لعشرة فعلا
  ولو مثلا رقم زي 103 او 14808 او اي رقم عليه نفس الفكرة هيبقى منتهي بصفرين ورا بعض ودول هيحققو الشرط
  لو منتهاش بصفرين اوانتهى بصفر واحد زي كده مثلا 24 او 38 او 1647867 يبقى الشرط مش هيتحقق
   */

  for (double i = 3; i < 11; i++) {
    double x = z - i;
    if ((x / 10) % 10 == 0) {
      isMinutesOrMinute = true;
      break;
    }
  }
  if (isMinutesOrMinute) {
    return '$defaultText $lateInMinutes دقائق';
  } else {
    return '$defaultText $lateInMinutes دقيقة';
  }
}

String absenceDaysTextAdjustor(int absenceDays) {
  const defaultText = 'الغياب الكلي للموظف';
  if (absenceDays == 0) {
    return '$defaultText لا يوجد';
  } else if (absenceDays == 1) {
    return '$defaultText يوم';
  } else if (absenceDays == 2) {
    return '$defaultText يومين';
  }
  double z = absenceDays.toDouble();
  bool isMinutesOrMinute = false;
  /*
  هنا احنا عاوزين نعرف هل الرقم ده ايا كان هو كبير قد ايه بينتهي برقم من تلاتة لحد عشرة ولا لا
  ف هنعمل لووب هتطرح الارقام من تلاتة لحد عشرة كل مرة من الرقم بتاعنا وتشوف هل هو بعد م نقسمه على عشرة هيقبل القسمة على عشرة ولا لا
  لو قبل يبقى كده تمام لو مقبلش يبقى لا دول مش من الارقام دي
  طب ده بناءاً على ايه
  مبني على حتة ان اي رقم هينتهي ب تلاتة لعشرة هيببقى صفر لو العدد تلاتة لعشرة فعلا
  ولو مثلا رقم زي 103 او 14808 او اي رقم عليه نفس الفكرة هيبقى منتهي بصفرين ورا بعض ودول هيحققو الشرط
  لو منتهاش بصفرين اوانتهى بصفر واحد زي كده مثلا 24 او 38 او 1647867 يبقى الشرط مش هيتحقق
   */

  for (double i = 3; i < 11; i++) {
    double x = z - i;
    if ((x / 10) % 10 == 0) {
      isMinutesOrMinute = true;
      break;
    }
  }
  if (isMinutesOrMinute) {
    return '$defaultText $absenceDays ايام';
  } else {
    return '$defaultText $absenceDays يوم';
  }
}

String vacationDaysTextAdjustor(int vacationDays) {
  const defaultText = 'الاجازات الاضافية للموظف:';
  if (vacationDays == 0) {
    return '$defaultText لا يوجد';
  } else if (vacationDays == 1) {
    return '$defaultText يوم';
  } else if (vacationDays == 2) {
    return '$defaultText يومين';
  }
  double z = vacationDays.toDouble();
  bool isMinutesOrMinute = false;
  /*
  هنا احنا عاوزين نعرف هل الرقم ده ايا كان هو كبير قد ايه بينتهي برقم من تلاتة لحد عشرة ولا لا
  ف هنعمل لووب هتطرح الارقام من تلاتة لحد عشرة كل مرة من الرقم بتاعنا وتشوف هل هو بعد م نقسمه على عشرة هيقبل القسمة على عشرة ولا لا
  لو قبل يبقى كده تمام لو مقبلش يبقى لا دول مش من الارقام دي
  طب ده بناءاً على ايه
  مبني على حتة ان اي رقم هينتهي ب تلاتة لعشرة هيببقى صفر لو العدد تلاتة لعشرة فعلا
  ولو مثلا رقم زي 103 او 14808 او اي رقم عليه نفس الفكرة هيبقى منتهي بصفرين ورا بعض ودول هيحققو الشرط
  لو منتهاش بصفرين اوانتهى بصفر واحد زي كده مثلا 24 او 38 او 1647867 يبقى الشرط مش هيتحقق
   */

  for (double i = 3; i < 11; i++) {
    double x = z - i;
    if ((x / 10) % 10 == 0) {
      isMinutesOrMinute = true;
      break;
    }
  }
  if (isMinutesOrMinute) {
    return '$defaultText $vacationDays ايام';
  } else {
    return '$defaultText $vacationDays يوم';
  }
}

String employeeWorkingTimeAdjustor(TimeOfDay timeOfDay, String text) {
  return 'موعد $text الموظف اليوم: ${timeOfDay.hourOfPeriod}:${timeOfDay.minute}${timeOfDay.period == DayPeriod.am ? ' ص' : ' م'}';
}
