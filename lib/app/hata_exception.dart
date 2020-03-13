class Hatalar {
  static String goster(String hataKodu) {
    switch (hataKodu) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return "Bu e-posta adresi zaten kullanımda, lütfen farklı bir e-posta kullanınız.";

      case 'ERROR_USER_NOT_FOUND':
        return "Bu kullanıcı sistemde bulunmamaktadır. Lütfen önce kayıt oluşturunuz.";

      case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
        return "Facebook hesabınızdaki e-posta adresi daha önce gmail veya e-posta yöntemi ile sisteme kaydedilmiştir. Lütfen bu e-posta adresi ile giriş yapın";

      case 'ERROR_WRONG_PASSWORD':
        return "Yanlış şifre girdiniz! Lütfen tekrar deneyin!";

      case 'ERROR_ACCOUNT_EXIST_WITH_DIFFERENT_CREDENTIAL':
        return "Facebook E-posta hesabınız daha önceden Gmail veya E-posta yoluyla kayolmuştur, farklı bir E-posta adresiyle giriş yapınız!";

      default:
        return "Bir hata olustu";
    }
  }
}
