import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tech_fun/components/HoverButton.dart';
import 'package:tech_fun/components/animated_gradient_dialog_content.dart';
import 'package:tech_fun/components/assetgallery.dart';
import 'package:tech_fun/components/commentsection.dart';
import 'package:tech_fun/components/hovericonbutton.dart';
import 'package:tech_fun/components/reactionbutton.dart';
import 'package:tech_fun/models/post_info.dart';
import 'package:url_launcher/url_launcher.dart';

class PostCard extends StatefulWidget {
  final VoidCallback onPressed;
  late PostInfo postInfo;
  PostCard({super.key, required this.postInfo, required this.onPressed});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late final ScrollController _listScrollController;
  final TextEditingController _commentController = TextEditingController();
  final ValueNotifier<List<String>> commentsNotifier = ValueNotifier([]);

  final List<List<Color>> gradientColors = [
    [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
    [Color(0xFF232526), Color(0xFF414345)],
    [Color(0xFF1D4350), Color(0xFFA43931)],
    [Color(0xFF141E30), Color(0xFF243B55)],
  ];

  int _currentGradientIndex = 0;
  bool hasLoad = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commentsNotifier.value = List.from(widget.postInfo.comments);

    _listScrollController = ScrollController();
    _startGradientLoop();
  }

  void _startGradientLoop() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 4));
      setState(() {
        _currentGradientIndex =
            (_currentGradientIndex + 1) % gradientColors.length;
      });
      return true;
    });
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    _commentController.dispose();

    super.dispose();
  }

  void _submitComment() {
    final text = _commentController.text.trim();
    if (text.isNotEmpty) {
      final updated = List<String>.from(commentsNotifier.value)..add(text);
      commentsNotifier.value = updated;

      setState(() {
        widget.postInfo.comments.add(text);
        widget.postInfo.commentTotal++;
      });
      _commentController.clear();

      // Scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _listScrollController.animateTo(
          _listScrollController.position.maxScrollExtent + 100,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedContainer(
        duration: const Duration(seconds: 2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors[_currentGradientIndex],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserHeader(context),
                const SizedBox(height: 8),
                Text(
                  widget.postInfo.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.postInfo.content,
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 10),
                AssetGallery(assetImagePaths: widget.postInfo.imageContent),
                const SizedBox(height: 8),
                _buildStatsRow(),
                const Divider(height: 24, color: Colors.white24),
                _buildReactionBar(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => {},
          child: CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(widget.postInfo.avatarUser),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => {},
          child: Text(
            widget.postInfo.nameUser,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          widget.postInfo.datePost,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const Spacer(),
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white70),
            onPressed: () => _showPostOptions(context),
          ),
        ),
      ],
    );
  }

  void _showPostOptions(BuildContext context) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Size screenSize = MediaQuery.of(context).size;
    final Offset offset = button.localToGlobal(Offset.zero);

    // Tính toán vị trí xuất hiện phù hợp để không sát mép phải
    const double menuWidth = 160; // Giả định chiều rộng menu
    double left = offset.dx;
    double right = screenSize.width - left - menuWidth;

    if (right < 16) {
      // Nếu sát mép phải thì dịch sang trái
      left = screenSize.width - menuWidth - 16;
    }

    final result = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(left, offset.dy + 40, 30, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFF1C1C1E),
      elevation: 12,
      items: [
        _buildHoverMenuItem(value: 'remove', label: '🗑️ Remove'),
        _buildHoverMenuItem(value: 'report', label: '🚩 Report'),
      ],
    );

    if (result == 'remove') {
      widget.onPressed();
    } else if (result == 'report') {
      _showReportForm();
    }
  }

  PopupMenuItem<String> _buildHoverMenuItem({
    required String value,
    required String label,
  }) {
    bool isHovered = false;

    return PopupMenuItem<String>(
      value: value,
      padding: EdgeInsets.zero,
      child: StatefulBuilder(
        builder: (context, setState) {
          return MouseRegion(
            onEnter: (_) => setState(() => isHovered = true),
            onExit: (_) => setState(() => isHovered = false),
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(value); // Trả về value khi click
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isHovered
                        ? Colors
                              .orange // Màu tech xanh dương hover
                        : Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showReportForm() {
    final TextEditingController _reasonController = TextEditingController();
    final gradientList = [
      [Color(0xFF0f0c29), Color(0xFF302b63)],
      [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
      [Color(0xFF1f4037), Color(0xFF99f2c8)],
    ];

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) {
        return Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 400),
            curve: Curves.easeOutBack,
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: AnimatedGradientDialogContent(
              reasonController: _reasonController,
              gradientList: gradientList,
              onSubmit: () {
                final reason = _reasonController.text.trim();
                if (reason.isNotEmpty) {
                  Navigator.pop(context);
                  _submitReport(reason);
                }
              },
              nameUser: widget.postInfo.nameUser,
            ),
          ),
        );
      },
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return TextField(
      cursorColor: const Color.fromARGB(255, 14, 167, 134),
      style: TextStyle(color: Colors.white),
      readOnly: true,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.white),
        hintStyle: TextStyle(color: Colors.white),
        labelText: label,
        border: OutlineInputBorder(),
      ),
      controller: TextEditingController(text: value),
    );
  }

  void _submitReport(String reason) {
    // Gửi lên server hoặc log ra
    print(
      'Report submitted:\nUser: ${widget.postInfo.nameUser}\nReason: $reason',
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Report submitted')));
  }

  Widget _buildImagePreview(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        image,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 200,
      ),
    );
  }

  Widget _buildReactionBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ReactionButton(
            emojiTotal: widget.postInfo.emojiTotal,
            onEmojiTotalChanged: (newTotal) {
              setState(() {
                widget.postInfo.emojiTotal = newTotal;
              });
            },
            currentIcon: widget.postInfo.currentIcon,
            onEmojiIconChanged: (String value) {
              setState(() {
                widget.postInfo.currentIcon = value;
              });
            },
          ),
        ),
        SizedBox(width: 4),
        Expanded(
          child: HoverIconButton(
            icon: Icons.comment_outlined,
            onPressed: () => _showCommentBottomSheet(context),
          ),
        ),
        SizedBox(width: 4),
        Expanded(
          child: HoverIconButton(
            icon: Icons.share_outlined,
            onPressed: () => _showShareOptions(),
          ),
        ),
      ],
    );
  }

  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1F2E), // Dark techy background
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildShareTile(
              icon: FontAwesomeIcons.facebook,
              label: "Facebook",
              color: Colors.blueAccent,
              onTap: _shareToFacebook,
            ),
            _buildShareTile(
              icon: FontAwesomeIcons.google,
              label: "Gmail",
              color: Colors.redAccent,
              onTap: _shareToGmail,
            ),
            _buildShareTile(
              icon: FontAwesomeIcons.microsoft,
              label: "Outlook",
              color: Colors.teal,
              onTap: _shareToOutlook,
            ),
            _buildShareTile(
              icon: Icons.chat_bubble,
              label: "Zalo",
              color: Colors.lightBlue,
              onTap: _shareToZalo,
            ),
            _buildShareTile(
              icon: FontAwesomeIcons.teamspeak,
              label: "Microsoft Teams",
              color: Colors.deepPurpleAccent,
              onTap: _shareToTeams,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: FaIcon(icon, color: color),
      title: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _shareToGmail() async {
    final subject = '${widget.postInfo.title} - ${widget.postInfo.nameUser}';
    final images = widget.postInfo.imageContent.join('\n');
    final body = '${widget.postInfo.content}\n\n$images';

    final uri = Uri(
      scheme: 'mailto',
      path: '',
      query:
          'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );

    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  void _shareToOutlook() => _shareToGmail(); // dùng mailto giống Gmail
  String _composeShareText() {
    final images = widget.postInfo.imageContent.join('\n');
    return '${widget.postInfo.title}\n${widget.postInfo.content}\n\n$images';
  }

  void _shareToFacebook() async {
    final content = _composeShareText();
    final fbUrl =
        'https://www.facebook.com/sharer/sharer.php?u=https://example.com&quote=${Uri.encodeComponent(content)}';
    if (await canLaunchUrl(Uri.parse(fbUrl))) launchUrl(Uri.parse(fbUrl));
  }

  void _shareToTeams() async {
    final content = _composeShareText();
    final teamsUrl =
        'https://teams.microsoft.com/share?msg=${Uri.encodeComponent(content)}';
    if (await canLaunchUrl(Uri.parse(teamsUrl))) launchUrl(Uri.parse(teamsUrl));
  }

  void _shareToZalo() async {
    final content = _composeShareText();
    final zaloUrl =
        'https://zalo.me/share?url=https://example.com&text=${Uri.encodeComponent(content)}';
    if (await canLaunchUrl(Uri.parse(zaloUrl))) launchUrl(Uri.parse(zaloUrl));
  }

  Widget _commentBottomSlider() {
    return CommentSection(
      commentsNotifier: commentsNotifier,
      scrollController: _listScrollController,
      commentController: _commentController,
      onSubmit: _submitComment,
    );
  }

  void _showCommentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // cho phép nội dung tràn
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (context, controller) => _commentBottomSlider(),
        );
      },
    );
  }

  Widget _buildStatsRow() {
    return Align(
      alignment: Alignment.centerRight, // ⬅️ Anchor to right
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.emoji_emotions, size: 18, color: Colors.orange),
          SizedBox(width: 4),
          Text(
            widget.postInfo.emojiTotal.toString(),
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 16),
          Icon(Icons.comment, size: 18, color: Colors.white70),
          SizedBox(width: 4),
          Text(
            widget.postInfo.commentTotal.toString(),
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 16),
          Icon(Icons.share, size: 18, color: Colors.white70),
          SizedBox(width: 4),
          Text(
            widget.postInfo.shareTotal.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
