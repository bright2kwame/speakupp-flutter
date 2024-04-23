import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_toast_message/simple_toast.dart';
import 'package:speakupp/api/api_exception.dart';
import 'package:speakupp/api/polls/poll_call.dart';
import 'package:speakupp/common/app_enums.dart';
import 'package:speakupp/common/app_navigate.dart';
import 'package:speakupp/common/app_resourses.dart';
import 'package:speakupp/common/app_utility.dart';
import 'package:speakupp/model/common/api_request.dart';
import 'package:speakupp/model/poll/poll_item.dart';
import 'package:speakupp/model/poll/poll_option_item.dart';
import 'package:speakupp/ui/common/app_fullscreen_progree_view.dart';
import 'package:speakupp/ui/common/app_input_decorator.dart';
import 'package:speakupp/ui/common/custom_app_bar.dart';
import 'package:speakupp/ui/common/primary_button.dart';
import 'package:speakupp/ui/common/size_config.dart';
import 'package:speakupp/ui/polls/make_payment_page.dart';

class BuyVotePage extends StatefulWidget {
  final PollItem pollItem;
  final PollOptionItem pollOptionItem;
  const BuyVotePage(
      {super.key, required this.pollItem, required this.pollOptionItem});

  @override
  State<BuyVotePage> createState() => _BuyVotePageState();
}

class _BuyVotePageState extends State<BuyVotePage> {
  bool _loading = false;
  final PollCall pollCall = GetIt.instance.get<PollCall>();
  final TextEditingController _quantityController = TextEditingController();
  String actionTitle = "PAY FOR VOTE";
  double amountPayable = 0.0;
  double quantityPayable = 0.0;

  @override
  void initState() {
    super.initState();
    _quantityController.addListener(_updateAmount);
    WidgetsBinding.instance.addPostFrameCallback((_) => _uiReady(context));
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _uiReady(BuildContext buildContext) {}

  //MARK: amount here
  void _updateAmount() {
    quantityPayable = double.tryParse(_quantityController.text.trim()) ?? 0.0;
    AppUtility.printLogMessage(quantityPayable, "AMOUNT");
    if (quantityPayable > 0.0) {
      amountPayable =
          quantityPayable * double.parse(widget.pollItem.pricePerSMS);
      String amountToDisplay = (amountPayable).toStringAsFixed(2);
      setState(() {
        actionTitle = "PAY FOR VOTE (GHS $amountToDisplay)";
      });
    } else {
      setState(() {
        actionTitle = "PAY FOR VOTE";
      });
    }
  }

  void _makePayment() {
    if (amountPayable <= 0.00) {
      SimpleToast.showErrorToast(
          context, "SpeakUpp", "Provide the quantity of vote to purchase");
      return;
    }
    String url = AppResourses.appStrings.paidPollUrl;
    var params = {
      "poll_id": widget.pollItem.id,
      "quantity": quantityPayable,
      "choice_id": widget.pollOptionItem.id,
      "total_amount": amountPayable,
    };
    if (widget.pollItem.pollType.toLowerCase() ==
        PollType.MULTIPLE.name.toLowerCase()) {
      url = AppResourses.appStrings.getParameterPaidPollUrl(widget.pollItem.id);
    }
    ApiRequest request = ApiRequest(url: url, data: params);
    setState(() {
      _loading = true;
    });
    pollCall.makePayment(request).whenComplete(() {
      setState(() {
        _loading = false;
      });
    }).then((value) {
      _proceedToPay(value.result ?? "");
    }).onError((error, stackTrace) {
      SimpleToast.showErrorToast(
          context, "SpeakUpp", (error as ApiException).message);
    });
  }

  void _proceedToPay(String url) {
    AppNavigate(context).navigateWithPush(
      MakePaymentPage(url: url),
      callback: (p0) {
        Navigator.of(context).pop(true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _loading ? const AppFullscreenProgressView(message: "") : _mainView(),
      appBar: CustomAppBar.subBar(
          leadingAction: () {
            Navigator.of(context).pop();
          },
          title: "Purchase Vote",
          textColor: Colors.white,
          backgroundColor: AppResourses.appColors.primaryColor),
      backgroundColor: AppResourses.appColors.background,
    );
  }

  Widget _mainView() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                text: 'Casting vote for: ${widget.pollItem.question}\n\n',
                style: AppResourses.appTextStyles.textStyle(
                  16,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text:
                          'Candidate:  ${widget.pollOptionItem.choiceText}\n\n',
                      style: AppResourses.appTextStyles.textStyle(
                        16,
                        weight: FontWeight.bold,
                      )),
                  TextSpan(
                      text: 'A vote cost GHS:  ${widget.pollItem.pricePerSMS}',
                      style: AppResourses.appTextStyles.textStyle(
                        16,
                        weight: FontWeight.bold,
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            child: TextFormField(
                maxLines: 1,
                controller: _quantityController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: AppResourses.appTextStyles
                    .textStyle(24, fontColor: Colors.black),
                decoration: AppInputDecorator.underlineDecoration(
                    "Number of Vote",
                    textStyle: AppResourses.appTextStyles
                        .textStyle(16, fontColor: Colors.black),
                    contentPadding: const EdgeInsets.only(bottom: 12))),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
            child: PrimaryButton(
                size: Size(SizeConfig(context).screenW! - 32, 50),
                text: actionTitle,
                color: AppResourses.appColors.primaryColor,
                onClick: _makePayment),
          ),
        ],
      ),
    );
  }
}
