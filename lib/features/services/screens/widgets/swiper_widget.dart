import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:finak/core/exports.dart';
import 'package:finak/core/widgets/network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class CustomDetailsSwiper extends StatefulWidget {
  final List<String> images;
  final String title;
  const CustomDetailsSwiper(
      {super.key, required this.images, required this.title});

  @override
  _CustomDetailsSwiperState createState() => _CustomDetailsSwiperState();
}

class _CustomDetailsSwiperState extends State<CustomDetailsSwiper> {
  final SwiperController _controller = SwiperController();
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;

  void _scrollToSelected() {
    if (_scrollController.hasClients) {
      double itemWidth = 50 + 10; // Adjust thumbnail width + padding
      double scrollTo = _currentIndex * itemWidth;

      _scrollController.animateTo(
        scrollTo,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.38,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Swiper(
            controller: _controller,
            itemCount: widget.images.length,
            onIndexChanged: (index) {
              setState(() {
                _currentIndex = index;
                _scrollToSelected(); // Scroll to selected thumbnail
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImageViewer(
                        images: widget.images,
                        initialIndex: index,
                      ),
                    ),
                  );
                },
                child: CustomNetworkImage(
                  image: widget.images[index],
                  // borderRadius: 10,
                ),
              );
            },
            layout: SwiperLayout.DEFAULT,
            loop: true,
            autoplayDelay: 6000,
            autoplay: true,
            // pagination: SwiperPagination(
            //   margin: EdgeInsets.only(
            //     bottom: MediaQuery.of(context).size.height * 0.32,
            //   ),
            //   builder: DotSwiperPaginationBuilder(
            //     activeColor: Colors.white,
            //     color: Colors.white.withOpacity(0.4),
            //   ),
            // ),
          ),
          PositionedDirectional(
            top: kToolbarHeight,
            start: 10,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
                10.w.horizontalSpace,
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: AutoSizeText(
                    widget.title,
                    maxLines: 1,
                    style: getBoldStyle(
                      fontSize: 20.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.07,
                minHeight: MediaQuery.of(context).size.height * 0.07,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SingleChildScrollView(
                  controller: _scrollController, // Attach scroll controller
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(widget.images.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          _controller.move(index);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 5),
                          child: Opacity(
                              opacity: _currentIndex == index ? 1 : 0.5,
                              child: CustomNetworkImage(
                                image: widget.images[index],
                                width: 70,
                                height: 50,
                                borderRadius: 10,
                              )),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   margin: EdgeInsets.only(right: 5.w),
//                   width: _currentIndex == index ? 20.w : 10.w,
//                   height: 10.w,
//                   decoration: BoxDecoration(
//                     color: _currentIndex == index
//                         ? Colors.white
//                         : Colors.white.withOpacity(.4),
//                     borderRadius: BorderRadius.circular(5.w),
//                   ),
//                 )

class FullScreenImageViewer extends StatelessWidget {
  final int initialIndex;
  final List<String> images;

  const FullScreenImageViewer({
    super.key,
    required this.initialIndex,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PhotoViewGallery.builder(
        itemCount: images.length,
        pageController: PageController(initialPage: initialIndex),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: CachedNetworkImageProvider(images[index]),
            heroAttributes: PhotoViewHeroAttributes(tag: images[index]),
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        loadingBuilder: (context, progress) {
          return Center(
            child: CircularProgressIndicator(
              value: progress == null || progress.expectedTotalBytes == null
                  ? null
                  : progress.cumulativeBytesLoaded /
                      progress.expectedTotalBytes!,
            ),
          );
        },
      ),
    );
  }
}
