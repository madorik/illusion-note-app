import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/mock_auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(),
              
              // 로고 및 제목
              Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6B73FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.psychology_outlined,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  const Text(
                    '착각노트',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                      fontFamily: 'NotoSansKR',
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  const Text(
                    '감정을 기록하고 분석해보세요',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF718096),
                      fontFamily: 'NotoSansKR',
                    ),
                  ),
                ],
              ),
              
              const Spacer(),
              
              // 로그인 버튼들
              Column(
                children: [
                  // Google 로그인 버튼
                  Consumer<MockAuthProvider>(
                    builder: (context, authProvider, child) {
                      return SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: authProvider.isLoading
                              ? null
                              : () => _signInWithGoogle(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF2D3748),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(
                                color: Color(0xFFE2E8F0),
                                width: 1,
                              ),
                            ),
                          ),
                          child: authProvider.isLoading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF6B73FF),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icons/google_icon.png',
                                      width: 24,
                                      height: 24,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.login,
                                          size: 24,
                                          color: Color(0xFF6B73FF),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Google로 계속하기',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'NotoSansKR',
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 또는 구분선
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '또는',
                          style: TextStyle(
                            color: Color(0xFF718096),
                            fontFamily: 'NotoSansKR',
                          ),
                        ),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 이메일 로그인 버튼
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => _showEmailLoginDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B73FF),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '이메일로 로그인',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'NotoSansKR',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // 에러 메시지
              Consumer<MockAuthProvider>(
                builder: (context, authProvider, child) {
                  if (authProvider.errorMessage != null) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Text(
                        authProvider.errorMessage!,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 14,
                          fontFamily: 'NotoSansKR',
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

    Future<void> _signInWithGoogle(BuildContext context) async {    final authProvider = Provider.of<MockAuthProvider>(context, listen: false);    authProvider.clearError();        final success = await authProvider.signInWithGoogle();        if (success && context.mounted) {      context.go('/home');    }  }

  void _showEmailLoginDialog(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    bool isSignUp = false;
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            isSignUp ? '회원가입' : '이메일 로그인',
            style: const TextStyle(fontFamily: 'NotoSansKR'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSignUp) ...[
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: '이름',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: '이메일',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  isSignUp = !isSignUp;
                });
              },
              child: Text(
                isSignUp ? '로그인으로 전환' : '회원가입으로 전환',
                style: const TextStyle(fontFamily: 'NotoSansKR'),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                '취소',
                style: TextStyle(fontFamily: 'NotoSansKR'),
              ),
            ),
            Consumer<MockAuthProvider>(
              builder: (context, authProvider, child) => ElevatedButton(
                onPressed: authProvider.isLoading
                    ? null
                    : () => _handleEmailAuth(
                          context,
                          emailController.text,
                          passwordController.text,
                          nameController.text,
                          isSignUp,
                        ),
                child: authProvider.isLoading
                    ? const CircularProgressIndicator()
                    : Text(
                        isSignUp ? '회원가입' : '로그인',
                        style: const TextStyle(fontFamily: 'NotoSansKR'),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleEmailAuth(
    BuildContext context,
    String email,
    String password,
    String name,
    bool isSignUp,
  ) async {
    final authProvider = Provider.of<MockAuthProvider>(context, listen: false);
    authProvider.clearError();

    bool success;
    if (isSignUp) {
      success = await authProvider.createUserWithEmailAndPassword(
        email,
        password,
        name,
      );
    } else {
      success = await authProvider.signInWithEmailAndPassword(email, password);
    }

    if (success && context.mounted) {
      Navigator.of(context).pop();
      context.go('/home');
    }
  }
} 