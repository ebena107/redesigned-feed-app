class ValidationModel {
  String? value;
  String? error;
  bool? isValid;

  ValidationModel({this.value, this.error, this.isValid = false});
}

extension ExtString on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

  bool get isValidName {
    final nameRegExp = RegExp(r"^[a-zA-Z0-9]+$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidInt {
    final nameRegExp = RegExp(r"^(?:-?(?:0|[1-9][0-9]*))$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidDouble {
    final nameRegExp =
        RegExp(r"^(?:-?(?:[0-9]+))?(?:\.[0-9]*)?(?:[eE][\+\-]?(?:[0-9]+))?$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidNumber {
    final intRegExp = RegExp(r"^(?:-?(?:0|[1-9][0-9]*))$");
    final doubleRegExp =
        RegExp(r"^(?:-?(?:[0-9]+))?(?:\.[0-9]*)?(?:[eE][\+\-]?(?:[0-9]+))?$");
    return intRegExp.hasMatch(this) || doubleRegExp.hasMatch(this);
  }

  bool get isValidPassword {
    final passwordRegExp =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    return passwordRegExp.hasMatch(this);
  }

  bool get isNotNull {
    return this != null;
  }

  bool get isValidPhone {
    final phoneRegExp = RegExp(r"^\+?0[0-9]{10}$");
    return phoneRegExp.hasMatch(this);
  }
}
