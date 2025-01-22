import 'package:flutter/material.dart';

class AuthFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final IconData prefixIcon;
  final String? Function(String?)? validator;
  final bool showClearIcon;

  const AuthFormField({
    Key? key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    required this.prefixIcon,
    this.validator,
    this.showClearIcon = true,
  }) : super(key: key);

  @override
  _AuthFormFieldState createState() => _AuthFormFieldState();
}

class _AuthFormFieldState extends State<AuthFormField> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() => _isFocused = hasFocus);
        if (hasFocus) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      },
      child: ScaleTransition(
        scale: _animation,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isFocused ? 0.4 : 0.2),
                blurRadius: _isFocused ? 8 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            validator: widget.validator,
            style: TextStyle(
              color: Colors.blueGrey[800],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(
                widget.prefixIcon,
                color: _isFocused ? const Color(0xFF3BAEE9) : Colors.blueGrey[300],
              ),
              suffixIcon: widget.showClearIcon && widget.controller.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.blueGrey[300]),
                      onPressed: () => widget.controller.clear(),
                    )
                  : null,
              label: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  widget.label,
                  style: TextStyle(
                    color: Colors.blueGrey[400],
                    fontSize: 14,
                  ),
                ),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              floatingLabelStyle: const TextStyle(
                color: Color(0xFF3BAEE9),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF3BAEE9),
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}