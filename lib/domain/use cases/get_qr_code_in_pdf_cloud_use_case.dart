import 'package:flutter/material.dart';

import '../../core/utilities/dependency_injection.dart';
import '../repository/base_attendance_repository.dart';

class GetQrCodeInPdfUseCaseCloud {
  final BaseAttendanceRepository baseAttendanceRepository =
      getIt.get<BaseAttendanceRepository>();
  Future<String> getQrCodeInPdfUseCaseCloud(
      String id, String name, Size mq) async {
    return await baseAttendanceRepository.addQrCodePdfToCloudAndGetLink(
        id, name, mq);
  }
}
