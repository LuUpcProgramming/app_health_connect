import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class TFormDivider extends StatelessWidget {
  const TFormDivider({
    super.key, required this.dividerText
  });

  final String dividerText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Flexible(
            child: Divider(
                color: Colors.grey, thickness: 0.5, indent: 20, endIndent: 5)),
        Text(
          dividerText,
          style: TAppTheme.textThemeCustom(15, 'Source Sans Pro', FontStyle.normal, TColors.dark, FontWeight.w500),
        ),
        const Flexible(
          child: Divider(
              color: Colors.grey, thickness: 0.5, indent: 20, endIndent: 10),
        )
      ],
    );
  }
}
