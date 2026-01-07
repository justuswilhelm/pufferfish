# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later
# https://karabiner-elements.pqrs.org/docs/json/complex-modifications-manipulator-definition/from/
{ lib, ... }:
let
  fnKeysRule = {
    description = "Function Key + hjkl to arrow keys Vim";
    manipulators = [
      {
        from = {
          key_code = "h";
          modifiers = {
            mandatory = [ "fn" ];
            optional = [ "any" ];
          };
        };
        to = [ { key_code = "left_arrow"; } ];
        type = "basic";
      }
      {
        from = {
          key_code = "j";
          modifiers = {
            mandatory = [ "fn" ];
            optional = [ "any" ];
          };
        };
        to = [ { key_code = "down_arrow"; } ];
        type = "basic";
      }
      {
        from = {
          key_code = "k";
          modifiers = {
            mandatory = [ "fn" ];
            optional = [ "any" ];
          };
        };
        to = [ { key_code = "up_arrow"; } ];
        type = "basic";
      }
      {
        from = {
          key_code = "l";
          modifiers = {
            mandatory = [ "fn" ];
            optional = [ "any" ];
          };
        };
        to = [ { key_code = "right_arrow"; } ];
        type = "basic";
      }
    ];
  };
  aerospaceRCmd = {
    description = "right_command -> cmd+alt for aerospace";
    manipulators = [
      {
        from = {
          key_code = "right_command";
          modifiers = {
            optional = [ "any" ];
          };
        };
        to = [
          {
            key_code = "left_command";
            modifiers = [ "left_option" ];
          }
        ];
        type = "basic";
      }
    ];
  };
in
{
  xdg.configFile."karabiner/karabiner.json".text = lib.generators.toJSON { } {
    global = {
      check_for_updates_on_startup = true;
      show_in_menu_bar = false;
      show_profile_name_in_menu_bar = false;
      unsafe_ui = false;
    };
    profiles = [
      {
        complex_modifications = {
          parameters = {
            "basic.simultaneous_threshold_milliseconds" = 50;
            "basic.to_delayed_action_delay_milliseconds" = 500;
            "basic.to_if_alone_timeout_milliseconds" = 1000;
            "basic.to_if_held_down_threshold_milliseconds" = 500;
            "mouse_motion_to_scroll.speed" = 100;
          };
          rules = [
            fnKeysRule
            aerospaceRCmd
          ];
        };
        devices = [
          # Internal keyboard
          {
            disable_built_in_keyboard_if_exists = false;
            fn_function_keys = [ ];
            identifiers = {
              is_keyboard = true;
              is_pointing_device = false;
              product_id = 0;
              vendor_id = 0;
            };
            ignore = false;
            manipulate_caps_lock_led = true;
            simple_modifications = [
              {
                from = {
                  key_code = "caps_lock";
                };
                to = [ { key_code = "return_or_enter"; } ];
              }
              {
                from = {
                  key_code = "non_us_backslash";
                };
                to = [ { key_code = "grave_accent_and_tilde"; } ];
              }
              {
                from = {
                  key_code = "return_or_enter";
                };
                to = [ { key_code = "vk_none"; } ];
              }
            ];
            treat_as_built_in_keyboard = false;
          }
          # External USB keyboard from FILCO
          {
            disable_built_in_keyboard_if_exists = false;
            fn_function_keys = [ ];
            identifiers = {
              is_keyboard = true;
              is_pointing_device = false;
              product_id = 6148;
              vendor_id = 12029;
            };
            ignore = false;
            manipulate_caps_lock_led = true;
            simple_modifications = [
              {
                from = {
                  key_code = "left_option";
                };
                to = [ { key_code = "left_command"; } ];
              }
              {
                from = {
                  key_code = "left_command";
                };
                to = [ { key_code = "left_option"; } ];
              }
              {
                from = {
                  key_code = "right_option";
                };
                to = [ { key_code = "right_command"; } ];
              }
              {
                from = {
                  key_code = "right_command";
                };
                to = [ { key_code = "right_option"; } ];
              }
              {
                from = {
                  key_code = "caps_lock";
                };
                to = [ { key_code = "return_or_enter"; } ];
              }
              {
                from = {
                  key_code = "non_us_backslash";
                };
                to = [ { key_code = "grave_accent_and_tilde"; } ];
              }
              {
                from = {
                  key_code = "return_or_enter";
                };
                to = [ { key_code = "vk_none"; } ];
              }
              {
                from = {
                  consumer_key_code = "scan_previous_track";
                };
                to = [ { key_code = "rewind"; } ];
              }
              {
                from = {
                  consumer_key_code = "scan_next_track";
                };
                to = [ { key_code = "fastforward"; } ];
              }
            ];
            treat_as_built_in_keyboard = false;
          }
          # Apple Magic Keyboard
          {
            disable_built_in_keyboard_if_exists = false;
            fn_function_keys = [ ];
            identifiers = {
              is_keyboard = true;
              is_pointing_device = false;
              product_id = 666;
              vendor_id = 76;
            };
            ignore = false;
            manipulate_caps_lock_led = true;
            simple_modifications = [
              {
                from = {
                  key_code = "caps_lock";
                };
                to = [ { key_code = "return_or_enter"; } ];
              }
              {
                from = {
                  key_code = "non_us_backslash";
                };
                to = [ { key_code = "grave_accent_and_tilde"; } ];
              }
              {
                from = {
                  key_code = "return_or_enter";
                };
                to = [ { key_code = "vk_none"; } ];
              }
            ];
            treat_as_built_in_keyboard = false;
          }
        ];
        fn_function_keys = [
          {
            from = {
              key_code = "f1";
            };
            to = [ { consumer_key_code = "display_brightness_decrement"; } ];
          }
          {
            from = {
              key_code = "f2";
            };
            to = [ { consumer_key_code = "display_brightness_increment"; } ];
          }
          {
            from = {
              key_code = "f3";
            };
            to = [ { apple_vendor_keyboard_key_code = "mission_control"; } ];
          }
          {
            from = {
              key_code = "f4";
            };
            to = [ { apple_vendor_keyboard_key_code = "spotlight"; } ];
          }
          {
            from = {
              key_code = "f5";
            };
            to = [ { consumer_key_code = "dictation"; } ];
          }
          {
            from = {
              key_code = "f6";
            };
            to = [ { key_code = "f6"; } ];
          }
          {
            from = {
              key_code = "f7";
            };
            to = [ { consumer_key_code = "rewind"; } ];
          }
          {
            from = {
              key_code = "f8";
            };
            to = [ { consumer_key_code = "play_or_pause"; } ];
          }
          {
            from = {
              key_code = "f9";
            };
            to = [ { consumer_key_code = "fast_forward"; } ];
          }
          {
            from = {
              key_code = "f10";
            };
            to = [ { consumer_key_code = "mute"; } ];
          }
          {
            from = {
              key_code = "f11";
            };
            to = [ { consumer_key_code = "volume_decrement"; } ];
          }
          {
            from = {
              key_code = "f12";
            };
            to = [ { consumer_key_code = "volume_increment"; } ];
          }
        ];
        name = "Default profile";
        parameters = {
          delay_milliseconds_before_open_device = 1000;
        };
        selected = true;
        simple_modifications = [ ];
        virtual_hid_keyboard = {
          country_code = 0;
          indicate_sticky_modifier_keys_state = true;
          mouse_key_xy_scale = 100;
          keyboard_type_v2 = "ansi";
        };
      }
    ];
  };
}
