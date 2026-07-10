// /Users/wac/Documents/wac projects/tsuite/lib/utils/common_widgets/common_text_form_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/res/styles/font_palette.dart';

class CommonTextFormField extends StatefulWidget {
  const CommonTextFormField({
    super.key,
    this.hintText = '',
    this.errorText,
    this.validator,
    this.isObscure = false,
    this.prefix,
    this.suffix,
    this.hintFontStyle,
    this.onChanged,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.autoFocus = false,
    this.showErrorText = true,
    this.controller,
    this.inputFormatters,
    this.prefixIcon,
    this.contentPadding,
    this.readOnly = false,
    this.style,
    this.inputType,
    this.onTap,
    this.focusNode,
    this.title,
    this.inputAction,
    this.onSubmitted,
    this.heightBetweenTitleAndTextField,
    this.titleColor,
    this.filledColor,
    this.height,
    this.cursorHeight,
    this.cursorWidth,
    this.showBorder = true,
    this.expands = false,
    this.ignorePointers,
    this.prefixIconConstraints,
    this.titleStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.suffixStackWidget,
    this.isLoading = false,
    this.loadingWidget,
    this.borderRadius,
    this.unfocusedBorderColor,
    this.cursorColor,
    this.focusColor,
    this.textCapitalization = TextCapitalization.none,
    this.enableSmoothRadius = true,
    this.onTapOutside,
  });

  final String hintText;
  final String? errorText;
  final String? Function(String?)? validator;
  final bool isObscure;
  final Widget? prefix;
  final Widget? suffix;
  final TextStyle? hintFontStyle;
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final int minLines;
  final int? maxLength;
  final bool autoFocus;
  final bool showErrorText;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final bool readOnly;
  final TextStyle? style;
  final TextInputType? inputType;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final String? title;
  final TextInputAction? inputAction;
  final ValueChanged<String>? onSubmitted;
  final double? heightBetweenTitleAndTextField;
  final Color? titleColor;
  final Color? filledColor;
  final double? height;
  final double? cursorHeight;
  final double? cursorWidth;
  final bool showBorder;
  final bool expands;
  final bool? ignorePointers;
  final BoxConstraints? prefixIconConstraints;
  final TextStyle? titleStyle;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final Widget? suffixStackWidget;
  final bool isLoading;
  final Widget? loadingWidget;
  final double? borderRadius;
  final Color? unfocusedBorderColor;
  final Color? cursorColor;
  final Color? focusColor;
  final TextCapitalization textCapitalization;
  final bool enableSmoothRadius;
  final TapRegionCallback? onTapOutside;

  @override
  State<CommonTextFormField> createState() => _CommonTextFormFieldState();
}

class _CommonTextFormFieldState extends State<CommonTextFormField> {
  FocusNode? _internalFocusNode;
  bool _isFocused = false;
  String? _localErrorText;

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _internalFocusNode!;

  @override
  void initState() {
    super.initState();
    _ensureFocusNode();
    _effectiveFocusNode.addListener(_handleFocusChange);
    _isFocused = _effectiveFocusNode.hasFocus;
  }

  @override
  void didUpdateWidget(covariant CommonTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode == widget.focusNode) {
      return;
    }

    final oldFocusNode = oldWidget.focusNode ?? _internalFocusNode;
    oldFocusNode?.removeListener(_handleFocusChange);

    if (oldWidget.focusNode == null && widget.focusNode != null) {
      _internalFocusNode?.dispose();
      _internalFocusNode = null;
    }

    _ensureFocusNode();
    _effectiveFocusNode.addListener(_handleFocusChange);
    _isFocused = _effectiveFocusNode.hasFocus;
  }

  void _ensureFocusNode() {
    _internalFocusNode ??= widget.focusNode == null ? FocusNode() : null;
  }

  void _handleFocusChange() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isFocused = _effectiveFocusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    final focusNode = widget.focusNode ?? _internalFocusNode;
    focusNode?.removeListener(_handleFocusChange);
    _internalFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final hasError = widget.errorText != null || _localErrorText != null;
    final borderColor = hasError
        ? colors.errorText
        : _isFocused
        ? widget.focusColor ?? colors.accent
        : widget.unfocusedBorderColor ?? colors.inputBorder;

    final effectiveSuffix = widget.isLoading
        ? widget.loadingWidget
        : widget.suffixStackWidget ?? widget.suffix;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          Text(
            widget.title!,
            style:
                widget.titleStyle ??
                FontPalette.base500(
                  14,
                  color: widget.titleColor ?? colors.primaryText,
                ),
          ),
          (widget.heightBetweenTitleAndTextField ?? 8.h).verticalSpace,
        ],
        SmoothContainer(
          height: widget.height,
          smoothness: widget.enableSmoothRadius ? 1 : 0,
          color: widget.filledColor ?? colors.inputBackground,
          borderRadius: BorderRadius.circular((widget.borderRadius ?? 100).r),
          side: widget.showBorder
              ? BorderSide(width: 1, color: borderColor)
              : BorderSide.none,
          child: TextFormField(
            controller: widget.controller,
            focusNode: _effectiveFocusNode,
            readOnly: widget.readOnly,
            obscureText: widget.isObscure,
            obscuringCharacter: '•',
            keyboardType: widget.inputType,
            textCapitalization: widget.textCapitalization,
            cursorWidth: widget.cursorWidth ?? 2.w,
            cursorHeight: widget.cursorHeight,
            cursorColor: widget.cursorColor ?? colors.primaryText,
            autocorrect: false,
            enableSuggestions: false,
            onChanged: (val) {
              if (_localErrorText != null) {
                setState(() {
                  _localErrorText = null;
                });
              }
              widget.onChanged?.call(val);
            },
            onFieldSubmitted: widget.onSubmitted,
            onTap: widget.onTap,
            onTapOutside: (event) {
              widget.onTapOutside?.call(event);
              FocusManager.instance.primaryFocus?.unfocus();
            },
            validator: (val) {
              final err = widget.validator?.call(val);
              if (_localErrorText != err) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _localErrorText = err;
                    });
                  }
                });
              }
              return err;
            },
            ignorePointers: widget.ignorePointers,
            inputFormatters: widget.inputFormatters,
            maxLength: widget.maxLength,
            minLines: widget.expands ? null : widget.minLines,
            maxLines: widget.expands ? null : widget.maxLines,
            autofocus: widget.autoFocus,
            textAlign: widget.textAlign,
            textAlignVertical:
                widget.textAlignVertical ?? TextAlignVertical.center,
            expands: widget.expands,
            textInputAction: widget.inputAction,
            style:
                widget.style ??
                FontPalette.base500(14, color: colors.primaryText),
            buildCounter:
                (
                  context, {
                  required currentLength,
                  required isFocused,
                  required maxLength,
                }) => null,
            decoration: InputDecoration(
              prefix: widget.prefix,
              prefixIcon: widget.prefixIcon,
              prefixIconConstraints: widget.prefixIconConstraints,
              suffixIcon: effectiveSuffix,
              hintText: widget.hintText,
              hintStyle:
                  widget.hintFontStyle ??
                  FontPalette.base400(14, color: colors.secondaryText),
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding:
                  widget.contentPadding ??
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              counterText: '',
              errorStyle: const TextStyle(
                fontSize: 0,
                height: 0,
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        if (widget.showErrorText &&
            (widget.errorText != null || _localErrorText != null)) ...[
          6.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              widget.errorText ?? _localErrorText ?? "",
              style: FontPalette.base400(12, color: colors.errorText),
            ),
          ),
        ],
      ],
    );
  }
}
