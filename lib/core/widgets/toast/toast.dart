import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:luminalens/core/constant/toast_offset.dart';
import 'package:luminalens/core/enum/enum.dart';

import 'toast_animation.dart';
import 'toast_provider.dart';

class FxToast {
  static OverlayEntry? _overlayEntry;
  static Timer? _timer;

  /// Use [ToastWithColor] or [ToastWithoutColor] for ToastProvider
  static Future<void> showToast(
      {required BuildContext context,
      ToastPosition? position = ToastPosition.top,
      required ToastProvider toast,
      Duration? displayDuration,
      Duration? animationDuration,
      double? toastWidth}) async {
    if (_timer != null) {
      _timer?.cancel();
      (_overlayEntry != null) ? _overlayEntry?.remove() : null;
    }
    _overlayEntry = _createOverlayEntry(
        context, toast, position ?? ToastPosition.top, animationDuration, toastWidth);
    Overlay.of(context).insert(_overlayEntry!);
    _timer = Timer(
      displayDuration ?? const Duration(seconds: 2),
      () {
        _timer?.cancel();
        _overlayEntry?.remove();
        _overlayEntry = null;
      },
    );
  }

  /// Use [ToastWithColor] or [ToastWithoutColor] for ToastProvider
  static show(BuildContext context, ToastProvider toast) {
    return Material(
      color: Colors.transparent,
      child: toast.show(context, null),
    );
  }

  static OverlayEntry _createOverlayEntry(
    BuildContext context,
    ToastProvider toast,
    ToastPosition position,
    Duration? duration,
    double? toastWidth,
  ) {
    bool isWeb = MediaQuery.of(context).size.width >= 1100;

    return OverlayEntry(
      builder: (context) => Positioned(
        top: position == ToastPosition.top ||
                position == ToastPosition.topLeft ||
                position == ToastPosition.topRight
            ? 16.0
            : null,
        left: isWeb
            ? position == ToastPosition.top || position == ToastPosition.bottom
                ? (MediaQuery.of(context).size.width - (toastWidth ?? 500.0)) /
                    2
                : null
            : null,
        right: isWeb
            ? position == ToastPosition.topRight ||
                    position == ToastPosition.bottomRight
                ? 0.0
                : null
            : null,
        bottom: position == ToastPosition.bottom ||
                position == ToastPosition.bottomLeft ||
                position == ToastPosition.bottomRight
            ? 16.0
            : null,
        child: ToastAnimation(
          offset: getOffset(position),
          duration: duration,
          child: Material(
            color: Colors.transparent,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: toast.show(context, toastWidth),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static showSuccessToast({required BuildContext context,String? message}){
    return showToast(context: context,
      toast: ToastWithoutColor.success(
        message: message ?? "success".tr(),
        icon: Icons.check_circle_rounded,
      ),
      position: ToastPosition.topRight,);
  }

  static showErrorToast({required BuildContext context,String? message}){
    return showToast(context: context,
      toast: ToastWithoutColor.error(
        message: message ?? "failed".tr(),
        icon: Icons.error_rounded,
      ),
      position: ToastPosition.top,);
  }

  static showWarningToast({required BuildContext context,required String warningMessage}){
    return showToast(context: context,
      toast: ToastWithoutColor.warning(
        message: warningMessage,
        icon: Icons.warning_rounded,
      ),
      position: ToastPosition.topLeft,);
  }
  static showInfoToast({required BuildContext context,required String infoMessage}){
    return showToast(context: context,
      toast: ToastWithoutColor.warning(
        message: infoMessage,
        icon: Icons.info_rounded,
      ),
      position: ToastPosition.topRight,);
  }
}
