function _fifc_or_pager_back
    if commandline --paging-mode
        commandline --function complete-and-search
    else
        _fifc
    end
end
