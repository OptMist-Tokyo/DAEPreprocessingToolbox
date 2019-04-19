// convert vectors and scalars into lists.

daepp::toList := proc(A)
begin
    // convert to list
    if testtype(A, matrix) then
        [m, n] := linalg::matdim(A);
        if m > 1 && n > 1 then
            error("Row or column vector expected.");
        end_if;
        if m > 1 then
            A := transpose(A);
        end_if;
        coerce(A, DOM_LIST)[1];
    else
        [A];
    end_if;
end_proc;
