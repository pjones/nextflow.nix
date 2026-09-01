{ ... }:
{
  perSystem = { pkgs, ... }: {
    # Just pass on the nextflow from nixpkgs:
    packages.nextflow = pkgs.nextflow;
  };
}
