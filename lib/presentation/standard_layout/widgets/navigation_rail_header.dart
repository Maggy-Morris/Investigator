import 'package:flutter/material.dart';
import 'package:luminalens/core/resources/adaptive.dart';

class NavigationRailHeader extends StatelessWidget {
  const NavigationRailHeader(
      {super.key,
      required this.extended,
      required this.logo,
      required this.isExpanded});

  final Function extended;
  final bool isExpanded;
  final Widget logo;

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    final animation = NavigationRail.extendedAnimation(context);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Align(
          alignment: AlignmentDirectional.center,
          child: GestureDetector(
            // radius: 0.1,
            // hoverColor: AppColors.scaffoldBackGround,
            // borderRadius: const BorderRadius.all(Radius.circular(16)),
            onTap: isDisplayDesktop(context) ? () => extended() : null,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 150,
                maxWidth: (isExpanded) ? 150 : 100,
              ),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 5,
                  right: 5,
                ),
                margin: const EdgeInsets.only(bottom: 50,top: 20),
                color: Colors.transparent,
                child: logo,
              ),
            ),
            // Row(
            //   children: [
            //     // Transform.rotate(
            //     //   angle: animation.value * pi,
            //     //   child: const Icon(
            //     //     Icons.arrow_right,
            //     //     color: Colors.black,
            //     //     size: 16,
            //     //   ),
            //     // ),
            //     // const _ReplyLogo(),
            //     const SizedBox(width: 10),
            //     ConstrainedBox(
            //       constraints: const BoxConstraints(
            //           maxHeight: 150.0, maxWidth: 150.0),
            //       child: Container(
            //           padding: const EdgeInsets.only(bottom: 30.0),
            //           color: Colors.white,
            //           child: Image.asset('assets/ums-logo.png')),
            //     ),
            //     // Align(
            //     //   alignment: AlignmentDirectional.centerStart,
            //     //   widthFactor: animation.value,
            //     //   child: Opacity(
            //     //     opacity: animation.value,
            //     //     child: Text(
            //     //       'REPLY',
            //     //       style: textTheme.bodyLarge!.copyWith(
            //     //         color: Colors.black,
            //     //       ),
            //     //     ),
            //     //   ),
            //     // ),
            //     SizedBox(width: 18 * animation.value),
            //   ],
            // ),
          ),
        );
      },
    );
  }
}
