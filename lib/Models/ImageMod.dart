

class ImageModel {
  final String id;
  final String url;
  final String title;

  ImageModel({
    required this.id,
    required this.url,
    required this.title,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'].toString(),
      url: json['download_url'],
      title: 'Image ${json['id']}', // Example title
    );
  }
}