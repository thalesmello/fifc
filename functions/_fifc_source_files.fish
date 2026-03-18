function _fifc_source_files -d "Return a command to recursively find files"
    set -l path (_fifc_path_to_complete | string escape)
    set path_type (string match -rq '/$' "$path"; and echo 'directory'; or echo 'string' )
    set -l hidden (string match "*." "$path")

    set -l depth_opts
    if test (path resolve "$path") = "$HOME"
        if type -q fd
            set depth_opts --max-depth 1
        else
            set depth_opts -maxdepth 1
        end
    end

    if string match --quiet -- '~*' "$fifc_query"
        set -e fifc_query
    end

    if test "$path_type" != "directory"
        echo _fifc_parse_complist
        return
    end

    if type -q fd
        if _fifc_test_version (fd --version) -ge "8.3.0"
            set fd_custom_opts --strip-cwd-prefix
        end

        set -l fd_base_opts $fifc_fd_opts $depth_opts --color=always --no-ignore $fd_custom_opts

        echo "fd . $fd_base_opts -- $path"
    else
        if test -n "$hidden"
            echo "find $path $fifc_find_opts $depth_opts ! -path . -print 2>/dev/null | sed 's|^\./||'"
        else
            echo "find $path $fifc_find_opts $depth_opts ! -path . ! -name '.*' -print 2>/dev/null | sed 's|^\./||'"
        end
    end
end
