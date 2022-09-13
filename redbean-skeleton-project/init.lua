-- builtin
--local sqlite3 = require('lsqlite3')
--local re = require('re')

-- rocks
local markdown = require('markdown')

function OnHttpRequest()
	if GetPath() == "/" then
		Write(markdown("# Hello, world!"))
	else
		Route()
	end
end

