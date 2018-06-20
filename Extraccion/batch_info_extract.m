warning off
clear all
%% Load images
pathfile = '..\..\Data\AgeDB';
files = dir(fullfile(pathfile,'*.jpg'));
nfile = length(files);
data = cell(nfile);
%% set parameters

    N = 90;
    M = 110;
    P = nfile; % number of subjects

    w = 24;
    s = 7;
    i1 = 1:s:N; i2 = i1+w-1; ii = find(i2>N); i1(ii) = []; i2(ii) = []; ni = length(i1);
    j1 = 1:s:M; j2 = j1+w-1; jj = find(j2>M); j1(jj) = []; j2(jj) = []; nj = length(j1);
    Z_train = zeros(fix(0.9*nfile)*ni*nj,59);
    Z_test  = zeros(fix(0.1*nfile)*ni*nj,59);
    tr = 0; te = 0;

    options.vdiv = 1;                  % one vertical divition 
    options.hdiv = 1;                  % one horizontal divition
    options.semantic = 0;              % classic LBP
    options.samples  = 8;              % number of neighbor samples
    options.mappingtype = 'u2';        % rot invariant lbp
    labels = zeros(nfile,1);

%% Extract

if ~exist('data_batch.mat')
    for k = 1:nfile
       disp(k*100/nfile)
       name = files(k).name;
       name_list = strsplit(name,'_');
       age = cell2mat(name_list(3));
       labels(k) = class_assign(age);
       I = imread(fullfile(pathfile,name));
       if length(size(I))>2
         I = rgb2gray(I);
       end
       I = imresize(I,[N M], 'bilinear');
       for i=1:ni
            for j=1:nj
                if mod(k,10)>0
                    tr = tr+1;
                    [X,Xn] = Bfx_lbp(I(i1(i):i2(i),j1(j):j2(j)),options);
                    Z_train(tr,:) = X;
                else
                    te = te+1;
                    Z_test(te,:) = Bfx_lbp(I(i1(i):i2(i),j1(j):j2(j)),options);
                end
            end
       end
    end
end


%% Class asign according to age

