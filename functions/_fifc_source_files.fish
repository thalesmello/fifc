function _fifc_source_files -d "Return a command to recursively find files"
    set -l path (_fifc_path_to_complete | string escape)
    set -l hidden (string match "*." "$path")

    set -l depth_opts
    if test "$path" = "$HOME/" -o "$path" = "$HOME"
        if type -q fd
            set depth_opts --max-depth 1
        else
            set depth_opts -maxdepth 1
        end
    end

    if string match --quiet -- '~*' "$fifc_query"
        set -e fifc_query
    end

    if type -q fd
        if _fifc_test_version (fd --version) -ge "8.3.0"
            set fd_custom_opts --strip-cwd-prefix
        end

        if test "$path" = {$PWD}/
            echo "fd . $fifc_fd_opts $depth_opts --color=always --no-ignore $fd_custom_opts"
        else if test "$path" = "."
            echo "fd . $fifc_fd_opts $depth_opts --color=always --hidden --no-ignore $fd_custom_opts"
        else if test -n "$hidden"
            echo "fd . $fifc_fd_opts $depth_opts --color=always --hidden --no-ignore -- $path"
        else
            echo "fd . $fifc_fd_opts $depth_opts --color=always --no-ignore -- $path"
        end
    else if test -n "$hidden"
        # Use sed to strip cwd prefix
        echo "find . $path $fifc_find_opts $depth_opts ! -path . -print 2>/dev/null | sed 's|^\./||'"
    else
        # Exclude hidden directories
        echo "find . $path $fifc_find_opts $depth_opts ! -path . ! -path '*/.*' -print 2>/dev/null | sed 's|^\./||'"
    end
end
