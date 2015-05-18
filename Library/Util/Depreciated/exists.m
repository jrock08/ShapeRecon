function ret = exists(elem, list)
  warning('Depreciated: Why is this called exists.')
  ret = any(strcmp(list, elem));
  return;

  %% Old impl
  %ret = 0;
  %for i = 1:length(list)
  %  if(strcmp(elem, list{i}))
  %    ret = 1;
  %    return;
  % end
  %end
end

