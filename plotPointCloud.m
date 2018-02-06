clc
clear
close all

patientID = 'NS';
wall = 'Outer';
pointCloudFile = horzcat('C:\Users\Luke\Documents\sharedFolder\4YP\pointClouds\Regent_', patientID, '\', patientID, wall, 'PointCloud.csv');
M = csvread(pointCloudFile, 1, 0);
M(:, 3) = -1*M(:, 3);
M(2:2:end,:) = [];
M(2:2:end,:) = [];
M(2:2:end,:) = [];
M(2:2:end,:) = [];
%tri = delaunayTriangulation(M(:,1),M(:,2),M(:,3));
%tetramesh(tri)
pcshow(M)