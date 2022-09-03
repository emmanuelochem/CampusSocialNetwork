import 'dart:async';

class FormValidationLogics {
  static String isEmpty(value) {
    if (value.isEmpty) {
      return 'This information is required';
    }

    return null;
  }

  static String isPin(String value) {
    if (value.length < 4 || value.length > 4) {
      return 'Pin must be four (4) digits';
    }

    return null;
  }

  static String isOTP(String value) {
    if (value.length < 6) {
      return 'OTP must be six (4) digits';
    }

    return null;
  }

  String checkAmount(value, ladder) {
    if (value.isEmpty) {
      return '';
    }

    if (int.parse(value) < 1000) {
      return 'The minimum amount is 1000';
    }

    if (int.parse(value) > 1000000) {
      return 'The maximum amount is 1000000';
    }

    return null;
  }

  static String isEmail(String value) {
    if (value.isEmpty) {
      return 'Email is required';
    }

    if (!RegExp(
            "^[a-zA-Z0-9.!#%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*")
        .hasMatch(value)) {
      return 'Enter a valid email address';
    }

    // validator has to return something :)
    return null;
  }

  static FutureOr<String> isPhone(String value) {
    Pattern pattern = r'(^(?:[+]234)[0-9]{10}$)';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Format phone number as +234**********';
    } else {
      return null;
    }
  }

  static String checkName(String name) {
    name = name.trim();

    Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(name)) {
      return 'Please enter a valid name';
    } else {
      return null;
    }
  }

  static String isPassword(String value) {
    // Pattern pattern =
    //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#_\$&*~]).{8,}$';
    // Pattern pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    // RegExp regex = new RegExp(pattern);

    // if (!regex.hasMatch(value))
    //   return 'Minimum of 8 alphanumeric character';
    // else
    //   return null;
    if (value.length < 6) {
      return 'Minimum of 8 characters required.';
    }
  }
}
