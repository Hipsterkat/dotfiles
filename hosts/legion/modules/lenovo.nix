{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.lenovo;
  l5pKeyboardRgb = lib.attrByPath [ "l5p-keyboard-rgb" "packages" pkgs.system "default" ] null inputs;
in {
  options.lenovo = {
    enable = lib.mkEnableOption "Enable Lenovo specific configurations.";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      [ fwupd ]
      ++ lib.optional (lib.hasAttr "lenovo-legion-app" pkgs) pkgs."lenovo-legion-app"
      ++ lib.optional (l5pKeyboardRgb != null) l5pKeyboardRgb;

    powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="c995", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="c994", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="c993", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="c985", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="c984", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="c983", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="c975", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="c973", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="c965", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="c963", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="c955", MODE="0666"
      # Keep the AQIRYS Phoenix mouse awake to avoid autosuspend disconnects.
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="04d9", ATTR{idProduct}=="a09f", TEST=="power/control", ATTR{power/control}="on"
    '';

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
