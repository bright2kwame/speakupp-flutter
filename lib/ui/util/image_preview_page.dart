import 'package:flutter/material.dart';
import 'package:speakupp/common/app_resourses.dart';
import 'package:speakupp/ui/common/custom_app_bar.dart';
import 'package:speakupp/ui/common/size_config.dart';

class ImagePreviewPage extends StatefulWidget {
  final String url;
  const ImagePreviewPage({super.key, required this.url});

  @override
  State<ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _uiReady(context));
  }

  void _uiReady(BuildContext buildContext) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _mainView(),
      appBar: CustomAppBar.subBar(
          leadingAction: () {
            Navigator.of(context).pop();
          },
          title: "Preview",
          textColor: Colors.white,
          backgroundColor: AppResourses.appColors.primaryColor),
      backgroundColor: AppResourses.appColors.darkColor,
    );
  }

  Widget _mainView() {
    return SizedBox(
      height: SizeConfig(context).screenH,
      child: Center(
        child: Image.network(
          widget.url,
        ),
      ),
    );
  }
}
