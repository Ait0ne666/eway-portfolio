class TopPlace {
  final int id;
  final String address;
  final String city;
  final int count;

  TopPlace(
      {required this.id,
      required this.address,
      required this.city,
      required this.count});

  TopPlace copyWith({
    int? id,
    String? address,
    String? city,
    int? count,
  }) {
    return TopPlace(
      id: id ?? this.id,
      address: address ?? this.address,
      city: city ?? this.city,
      count:  count ?? this.count
    );
  }
}
