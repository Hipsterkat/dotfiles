{ config, lib, pkgs, ... }:

let
  cfg = config.lenovo;
in {
  options.lenovo = {
    enable = lib.mkEnableOption "Enable Lenovo specific configurations.";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ fwupd ];

    powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

    systemd.services.lenovo-conservation-mode = {
      description = "Enable Lenovo conservation mode";
      wantedBy = [ "multi-user.target" ];
      unitConfig.ConditionPathIsWritable = "/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "enable-conservation-mode" ''
          path="/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode"
          if [ -w "$path" ]; then
            echo 1 > "$path"
          else
            echo "Conservation mode sysfs path not found; skipping" >&2
          fi
        '';
      };
    };
  };
}
