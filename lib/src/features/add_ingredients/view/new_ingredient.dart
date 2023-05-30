import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/features/add_ingredients/widgets/ingredient_form.dart';
import 'package:feed_estimator/src/utils/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class NewIngredient extends StatelessWidget {
  final String? ingredientId;
  const NewIngredient({
    Key? key,
    this.ingredientId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final int? ingId =
        (ingredientId == null || ingredientId == "null" || ingredientId == "")
            ? null
            : int.tryParse(ingredientId!);
    return Scaffold(
      drawer: const FeedAppDrawer(),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          tileMode: TileMode.repeated,
          stops: [0.4, 0.8],
          colors: [
            AppConstants.appBackgroundColor,
            Color(0xff87643E),
          ],
        )),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              snap: false,
              floating: false,
              expandedHeight: displayHeight(context) * .25,
              //  leading: IconButton(onPressed: (){}, icon: Icon(Icons.menu, color: AppConstants.appBackgroundColor,)),
              actions: const [],
              foregroundColor: AppConstants.appBackgroundColor,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      tileMode: TileMode.repeated,
                      stops: const [
                        0.6,
                        0.9
                      ],
                      colors: [
                        const Color(0xff87643E),
                        const Color(0xff87643E).withOpacity(.7)
                      ]),
                ),
                child: FlexibleSpaceBar(
                    title: Text(
                        ingId != null ? "Update Ingredient" : 'Add Ingredient'),
                    centerTitle: true,
                    background: const Image(
                        image: AssetImage('assets/images/back.png'))),
              ),
            ),
            SliverToBoxAdapter(
              child: IngredientForm(
                ingId: ingId,
              ),
            )
          ],
        ),
      ),
    );
  }
}
