// implements is use to call a abstract class which is exception
// abstract is use to overwrite a method
class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  // to provide useful infomation while debugging
  @override
  String toString() {
    return message;
    // return super.toString(); // Instance of HttpException
  }
}
