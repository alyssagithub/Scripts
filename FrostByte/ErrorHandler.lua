local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")

local PlaceName = MarketplaceService:GetProductInfo(game.PlaceId).Name

local Webhook = "https://disc".."ord.com/api/webhooks/1323494310267588700/uyWe".."y6sZ4Nb_8Qmtg8608Lc".."8cqzrXt2ox6TJqEdk-qXFPSC4QdLXGqJ9OF4vDaHSwH"

local function SendLog(Error)
	local Data =
		{
			embeds = {
				{            
					title = PlaceName,
					color = tonumber(51555),
					fields = {
						{
							name = "Executor",
							value = (getexecutorname and getexecutorname()) or (identifyexecutor and identifyexecutor()) or "Hidden",
							inline = true
						},
						{
							name = "Error",
							value = Error,
							inline = true
						},
					}
				}
			}
		}

	pcall((syn and syn.request) or (http and http.request) or http_request or request, {
		Url = "https://disc".."ord.com/api/webhooks/1323494310267588700/uyWe".."y6sZ4Nb_7Qmtg8608Lc".."8cqzrXt2ox6TJqEydk-qXFP6C4QdLXGqJ9OFL4vDaHSwH",
		Body = HttpService:JSONEncode(Data),
		Method = "POST",
		Headers = {["Content-Type"] = "application/json"}
	})
end

local Success, Result = pcall(loadstring(LoadLink))

if not Success then
	SendLog(Result)
end
