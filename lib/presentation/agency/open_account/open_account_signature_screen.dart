part of 'agency_open_account_screen.dart';

class _OpenAccountSignatureScreen extends StatefulWidget {
  final List<List<Offset?>> initialStrokes;
  final Color accentColor;
  final List<Color> gradientColors;

  const _OpenAccountSignatureScreen({
    required this.initialStrokes,
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  State<_OpenAccountSignatureScreen> createState() =>
      _OpenAccountSignatureScreenState();
}

class _OpenAccountSignatureScreenState extends State<_OpenAccountSignatureScreen> {
  late List<List<Offset?>> _localStrokes;
  List<Offset?> _localCurrent = [];

  @override
  void initState() {
    super.initState();
    _localStrokes = widget.initialStrokes
        .map((stroke) => List<Offset?>.from(stroke))
        .toList();
  }

  bool get _hasSig => _localStrokes.isNotEmpty;

  void _clearSignature() {
    setState(() {
      _localStrokes.clear();
      _localCurrent = [];
    });
  }

  void _saveAndClose() {
    Navigator.of(context).pop(
      _localStrokes.map((stroke) => List<Offset?>.from(stroke)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canvasBg = isDark ? const Color(0xFF0D1117) : Colors.white;
    final linePaint = isDark
        ? Colors.white.withValues(alpha: 0.85)
        : const Color(0xFF1B365D);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _OpenAccountUi.buildAgencyHeader(
            context: context,
            isDark: isDark,
            title: 'Customer Signature',
            subtitle: 'Documents · Sign to confirm',
            gradientColors: widget.gradientColors,
            icon: Icons.draw_rounded,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(5.w, 1.6.h, 5.w, 1.5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _OpenAccountUi.buildIntroTip(
                    isDark,
                    'Ask the customer to sign inside the box using their finger or stylus. The signature will be stored with the account opening record.',
                    accentColor: widget.accentColor,
                  ),
                  SizedBox(height: 1.2.h),
                  Row(
                    children: [
                      Text(
                        'Signature Pad',
                        style: GoogleFonts.inter(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF111827),
                        ),
                      ),
                      const Spacer(),
                      if (_hasSig)
                        GestureDetector(
                          onTap: _clearSignature,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.5.w,
                              vertical: 0.45.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDC2626)
                                  .withValues(alpha: isDark ? 0.12 : 0.06),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFDC2626)
                                    .withValues(alpha: 0.18),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.refresh_rounded,
                                  size: 13,
                                  color: Color(0xFFDC2626),
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  'Clear',
                                  style: GoogleFonts.inter(
                                    fontSize: 7.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFDC2626),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 0.8.h),
                  Container(
                    height: 42.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: canvasBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _hasSig
                            ? const Color(0xFF059669).withValues(alpha: 0.35)
                            : (isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : const Color(0xFFE5E7EB)),
                        width: _hasSig ? 1.5 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 28,
                            left: 16,
                            right: 16,
                            child: Container(
                              height: 1,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.07)
                                  : const Color(0xFFE5E7EB),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 16,
                            child: Text(
                              'Sign above this line',
                              style: GoogleFonts.inter(
                                fontSize: 6.5.sp,
                                color: isDark
                                    ? Colors.white12
                                    : const Color(0xFFD1D5DB),
                              ),
                            ),
                          ),
                          if (!_hasSig)
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.gesture_rounded,
                                    size: 36,
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.08)
                                        : const Color(0xFFE5E7EB),
                                  ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    'Draw signature here',
                                    style: GoogleFonts.inter(
                                      fontSize: 8.5.sp,
                                      color: isDark
                                          ? Colors.white12
                                          : const Color(0xFFD1D5DB),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onPanStart: (d) => setState(() {
                              _localCurrent = [d.localPosition];
                              _localStrokes.add(_localCurrent);
                            }),
                            onPanUpdate: (d) =>
                                setState(() => _localCurrent.add(d.localPosition)),
                            onPanEnd: (_) => setState(() => _localCurrent = []),
                            child: CustomPaint(
                              painter: _SignaturePainter(_localStrokes, linePaint),
                              child: const SizedBox.expand(),
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
          _OpenAccountUi.buildStickyActionBar(
            isDark: isDark,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 1.25.h),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.06)
                            : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.inter(
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? Colors.white54
                                : const Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 2.5.w),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: _saveAndClose,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 1.25.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _hasSig
                              ? const [
                                  Color(0xFF059669),
                                  Color(0xFF047857),
                                ]
                              : [
                                  widget.accentColor,
                                  widget.accentColor.withValues(alpha: 0.85),
                                ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: (_hasSig
                                    ? const Color(0xFF059669)
                                    : widget.accentColor)
                                .withValues(alpha: 0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _hasSig
                                  ? Icons.check_rounded
                                  : Icons.skip_next_rounded,
                              size: 17,
                              color: Colors.white,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              _hasSig ? 'Save Signature' : 'Skip',
                              style: GoogleFonts.inter(
                                fontSize: 9.5.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
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
        ],
      ),
    );
  }
}
