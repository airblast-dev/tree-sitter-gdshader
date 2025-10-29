(function_definition
  declarator: (identifier) @local.definition)

(declaration
  declarator: (identifier) @local.definition)

(init_declarator
  declarator: (identifier) @local.definition)

(array_declarator
  declarator: (identifier) @local.definition)

(parameter_declaration
  declarator: (identifier) @local.definition)

(expression
  [
    left: (identifier) @local.reference
    argument: (identifier) @local.reference
  ])

(expression/identifier) @local.reference

(compound_statement) @local.scope
