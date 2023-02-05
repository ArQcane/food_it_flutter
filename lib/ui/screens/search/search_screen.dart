import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:food_it_flutter/providers_viewmodels/authentication_provider.dart';
import 'package:food_it_flutter/ui/components/extras/gradient_text.dart';
import 'package:food_it_flutter/ui/screens/restaurant/specific_restaurant_screen.dart';
import 'package:food_it_flutter/ui/theme/colors.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as ra;

import '../../../domain/user/user.dart';
import '../../../providers_viewmodels/restaurant_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _formKey = GlobalKey<FormState>();
  var query = "";

  late ra.RiveAnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = ra.OneShotAnimation("doggo", autoplay: false);
  }

  @override
  Widget build(BuildContext context) {
    var restaurantProvider = Provider.of<RestaurantProvider>(context);
    var authProvider = Provider.of<AuthenticationProvider>(context);
    var currentUser = authProvider.user!;
    var token = authProvider.token!;
    var restaurantList = restaurantProvider.restaurantList
        .where(
          (element) => element.restaurant.restaurant_name
              .toLowerCase()
              .contains(query.toLowerCase()),
        )
        .toList()
      ..sort(
        (a, b) => a.restaurant.restaurant_name
            .toLowerCase()
            .indexOf(query.toLowerCase())
            .compareTo(
              b.restaurant.restaurant_name
                  .toLowerCase()
                  .indexOf(query.toLowerCase()),
            ),
      );

    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Form(
              key: _formKey,
              child: TextFormField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        query = "";
                      });
                      _formKey.currentState!.reset();
                    },
                  ),
                  hintText: 'Enter restaurant name here',
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.search,
                onChanged: (value) {
                  setState(() {
                    query = value;
                  });
                },
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GradientText(text: "Restaurants Queried"),
              const SizedBox(height: 10),
              _buildRestaurantCards(
                restaurantList,
                currentUser,
                restaurantProvider,
                token,
              ),
              if (restaurantList.isEmpty)
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 220,
                      child: ra.RiveAnimation.asset(
                        "assets/rive/search-interactive-ui-doggo.riv",
                        fit: BoxFit.fill,
                        animations: ["idle"],
                      ),
                    ),
                    Material(
                      elevation: 4,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              "No restaurants found",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            Text(
                              "Try searching for something else",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantCards(
    List<TransformedRestaurant> restaurantList,
    User currentUser,
    RestaurantProvider restaurantProvider,
    String token,
  ) {
    return Column(
      children: restaurantList.map(
        (e) {
          var isFavoritedByCurrentUser = e.usersWhoFavRestaurant.any(
            (element) => element.userId == currentUser.user_id,
          );

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: OpenContainer(
              closedBuilder: (context, openContainer) {
                return _buildSearchCard(
                  leadingImageUrl: e.restaurant.restaurant_logo,
                  title: e.restaurant.restaurant_name,
                  location: e.restaurant.location,
                  rating: e.restaurant.average_rating.toString(),
                  cuisine: e.restaurant.cuisine,
                  onTap: openContainer,
                  trailing: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [primaryAccent, primary],
                    ).createShader(bounds),
                    child: IconButton(
                      splashRadius: 20,
                      icon: Icon(
                        isFavoritedByCurrentUser
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                      onPressed: () {
                        restaurantProvider.toggleRestaurantFavourite(
                          e.restaurant.restaurant_id.toString(),
                          currentUser,
                          !isFavoritedByCurrentUser,
                        );
                      },
                    ),
                  ),
                );
              },
              closedColor: ElevationOverlay.colorWithOverlay(
                Theme.of(context).colorScheme.surface,
                Colors.white,
                4,
              ),
              closedElevation: 4,
              openElevation: 0,
              transitionDuration: const Duration(milliseconds: 500),
              transitionType: ContainerTransitionType.fadeThrough,
              openBuilder: (context, _) {
                return SpecificRestaurantScreen(
                  restaurantId: e.restaurant.restaurant_id.toString(),
                );
              },
            ),
          );
        },
      ).toList(),
    );
  }

  Widget _buildSearchCard({
    required String? leadingImageUrl,
    required String title,
    required String location,
    required String cuisine,
    required String rating,
    Widget? trailing,
    void Function()? onTap,
  }) {
    var startQueryIndex = title.toLowerCase().indexOf(query.toLowerCase());
    var endQueryIndex = startQueryIndex + query.length;

    return InkWell(
      onTap: onTap,
      child: ListTile(
        isThreeLine: true,
        subtitle: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.75),
            ),
            children: [
              TextSpan(text: "$location - $cuisine" + "\n$rating"),
            ],
          ),
        ),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(
              color: primary,
              width: 2,
            ),
            shape: BoxShape.circle,
          ),
          child: leadingImageUrl == null
              ? const Icon(Icons.person)
              : ClipOval(
                  child: Image.network(
                    leadingImageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 18,
              color: primary,
            ),
            children: [
              TextSpan(
                text: title.substring(
                  0,
                  startQueryIndex,
                ),
              ),
              TextSpan(
                text: title.substring(
                  startQueryIndex,
                  endQueryIndex,
                ),
                style: const TextStyle(color: primary),
              ),
              TextSpan(
                text: title.substring(endQueryIndex),
              ),
            ],
          ),
        ),
        trailing: trailing,
      ),
    );
  }
}
