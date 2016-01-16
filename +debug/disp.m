function disp( varargin )
global DEBUG
if all(exist('DEBUG', 'var')) && all(DEBUG)
    disp(varargin{:})
    snapnow;
end
end
