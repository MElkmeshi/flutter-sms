# Technical Spec: Product Detail Feature

> **Last Updated**: January 2026

---

## Overview

The product detail screen displays comprehensive product information including image gallery, pricing, product details, seller information, and suggested products.

---

## API Endpoints

### Get Product Details

Fetches detailed information about a specific product.

```http
GET /api/v1/products/{productUuid} HTTP/1.1
```

**Response:**
```json
{
  "data": {
    "id": "uuid",
    "name": "Summer Dress",
    "description": "Beautiful summer dress perfect for casual outings...",
    "offer_type": "sale",
    "price": 120.00,
    "price_after_discount": 79.99,
    "media": {
      "front_picture": "https://...",
      "back_picture": "https://...",
      "tag_picture": "https://...",
      "video": "https://...",
      "gallery": [
        "https://...",
        "https://...",
        "https://..."
      ]
    },
    "category": {
      "id": "uuid",
      "name": "Dresses",
      "name_ar": "فساتين"
    },
    "brand": {
      "id": "uuid",
      "name": "Zara",
      "logo_url": "https://..."
    },
    "color": {
      "id": "uuid",
      "name": "Navy Blue",
      "name_ar": "أزرق داكن",
      "hex": "#000080"
    },
    "sizes": {
      "eu": "38",
      "uk": "10",
      "letter": "M"
    },
    "quality_status": {
      "id": "like_new",
      "name": "Like New",
      "name_ar": "كالجديد"
    },
    "delivery_type": {
      "id": "shipping",
      "name": "Shipping",
      "name_ar": "شحن"
    },
    "country_of_manufacture": {
      "id": "uuid",
      "name": "Italy",
      "name_ar": "إيطاليا"
    },
    "style": "Casual",
    "is_available": true,
    "store": {
      "id": "uuid",
      "name": "Sarah's Closet",
      "avatar_url": "https://...",
      "product_count": 156,
      "joined_at": "2024-01-15T00:00:00Z"
    },
    "reactions": {
      "love": 45,
      "like": 23,
      "fire": 12
    },
    "user_reaction": "love",
    "created_at": "2026-01-05T10:30:00Z"
  }
}
```

---

### Get Suggested Products

Fetches related/similar products.

```http
GET /api/v1/products/{productUuid}/suggestions HTTP/1.1
```

**Alternative:** Use products endpoint with category filter:

```http
GET /api/v1/products?filter[category]={categoryId}&exclude={productId}&limit=10 HTTP/1.1
```

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "name": "Casual Dress",
      "image_url": "https://...",
      "price": 89.00,
      "price_after_discount": null,
      "category": {
        "id": "uuid",
        "name": "Dresses"
      }
    }
  ]
}
```

---

### Toggle Wishlist (Reaction)

Adds or removes product from wishlist.

```http
POST /api/v1/reacted-products/{productUuid} HTTP/1.1
Authorization: Bearer <token>
Content-Type: application/json

{
  "reaction_type": "love"
}
```

**Response:**
```json
{
  "data": {
    "product_id": "uuid",
    "reaction_type": "love",
    "is_reacted": true
  }
}
```

---

### Get Store Details

Fetches seller/store information.

```http
GET /api/v1/stores/{storeUuid} HTTP/1.1
```

**Response:**
```json
{
  "data": {
    "id": "uuid",
    "name": "Sarah's Closet",
    "avatar_url": "https://...",
    "location": "Tripoli, Libya",
    "city": {
      "id": "uuid",
      "name": "Tripoli"
    },
    "product_count": 156,
    "joined_at": "2024-01-15T00:00:00Z",
    "social_links": {
      "facebook_url": "https://...",
      "instagram_url": "https://...",
      "whatsapp_url": "https://..."
    }
  }
}
```

---

## Data Models

### ProductDetail

```dart
@immutable
class ProductDetail extends Equatable {
  const ProductDetail({
    required this.id,
    required this.name,
    this.description,
    required this.offerType,
    required this.price,
    this.priceAfterDiscount,
    required this.media,
    required this.category,
    this.brand,
    this.color,
    this.sizes,
    required this.qualityStatus,
    this.deliveryType,
    this.countryOfManufacture,
    this.style,
    required this.isAvailable,
    required this.store,
    this.reactions,
    this.userReaction,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String? description;
  final String offerType; // 'sale' or 'rent'
  final double price;
  final double? priceAfterDiscount;
  final ProductMedia media;
  final Category category;
  final Brand? brand;
  final ProductColor? color;
  final ProductSizes? sizes;
  final QualityStatus qualityStatus;
  final DeliveryType? deliveryType;
  final Country? countryOfManufacture;
  final String? style;
  final bool isAvailable;
  final SellerSummary store;
  final ProductReactions? reactions;
  final String? userReaction;
  final DateTime createdAt;

  bool get hasDiscount =>
      priceAfterDiscount != null && priceAfterDiscount! < price;

  double get discountPercentage {
    if (!hasDiscount) return 0;
    return ((price - priceAfterDiscount!) / price * 100).roundToDouble();
  }

  double get displayPrice => priceAfterDiscount ?? price;

  bool get isWishlisted => userReaction == 'love';

  @override
  List<Object?> get props => [
        id, name, description, offerType, price, priceAfterDiscount,
        media, category, brand, color, sizes, qualityStatus,
        deliveryType, countryOfManufacture, style, isAvailable,
        store, reactions, userReaction, createdAt,
      ];
}
```

### ProductMedia

```dart
@immutable
class ProductMedia extends Equatable {
  const ProductMedia({
    this.frontPicture,
    this.backPicture,
    this.tagPicture,
    this.video,
    this.gallery = const [],
  });

  final String? frontPicture;
  final String? backPicture;
  final String? tagPicture;
  final String? video;
  final List<String> gallery;

  /// Returns all available images in display order
  List<String> get allImages {
    final images = <String>[];
    if (frontPicture != null) images.add(frontPicture!);
    if (backPicture != null) images.add(backPicture!);
    if (tagPicture != null) images.add(tagPicture!);
    images.addAll(gallery);
    return images;
  }

  bool get hasVideo => video != null;
  bool get hasMultipleImages => allImages.length > 1;

  @override
  List<Object?> get props => [frontPicture, backPicture, tagPicture, video, gallery];
}
```

### ProductSizes

```dart
@immutable
class ProductSizes extends Equatable {
  const ProductSizes({
    this.eu,
    this.uk,
    this.letter,
  });

  final String? eu;
  final String? uk;
  final String? letter;

  String get displaySize {
    if (letter != null) return letter!;
    if (eu != null) return 'EU $eu';
    if (uk != null) return 'UK $uk';
    return 'N/A';
  }

  @override
  List<Object?> get props => [eu, uk, letter];
}
```

### QualityStatus

```dart
@immutable
class QualityStatus extends Equatable {
  const QualityStatus({
    required this.id,
    required this.name,
    this.nameAr,
  });

  final String id;
  final String name;
  final String? nameAr;

  /// Returns a color based on quality status
  Color get indicatorColor {
    switch (id) {
      case 'new':
        return Colors.green;
      case 'like_new':
        return Colors.lightGreen;
      case 'good':
        return Colors.orange;
      case 'fair':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  List<Object?> get props => [id, name, nameAr];
}
```

### SellerSummary

```dart
@immutable
class SellerSummary extends Equatable {
  const SellerSummary({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.productCount,
    required this.joinedAt,
  });

  final String id;
  final String name;
  final String? avatarUrl;
  final int productCount;
  final DateTime joinedAt;

  String get memberSince {
    final formatter = DateFormat('MMM yyyy');
    return 'Member since ${formatter.format(joinedAt)}';
  }

  @override
  List<Object?> get props => [id, name, avatarUrl, productCount, joinedAt];
}
```

### ProductReactions

```dart
@immutable
class ProductReactions extends Equatable {
  const ProductReactions({
    this.love = 0,
    this.like = 0,
    this.fire = 0,
  });

  final int love;
  final int like;
  final int fire;

  int get total => love + like + fire;

  @override
  List<Object?> get props => [love, like, fire];
}
```

---

## Controllers

### ProductDetailController

```dart
class ProductDetailController extends AutoDisposeFamilyAsyncNotifier<ProductDetail, String> {
  static final provider = AsyncNotifierProvider.autoDispose
      .family<ProductDetailController, ProductDetail, String>(
    ProductDetailController.new,
  );

  @override
  Future<ProductDetail> build(String productId) async {
    return _fetchProductDetail(productId);
  }

  Future<ProductDetail> _fetchProductDetail(String productId) async {
    final api = ref.read(productApiProvider);
    return api.getProductDetail(productId);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchProductDetail(arg));
  }

  Future<void> toggleWishlist() async {
    final currentProduct = state.valueOrNull;
    if (currentProduct == null) return;

    // Optimistic update
    final newReaction = currentProduct.isWishlisted ? null : 'love';
    state = AsyncData(currentProduct.copyWith(userReaction: newReaction));

    try {
      final api = ref.read(reactionApiProvider);
      await api.toggleReaction(arg, 'love');
    } catch (e) {
      // Rollback on error
      state = AsyncData(currentProduct);
      rethrow;
    }
  }
}
```

### SuggestedProductsController

```dart
class SuggestedProductsController extends AutoDisposeFamilyAsyncNotifier<List<Product>, String> {
  static final provider = AsyncNotifierProvider.autoDispose
      .family<SuggestedProductsController, List<Product>, String>(
    SuggestedProductsController.new,
  );

  @override
  Future<List<Product>> build(String productId) async {
    return _fetchSuggestedProducts(productId);
  }

  Future<List<Product>> _fetchSuggestedProducts(String productId) async {
    final api = ref.read(productApiProvider);
    return api.getSuggestedProducts(productId, limit: 10);
  }
}
```

### ImageGalleryController

```dart
class ImageGalleryController extends AutoDisposeNotifier<int> {
  static final provider = NotifierProvider.autoDispose<ImageGalleryController, int>(
    ImageGalleryController.new,
  );

  @override
  int build() => 0;

  void setPage(int page) => state = page;

  void nextPage(int maxPages) {
    if (state < maxPages - 1) state++;
  }

  void previousPage() {
    if (state > 0) state--;
  }
}
```

---

## API Services

### ProductApi (Extended)

```dart
abstract class ProductApi {
  Future<PaginatedProducts> getProducts({...});
  Future<ProductDetail> getProductDetail(String productId);
  Future<List<Product>> getSuggestedProducts(String productId, {int limit = 10});
}

class ProductApiImpl implements ProductApi {
  ProductApiImpl(this._client);

  final ApiClient _client;

  @override
  Future<ProductDetail> getProductDetail(String productId) async {
    final response = await _client.get('/api/v1/products/$productId');
    return ProductDetail.fromJson(response.data['data']);
  }

  @override
  Future<List<Product>> getSuggestedProducts(String productId, {int limit = 10}) async {
    // Option 1: If dedicated endpoint exists
    // final response = await _client.get('/api/v1/products/$productId/suggestions');

    // Option 2: Use products endpoint with category filter
    final productDetail = await getProductDetail(productId);
    final response = await _client.get(
      '/api/v1/products',
      queryParameters: {
        'filter[category]': productDetail.category.id,
        'exclude': productId,
        'limit': limit,
      },
    );

    final List<dynamic> data = response.data['data'];
    return data.map((json) => Product.fromJson(json)).toList();
  }
}
```

### ReactionApi

```dart
abstract class ReactionApi {
  Future<void> toggleReaction(String productId, String reactionType);
}

class ReactionApiImpl implements ReactionApi {
  ReactionApiImpl(this._client);

  final ApiClient _client;

  @override
  Future<void> toggleReaction(String productId, String reactionType) async {
    await _client.post(
      '/api/v1/reacted-products/$productId',
      data: {'reaction_type': reactionType},
    );
  }
}

final reactionApiProvider = Provider<ReactionApi>((ref) {
  return ReactionApiImpl(ref.read(apiClientProvider));
});
```

---

## File Structure

```
lib/
├── domain/model/
│   ├── product_detail.dart
│   ├── product_media.dart
│   ├── product_sizes.dart
│   ├── quality_status.dart
│   ├── seller_summary.dart
│   ├── product_reactions.dart
│   └── delivery_type.dart
│
├── feature/product/
│   ├── data/
│   │   ├── product_api.dart
│   │   └── reaction_api.dart
│   ├── deps/
│   │   └── product_deps.dart
│   ├── logic/
│   │   ├── product_detail_controller.dart
│   │   ├── suggested_products_controller.dart
│   │   └── image_gallery_controller.dart
│   └── ui/
│       ├── product_detail_screen.dart
│       ├── image_gallery.dart
│       ├── image_gallery_fullscreen.dart
│       ├── price_section.dart
│       ├── product_details_section.dart
│       ├── seller_section.dart
│       ├── suggested_products_section.dart
│       └── bottom_action_bar.dart
│
└── ui/widget/
    └── product_card.dart       # Shared widget
```

---

## Screen Implementation

### ProductDetailScreen

```dart
@RoutePage()
class ProductDetailScreen extends HookConsumerWidget {
  const ProductDetailScreen({
    super.key,
    @PathParam('productId') required this.productId,
  });

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(ProductDetailController.provider(productId));
    final suggestedAsync = ref.watch(SuggestedProductsController.provider(productId));

    return Scaffold(
      body: productAsync.when(
        loading: () => const ProductDetailShimmer(),
        error: (e, _) => ProductDetailError(
          onRetry: () => ref.invalidate(ProductDetailController.provider(productId)),
        ),
        data: (product) => Stack(
          children: [
            CustomScrollView(
              slivers: [
                // App Bar with actions
                SliverAppBar(
                  floating: true,
                  actions: [
                    IconButton(
                      icon: Icon(
                        product.isWishlisted
                            ? LucideIcons.heartFilled
                            : LucideIcons.heart,
                        color: product.isWishlisted ? Colors.red : null,
                      ),
                      onPressed: () => _toggleWishlist(ref, product),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.share2),
                      onPressed: () => _shareProduct(product),
                    ),
                  ],
                ),

                // Image Gallery
                SliverToBoxAdapter(
                  child: ImageGallery(
                    images: product.media.allImages,
                    onTap: () => _openFullscreenGallery(context, product.media),
                  ),
                ),

                // Price Section
                SliverToBoxAdapter(
                  child: PriceSection(
                    price: product.price,
                    discountPrice: product.priceAfterDiscount,
                  ),
                ),

                // Product Details Section
                SliverToBoxAdapter(
                  child: ProductDetailsSection(product: product),
                ),

                // Seller Section
                SliverToBoxAdapter(
                  child: SellerSection(
                    seller: product.store,
                    onViewProfile: () => _navigateToSellerProfile(context, product.store.id),
                  ),
                ),

                // Suggested Products
                SliverToBoxAdapter(
                  child: suggestedAsync.when(
                    loading: () => const SuggestedProductsShimmer(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (products) => products.isEmpty
                        ? const SizedBox.shrink()
                        : SuggestedProductsSection(
                            products: products,
                            onProductTap: (product) {
                              context.pushRoute(
                                ProductDetailRoute(productId: product.id),
                              );
                            },
                          ),
                  ),
                ),

                // Bottom padding for action bar
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            ),

            // Bottom Action Bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BottomActionBar(
                isAvailable: product.isAvailable,
                onAddToCart: () => _addToCart(context, product),
                onBuyNow: () => _buyNow(context, product),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleWishlist(WidgetRef ref, ProductDetail product) {
    final isAuthenticated = ref.read(authStateProvider).isAuthenticated;
    if (!isAuthenticated) {
      // Show login prompt
      return;
    }
    ref.read(ProductDetailController.provider(productId).notifier).toggleWishlist();
  }

  void _shareProduct(ProductDetail product) {
    Share.share(
      'Check out ${product.name} on Nazaka!\nhttps://nazaka.app/products/${product.id}',
      subject: product.name,
    );
  }

  void _openFullscreenGallery(BuildContext context, ProductMedia media) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ImageGalleryFullscreen(images: media.allImages),
      ),
    );
  }

  void _navigateToSellerProfile(BuildContext context, String sellerId) {
    context.pushRoute(SellerProfileRoute(sellerId: sellerId));
  }

  void _addToCart(BuildContext context, ProductDetail product) {
    // TODO: Implement add to cart
  }

  void _buyNow(BuildContext context, ProductDetail product) {
    // TODO: Implement buy now - navigate to checkout
  }
}
```

### ImageGallery

```dart
class ImageGallery extends HookConsumerWidget {
  const ImageGallery({
    super.key,
    required this.images,
    this.onTap,
  });

  final List<String> images;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(ImageGalleryController.provider);
    final pageController = usePageController();

    return Column(
      children: [
        // Main Image
        GestureDetector(
          onTap: onTap,
          child: AspectRatio(
            aspectRatio: 1,
            child: PageView.builder(
              controller: pageController,
              itemCount: images.length,
              onPageChanged: (page) {
                ref.read(ImageGalleryController.provider.notifier).setPage(page);
              },
              itemBuilder: (context, index) {
                return Image.network(
                  images[index],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.image_outlined, size: 64),
                  ),
                );
              },
            ),
          ),
        ),

        // Page Indicator
        if (images.length > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              images.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == currentPage
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            ),
          ),
        ],

        // Thumbnails
        if (images.length > 1) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 60,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = index == currentPage;
                return GestureDetector(
                  onTap: () {
                    pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        images[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
```

### ProductDetailsSection

```dart
class ProductDetailsSection extends StatelessWidget {
  const ProductDetailsSection({
    super.key,
    required this.product,
  });

  final ProductDetail product;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product Details',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Condition
          _buildDetailRow(
            context,
            label: 'Condition',
            value: product.qualityStatus.name,
            trailing: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: product.qualityStatus.indicatorColor,
              ),
            ),
          ),

          // Size
          if (product.sizes != null)
            _buildDetailRow(
              context,
              label: 'Size',
              value: product.sizes!.displaySize,
            ),

          // Color
          if (product.color != null)
            _buildDetailRow(
              context,
              label: 'Color',
              value: product.color!.name,
              trailing: product.color!.color != null
                  ? Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: product.color!.color,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                    )
                  : null,
            ),

          // Designer/Brand
          if (product.brand != null)
            _buildDetailRow(
              context,
              label: 'Designer',
              value: product.brand!.name,
            ),

          // Style
          if (product.style != null)
            _buildDetailRow(
              context,
              label: 'Style',
              value: product.style!,
            ),

          // Country of Origin
          if (product.countryOfManufacture != null)
            _buildDetailRow(
              context,
              label: 'Country of Origin',
              value: product.countryOfManufacture!.name,
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required String value,
    Widget? trailing,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing,
              ],
            ],
          ),
        ],
      ),
    );
  }
}
```

### SellerSection

```dart
class SellerSection extends StatelessWidget {
  const SellerSection({
    super.key,
    required this.seller,
    this.onViewProfile,
  });

  final SellerSummary seller;
  final VoidCallback? onViewProfile;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Seller',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 28,
                backgroundImage: seller.avatarUrl != null
                    ? NetworkImage(seller.avatarUrl!)
                    : null,
                child: seller.avatarUrl == null
                    ? Text(seller.name[0].toUpperCase())
                    : null,
              ),
              const SizedBox(width: 16),

              // Seller Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      seller.name,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${seller.productCount} products listed',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      seller.memberSince,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // View Profile Button
              TextButton(
                onPressed: onViewProfile,
                child: const Text('View Profile'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

---

## Analytics Events

| Event | When | Properties |
|-------|------|------------|
| `product_viewed` | Product detail opened | `product_id`, `category_id`, `price` |
| `product_image_viewed` | Full-screen gallery opened | `product_id`, `image_index` |
| `product_shared` | Share button clicked | `product_id` |
| `wishlist_toggled` | Wishlist button clicked | `product_id`, `action` (add/remove) |
| `seller_profile_viewed` | View Profile clicked | `seller_id`, `product_id` |
| `suggested_product_tapped` | Suggested product clicked | `product_id`, `suggested_product_id` |
| `add_to_cart` | Add to Cart clicked | `product_id`, `price` |
| `buy_now` | Buy Now clicked | `product_id`, `price` |

---

## Checklist

- [ ] ProductDetail model created
- [ ] ProductMedia model created
- [ ] ProductSizes model created
- [ ] QualityStatus model created
- [ ] SellerSummary model created
- [ ] ProductReactions model created
- [ ] ProductApi extended with getProductDetail
- [ ] ProductApi extended with getSuggestedProducts
- [ ] ReactionApi implemented
- [ ] ProductDetailController with static provider
- [ ] SuggestedProductsController
- [ ] ImageGalleryController
- [ ] ProductDetailScreen implemented
- [ ] ImageGallery widget
- [ ] ImageGalleryFullscreen with pinch-to-zoom
- [ ] PriceSection widget
- [ ] ProductDetailsSection widget
- [ ] SellerSection widget
- [ ] SuggestedProductsSection widget
- [ ] BottomActionBar widget
- [ ] Loading shimmer states
- [ ] Error handling with retry
- [ ] Wishlist toggle with optimistic update
- [ ] Share functionality
- [ ] Out of stock state handling
- [ ] Analytics events
- [ ] Localization keys

---

## References

- [Product PRD](./prd.md) — Product requirements
- [Category Spec](/docs/features/category/spec.md) — Category feature spec
- [Home Spec](/docs/features/home/spec.md) — ProductCard widget reference
- [API Documentation](/docs/api.md) — Backend API reference
- [Agent Guidelines](/agent.md) — Architecture and coding standards
