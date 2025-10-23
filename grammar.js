/**
 * @file A parser for the Godot Shader langage
 * @author Tayfun Bocek <tayfunbocek@live.ca>
 * @license GPL3.0
 */

/// <reference types="tree-sitter-cli/dsl" />

const PREC = {
  PARENTHICAL_GROUP: 17,

  ARRAY_SUBSCRIPT: 16,
  FUNCTION_CALL: 16,
  STRUCTURE_FIELD: 16,
  METHOD_CALL: 16,
  POST_INC_DEC: 16,

  UNARY: 15,

  MULTIPLICATIVE: 14,
  ADDITIVE: 13,
  BITWISE_SHIFT: 12,
  RELATIONAL: 11,
  EQUALITY: 10,
  BITWISE_AND: 9,
  BITWISE_EXCLUSIVE_OR: 8,
  BITWISE_INCLUSIVE_OR: 7,
  LOGICAL_AND: 6,
  LOGICAL_EXCLUSIVE_OR: 5,
  LOGICAL_INCLUSIVE_OR: 4,
  SELECTION: 3,

  ARITHMETIC_ASSIGNMENT: 2,

  SEQUENCE: 1,
};

module.exports = grammar({
  name: "gdshader",
  externals: ($) => [$._eof],
  word: ($) => $.identifier,
  conflicts: ($) => [
    [$._type_identifier, $.expression],
    [$._type_spec, $.declaration],
  ],
  extras: (_) => [
    /\s|\\\r?\n/,
  ],
  inline: (
    $,
  ) => [
    $.block_item,
    $.initializer,
    $.assignable_expression,
    $.non_case_statement,
  ],
  supertypes: (
    $,
  ) => [
    $.number,
    $.integer,
    $.type,
    $.expression,
    $.statement,
    $.declarator,
  ],
  reserved: {
    global: (_) => [
      // type definitions
      "struct",
      // type qualifiers
      "uniform",
      "varying",
      "const",

      // interpolation specifiers
      "flat",
      "smooth",

      // precision qualifiers
      "highp",
      "mediump",
      "lowp",

      // parameter qualifiers
      "in",
      "out",
      "inout",

      // control flow
      "if",
      "else",
      "while",
      "do",
      "switch",
      "case",
      "default",
      "break",
      "return",
      "continue",
      "for",

      // other
      "discard",
      //"group_uniforms",
      //"global",
    ],
  },
  rules: {
    // TODO: add the actual grammar rules
    source_file: ($) => repeat($._top_level_item),

    // top level only bits
    _top_level_item: ($) =>
      choice(
        $.struct_definition,
        $.function_definition,
        $.declaration,
        $.non_case_statement,
        $.preproc_include,
      ),

    // preproc bits
    // partially taken then modified from:
    string_literal: ($) =>
      seq(
        '"',
        repeat(
          choice(
            alias(/[^\\"\n]+/, $.string_content),
            $.escape_sequence,
          ),
        ),
        '"',
      ),
    escape_sequence: (_) =>
      token(prec(
        1,
        seq(
          "\\",
          choice(
            /[^xuU]/,
            /\d{2,3}/,
            /x[0-9a-fA-F]{1,4}/,
            /u[0-9a-fA-F]{4}/,
            /U[0-9a-fA-F]{8}/,
          ),
        ),
      )),
    preproc_include: ($) =>
      seq(
        "#include",
        field("path", $.string_literal),
        choice(token.immediate(/\r?\n/), $._eof),
      ),

    // TODO: handle if and ifdefs etc.

    // gdshader specific bits (things that aren't in C or GLSL)
    type_qualifier: (_) =>
      choice(
        "uniform",
        "varying",
        "const",
      ),

    interpolation_specifier: (_) =>
      choice(
        "flat",
        "smooth",
      ),

    precision_specifier: (_) =>
      choice(
        "highp",
        "mediump",
        "lowp",
      ),

    parameter_qualifier: (_) =>
      choice(
        "in",
        "out",
        "inout",
      ),

    _group_uniforms: (_) => "group_uniforms",

    scope: (_) => "global",

    // common bits
    _any_integer: (_) => /[+-]?(?:0x[a-f0-9]+|\d+)/i,
    unsigned_integer: ($) =>
      seq($._any_integer, token.immediate(choice("u", "U"))),
    signed_integer: ($) => $._any_integer,
    integer: ($) => choice($.unsigned_integer, $.signed_integer),
    float: (_) => /[+-]?(?:\d+\.|\.\d)\d*(?:e[+-]\d+)?f?/i,
    number: ($) =>
      choice(
        $.integer,
        $.float,
      ),

    // must appear before `identifier` as it will always take precedence over `primitive_type`
    primitive_type: (_) =>
      /void|bool|u?int|float|(?:[biu]?vec|mat)[2-4]|[iu]?sampler(?:2D(Array)?|3D)|sampler(?:Cube(?:Array)?|ExternalOES)/,
    identifier: (_) => /(r#)?[_\p{XID_Start}][_\p{XID_Continue}]*/,
    _type_identifier: ($) => alias($.identifier, $.type_identifier),
    block_item: ($) =>
      choice(
        $.statement,
        $.declaration,
        $.preproc_include,
      ),
    type: ($) => choice($.primitive_type, $._type_identifier),

    // Expressions
    unary_expression: ($) => {
      const operators = field("operator", choice("+", "-", "~", "!"));
      return prec.left(
        PREC.UNARY,
        seq(
          field("operator", operators),
          field("argument", $.expression),
        ),
      );
    },
    update_expression: ($) => {
      const operators = field("operator", choice("--", "++"));
      const arg = field("argument", $.expression);
      return choice(
        prec.left(PREC.UNARY, seq(operators, arg)),
        prec.right(PREC.POST_INC_DEC, seq(arg, operators)),
      );
    },

    assignment_expression: ($) =>
      prec.right(
        PREC.ARITHMETIC_ASSIGNMENT,
        seq(
          field("left", $.assignable_expression),
          field(
            "operator",
            choice(
              "=",
              "*=",
              "/=",
              "%=",
              "+=",
              "-=",
              "<<=",
              ">>=",
              "&=",
              "^=",
              "|=",
            ),
          ),
          field("right", $.expression),
        ),
      ),

    assignable_expression: ($) =>
      choice($.identifier, $.field_expression, $.subscript_expression),

    binary_expression: ($) => {
      const table = [
        [PREC.LOGICAL_INCLUSIVE_OR, "||"],
        [PREC.LOGICAL_EXCLUSIVE_OR, "^^"],
        [PREC.LOGICAL_AND, "&&"],
        [PREC.BITWISE_INCLUSIVE_OR, "|"],
        [PREC.BITWISE_EXCLUSIVE_OR, "^"],
        [PREC.BITWISE_AND, "&"],
        [PREC.EQUALITY, choice("!=", "==")],
        [
          PREC.RELATIONAL,
          choice("<", "<=", ">", ">="),
        ],
        [PREC.BITWISE_SHIFT, choice("<<", ">>")],
        [PREC.ADDITIVE, choice("+", "-")],
        [PREC.MULTIPLICATIVE, choice("*", "/", "%")],
      ];

      return prec.left(choice(
        ...table.map(
          ([precedence, rule]) =>
            prec.left(
              precedence,
              seq(
                field("left", $.expression),
                field("operator", rule),
                field("right", $.expression),
              ),
            ),
        ),
      ));
    },

    ternary_expression: ($) =>
      prec.right(
        PREC.SELECTION,
        seq(
          field("condition", $.expression),
          "?",
          field("consequence", $.expression),
          ":",
          field("alternative", $.expression),
        ),
      ),

    parenthical_expression: ($) =>
      prec(PREC.PARENTHICAL_GROUP, seq("(", $.expression, ")")),
    subscript_expression: ($) =>
      prec.left(
        PREC.ARRAY_SUBSCRIPT,
        seq(
          field("argument", $.expression),
          "[",
          field("index", $.expression),
          "]",
        ),
      ),

    field_expression: ($) =>
      prec.left(
        PREC.STRUCTURE_FIELD,
        seq(
          field("argument", $.expression),
          repeat1(seq(field("operator", "."), field("field", $.identifier))),
        ),
      ),
    argument_list: ($) =>
      seq("(", optional(comma_seperated_rule($.expression)), ")"),
    call_expression: ($) =>
      prec.left(
        PREC.FUNCTION_CALL,
        seq(
          field("function", choice($.primitive_type, $.identifier)),
          // TODO: find better way to add array constructor support
          //field("size", optional($.array_constructor)),
          field("arguments", $.argument_list),
        ),
      ),

    comma_expression: ($) =>
      prec(
        PREC.SEQUENCE,
        // we explicitly require the comma to avoid parsing a single
        // expression as a comma expression
        seq($.expression, ",", comma_seperated_rule($.expression)),
      ),

    method_expression: ($) =>
      prec.left(
        PREC.METHOD_CALL,
        seq(
          field("argument", $.expression),
          field("operator", "."),
          field("method", $.identifier),
          field("arguments", $.argument_list),
        ),
      ),

    // Comma expressions are only supported under specific contexts so just
    // use choice(comma_expr, expr) instead where needed
    //
    // TODO: add method expressions for array.length() parsing
    expression: ($) =>
      choice(
        $.update_expression,
        $.call_expression,
        $.method_expression,
        $.assignment_expression,
        $.unary_expression,
        $.binary_expression,
        $.subscript_expression,
        $.field_expression,
        $.ternary_expression,
        $.parenthical_expression,
        $.identifier,
        $.number,
      ),

    // Statements
    compound_statement: ($) => seq("{", repeat($.block_item), "}"),
    expression_statement: ($) => seq(optional($.expression), ";"),
    if_statement: ($) =>
      prec.right(
        seq(
          "if",
          field("condition", $.parenthical_expression),
          choice(
            seq(
              field("consequence", $.statement),
              field("alternative", optional($.else_clause)),
            ),
          ),
        ),
      ),
    else_clause: ($) => seq("else", $.statement),
    while_statement: ($) =>
      seq(
        "while",
        field("condition", $.parenthical_expression),
        field("consequence", $.statement),
      ),
    do_statement: ($) =>
      seq(
        "do",
        field("consequence", $.statement),
        "while",
        field("condition", $.parenthical_expression),
        ";",
      ),
    for_statement: ($) =>
      prec.left(seq(
        "for",
        "(",
        // the first value is expected to be a declaration but we also accept expressions
        // so things like macros can be validly parsed if they actually declare a variable
        // (very niche use case but valid syntax - just not logical)
        field(
          "initializer",
          choice($.declaration, $.expression_statement),
        ),
        // unlike any other part in gdshader the comma operator is supported here meaning the following
        // is valid:
        //
        // for(;true, false;)
        //
        // See: https://github.com/godotengine/godot/issues/95451
        // TODO: replace with a dedicated rule to avoid future breakage related to the issue linked above
        field(
          "condition",
          optional(choice($.expression, $.comma_expression)),
        ),
        ";",
        field("update", optional($.expression)),
        ")",
        // unlike C, gdshader accepts any statement
        // so something like `for (;;) int a;` is actually valid
        field("consequence", optional($.statement)),
      )),
    return_statement: ($) =>
      seq("return", field("value", optional($.expression)), ";"),
    break_statement: (_) => seq("break", ";"),
    continue_statement: (_) => seq("continue", ";"),
    discard_statement: (_) => seq("discard", ";"),
    switch_statement: ($) =>
      seq(
        "switch",
        field("condition", $.parenthical_expression),
        field("block", $.compound_statement),
      ),
    case_statement: ($) =>
      prec.right(
        seq(
          choice(
            seq("case", field("value", choice($.identifier, $.number))),
            "default",
          ),
          ":",
          repeat(choice($.non_case_statement, $.declaration)),
        ),
      ),

    // TODO: fill with actual names
    _render_mode: ($) => alias($.identifier, $.render_mode),
    _shader_type: ($) => alias($.identifier, $.shader_type),

    shader_type_statement: ($) =>
      seq(
        "shader_type",
        $._shader_type,
        ";",
      ),

    render_mode_statement: ($) =>
      seq(
        "render_mode",
        comma_seperated_rule($._render_mode),
        ";",
      ),

    statement: ($) =>
      choice(
        $.non_case_statement,
        $.case_statement,
      ),
    non_case_statement: ($) =>
      choice(
        $.compound_statement,
        $.if_statement,
        $.while_statement,
        $.do_statement,
        $.return_statement,
        $.for_statement,
        $.break_statement,
        $.discard_statement,
        $.continue_statement,
        $.shader_type_statement,
        $.render_mode_statement,
        $.switch_statement,
        $.expression_statement,
      ),

    // Declaration
    field_definition: ($) => $._non_top_level_many_declarator,
    struct_fields: ($) => seq("{", repeat(seq($.field_definition, ";")), "}"),
    struct_definition: ($) =>
      seq(
        "struct",
        field("name", $.identifier),
        field("fields", $.struct_fields),
        ";",
      ),
    _type_spec: ($) =>
      seq(
        field("precision_specifier", optional($.precision_specifier)),
        field("type", $.type),
      ),
    _non_top_level_many_declarator: ($) =>
      seq(
        $._type_spec,
        comma_seperated_rule(field("declarator", $.declarator)),
      ),
    _non_top_level_single_declarator: ($) =>
      seq(
        $._type_spec,
        field("declarator", $.declarator),
      ),
    declaration: ($) =>
      seq(
        field("qualifier", optional($.type_qualifier)),
        field("interpolation", optional($.interpolation_specifier)),
        field("precision", optional($.precision_specifier)),
        field("type", $.type),
        comma_seperated_rule(
          field("declarator", choice($.init_declarator, $.declarator)),
        ),
        ";",
      ),
    init_declarator: ($) =>
      seq(
        field("declarator", $.declarator),
        field("operator", "="),
        field("value", $.initializer),
      ),
    declarator: ($) =>
      field("declarator", choice($.identifier, $.array_declarator)),
    array_declarator: ($) =>
      prec.right(
        seq(
          field("declarator", $.identifier),
          repeat1(seq("[", field("size", $.expression), "]")),
        ),
      ),
    initializer: ($) => choice($.expression, $.initializer_list),
    initializer_list: ($) =>
      seq("{", comma_seperated_trailing_rule($.expression), "}"),

    parameter_declaration: ($) =>
      seq(
        field("parameter_qualifier", optional($.parameter_qualifier)),
        $._non_top_level_single_declarator,
      ),
    parameter_list: ($) =>
      seq(
        "(",
        optional(
          comma_seperated_rule(
            $.parameter_declaration,
          ),
        ),
        ")",
      ),

    type_specifier: ($) =>
      seq(
        field("type", $._type_spec),
        repeat(seq("[", field("size", $.expression), "]")),
      ),
    function_definition: ($) =>
      seq(
        field("type", $.type_specifier),
        field("declarator", $.identifier),
        field("parameters", $.parameter_list),
        field("block", $.compound_statement),
      ),
  },
});

function comma_seperated_rule(rule) {
  return seq(rule, repeat(seq(",", rule)));
}

function comma_seperated_trailing_rule(rule) {
  return seq(rule, repeat(seq(",", rule)), optional(","));
}
