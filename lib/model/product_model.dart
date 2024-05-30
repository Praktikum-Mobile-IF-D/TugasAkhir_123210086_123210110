import 'package:hive/hive.dart';

part 'product_model.g.dart';

class ProductModel {
  final List<Products>? products;
  final int? total;
  final int? skip;
  final int? limit;

  ProductModel({
    this.products,
    this.total,
    this.skip,
    this.limit,
  });

  ProductModel.fromJson(Map<String, dynamic> json)
      : products = (json['products'] as List?)
            ?.map((dynamic e) => Products.fromJson(e as Map<String, dynamic>))
            .toList(),
        total = json['total'] as int?,
        skip = json['skip'] as int?,
        limit = json['limit'] as int?;

  Map<String, dynamic> toJson() => {
        'products': products?.map((e) => e.toJson()).toList(),
        'total': total,
        'skip': skip,
        'limit': limit
      };
}

@HiveType(typeId: 1)
class Products {
  @HiveField(0)
  List<Products>? cart;

  final int? id;
  final String? title;
  final String? description;
  final String? category;
  final double? price;
  final double? discountPercentage;
  final double? rating;
  final int? stock;
  final List<String>? tags;
  final String? brand;
  final String? sku;
  final int? weight;
  final Dimensions? dimensions;
  final String? warrantyInformation;
  final String? shippingInformation;
  final String? availabilityStatus;
  final List<Reviews>? reviews;
  final String? returnPolicy;
  final int? minimumOrderQuantity;
  final Meta? meta;
  final List<String>? images;
  final String? thumbnail;

  Products({
    this.id,
    this.title,
    this.description,
    this.category,
    this.price,
    this.discountPercentage,
    this.rating,
    this.stock,
    this.tags,
    this.brand,
    this.sku,
    this.weight,
    this.dimensions,
    this.warrantyInformation,
    this.shippingInformation,
    this.availabilityStatus,
    this.reviews,
    this.returnPolicy,
    this.minimumOrderQuantity,
    this.meta,
    this.images,
    this.thumbnail,
  });

  Products.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        title = json['title'] as String?,
        description = json['description'] as String?,
        category = json['category'] as String?,
        price = json['price'] as double?,
        discountPercentage = json['discountPercentage'] as double?,
        rating = json['rating'] as double?,
        stock = json['stock'] as int?,
        tags =
            (json['tags'] as List?)?.map((dynamic e) => e as String).toList(),
        brand = json['brand'] as String?,
        sku = json['sku'] as String?,
        weight = json['weight'] as int?,
        dimensions = (json['dimensions'] as Map<String, dynamic>?) != null
            ? Dimensions.fromJson(json['dimensions'] as Map<String, dynamic>)
            : null,
        warrantyInformation = json['warrantyInformation'] as String?,
        shippingInformation = json['shippingInformation'] as String?,
        availabilityStatus = json['availabilityStatus'] as String?,
        reviews = (json['reviews'] as List?)
            ?.map((dynamic e) => Reviews.fromJson(e as Map<String, dynamic>))
            .toList(),
        returnPolicy = json['returnPolicy'] as String?,
        minimumOrderQuantity = json['minimumOrderQuantity'] as int?,
        meta = (json['meta'] as Map<String, dynamic>?) != null
            ? Meta.fromJson(json['meta'] as Map<String, dynamic>)
            : null,
        images =
            (json['images'] as List?)?.map((dynamic e) => e as String).toList(),
        thumbnail = json['thumbnail'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'price': price,
        'discountPercentage': discountPercentage,
        'rating': rating,
        'stock': stock,
        'tags': tags,
        'brand': brand,
        'sku': sku,
        'weight': weight,
        'dimensions': dimensions?.toJson(),
        'warrantyInformation': warrantyInformation,
        'shippingInformation': shippingInformation,
        'availabilityStatus': availabilityStatus,
        'reviews': reviews?.map((e) => e.toJson()).toList(),
        'returnPolicy': returnPolicy,
        'minimumOrderQuantity': minimumOrderQuantity,
        'meta': meta?.toJson(),
        'images': images,
        'thumbnail': thumbnail
      };
}

class Dimensions {
  final double? width;
  final double? height;
  final double? depth;

  Dimensions({
    this.width,
    this.height,
    this.depth,
  });

  Dimensions.fromJson(Map<String, dynamic> json)
      : width = json['width'] as double?,
        height = json['height'] as double?,
        depth = json['depth'] as double?;

  Map<String, dynamic> toJson() =>
      {'width': width, 'height': height, 'depth': depth};
}

class Reviews {
  final int? rating;
  final String? comment;
  final String? date;
  final String? reviewerName;
  final String? reviewerEmail;

  Reviews({
    this.rating,
    this.comment,
    this.date,
    this.reviewerName,
    this.reviewerEmail,
  });

  Reviews.fromJson(Map<String, dynamic> json)
      : rating = json['rating'] as int?,
        comment = json['comment'] as String?,
        date = json['date'] as String?,
        reviewerName = json['reviewerName'] as String?,
        reviewerEmail = json['reviewerEmail'] as String?;

  Map<String, dynamic> toJson() => {
        'rating': rating,
        'comment': comment,
        'date': date,
        'reviewerName': reviewerName,
        'reviewerEmail': reviewerEmail
      };
}

class Meta {
  final String? createdAt;
  final String? updatedAt;
  final String? barcode;
  final String? qrCode;

  Meta({
    this.createdAt,
    this.updatedAt,
    this.barcode,
    this.qrCode,
  });

  Meta.fromJson(Map<String, dynamic> json)
      : createdAt = json['createdAt'] as String?,
        updatedAt = json['updatedAt'] as String?,
        barcode = json['barcode'] as String?,
        qrCode = json['qrCode'] as String?;

  Map<String, dynamic> toJson() => {
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'barcode': barcode,
        'qrCode': qrCode
      };
}
