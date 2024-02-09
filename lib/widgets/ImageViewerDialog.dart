import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../model/PhotosResponse.dart';

class ImageViewerDialog extends StatelessWidget {
  final List<PhotosResponse> imageUrls;
  final int initialIndex;

  const ImageViewerDialog({super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 500, // Adjust the height to your preference
        child: PhotoViewGallery.builder(
          itemCount: imageUrls.length,
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              //imageProvider: NetworkImage("kmschool.observer.school/app23/uploads/2023-2024/CASA%20A/Mahataab%20Singh%20Mehtaab/20230817_134254000_iOS.jpg"/*imageUrls[index].imageurl.toString().replaceAll("file:///", "http://")*/),
              imageProvider: NetworkImage(imageUrls[index].imageurl.toString().replaceAll("file:///", "http://")),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
            );
          },
          scrollPhysics: const BouncingScrollPhysics(),
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          pageController: PageController(initialPage: initialIndex),
        ),
      ),
    );
  }
}
