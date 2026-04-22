import 'package:flutter_test/flutter_test.dart';
import 'package:mio/core/network/api_exception.dart';

void main() {
  group('AppException', () {
    test('toString returns correct format', () {
      const exception = NetworkException(message: 'Test error', code: 500);
      expect(exception.toString(), contains('NetworkException'));
      expect(exception.toString(), contains('Test error'));
    });
  });

  group('NetworkException', () {
    test('creates with default message', () {
      const exception = NetworkException();
      expect(exception.message, equals('Network error occurred'));
    });

    test('creates with custom message', () {
      const exception = NetworkException(message: 'No internet');
      expect(exception.message, equals('No internet'));
    });
  });

  group('ServerException', () {
    test('creates with statusCode', () {
      const exception = ServerException(
        message: 'Server error',
        statusCode: 500,
      );
      expect(exception.statusCode, equals(500));
    });
  });

  group('UnauthorizedException', () {
    test('has default 401 code', () {
      const exception = UnauthorizedException();
      expect(exception.code, equals(401));
    });
  });

  group('NotFoundException', () {
    test('has default 404 code', () {
      const exception = NotFoundException();
      expect(exception.code, equals(404));
    });
  });
}
