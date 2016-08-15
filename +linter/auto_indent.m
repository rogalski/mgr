% http://stackoverflow.com/questions/7861006/matlab-code-formatting-similar-to-astyle
function auto_indent(pattern)

files = dir(pattern);
files = {files.name};

for i=1:numel(files)
    doc = matlab.desktop.editor.openDocument( which(files{i}) );
    doc.smartIndentContents;
    doc.save;
    doc.close;
end

end
