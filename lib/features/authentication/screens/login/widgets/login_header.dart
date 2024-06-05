import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:app_health_connect/utils/constants/sizes.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:app_health_connect/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class TLoginHeader extends StatelessWidget {
  const TLoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Image(
          height: 150,
          image: AssetImage(TImages.officialLogo),
        ),
      /*  Text(TTexts.loginTitle,
          // style: Theme.of(context).textTheme.headlineMedium
            style: TextStyle(color: TColors.primary,fontSize: TSizes.lg)
        ), */
        const SizedBox(height: TSizes.sm),
        Text(TTexts.loginSubTitle,
          //style: Theme.of(context).textTheme.headlineSmall
          style: TAppTheme.textThemeSubTitlePrimary
        ),
      ],
    );
  }
}