clear;clc;
n=5;
theta=1.5;
A=[2 2 2 3 1 1 1 1 1 1 1 1 2 1 1 1 1 1 0 2 3 1 1 1 1 1 0.1];
S=delete_zero(A,n,theta);

A_bar=connect_signal(S{1},S{3},S{4},length(A));
