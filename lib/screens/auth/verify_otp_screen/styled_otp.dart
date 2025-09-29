import '../../../config/app_config.dart';

class StyledOtpInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VerifyOTPController verifyOtpController;
  final int index;
  final int otpLength;

  const StyledOtpInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.verifyOtpController,
    required this.index,
    this.otpLength = 5,
  });

  @override
  _StyledOtpInputState createState() => _StyledOtpInputState();
}

class _StyledOtpInputState extends State<StyledOtpInput> {
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    isFocused = widget.focusNode.hasFocus;
    widget.focusNode.addListener(_focusListener);

    // Select text immediately if it starts focused with content.
    if (isFocused && widget.controller.text.isNotEmpty) {
      _selectText();
    }
  }

  // Updates the focus state and selects text if focus is gained on a non-empty field.
  void _focusListener() {
    if (mounted) {
      final currentFocus = widget.focusNode.hasFocus;
      setState(() {
        isFocused = currentFocus;
      });

      // Select existing text on focus gain to allow easy replacement.
      if (currentFocus && widget.controller.text.isNotEmpty) {
        _selectText();
      }
    }
  }

  // Selects the text in the field, scheduled after the frame build.
  void _selectText() {
    // Use addPostFrameCallback to ensure the field is ready for selection changes.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.controller.text.isNotEmpty) {
        widget.controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: widget.controller.text.length,
        );
      }
    });
  }

  // Handles backspace specifically when the field is already empty.
  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      // Move focus backward if backspace is pressed on an empty field (and it's not the first field).
      if (widget.controller.text.isEmpty && widget.index > 0) {
        FocusScope.of(context).requestFocus(
          widget.verifyOtpController.focusNodes[widget.index - 1],
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // RawKeyboardListener catches backspace on empty field before TextField does.
    return RawKeyboardListener(
      focusNode: FocusNode(
          debugLabel: 'RawKeyboardListener Focus Node ${widget.index}'),
      onKey: _handleKeyEvent,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque, // Make entire area tappable
        onTap: () {
          if (!widget.focusNode.hasFocus) {
            FocusScope.of(context).requestFocus(widget.focusNode);
          } else {
            // Re-select text if already focused and tapped again.
            if (widget.controller.text.isNotEmpty) {
              _selectText();
            }
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Dotted border appears only when focused.
            DottedBorder(
              color: isFocused ? AppColors.primaryColor : AppColors.transparent,
              strokeWidth: 2,
              borderType: BorderType.RRect,
              radius: Radius.circular(AppDimens.dimen18),
              dashPattern: const [1, 0],
              padding: EdgeInsets.zero,
              child: Container(
                height: AppDimens.dimen75,
                width: AppDimens.dimen75 + 3,
                decoration: BoxDecoration(
                  color: AppColors.bgColor,
                  borderRadius: BorderRadius.circular(AppDimens.dimen18),
                  // Solid border shown only when *not* focused.
                  border: !isFocused
                      ? Border.all(
                          color: AppColors.bgColor.withOpacity(1),
                          width: 1.5,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textColor1.withOpacity(0.05),
                      spreadRadius: 1,
                      blurRadius: 15,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: TextField(
                  focusNode: widget.focusNode,
                  controller: widget.controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  cursorColor: AppColors.primaryColor,
                  style: TextStyle(
                    color: AppColors.textColor3.withOpacity(1),
                    fontSize: AppDimens.dimen20,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.inter().fontFamily,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    counterText: '', // Hide the maxLength counter
                  ),
                  onChanged: (value) {
                    // Move focus forward or backward based on input/deletion.
                    if (value.isNotEmpty) {
                      if (widget.index < widget.otpLength - 1) {
                        FocusScope.of(context).requestFocus(
                          widget
                              .verifyOtpController.focusNodes[widget.index + 1],
                        );
                      } else {
                        widget.focusNode.unfocus(); // Last digit entered
                      }
                    }
                    // Backspace clearing the field
                    else if (value.isEmpty && widget.index > 0) {
                      FocusScope.of(context).requestFocus(
                        widget.verifyOtpController.focusNodes[widget.index - 1],
                      );
                    }
                  },
                ),
              ),
            ),
            // Positioned(
            //   bottom: 10,
            //   child: Container(
            //     width: AppDimens.dimen15,
            //     height: 2,
            //     color: isFocused
            //         ? AppColors.primaryColor
            //         : AppColors.textColor1.withOpacity(1),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the focus listener to prevent memory leaks.
    widget.focusNode.removeListener(_focusListener);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.focusNode.removeListener(_focusListener);
    widget.focusNode.addListener(_focusListener);
  }
}
