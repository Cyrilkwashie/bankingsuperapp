import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/app_export.dart';
import '../../../models/verified_customer.dart';

enum CustomerDocumentViewType { photo, signature }

class CustomerDocumentViewerScreen extends StatelessWidget {
  final VerifiedCustomer customer;
  final CustomerDocumentViewType viewType;
  final Color accentColor;

  const CustomerDocumentViewerScreen({
    super.key,
    required this.customer,
    required this.viewType,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final isPhoto = viewType == CustomerDocumentViewType.photo;
    final title = isPhoto ? 'Customer Photograph' : 'Signature Specimen';

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          _buildHeader(context, title),
          Expanded(
            child: InteractiveViewer(
              minScale: 0.8,
              maxScale: 4,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: isPhoto
                      ? _buildPhotoView()
                      : _buildSignatureView(),
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 2.h),
              child: Column(
                children: [
                  Text(
                    customer.name,
                    style: GoogleFonts.inter(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 0.3.h),
                  Text(
                    isPhoto
                        ? 'Pinch or drag to zoom the on-file passport photo'
                        : 'Pinch or drag to zoom the on-file signature',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 7.sp,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1B365D),
            accentColor,
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoView() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        customer.photoAssetPath,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Container(
          color: const Color(0xFF1F2937),
          padding: EdgeInsets.all(8.w),
          child: Icon(Icons.person_outline, size: 20.w, color: Colors.white38),
        ),
      ),
    );
  }

  Widget _buildSignatureView() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: ColoredBox(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
          child: SvgPicture.asset(
            customer.signatureAssetPath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
