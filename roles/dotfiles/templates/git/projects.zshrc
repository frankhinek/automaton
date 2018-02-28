#!/usr/bin/env zsh

# {{ ansible_managed }}

{%- macro f(color_code) -%}
\e[38;5;{{ color_code }}m
{%- endmacro %}
{% macro b(color_code) -%}
\e[48;5;{{ color_code }}m
{%- endmacro %}
{% set reset = '\e[0m' -%}
{% set glyph_git = '\uE0A0' -%}
{% set glyph_rt_arrow = '\uE0B0' -%}
{% set glyph_lock = '\uE0A2' %}

function dynamic_git_user() {
  # If a .git directory is present or we are in a git repository directory structure
  if [ -d .git ] || git rev-parse --is-inside-work-tree >/dev/null 2>&1; then

    # This script only works if an origin remote exists
    if git config --get remote.origin.url > /dev/null 2>&1; then
      local origin_url git_email

      # Get the URL of the origin remote
      origin_url="$(git config --get remote.origin.url)"

      # Get the git email address currently configured and any local config
      git_email="$(git config --get user.email)"
      git_email_local_only="$(git config --local --get user.email)"

      # If origin is github.com, assume it is a personal project
      if [ "$(echo $origin_url | sed -n '/github\.com/p')" ]; then
        # Only modify .git/config if a local user.email was not manually set
        if [ "$git_email" != "{{ git.email.personal }}" ] && [ ! "$git_email_local_only" ]; then
          #git config user.email {{ git.email.personal }}
          echo -e "{{f(252)}}{{b(237)}}  {{glyph_git}}  {{f(237)}}{{b(239)}}{{glyph_rt_arrow}}{{f(252)}} {{ glyph_lock if enable_git_signing else ' ' }}  {{f(239)}}{{b(32)}}{{glyph_rt_arrow}}{{f(236)}} {{ git.email.personal }} {{reset}}{{f(32)}}{{glyph_rt_arrow}}{{reset}}"
        fi
      # If origin is honeywell.com, assume it is a work project
      elif [ "$(echo $origin_url | sed -n '/honeywell\.com/p')" ]; then
        # Only modify .git/config if a local user.email was not manually set
        if [ "$git_email" != "{{ git.email.work }}" ] && [ ! "$git_email_local_only" ]; then
          #git config user.email {{ git.email.work }}
          echo -e "{{f(252)}}{{b(237)}}  {{glyph_git}}  {{f(237)}}{{b(239)}}{{glyph_rt_arrow}}{{f(252)}} {{ glyph_lock if enable_git_signing else ' ' }}  {{f(239)}}{{b(32)}}{{glyph_rt_arrow}}{{f(236)}} {{ git.email.work }} {{reset}}{{f(32)}}{{glyph_rt_arrow}}{{reset}}"
        fi
      fi
    fi
  fi
}

# clean up will be called if the working directory is no longer a subdirectory
# of the parent directory in which this zshrc file is stored
function unmagic {
  unfunction dynamic_git_user
  unset origin_url git_email
  chpwd_functions=("${(@)chpwd_functions:#dynamic_git_user}")
}

# Enable the dynamic_git_user function hook
chpwd_functions=(${chpwd_functions[@]} "dynamic_git_user")
