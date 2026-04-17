import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../widgets/rate_app_dialog.dart';

enum MessageType { user, ai, videoUploaded, analyzing }

class ChatMessage {
  final String id;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final List<String>? tips;

  ChatMessage({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
    this.tips,
  });
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isAnalyzing = false;
  bool _showVideoOptions = false;

  late AnimationController _typingController;
  late AnimationController _inputBarController;
  late Animation<Offset> _inputBarSlide;

  // Simulated AI tip sets for various scenarios
  static const List<List<String>> _tipSets = [
    [
      '🎯 Maintain eye contact with your audience at least 60–70% of the time to build trust and credibility.',
      '🗣️ Reduce filler words like "um", "uh", and "like" — pause instead to appear more composed.',
      '💪 Your posture was mostly upright; try keeping shoulders slightly back during key points.',
      '⏱️ Your pace averaged ~178 WPM — slightly high. Aim for 140–160 WPM for better comprehension.',
    ],
    [
      '✋ Your hand gestures were minimal. Use open palms when making key points to reinforce your message.',
      '🎭 Emotional range was good! Smiling during the opening creates an immediate rapport with your audience.',
      '📍 Try moving purposefully on stage — spatial positioning helps emphasize transitions between sections.',
      '🔊 Your vocal variety was limited in the middle section. Vary tone and pitch to re-engage attention.',
    ],
    [
      '⚡ Strong opening hook! The rhetorical question immediately drew the audience in.',
      '📊 When referencing data slides, turn back to the audience sooner — you spent 8+ seconds looking at the screen.',
      '🌟 Your confidence increased notably in the second half — great energy and momentum.',
      '🔁 The conclusion was abrupt. Add a clear call-to-action and a memorable closing statement.',
    ],
  ];

  static const List<String> _aiResponses = [
    "I've analyzed your presentation. Here are your personalized coaching insights:",
    "Great submission! After processing your video, I've identified some key areas to focus on:",
    "Analysis complete! Here's what I found from reviewing your presentation:",
  ];

  int _tipSetIndex = 0;

  @override
  void initState() {
    super.initState();
    _typingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
    _inputBarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
    _inputBarSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _inputBarController, curve: Curves.easeOutCubic),
    );

    // Add welcome message after a short delay
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        _addMessage(ChatMessage(
          id: DateTime.now().toString(),
          content:
              "👋 Hi there! I'm **Confidex AI**, your personal presentation coach.\n\nUpload a presentation video and I'll analyze your **body language**, **vocal delivery**, **pacing**, and **confidence** — then give you expert tips to help you shine on stage.",
          type: MessageType.ai,
          timestamp: DateTime.now(),
        ));
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _typingController.dispose();
    _inputBarController.dispose();
    super.dispose();
  }

  void _addMessage(ChatMessage msg) {
    setState(() => _messages.add(msg));
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    _textController.clear();

    _addMessage(ChatMessage(
      id: DateTime.now().toString(),
      content: text,
      type: MessageType.user,
      timestamp: DateTime.now(),
    ));

    // Simulated AI reply after short delay
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        _addMessage(ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content:
              "I can see you're interested in improving your presentation skills! To get personalized tips, please upload a presentation video using the 📎 button below. I'll analyze it and give you detailed coaching feedback.",
          type: MessageType.ai,
          timestamp: DateTime.now(),
        ));
      }
    });
  }

  void _simulateVideoUpload(String filename) {
    setState(() => _showVideoOptions = false);

    // User message - video uploaded
    _addMessage(ChatMessage(
      id: DateTime.now().toString(),
      content: filename,
      type: MessageType.videoUploaded,
      timestamp: DateTime.now(),
    ));

    // Analyzing state
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        _addMessage(ChatMessage(
          id: '${DateTime.now()}_analyzing',
          content: '',
          type: MessageType.analyzing,
          timestamp: DateTime.now(),
        ));
        setState(() => _isAnalyzing = true);
        _scrollToBottom();
      }
    });

    // AI response with tips
    Future.delayed(const Duration(milliseconds: 4000), () {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _messages.removeWhere((m) => m.type == MessageType.analyzing);
        });
        _addMessage(ChatMessage(
          id: '${DateTime.now()}_response',
          content: _aiResponses[_tipSetIndex % _aiResponses.length],
          type: MessageType.ai,
          timestamp: DateTime.now(),
          tips: _tipSets[_tipSetIndex % _tipSets.length],
        ));
        _tipSetIndex++;
        _scrollToBottom();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                if (_showVideoOptions) {
                  setState(() => _showVideoOptions = false);
                }
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                itemCount: _messages.length,
                itemBuilder: (_, i) {
                  final msg = _messages[i];
                  final showTime = i == 0 ||
                      _messages[i].timestamp
                              .difference(_messages[i - 1].timestamp)
                              .inMinutes >
                          5;
                  return Column(
                    children: [
                      if (showTime) _buildTimestamp(msg.timestamp),
                      _buildMessageBubble(msg, i),
                    ],
                  );
                },
              ),
            ),
          ),
          // Video options panel
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            child: _showVideoOptions
                ? _buildVideoOptionsPanel()
                : const SizedBox.shrink(),
          ),
          // Input bar
          SlideTransition(
            position: _inputBarSlide,
            child: _buildInputBar(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.videocam_rounded, color: Colors.white, size: 20),
        ),
      ),
      title: Column(
        children: [
          Text(
            'Confidex',
            style: GoogleFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                'AI Coach Online',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.success,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert_rounded, color: AppColors.textPrimary),
          color: AppColors.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          onSelected: (value) {
            if (value == 'rate') {
              RateAppDialog.show(context);
            } else if (value == 'new') {
              setState(() => _messages.clear());
              Future.delayed(const Duration(milliseconds: 300), () {
                if (mounted) {
                  _addMessage(ChatMessage(
                    id: DateTime.now().toString(),
                    content:
                        "👋 New session started! Upload a new presentation video whenever you're ready.",
                    type: MessageType.ai,
                    timestamp: DateTime.now(),
                  ));
                }
              });
            } else if (value == 'logout') {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            }
          },
          itemBuilder: (_) => [
            _buildMenuItem(
                'new', Icons.add_circle_outline_rounded, 'New Session'),
            _buildMenuItem(
                'rate', Icons.star_outline_rounded, 'Rate Confidex'),
            _buildMenuItem(
                'logout', Icons.logout_rounded, 'Sign Out'),
          ],
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(
      String value, IconData icon, String label) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 18),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimestamp(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final min = time.minute.toString().padLeft(2, '0');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        '$hour:$min',
        style: GoogleFonts.inter(
          fontSize: 11,
          color: AppColors.textHint,
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg, int index) {
    switch (msg.type) {
      case MessageType.user:
        return _UserBubble(message: msg, index: index);
      case MessageType.ai:
        return _AIBubble(message: msg, index: index);
      case MessageType.videoUploaded:
        return _VideoUploadBubble(message: msg, index: index);
      case MessageType.analyzing:
        return _AnalyzingBubble(controller: _typingController);
    }
  }

  Widget _buildVideoOptionsPanel() {
    final options = [
      ('Record Now', Icons.videocam_rounded, 'presentation_recording.mp4'),
      ('Choose from Library', Icons.video_library_rounded, 'my_pitch_deck.mp4'),
      ('Import from Drive', Icons.cloud_download_rounded, 'q4_presentation.mp4'),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Upload Presentation Video',
              style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          ...options.map((opt) => GestureDetector(
                onTap: () => _simulateVideoUpload(opt.$3),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(opt.$2, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 14),
                      Text(opt.$1,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          )),
                      const Spacer(),
                      const Icon(Icons.chevron_right_rounded,
                          color: AppColors.textHint, size: 18),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          12, 10, 12, MediaQuery.of(context).padding.bottom + 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.border, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Video attach button
          GestureDetector(
            onTap: () {
              setState(() => _showVideoOptions = !_showVideoOptions);
              FocusScope.of(context).unfocus();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: _showVideoOptions
                    ? AppColors.primaryGradient
                    : null,
                color: _showVideoOptions ? null : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(14),
                border: _showVideoOptions
                    ? null
                    : Border.all(color: AppColors.border),
              ),
              child: Icon(
                _showVideoOptions
                    ? Icons.close_rounded
                    : Icons.attach_file_rounded,
                color: _showVideoOptions
                    ? Colors.white
                    : AppColors.textSecondary,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Text field
          Expanded(
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _textController,
                style: GoogleFonts.inter(
                    color: AppColors.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Ask about your presentations...',
                  hintStyle: GoogleFonts.inter(
                      color: AppColors.textHint, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 13),
                  fillColor: Colors.transparent,
                  filled: true,
                ),
                onSubmitted: (_) => _sendMessage(),
                textInputAction: TextInputAction.send,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Send button
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentBlue.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.send_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// Message Bubble Widgets
// ─────────────────────────────────────────────────

class _UserBubble extends StatelessWidget {
  final ChatMessage message;
  final int index;

  const _UserBubble({required this.message, required this.index});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      builder: (_, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(
            offset: Offset(20 * (1 - v), 0), child: child),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                gradient: AppColors.userBubbleGradient,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Text(
                message.content,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.surfaceLight,
              child: const Icon(Icons.person_rounded,
                  color: AppColors.textSecondary, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _AIBubble extends StatelessWidget {
  final ChatMessage message;
  final int index;

  const _AIBubble({required this.message, required this.index});

  @override
  Widget build(BuildContext context) {
    // Parse **bold** text
    final hasTips = message.tips != null && message.tips!.isNotEmpty;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      builder: (_, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(
            offset: Offset(-20 * (1 - v), 0), child: child),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.auto_awesome_rounded,
                  color: Colors.white, size: 17),
            ),
            const SizedBox(width: 10),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18),
                      ),
                    ),
                    child: _buildBoldText(message.content),
                  ),
                  if (hasTips) ...[
                    const SizedBox(height: 8),
                    ...message.tips!.asMap().entries.map(
                          (e) => _TipCard(tip: e.value, index: e.key),
                        ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoldText(String text) {
    final parts = text.split('**');
    final spans = <TextSpan>[];
    for (var i = 0; i < parts.length; i++) {
      spans.add(TextSpan(
        text: parts[i],
        style: GoogleFonts.inter(
          color: i % 2 == 0 ? AppColors.textPrimary : AppColors.accentBlue,
          fontSize: 14,
          fontWeight: i % 2 == 0 ? FontWeight.w400 : FontWeight.w700,
          height: 1.6,
        ),
      ));
    }
    return RichText(text: TextSpan(children: spans));
  }
}

class _TipCard extends StatelessWidget {
  final String tip;
  final int index;

  const _TipCard({required this.tip, required this.index});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 350 + (index * 120)),
      curve: Curves.easeOutCubic,
      builder: (_, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(
            offset: Offset(0, 12 * (1 - v)), child: child),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.accentBlue.withOpacity(0.15),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 2),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                tip,
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoUploadBubble extends StatelessWidget {
  final ChatMessage message;
  final int index;

  const _VideoUploadBubble({required this.message, required this.index});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      builder: (_, v, child) => Opacity(opacity: v, child: child),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentBlue.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.play_circle_fill_rounded,
                        color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.content,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Video • Uploading...',
                          style: GoogleFonts.inter(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.surfaceLight,
              child: const Icon(Icons.person_rounded,
                  color: AppColors.textSecondary, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalyzingBubble extends StatelessWidget {
  final AnimationController controller;

  const _AnalyzingBubble({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.auto_awesome_rounded,
                color: Colors.white, size: 17),
          ),
          const SizedBox(width: 10),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShaderMask(
                      shaderCallback: (b) =>
                          AppColors.primaryGradient.createShader(b),
                      child: Text(
                        'Analyzing your video',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _DotsIndicator(controller: controller),
                  ],
                ),
                const SizedBox(height: 10),
                _buildProgressItems(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItems() {
    final items = [
      'Scanning body language',
      'Analyzing vocal delivery',
      'Measuring confidence signals',
      'Generating coaching tips',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .asMap()
          .entries
          .map((e) => TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 600 + (e.key * 400)),
                curve: Curves.easeOut,
                builder: (_, v, child) =>
                    Opacity(opacity: v, child: child),
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_rounded,
                          color: AppColors.accentBlue.withOpacity(0.7),
                          size: 14),
                      const SizedBox(width: 8),
                      Text(
                        e.value,
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  final AnimationController controller;

  const _DotsIndicator({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final progress = (controller.value * 3).floor();
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final active = i == progress % 3;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: active ? 8 : 5,
              height: active ? 8 : 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active
                    ? AppColors.accentBlue
                    : AppColors.accentBlue.withOpacity(0.3),
              ),
            );
          }),
        );
      },
    );
  }
}
