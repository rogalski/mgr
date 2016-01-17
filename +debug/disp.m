function disp( s )
global DEBUG
if all(exist('DEBUG', 'var')) && all(DEBUG)
    disp(s)
    snapnow;
end
end
