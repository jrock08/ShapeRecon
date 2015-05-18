function [root, class, model, view] = parsePath(filename)
    tokens = strsplit(char(filename), '[\\,/]', 'DelimiterType','RegularExpression');
    root = char(tokens(1));
    for i = 2:length(tokens)-2
       root = [root '/' char(tokens(i))];
    end
    class = char(tokens(end-1));
    tokens = char(tokens(end));
    if(tokens(1) == 'D')
        tokens = strsplit(char(tokens),  '[_,.]', 'DelimiterType','RegularExpression');
        model = char(tokens(1));
        view = char(tokens(3));
    else
        x = strfind(tokens, '_v');
        x2 = x+2;
	while(tokens(x2+1) ~= '_')
          x2 = x2+1;
        end
        model = char(tokens(1:x-1));
        view = char(tokens(x+1:x2));
    end

end
