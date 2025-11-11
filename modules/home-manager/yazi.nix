{
  config,
  pkgs,
  ...
}:
let
  palette = config.colorScheme.palette;
in
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      manager = {
        ratio = [ 1 3 3 ];
        sort_by = "alphabetical";
        sort_sensitive = false;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "none";
        show_hidden = false;
        show_symlink = true;
      };
      theme = {
        manager = {
          cwd = { fg = "#${palette.base0D}"; };
          hovered = { fg = "#${palette.base00}"; bg = "#${palette.base0D}"; };
          preview_hovered = { underline = true; };
          find_keyword = { fg = "#${palette.base0A}"; bold = true; };
          find_position = { fg = "#${palette.base0E}"; bg = "#${palette.base0E}"; fg_plus = "#${palette.base00}"; };
          marker_copied = { fg = "#${palette.base0B}"; };
          marker_selected = { fg = "#${palette.base0A}"; };
          marker_cut = { fg = "#${palette.base08}"; };
          tab_active = { fg = "#${palette.base00}"; bg = "#${palette.base0D}"; };
          tab_inactive = { fg = "#${palette.base05}"; bg = "#${palette.base02}"; };
          tab_width = 1;
          count_copied = { fg = "#${palette.base00}"; bg = "#${palette.base0B}"; };
          count_selected = { fg = "#${palette.base00}"; bg = "#${palette.base0D}"; };
          count_cut = { fg = "#${palette.base00}"; bg = "#${palette.base08}"; };
          border_symbol = "│";
          border_style = { fg = "#${palette.base03}"; };
          highlight = { fg = "#${palette.base00}"; bg = "#${palette.base0D}"; };
        };
      };
    };
  };
}

