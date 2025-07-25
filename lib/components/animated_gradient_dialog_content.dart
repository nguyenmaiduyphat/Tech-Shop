import 'package:flutter/material.dart';
import 'package:tech_fun/components/HoverButton.dart';

class AnimatedGradientDialogContent extends StatefulWidget {
  final TextEditingController reasonController;
  final List<List<Color>> gradientList;
  final VoidCallback onSubmit;
  final String nameUser;

  const AnimatedGradientDialogContent({
    required this.reasonController,
    required this.gradientList,
    required this.onSubmit,
    required this.nameUser,
  });

  @override
  State<AnimatedGradientDialogContent> createState() =>
      AnimatedGradientDialogContentState();
}

class AnimatedGradientDialogContentState
    extends State<AnimatedGradientDialogContent> {
  int _currentGradientIndex = 0;

  @override
  void initState() {
    super.initState();
    _startGradientLoop();
  }

  void _startGradientLoop() {
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 5));
      if (!mounted) return false;
      setState(() {
        _currentGradientIndex =
            (_currentGradientIndex + 1) % widget.gradientList.length;
      });
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.gradientList[_currentGradientIndex];
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.transparent,
      child: AnimatedContainer(
        duration: Duration(seconds: 3),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Report Post',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            _buildReadOnlyField('User', widget.nameUser),
            const SizedBox(height: 8),
            _buildReadOnlyField(
              'Date',
              DateTime.now().toString().split('.')[0],
            ),
            const SizedBox(height: 8),
            TextField(
              cursorColor: const Color.fromARGB(255, 14, 167, 134),
              controller: widget.reasonController,
              decoration: InputDecoration(
                labelText: 'Reason',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyanAccent),
                ),
              ),
              maxLines: 3,
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                HoverButton(
                  label: 'Cancel',
                  color: Colors.grey.shade300,
                  hoverColor: Colors.grey.shade100,
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 12),
                HoverButton(
                  label: 'Submit',
                  color: Colors.cyanAccent,
                  hoverColor: Colors.tealAccent,
                  onPressed: widget.onSubmit,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return TextField(
      cursorColor: const Color.fromARGB(255, 14, 167, 134),
      style: TextStyle(color: Colors.white),
      readOnly: true,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.white),
        labelText: label,
        border: OutlineInputBorder(),
      ),
      controller: TextEditingController(text: value),
    );
  }
}
