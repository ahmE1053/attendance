import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/providers/network_provider.dart';
import '../../core/utilities/dependency_injection.dart';
import '../../domain/use cases/get_qr_code_in_pdf_cloud_use_case.dart';
import '../widgets/no_connection_bottom_bar.dart';

class QrCodeScreen extends StatefulWidget {
  final String name, id;
  final bool firstTime;
  final String? downloadUrl;

  const QrCodeScreen({
    Key? key,
    required this.name,
    required this.id,
    required this.firstTime,
    this.downloadUrl,
  }) : super(key: key);

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  bool isThePdfSaved = false;
  final RoundedLoadingButtonController _buttonController =
      RoundedLoadingButtonController();

  late String? downloadUrl;

  @override
  void initState() {
    super.initState();
    downloadUrl = widget.downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    final networkProvider = Provider.of<NetworkProvider>(context);
    final isConnectionWorking = networkProvider.isConnectionWorking;
    final mq = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (!widget.firstTime) {
          return true;
        }
        if (isThePdfSaved) {
          return true;
        } else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'برجاء حفظ الملف حتى يتمكن الموظف من التسجيل',
              ),
            ),
          );
          return false;
        }
      },
      child: Scaffold(
        bottomNavigationBar: NoConnectionBottomBar(
          isConnectionWorking ? 0 : mq.height * 0.07,
        ),
        appBar: AppBar(
          title: const Text(
            'الكود الخاص بالموظف',
          ),
        ),
        body: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return Padding(
                padding: EdgeInsets.all(mq.width * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'برجاء طباعة هذه الصورة لكي يقوم\n الموظف بتسجيل الحضور والانصراف بها',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: mq.width * 0.08,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                    BarcodeWidget(
                      padding: EdgeInsets.zero,
                      height: mq.height * 0.5,
                      data: widget.id,
                      color: Theme.of(context).colorScheme.onBackground,
                      barcode: Barcode.qrCode(),
                      width: mq.width * 0.9,
                      drawText: true,
                    ),
                    buildRoundedLoadingButton(isConnectionWorking, context, mq),
                  ],
                ),
              );
            } else {
              return Padding(
                padding: EdgeInsets.all(mq.height * 0.05),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'برجاء طباعة هذه الصورة لكي يقوم\n الموظف بتسجيل الحضور والانصراف بها',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: mq.height * 0.08,
                                fontWeight: FontWeight.w700,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                          ),
                          buildRoundedLoadingButton(
                              isConnectionWorking, context, mq),
                        ],
                      ),
                    ),
                    Expanded(
                      child: BarcodeWidget(
                        padding: EdgeInsets.zero,
                        data: widget.id,
                        color: Theme.of(context).colorScheme.onBackground,
                        barcode: Barcode.qrCode(),
                        drawText: true,
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  RoundedLoadingButton buildRoundedLoadingButton(
      bool isConnectionWorking, BuildContext context, Size mq) {
    return RoundedLoadingButton(
      onPressed: !isConnectionWorking
          ? null
          : () async {
              isThePdfSaved = true;
              _buttonController.start();
              final scaffold = ScaffoldMessenger.of(context);

              if (downloadUrl!.isEmpty) {
                downloadUrl = null;
              }
              downloadUrl = await getIt
                  .get<GetQrCodeInPdfUseCaseCloud>()
                  .getQrCodeInPdfUseCaseCloud(
                    widget.id,
                    widget.name,
                    mq,
                  );
              final url = Uri.parse(downloadUrl!);
              if (!await launchUrl(
                url,
                mode: LaunchMode.externalApplication,
              )) {
                scaffold.showSnackBar(
                  SnackBar(
                    content: const Text(
                      'حدث خطأ، برجاء إعادة المحاولة',
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                _buttonController.error();
                Future.delayed(const Duration(milliseconds: 700))
                    .then((value) => _buttonController.reset());
                return;
              }

              scaffold.showSnackBar(
                SnackBar(
                  content: const Text(
                    'تم حفظ الملف الى ملف التحميلات الخاص بهاتفك',
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              _buttonController.success();
            },
      successColor: Colors.greenAccent,
      controller: _buttonController,
      color: Theme.of(context).colorScheme.primary,
      child: Text(
        'حفظ الملف في صيغة pdf',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
