package tree_sitter_gdshader_test

import (
	"testing"

	tree_sitter "github.com/tree-sitter/go-tree-sitter"
	tree_sitter_gdshader "github.com/tree-sitter/tree-sitter-gdshader/bindings/go"
)

func TestCanLoadGrammar(t *testing.T) {
	language := tree_sitter.NewLanguage(tree_sitter_gdshader.Language())
	if language == nil {
		t.Errorf("Error loading Gdshader grammar")
	}
}
