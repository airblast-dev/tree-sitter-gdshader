(function_definition declarator: (identifier) @name) @definition.function
(call_expression function: (identifier) @name ) @reference.call
(struct_definition name: (identifier) @name) @definition.type
((type_identifier) @name)@reference.type
