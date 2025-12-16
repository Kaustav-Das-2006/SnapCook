import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_animate/flutter_animate.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  File? _image;
  bool _isLoading = false;
  Map<String, dynamic>? _recipeData;
  final ImagePicker _picker = ImagePicker();

  // 1. Pick Image
  Future<void> _pickImage(ImageSource source) async {
    final XFile? photo = await _picker.pickImage(source: source);
    if (photo != null) {
      setState(() {
        _image = File(photo.path);
        _recipeData = null; // Reset previous recipe
      });
      _generateRecipe();
    }
  }

  // 2. Send to Backend
  Future<void> _generateRecipe() async {
    if (_image == null) return;

    setState(() => _isLoading = true);

    try {
      // NOTE: Use 10.0.2.2 for Android Emulator, localhost for iOS Simulator
      var uri = Uri.parse("http://10.0.2.2:8000/generate");

      var request = http.MultipartRequest('POST', uri);
      request.files.add(
        await http.MultipartFile.fromPath('file', _image!.path),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        setState(() {
          _recipeData = json.decode(responseData);
        });
      } else {
        _showError("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      _showError("Failed to connect. Is the backend running?");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("👨‍🍳 SnapCook AI")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Preview Area
            GestureDetector(
              onTap: () => _pickImage(ImageSource.camera),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                  image: _image != null
                      ? DecorationImage(
                          image: FileImage(_image!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: _image == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.camera_alt_rounded,
                            size: 50,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Tap to take photo",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            // Loading State
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ).animate().fadeIn()
            // Result State (Polished UI)
            else if (_recipeData != null)
              _buildRecipeCard(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _pickImage(ImageSource.gallery),
        label: const Text("Upload from Gallery"),
        icon: const Icon(Icons.photo_library),
      ),
    );
  }

  Widget _buildRecipeCard() {
    return Column(
      children: [
        // 1. Title Card
        Card(
          elevation: 0,
          color: Colors.deepOrange.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  _recipeData!['title'],
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.deepOrange.shade900,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _infoBadge(
                      Icons.timer_outlined,
                      _recipeData!['cooking_time'],
                    ),
                    _infoBadge(
                      Icons.restaurant_menu,
                      _recipeData!['difficulty'],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ).animate().slideY(begin: 0.2, end: 0).fadeIn(),

        const SizedBox(height: 20),

        // 2. Ingredients Section
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "🛒 Ingredients",
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        ...(_recipeData!['ingredients'] as List).map(
          (e) => Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
              ),
              title: Text(
                e,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // 3. Instructions Section
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "🔥 Instructions",
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        ...(_recipeData!['instructions'] as List).asMap().entries.map((entry) {
          int idx = entry.key + 1;
          String text = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.deepOrange,
                  child: Text(
                    "$idx",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _infoBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.deepOrange.shade100),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.deepOrange),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
