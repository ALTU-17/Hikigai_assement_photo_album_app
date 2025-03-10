import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AppStateMange/imgPro.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  int _page = 1;
  int _limit = 20;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Provider.of<ImageProvider1>(context, listen: false).fetchImages(_page, _limit);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _page++;
      Provider.of<ImageProvider1>(context, listen: false).fetchImages(_page, _limit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search by Name or Number',
            border: InputBorder.none,
          ),
          onChanged: (query) {
            setState(() {});
          },
        )
            : Text('Hikigai Photo Album'),
        actions: [
          IconButton(
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(_isSearching ? Icons.close : Icons.image_search, size: 30),
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
          ),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Consumer<ImageProvider1>(
          builder: (context, imageProvider, child) {
            if (imageProvider.error.isNotEmpty) {
              // Show error message if API fails
              return Center(
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Failed to load images, please check your internet conecction.',
                      style: TextStyle(fontSize: 16, color: Colors.red,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            }

            final images = _isSearching
                ? imageProvider.searchImages(_searchController.text)
                : imageProvider.images;

            if (images.isEmpty && !imageProvider.isLoading) {
              // Show message if no data is available
              return Center(
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'No data available',
                      style: TextStyle(fontSize: 16, color: Colors.grey,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            }

            return GridView.builder(
              controller: _scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: images.length + (imageProvider.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < images.length) {
                  final image = images[index];
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      color: Colors.grey.shade300,
                      child: Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                image.url,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(image.title),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  // Show loading indicator at the bottom
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}