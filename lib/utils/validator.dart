class Validator {
  Validator._();

  static String? isValidDescription(String? value) {
    final description = value ?? '';
    if (description.length < 10) {
      return 'Description must be at last 10 characters!';
    }
    return null;
  }

  static String? isValidImageUrl(String? value) {
    final imageUrl = value ?? '';
    RegExp exp =
        RegExp(r'^http[s]{0,1}://[\w]+[\w\d\-_\.\/]*\.(png|jpg|jpeg)$');
    if (imageUrl.trim().isEmpty || !exp.hasMatch(imageUrl.toLowerCase())) {
      return 'ImageUrl must be a valid url!';
    }
    return null;
  }

  static String? isValidPrice(String? value) {
    final price = double.tryParse(value ?? '-1');
    if (price == null || price <= 0) {
      return 'Enter a valid price!';
    }
    return null;
  }

  static String? isValidName(String? value) {
    final name = value ?? '';
    if (name.trim().length < 2) {
      return 'Name must be more than 2 characters!';
    }
    return null;
  }
}
