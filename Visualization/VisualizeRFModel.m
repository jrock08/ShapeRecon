function [ ] = VisualizeRFModel( RF_model, iminfo )
down_tree(RF_model.tree.treeModels{1}, iminfo, RF_model.trainImages);
end


function down_tree(sub_tree, iminfo, rf_images)

if(isempty(sub_tree.left))
    vals = sub_tree.leftY;
    f = figure;
    internal_display(vals, iminfo, rf_images);
    uiwait(f);
else
    down_tree(sub_tree.left, iminfo, rf_images);
end

if(isempty(sub_tree.right))
    vals = sub_tree.rightY;
    f = figure;
    internal_display(vals, iminfo, rf_images);
    uiwait(f);
else
    down_tree(sub_tree.right, iminfo, rf_images);
end
end

function internal_display(vals, iminfo, rf_images)
for i = 1:numel(vals)
    [~, class, model, view] = parsePath(rf_images{vals(i)})
    iminfo_val = queryIminfo(iminfo, class, model, view);
    subplot(5,2,i);
    imshow(iminfo_val.depth);
end
end
