function [features_balanced, labels_balanced] = balancePosNeg(features,labels)

pos_map = labels > 0;
features_pos = features(pos_map);
labels_pos = labels(pos_map);
features_neg = features(~pos_map);
labels_neg = labels(~pos_map);

num_pos = sum(pos_map);
num_neg = sum(~pos_map);

N = min([num_pos,num_neg]);
