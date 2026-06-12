import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../copoment/custom_buttom_widget.dart';
import '../copoment/custom_header_widget.dart';
import '../copoment/custom_textfield.dart';
import '../db/user_database_helper.dart';
import '../model/user.dart';
import '../service/smtp_service.dart';
import '../utils/form_validators.dart';

class RegistorScreen extends StatelessWidget {
  const RegistorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Thanh phan: Header man hinh dang ky
            const CustomHeaderWidget(
              imagePath: 'asset/img.png',
              logoPath: 'asset/img.png',
              title: 'Đăng Ký',
              subtitle: 'Gia nhập cộng đồng UTC2 hôm nay',
            ),
            const SizedBox(height: 5),
            // Thanh phan: Form dang ky tai khoan
            const RegistorForm(),
            const SizedBox(height: 30),
            // Thanh phan: Duong ke phan cach Hoac
            const DividerWithText(text: 'Hoặc'),
            const SizedBox(height: 20),
            // Nut: Quay lai man hinh dang nhap
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const FaIcon(
                FontAwesomeIcons.rightToBracket,
                color: Colors.indigo,
                size: 18,
              ),
              label: const Text(
                'Đã có tài khoản? Đăng nhập',
                style: TextStyle(color: Colors.indigo),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.indigo, width: 2),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 30,
                ),
              ),
            ),
          ],
        ),
      ),
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

class RegistorForm extends StatefulWidget {
  const RegistorForm({super.key});

  @override
  State<RegistorForm> createState() => _RegistorFormState();
}

class _RegistorFormState extends State<RegistorForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _selectedGender;
  final List<String> _genders = ['Nam', 'Nữ', 'Khác'];
  final _formKey = GlobalKey<FormState>();

  int _strength = 0;
  bool isAgree = false;

  void _checkPasswordStrength(String password) {
    int strength = 0;
    if (password.length >= 6) strength += 1;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 1;
    if (password.contains(RegExp(r'[a-z]'))) strength += 1;
    if (password.contains(RegExp(r'[0-9]'))) strength += 1;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 1;
    setState(() {
      _strength = strength;
    });
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng kiểm tra lại dữ liệu')),
      );
      return;
    }

    if (!isAgree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng đồng ý điều khoản sử dụng')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final email = _emailController.text.trim();
      final existingUser = await UserDatabaseHelper().getUserByEmail(email);

      if (existingUser != null) {
        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Email đã được đăng ký')));
        return;
      }

      User newUser = User(
        full_name: _nameController.text.trim(),
        email: email,
        student_id: _studentIdController.text.trim(),
        gender: _selectedGender!,
        password: _passwordController.text,
      );

      await UserDatabaseHelper().insertUser(newUser);

      final isSent = await SmtpService().sendWelcomeEmail(
        email,
        newUser.full_name,
      );

      if (!mounted) return;
      Navigator.pop(context);

      if (isSent) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng ký thành công, đã gửi email chào mừng'),
          ),
        );
      } else {
        final err = SmtpService.lastError ?? 'Lỗi không xác định';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng ký thành công nhưng gửi email lỗi: $err'),
          ),
        );
      }
      Navigator.pop(context); // Go back to login
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 20),
          CustomInputField(
            controller: _nameController,
            hintText: 'Họ và tên',
            prefixIcon: FontAwesomeIcons.user,
            validator: (value) {
              if (value == null || value.trim().isEmpty)
                return 'Vui lòng nhập họ và tên';
              return null;
            },
          ),
          const SizedBox(height: 15),
          CustomInputField(
            controller: _emailController,
            hintText: 'Email',
            prefixIcon: FontAwesomeIcons.envelope,
            validator: FormValidators.email,
          ),
          const SizedBox(height: 15),
          CustomInputField(
            controller: _studentIdController,
            hintText: 'Mã sinh viên',
            prefixIcon: FontAwesomeIcons.idCard,
            validator: (value) {
              if (value == null || value.trim().isEmpty)
                return 'Vui lòng nhập mã sinh viên';
              return null;
            },
          ),
          const SizedBox(height: 15),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              hintText: 'Giới tính',
              prefixIcon: const FaIcon(FontAwesomeIcons.venusMars, size: 20),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 20.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Colors.blue),
              ),
            ),
            value: _selectedGender,
            items:
                _genders.map((gender) {
                  return DropdownMenuItem(value: gender, child: Text(gender));
                }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedGender = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Vui lòng chọn giới tính';
              return null;
            },
          ),
          const SizedBox(height: 15),
          CustomInputField(
            controller: _passwordController,
            hintText: 'Mật khẩu',
            prefixIcon: FontAwesomeIcons.lock,
            validator: FormValidators.password,
            onChanged: _checkPasswordStrength,
            obscureText: true,
          ),
          const SizedBox(height: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Password Strength'),
              LinearProgressIndicator(
                value: _strength / 5,
                backgroundColor: Colors.grey.shade300,
                color:
                    _strength == 5
                        ? Colors.green
                        : _strength >= 3
                        ? Colors.orange
                        : Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 15),
          CustomInputField(
            controller: _confirmPasswordController,
            hintText: 'Mật khẩu xác nhận',
            prefixIcon: FontAwesomeIcons.lock,
            validator:
                (value) => FormValidators.confirmPassword(
                  value,
                  _passwordController.text,
                ),
            obscureText: true,
          ),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: isAgree,
                onChanged: (value) {
                  setState(() {
                    isAgree = value ?? false;
                  });
                },
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Wrap(
                    children: [
                      Text("Tôi đồng ý với "),
                      Text(
                        "Điều khoản sử dụng",
                        style: TextStyle(color: Colors.deepPurpleAccent),
                      ),
                      Text(" và "),
                      Text(
                        "Chính sách bảo mật",
                        style: TextStyle(color: Colors.deepPurpleAccent),
                      ),
                      Text(" của UTC2"),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: CustomElevatedButton(
              onPressed: _submitForm,
              label: 'Đăng ký',
              icon: FontAwesomeIcons.userPlus,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
