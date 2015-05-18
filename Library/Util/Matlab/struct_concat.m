function cat = struct_concat(varargin)

cat = varargin{1};

for i = 2:nargin
  f_ = fields(varargin{i});
  for f_idx = 1:numel(f_);
    f = f_{f_idx};
    if isfield(cat, f)
      if isstruct(cat.(f))
        cat.(f) = {cat.(f){:}, varargin{i}.(f){:}};
      else
        cat.(f) = [cat.(f), varargin{i}.(f)];
      end
    else
      cat.(f) = varargin{i}.(f);
  end
end

end
