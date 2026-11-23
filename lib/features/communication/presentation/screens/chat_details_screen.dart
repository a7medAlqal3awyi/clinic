import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../cubit/communication_cubit.dart';
import '../cubit/communication_state.dart';

class ChatDetailsScreen extends StatefulWidget {
  const ChatDetailsScreen({super.key});

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      _textController.clear();
      context.read<CommunicationCubit>().sendMessage(text: text);
      _scrollToBottom();
    }
  }

  Future<void> _pickFile() async {
    final files = await FilePicker.pickFiles();
    if (files.isNotEmpty) {
      final file = files.first;
      if (mounted) {
        context.read<CommunicationCubit>().sendMessage(
              text: 'Attached Document: ${file.name}',
              type: MessageType.file,
              attachmentName: file.name,
              attachmentPath: file.path,
            );
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'Dr. Sarah Mansour',
              style: AppTextStyles.headingSmall(context),
            ),
            Text(
              context.tr(AppStrings.online),
              style: TextStyle(
                fontSize: 10.sp,
                color: colors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Notice Banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
              color: colors.chipBackground,
              child: Text(
                context.tr(AppStrings.simulatedNotice),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: colors.primaryDark,
                ),
              ),
            ),
            Expanded(
              child: BlocConsumer<CommunicationCubit, CommunicationState>(
                listener: (context, state) {
                  if (state is CommunicationLoaded) {
                    _scrollToBottom();
                  }
                },
                builder: (context, state) {
                  if (state is CommunicationLoading) {
                    return StateViews.loading(context);
                  } else if (state is CommunicationLoaded) {
                    final messages = state.messages;
                    return ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      itemCount: messages.length + (state.isSpecialistTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == messages.length && state.isSpecialistTyping) {
                          return _buildTypingIndicator(context);
                        }
                        final msg = messages[index];
                        return _buildMessageBubble(context, msg);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            _buildChatInput(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(BuildContext context) {
    final colors = context.customColors;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: colors.border),
        ),
        child: Text(
          'Dr. Sarah is typing...',
          style: TextStyle(
            fontSize: 11.sp,
            fontStyle: FontStyle.italic,
            color: colors.textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, ChatMessageEntity msg) {
    final colors = context.customColors;
    final isMe = msg.sender == MessageSender.user;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h),
        constraints: BoxConstraints(maxWidth: 0.78.sw),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isMe ? colors.primary : colors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(isMe ? 16.r : 2.r),
            bottomRight: Radius.circular(isMe ? 2.r : 16.r),
          ),
          border: isMe ? null : Border.all(color: colors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (msg.type == MessageType.file) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.insert_drive_file, color: isMe ? Colors.white : colors.primary, size: 20.sp),
                  SizedBox(width: 6.w),
                  Flexible(
                    child: Text(
                      msg.attachmentName ?? 'Document',
                      style: TextStyle(
                        color: isMe ? Colors.white : colors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
            ],
            Text(
              msg.text,
              style: TextStyle(
                color: isMe ? Colors.white : colors.textPrimary,
                fontSize: 13.sp,
                height: 1.35,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${msg.timestamp.hour.toString().padLeft(2, '0')}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: isMe ? Colors.white70 : colors.textMuted,
                    fontSize: 9.sp,
                  ),
                ),
                if (isMe) ...[
                  SizedBox(width: 4.w),
                  Icon(Icons.done_all_rounded, size: 12.sp, color: Colors.white70),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatInput(BuildContext context) {
    final colors = context.customColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attach_file, color: colors.textSecondary, size: 22.sp),
            onPressed: _pickFile,
          ),
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: context.tr(AppStrings.typeMessage),
                hintStyle: AppTextStyles.bodyMedium(context).copyWith(
                  color: colors.textMuted,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send_rounded, color: colors.primary, size: 24.sp),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
