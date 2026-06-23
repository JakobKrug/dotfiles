source /usr/share/cachyos-fish-config/cachyos-config.fish

set EDITOR nvim
set VISUAL nvim

alias r="ranger"
alias reload="source /home/jakob/.config/fish/config.fish"
alias cm="chezmoi"

function fastfetch
    # 1. Get wallpaper path
    set -l wall (qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.wallpaper 0 | grep -m1 "Image:" | cut -d ' ' -f2 | sed 's|file://||')

    # 2. Exit early if no wallpaper or "null"
    if test -z "$wall"; or test "$wall" = null
        command fastfetch $argv
        return
    end

    # 3. Check cache to avoid re-running pywal
    set -l cache_file "$HOME/.cache/fastfetch_last_wall"
    if test "$wall" != (cat "$cache_file" 2>/dev/null)
        wal -i "$wall" -n -e -q -b "#232627"
        echo "$wall" >"$cache_file"
    end

    # 4. Extract Two Colors & Run
    set -l color_file "$HOME/.cache/wal/colors.sh"
    if test -f "$color_file"
        # Extract primary and secondary accents
        set -l c1 (grep -w "color1" "$color_file" | cut -d"'" -f2)
        set -l c2 (grep -w "color2" "$color_file" | cut -d"'" -f2)

        # Apply colors:
        # --logo-color-1 & 2: Primary and secondary logo parts
        # --color-keys: The module labels
        # --color-title: The user@host text
        command fastfetch \
            --logo-color-1 "$c1" \
            --logo-color-2 "$c2" \
            --color-keys "$c1" \
            --color-title "$c2" \
            $argv
    else
        command fastfetch $argv
    end
end
