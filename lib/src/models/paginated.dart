import 'dart:convert';

class Paginated<T> {
  final currentPage;
  final List<T> data;
  final firstPageUrl;
  final from;
  final lastPage;
  final lastPageUrl;
  final nextPageUrl;
  final path;
  final perPage;
  final prevPageUrl;
  final to;
  final total;

  Paginated({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory Paginated.fromJson(Map<String, dynamic> json, listItemConstruct) {
    List<T> items = [];

    print(json["data"].length);
    for (int i = 0; i < json["data"].length; i++) {
      items.add(listItemConstruct(json["data"][i]));
    }
    return new Paginated<T>(
      currentPage: json["current_page"] ?? "",
      data: items,
      firstPageUrl: json["first_page_url"] ?? "",
      from: json["from"] ?? "",
      lastPage: json["last_page"] ?? "",
      lastPageUrl: json["last_page_url"] ?? "",
      nextPageUrl: json["next_page_url"] ?? "",
      path: json["path"] ?? "",
      perPage: json["per_page"] ?? "",
      prevPageUrl: json["prev_page"] ?? "",
      to: json["to"] ?? "",
      total: json["total"] ?? "",
    );
  }

  List<T> get getData => data;
}
