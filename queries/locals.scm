(declaration) @local.definition
(function_definition declarator: (identifier) @local.definition) @local.scope
(parameter_declaration declarator: ([(identifier) @local.definition (array_declarator declarator: (identifier) @local.definition)]))
(identifier) @local.reference

(while_statement) @local.scope
(do_statement) @local.scope
(if_statement) @local.scope
(else_clause) @local.scope
