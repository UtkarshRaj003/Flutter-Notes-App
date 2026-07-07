class Validators {

  static String? validateEmail(
      String? value) {

    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    if (!value.contains('@')) {
      return 'Invalid email';
    }

    return null;
  }

  static String? validatePassword(
      String? value) {

    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Minimum 6 characters';
    }

    return null;
  }

  static String? validateName(
      String? value) {

    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    return null;
  }
}