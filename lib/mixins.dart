mixin ValidationMixin {
validateEmail(String value) {
    if (!value.contains('@')) {
      return 'please enter a valid email';
    }
  
  }

  validatePassword( value) {
    if (value < 5) {
      return 'Please enter a valid email';
    }
  }
}
