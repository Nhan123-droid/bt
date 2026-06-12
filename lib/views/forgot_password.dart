import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../copoment/custom_header_widget.dart';
import '../copoment/custom_textfield.dart';
import '../db/user_database_helper.dart';
import '../service/smtp_service.dart';
import '../utils/form_validators.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Thanh phan: Header man hinh quen mat khau
                CustomHeaderWidget(
                  imagePath: 'asset/img.png',
                  logoPath: 'asset/img.png',
                  title: 'Quên Mật Khẩu',
                  subtitle: 'Đừng lo lắng, chúng tôi sẽ giúp bạn',
                ),
                SizedBox(height: 30),
                // Thanh phan: Huong dan quen mat khau
                Introduce(),
                SizedBox(height: 30),
                // Thanh phan: Form nhap email quen mat khau
                ForgotPasswordForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Introduce extends StatelessWidget {
  const Introduce({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 340,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white70,
            border: Border(left: BorderSide(color: Colors.indigo, width: 4)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                // Thanh phan: Tieu de huong dan
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.circleInfo,
                      color: Colors.indigo,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Hướng dẫn',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Thanh phan: Noi dung huong dan
                Text('Nhập email đã đăng ký để nhận lại mật khẩu'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final user = await UserDatabaseHelper().getUserByEmail(email);
    if (!mounted) return;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              FaIcon(FontAwesomeIcons.circleExclamation, color: Colors.white),
              SizedBox(width: 8),
              Expanded(child: Text('Email chưa được đăng ký')),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final isSent = await SmtpService().sendPasswordRecoveryEmail(
      email,
      user.password,
    );
    if (!mounted) return;

    Navigator.pop(context);

    if (isSent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              FaIcon(FontAwesomeIcons.circleCheck, color: Colors.white),
              SizedBox(width: 8),
              Expanded(child: Text('Đã gửi email khôi phục thành công!')),
            ],
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      final error = SmtpService.lastError;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.circleExclamation,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  error == null
                      ? 'Lỗi khi gửi email, vui lòng thử lại sau.'
                      : 'Lỗi gửi email: $error',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Thanh phan: Email nhan ma reset
          SizedBox(
            width: 340,
            child: CustomInputField(
              controller: _emailController,
              hintText: 'Địa chỉ email',
              prefixIcon: FontAwesomeIcons.envelope,
              validator: FormValidators.email,
            ),
          ),
          const SizedBox(height: 20),
          // Nut: Gui mat khau
          SizedBox(
            width: 340,
            child: ElevatedButton.icon(
              onPressed: _submitForm,
              icon: const FaIcon(
                FontAwesomeIcons.paperPlane,
                color: Colors.white,
                size: 18,
              ),
              label: const Text(
                'Gửi Mật Khẩu',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 30,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Nut: Quay lai dang nhap
          SizedBox(
            width: 250,
            child: TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const FaIcon(FontAwesomeIcons.arrowLeft, size: 18),
              label: const Text('Quay lại Đăng nhập'),
            ),
          ),
          const SizedBox(height: 10),
          // Thanh phan: Lien he ho tro
          const Wrap(
            alignment: WrapAlignment.center,
            children: [
              Text('Vẫn gặp vấn đề? '),
              Text(
                'Liên hệ hỗ trợ',
                style: TextStyle(color: Colors.deepPurpleAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
