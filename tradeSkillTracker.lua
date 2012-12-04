local skillFile = assert(io.open("tailoring", "r"), "Unable to open file")
local lines = {}
-- Read the lines in skillFile
for line in skillFile:lines() do
	table.insert(lines, line)
end
skillFile:close()

local input = io.read()
while input ~= "END" do
	print(input .. "~~~")
	io.flush()
	input = io.read()
end
