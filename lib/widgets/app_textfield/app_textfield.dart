import '../../config/app_config.dart';

class AppTextField extends StatefulWidget {
  final String? lableText;
  final String? hintText;
  final String tag;
  final double? height;
  final bool isAuth;
  final String img;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? suffixIcon;
  final bool? isDense;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final int? maxLength;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final Widget? prefixIcon;
  final TextAlign? textAlign;
  final Function()? onTap;
  final bool readOnly;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final bool showClearIcon;

  const AppTextField({
    super.key,
    required this.tag,
    this.lableText,
    this.hintText,
    this.height,
    this.isAuth = false,
    this.img = '',
    this.controller,
    this.focusNode,
    this.hintStyle,
    this.contentPadding,
    this.style,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.onChanged,
    this.validator,
    this.maxLength,
    this.color,
    this.textAlign,
    this.borderRadius,
    this.prefixIcon,
    this.onTap,
    this.readOnly = false,
    this.isDense,
    this.enabled = true,
    this.inputFormatters,
    this.showClearIcon = true,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late TextEditingController? _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    // Watch for changes to update the clear icon
    _controller?.addListener(_textChangeListener);
    _hasText = _controller?.text.isNotEmpty ?? false;
  }

  @override
  void dispose() {
    _controller?.removeListener(_textChangeListener);
    super.dispose();
  }

  void _textChangeListener() {
    if (_hasText != (_controller?.text.isNotEmpty ?? false)) {
      setState(() {
        _hasText = _controller?.text.isNotEmpty ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize the specific controller instance for this text field using 'tag'
    final TextFieldController textFieldCtrl = Get.put(
      TextFieldController()..setData(widget.obscureText),
      tag: widget.tag,
    );

    return GetBuilder<TextFieldController>(
      tag: widget.tag,
      builder: (controller1) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.color ?? AppColors.bgColor,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
              border: Border.all(
                color: controller1.validatorMsg != null
                    ? AppColors.redColor.withOpacity(0.6)
                    : AppColors.textColor1.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Center(
              child: TextFormField(
                controller: _controller,
                focusNode: widget.focusNode,
                keyboardType: widget.keyboardType ?? TextInputType.text,
                obscureText: controller1.isObscureText,
                obscuringCharacter: '•',
                maxLines: widget.maxLines,
                maxLength: widget.maxLength,
                onTap: widget.onTap,
                readOnly: widget.readOnly,
                enabled: widget.enabled,
                inputFormatters: widget.inputFormatters,
                textAlign: widget.textAlign ?? TextAlign.start,
                style: widget.style ??
                    TextStyle(
                      color: AppColors.textColor2.withOpacity(0.9),
                      fontSize: FontDimen.dimen13,
                      fontWeight: FontWeight.w500,
                      fontFamily: GoogleFonts.inter().fontFamily,
                    ),
                cursorColor: AppColors.primaryColor,
                validator: widget.validator,
                autovalidateMode: AutovalidateMode.disabled,
                onChanged: (value) {
                  if (widget.onChanged != null) {
                    widget.onChanged!(value);
                  }
                  if (widget.validator != null) {
                    final String? validationMsg = widget.validator!(value);
                    textFieldCtrl.setValidationMessage(validationMsg);
                  } else {
                    textFieldCtrl.setValidationMessage(null);
                  }
                  // Live update _hasText to show/hide clear icon
                  _textChangeListener();
                },
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: widget.hintStyle ??
                      TextStyle(
                        color: AppColors.textColor2.withOpacity(0.5),
                        fontSize: FontDimen.dimen13,
                        fontWeight: FontWeight.w400,
                        fontFamily: GoogleFonts.inter().fontFamily,
                      ),
                  prefixIcon: widget.prefixIcon,
                  suffixIcon: _buildSuffixIcon(controller1),
                  contentPadding: widget.contentPadding ??
                      const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  errorStyle: const TextStyle(
                    height: 0.01,
                    color: Colors.transparent,
                  ),
                  isDense: widget.isDense,
                  counterText: "",
                ),
              ),
            ),
          ),
          // --- External Error Message Display ---
          AnimatedOpacity(
            opacity: controller1.validatorMsg != null ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: controller1.validatorMsg != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 6.0, left: 12.0),
                    child: Text(
                      controller1.validatorMsg!,
                      style: TextStyle(
                        color: AppColors.redColor,
                        fontSize: FontDimen.dimen11,
                        fontWeight: FontWeight.w400,
                        fontFamily: GoogleFonts.inter().fontFamily,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  )
                : SizedBox(height: 6.0 + (FontDimen.dimen2 * 1.3) * 2),
          ),
        ],
      ),
    );
  }

  // Helper for password/clear/custom icon logic
  Widget? _buildSuffixIcon(TextFieldController controller1) {
    if (widget.obscureText) {
      // Password field: [clear][eye], both same size, same mainAxisAlignment/padding
      List<Widget> icons = [];

      // Show clear icon only if text & allowed
      if (widget.showClearIcon && _hasText) {
        icons.add(
          GestureDetector(
            onTap: () {
              _controller?.clear();
              if (widget.onChanged != null) {
                widget.onChanged!("");
              }
              _textChangeListener();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Icon(
                Icons.clear_rounded,
                color: AppColors.textColor2.withOpacity(0.7),
                size: AppDimens.dimen22,
              ),
            ),
          ),
        );
      }

      // Eye icon always
      icons.add(
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            controller1.isObscureText = !controller1.isObscureText;
            controller1.update();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: widget.showClearIcon && _hasText ? 14.0 : 14.0,
            ),
            child: Image.asset(
              controller1.isObscureText
                  ? AppImages.passwordHide
                  : AppImages.passwordShow,
              height: AppDimens.dimen26,
              width: AppDimens.dimen26,
              fit: BoxFit.contain,
              color: AppColors.textColor2.withOpacity(0.7),
            ),
          ),
        ),
      );

      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: icons,
      );
    }
    // Custom suffix
    if (widget.suffixIcon != null) {
      return widget.suffixIcon;
    }
    // Non-password, clear icon logic
    if (widget.showClearIcon && _hasText) {
      return GestureDetector(
        onTap: () {
          _controller?.clear();
          if (widget.onChanged != null) {
            widget.onChanged!("");
          }
          _textChangeListener();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Icon(
            Icons.clear_rounded,
            color: AppColors.textColor2.withOpacity(0.7),
            size: AppDimens.dimen22,
          ),
        ),
      );
    }
    return null;
  }
}
