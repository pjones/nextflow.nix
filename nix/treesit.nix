{ self, ... }:
{
  perSystem = { pkgs, system, ... }: {
    packages.tree-sitter-nextflow =
      let
        version = "0.3.0";
      in
      pkgs.tree-sitter.buildGrammar {
        inherit version;
        language = "nextflow";

        src = pkgs.fetchFromGitHub {
          owner = "nextflow-io";
          repo = "tree-sitter-nextflow";
          rev = "v${version}";
          hash = "sha256-nMQATg0dP15d+P+8/9f0tWNpSl8FgBIR/KW9smPHKVk=";
        };

        meta = {
          description = "Nextflow grammar for tree-sitter.";

          longDescription = ''
            Nextflow Strict Syntax (v2 Parser) - NXF_SYNTAX_PARSER=v2

            This grammar is designed to support Nextflow's strict
            syntax mode, focusing on the cleaner, more consistent v2
            parser syntax patterns.
          '';

          homepage = "https://github.com/nextflow-io/tree-sitter-nextflow";
          license = pkgs.lib.licenses.mit;
          maintainers = with pkgs.lib.maintainers; [ pjones ];
          platforms = pkgs.lib.platforms.all;
        };
      };

    checks.tree-sitter-nextflow = self.packages.${system}.tree-sitter-nextflow;
  };
}
