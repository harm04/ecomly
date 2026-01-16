import 'dart:async';

import 'package:ecomly/common/pallete.dart';
import 'package:ecomly/common/widgets/optimized_image.dart';
import 'package:ecomly/providers/banner_provider.dart';
import 'package:flutter/material.dart';
import 'package:ecomly/common_controllers/banner_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BannerWidget extends ConsumerStatefulWidget {
  const BannerWidget({super.key});

  @override
  ConsumerState<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends ConsumerState<BannerWidget> {
  final PageController _pageController = PageController();

  Timer? _timer;
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchBanner();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll(int bannerCount) {
    _timer?.cancel();
    if (bannerCount <= 1) return;

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients && mounted) {
        _currentPage = (_currentPage + 1) % bannerCount;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopAutoScroll() {
    _timer?.cancel();
  }

  Future<void> fetchBanner() async {
    final BannerController bannerController = BannerController();
    try {
      final banners = await bannerController.fetchBanners();
      ref.read(bannerProvider.notifier).setBanners(banners);
      if (banners.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _startAutoScroll(banners.length);
          }
        });
      }
    } catch (error) {
      print('Error fetching popular products:$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final banners = ref.watch(bannerProvider);
    ref.listen(bannerProvider, (previous, next) {
      if (next.isNotEmpty && (previous?.length != next.length)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _startAutoScroll(next.length);
          }
        });
      }
    });
    return banners.isEmpty || banners.length == 0
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              height: 170,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: banners.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _stopAutoScroll();

                            Timer(const Duration(seconds: 5), () {
                              _startAutoScroll(banners.length);
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: BannerImage(
                                imageUrl: banners[index].image,
                                width: double.infinity,
                                height: 180,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      banners.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: _currentPage == index ? 12 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Pallete.primaryColor
                              : Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(4),
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
