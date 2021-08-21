function ExampleCIE_xy_from_upvp()
    upvp = struct('up',0.2105,'vp',0.4737); % same as xy = [0.333, 0.333]
    xyz = CIE_xy_from_upvp(upvp);  % call with struct with fields up, vp
    disp(xyz);
    xyz = CIE_xy_from_upvp([upvp.up, upvp.vp]);  % call with two element vector
    fprintf('xyz.x = %g, xyz.y = %g\n',xyz.x, xyz.y);
    xyz = CIE_xy_from_upvp(upvp.up, upvp.vp);  % call with two scalars
    fprintf('xyz.x = %g, xyz.y = %g\n',xyz.x, xyz.y);
end

