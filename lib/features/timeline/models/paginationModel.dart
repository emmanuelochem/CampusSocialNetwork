class PaginationModel {
  int total;
  int nextPage;
  int totalPages;
  bool hasMore;
  int itemCount;
  List<dynamic> data;

  PaginationModel({
    this.itemCount = 0,
    this.hasMore = false,
    this.nextPage = 0,
    this.totalPages = 0,
    this.data = const [],
  }) {
    if (data.isNotEmpty) {
      data = data;
    } else {
      data = List.empty(growable: true);
    }
    itemCount = itemCount;
    hasMore = hasMore;
    nextPage = nextPage;
    totalPages = totalPages;
  }

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      itemCount: json["item_count"],
      hasMore: json['has_more'],
      nextPage: json['next_page'],
      totalPages: json["total_pages"],
      data: json['data'],
    );
  }
}
