import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../core/widgets/app_button/app_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageController = PageController();
  int _currentPage = 0;
  bool _loading = false;

  List<_OnboardingSlide> _slides(AppLocalizations l) => [
    _OnboardingSlide(
      title: l.weddingDecorationDreams,
      description: l.findBeautifulFlowers,
    ),
    _OnboardingSlide(title: l.searchWithImage, description: l.useCbirFeature),
    _OnboardingSlide(
      title: l.easyQuickOrder,
      description: l.orderFavoritePackages,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onFinish() async {
    if (_loading) return;
    setState(() => _loading = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
    if (mounted) context.go('/landing');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _slides(l).length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (_, i) => _slides(l)[i],
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            child: _currentPage > 0
                ? IconButton(
                    onPressed: () => _pageController.previousPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    ),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 22,
                    ),
                    splashRadius: 20,
                  )
                : const SizedBox.shrink(),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 16,
            child: TextButton(
              onPressed: _loading ? null : _onFinish,
              child: Text(
                l.skip,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).padding.bottom + 32,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_slides(l).length, (i) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == i ? 28 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == i
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: AppButton(
                    label: _currentPage == _slides(l).length - 1
                        ? l.getStarted
                        : l.next,
                    loading: _loading,
                    onPressed: _loading
                        ? null
                        : () {
                            if (_currentPage == _slides(l).length - 1) {
                              _onFinish();
                            } else {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  final String title;
  final String description;

  const _OnboardingSlide({required this.title, required this.description});

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/article/article-4.png', fit: BoxFit.cover),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                AppColors.primaryDark.withAlpha(128),
                AppColors.primaryDark.withAlpha(204),
              ],
            ),
          ),
        ),
        Positioned(
          top: -100,
          right: -50,
          child: _blob(300, AppColors.primaryColor.withValues(alpha: 0.15)),
        ),
        Positioned(
          bottom: 80,
          left: -80,
          child: _blob(240, AppColors.secondaryColor.withValues(alpha: 0.12)),
        ),
        Positioned(
          top: 240,
          left: -40,
          child: _blob(140, AppColors.accentColor.withValues(alpha: 0.08)),
        ),
        Positioned(
          bottom: 340,
          right: -30,
          child: _blob(120, AppColors.infoColor.withValues(alpha: 0.06)),
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 32,
              right: 32,
              bottom: MediaQuery.of(context).padding.bottom + 148,
            ),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Image.asset('assets/images/logo.png', width: 100, height: 100),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.3,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        offset: const Offset(0, 2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.95),
                    height: 1.5,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        offset: const Offset(0, 1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
