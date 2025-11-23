((function_definition
  declarator: (identifier) @name) @definition.function)

((call_expression
  function: (_) @name) @reference.call)

((method_expression
  method: (identifier) @name) @reference.call)

((struct_definition
  name: (identifier) @name) @definition.class)

(((type_identifier) @name) @reference.class)
