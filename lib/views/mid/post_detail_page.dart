import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  bool isEditing = false;
  bool hasChanges = false;

  String initialName = 'The Future of AI in Art';
  String initialContent =
      'AI is transforming how we create and perceive art. From generative algorithms to neural style transfer, artists are finding new ways to innovate.';

  final nameController = TextEditingController();
  final contentController = TextEditingController();

  List<File?> imageFiles = List.generate(10, (_) => null);
  List<File?> initialImages = List.generate(10, (_) => null);

  final picker = ImagePicker();
  int _slotsCount() {
    final usedCount = imageFiles.where((file) => file != null).length;
    if (usedCount == 0) return 1; // at least 1 slot when empty
    return (usedCount + 1).clamp(0, 10);
  }

  @override
  void initState() {
    super.initState();
    nameController.text = initialName;
    contentController.text = initialContent;

    nameController.addListener(_checkForChanges);
    contentController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    final changed =
        nameController.text != initialName ||
        contentController.text != initialContent ||
        !_listEquals(imageFiles, initialImages);
    if (changed != hasChanges) {
      setState(() => hasChanges = changed);
    }
  }

  bool _listEquals(List<File?> a, List<File?> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i]?.path != b[i]?.path) return false;
    }
    return true;
  }

  void toggleEdit() {
    setState(() {
      if (isEditing && !hasChanges) {
        isEditing = false;
      } else {
        isEditing = !isEditing;
      }
    });
  }

  void applyChanges() {
    setState(() {
      initialName = nameController.text;
      initialContent = contentController.text;
      initialImages = List<File?>.from(imageFiles);
      hasChanges = false;
      isEditing = false;
    });
  }

  Future<void> pickImage(int index) async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        imageFiles[index] = File(picked.path);
        _checkForChanges();
      });
    }
  }

  void removeImage(int index) {
    setState(() {
      // Shift images to left after removed index
      for (int i = index; i < imageFiles.length - 1; i++) {
        imageFiles[i] = imageFiles[i + 1];
      }
      // Set last slot to null after shift
      imageFiles[imageFiles.length - 1] = null;

      _checkForChanges();
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Post Details',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.home, color: Colors.white70),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          isEditing ? Icons.close : Icons.edit,
                          color: Colors.cyanAccent,
                        ),
                        onPressed: toggleEdit,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Post Name
              TextField(
                controller: nameController,
                enabled: isEditing,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                decoration: _inputDecoration('Post Name'),
              ),
              const SizedBox(height: 16),

              // Post Content
              TextField(
                controller: contentController,
                enabled: isEditing,
                maxLines: 6,
                style: const TextStyle(color: Colors.white70),
                decoration: _inputDecoration('Post Content'),
              ),

              const SizedBox(height: 24),

              // Images
              const Text(
                'Images (10 slots)',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _slotsCount(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final file = index < imageFiles.length
                      ? imageFiles[index]
                      : null;

                  final isAddSlot = file == null && index == _slotsCount() - 1;

                  return Stack(
                    children: [
                      GestureDetector(
                        onTap: isEditing && isAddSlot
                            ? () => pickImage(index)
                            : isEditing && file != null
                            ? () => pickImage(index)
                            : null,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            border: Border.all(color: Colors.white30),
                            borderRadius: BorderRadius.circular(8),
                            image: file != null
                                ? DecorationImage(
                                    image: FileImage(file),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: file == null
                              ? Center(
                                  child: Icon(
                                    Icons.add_photo_alternate,
                                    color: Colors.white38,
                                    size: 28,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      if (isEditing && file != null)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.redAccent,
                            ),
                            padding: EdgeInsets.zero,
                            onPressed: () => removeImage(index),
                          ),
                        ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 30),

              // Apply Changes Button
              // Apply Changes Button (always visible when editing)
              if (isEditing)
                Center(
                  child: ElevatedButton.icon(
                    onPressed: hasChanges
                        ? applyChanges
                        : null, // disable if no changes
                    icon: const Icon(Icons.check),
                    label: const Text('Apply Changes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasChanges
                          ? Colors.cyan
                          : Colors.grey, // color change too
                      foregroundColor: hasChanges
                          ? Colors.black
                          : Colors.black38,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: Colors.white10,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white30),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
