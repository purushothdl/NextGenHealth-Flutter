import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_form_field.dart';
import '../widgets/role_selector.dart';
import '../widgets/status_button.dart';
import 'login_screen.dart';
import 'status_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'patient';

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              // Wrap the Column in a SingleChildScrollView
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Header
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF3BAEE9), Color(0xFF6AC8F5)],
                    ).createShader(bounds),
                    child: const Icon(
                      Icons.medical_services_rounded,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.blueGrey[800],
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 32),
      
                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AuthFormField(
                          controller: _usernameController,
                          label: 'Username',
                          prefixIcon: Icons.person_outline_rounded,
                          validator: (value) =>
                              value!.isEmpty ? 'Required field' : null,
                        ),
                        const SizedBox(height: 16),
                        AuthFormField(
                          controller: _emailController,
                          label: 'Email',
                          prefixIcon: Icons.email_outlined,
                          validator: (value) =>
                              value!.isEmpty ? 'Required field' : null,
                        ),
                        const SizedBox(height: 16),
                        AuthFormField(
                          controller: _passwordController,
                          label: 'Password',
                          prefixIcon: Icons.lock_outline_rounded,
                          obscureText: true,
                          validator: (value) =>
                              value!.isEmpty ? 'Required field' : null,
                        ),
                        const SizedBox(height: 16),
                        RoleSelector(
                          value: _selectedRole,
                          onChanged: (value) =>
                              setState(() => _selectedRole = value!),
                        ),
                        const SizedBox(height: 32),
      
                        // Buttons Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: AuthButton(
                                onPressed: authProvider.isLoading
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          _handleRegistration(context, authProvider);
                                        }
                                      },
                                text: 'Create Account',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: VerificationStatusButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const StatusScreen(),
                                  ),
                                ),
                                text: 'Check Status',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
      
                        // Sign In Prompt
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(color: Colors.blueGrey[600]),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              ),
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Color(0xFF3BAEE9),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
      
                        // Loading Indicator
                        if (authProvider.isLoading)
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegistration(
      BuildContext context, AuthProvider authProvider) async {
    try {
      final user = UserRegistration(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        role: _selectedRole,
        fcmToken: '',
      );

      final success = await authProvider.register(user);

      if (success) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error ?? 'Registration failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}