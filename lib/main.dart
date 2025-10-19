import 'package:flutter/material.dart';
import 'utils/text_styles.dart';
import 'utils/app_theme.dart';

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onAllTap;
  const _SectionHeader({required this.title, required this.onAllTap});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.008),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onAllTap,
            child: Text(
              'الكل',
              style: AppTextStyles.medium(
                fontSize: size.width * 0.04,
                color: const Color(0xFF7C8899),
              ),
            ),
          ),
          Text(
            title,
            style: AppTextStyles.bold(
              fontSize: size.width * 0.055,
              color: const Color(0xFF1A2A4A),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MubeenApp());
}

class MubeenApp extends StatelessWidget {
  const MubeenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mubeen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D47A1)),
        useMaterial3: true,
        fontFamily: 'IBMPlexSansArabic',
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _fadeController;
  late final AnimationController _floatController;
  late final Animation<double> _scale;
  late final Animation<double> _fade;
  late final Animation<double> _rotation;
  late final Animation<double> _float;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this, 
      duration: const Duration(milliseconds: 1200)
    );
    _fadeController = AnimationController(
      vsync: this, 
      duration: const Duration(milliseconds: 1500)
    );
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000)
    );
    
    _scale = CurvedAnimation(
      parent: _logoController, 
      curve: Curves.easeOut
    );
    _fade = CurvedAnimation(
      parent: _fadeController, 
      curve: Curves.easeInOut
    );
    _rotation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOut,
    ));
    _float = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));
    
    // Start animations
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _fadeController.forward();
        _floatController.repeat(reverse: true);
      }
    });
    
    // Navigate to login page after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppGradients.blueBackground,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              FadeTransition(
                opacity: _fade,
                child: AnimatedBuilder(
                  animation: _float,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -_float.value * 2),
                      child: ScaleTransition(
                        scale: _scale,
                        child: RotationTransition(
                          turns: _rotation,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.1,
                              vertical: size.height * 0.02,
                            ),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: size.width * 0.7,
                                maxHeight: size.height * 0.4,
                              ),
                              child: Image.asset(
                                'assets/images/mubeen_logo.png',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => Column(
                                  children: [
                                    const Icon(Icons.image_not_supported, color: Colors.white, size: 80),
                                    const SizedBox(height: 16),
                                    Text(
                                      'جاري تحميل الشعار...',
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.light(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ),
                          ),
                        ),
                      );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.04),
                child: FadeTransition(
                  opacity: _fade,
                  child: const BouncingDots(
                    color: Colors.white,
                    dotSize: 18,
                    spacing: 16,
                  ),
                ),
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}

class BouncingDots extends StatefulWidget {
  const BouncingDots({super.key, this.color = Colors.white, this.dotSize = 8, this.spacing = 6});

  final Color color;
  final double dotSize;
  final double spacing;

  @override
  State<BouncingDots> createState() => _BouncingDotsState();
}

class _BouncingDotsState extends State<BouncingDots>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<AnimationController> _dotControllers;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    
    _dotControllers = List.generate(3, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
    });
    
    _startStaggeredAnimation();
  }

  void _startStaggeredAnimation() {
    for (int i = 0; i < _dotControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _dotControllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    for (var controller in _dotControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.dotSize * 4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _dotControllers[index],
            builder: (context, _) {
              final double scale = 0.5 + (_dotControllers[index].value * 0.5);
              final double opacity = 0.3 + (_dotControllers[index].value * 0.7);
              final double offset = _dotControllers[index].value * 12;
              
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
                child: Transform.translate(
                  offset: Offset(0, -offset),
                  child: Transform.scale(
                    scale: scale,
                    child: Container(
                      width: widget.dotSize,
                      height: widget.dotSize,
                      decoration: BoxDecoration(
                        color: widget.color.withOpacity(opacity),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: widget.color.withOpacity(opacity * 0.9),
                            blurRadius: 15,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      body: Stack(
        children: [
          // Full-screen gradient background so rounded corners blend with it
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppGradients.blueBackground,
            ),
          ),

          // Logo area (approx. top 60% of the screen)
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: size.height * 0.6,
              width: double.infinity,
              child: Center(
                child: Image.asset(
                  'assets/images/mubeen_logo_login.png',
                  width: size.width * 0.55,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.image_not_supported,
                    color: Colors.white,
                    size: 80,
                  ),
                ),
              ),
            ),
          ),

          // Bottom dark section (40% of screen)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * 0.4,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF121619),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(56),
                  topRight: Radius.circular(56),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.08,
                  vertical: size.height * 0.02,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Headline
                    Text(
                      'إنضم إلى العديد\nمن المستخدمين !',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bold(
                        fontSize: size.width * 0.09,
                        color: Colors.white,
                        height: 1.25,
                      ),
                    ),

                    SizedBox(height: size.height * 0.035),

                    // Login button
                    Container(
                      width: double.infinity,
                      height: size.height * 0.055,
                      decoration: BoxDecoration(
                        gradient: AppGradients.blueButton,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Material(
                        color: Colors.transparent,
                    child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const DetailedLoginPage(),
                              ),
                            );
                          },
                          child: Center(
                            child: Text(
                              'تسجيل الدخول',
                              style: AppTextStyles.semiBold(
                                fontSize: size.width * 0.045,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * 0.025),

                    // Separator with "Or" text
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'أو',
                            style: AppTextStyles.regular(
                              fontSize: size.width * 0.035,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: size.height * 0.025),

                    // Create account text
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      );
                    },
                      child: Text(
                        'انشاء حساب',
                        style: AppTextStyles.medium(
                          fontSize: size.width * 0.045,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class DetailedLoginPage extends StatefulWidget {
  const DetailedLoginPage({super.key});

  @override
  State<DetailedLoginPage> createState() => _DetailedLoginPageState();
}

class _DetailedLoginPageState extends State<DetailedLoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    const Color deepNavy = Color(0xFF0B1F3A);
    const Color gradientStart = Color(0xFF0D47A1);

    const String loginLogoUrl = 'https://i.ibb.co/3YsvdWgW/Component-3.png';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Full gradient background (top-heavy)
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: AppGradients.blueBackground,
              ),
            ),

            // Header logo in the gradient area
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: size.height * 0.08),
                  child: SizedBox(
                    width: size.width * 0.27,
                    child: Image.network(
                      loginLogoUrl,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image_not_supported, color: Colors.white, size: 72);
                      },
                    ),
                  ),
                ),
              ),
            ),

            // White sheet with rounded top corners
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: size.height * 0.78,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(80),
                    topRight: Radius.circular(80),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 30,
                      offset: const Offset(0, -6),
                      spreadRadius: 6,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.07,
                      vertical: size.height * 0.04,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            'تسجيل الدخول',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bold(
                              fontSize: size.width * 0.09,
                              color: deepNavy,
                              height: 1.2,
                            ),
                          ),
                        ),

                        SizedBox(height: size.height * 0.04),

                        _buildLabeledField(
                          context: context,
                          label: 'اسم المستخدم',
                          hint: 'yasser30ds@gmail.com',
                          controller: _usernameController,
                          icon: Icons.person_outline,
                          isPassword: false,
                        ),

                        SizedBox(height: size.height * 0.03),

                        _buildLabeledField(
                          context: context,
                          label: 'كلمة المرور',
                          hint: '********',
                          controller: _passwordController,
                          icon: Icons.lock_outline,
                          isPassword: true,
                        ),

                        SizedBox(height: size.height * 0.045),

                        // Login button
                        Container(
                          height: size.height * 0.065,
                          decoration: BoxDecoration(
                            gradient: AppGradients.blueButton,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0D47A1).withOpacity(0.35),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {},
                              child: Center(
                                child: Text(
                                  'تسجيل الدخول',
                                  style: AppTextStyles.semiBold(
                                    fontSize: size.width * 0.05,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: size.height * 0.06),

                        // Bottom sign-up prompt
                        Center(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'ليس لديك حساب؟ ',
                                style: AppTextStyles.semiBold(
                                  fontSize: size.width * 0.045,
                                  color: deepNavy,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const SignUpPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'تسجيل',
                                  style: AppTextStyles.bold(
                                    fontSize: size.width * 0.045,
                                    color: gradientStart,
                                  ),
                                ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildLabeledField({
    required BuildContext context,
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    required bool isPassword,
  }) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: size.height * 0.012),
          child: Text(
            label,
            style: AppTextStyles.semiBold(
              fontSize: size.width * 0.045,
              color: const Color(0xFF1A2A4A),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.regular(
                fontSize: size.width * 0.04,
                color: const Color(0xFF9EABB8),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04,
                vertical: size.height * 0.022,
              ),
              // Icon on the right side for RTL
              suffixIcon: Padding(
                padding: const EdgeInsetsDirectional.only(end: 12),
                child: Icon(icon, color: const Color(0xFF1A2A4A)),
              ),
              suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            ),
          ),
        ),
      ],
    );
  }
}


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Background gradient
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: AppGradients.blueBackground,
              ),
            ),

            // Top app bar area with circular back/next button
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.06,
                  vertical: size.height * 0.02,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 48),
                    Text(
                      'انشاء حساب',
                      style: AppTextStyles.bold(
                        fontSize: size.width * 0.08,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const DetailedLoginPage(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.25),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Progress bar under the title
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.16,
                  left: size.width * 0.08,
                  right: size.width * 0.08,
                ),
                child: Stack(
                  children: [
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.45,
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFB226E1), Color(0xFF3F2B96)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // White card sheet
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: size.height * 0.78,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(80),
                    topRight: Radius.circular(80),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 30,
                      offset: const Offset(0, -6),
                      spreadRadius: 6,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.07,
                      vertical: size.height * 0.04,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildLabeledField(
                          context: context,
                          label: 'الاسم الاول',
                          hint: 'ياسر',
                          controller: _firstNameController,
                          isPassword: false,
                        ),

                        SizedBox(height: size.height * 0.025),

                        _buildLabeledField(
                          context: context,
                          label: 'الاسم الأخير',
                          hint: 'الشريف',
                          controller: _lastNameController,
                          isPassword: false,
                        ),

                        SizedBox(height: size.height * 0.025),

                        _buildLabeledField(
                          context: context,
                          label: 'البريد الالكتروني',
                          hint: 'yasser30ds@gmail.com',
                          controller: _emailController,
                          isPassword: false,
                          keyboardType: TextInputType.emailAddress,
                        ),

                        SizedBox(height: size.height * 0.025),

                        _buildLabeledField(
                          context: context,
                          label: 'كلمة المرور',
                          hint: '********',
                          controller: _passwordController,
                          isPassword: true,
                        ),

                        SizedBox(height: size.height * 0.045),

                        // Next button
                        Container(
                          height: size.height * 0.065,
                          decoration: BoxDecoration(
                            gradient: AppGradients.blueButton,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0D47A1).withOpacity(0.35),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpAgePage(),
                                  ),
                                );
                              },
                              child: Center(
                                child: Text(
                                  'التالي',
                                  style: AppTextStyles.semiBold(
                                    fontSize: size.width * 0.05,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: size.height * 0.06),

                        Center(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'لديك بالفعل حساب ؟ ',
                                style: AppTextStyles.semiBold(
                                  fontSize: size.width * 0.045,
                                  color: const Color(0xFF0B1F3A),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.of(context).pop();
                                  } else {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => const DetailedLoginPage(),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  'دخول',
                                  style: AppTextStyles.bold(
                                    fontSize: size.width * 0.045,
                                    color: const Color(0xFF0D47A1),
                                  ),
                                ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildLabeledField({
    required BuildContext context,
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool isPassword,
    TextInputType? keyboardType,
  }) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: size.height * 0.012),
          child: Text(
            label,
            style: AppTextStyles.semiBold(
              fontSize: size.width * 0.045,
              color: const Color(0xFF1A2A4A),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            keyboardType: keyboardType,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.regular(
                fontSize: size.width * 0.04,
                color: const Color(0xFF9EABB8),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04,
                vertical: size.height * 0.022,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SignUpAgePage extends StatefulWidget {
  const SignUpAgePage({super.key});

  @override
  State<SignUpAgePage> createState() => _SignUpAgePageState();
}

class _SignUpAgePageState extends State<SignUpAgePage> {
  final TextEditingController _ageController = TextEditingController(text: '17');

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Background gradient
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: AppGradients.blueBackground,
              ),
            ),

            // Title and back/next
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.06,
                  vertical: size.height * 0.02,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 48),
                    Text(
                      'انشاء حساب',
                      style: AppTextStyles.bold(
                        fontSize: size.width * 0.08,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.25),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Progress bar
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.16,
                  left: size.width * 0.08,
                  right: size.width * 0.08,
                ),
                child: Stack(
                  children: [
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.7,
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFB226E1), Color(0xFF3F2B96)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // White sheet with question and field
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: size.height * 0.78,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(80),
                    topRight: Radius.circular(80),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 30,
                      offset: const Offset(0, -6),
                      spreadRadius: 6,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.07,
                    vertical: size.height * 0.04,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.02),
                      Text(
                        'كم عمرك ؟',
                        style: AppTextStyles.bold(
                          fontSize: size.width * 0.1,
                          color: const Color(0xFF0B1F3A),
                        ),
                      ),
                      SizedBox(height: size.height * 0.06),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.07),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _ageController,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '17',
                            hintStyle: AppTextStyles.regular(
                              fontSize: size.width * 0.045,
                              color: const Color(0xFF9EABB8),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.04,
                              vertical: size.height * 0.022,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.06),
                      Container(
                        height: size.height * 0.065,
                        decoration: BoxDecoration(
                          gradient: AppGradients.blueButton,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0D47A1).withOpacity(0.35),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const PoliciesAndPrivacyPage(),
                                ),
                              );
                            },
                            child: Center(
                              child: Text(
                                'التالي',
                                style: AppTextStyles.semiBold(
                                  fontSize: size.width * 0.05,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PoliciesAndPrivacyPage extends StatefulWidget {
  const PoliciesAndPrivacyPage({super.key});

  @override
  State<PoliciesAndPrivacyPage> createState() => _PoliciesAndPrivacyPageState();
}

class _PoliciesAndPrivacyPageState extends State<PoliciesAndPrivacyPage> {
  bool _accepted = false;

  List<String> get _points => const [
        'واجهة سهلة الاستخدام: تصميم بسيط ومريح يناسب جميع الأعمار والفئات.',
        'تمارين تفاعلية يومية: أنشطة متنوعة لتحسين النطق وتقوية الثقة بالنفس.',
        'أدوات تحليل الصوت المتقدمة: تقنيات حديثة لتحليل أنماط النطق وتقديم توصيات مخصصة.',
        'تتبع التقدم: تقارير دورية لمراقبة التحسن وتحديد النقاط التي تحتاج إلى تطوير.',
        'مجتمع داعم: يوفر التطبيق منتدى تفاعلي يتيح للمستخدمين مشاركة تجاربهم والتعلم من الآخرين.',
        'كسر حاجز العزلة: يوفر التطبيق بيئة آمنة وداعمة تُشجع على التواصل والتعبير بحرية.',
        'إمكانية الوصول: يمكن استخدام التطبيق في أي وقت وأي مكان، مما يمنح المستخدم مرونة أكبر.',
        'تقييم أولي عشان نعرف تقييم التأتأة، ونحدد له الأهداف العلاجية.',
        'تمارين يومية: تدريبات التنفس، تقنيات إبطاء الكلام، ممارسة العبارات الشائعة.',
        'استراتيجيات نفسية: مثل تمارين استرخاء وتأمل لتعزيز الثقة بالنفس وتقليل القلق.',
        'دعم اجتماعي.',
        'تعديل الخطة: مراجعه الخطة بانتظام وتعديلها بناءً على تقدم المستخدم واحتياجاته المتغيرة.',
        'المتابعة: جلسات متابعة دورية لضمان استمرارية الدعم.',
      ];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: AppGradients.blueBackground,
              ),
            ),

            // Top bar
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.06,
                  vertical: size.height * 0.02,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 48),
                    Text(
                      'انشاء حساب',
                      style: AppTextStyles.bold(
                        fontSize: size.width * 0.08,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.25),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Progress bar
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.16,
                  left: size.width * 0.08,
                  right: size.width * 0.08,
                ),
                child: Stack(
                  children: [
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 1.0,
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFB226E1), Color(0xFF3F2B96)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content card
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: size.height * 0.7,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(80),
                    topRight: Radius.circular(80),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 30,
                      offset: const Offset(0, -6),
                      spreadRadius: 6,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.07,
                    vertical: size.height * 0.035,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'السياسات والخصوصية',
                        style: AppTextStyles.bold(
                          fontSize: size.width * 0.085,
                          color: const Color(0xFF0B1F3A),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 14,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.06,
                                vertical: size.height * 0.025,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ..._points.map(
                                    (p) => Padding(
                                      padding: EdgeInsets.only(bottom: size.height * 0.015),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('•  ', style: AppTextStyles.bold(fontSize: size.width * 0.06, color: const Color(0xFF0B1F3A))),
                                          Expanded(
                                            child: Text(
                                              p,
                                              textAlign: TextAlign.right,
                                              style: AppTextStyles.regular(
                                                fontSize: size.width * 0.045,
                                                color: const Color(0xFF1A2A4A),
                                                height: 1.6,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'قبول',
                            style: AppTextStyles.semiBold(
                              fontSize: size.width * 0.05,
                              color: const Color(0xFF0B1F3A),
                            ),
                          ),
                          SizedBox(width: size.width * 0.03),
                          Checkbox(
                            value: _accepted,
                            onChanged: (v) => setState(() => _accepted = v ?? false),
                            shape: const CircleBorder(),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.005),
                      Opacity(
                        opacity: _accepted ? 1.0 : 0.5,
                        child: Container(
                          height: size.height * 0.065,
                          decoration: BoxDecoration(
                            gradient: AppGradients.blueButton,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0D47A1).withOpacity(0.35),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: _accepted
                                  ? () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) => const HomePage(),
                                        ),
                                      );
                                    }
                                  : () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('الرجاء قبول الشروط للمتابعة')),
                                      );
                                    },
                              child: Center(
                                child: Text(
                                  'تم',
                                  style: AppTextStyles.semiBold(
                                    fontSize: size.width * 0.05,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tabIndex = 0;

  Color get _primaryBlue => const Color(0xFF0D47A1);
  static const String _topProfileUrl = 'https://i.ibb.co/gLmmGG86/Compone-nt-3.png';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                  vertical: size.height * 0.012,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'ايام التمرين',
                              style: AppTextStyles.medium(
                                fontSize: size.width * 0.043,
                                color: const Color(0xFF1A2A4A),
                              ),
                            ),
                            SizedBox(width: size.width * 0.012),
                            Text(
                              '20',
                              style: AppTextStyles.bold(
                                fontSize: size.width * 0.048,
                                color: _primaryBlue,
                              ),
                            ),
                            SizedBox(width: size.width * 0.006),
                            const Icon(Icons.star, color: Color(0xFFFFD54F), size: 16),
                          ],
                        ),
                        Text('~ ~', style: AppTextStyles.bold(fontSize: size.width * 0.06, color: const Color(0xFF1A2A4A))),
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white,
                          backgroundImage: const NetworkImage(_topProfileUrl),
                          onBackgroundImageError: (_, __) {},
                        ),
                      ],
                    ),

                    SizedBox(height: size.height * 0.02),

                    // Chart card
                    Container(
                      height: size.height * 0.24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE6EAF0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          )
                        ],
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.06,
                        vertical: size.height * 0.02,
                      ),
                      child: CustomPaint(
                        painter: _SimpleLineChartPainter(color: _primaryBlue),
                        child: const SizedBox.expand(),
                      ),
                    ),

                    SizedBox(height: size.height * 0.02),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'قـيّم كيف كان يومك',
                        style: AppTextStyles.bold(
                          fontSize: size.width * 0.055,
                          color: const Color(0xFF1A2A4A),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        _MoodIcon(icon: Icons.sentiment_very_dissatisfied_outlined, selected: false),
                        _MoodIcon(icon: Icons.sentiment_dissatisfied, selected: true),
                        _MoodIcon(icon: Icons.sentiment_neutral_outlined, selected: false),
                        _MoodIcon(icon: Icons.sentiment_satisfied_alt_outlined, selected: false),
                      ],
                    ),

                    SizedBox(height: size.height * 0.02),
                    _SectionHeader(title: 'مكتبة الدروس', onAllTap: () {}),
                    SizedBox(height: size.height * 0.012),

                    // Big upcoming lesson card
                    Container(
                      height: size.height * 0.18,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6F8CF9),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.05,
                        vertical: size.height * 0.02,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'دروسي القادمة',
                                  style: AppTextStyles.bold(
                                    fontSize: size.width * 0.065,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: size.height * 0.004),
                                Text(
                                  'التدريـب على مقال عن السمعيات',
                                  style: AppTextStyles.regular(
                                    fontSize: size.width * 0.038,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: size.width * 0.04),
                          Container(
                            width: size.width * 0.26,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              image: const DecorationImage(
                                image: AssetImage('assets/images/mubeen_logo.png'),
                                fit: BoxFit.cover,
                                opacity: 0.2,
                              ),
                            ),
                            child: const Icon(Icons.person, size: 48, color: Colors.white),
                          )
                        ],
                      ),
                    ),

                    SizedBox(height: size.height * 0.015),

                    // Horizontal lessons cards
                    SizedBox(
                      height: size.height * 0.17,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        itemBuilder: (context, i) => _LessonSmallCard(
                          title: i == 0
                              ? 'تمرين القراءة'
                              : i == 1
                                  ? 'تمرين نطق الحروف'
                                  : 'تمرين مخارج الحروف',
                          subtitle: 'مخصص للتدريب على مخارج الأحرف',
                          onStart: () {},
                        ),
                        separatorBuilder: (context, i) => SizedBox(width: size.width * 0.035),
                        itemCount: 3,
                      ),
                    ),

                    SizedBox(height: size.height * 0.012),
                    const _PageIndicatorLine(),

                    SizedBox(height: size.height * 0.02),
                    // Community banner
                    Container(
                      height: size.height * 0.18,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6A5E),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                      child: Text(
                        'انضم إلى مجتمعنا\n\nكن جزءًا من مجتمعٍ يساعدك، كن\nضمن أصدقائك وحققنا\nنجاحًا! انضم إلينا الآن! 🔔',
                        style: AppTextStyles.bold(
                          fontSize: size.width * 0.045,
                          color: Colors.white,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),

                    SizedBox(height: size.height * 0.02),
                    _SectionHeader(title: 'أفضل الدكاتره تقييمًا', onAllTap: () {}),
                    SizedBox(height: size.height * 0.012),

                    _DoctorCard(name: 'د. أحمد حسن', onStart: () {}),
                    SizedBox(height: size.height * 0.012),
                    _DoctorCard(name: 'د. حسين علي', onStart: () {}),
                    SizedBox(height: size.height * 0.09), // space for bottom bar
                  ],
                ),
              ),
            ),

            // Bottom navigation (dark bar with raised home button)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 86,
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom > 0 ? 8 : 12),
                decoration: const BoxDecoration(
                  gradient: AppGradients.blueButton,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _BottomItem(
                          icon: Icons.insights_rounded,
                          label: 'التقدم',
                          selected: _tabIndex == 1,
                          onTap: () => setState(() => _tabIndex = 1),
                          activeColor: Colors.white,
                        ),
                        SizedBox(width: size.width * 0.18),
                        _BottomItem(
                          icon: Icons.person_rounded,
                          label: 'الحساب',
                          selected: _tabIndex == 2,
                          onTap: () => setState(() => _tabIndex = 2),
                          activeColor: Colors.white,
                        ),
                      ],
                    ),
                    Positioned(
                      top: -22,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => _tabIndex = 0),
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.home_rounded,
                                size: 30,
                                color: _primaryBlue,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'الرئيسية',
                            style: AppTextStyles.medium(
                              fontSize: size.width * 0.032,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class _LessonSmallCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onStart;

  const _LessonSmallCard({
    required this.title,
    required this.subtitle,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.045,
        vertical: size.height * 0.018,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: AppTextStyles.bold(
              fontSize: size.width * 0.048,
              color: const Color(0xFF1A2A4A),
            ),
          ),
          SizedBox(height: size.height * 0.005),
          Text(
            subtitle,
            style: AppTextStyles.regular(
              fontSize: size.width * 0.035,
              color: const Color(0xFF7C8899),
            ),
            textAlign: TextAlign.right,
          ),
          const Spacer(),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              height: size.height * 0.048,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E68FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                ),
                onPressed: onStart,
                child: Text(
                  'ابدأ الآن',
                  style: AppTextStyles.semiBold(
                    fontSize: size.width * 0.037,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final String name;
  final VoidCallback onStart;
  const _DoctorCard({required this.name, required this.onStart});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.16,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.018,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.bold(
                        fontSize: size.width * 0.05,
                        color: const Color(0xFF1A2A4A),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Icon(Icons.star, color: Color(0xFFFFD54F), size: 16),
                    Icon(Icons.star, color: Color(0xFFFFD54F), size: 16),
                    Icon(Icons.star, color: Color(0xFFFFD54F), size: 16),
                    Icon(Icons.star, color: Color(0xFFFFD54F), size: 16),
                    Icon(Icons.star_half, color: Color(0xFFFFD54F), size: 16),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: size.height * 0.052,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E68FF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
                      ),
                      onPressed: onStart,
                      child: Text(
                        'ابدأ جلسه مع الدكتور الآن',
                        style: AppTextStyles.semiBold(
                          fontSize: size.width * 0.034,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: size.width * 0.04),
          Container(
            width: size.width * 0.24,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.person, size: 62, color: Color(0xFFCC8650)),
          )
        ],
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color activeColor;

  const _BottomItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: selected ? activeColor : activeColor.withOpacity(0.55)),
          SizedBox(height: size.height * 0.004),
          Text(
            label,
            style: AppTextStyles.medium(
              fontSize: size.width * 0.032,
              color: selected ? activeColor : activeColor.withOpacity(0.55),
            ),
          ),
        ],
      ),
    );
  }
}

class _SimpleLineChartPainter extends CustomPainter {
  final Color color;
  _SimpleLineChartPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint axis = Paint()
      ..color = const Color(0xFFE6EAF0)
      ..strokeWidth = 1.2;
    final Paint line = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    // simple polyline
    final Path p = Path();
    final List<Offset> pts = [
      Offset(size.width * 0.05, size.height * 0.75),
      Offset(size.width * 0.2, size.height * 0.6),
      Offset(size.width * 0.35, size.height * 0.35),
      Offset(size.width * 0.5, size.height * 0.65),
      Offset(size.width * 0.65, size.height * 0.28),
      Offset(size.width * 0.8, size.height * 0.32),
      Offset(size.width * 0.95, size.height * 0.45),
    ];
    p.moveTo(pts.first.dx, pts.first.dy);
    for (int i = 1; i < pts.length; i++) {
      p.lineTo(pts[i].dx, pts[i].dy);
    }
    canvas.drawPath(p, line);

    // light grid & labels left
    final TextPainter tp = TextPainter(textDirection: TextDirection.rtl);
    for (int i = 0; i <= 5; i++) {
      final double y = size.height * (i / 5);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), axis);
      if (i > 0) {
        final String label = (5000 - (i * 1000)).toString();
        tp.text = TextSpan(style: const TextStyle(color: Color(0xFF9EABB8), fontSize: 10), text: label);
        tp.layout();
        tp.paint(canvas, Offset(-tp.width - 6, y - tp.height / 2));
      }
    }
    // bottom labels
    const List<String> days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    for (int i = 0; i < days.length; i++) {
      tp.text = TextSpan(style: const TextStyle(color: Color(0xFF9EABB8), fontSize: 10), text: days[i]);
      tp.layout();
      final double x = size.width * (0.1 + i * 0.12);
      tp.paint(canvas, Offset(x - tp.width / 2, size.height - tp.height));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MoodIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  const _MoodIcon({required this.icon, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFC7CCD4), width: 3),
        color: selected ? const Color(0xFFEFF3FF) : Colors.transparent,
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 30, color: selected ? Colors.black87 : const Color(0xFFC7CCD4)),
    );
  }
}

class _PageIndicatorLine extends StatelessWidget {
  const _PageIndicatorLine();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.12,
      height: 4,
      decoration: BoxDecoration(
        color: const Color(0xFF1A2A4A),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class SignUpStutterDurationPage extends StatefulWidget {
  const SignUpStutterDurationPage({super.key});

  @override
  State<SignUpStutterDurationPage> createState() => _SignUpStutterDurationPageState();
}

class _SignUpStutterDurationPageState extends State<SignUpStutterDurationPage> {
  final List<String> _durations = const [
    '1 شهر',
    '3 شهور',
    '6 شهور',
    '1 سنة',
    '2 سنة',
    '3 سنوات',
    '5 سنوات',
    'منذ الطفولة',
  ];

  String? _selectedDuration = '1 سنة';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Background gradient
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: AppGradients.blueBackground,
              ),
            ),

            // Title and back button
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.06,
                  vertical: size.height * 0.02,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 48),
                    Text(
                      'انشاء حساب',
                      style: AppTextStyles.bold(
                        fontSize: size.width * 0.08,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.25),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Progress bar
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.16,
                  left: size.width * 0.08,
                  right: size.width * 0.08,
                ),
                child: Stack(
                  children: [
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.9,
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFB226E1), Color(0xFF3F2B96)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // White content sheet
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: size.height * 0.78,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(80),
                    topRight: Radius.circular(80),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 30,
                      offset: const Offset(0, -6),
                      spreadRadius: 6,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.07,
                    vertical: size.height * 0.04,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.02),
                      Text(
                        'منذ متى وانت \nلديك تأتأة ؟',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bold(
                          fontSize: size.width * 0.095,
                          color: const Color(0xFF0B1F3A),
                        ),
                      ),
                      SizedBox(height: size.height * 0.06),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.07),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.04,
                          vertical: size.height * 0.006,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedDuration,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF1A2A4A)),
                            alignment: Alignment.centerRight,
                            items: _durations
                                .map((d) => DropdownMenuItem<String>(
                                      value: d,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          d,
                                          style: AppTextStyles.regular(
                                            fontSize: size.width * 0.045,
                                            color: const Color(0xFF1A2A4A),
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              setState(() => _selectedDuration = val);
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.06),
                      Container(
                        height: size.height * 0.065,
                        decoration: BoxDecoration(
                          gradient: AppGradients.blueButton,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0D47A1).withOpacity(0.35),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.of(context).popUntil((route) => route.isFirst);
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const DetailedLoginPage(),
                                ),
                              );
                            },
                            child: Center(
                              child: Text(
                                'تسجيل',
                                style: AppTextStyles.semiBold(
                                  fontSize: size.width * 0.05,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

