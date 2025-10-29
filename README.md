# tree-sitter-gdshader

GDShader grammer for tree-sitter.

## Implementation

The GDShader does have an official syntax specification and instead forwards most of the work
to the GLSL ES 3.0 specification. 
Because of that, the grammer implementation decides a syntax rule is valid if all of the following are true.

- Is it a valid GLSL shader?
- Can the Godot Editor parse it? (even if semantically invalid)

There are a few exceptions to this rule as there are cases where obviously parseable syntax is rejected by the editor.
