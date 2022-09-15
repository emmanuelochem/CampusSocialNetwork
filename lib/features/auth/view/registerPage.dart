import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mysocial_app/core/components/buttons/primaryButton.dart';
import 'package:mysocial_app/core/logics/formValidationLogics.dart';
import 'package:mysocial_app/core/logics/generalLogics.dart';
import 'package:mysocial_app/core/utils/colors.dart';
import 'package:mysocial_app/features/auth/auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  AuthDataProvider authDataProvider;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    authDataProvider = Provider.of<AuthDataProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    var log = authDataProvider;
    //log.page = 'otp';
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.black),
              centerTitle: true,
              leading: log.page == 'phone'
                  ? TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Platform.isAndroid
                          ? const Icon(Icons.arrow_back)
                          : const Icon(Icons.arrow_back_ios),
                    )
                  : null,
              automaticallyImplyLeading: false,
              elevation: 0),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //phone
                  log.page == 'phone' ? EnterPhone(log: log) : const SizedBox(),

                  //otp
                  log.page == 'otp' ? VerifyPhone(log: log) : const SizedBox(),

                  //gender
                  log.page == 'gender'
                      ? GenderSelector(log: log)
                      : const SizedBox(),

                  //department
                  log.page == 'department'
                      ? DepartmentSelector(log: log)
                      : const SizedBox(),

                  //name
                  log.page == 'profile'
                      ? DisplayName(log: log)
                      : const SizedBox(),
                ],
              ),
            ),
          )),
    );
  }
}

class EnterPhone extends StatefulWidget {
  final log;
  const EnterPhone({this.log});

  @override
  State<EnterPhone> createState() => _EnterPhoneState();
}

class _EnterPhoneState extends State<EnterPhone> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  _sendCode() async {
    if (!FocusScope.of(context).hasPrimaryFocus) {
      FocusScope.of(context).unfocus();
    }
    try {
      setState(() => _isLoading = true);
      Navigator.pop(context);
      AuthApi authApi = AuthApi();
      Map<String, dynamic> data = {
        'phone': widget.log.phone,
      };
      await authApi.verifyPhone(data).then((res) {
        setState(() => _isLoading = false);
        if (res['status'] != 'success') {
          return GeneralLogics.showAlert(
              title: true,
              titleText: ReCase(res['status']).sentenceCase,
              body: true,
              bodyText: ReCase(res['message']).sentenceCase,
              cancel: true,
              cancelText: 'Retry',
              cancelFunction: () => Navigator.pop(context),
              context: context);
        }
        widget.log.page = 'otp';
      });
    } catch (e) {
      setState(() => _isLoading = false);
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
                widget.log.phone =
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
                            bodyText: widget.log.phone,
                            footer: true,
                            footerText:
                                'Is it okay, or would you like to change the phone number',
                            cancel: true,
                            cancelText: 'Edit',
                            cancelFunction: () => Navigator.pop(context),
                            okay: true,
                            okayText: 'Okay',
                            okayFunction: () => _sendCode(),
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
  final AuthDataProvider log;
  const VerifyPhone({this.log});

  @override
  State<VerifyPhone> createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  bool _isLoading = false;
  bool _buttonActive = true;
  final _formKey = GlobalKey<FormState>();
  _verifyCode() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    try {
      setState(() => _isLoading = true);
      AuthApi authApi = AuthApi();
      Map<String, dynamic> data = {
        'phone': widget.log.phone,
        'code': widget.log.otp,
      };
      await authApi.verifyPhoneToken(data).then((res) {
        setState(() => _isLoading = false);
        if (res['status'] != 'success') {
          //print(res);
          return GeneralLogics.showAlert(
              title: true,
              titleText: ReCase(res['status']).sentenceCase,
              body: true,
              bodyText: ReCase(res['message']).sentenceCase,
              cancel: true,
              cancelText: 'Retry',
              cancelFunction: () => Navigator.pop(context),
              context: context);
        }
        widget.log.page = 'gender';
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    super.dispose();
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
              'Verify Phone Number',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Waiting to automatically detect an SMS sent to ${widget.log.phone}.',
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
                  widget.log.otp = value;
                },
                beforeTextPaste: (text) {
                  return true;
                },
              ),
            ),
            SizedBox(height: 0.02.sh),
            GestureDetector(
                onTap: () => widget.log.page = 'phone',
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
                        : () => _verifyCode(),
                text: 'Verify'),
          ],
        ),
      ),
    );
  }
}

class GenderSelector extends StatelessWidget {
  final AuthDataProvider log;
  const GenderSelector({this.log});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.8.sh,
      width: 1.sw,
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'What\'s your gender',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor),
              ),
              SizedBox(
                height: 0.03.sh,
              ),
              SizedBox(
                width: 0.7.sw,
                child: Row(
                  children: [
                    // MALE
                    Expanded(
                      child: Consumer<AuthDataProvider>(
                        builder: (context, state, _) => GestureDetector(
                          onTap: () {
                            state.isMale = true;
                          },
                          child: Container(
                            height: 0.13.sh,
                            width: 0.13.sw,
                            decoration: BoxDecoration(
                              color: state.isMale
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                              border: Border.all(
                                color: state.isMale
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  PhosphorIcons.gender_male,
                                  size: 40.sp,
                                  color: state.isMale
                                      ? Colors.white
                                      : Theme.of(context).primaryColor,
                                ),
                                Text(
                                  'Male',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: state.isMale
                                        ? Colors.white
                                        : Theme.of(context).primaryColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    // FEMALE
                    Expanded(
                      child: Consumer<AuthDataProvider>(
                        builder: (context, state, _) => GestureDetector(
                          onTap: () {
                            state.isMale = false;
                          },
                          child: Container(
                            height: 0.13.sh,
                            width: 0.13.sw,
                            decoration: BoxDecoration(
                              color: !state.isMale
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                              border: Border.all(
                                color: !state.isMale
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  PhosphorIcons.gender_female,
                                  size: 40.sp,
                                  color: !state.isMale
                                      ? Colors.white
                                      : Theme.of(context).primaryColor,
                                ),
                                Text(
                                  'Female',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: !state.isMale
                                        ? Colors.white
                                        : Theme.of(context).primaryColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const Spacer(),
          PrimaryButton(
              onPressed: () {
                //log.page = 'otp';
                log.page = 'department';
              },
              text: 'Continue'),
        ],
      ),
    );
  }
}

class DepartmentSelector extends StatefulWidget {
  AuthDataProvider log;
  DepartmentSelector({@required this.log});

  @override
  State<DepartmentSelector> createState() => _DepartmentSelectorState();
}

class _DepartmentSelectorState extends State<DepartmentSelector> {
  final _formKey = GlobalKey<FormState>();
  final bool _isLoading = false;
  bool gotDepartment = false;
  Map department;
  List departments = [];

  bool gotLevels = false;
  Map level;
  List levels = [];

  Future<List> _getDepartments() async {
    AuthApi authApi = AuthApi();
    var res = await authApi.getDepartment().then((res) {
      return res == null ? [] : res['data'];
    });
    return res;
  }

  Future<List> _getLevels(int id) async {
    AuthApi authApi = AuthApi();
    var res = await authApi.getDepartmentLevels(id).then((res) {
      return res == null ? [] : res['data'];
    });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    if (gotDepartment == false) {
      _getDepartments().then((value) {
        setState(() {
          departments = value;
          departments.sort((a, b) => a["name"].compareTo(b["name"]));
          gotDepartment = true;
        });
      });
    }
    return SizedBox(
      height: 0.8.sh,
      width: 1.sw,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text(
              'Tell us your department & level',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 0.01.sh,
            ),
            const Text(
              'This would help us find match your friends.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 0.04.sh),
            Column(children: [
              DropdownSearch<String>(
                enabled: !_isLoading,
                validator: FormValidationLogics.isEmpty,
                dropdownSearchDecoration: InputDecoration(
                    errorStyle: const TextStyle(fontSize: 8),
                    hintStyle: const TextStyle(color: Colors.grey),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    hintText:
                        gotDepartment == false ? 'Loading Departments...' : '',
                    labelText: 'Department'),
                items: departments.map((value) {
                  return '${value['name']}';
                }).toList(),
                mode: Mode.BOTTOM_SHEET,
                showSearchBox: true,
                maxHeight: 0.5.sh,
                searchFieldProps: const TextFieldProps(
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.search),
                        labelText: 'Search Departments')),
                onChanged: (r) {
                  for (var element in departments) {
                    if (element['name'] == r) {
                      _getLevels(element['id']).then((value) {
                        setState(() {
                          levels = value;
                          levels.sort((a, b) => a["name"].compareTo(b["name"]));
                          gotLevels = true;
                        });
                      });
                      widget.log.department = element['id'];
                    }
                  }
                },
                selectedItem: '',
              ),
              SizedBox(
                height: 0.02.sh,
              ),
              DropdownSearch<String>(
                enabled: !_isLoading,
                validator: FormValidationLogics.isEmpty,
                dropdownSearchDecoration: const InputDecoration(
                    errorStyle: TextStyle(fontSize: 8),
                    hintStyle: TextStyle(color: Colors.grey),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: 'Level'),
                items: levels.map((value) {
                  return '${value['name']}';
                }).toList(),
                mode: Mode.BOTTOM_SHEET,
                showSearchBox: true,
                maxHeight: 0.5.sh,
                searchFieldProps: const TextFieldProps(
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.search),
                        labelText: 'Search Level')),
                onChanged: (r) {
                  for (var element in levels) {
                    if (element['name'] == r) {
                      widget.log.level = element['id'];
                      // setState(() {
                      //   level = element;
                      // });
                    }
                  }
                },
                selectedItem: '',
              ),
            ]),
            const Spacer(),
            PrimaryButton(
                onPressed: () {
                  if (!_formKey.currentState.validate()) {
                    return;
                  }
                  widget.log.page = 'profile';
                },
                text: 'Next'),
          ],
        ),
      ),
    );
  }
}

class DisplayName extends StatefulWidget {
  AuthDataProvider log;
  DisplayName({@required this.log});

  @override
  State<DisplayName> createState() => _DisplayNameState();
}

class _DisplayNameState extends State<DisplayName> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  _registerUser() async {
    try {
      setState(() => _isLoading = true);
      AuthApi authApi = AuthApi();
      Map<String, dynamic> data = {
        'nickname': widget.log.nickname,
        'phone': widget.log.phone,
        'level': widget.log.level,
        'department': widget.log.department,
        'gender': widget.log.isMale ? 'male' : 'female',
      };
      print(data);
      await authApi.register(data).then((res) {
        setState(() => _isLoading = false);
        if (res['status'] != 'success') {
          return GeneralLogics.showAlert(
              title: true,
              titleText: ReCase(res['status']).sentenceCase,
              body: true,
              bodyText: ReCase(res['message']).sentenceCase,
              cancel: true,
              cancelText: 'Retry',
              cancelFunction: () => Navigator.pop(context),
              context: context);
        }
        // print(res);
        // GeneralLogics.saveToken(res['token']);
        // GeneralLogics.setUserDataProvider(userDataProvider, res['data']);
        Navigator.pushReplacementNamed(context, '/home');
        return null;
      });
    } catch (e) {
      print(e);
      setState(() => _isLoading = false);
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
          children: [
            const Text(
              'Profile Info',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 0.01.sh,
            ),
            const Text(
              'Please provide your info and optional profile photo',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 0.05.sh),
            SizedBox(
              height: 150,
              width: 150,
              child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    const CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://cutewallpaper.org/24/image-placeholder-png/image-placeholder-png-user-profile-placeholder-image-png-transparent-png--1200x12006104451-pngfind.png'),
                    ),
                    Positioned(
                        right: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                              color: Colors.black.withOpacity(.1),
                              height: 150,
                              width: 150,
                              child: IconButton(
                                enableFeedback: true,
                                color: Colors.grey,
                                onPressed: () {
                                  //pickImage('camera');
                                },
                                icon: const Icon(Icons.camera_alt),
                              )),
                        ))
                  ]),
            ),
            SizedBox(height: 0.04.sh),
            SizedBox(
              width: 0.8.sw,
              child: TextFormField(
                enabled: !_isLoading,
                keyboardType: TextInputType.name,
                validator: FormValidationLogics.isEmpty,
                decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 10, color: Theme.of(context).primaryColor),
                    ),
                    labelText: 'Nickname',
                    errorStyle: const TextStyle(fontSize: 8),
                    hintStyle: const TextStyle(color: Colors.grey)),
                onChanged: (name) => widget.log.nickname = name,
              ),
            ),
            const Spacer(),
            PrimaryButton(
                onPressed: () {
                  if (!_formKey.currentState.validate()) {
                    return;
                  }
                  _registerUser();
                },
                text: 'Finish'),
          ],
        ),
      ),
    );
  }
}
