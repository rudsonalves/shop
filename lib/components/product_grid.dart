import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../models/product_list.dart';
import 'product_grid_item.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid(this.showFavoriteOnly, {super.key});

  final bool showFavoriteOnly;

  @override
  Widget build(BuildContext context) {
    final List<Product> loadedProducts = showFavoriteOnly
        ? Provider.of<ProductList>(context).favoriteItems
        : Provider.of<ProductList>(context).items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: loadedProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: loadedProducts[index],
        child: const ProductGridItem(),
      ),
    );
  }
}
