import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../l10n/l10n.dart';
import '../../application/splash_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  // Plays once: logo pops in, then the text slides up.
  late final AnimationController _intro;
  // Loops: ripple rings behind the logo and the loading dots.
  late final AnimationController _loop;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    )..forward();
    _loop = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat();

    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _intro,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );
    _logoFade = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    );
    final textCurve = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
    );
    _textFade = textCurve;
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(textCurve);

    _navigate();
  }

  @override
  void dispose() {
    _intro.dispose();
    _loop.dispose();
    super.dispose();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 4));
    final destination =
        await ref.read(splashControllerProvider.notifier).decide();
    if (!mounted) return;
    switch (destination) {
      case ResumeTrip(:final trip):
        // App was killed mid-trip — go straight back to it. TripScreen
        // restarts tracking; Home will reconcile with the server later.
        context.go(AppRoutes.tripOf(trip.id), extra: trip);
      case GoToHome():
        context.go(AppRoutes.home);
      case GoToLogin():
        context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      backgroundColor: const Color(0xFF0B1B3F),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Same photo as the auth screens, under a heavy navy wash.
          Image.asset(
            'assets/images/login_bg.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xCC0B1B3F),
                  Color(0xE60B1B3F),
                  Color(0xFF0B1B3F),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 240,
                  height: 240,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Ripple rings radiating from the logo.
                      AnimatedBuilder(
                        animation: _loop,
                        builder: (context, _) => CustomPaint(
                          size: const Size(240, 240),
                          painter: _RipplePainter(_loop.value),
                        ),
                      ),
                      FadeTransition(
                        opacity: _logoFade,
                        child: ScaleTransition(
                          scale: _logoScale,
                          child: Container(
                            width: 124,
                            height: 124,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(34),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFFFEC610).withOpacity(0.35),
                                  blurRadius: 36,
                                  spreadRadius: 2,
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.directions_bus,
                                size: 56,
                                color: Color(0xFF1B3B69),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                FadeTransition(
                  opacity: _textFade,
                  child: SlideTransition(
                    position: _textSlide,
                    child: Column(
                      children: [
                        Text(
                          context.l10n.appTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          context.l10n.splashTagline,
                          style: const TextStyle(
                            color: Color(0xFFFEC610),
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Loading dots
          Positioned(
            left: 0,
            right: 0,
            bottom: 48 + bottomInset,
            child: FadeTransition(
              opacity: _textFade,
              child: AnimatedBuilder(
                animation: _loop,
                builder: (context, _) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    // Each dot peaks a third of a cycle after the previous one.
                    final t = (_loop.value - i / 3) % 1.0;
                    final lift = t < 0.5
                        ? Curves.easeInOut.transform(t * 2)
                        : Curves.easeInOut.transform(2 - t * 2);
                    return Transform.translate(
                      offset: Offset(0, -8 * lift),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.lerp(
                            Colors.white30,
                            const Color(0xFFFEC610),
                            lift,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  _RipplePainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    // Two rings, half a cycle apart, growing out from behind the logo.
    for (var i = 0; i < 2; i++) {
      final t = (progress + i / 2) % 1.0;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = const Color(0xFFFEC610).withOpacity((1 - t) * 0.35);
      canvas.drawCircle(center, 62 + t * 58, paint);
    }
  }

  @override
  bool shouldRepaint(_RipplePainter old) => old.progress != progress;
}
