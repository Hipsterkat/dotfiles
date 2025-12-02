{ lib, config, ... }:

let
  cfg = config.hardware.vfio;
  idsParam = lib.concatStringsSep "," cfg.ids;
  disableVgaFlag = lib.optionalString cfg.disableVga " disable_vga=1";
in
{
  options.hardware.vfio = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable helper settings for VFIO passthrough.";
    };

    ids = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      example = [ "10de:28e0" "10de:22be" ];
      description = "List of PCI IDs (vendor:device) to bind to vfio-pci.";
    };

    enableAcsOverride = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Append pcie_acs_override=downstream,multifunction to kernel params.";
    };

    disableVga = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Pass disable_vga=1 to vfio-pci when setting ids.";
    };

    bootEntry = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Expose a specialisation boot entry with VFIO enabled while keeping the default system untouched.";
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "vfio";
        description = "Name of the VFIO specialisation boot entry.";
      };

      configuration = lib.mkOption {
        type = lib.types.listOf lib.types.deferredModule;
        default = [ ];
        example = [
          { services.xserver.videoDrivers = [ "modesetting" "intel" ]; }
        ];
        description = "Extra module fragments applied only in the VFIO specialisation (e.g. disable GPU drivers).";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      boot.kernelModules = lib.mkBefore [ "vfio" "vfio_pci" "vfio_iommu_type1" ];
      boot.initrd.kernelModules = lib.mkBefore [ "vfio" "vfio_pci" "vfio_iommu_type1" ];
      boot.kernelParams = lib.mkAfter (
        [ "intel_iommu=on" "iommu=pt" ]
        ++ lib.optionals (cfg.ids != []) [ "vfio-pci.ids=${idsParam}" ]
        ++ lib.optional cfg.enableAcsOverride "pcie_acs_override=downstream,multifunction"
      );
      boot.extraModprobeConfig = lib.mkAfter (lib.optionalString (cfg.ids != []) ''
        options vfio-pci ids=${idsParam}${disableVgaFlag}
      '');
    })

    (lib.mkIf cfg.bootEntry.enable {
      specialisation."${cfg.bootEntry.name}" = {
        inheritParentConfig = true;
        configuration =
          let extraImports = cfg.bootEntry.configuration;
          in
          {
            system.nixos.tags = [ cfg.bootEntry.name "vfio" ];
            hardware.vfio.enable = true;
          } // lib.optionalAttrs (extraImports != [ ]) {
            imports = extraImports;
          };
      };
    })
  ];
}
