/// Predefined font family options for the auth UI package
enum AuthFontFamily {
  /// Inter font family (modern, clean)
  inter('Inter'),
  
  /// Ubuntu font family (friendly, rounded)
  ubuntu('Ubuntu'),
  
  /// Helvetica Neue font family (classic, professional)
  helveticaNeue('Helvetica Neue'),
  
  /// Roboto font family (Android default, versatile)
  roboto('Roboto'),
  
  /// Open Sans font family (neutral, readable)
  openSans('Open Sans'),
  
  /// Lato font family (elegant, warm)
  lato('Lato'),
  
  /// Montserrat font family (geometric, modern)
  montserrat('Montserrat'),
  
  /// Poppins font family (geometric, friendly)
  poppins('Poppins'),
  
  /// Nunito font family (rounded, friendly)
  nunito('Nunito'),
  
  /// Custom font family (allows passing any font name)
  custom('');

  const AuthFontFamily(this.fontName);

  final String fontName;

  /// Get the font family name
  String get fontFamily => fontName;

  /// Create from custom font name
  static AuthFontFamily fromName(String fontName) {
    for (var family in AuthFontFamily.values) {
      if (family.fontName == fontName) {
        return family;
      }
    }
    return AuthFontFamily.custom;
  }

  @override
  String toString() => fontName;
}
