import 'package:flutter/material.dart';

import '../core/utils/screen_size.dart';
import 'shimmer_widget.dart';

class MovieListShimmerWidget extends StatelessWidget {
  const MovieListShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.only(
        right: context.width * 0.04,
        left: context.width * 0.04,
        bottom: context.height * 0.1,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: context.width * 0.04,
        mainAxisSpacing: context.width * 0.04,
        childAspectRatio: 0.7,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        return ShimmerWidget();
      },
    );
  }
}
