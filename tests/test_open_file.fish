set dir "tests/_resources/dir with spaces"
set curr_fifc_editor $FIFC_EDITOR
set FIFC_EDITOR cat
set fifc_candidate "$dir/file 1.txt"

set actual (_fifc_open_file)
@test "builtin file open" "$actual" = 'foo 1'

set FIFC_EDITOR $curr_fifc_editor
