function spy( varargin )
global DEBUG
if all(exist('DEBUG', 'var')) && all(DEBUG)
    spy(varargin{:})
    snapnow;
end
end
