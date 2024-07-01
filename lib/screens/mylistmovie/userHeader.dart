import 'package:flutter/material.dart';
import 'package:xemphim/common/AvatarManager.dart';

class UserHeader extends StatelessWidget {
  final String userName;

  const UserHeader({
    Key? key,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ValueListenableBuilder<String>(
          valueListenable: AvtManager.avatarUrlNotifier,
          builder: (context, avatarUrl, child) {
            return CircleAvatar(
              backgroundImage: avatarUrl.isNotEmpty
                  ? NetworkImage(avatarUrl)
                  : const AssetImage('assets/default_avatar.png') as ImageProvider,
              radius: 30, // Tăng kích thước avatar
            );
          },
        ),
        const SizedBox(height: 12), // Tăng khoảng cách giữa avatar và tên
        Text(
          userName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24, // Tăng kích thước chữ
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
