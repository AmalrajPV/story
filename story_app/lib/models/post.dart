import 'package:intl/intl.dart';

class Post {
  final String caption;
  final String image;
  final String date;
  final String? userProfileImage;
  final String username;

  Post({
    required this.caption,
    required this.image,
    required this.date,
    this.userProfileImage,
    required this.username,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    String backendDatetimeString = json['createdAt'];

    DateTime backendDatetime = DateTime.parse(backendDatetimeString);

    String formattedDatetime =
        DateFormat('dd/MM/yyyy h:mm a').format(backendDatetime);
    return Post(
      caption: json['caption'],
      image: json['imageUrl'],
      date: formattedDatetime,
      userProfileImage: json['uid']['image'],
      username: json['uid']['username'],
    );
  }
}
