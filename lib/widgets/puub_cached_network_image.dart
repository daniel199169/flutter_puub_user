import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PuubCachedNetworkImage extends StatelessWidget {
  final String imageURL;
  PuubCachedNetworkImage({this.imageURL});
  @override
  Widget build(BuildContext context) {
    
    return CachedNetworkImage(
      imageUrl: imageURL!=null?imageURL:'https://www/google.com',
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.fill,
          ),
        ),
      ),
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => Image.asset('assets/images/check.jpg',fit: BoxFit.fill,),
    );
  }
}
