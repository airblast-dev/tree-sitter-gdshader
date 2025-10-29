int a = 1;
// <- type.builtin
//  ^ variable
//    ^ operator
//      ^ number
const int a = 1;
// <- keyword
//     ^ type.builtin
//        ^ variable
//          ^ operator
//            ^ number
uniform int a = 1;
// <- keyword
//      ^ type.builtin
//          ^ variable
//            ^ operator
//              ^ number
uniform float a: color_source, other_hint = 1.0;
// <- keyword
//      ^^^^^ type.builtin
//            ^ variable
//               ^^^^^^^^^^^^ attribute
//                             ^^^^^^^^^^ attribute
//                                        ^ operator
//                                          ^^^ number
//                                             ^ punctuation.delimiter
varying smooth int a = 1;
// <- keyword
//      ^ keyword
//             ^ type.builtin
//                 ^ variable
//                   ^ operator
//                     ^ number
void myfunc(mytype a, inout othertype b, out float c, in lowp float d[n + 0XDEADBEEF]) {}
// <- type.builtin
//   ^ function
//         ^ punctuation.bracket
//          ^ type
//                 ^ variable.parameter
//                    ^ keyword 
//                          ^ type
//                                    ^ variable.parameter
//                                       ^ keyword
//                                           ^ type.builtin
//                                                 ^ variable.parameter
//                                                    ^ keyword
//                                                       ^ keyword
//                                                            ^ type.builtin
//                                                                  ^ variable.parameter
//                                                                   ^ punctuation.bracket
//                                                                    ^ variable
//                                                                      ^ operator
//                                                                        ^ number
//                                                                                  ^ punctuation.bracket
//                                                                                   ^ punctuation.bracket

/** Some important shader struct*/
// <- comment.documentation
struct Asd {
// <- keyword
//     ^ type
//         ^ punctuation.bracket
  mytype myfield;
// ^ type
//       ^ variable.member
//              ^ punctuation.delimiter
  int otherfield;
// ^ type.builtin 
//    ^ variable.member
//              ^ punctuation.delimiter
  sometype otherotherfield[MACRO];
// ^ type
//         ^ variable.member
//                        ^ punctuation.bracket
//                         ^ constant
//                              ^ punctuation.bracket
//                               ^ punctuation.delimiter
   };
// ^ punctuation.bracket
//  ^ punctuation.delimiter




uniform lowp int MyColor[3]: color_source = {1, 2, 3};
// <- keyword
//      ^ keyword
//           ^ type.builtin
//               ^ variable
//                      ^ punctuation.bracket
//                       ^ number
//                        ^ punctuation.bracket
//                         ^ operator
//                           ^ attribute
//                                        ^ operator
//                                          ^ punctuation.bracket
//                                           ^ number
//                                              ^ number
//                                                 ^ number
//                                                  ^ punctuation.bracket
//                                                   ^ punctuation.delimiter
int a, b = 0xFFFF, c[x + y + 1.0E-1F];
// <- type.builtin
//  ^ variable
//     ^ variable
//       ^ operator
//         ^ number
//                 ^ variable
//                  ^ punctuation.bracket
//                   ^ variable
//                     ^ operator
//                       ^ variable
//                         ^ operator
//                           ^ number
//                                  ^ punctuation.bracket
//                                   ^ punctuation.delimiter
