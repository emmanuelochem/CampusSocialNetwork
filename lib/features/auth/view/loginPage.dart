import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mysocial_app/core/components/buttons/primaryButton.dart';
import 'package:mysocial_app/core/logics/generalLogics.dart';
import 'package:mysocial_app/core/utils/colors.dart';
import 'package:mysocial_app/features/auth/auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthDataProvider authDataProvider;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    authDataProvider = Provider.of<AuthDataProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    // var log = authDataProvider;
    //log.page = 'otp';
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.black),
              centerTitle: true,
              leading: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Platform.isAndroid
                    ? const Icon(Icons.arrow_back)
                    : const Icon(Icons.arrow_back_ios),
              ),
              automaticallyImplyLeading: false,
              elevation: 0),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //phone
                  authDataProvider.loginPage == 'phone'
                      ? const EnterPhone()
                      : const SizedBox(),
                  //otp
                  authDataProvider.loginPage == 'otp'
                      ? const VerifyPhone()
                      : const SizedBox(),
                ],
              ),
            ),
          )),
    );
  }
}

class EnterPhone extends StatefulWidget {
  const EnterPhone();

  @override
  State<EnterPhone> createState() => _EnterPhoneState();
}

class _EnterPhoneState extends State<EnterPhone> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  AuthController authController = AuthController();
  AuthDataProvider authDataProvider;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    authDataProvider = context.read<AuthDataProvider>();
  }

  _sendCode() async {
    if (!FocusScope.of(context).hasPrimaryFocus) {
      FocusScope.of(context).unfocus();
    }
    if (!_formKey.currentState.validate()) return;
    setState(() => _isLoading = true);
    Map<String, dynamic> data = {
      'phone': authDataProvider.loginPhone,
    };
    var response = await authController.login(
      data: data,
      context: context,
      //userDataProvider: userDataProvider,
    );
    if (response == null) {
      setState(() => _isLoading = false);
    }
    if (response == 'proceed') {
      setState(() => _isLoading = false);
      authDataProvider.loginPage = 'otp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.8.sh,
      width: 1.sw,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Enter Your Number',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'An SMS would be sent to your phone number to verify your identity.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 0.03.sh),
            IntlPhoneField(
              //enabled: !_isLoading,
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                errorStyle: TextStyle(fontSize: 8),
                labelText: '',
                counterText: '',
              ),
              countries: const ['NG'],
              initialCountryCode: 'NG',
              onChanged: (phone) {
                authDataProvider.loginPhone =
                    phone.completeNumber.replaceAll(RegExp(r'\+2340'), '+234');
              },
              keyboardType: TextInputType.phone,
              //validator: FormValidationLogics.isPhone(phone),
            ),
            const Spacer(),
            const Text(
              'By tapping continue, you "Agree" to our Terms of Service.',
              style: TextStyle(color: greyColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            PrimaryButton(
                isLoading: _isLoading,
                onPressed: _isLoading
                    ? null
                    : () {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }
                        GeneralLogics.showAlert(
                            title: true,
                            titleText: 'We will be verifying your phone number',
                            body: true,
                            bodyText: authDataProvider.loginPhone,
                            footer: true,
                            footerText:
                                'Is it okay, or would you like to change the phone number',
                            cancel: true,
                            cancelText: 'Edit',
                            cancelFunction: () => Navigator.pop(context),
                            okay: true,
                            okayText: 'Okay',
                            okayFunction: () {
                              Navigator.pop(context);
                              _sendCode();
                            },
                            context: context);
                      },
                text: 'Continue'),
          ],
        ),
      ),
    );
  }
}

class VerifyPhone extends StatefulWidget {
  const VerifyPhone();

  @override
  State<VerifyPhone> createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  AuthController authController = AuthController();

  AuthDataProvider authDataProvider;
  UserDataProvider userDataProvider;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    authDataProvider = context.watch<AuthDataProvider>();
    userDataProvider = context.watch<UserDataProvider>();
  }

  bool _isLoading = false;
  bool _buttonActive = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.8.sh,
      width: 1.sw,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Verify Phone Number',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Waiting to automatically detect an SMS sent to ${authDataProvider.loginPhone}.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 0.04.sh),
            SizedBox(
              width: 0.8.sw,
              child: PinCodeTextField(
                enabled: !_isLoading,
                appContext: context,
                pastedTextStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                length: 6,
                obscureText: false,
                obscuringCharacter: '*',
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 50,
                  borderWidth: 1,
                  inactiveColor: Theme.of(context).colorScheme.secondary,
                  // activeColor: Theme.of(context).accentColor,
                  selectedFillColor: Colors.transparent,
                  selectedColor: Theme.of(context).colorScheme.secondary,
                  inactiveFillColor: Colors.transparent,
                  activeFillColor: Colors.transparent,
                ),
                cursorColor: Theme.of(context).primaryColor,
                animationDuration: const Duration(milliseconds: 300),
                textStyle: const TextStyle(fontSize: 20, height: 1.6),
                backgroundColor: Colors.transparent,
                enableActiveFill: true,
                keyboardType: TextInputType.number,
                onCompleted: (v) async {
                  setState(() => _buttonActive = true);
                  if (!FocusScope.of(context).hasPrimaryFocus) {
                    FocusScope.of(context).unfocus();
                  }
                  if (_formKey.currentState.validate()) {
                    //widget.log.page = 'gender';
                  }
                },
                onChanged: (value) {
                  authDataProvider.otp = value;
                },
                beforeTextPaste: (text) {
                  return true;
                },
              ),
            ),
            SizedBox(height: 0.02.sh),
            GestureDetector(
                onTap: () => authDataProvider.page = 'phone',
                child: Text("Resend",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        fontFamily: 'NotoSans'))),
            const Spacer(),
            PrimaryButton(
                isLoading: _isLoading,
                onPressed: !_buttonActive
                    ? null
                    : _isLoading
                        ? null
                        : () async {
                            if (!_formKey.currentState.validate()) return;
                            setState(() => _isLoading = true);
                            Map<String, dynamic> data = {
                              'phone': authDataProvider.loginPhone,
                              'code': authDataProvider.otp,
                            };
                            var response = await authController.validateLogin(
                              data: data,
                              context: context,
                              userDataProvider: userDataProvider,
                            );
                            if (response == null) {
                              setState(() => _isLoading = false);
                            }
                          },
                text: 'Verify'),
          ],
        ),
      ),
    );
  }
}
