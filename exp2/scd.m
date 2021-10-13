function ncd = ncd(measured, correct)

ncd = -log10(max(abs((measured - correct) ./ correct)));
