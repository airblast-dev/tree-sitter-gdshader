; highlights.scm

["uniform" "const" "varying" "render_mode" "shader_type"] @keyword
["in" "inout" "out"] @keyword.modifier
["return"] @keyword.return
["while" "do" "break" "continue"] @keyword.repeat
["if" "else" "switch" "case"] @keyword.conditional
["struct"] @keyword.type
[
  ";"
  ":"
  ","
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
] @operator

(ternary_expression
  ["?" ":"] @keyword.conditional.ternary
)

(primitive_type) @type.builtin
(type_identifier) @type
(number) @number
(float) @number.float

(_
  declarator: (identifier) @variable)

(field_expression
  field: (identifier) @variable.member)

(case_statement
  value: (identifier) @constant)


(parameter_declaration
      declarator: (identifier)* @variable.parameter)

(function_definition
  declarator: (identifier) @function)

(field_expression
  field: (identifier) @property
)

(call_expression
  function: (identifier)
  arguments: (argument_list
    (identifier)? @variable
  )
) @function.call

(
 (call_expression
  function: (identifier) @func.builtin
 )
 (#any-of? @func.builtin
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
  (#any-of? @constant.builtin "PI" "E" "TIME" "TAU")
)

(struct_declaration name: (identifier) @type.definition) @type

(preproc_include "#include" @keyword.directive)
(preproc_include path: (string_literal (string_content)* @string.special.path) @string)
