; highlights.scm

["uniform" "const" "varying" "render_mode" "shader_type"
 "return" "while" "do" "break" "continue"
 "if" "else" "switch" "case" "struct" "for"] @keyword
(parameter_qualifier) @keyword
(interpolation_specifier) @keyword
(precision_specifier) @keyword
(identifier) @variable
(struct_definition name: (identifier) @type)

(preproc . _ @keyword . (_))
(preproc_define_func name: (identifier) @function)
(preproc_include path: (_) @string)
(preproc_undef argument: (identifier) @constant)
(comment) @comment
[
  ";"
  "."
] @punctuation.delimiter
[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket
[
  "="
  "-"
  "*"
  "/"
  "+"
  "%"
  "~"
  "|"
  "&"
  "^"
  "<<"
  ">>"
  "<"
  "<="
  ">="
  ">"
  "=="
  "!="
  "!"
  "&&"
  "||"
  "-="
  "+="
  "*="
  "/="
  "%="
  "|="
  "&="
  "^="
  ">>="
  "<<="
  "--"
  "++"
  "?"
  ":"
] @operator

(primitive_type) @type.builtin
(type_identifier) @type
(number) @number
(bool) @boolean

(case_statement
  value: (identifier) @constant)


(parameter_declaration
      declarator: [ (identifier) @variable.parameter (array_declarator declarator: (identifier) @variable.parameter)])

(function_definition
  declarator: (identifier) @function)

(field_expression field: (_) @property)

(call_expression
  function: (identifier)
  arguments: (argument_list
    (identifier)? @variable
  )
) @function

(
 (call_expression
  function: (identifier) @function.builtin
 )
 (#any-of? @function.builtin
  ; taken from: https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/shader_functions.html
  ; trigonometric builtins
  "radians" "degrees" "sin" "cos" "tan" 
  "asin" "acos" "atan" "sinh" "cosh" "tanh" 
  "asinh" "acosh" "atanh"
  ; exponential and math builtins
  "pow" "exp" "exp2" "log" "log2" "sqrt" "inversesqrt"
  "abs" "sign" "floor" "round" "roundEven" "trunc" "ceil" 
  "fract" "mod" "modf" "min" "max" "clamp" "mix" "fma"
  "step" "smoothstep" "isnan" "isinf" "floatBitsToInt" 
  "floatBitsToUint" "intBitsToFloat" "uintBitsToFloat"
  ; geometric builtins
  "length" "distance" "dot" "cross" "normalize" "reflect"
  "refract" "faceforward" "matrixCompMult" "outerProduct"
  "transpose" "determinant" "inverse"
  ; comparison builtins
  "lessThan" "greaterThan" "lessThanEqual" "equal" "notEqual" "any" "all" "not"
  ; texture builtins
  "textureSize" "textureQueryLod" "textureQueryLevels" "texture" "textureProj"
  "textureLod" "textureProjLod" "textureGrad" "textureProjGrad" "texelFetch"
  "textureGather" "dFdx" "dFdxCoarse" "dFdxFine" "dFdy" "dFdyCoarse" "dFdyFine"
  "fwidth" "fwidthCoarse" "fwidthFine"
  ; packing unpacking builtins
  "packHalf2x16" "unpackHalf2x16" 
  "packUnorm2x16" "unpackUnorm2x16"
  "packSnorm2x16" "unpackSnorm2x16"
  "packUnorm4x8" "unpackUnorm4x8"
  "packSnorm4x8" "unpackSnorm4x8"
  ; bitwise builtins
  "bitfieldExtract" "bitfieldInsert" "bitfieldReverse" "bitCount" "findLSB"
  "findMSB" "imulExtend" "umulExtend" "uaddCarry" "usubBorrow" "ldexp" "frexp"
 )
)

; assume all uppercase variables as constants
((identifier) @constant
 (#match? @constant "^[A-Z][A-Z_0-9]*$"))

((identifier) @constant.builtin
 (#any-of? @constant.builtin 
  ; common / declared in all shader types
  "PI" "E" "TAU" "CURRENT_RENDERER" 
  "RENDERER_COMPATIBILITY" "RENDERER_MOBILE" "RENDERER_FORWARD_PLUS"
  ; TODO: add more builtins
  ))

((identifier) @variable.builtin
(#any-of? @variable.builtin "TIME"))
