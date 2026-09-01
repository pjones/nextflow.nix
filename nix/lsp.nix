{ self, ... }:
{
  perSystem = { pkgs, system, ... }: {
    packages.nextflow-language-server =
      pkgs.callPackage
        (
          {
            lib,
            stdenv,
            fetchFromGitHub,
            makeWrapper,
            gradle,
            jdk,
            jre,
          }:
          stdenv.mkDerivation (finalAttrs: {
            pname = "nextflow-lsp";
            version = "26.04.3";

            src = fetchFromGitHub {
              owner = "nextflow-io";
              repo = "language-server";
              rev = "v${finalAttrs.version}";
              hash = "sha256-0iYyULJqGWX6L9Qo53H/T7sLmO2qX8t1y5WSk5TmhkY=";
            };

            patches = [
              ../patches/lsp-deps.patch
              ../patches/lsp-tests.patch
            ];

            nativeBuildInputs = [
              gradle
              makeWrapper
            ];

            gradleFlags = [
              "-Dfile.encoding=utf-8"
              "-Dorg.gradle.java.home=${jdk}"
              "--no-configuration-cache"
            ];

            gradleBuildTask = "shadowJar";

            # To update:
            #
            # ```
            # nix build .\#nextflow-lsp.mitmCache.updateScript
            # ./result
            # ```
            mitmCache = gradle.fetchDeps {
              pkg = finalAttrs.finalPackage;
              data = ../support/lsp-deps.json;
            };

            doCheck = true;

            installPhase = ''
              runHook preInstall

              mkdir -p "$out/bin" "$out/share/nextflow"
              install build/libs/language-server-all.jar "$out/share/nextflow"

              makeWrapper ${lib.getExe jre} $out/bin/nextflow-language-server \
                --add-flags "-jar $out/share/nextflow/language-server-all.jar"

              runHook postInstall
            '';

            meta = {
              description = "The Nextflow language server";

              longDescription = ''
                The official language server for Nextflow scripts and config files.
              '';

              mainProgram = "nextflow-language-server";
              homepage = "https://github.com/nextflow-io/language-server";
              license = lib.licenses.asl20;
              maintainers = with lib.maintainers; [ pjones ];
              platforms = lib.platforms.all;
            };
          })
        )
        {
          gradle = pkgs.gradle_9;
        };

    checks.nextflow-language-server = self.packages.${system}.nextflow-language-server;
  };
}
