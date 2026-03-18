function _fifc_or_pager_back
    if commandline --paging-mode
        commandline --function backward-char
    else
        _fifc
    end
end
