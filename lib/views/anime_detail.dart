import 'package:flutter/material.dart';
import '../network/base_network.dart'; // Assuming this path is correct

class DetailScreen extends StatefulWidget {
  final int id;
  final String endpoint;
  const DetailScreen({super.key, required this.id, required this.endpoint});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _detailData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDetailData();
  }

  Future<void> _fetchDetailData() async {
    try {
      final data = await BaseNetwork.getDetailData(widget.endpoint, widget.id);
      setState(() {
        _detailData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load data: $e";
        _isLoading = false;
      });
    }
  }

  // Helper function to extract image URL safely
  String _getImageUrl() {
    if (_detailData == null) return '';

    // Check for 'images' field first (common for character images in this API)
    if (_detailData!.containsKey('images') && _detailData!['images'] is List) {
      List images = _detailData!['images'];
      if (images.isNotEmpty && images[0] is String) {
        return images[0]; // Return the first image URL from the list
      }
    }

    // Fallback if 'images' is not found or empty, try 'image'
    if (_detailData!.containsKey('image')) {
      dynamic imageData = _detailData!['image'];
      if (imageData is String && imageData.isNotEmpty) {
        return imageData; // If 'image' is a direct string
      } else if (imageData is List &&
          imageData.isNotEmpty &&
          imageData[0] is String) {
        return imageData[0]; // If 'image' is a list
      }
    }

    return ''; // Return empty string if no valid image URL is found
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = _getImageUrl();

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Character")),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(child: Text("Error: $_errorMessage"))
              : _detailData != null
              ? SingleChildScrollView(
                // Use SingleChildScrollView for scrollability
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align text to start
                  children: [
                    // Display image
                    Center(
                      // Center the image
                      child:
                          imageUrl.isNotEmpty
                              ? Image.network(
                                imageUrl,
                                loadingBuilder: (
                                  BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress,
                                ) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                                errorBuilder:
                                    (context, error, stackTrace) => Container(
                                      width: 200,
                                      height: 200,
                                      color: Colors.grey[300],
                                      child: Icon(
                                        Icons.broken_image,
                                        size: 80,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                              )
                              : Container(
                                // Placeholder if no image URL is found
                                width: 200,
                                height: 200,
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 80,
                                  color: Colors.grey[700],
                                ),
                              ),
                    ),
                    const SizedBox(height: 20), // Add some spacing
                    // Display character details
                    Text(
                      "**Name:** ${_detailData!['name'] ?? 'Unknown'}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Access 'personal' field safely for nested data
                    Text(
                      "**Kekkei Genkai:** ${_detailData!['personal']?['kekkei_genkai'] ?? 'Empty'}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      "**Title:** ${_detailData!['personal']?['tittle'] ?? 'Empty'}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),

                    // Add more details as needed from _detailData
                    // Example: display affiliations if available
                    if (_detailData!.containsKey('affiliations') &&
                        _detailData!['affiliations'] is List)
                      Text(
                        "**Affiliations:** ${(_detailData!['affiliations'] as List).join(', ')}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    const SizedBox(height: 8),

                    if (_detailData!.containsKey('jutsu') &&
                        _detailData!['jutsu'] is List)
                      Text(
                        "**Jutsu:** ${(_detailData!['jutsu'] as List).join(', ')}",
                        style: const TextStyle(fontSize: 16),
                      ),
                  ],
                ),
              )
              : const Center(child: Text("No data available")),
    );
  }
}
