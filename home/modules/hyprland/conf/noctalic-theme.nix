{ ... }:
{
  # rose-pine theme colors
  wayland.windowManager.hyprland = {
    settings = {
      "$primary" = "rgb(d7827e)";
      "$surface" = "rgb(fffaf3)";
      "$secondary" = "rgb(56949f)";
      "$error" = "rgb(b4637a)";
      "$tertiary" = "rgb(286983)";
      "$surface_lowest" = "rgb(fcf6ef)";

      general = {
        "col.active_border" = "$primary";
        "col.inactive_border" = "$surface";
      };

      group = {
        "col.border_active" = "$secondary";
        "col.border_inactive" = "$surface";
        "col.border_locked_active" = "$error";
        "col.border_locked_inactive" = " $surface";

        groupbar = {
          "col.active" = "$secondary";
          "col.inactive" = "$surface";
          "col.locked_active" = "$error";
          "col.locked_inactive" = "$surface";
        };
      };
    };
  };
}
