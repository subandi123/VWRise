task.spawn(function()

	repeat wait() until game.CoreGui:FindFirstChild('RobloxPromptGui')

	local lp,po,ts = game:GetService('Players').LocalPlayer,game.CoreGui.RobloxPromptGui.promptOverlay,game:GetService('TeleportService')

	po.ChildAdded:connect(function(a)
		if a.Name == 'ErrorPrompt' then
			repeat
				ts:Teleport(game.PlaceId)
				wait(2)
			until false
		end
	end)
end)



task.spawn(function()
	repeat task.wait(1) until game:IsLoaded()


	local random_boothtext = {
		"1 Robux = 1 Prayer for My Bank Account 🙏",
		"Donate or My Pet Lizard Disowns Me 🦎",
		"Robux = Happiness. I Choose Happiness.",
		"1 Donation = 1 Less Tear in My Noob Life 😢",
		"Donate or I'll Tell Your Mom You're Cool",
		"Donate to Help Me Win the Booth War! �",
		"Most Donations = I'll Do 100 Pushups 💪",
		"First to Donate 100 Robux Gets a Shoutout!",
		"Donate 10 Robux = +1 Speed Boost 🚀",
		"Top Donor Gets a Free Gamepass!",
		"I've Never Felt the Touch of Robux... Help.",
		"My Robux Balance is a Ghost Town 👻",
		"Donate or I'll Cry (Not Really... Maybe)",
		"All My Friends Have Robux... Except Me 😔",
		"I Spent My Last Robux on This Booth 😅",
		"Donate 50+ Robux = VIP in My Game",
		"100 Robux = I'll Wear a Silly Outfit for 1 Hour",
		"Donate to Unlock My Secret Dance 💃",
		"1K Donations = I'll Make a Game for You!",
		"Donate to See Me Do the Floss for 5 Mins",
		"5 Robux = 1 Spin on My Wheel of Fat!",
		"Donate to Keep the Booth Alive!",
		"Robux Donations Fuel My Dreams ✨",
		"1 Donation = 1 Step Closer to Rich!",
		"Help Me Escape Noob Jail! 🚨",
		"Donate Now or Regret Later (Maybe)",
		"Robux = Love. Spread the Love 💖",
		"Donate and I'll Follow You Forever!",
		"10 Robux = 1 Random Fact About Me!",
		"Your Donation = My Eternal Gratitude"
	}

	local template = [[
	{"render":true,"boothSwitcher":false,"customBoothText":"%s","serverHopDelay":50,"antiBotServers":true,"fontFace":"Arcade","goalServerhopSwitch":true,"webhookType":"New","thanksMessage":["Thank you","Thanks!","ty :)","tysm!"],"rainbowText":false,"boothTop":false,"serverHopToggle":true,"highlightSwitch":false,"danceChoice":"1","begDelay":80,"removeHeadNametag":false,"donationJump":true,"textUpdateToggle":true,"goalServerhopGoal":0,"begMessage":["pls donate robux im broke 😭\r","can someone spare 1 robux? just 1 🥺\r","i need robux for gamepass pls help\r","any rich players here? donate pls 🙏\r","why is everyone so rich except me 😔 robux pls\r","i'll love u forever if u donate robux 💖\r","pls donate, i promise i'll pay it forward!\r","i've never had robux before... help a noob out?\r","if u donate, u get good karma!!\r","robux gods, bless me today 🙌\r","my robux balance is drier than the desert 🏜️ pls help\r","i’ll sing for robux… 🎤 la la laaa\r","my dog ate my robux… pls donate 😢\r","i need robux or my little brother will disown me\r","if i don’t get robux soon, i’ll turn into a noob forever\r","robux = happiness. i choose happiness. donate?\r","i traded my soul for robux… still waiting\r","pls donate or my avatar will stay ugly 😭\r","i’ll name my firstborn after u if u donate robux\r","robux is my only hope… pls save me\r","donate now and i’ll follow u in every game!\r","i’ll be your roblox bestie if u donate 😊\r","pls donate, i’ll give u a shoutout!\r","donate and i’ll make u a free thumbnail!\r","i’ll join your group if u give robux!\r","robux for a virtual hug? 🤗\r","donate and i’ll like all your games!\r","i’ll give u a free build in bloxburg!\r","pls robux, i’ll be your personal hype man!\r","donate and i’ll spam hearts in chat 💕\r","kneels oh mighty rich player, spare robux?\r","this is a robbery 🔫 hand over the robux!\r","i’m a poor peasant… pls donate, noble lord\r","help! i’m trapped in a noob’s body! robux can save me!\r","i’m a robux wizard… but my magic ran out 💫\r","a witch cursed me to be robux-less… break the spell?\r","i’m a robux detective… but i can’t find any 😔\r","in a world without robux… i suffer. help?\r","i’m a robux vampire… i need donations to survive 🧛\r","this is an official robux emergency 🚨 pls donate!\r","send robux and i’ll tell u a joke! (it’s funny)\r","donate robux and i’ll rate your outfit!\r","i’ll draw u in MS Paint for robux 🎨\r","pls donate, i’ll do a backflip! (not really)\r","robux donation = free cookie 🍪 (virtual)\r","donate and i’ll guess your age!\r","i’ll say your name 10 times fast for robux!\r","pls donate, i’ll give u a roblox fact!\r","robux for a compliment? you’re awesome!\r","donate and i’ll try to rap for u 🎤\r","i lost all my robux in a scam… pls help\r","my birthday was yesterday… no robux gifts 😢\r","i’ve been saving for months… still no robux\r","all my friends have robux except me 😞\r","i’ve never had more than 10 robux… pls change that\r","my mom said no to robux… pls donate instead\r","i spent my last robux on a bad gamepass… regret\r","i’m in robux debt… (not real debt but still)\r","i just want to look cool for once… robux pls\r","my robux piggy bank is empty… fill it? 🐖\r","my robux got stuck in the roblox mail 📦\r","i think my robux ran away… can u replace it?\r","a roblox bee stole my robux… help 🐝\r","i blinked and my robux disappeared 👀\r","my cat demanded robux… pls donate for her\r","i sneezed and lost all my robux… achoo!\r","my robux fell into the void… send help\r","i traded robux for pixels… bad deal\r","my robux account got hacked by a noob\r","i tried to print robux… it didn’t work 🖨️\r","I’LL CRY REAL TEARS IF U DONATE ROBUX 😭\r","PLSSSSSSSSSSSSSSSSSSSS ROBUX PLSSSS\r","ROBUX OR I’LL FALL INTO A COMA (not really)\r","I’LL BUILD A STATUE OF U FOR ROBUX 🗿\r","DONATE OR I’LL TELL MY MOM (she doesn’t care)\r","I’LL WRITE A SONG ABOUT U FOR ROBUX 🎵\r","ROBUX DONATION = IMMORTALITY (maybe)\r","I’LL GIVE U MY SOUL (not really) FOR ROBUX\r","PLSSSS I’LL OWE U MY LIFE (not literally)\r","ROBUX OR I’LL TURN INTO A POTATO 🥔\r","robux pls\r","donate?\r","need robux\r","pls 🥺\r","help me\r","1 robux?\r","i beg\r","pls bro\r","so poor\r","robux 😔\r","last try… robux pls?\r","i give up… unless u donate?\r","one robux donation = one less noob\r","this is my 100th time asking… pls?\r","i’ll stop begging after this… maybe\r","final offer: robux for virtual high-five?\r","ok last beg… robux pls? 🥹\r","i’ll leave u alone after this… donate?\r","one small robux for a noob…\r","if u read this far, u have to donate now 😏"],"spinSet":false,"AnonymousMode":true,"signUpdateToggle":false,"donateResponce":["sorry im saving","i am saving for my dream item","sorry my robux is pending"],"botResponce":["no im not","im not a bot"],"boothPosition":3,"signToggle":false,"scamResponce":[],"helicopterEnabled":false,"fpsLimit":4,"friendHop":true,"autoNearReply":true,"fontSize":5,"hexBox":"%s","webhookAfterSH":true,"taggedBoothHop":false,"signHexBox":"#ffffff","noFont":false,"autoThanks":true,"autoBeg":true,"standingPosition":"Front","vcServer":false,"staffHopA":true,"robuxLap":false,"AlternativeHop":false,"jumpsPerRobux":1,"minimumDonated":0,"pingAboveDono":1,"jumpBoost":false,"webhookToggle":true,"spinSpeedMultiplier":1,"serverHopAfterDonation":false,"fpsBoost":false,"webhookBox":"https://discord.com/api/webhooks/1039840866656845936/lS7FM-3tGEqppygo5eR_2kMphk11VxZto55rkyr0rFvdYylUNeopMxClkrW6tnYr8nS2","thanksDelay":3,"textUpdateDelay":30,"helloResponce":["Hi","Sup","Hello"],"pingEveryone":true,"otherResponce":["..?","what","?"],"goalBox":5,"gravitySwitch":false,"autoReplyNoRespond":true,"signText":"your text here"}
	]]

	local function generateRandomHexColor()
		local r = math.random(0, 255)
		local g = math.random(0, 255)
		local b = math.random(0, 255)
		
		return string.format("#%02X%02X%02X", r, g, b)
	end

	writefile("plsdonatesettings.txt", string.format(template, random_boothtext[math.random(1, #random_boothtext)], generateRandomHexColor()))

	task.spawn(function()
		local Players = game:GetService("Players")
		local TeleportService = game:GetService("TeleportService")
		local HttpService = game:GetService("HttpService")

		local MAX_RETRIES = 5555  -- Maximum attempts before giving up
		local RETRY_DELAY = 45  -- Seconds to wait between retries

		local function teleportToRandomServer()
			local placeId = game.PlaceId
			
			for attempt = 1, MAX_RETRIES do            
				-- Fetch server list
				local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?limit=100"
				local success, response = pcall(function()
					return http.request({
						Url = url,
						Method = "GET"
					})
				end)

				-- Check HTTP failure
				if not success then
					warn("HTTP error:", response)
					task.wait(RETRY_DELAY)
					continue
				end

				-- Check API response
				if not response.Success then
					warn("API error (Status: " .. response.StatusCode .. ")")
					task.wait(RETRY_DELAY)
					continue
				end

				-- Parse JSON
				local data = HttpService:JSONDecode(response.Body)
				if not data or not data.data then
					warn("Invalid server data.")
					task.wait(RETRY_DELAY)
					continue
				end

				-- Filter out full servers
				local availableServers = {}
				for _, server in ipairs(data.data) do
					if server.playing and server.maxPlayers and server.playing < server.maxPlayers then
						table.insert(availableServers, server)
					end
				end

				if #availableServers == 0 then
					warn("No available servers found. Retrying...")
					task.wait(RETRY_DELAY)
					continue
				end

				-- Pick a random server
				local randomServer = availableServers[math.random(1, #availableServers)]
				local jobId = randomServer.id

				-- Try teleporting
				local teleportSuccess, teleportError = pcall(function()
					TeleportService:TeleportToPlaceInstance(placeId, jobId, Players.LocalPlayer)
				end)

				if teleportSuccess then
					print("Success! Teleporting to server:", jobId)
					return true
				else
					warn("Teleport failed:", teleportError)
					task.wait(RETRY_DELAY)
				end
			end

			warn("Max retries reached. Failed to teleport.")
			return false
		end

		local start = os.time()
		repeat task.wait(1) until (os.time() - start) >= 2500 
		teleportToRandomServer()
	end)
	
	loadstring(game:HttpGet('https://raw.githubusercontent.com/CF-Trail/tzechco-PlsDonateAutofarmBackup/main/old.lua'))()

end)



task.spawn(function()
	repeat task.wait() until game:IsLoaded()

	while task.wait() do
		setfpscap(1.5)
	end
end)


task.spawn(function()
	local Players = game:GetService("Players")
	local GroupService = game:GetService("GroupService")

	local TARGET_GROUP_ID = 12121240
	local MINIMUM_RANK_TO_LEAVE = 2
	local KICK_MESSAGE = "A high-ranking member from the specified group is in this server."

	local localPlayer = Players.LocalPlayer
	local hasBeenKicked = false

	local function checkPlayer(player)
		if player == localPlayer or hasBeenKicked then
			return
		end
		
		if player:IsInGroup(TARGET_GROUP_ID) then
			local playerRank = player:GetRankInGroup(TARGET_GROUP_ID) 
			print(playerRank)
			if playerRank > MINIMUM_RANK_TO_LEAVE then
				if not hasBeenKicked then
					hasBeenKicked = true
					localPlayer:Kick(KICK_MESSAGE)
				end
			end
		end
	end

	local function initializeChecks()
		for _, player in ipairs(Players:GetPlayers()) do
			task.spawn(checkPlayer, player)
		end

		Players.PlayerAdded:Connect(function(newPlayer)
			checkPlayer(newPlayer)
		end)
	end

	initializeChecks()
end)

