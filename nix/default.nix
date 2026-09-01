{ self, ... }:
{
  perSystem = { system, ... }: {
    packages.default = self.packages.${system}.nextflow;
  };
}
