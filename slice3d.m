function plane = slice3d(array3d,xyaxis,zslice)
% plane = slice3d(array3d,xyaxis,zslice)
%
% slice3d takes a 3d array and slices it along the plane given by xyaxis at
% the depth given by zslice and returns the 2d array of that slice. xyaxis
% is a 2 character string that can be 'xy','yx','zy','yz','xz', or 'zx'.
% Example,
% plane = slice3d(ncfopen('ZY',210,256),'xz',30);
% You can axis 'ZY' at coordinates (x,30,z,210) by calling plane(x,z)
    
    % since matlab's indexing starts at 1 and not 0
    zslice = zslice+1;
    
    if     strcmp(xyaxis,'yx')
        plane = permute(array3d(:,:,zslice),[2 1 3]);       
    elseif strcmp(xyaxis,'xy')
        plane = permute(array3d(:,:,zslice),[1 2 3]);  
    elseif strcmp(xyaxis,'zx')
        plane = permute(array3d(:,zslice,:),[3 1 2]);
    elseif strcmp(xyaxis,'xz')
        plane = permute(array3d(:,zslice,:),[1 3 2]);
    elseif strcmp(xyaxis,'zy')
        plane = permute(array3d(zslice,:,:),[3 2 1]);
    elseif strcmp(xyaxis,'yz')
        plane = permute(array3d(zslice,:,:),[2 3 1]);
    else
        error ('xyaxis is not the right format')
    end
end

