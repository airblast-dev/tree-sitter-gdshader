/** Our Vertext Shader */
// <- comment.documentation
void vertex() {
// <- type.builtin
//   ^ function
//         ^ punctuation.bracket
//          ^ punctuation.bracket
//            ^ punctuation.bracket
  float my_val = 2.3E-3;
//^^^^^ type.builtin
//      ^^^^^^ variable
//             ^ operator
//               ^^^^^^ number
//                     ^ punctuation.delimiter
  #if CURRENT_RENDERER == RENDERER_COMPATIBILITY
//^^^ keyword
//    ^^^^^^^^^^^^^^^^ constant.builtin
//                     ^^ operator
//                        ^^^^^^^^^^^^^^^^^^^^^^ constant.builtin
    // fma is not defined or something idk
//  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ comment
    myval = my_val * 2.0 + PI;
//  ^^^^^ variable
//        ^ operator
//          ^^^^^^ variable
//                 ^ operator
//                   ^^^ number
//                       ^ operator
//                         ^^ constant.builtin
  #else
//^^^^^ keyword
    // use fma for performance
    myval = fma(my_val, 2.0, PI);
//  ^^^^^ variable
//        ^ operator
//          ^^^ function.builtin
//             ^ punctuation.bracket
//              ^^^^^ variable
//                     ^^^ number
//                           ^^ constant.builtin
//                             ^ punctuation.bracket
  #endif
//^^^^^^ keyword

  for (;1 == 2, 2 == 3;) {
//^^^ keyword
//    ^ punctuation.bracket
//      ^ number
//        ^^ operator
//           ^ number
//            ^ operator
//              ^ number
//                ^^ operator
//                   ^ number
//                     ^ punctuation.bracket
    myval += 2.E-3;
//  ^^^^^ variable
//        ^^ operator
//           ^^^^^ number
    switch(myval) {
//  ^^^^^^ keyword
//        ^ punctuation.bracket
//         ^^^^^ variable
//              ^ punctuation.bracket
//                ^ punctuation.bracket
      case PI:
//    ^^^^ keyword
//         ^^ constant.builtin
        do_py_thing(myval);
//      ^^^^^^^^^^^ function
//                 ^ punctuation.bracket
//                  ^^^^^ variable
//                       ^ punctuation.bracket
      default:
//    ^^^^^^^ keyword
        fallback_thing(myval);
//      ^^^^^^^^^^^^^^ function
//                    ^ punctuation.bracket
//                     ^^^^^ variable
//                          ^ punctuation.bracket
	break;
    }
//  ^ punctuation.bracket
  }
//^ punctuation.bracket

  discard;
//^^^^^^^ keyword
  break;
//^^^^^ keyword
  continue;
//^^^^^^^^ keyword

do {
//<- keyword
// ^ punctuation.bracket
  #define IMPORTANTMACRO 1.E-3
//^^^^^^^ keyword
//        ^^^^^^^^^^^^^^ constant
  myval = IMPORTANTMACRO;
//^^^^^ variable
//      ^ operator
//        ^^^^^^^^^^^^^^ constant
  #undef IMPORTANTMACRO
//^^^^^^ keyword
//       ^^^^^^^^^^^^^^ constant
} while(myval <= 2.3);
// <- punctuation.bracket
//^^^^^ keyword
//     ^ punctuation.bracket
//      ^^^^^ variable
//            ^^ operator
//               ^^^ number
//                  ^ punctuation.bracket

const float PI_MULT_BY2 = PI * 2.;
// <- keyword
//    ^^^^^ type.builtin
//          ^^^^^^^^^^^ constant
//                      ^ operator
//                        ^^ constant.builtin
//                           ^ operator
//                             ^^ number
    myval *= PI_MULT_BY2;
//  ^^^^^ variable
//        ^^ operator
//           ^^^^^^^^^^^ constant
  while (myval < 0.) {\
//^^^^^ keyword
//      ^ punctuation.bracket
//       ^^^^^ variable
//             ^ operator
//               ^^ number
//                 ^ punctuation.bracket
//                   ^ punctuation.bracket
    do_something();
//  ^^^^^^^^^^^^ function
//              ^^ punctuation.bracket
    if (myval < -2.0) {
//  ^^ keyword
//     ^ punctuation.bracket
//      ^^^^^ variable
//            ^ operator
//              ^^^^ number
//                  ^ punctuation.bracket
//                    ^ punctuation.bracket
      break;
//    ^^^^^ keyword
//         ^ punctuation.delimiter
    } else if (myval < 1.0) {
//  ^ punctuation.bracket
//    ^^^^ keyword
//         ^^ keyword
//            ^ punctuation.bracket
//             ^^^^^ variable
//                   ^ operator
//                     ^^^ number
//                        ^ punctuation.bracket
//                          ^ punctuation.bracket
      continue;
//    ^^^^^^^^ keyword
//            ^ punctuation.delimiter
    } else {
//  ^ punctuation.bracket
//    ^^^^ keyword
//         ^ punctuation.bracket
      return;
//    ^^^^^^ keyword
//          ^ punctuation.delimiter
    }
//  ^ punctuation.bracket
  }
//^ punctuation.bracket
{
  float mynewval = PI;
//^^^^^ type.builtin
//      ^^^^^^^^ variable
//               ^ operator
//                 ^^ constant.builtin
//                   ^ punctuation.delimiter
  mynewval++--;
//^^^^^^^^ variable
//        ^^^^ operator
//            ^ punctuation.delimiter
  mynewval /= divide;
//^^^^^^^^ variable
//         ^^ operator
//            ^^^^^^ variable
//                  ^ punctuation.delimiter
}
myval.length();
//    ^^^^^^ function
}
// <- punctuation.bracket
