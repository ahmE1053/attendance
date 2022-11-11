import 'package:flutter/material.dart';

import 'package:attendance/core/utilities/dependency_injection.dart';
import 'package:attendance/domain/repository/base_attendance_repository.dart';

class GetQrCodeInPdfUseCaseCloud {
  final BaseAttendanceRepository baseAttendanceRepository =
      getIt.get<BaseAttendanceRepository>();
  Future<String> getQrCodeInPdfUseCaseCloud(
      String id, String name, Size mq) async {
    return await baseAttendanceRepository.addQrCodePdfToCloudAndGetLink(
        id, name, mq);
  }
}
