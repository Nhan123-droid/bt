import 'dart:developer' as developer;

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class SmtpService {
  // Thay đổi thông tin email và app password của bạn ở đây
  static const String _username = '';
  static const String _password = '';
  static String? lastError;

  Future<bool> sendWelcomeEmail(String recipientEmail, String fullName) async {
    lastError = null;
    final username = _username.trim();
    final password = _password.replaceAll(' ', '');

    if (username.isEmpty ||
        password.isEmpty ||
        username == 'your_email@gmail.com') {
      lastError = 'Chưa cấu hình tài khoản SMTP';
      return false;
    }

    final smtpServer = gmail(username, password);

    final message =
        Message()
          ..from = Address(username, 'UTC2 App')
          ..recipients.add(recipientEmail)
          ..subject = 'Chào mừng đến với UTC2'
          ..text = 'Chào mừng $fullName đã đăng ký tài khoản tại UTC2!';

    try {
      final sendReport = await send(message, smtpServer);
      developer.log('Message sent: $sendReport');
      return true;
    } catch (e, stackTrace) {
      lastError = e.toString();
      developer.log('Message not sent. Error: $e', stackTrace: stackTrace);
      return false;
    }
  }

  Future<bool> sendPasswordRecoveryEmail(
    String recipientEmail,
    String userPassword,
  ) async {
    lastError = null;
    final username = _username.trim();
    final password = _password.replaceAll(' ', '');

    if (username.isEmpty ||
        password.isEmpty ||
        username == 'your_email@gmail.com') {
      lastError = 'Chưa cấu hình tài khoản SMTP';
      return false;
    }

    final smtpServer = gmail(username, password);

    final message =
        Message()
          ..from = Address(username, 'UTC2 App')
          ..recipients.add(recipientEmail)
          ..subject = 'Khôi phục mật khẩu'
          ..text =
              'Thông tin tài khoản của bạn: Email: $recipientEmail, Mật khẩu: $userPassword';

    try {
      final sendReport = await send(message, smtpServer);
      developer.log('Message sent: $sendReport');
      return true;
    } catch (e, stackTrace) {
      lastError = e.toString();
      developer.log('Message not sent. Error: $e', stackTrace: stackTrace);
      return false;
    }
  }
}
