function [ labeled_points ] = clickA3DPointOnMesh( Mesh )

Mesh = samplePointsInMesh(Mesh);
labeled_points = clickA3DPoint(Mesh.v_sample);

end

