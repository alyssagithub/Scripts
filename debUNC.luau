--!strict
local Tests: {[string]: {[string]: (any?) -> (any?, any?)} | () -> ()}
Tests = {
	-- Identification
	identifyexecutor = function()
		local identifyexecutor: () -> (string, string) = getfenv().identifyexecutor

		local Name, Version = identifyexecutor()

		assert(typeof(Name) == "string", "Function does not return a string name as the first value.")

		assert(typeof(Version), "Function does not return a string version as the second value.")

		return `{Name} {Version}`
	end,
	
	-- Environments
	getrenv = function()
		local getrenv: () -> {[string]: any} = getfenv().getrenv

		local RobloxEnvironment = getrenv()

		assert(typeof(RobloxEnvironment) == "table", "Function does not return a table.")
		
		local ShouldHave = {
			"delay",
			"elapsedTime",
			"printidentity",
			"settings",
			"spawn",
			"stats",
			"tick",
			"time",
			"typeof",
			"UserSettings",
			"version",
			"wait",
			"warn",
			"ypcall",
			
			"Enum",
			"game",
			"shared",
			"workspace"
		}
		
		for _, FunctionName: string in ShouldHave do
			assert(RobloxEnvironment[FunctionName], `Missing '{FunctionName}' in the returned table.`)
		end
	end,
	
	getgenv = function()
		local getgenv: () -> {[string]: any} = getfenv().getgenv

		local GlobalEnvironment = getgenv()

		assert(typeof(GlobalEnvironment) == "table", "Function does not return a table.")

		for FunctionName in getfenv() do
			assert(GlobalEnvironment[FunctionName], `Function '{FunctionName}' does not exist in the returned table.`)
		end
	end,
	
	-- Files
	readfile = function()
		local readfile: (Path: string) -> string = getfenv().readfile

		local Success, Result = pcall(readfile, "doesntexist.txt")

		assert(not Success, "Function doesn't error when reading a non-existent file.")

		local writefile: (Path: string, Data: string) -> () = getfenv().writefile

		assert(writefile, "'writefile' does not exist, and is required for this test.")

		local GeneratedResult = tostring(math.random())
		local FileName = `File_{math.random()}.txt`

		writefile(FileName, GeneratedResult)

		local Result = readfile(FileName)

		assert(Result == GeneratedResult, "Test file did not return what was written into it.")
		
		local delfile: (Path: string) -> () = getfenv().delfile

		if delfile then
			delfile(FileName)
		end

		return FileName
	end,
	
	writefile = function()
		local writefile: (Path: string, Data: string) -> () = getfenv().writefile
		
		local readfile: (Path: string) -> string = getfenv().readfile
		
		assert(readfile, "'readfile' does not exist, and is required for this test.")
		
		local GeneratedResult = tostring(math.random())
		local FileName = `File_{math.random()}.txt`
		
		writefile(FileName, GeneratedResult)
		
		local Result = readfile(FileName)
		
		assert(typeof(Result) == "string", "'readfile' failed to read the file, cannot continue test.")
		
		assert(Result == GeneratedResult, "'writefile' did not write to the file.")
		
		local delfile: (Path: string) -> () = getfenv().delfile

		if delfile then
			delfile(FileName)
		end
		
		return FileName
	end,
	
	isfile = function()
		local isfile: (Path: string) -> boolean = getfenv().isfile
		
		local FileName = `File_{math.random()}.txt`
		
		assert(not isfile("???"), "Function returned true when a file cannot exist with this name.")
		
		local writefile: (Path: string, Data: string) -> () = getfenv().writefile
		
		assert(writefile, "'writefile' does not exist, and is required for this test.")
		
		writefile(FileName, "Test")
		
		assert(isfile(FileName), "Function returned false after a file of the same name was written to.")
		
		local delfile: (Path: string) -> () = getfenv().delfile

		if delfile then
			delfile(FileName)
		end
		
		return FileName
	end,
	
	appendfile = function()
		local appendfile: (Path: string, Data: string) -> () = getfenv().appendfile
		
		local readfile: (Path: string) -> string = getfenv().readfile
		
		assert(readfile, "'readfile' does not exist, and is required for this test.")
		
		local GeneratedResult = tostring(math.random())
		local FileName = `File_{math.random()}.txt`
		
		appendfile(FileName, GeneratedResult)
		
		assert(readfile(FileName) == GeneratedResult, "Function failed to create and/or write to the file.")
		
		appendfile(FileName, "Append")
		
		assert(readfile(FileName):find("Append"), "Failed to add to the existing file.")
		
		local delfile: (Path: string) -> () = getfenv().delfile

		if delfile then
			delfile(FileName)
		end
		
		return FileName
	end,
	
	listfiles = function()
		local listfiles: (Path: string) -> {string} = getfenv().listfiles
		
		local writefile: (Path: string, Data: string) -> () = getfenv().writefile
		
		assert(writefile, "'writefile' does not exist, and is required for this test.")
		
		local makefolder: (Path: string) -> () = getfenv().makefolder
		
		assert(makefolder, "'makefolder' does not exist, and is required for this test.")
		
		local FolderName = `Folder_{math.random()}`
		
		local Success = pcall(listfiles, "???")
		
		assert(not Success, "Function did not error when listing the files of a non-existent folder.")
		
		makefolder(FolderName)
		
		assert(typeof(listfiles(FolderName)) == "table", "Function did not return a table.")
		
		local GeneratedResult = tostring(math.random())
		local FileName = `{FolderName}\\{`File_{math.random()}.txt`}`
		
		writefile(FileName, GeneratedResult)
		
		local Result = listfiles(FolderName)
		
		assert(Result[1] == FileName, "Function did not find the written file.")
		
		local delfolder: (Path: string) -> () = getfenv().delfolder

		if delfolder then
			delfolder(FolderName)
		end
		
		return FileName
	end,
	
	delfile = function()
		local delfile: (Path: string) -> any? = getfenv().delfile
		
		local writefile: (Path: string, Data: string) -> () = getfenv().writefile

		assert(writefile, "'writefile' does not exist, and is required for this test.")
		
		local isfile: (Path: string) -> boolean = getfenv().isfile
		
		assert(isfile, "'isfile' does not exist, and is required for this test.")
		
		local Success, Result = pcall(delfile, "???")
		
		assert(not Success, "Function should error when attempting to delete a file that does not exist.")
		
		local FileName = `File_{math.random()}.txt`
		
		writefile(FileName, "Test")
		
		assert(isfile(FileName), "Failed to write to the file, cannot continue test.")
		
		delfile(FileName)
		
		assert(not isfile(FileName), "'isfile' returned true after file was meant to be deleted.")
		
		return FileName
	end,
	
	-- Folders
	makefolder = function()
		local makefolder: (Path: string) -> () = getfenv().makefolder
		
		local isfolder: (Path: string) -> boolean = getfenv().isfolder
		
		assert(isfolder, "'isfolder' does not exist, and is required for this test.")
		
		assert(not isfolder("???"), "'isfolder' returned true when checking if a non-existent folder existed.")
		
		local FolderName = `Folder_{math.random()}`
		
		makefolder(FolderName)
		
		assert(isfolder(FolderName), "Folder was not found by 'isfolder' after it was made.")
		
		local delfolder: (Path: string) -> () = getfenv().delfolder

		if delfolder then
			delfolder(FolderName)
		end
		
		return FolderName
	end,
	
	isfolder = function()
		local isfolder: (Path: string) -> boolean = getfenv().isfolder

		local makefolder: (Path: string) -> () = getfenv().makefolder
		
		assert(makefolder, "'makefolder' does not exist, and is required for this test.")
		
		assert(not isfolder("???"), "Function returned true when checking if a non-existent folder existed.")
		
		local FolderName = `Folder_{math.random()}`
		
		makefolder(FolderName)

		assert(isfolder(FolderName), "Folder was not found by 'isfolder' after it was made.")
		
		local delfolder: (Path: string) -> () = getfenv().delfolder
		
		if delfolder then
			delfolder(FolderName)
		end
		
		return FolderName
	end,
	
	delfolder = function()
		local delfolder: (Path: string) -> () = getfenv().delfolder
		
		local makefolder: (Path: string) -> () = getfenv().makefolder

		assert(makefolder, "'makefolder' does not exist, and is required for this test.")
		
		local isfolder: (Path: string) -> boolean = getfenv().isfolder

		assert(isfolder, "'isfolder' does not exist, and is required for this test.")
		
		assert(not isfolder("???"), "'isfolder' returned true when checking if a non-existent folder existed.")
		
		local FolderName = `Folder_{math.random()}`
		
		makefolder(FolderName)

		assert(isfolder(FolderName), "Folder was not found by 'isfolder' after it was made.")
		
		delfolder(FolderName)
		
		assert(not isfolder(FolderName), "'isfolder' found the folder after it should've been deleted.")
		
		return FolderName
	end,
	
	-- Hooking
	hookfunction = function()
		local hookfunction: (FunctionToHook: () -> (), Hook: () -> ()) -> (() -> ()) = getfenv().hookfunction

		local GeneratedResult = math.random()

		local function Test()
			return GeneratedResult
		end

		local OtherGeneratedResult = math.random() + 1

		local Hook = hookfunction(Test, function()
			return OtherGeneratedResult
		end)

		assert(typeof(Hook) == "function", "Hookfunction did not return the original function.")

		assert(Hook() == GeneratedResult, "Original function does not return the value it's meant to.")

		assert(Test() == OtherGeneratedResult, "Hooked function does not return the value it's meant to.")
	end,
	
	-- Closures
	iscclosure = function()
		local iscclosure: (Function: (any?) -> ()) -> (boolean) = getfenv().iscclosure

		assert(iscclosure(assert), "Function 'assert' is written in C and should return true.")

		assert(not iscclosure(function() end), "A function created in the executor is not written in C.")
	end,
	
	-- HTTP
	request = function()
		type Request = {
			StatusCode: number,
			StatusMessage: string,
			Headers: {
				Connection: string,
				["Content-Length"]: number,
				["Access-Control-Allow-Credentials"]: boolean,
				["Access-Control-Allow-Origin"]: string,
				Date: string,
				["Content-Type"]: string,
				Server: string
			},
			Body: string
		}

		local request: ({Url: string, Body: string?, Method: string, Headers: {["Content-Type"]: "application/json"}?}) -> Request = getfenv().request

		local Result = request({
			Url = "https://httpbin.org/get",
			Method = "GET"
		})

		assert(typeof(Result) == "table", "Function did not return a table.")

		local StatusCode = Result.StatusCode

		assert(typeof(StatusCode) == "number", "Status Code is not a number.")

		local StatusMessage = Result.StatusMessage

		assert(typeof(StatusMessage) == "string", "Status Message is not a string.")

		local Headers = Result.Headers

		assert(typeof(Headers) == "table", "Headers is not a table.")

		assert(Headers.Date, "Headers does not contain the Date.")

		local Body = Result.Body

		assert(typeof(Body) == "string", "Body is not a string.")

		local Decoded = game:GetService("HttpService"):JSONDecode(Body)

		assert(Decoded.url, "Decoded body does not contain the url.")

		assert(Decoded.origin, "Decoded body does not contain the origin.")

		local DecodedHeaders = Decoded.headers

		assert(DecodedHeaders, "Decoded body does not contain the headers.")

		--assert(typeof(DecodedHeaders["Roblox-Place-Id"]) == "string", "Decoded headers Roblox-Place-Id is not a string.")

		--assert(typeof(DecodedHeaders.Exploitidentifier) == "string", "Decoded headers Exploitidentifier is not a string.")

		--assert(typeof(DecodedHeaders["Exploit-Guid"]) == "string", "Decoded headers Exploit-Guid is not a string.")

		local Fingerprint

		for i,v in DecodedHeaders do
			if i:lower():find("fingerprint") then
				Fingerprint = v
				break
			end
		end

		assert(Fingerprint, "Decoded headers does not contain an executor fingerprint.")

		return `StatusCode: {StatusCode}, StatusMessage: {StatusMessage}`
	end,
	
	-- Instances
	require = function()
		local Module = game:FindFirstChildWhichIsA("ModuleScript", true)
		
		assert(Module, "Could not find a ModuleScript in this game, try another for accurate results.")
		
		local Success, Result = pcall(require, Module)
		
		assert(Success, "Failed to require module:", Result)
		
		return Module.Name
	end,
	fireclickdetector = function()
		local fireclickdetector: (ClickDetector) -> () = getfenv().fireclickdetector
		
		local ClickDetector = Instance.new("ClickDetector")
		
		local WasClicked = false
		
		ClickDetector.MouseClick:Once(function(Player)
			if Player == game:GetService("Players").LocalPlayer then
				WasClicked = true
			end
		end)
		
		fireclickdetector(ClickDetector)
		
		local Start = tick()
		
		repeat
			task.wait()
		until WasClicked or tick() - Start >= 1
		
		assert(WasClicked, "Function did not fire the ClickDetector's MouseClick signal.")
		
		ClickDetector:Destroy()
	end,
	firesignal = function()
		local firesignal: (RBXScriptSignal, any?) -> () = getfenv().firesignal
		
		local NumberValue = Instance.new("NumberValue")
		
		local GeneratedValue = math.random()
		
		local DidChange = false
		
		NumberValue.Changed:Once(function(Value)
			if Value == GeneratedValue then
				DidChange = true
			end
		end)
		
		firesignal(NumberValue.Changed, GeneratedValue)
		
		local Start = tick()
		
		repeat
			task.wait()
		until DidChange or tick() - Start >= 1
		
		assert(DidChange, "Failed to fire the signal.")
	end,
	getconnections = function()
		local getconnections: (RBXScriptSignal) -> ({RBXScriptConnection & {Fire: (self: RBXScriptConnection, any?) -> ()}}) = getfenv().getconnections
		
		local NumberValue = Instance.new("NumberValue")
		
		local DidChange = false
		
		local GeneratedValue = math.random()
		
		NumberValue.Changed:Once(function(Value)
			if GeneratedValue == Value then
				DidChange = true
			end
		end)
		
		local Connections = getconnections(NumberValue.Changed)
		
		assert(typeof(Connections) == "table", "Function must return a table.")
		
		assert(#Connections == 1, "Function should have 1 connection in the returned table when only connected to once.")
		
		local ChangedConnection = Connections[1]
		
		assert(ChangedConnection.Fire, "The 'Fire' function is not in the connection's table.")
		
		ChangedConnection:Fire(GeneratedValue)
		
		local Start = tick()

		repeat
			task.wait()
		until DidChange or tick() - Start >= 1
		
		assert(DidChange, "Failed to fire the connection.")
	end,
}

local NoTests = {
	"firetouchinterest",
	"rconsoleclear",
	"rconsolecreate",
	"rconsoledestroy",
	"rconsoleinput",
	"rconsoleprint",
	"rconsolesettitle",
	"mouse1click",
	"mouse1press",
	"mouse1release",
	"mouse2click",
	"mouse2press",
	"mouse2release",
	"mousemoveabs",
	"mousemoverel",
	"mousescroll",
	"keypress",
	"keyrelease",
	--"setrbxclipboard",
	"setclipboard",
	--"getclipboard",
	"queueonteleport",
	"getreg",
	"getidentity",
	"setidentity",
	"isreadonly",
	"setreadonly",
	"makereadonly",
	--"makewriteable",
	"getrawmetatable",
	"setrawmetatable",
	"newcclosure",
	"isnewcclosure",
	"hookmetamethod",
	"getnamecallmethod",
	"setnamecallmethod",
	--"disassemble",
	"decompile",
	"gethiddenproperties",
	"gethiddenproperty",
	"sethiddenproperty",
	--"getsimulationradius",
	"setsimulationradius",
	"clonefunction",
	"getcallingscript",
	"isscriptable",
	"lz4decompress",
	"setfflag",
	"setthreadcontext",
	"toclipboard",
	"getthreadcontext",
	"isfunctionhooked",
	--"isluau",
	"cloneref",
	"setscriptable",
	"loadstring",
	"setthreadidentity",
	"isrbxactive",
	"getstack",
	"getupvalue",
	--"httpget",
	"setupvalue",
	--"getregistry",
	"getnilinstances",
	"dumpstring",
	"gettenv",
	--"getinstancelist",
	"setstack",
	"getinfo",
	"base64_encode",
	"getconstant",
	"getscriptclosure",
	"checkcaller",
	"setrenderproperty",
	--"ismoduleloaded",
	"setconstant",
	"getinstances",
	"getconstants",
	"compareinstances",
	"gethui",
	"getscripts",
	"getcustomasset",
	"getscripthash",
	--"getmenv",
	"getloadedmodules",
	"getrunningscripts",
	"base64_decode",
	"getfpscap",
	"cleardrawcache",
	"isrenderobj",
	"isparallel",
	"getactors",
	"getscriptfunction",
	"islclosure",
	"getsenv",
	"lz4compress",
	"getfflag",
	"getscriptbytecode",
	--"defersignal",
	"gethwid",
	"getgc",
	--"base64decode",
	--"base64encode",
	"setfpscap",
	"restorefunction",
	--"istempleclosure",
	"getcallbackvalue",
	"loadfile",
	"dofile",
	"run_on_actor",
	"fireproximityprompt",
	"getrenderproperty",
	"getthreadidentity",
	"getproto",
	"getprotos",
	"getupvalues",
	"messagebox",
	"info",
	"isexecutorclosure",
	
}

local LibraryNoTests: {[string]: {string}} = {
	Drawing = {
		"new"
	},
	debug = {
		"getconstants",
		"getconstant",
		"setconstant",
		"getprotos",
		"getproto",
		--"setprotos",
		--"setproto",
		"getstack",
		"setstack",
		"getupvalues",
		"getupvalue",
		"setupvalue",
	},
	base64 = {
		"encode",
		"decode",
	},
	http = {
		"request"
	},
	crypt = {
		"base64encode",
		"base64decode",
		"encrypt",
		"decrypt",
		"generatebytes",
		"generatekey",
		"hash"
	},
	--[[input = {
		"mouse2release",
		"keyrelease",
		"mousemoveabs",
		"keypress",
		"mousemoverel",
		"mouse2click",
		"mouse2press",
		"mousescroll",
		"mouse1click",
		"mouse1release",
		"mouse1press"
	},]]
	cache = {
		"invalidate",
		"iscached",
		"replace"
	},
	WebSocket = {
		"connect"
	},
}

local Aliases: {[string]: {string}} = {
	hookfunction = {"replaceclosure"},
	queueonteleport = {"queue_on_teleport"},
	request = {"http_request"},
	isexecutorclosure = {"checkclosure", "isourclosure"},
	rconsoleclear = {"consoleclear"},
	rconsolecreate = {"consolecreate"},
	rconsoledestroy = {"consoledestroy"},
	rconsoleinput = {"consoleinput"},
	rconsoleprint = {"consoleprint"},
	rconsolesettitle = {"rconsolename", "consolesettitle"},
	isrbxactive = {"isgameactive"},
	identifyexecutor = {"getexecutorname"},
	setclipboard = {"toclipboard"},
	getscriptbytecode = {"dumpstring"},
	getscriptclosure = {"getscriptfunction"},
	getthreadidentity = {"getidentity", "getthreadcontext", "get_thread_identity"},
	setthreadidentity = {"setidentity", "setthreadcontext", "set_thread_identity"},
}

for _, FunctionAliases in Aliases do
	for _, Alias in FunctionAliases do
		assert(not Tests[Alias], `A test for the alias '{Alias}' exists and needs to be removed.`)
	end
end

local function Default()
	return "Non-thorough test"
end

for TableName, FunctionName in NoTests do
	assert(not Tests[FunctionName], `A test for {FunctionName} already exists.`)
	
	Tests[FunctionName] = Default
end

for LibraryName, LibraryFunctionNames in LibraryNoTests do
	local NewLibrary = {}
	
	for _, FunctionName: string in LibraryFunctionNames do
		assert(not NewLibrary[FunctionName], `A test for {LibraryName}.{FunctionName} already exists.`)

		NewLibrary[FunctionName] = Default
	end
	
	Tests[LibraryName] = NewLibrary
end

local TotalTests = 0
local CompletedTests = 0
local FailedTests = 0
local ThoroughTests = 0
local NonThoroughTests = 0

local function RunTest(FunctionName: string, Callback: (any) -> (any?, any?), LibraryName: string?)
	TotalTests += 1
	
	local Start = tick()
	
	local Success, Result = pcall(function()
		local ToIndex = getfenv()
		
		if LibraryName then
			ToIndex = getfenv()[LibraryName]
			
			assert(ToIndex, `The '{LibraryName}' library does not exist.`)
		end
		
		local Function = ToIndex[FunctionName]

		assert(Function, "Function does not exist.")

		local FunctionType = typeof(Function)

		assert(FunctionType == "function", "Does not have typeof 'function', typeof:", FunctionType)
		
		if Callback == Default then
			NonThoroughTests += 1
		else
			ThoroughTests += 1
		end

		return Callback()
	end)
	
	local ElapsedTime = math.round((tick() - Start) * 100) / 100
	
	local ShowcaseResult = if Result ~= nil then `: {Result}` else ""
	local ShowcaseLibrary = if LibraryName then `{LibraryName}.` else ""
	local ShowcaseTime = if ElapsedTime > 0 then ` - took {ElapsedTime} seconds` else ""
	
	local Name = `{ShowcaseLibrary}{FunctionName}{ShowcaseResult}{ShowcaseTime}`

	if Success then
		CompletedTests += 1
		print(`🟢 {Name}`)
	else
		FailedTests += 1
		warn(`🔴 {Name}`)
	end
end

for FunctionName, Callback in Tests do
	if typeof(Callback) == "table" then
		
		for LibraryFunctionName, LibraryCallback in Callback do
			task.spawn(RunTest, LibraryFunctionName, LibraryCallback, FunctionName)
		end
	else
		task.spawn(RunTest, FunctionName, Callback)
	end
	
	local FunctionAliases = Aliases[FunctionName]
	
	if not FunctionAliases then
		continue
	end
	
	for _, Alias in FunctionAliases do
		task.spawn(RunTest, Alias, function()
			--assert(getfenv()[Alias] == getfenv()[FunctionName], "Alias does not point to the original function.")
			return "Alias"
		end)
	end
end

repeat
	task.wait()
until CompletedTests + FailedTests == TotalTests

local TestService = game:GetService("TestService")

local identifyexecutor = getfenv().identifyexecutor
local getexecutorname = getfenv().getexecutorname

TestService:Message(`🔵 debUNC BETA v0.0.2 Score for {if identifyexecutor then identifyexecutor() elseif getexecutorname then getexecutorname() else ""}: {math.floor(CompletedTests / TotalTests * 100)}%`)
TestService:Message(`⚪ Total tests: {TotalTests}`)
TestService:Message(`🟢 Successful tests: {CompletedTests}`)
TestService:Message(`🔴 Failed tests: {FailedTests}`)
TestService:Message(`🟣 Thorough tests: {ThoroughTests}`)
TestService:Message(`🟠 Non-thorough tests: {NonThoroughTests}`)

print("For development purposes, a list of stuff in getgenv() that isn't added to the test.")
local getgenv = getfenv().getgenv
local getrenv = getfenv().getrenv

for Name, Value in getgenv() do
	if Tests[Name] then
		continue
	end
	
	if getrenv()[Name] then
		continue
	end
	
	local IsAlias = false
	
	for _, FunctionAliases in Aliases do
		if table.find(FunctionAliases, Name) then
			IsAlias = true
		end
	end
	
	if IsAlias then
		continue
	end
	
	print(`Missing {Name}, Type: {typeof(Value)}`)
	
	if typeof(Value) ~= "table" then
		continue
	end
	
	for FunctionInLibraryName, FunctionInLibraryValue in Value do
		print(`Missing {Name}.{FunctionInLibraryName}, Type: {typeof(Value)}`)
	end
end
