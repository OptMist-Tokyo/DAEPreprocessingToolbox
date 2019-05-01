// MuPAD implementation for addEntry.m

daepp::addEntry := proc(table, key, value)
begin
    // check number of arguments
    if args(0) <> 3 then
        error("Three arguments expected.");
    end_if;
    
    // check input
    if testargs() then
        if not testtype(table, DOM_TABLE) then
            error("First argument must be table.");
        end_if;
    end_if;
    
    // store value
    table[key] := value;
    table;
end_proc;
