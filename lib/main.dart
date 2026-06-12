import 'package:final_exam_flutter/views/forgot_password.dart';
import 'package:final_exam_flutter/views/registor_account.dart';
import 'package:flutter/material.dart';

import 'copoment/custom_buttom_widget.dart';
import 'copoment/custom_header_widget.dart';
import 'copoment/custom_textfield.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'db/user_database_helper.dart';
import 'views/webview_screen.dart';
import 'utils/form_validators.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      routes: {
        '/forgot': (context) => const ForgotPassword(),
        '/registor': (context) => const RegistorScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Thanh phan: Header man hinh dang nhap
                CustomHeaderWidget(
                  imagePath: 'asset/img.png',
                  logoPath: 'asset/img.png',
                  title: 'Đăng Nhập',
                  subtitle: 'Đăng nhập vào tài khoản của bạn',
                ),
                SizedBox(height: 36),
                // Thanh phan: Form dang nhap
                LoginFormWidget(),
                SizedBox(height: 20),
                // Thanh phan: Cac nut quen mat khau va dang ky
                ActionButtonsWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng kiểm tra lại dữ liệu')),
      );
      return;
    }

    final user = await UserDatabaseHelper().login(
      _emailController.text.trim(),
      _passwordController.text,
    );
    if (!mounted) return;

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đăng nhập thành công, xin chào ${user.full_name}'),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WebViewScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Sai email hoặc mật khẩu')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Thanh phan: Email dang nhap
          SizedBox(
            width: 340,
            child: CustomInputField(
              controller: _emailController,
              hintText: 'Email',
              prefixIcon: FontAwesomeIcons.envelope,
              endIcon: null,
              validator: FormValidators.email,
            ),
          ),
          const SizedBox(height: 16),
          // Thanh phan: Password dang nhap
          SizedBox(
            width: 340,
            child: CustomInputField(
              controller: _passwordController,
              hintText: 'Mật khẩu',
              prefixIcon: FontAwesomeIcons.lock,
              obscureText: true,
              validator: FormValidators.password,
            ),
          ),
          const SizedBox(height: 24),
          // Nut: Dang nhap
          SizedBox(
            width: 340,
            child: CustomElevatedButton(
              onPressed: _submitForm,
              label: 'Đăng Nhập',
              icon: FontAwesomeIcons.rightToBracket,
              color: const Color(0xFFFF9228),
            ),
          ),
        ],
      ),
    );
  }
}

class ActionButtonsWidget extends StatelessWidget {
  const ActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Nut: Quen mat khau
        SizedBox(
          width: 170,
          child: TextButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/forgot');
            },
            icon: const FaIcon(
              FontAwesomeIcons.circleQuestion,
              color: Colors.deepPurpleAccent,
              size: 18,
            ),
            label: const Text(
              'Quên mật khẩu?',
              style: TextStyle(color: Colors.indigo),
            ),
          ),
        ),
        // Thanh phan: Duong ke phan cach Hoac
        const DividerWithText(text: 'Hoặc'),
        const SizedBox(height: 20),
        // Nut: Chuyen sang man hinh dang ky
        SizedBox(
          width: 270,
          child: TextButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/registor');
            },
            icon: const FaIcon(
              FontAwesomeIcons.userPlus,
              size: 18,
            ),
            label: const Text(
              'Chưa có tài khoản? Đăng ký',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
