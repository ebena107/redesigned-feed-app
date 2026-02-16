import 'package:feed_estimator/src/features/add_ingredients/widgets/ingredient_form.dart';
import 'package:feed_estimator/src/utils/widgets/responsive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:feed_estimator/src/core/localization/localization_helper.dart';

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

    return ResponsiveScaffold(
      body: SafeArea(
        top: false,
        child: CustomScrollView(
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
                flexibleSpace: Container(
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
                  child: FlexibleSpaceBar(
                    title: Text(
                      ingId != null
                          ? "${context.l10n.actionUpdate} ${context.l10n.navIngredients}"
                          : "${context.l10n.actionAdd} ${context.l10n.navIngredients}",
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                    collapseMode: CollapseMode.parallax,
                    background: const Image(
                      image: AssetImage('assets/images/back.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                )),

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
      ),
    );
  }
}
