import 'package:feed_estimator/src/features/add_ingredients/widgets/ingredient_form.dart';
import 'package:feed_estimator/src/utils/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewIngredient extends StatelessWidget {
  final String? ingredientId;
  const NewIngredient({
    super.key,
    this.ingredientId,
  });

  @override
  Widget build(BuildContext context) {
    final int? ingId =
        (ingredientId == null || ingredientId == "null" || ingredientId == "")
            ? null
            : int.tryParse(ingredientId!);

    return Scaffold(
      drawer: const FeedAppDrawer(),
      body: CustomScrollView(
        slivers: [
          // Modern SliverAppBar with back.png background
          SliverAppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Color(0xff87643E),
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
            pinned: true,
            expandedHeight: 180,
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Back pattern background
                  const Image(
                    image: AssetImage('assets/images/back.png'),
                    fit: BoxFit.cover,
                  ),
                  // Brown overlay gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xff87643E).withValues(alpha: 0.4),
                          const Color(0xff87643E).withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                  // Title positioned at bottom
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Text(
                      ingId != null ? "Update Ingredient" : "Add Ingredient",
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content section with modern styling
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xff87643E).withValues(alpha: 0.1),
                    Colors.white.withValues(alpha: 0.98),
                  ],
                  stops: const [0.0, 0.2],
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(top: 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      offset: Offset(0, -5),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 24.0),
                  child: IngredientForm(
                    ingId: ingId,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
