import 'package:flutter/material.dart';

class ITextFormFieldTheme{
  ITextFormFieldTheme._();
  static InputDecorationTheme lightInputDecorationTheme(){
    return InputDecorationTheme(
      errorMaxLines: 3,
      prefixIconColor: Colors.grey,
      suffixIconColor: Colors.grey,
      labelStyle: const TextStyle().copyWith(fontSize: 14, color: Colors.black),
      hintStyle: const TextStyle().copyWith(fontSize:  14, color: Colors.black),
      floatingLabelStyle: const TextStyle().copyWith(color: Colors.black.withAlpha(100)),
      border: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(width: 1, color: Colors.grey),
      ),
        enabledBorder: const OutlineInputBorder().copyWith(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(width: 1, color: Colors.grey),
    ),
        focusedBorder: const OutlineInputBorder().copyWith(
          borderRadius: BorderRadius.circular(14),
          borderSide:  const BorderSide(width:  1 , color: Colors.black12),
        ),
        errorBorder: const OutlineInputBorder().copyWith(
          borderRadius: BorderRadius.circular(14),
          borderSide:  const BorderSide(width:  1 , color: Colors.red),
    ),
        focusedErrorBorder: const OutlineInputBorder().copyWith(
          borderRadius: BorderRadius.circular(14),
          borderSide:  const BorderSide(width:  1 , color: Colors.orange),
    )
    );
}
  static InputDecorationTheme darkInputDecorationTheme(){
    return InputDecorationTheme(
        errorMaxLines: 3,
        prefixIconColor: Colors.grey,
        suffixIconColor: Colors.grey,
        labelStyle: const TextStyle().copyWith(fontSize: 14, color: Colors.white),
        hintStyle: const TextStyle().copyWith(fontSize:  14, color: Colors.white),
        floatingLabelStyle: const TextStyle().copyWith(color: Colors.white.withAlpha(100)),
        border: const OutlineInputBorder().copyWith(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(width: 1, color: Colors.grey),
        ),
        enabledBorder: const OutlineInputBorder().copyWith(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(width: 1, color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder().copyWith(
          borderRadius: BorderRadius.circular(14),
          borderSide:  const BorderSide(width:  1 , color: Colors.white),
        ),
        errorBorder: const OutlineInputBorder().copyWith(
          borderRadius: BorderRadius.circular(14),
          borderSide:  const BorderSide(width:  1 , color: Colors.red),
        ),
        focusedErrorBorder: const OutlineInputBorder().copyWith(
          borderRadius: BorderRadius.circular(14),
          borderSide:  const BorderSide(width:  1 , color: Colors.orange),
        )
    );
  }
}