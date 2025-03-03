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

	gethwid = function()
		local gethwid: () -> string = getfenv().gethwid

		local HWID = gethwid()

		assert(typeof(HWID) == "string", "Returned value should be a string.")

		return HWID
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

	gettenv = function()
		local gettenv: (thread | () -> ()) -> {[string]: any} = getfenv().gettenv

		local Success = pcall(gettenv, function() end)

		assert(not Success, "Function should error when providing a non-thread value.")

		local ThreadEnvironment = gettenv(task.spawn(function() end))

		assert(typeof(ThreadEnvironment) == "table", "Function should return a table.")

		for FunctionName in ThreadEnvironment do
			assert(getfenv()[FunctionName], `Function does not contain all values in getfenv(). Missing value: {FunctionName}`)
		end
	end,
	
	getfenv = function()
		local Environment = getfenv()
		assert(typeof(Environment) == "table", "Function should return a table.")
		
		local getgenv: () -> {[string]: any} = getfenv().getgenv
		
		assert(getgenv, "'getgenv' does not exist and is required for this test.")
		
		for Name, Value in getgenv() do
			if typeof(Value) ~= "table" and typeof(Value) ~= "function" then
				continue
			end
			
			assert(Environment[Name], `Missing '{Name}' from the global environment in the function environment.`)
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

	dofile = function()
		local dofile: (Path: string) -> any? = getfenv().dofile

		local writefile: (Path: string, Data: string) -> () = getfenv().writefile

		assert(writefile, "'writefile' does not exist, and is required for this test.")

		local FileName = `File_{math.random()}.txt`
		local GeneratedNumber = math.random()

		writefile(FileName, `return \{{GeneratedNumber}\}`)

		local Result = dofile(FileName)

		local delfile: (Path: string) -> () = getfenv().delfile

		if delfile then
			delfile(FileName)
		end

		assert(typeof(Result) == "table", "Function test should've returned a table based on this test's given code.")

		assert(Result[1] == GeneratedNumber, "Function's table should've contained the test's randomly generated number.")
	end,

	loadfile = function()
		local loadfile: (Path: string, ChunkName: string?) -> ((any?) -> (any?)?, string?) = getfenv().loadfile

		local writefile: (Path: string, Data: string) -> () = getfenv().writefile

		assert(writefile, "'writefile' does not exist, and is required for this test.")

		local FileName = `File_{math.random()}.txt`
		local GeneratedNumber = math.random()

		writefile(FileName, "local number = ...; return number + 1")

		local LoadedFunction, Error = loadfile(FileName)

		local delfile: (Path: string) -> () = getfenv().delfile

		if delfile then
			delfile(FileName)
		end

		local Result = assert(LoadedFunction, Error)(GeneratedNumber)

		assert(Result == GeneratedNumber + 1, "Function did not return the correct number.")
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

		assert(isfolder(FolderName), "Folder was not found after it was made.")

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

	-- Closures/Functions
	iscclosure = function()
		local iscclosure: (Function: (any?) -> ()) -> (boolean) = getfenv().iscclosure

		assert(iscclosure(assert), "Function 'assert' is written in C and should return true.")

		assert(not iscclosure(function() end), "A function created in the executor is not written in C.")
	end,

	isluau = function()
		local isluau: () -> boolean = getfenv().isluau

		assert(isluau() == (_VERSION == "Luau"), "Did not properly check if the current function is running in Luau.")
	end,

	clonefunction = function()
		local clonefunction: ((any?) -> any?) -> ((any?) -> any?) = getfenv().clonefunction

		local GeneratedNumber = math.random()

		local function Original()
			return GeneratedNumber
		end

		local Clone = clonefunction(Original)

		assert(Clone ~= Original, "Cloned and original function should not have the same reference.")

		assert(Clone() == Original(), "Cloned and original function should return the same value.")
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

		type Parameters = {
			Url: string,
			Body: string?,
			Method: string,
			Headers: {
				["Content-Type"]: "application/json"
			}?
		}

		local request: (Parameters) -> Request = getfenv().request

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

		assert(Success, `Failed to require module '{Module.Name}' with error:`, Result)

		return Module.Name
	end,

	ismoduleloaded = function()
		local ismoduleloaded: (ModuleScript) -> boolean = getfenv().ismoduleloaded

		local Module = game:FindFirstChildWhichIsA("ModuleScript", true)

		assert(Module, "Could not find a ModuleScript in this game, try another for accurate results.")

		assert(ismoduleloaded(Module), "Function returned false when the module is loaded.")
	end,

	getloadedmodules = function()
		local getloadedmodules: () -> {ModuleScript} = getfenv().getloadedmodules

		local Module = game:FindFirstChildWhichIsA("ModuleScript", true)

		assert(Module, "Could not find a ModuleScript in this game, try another for accurate results.")

		local LoadedModules = getloadedmodules()

		assert(typeof(LoadedModules) == "table", "Function did not return a table.")

		assert(table.find(LoadedModules, Module), "Could not find a loaded module in the returned table.")
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
	end,

	fireproximityprompt = function()
		local fireproximityprompt: (ProximityPrompt) -> () = getfenv().fireproximityprompt

		local Part = Instance.new("Part")
		Part.Parent = workspace

		local ProximityPrompt = Instance.new("ProximityPrompt")
		ProximityPrompt.Parent = Part

		local WasTriggered = false

		ProximityPrompt.Triggered:Once(function(Player)
			if Player == game:GetService("Players").LocalPlayer then
				WasTriggered = true
			end
		end)

		fireproximityprompt(ProximityPrompt)

		local Start = tick()

		repeat
			task.wait()
		until WasTriggered or tick() - Start >= 1

		Part:Destroy()

		assert(WasTriggered, "Function did not fire the ProximityPrompt's Triggered signal.")
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
		type Connections = {
			RBXScriptConnection & {
				Fire: (self: RBXScriptConnection, any?) -> ()
			}
		}

		local getconnections: (RBXScriptSignal) -> Connections = getfenv().getconnections

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

	gethui = function()
		local gethui: () -> Instance = getfenv().gethui

		local HiddenUI = gethui()

		assert(typeof(HiddenUI) == "Instance", "Function does not return an instance.")

		assert(not HiddenUI:IsA("CoreGui"), "Returned object should not be the CoreGui.")

		assert(not HiddenUI:IsA("PlayerGui"), "Returned object should not be the PlayerGui.")
	end,

	getscripts = function()
		local getscripts: () -> {BaseScript} = getfenv().getscripts

		local Scripts = getscripts()

		assert(typeof(Scripts) == "table", "Function should return a table.")

		assert(Scripts[1], "Table should have at least one value inside.")

		for _, CurrentScript: BaseScript | ModuleScript in Scripts do
			assert(typeof(CurrentScript) == "Instance", `The listed value {CurrentScript} is not an instance.`)

			local ClassCheck = CurrentScript:IsA("BaseScript") or CurrentScript:IsA("ModuleScript")

			assert(ClassCheck, `The listed instance '{CurrentScript}' is not a script. ClassName: {CurrentScript.ClassName}`)
		end
	end,

	-- Client
	setfpscap = function()
		local setfpscap: (FPSCap: number) -> () = getfenv().setfpscap
		
		local function GetCurrentFPS(): number
			return math.floor(1 / game:GetService("Stats").FrameTime)
		end
		
		local HighestFPS = 0
		local LastPeak = tick()
		
		while tick() - LastPeak <= 0.25 and task.wait() do
			local FPS = GetCurrentFPS()
			
			if FPS == math.huge then
				continue
			end
			
			if FPS > HighestFPS then
				HighestFPS = FPS
				LastPeak = tick()
			end
		end

		local FPSCap = math.floor(HighestFPS / 4)

		setfpscap(FPSCap)

		local StartLoop = tick()
		
		local FPS

		repeat
			FPS = GetCurrentFPS()
			task.wait()
		until FPS <= FPSCap or tick() - StartLoop >= 5

		setfpscap(0)

		assert(FPS <= FPSCap, `FPS was determined to still stay above the set FPS cap. FPS: {FPS}, FPS Cap: {FPSCap}`)

		return `FPS: {FPS}, FPS Cap: {FPSCap}, Highest FPS: {HighestFPS}`
	end,

	-- Misc
	getreg = function()
		local getreg: () -> {[string]: any} = getfenv().getreg

		local Registry = getreg()

		assert(typeof(Registry) == "table", "Function should return a table.")
	end,

	-- Encryption
	base64encode = function()
		local base64encode: (string) -> string = getfenv().base64encode

		local base64decode: (string) -> string = getfenv().base64decode

		assert(base64decode, "'base64decode' does not exist and is required for this test.")

		local GeneratedString = tostring(math.random())

		local Encoded = base64encode(GeneratedString)

		assert(Encoded ~= GeneratedString, "Function should not return the same string as the one given.")

		local Decoded = base64decode(Encoded)

		assert(Decoded == GeneratedString, "Decoded version should return back to the original string.")

		return `Encoded: {Encoded}, Decoded: {Decoded}`
	end,
	
	testing = function()
		return "test ing t h i s"
	end,
}

local NoTests = {
	"firetouchinterest",
	"rconsoleclear",
	"rconsolecreate",
	"rconsoledestroy",
	"rconsoleinput",
	"rconsoleprint",
	"rconsolename",
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
	"setclipboard",
	"queueonteleport",
	"isreadonly",
	"setreadonly",
	"makereadonly",
	"getrawmetatable",
	"setrawmetatable",
	"newcclosure",
	"isnewcclosure",
	"hookmetamethod",
	"getnamecallmethod",
	"setnamecallmethod",
	"decompile",
	"gethiddenproperties",
	"gethiddenproperty",
	"sethiddenproperty",
	"setsimulationradius",
	"getcallingscript",
	"isscriptable",
	"lz4decompress",
	"setfflag",
	"isfunctionhooked",
	"cloneref",
	"setscriptable",
	"loadstring",
	"setthreadidentity",
	"isrbxactive",
	"getstack",
	"getupvalue",
	"setupvalue",
	"getnilinstances",
	"setstack",
	"getinfo",
	"base64_encode",
	"getconstant",
	"getscriptclosure",
	"checkcaller",
	"setrenderproperty",
	"setconstant",
	"getinstances",
	"getconstants",
	"compareinstances",
	"getcustomasset",
	"getscripthash",
	"getrunningscripts",
	"base64_decode",
	"getfpscap",
	"cleardrawcache",
	"isrenderobj",
	"isparallel",
	"getactors",
	"islclosure",
	"getsenv",
	"lz4compress",
	"getfflag",
	"getscriptbytecode",
	"getgc",
	"base64decode",
	"restorefunction",
	"getcallbackvalue",
	"run_on_actor",
	"getrenderproperty",
	"getthreadidentity",
	"getproto",
	"getprotos",
	"getupvalues",
	"messagebox",
	"info",
	"isexecutorclosure",
	"rconsolehide",
	"getinstancecache",
	"get_process_identifier",
	"getmodules",
	"rconsoleinfo",
	"get_comm_channel",
	"isvalidlevel",
	"getproperties",
	"dbg",
	"getcallbackmember",
	"lift_closure",
	"get_signal_cons",
	"rconsoletop",
	"getscriptfromthread",
	"rconsolehidden",
	"create_comm_channel",
	"saveinstance",
	"lift_and_load_closure",
	"isnetworkowner",
	"rconsoletoggle",
	"iscustomcclosure",
	"gethookcache",
	"runfile",
	"validlevel",
	"getcallstack",
	"keyclick",
	"rconsolewarn",
	"clearteleportqueue",
	"iswriteble",
	"makewritable",
	"makewriteable",
	"rconsoleshow",
	"iswindowactive",
	"rconsoleerr",
	"getbspval",
	"detourfunction",
	"clearimmediatecache",
	"checkparallel",
	"keytap",
	"getallthreads",
	"createsecurefolder",
	"replacefunction",
	"getrendersteppedlist",
	"issecuredinstance",
	"inparallel",
	"checkpressedkey",
	"decompilesync",
	"iskeydown",
	"getfunctionhash",
	"filtergc",
	"getnspval",
	"executescript",
	"disassociate_script",
	"run_on_thread",
	"getobjects",
	"httppost",
	"setsecureinstance",
	"getthreadobject",
	"getsafeenv",
	"getunionassetid",
	"getpcd",
	"getactorthreads",
	"setnormalinstance",
	"setsafeenv",
	"getsimulationradius",
	"comparefunctions",
	"httpget",
	"messageboxasync",
	"setrbxclipboard",
	"defersignal",
}

local LibraryNoTests: {[string]: {string}} = {
	Drawing = {
		"new",
		"clear",
		"Fonts",
	},
	debug = {
		"getconstants",
		"getconstant",
		"setconstant",
		"getprotos",
		"getproto",
		"getstack",
		"setstack",
		"getupvalues",
		"getupvalue",
		"setupvalue",
		"getinfo",
		"getregistry",
		"validlevel",
		"isvalidlevel",
		"setname",
	},
	base64 = {
		"encode",
		"decode",
	},
	http = {
		"request",
	},
	crypt = {
		"base64encode",
		"base64decode",
		"encrypt",
		"decrypt",
		"generatebytes",
		"generatekey",
		"hash",
		"base64_decode",
		"base64",
		"base64_encode",
		"hex",
		"rsa",
		"derive",
		"unwrap_key",
		"wrap_key",
		"hmac",
	},
	input = {
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
		"mouse1press",
	},
	cache = {
		"invalidate",
		"iscached",
		"replace",
	},
	WebSocket = {
		"connect",
		"Connect",
		"new",
		"New",
	},
	websocket = {
		"connect",
	},
	bit = {
		"band",
		"arshift",
		"rshift",
		"ror",
		"bor",
		"bnot",
		"badd",
		"bsub",
		"bxor",
		"tobit",
		"bswap",
		"rol",
		"lshift",
		"tohex",
		"bdiv",
		"bmul",
		"bpopcount",
	},
	SecureTable = {
		"new",
	},
	math = {
		"erf",
		"dist",
		"set_symmetric_difference",
		"lgamma",
		"vector_dot_product",
		"transform_translate",
		"log1p",
		"modular_inverse",
		"next_prime",
		"matrix_add",
		"set_union",
		"modular_exponentiation",
		"transform_scale",
		"matrix_multiply",
		"isclose",
		"gamma",
		"atanh",
		"matrix_inverse",
		"comb",
		"transform_rotate",
		"acosh",
		"matrix_determinant",
		"set_contains",
		"matrix_create",
		"tau",
		"vector_normalize",
		"vector_add",
		"e",
		"log2",
		"asinh",
		"isfinite",
		"expm1",
		"sumprod",
		"matrix_transpose",
		"remainder",
		"prod",
		"nextafter",
		"exp2",
		"erfc",
		"gcd",
		"set_difference",
		"vector_cross_product",
		"set_cardinality",
		"set_intersection",
		"matrix_multiply_gemm",
		"matrix_subtract",
		"is_prime",
		"lcm",
		"vector_subtract",
		"vector_magnitude",
	},
	DrawingImmediate = {
		"GetPaint",
		"Clear",
		"New",
	},
	Duration = {
		"FromMonths",
		"FromMilliseconds",
		"FromYears",
		"TimeSinceEpoch",
		"FromHours",
		"FromNanoseconds",
		"FromMicroseconds",
		"FromSeconds",
		"FromMinutes",
		"FromDays",
		"new",
	},
	Stopwatch = {
		"new",
	},
	DirectoryWatcher = {
		"new",
	},
	csv = {
		"getRow",
		"getField",
		"stringify",
		"parse",
	},
	Regex = {
		"Escape",
		"new",
	},
}

local Aliases: {[string]: {string}} = {
	hookfunction = {"replaceclosure"},
	queueonteleport = {"queue_on_teleport", "queueteleport"},
	request = {"http_request"},
	isexecutorclosure = {
		"checkclosure",
		"isourclosure",
		"istempleclosure",
		"is_synapse_function",
		"issentinelclosure",
		"is_sirhurt_closure",
		"is_protosmasher_closure",
	},
	rconsoleclear = {"consoleclear"},
	rconsolecreate = {"consolecreate"},
	rconsoledestroy = {"consoledestroy"},
	rconsoleinput = {"consoleinput"},
	rconsoleprint = {"consoleprint"},
	rconsolename = {"rconsolesettitle", "consolesettitle", "consolename"},
	isrbxactive = {"isgameactive"},
	identifyexecutor = {"getexecutorname"},
	setclipboard = {"toclipboard"},
	getscriptbytecode = {"dumpstring"},
	getscriptclosure = {"getscriptfunction"},
	getthreadidentity = {"getidentity", "getthreadcontext", "get_thread_identity", "get_thread_context"},
	setthreadidentity = {"setidentity", "setthreadcontext", "set_thread_identity", "set_thread_context"},
	gethui = {"get_hidden_gui"},
	saveinstance = {"saveplace"},
	clearteleportqueue = {"clear_teleport_queue"},
	getreg = {"getregistry"},
	getinstances = {"getinstancelist"},
	getrenv = {"getmenv"},
	gethiddenproperty = {"gethiddenprop"},
	firesignal = {"replicatesignal"},
}

local Documentation = {
	Duration = "https://docs.zenith.win/API%20Reference/Duration/"
}

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

for OriginalFunctioName, FunctionAliases in Aliases do
	assert(Tests[OriginalFunctioName], `A test for the function {OriginalFunctioName} does not exist, and cannot have aliases.`)

	for _, Alias in FunctionAliases do
		assert(not Tests[Alias], `A test for the alias '{Alias}' exists and needs to be removed.`)
	end
end

local getgenv = getfenv().getgenv or function() return {} end

local Settings: {[string]: boolean} = {
	FakeFunctions = getgenv().FakeFunctions or false,
	CopyUnaddedTests = getgenv().CopyUnaddedTests or false
}

if Settings.FakeFunctions then
	for FunctionName in Tests do
		if FunctionName == "getgenv" then
			continue
		end
		
		getgenv()[FunctionName] = function()
			
		end
	end
end

local TotalTests = 0
local CompletedTests = 0
local FailedTests = 0
local ThoroughTests = 0
local NonThoroughTests = 0

local function RunTest(FunctionName: string, Callback: (any) -> (any?, any?), LibraryName: string?)
	TotalTests += 1
	
	if Callback == Default then
		NonThoroughTests += 1
	else
		ThoroughTests += 1
	end

	local Start = tick()

	local Success, Result: string? = pcall(function()
		local ToIndex = getfenv()

		if LibraryName then
			ToIndex = getfenv()[LibraryName]

			assert(ToIndex, `The '{LibraryName}' library does not exist.`)
		end

		local Function = ToIndex[FunctionName]

		assert(Function, "Function does not exist.")

		local FunctionType = typeof(Function)

		assert(FunctionType == "function", "Does not have typeof 'function', typeof:", FunctionType)

		return Callback()
	end)

	local ElapsedTime = math.round((tick() - Start) * 100) / 100
	
	if not Success and Result and Result:find(":") then
		local Split = Result:split(": ")
		Result = Split[#Split]
	end
	
	local AliasFor
	
	for OriginalFunctionName: string, FunctionAliases in Aliases do
		for _, AliasFunctionName in FunctionAliases do
			if AliasFunctionName == FunctionName then
				AliasFor = OriginalFunctionName
			end
		end
	end
	
	local ShowcaseLibrary = if LibraryName then `{LibraryName}.` else ""
	local ShowcaseMainFunction = if AliasFor then ` ({AliasFor})` else ""
	local ShowcaseResult = if Result ~= nil then `: {Result}` else ""
	local ShowcaseTime = if ElapsedTime > 0 then ` - took {ElapsedTime} seconds` else ""
	local ShowcaseDocs = if not Success and LibraryName and Documentation[LibraryName] then ` | Docs: {Documentation[LibraryName]}` else ""

	local Name = `{ShowcaseLibrary}{FunctionName}{ShowcaseMainFunction}{ShowcaseResult}{ShowcaseTime}{ShowcaseDocs}`

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
			if typeof(Callback) == "function" then
				getfenv(Callback)[FunctionName] = getfenv()[Alias]
				Callback()
			end
		end)
	end
end

repeat
	task.wait()
until CompletedTests + FailedTests == TotalTests

local TestService = game:GetService("TestService")

local identifyexecutor = getfenv().identifyexecutor
local getexecutorname = getfenv().getexecutorname

local ExecutorName = if identifyexecutor then identifyexecutor() elseif getexecutorname then getexecutorname() else "Unknown Executor"

local function DisplayMessage(MessageToDisplay)
	local DisplayFunction: (any?) -> ()

	if ExecutorName == "AWP" then
		DisplayFunction = print
	else
		DisplayFunction = function(Message)
			TestService:Message(Message)
		end
	end

	DisplayFunction(MessageToDisplay)
end

DisplayMessage(`❓ The score below is only for how many custom functions are supported.`)
DisplayMessage(`🔵 debUNC BETA v0.0.9 Score for {ExecutorName}: {math.floor(CompletedTests / TotalTests * 100)}%`)
DisplayMessage(`⚪ Total tests: {TotalTests}`)
DisplayMessage(`🟢 Successful tests: {CompletedTests}`)
DisplayMessage(`🔴 Failed tests: {FailedTests}`)
DisplayMessage(`🟣 Thorough tests: {ThoroughTests}`)
DisplayMessage(`🟠 Non-thorough tests: {NonThoroughTests}`)

print("------------------------------------------------------------------------------------------------")
print("For development purposes, a list of stuff in getfenv() and getgenv() that isn't added to the test.")
print("------------------------------------------------------------------------------------------------")

local AlreadyChecked = {}
local Copy = ""

local getrenv = getfenv().getrenv or function() return {} end

local RobloxEnvironment = if typeof(getrenv()) == "table" then getrenv() else {}

local function Check(Name: string, Value)
	if Tests[Name] and typeof(Tests[Name]) ~= "table" then
		return
	end

	if (typeof(Value) == "function" and RobloxEnvironment[Name]) or Name == "shared" or Name == "_G" or Name == "script" then
		return
	end
	
	if typeof(Value) ~= "table" and typeof(Value) ~= "function" then
		return
	end

	local IsAlias = false

	for _, FunctionAliases in Aliases do
		if table.find(FunctionAliases, Name) then
			IsAlias = true
		end
	end

	if IsAlias then
		return
	end
	
	if AlreadyChecked[Name] then
		return
	end

	AlreadyChecked[Name] = true
	
	if typeof(Value) == "function" then
		Copy ..= `"{Name}",\n`
		return
	end
	
	local AddedLibrary = false

	for FunctionInLibraryName, FunctionInLibraryValue in Value do
		if (RobloxEnvironment[Name] and RobloxEnvironment[Name][FunctionInLibraryName]) then
			continue
		end
		
		local LibraryTest = Tests[Name]
		
		if typeof(LibraryTest) == "table" and LibraryTest[FunctionInLibraryName] then
			continue
		end
		
		if not AddedLibrary then
			Copy ..= `{Name} = \{\n`
			AddedLibrary = true
		end
		
		local PathName = `{Name}.{FunctionInLibraryName}`
		AlreadyChecked[PathName] = true
		
		Copy ..= `	"{FunctionInLibraryName}",\n`
	end
	
	if AddedLibrary then
		Copy ..= "},\n"
	end
end

for Name, Value in getfenv() do
	Check(Name, Value)
end

for Name, Value in getgenv() do
	Check(Name, Value)
end

if Settings.CopyUnaddedTests and Copy ~= "" then
	local setclipboard = getfenv().setclipboard
	
	setclipboard(Copy)
end

if Copy == "" then
	Copy = "Could not find any functions/libraries, this executor is all caught up."
end

print(Copy)

print("------------------------------------------------------------------------------------------------")
print("All enabled/disabled settings")
print("------------------------------------------------------------------------------------------------")
for SettingName: string, SettingEnabled: boolean in Settings do
	print(`getgenv().{SettingName} = {SettingEnabled}`)
end
print("------------------------------------------------------------------------------------------------")
