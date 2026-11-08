/// Ringkasan rating yang dipakai bersama oleh "Komentar Penilaian Katalog Saya"
/// dan "Komentar Penilaian Katalog".
class ReviewSummaryModel {
  final double average;
  final int total;
  final int withPhotoCount;
  final int withMediaCount;
  final int withCommentCount;
  final int verifiedCount;
  final List<ReviewRatingDistribution> distribution;

  const ReviewSummaryModel({
    this.average = 0,
    this.total = 0,
    this.withPhotoCount = 0,
    this.withMediaCount = 0,
    this.withCommentCount = 0,
    this.verifiedCount = 0,
    this.distribution = const [],
  });

  factory ReviewSummaryModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ReviewSummaryModel();
    final distribution =
        (json['distribution'] as List?)
            ?.whereType<Map>()
            .map(
              (e) => ReviewRatingDistribution.fromJson(
                Map<String, dynamic>.from(e),
              ),
            )
            .toList() ??
        const [];

    return ReviewSummaryModel(
      average: (json['average'] as num?)?.toDouble() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      withPhotoCount: (json['with_photo_count'] as num?)?.toInt() ?? 0,
      withMediaCount:
          (json['with_media_count'] as num?)?.toInt() ??
          (json['with_photo_count'] as num?)?.toInt() ??
          0,
      withCommentCount: (json['with_comment_count'] as num?)?.toInt() ?? 0,
      verifiedCount: (json['verified_count'] as num?)?.toInt() ?? 0,
      distribution: distribution,
    );
  }
}

class ReviewRatingDistribution {
  final int star;
  final int count;
  final double percentage;

  const ReviewRatingDistribution({
    required this.star,
    required this.count,
    required this.percentage,
  });

  factory ReviewRatingDistribution.fromJson(Map<String, dynamic> json) {
    return ReviewRatingDistribution(
      star: (json['star'] as num?)?.toInt() ?? 0,
      count: (json['count'] as num?)?.toInt() ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0,
    );
  }
}

class ReviewPaginationModel {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final bool hasMorePages;

  const ReviewPaginationModel({
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 10,
    this.total = 0,
    this.hasMorePages = false,
  });

  factory ReviewPaginationModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ReviewPaginationModel();
    return ReviewPaginationModel(
      currentPage: (json['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (json['last_page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 10,
      total: (json['total'] as num?)?.toInt() ?? 0,
      hasMorePages: json['has_more_pages'] == true,
    );
  }
}

/// Halaman hasil review yang sudah diparse ke model typed.
class ReviewPage<T> {
  final List<T> items;
  final ReviewSummaryModel summary;
  final ReviewPaginationModel pagination;

  const ReviewPage({
    this.items = const [],
    this.summary = const ReviewSummaryModel(),
    this.pagination = const ReviewPaginationModel(),
  });

  bool get isEmpty => items.isEmpty;

  factory ReviewPage.fromResponse(
    Map<String, dynamic> response,
    T Function(Map<String, dynamic>) parseItem,
  ) {
    final data = response['data'] as List? ?? const [];
    return ReviewPage<T>(
      items: data
          .whereType<Map>()
          .map((e) => parseItem(Map<String, dynamic>.from(e)))
          .toList(),
      summary: ReviewSummaryModel.fromJson(
        response['summary'] is Map
            ? Map<String, dynamic>.from(response['summary'] as Map)
            : null,
      ),
      pagination: ReviewPaginationModel.fromJson(
        response['pagination'] is Map
            ? Map<String, dynamic>.from(response['pagination'] as Map)
            : null,
      ),
    );
  }
}
