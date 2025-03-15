import 'package:card_swiper/card_swiper.dart';
import 'package:finak/core/exports.dart';
import 'package:finak/core/widgets/network_image.dart';

class CustomSwiper extends StatefulWidget {
  final double? height;
  final List<String> images;
  const CustomSwiper({
    super.key,
    this.height,
    required this.images,
  });
//
  @override
  _CustomSwiperState createState() => _CustomSwiperState();
}

class _CustomSwiperState extends State<CustomSwiper> {
  final SwiperController _controller = SwiperController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // var cubit = context.read<ResidenceCubit>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          SizedBox(
            height: widget.height ?? getHeightSize(context) * 0.2,
            width: getWidthSize(context),
            child: Swiper(
              controller: _controller,
              itemCount: widget.images.length,
              onIndexChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => FullScreenImageViewer(
                    //       initialIndex: index,
                    //       images: widget.images,
                    //     ),
                    //   ),
                    // );
                  },
                  child: CustomNetworkImage(
                    image: widget.images[index],
                    fit: BoxFit.cover,
                    borderRadius: 20.r,
                  ),
                );
              },
              layout: SwiperLayout.DEFAULT,
              loop: true,
              autoplayDelay: 6000,
              autoplay: true,

              // itemWidth: MediaQuery.of(context).size.width * 0.8,
              // itemHeight: 200.0,
            ),
          ),
          const SizedBox(height: 10), // Space between Swiper and pagination
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.images.length,
              (index) => AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentIndex == index ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? Colors.blue
                      : Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class FullScreenImageViewer extends StatelessWidget {
//   final int initialIndex;
//   final List<String> images;

//   const FullScreenImageViewer({
//     super.key,
//     required this.initialIndex,
//     required this.images,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: PhotoViewGallery.builder(
//         itemCount: images.length,
//         pageController: PageController(initialPage: initialIndex),
//         builder: (BuildContext context, int index) {
//           return PhotoViewGalleryPageOptions(
//             imageProvider: CachedNetworkImageProvider(images[index]),
//             heroAttributes: PhotoViewHeroAttributes(tag: images[index]),
//           );
//         },
//         scrollPhysics: const BouncingScrollPhysics(),
//         backgroundDecoration: const BoxDecoration(color: Colors.black),
//         loadingBuilder: (context, progress) {
//           return Center(
//             child: CircularProgressIndicator(
//               value: progress == null || progress.expectedTotalBytes == null
//                   ? null
//                   : progress.cumulativeBytesLoaded /
//                       progress.expectedTotalBytes!,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
