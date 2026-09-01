{ self, ... }:
{
  perSystem = { pkgs, system, ... }: {
    packages.nextflow-mode = pkgs.callPackage (
      {
        lib,
        emacs,
        emacsPackages,
        fetchFromGitHub,
        version ? "1.0.0",
      }:

      emacs.pkgs.melpaBuild {
        inherit version;
        pname = "nextflow-mode";

        src = fetchFromGitHub {
          owner = "edmundmiller";
          repo = "nextflow-mode";
          rev = "v${version}";
          hash = "sha256-vKpqiquTh8YiX9swQgCephAfHAC53gA2vZWxx7FmvDw=";
        };

        packageRequires = [
          emacsPackages.groovy-mode
        ];

        meta = {
          description = "Emacs major mode for Nextflow";

          longDescription = ''
            An Emacs mode for syntax highlighting for Nextflow based
            on snakemake-mode. More features such as a popup runner,
            and better script editing planned in the future! Support
            for DSL2 is in the works also.
          '';

          homepage = "https://github.com/edmundmiller/nextflow-mode";
          license = lib.licenses.gpl3Only;
          maintainers = with lib.maintainers; [ pjones ];
          platforms = lib.platforms.all;
        };
      }
    ) { };

    checks.nextflow-mode = self.packages.${system}.nextflow-mode;
  };
}
