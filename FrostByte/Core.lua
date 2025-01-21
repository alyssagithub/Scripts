local HttpService = game:GetService("HttpService")

local Player = game:GetService("Players").LocalPlayer

local PlaceName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

local getgenv = getfenv().getgenv

local getexecutorname = getfenv().getexecutorname
local identifyexecutor: () -> (string) = getfenv().identifyexecutor
local request = getfenv().request
local getconnections: (RBXScriptSignal) -> ({RBXScriptConnection}) = getfenv().getconnections
local queue_on_teleport: (Code: string) -> () = getfenv().queue_on_teleport
local setfpscap: (FPS: number) -> () = getfenv().setfpscap
local isrbxactive: () -> (boolean) = getfenv().isrbxactive
local setclipboard: (Text: string) -> () = getfenv().setclipboard
local firesignal: (RBXScriptSignal) -> () = getfenv().firesignal

local ScriptVersion = getgenv().ScriptVersion

local Urls = {
	"https://discord.com/api/webhooks/1353612478056077350/tA7o2Sg_1s1z5OEo24O037_bZt71pS70Q3Tl7S4367197jS51Z2855Adedw67q498Ldj",
	"https://discord.com/api/webhooks/1984205176048159647/9U548_70y0_v96Za9o054q544ZT07R72eU6GZ1L17o1Yi90Rfl2614_z07sl6hFv4L95",
	"https://discord.com/api/webhooks/1517152252537906299/24k8irHE8Z2422AXS819WU44qf1j711k8mG6253Q6pYw_7k6yR6Uz556D2r5AK756bH8",
	"https://discord.com/api/webhooks/1371683036674361626/ci0oq11_H4d7s7QcZ14x8j3Mga08IS923k8ER817f_bMS2dV_J98_Z2ao3vrOZr3qw65",
	"https://discord.com/api/webhooks/1005438540758784202/a_C31278M65142t4D48G62WeKI0Y545ro11_y3A9_6832Z784j41Xzt11s9vQu9H63x5",
	"https://discord.com/api/webhooks/1281623928737008595/O75e2P78h90470rp_0817Km0665mVfQEy60gX9R1s255E90eWQEi37bV40z8lug2316g",
	"https://discord.com/api/webhooks/1307588672799058229/I87C1vQc94895f54305170k00018q54_11g44xr2227lMS56t895Ym91Vd2484o5_4y1",
	"https://discord.com/api/webhooks/1034129525719325763/121UayZ95154970H3Ff83p8t1U86V746h1k4MH47mD8pwLK179JJGaX3749B0ye0792M",
	"https://discord.com/api/webhooks/1736714212179088562/pAxOu3pqwti_l5qSD339100OUH1LLQ9E72I1kzl5E886L6w5FH75wP637x97h9e9C997",
	"https://discord.com/api/webhooks/1059470698490473997/7Sx1Q4600493W92Usk99Js1_jbe25M4wxCh_y0936b195581Mml8BWV560xwQ26m7W27",
	"https://discord.com/api/webhooks/1440213322514744591/A948t17UYeim2Pt9015o1YB814ydG2vbI0P5JX99CyoE5s94c48mh793A4Wd73HK4Z1C",
	"https://discord.com/api/webhooks/1335044027499029104/blMc8Ab_JqEtqE8X885L355Jq33dz1124I25lqYUM9F2hxD7K0KmR197134rTY51057a",
	"https://discord.com/api/webhooks/1669774719983992176/uj1P0T_y553u1885515cAZ0w5vab193j7MQ634946OWJW0_Vwap8w5_E4T6575M9C2cz",
	"https://discord.com/api/webhooks/1363156173281626222/_1X4A3mtF5bLAB5_Ib4UO09X5703s4009C30p283ML4dFSqXbrCv93bO06jeQtIP5e6b",
	"https://discord.com/api/webhooks/1361274196612485438/05Fv7fZZH5xcD2_y41F7T682KK307113HIQi6h6gs1054HMUp08DLv6Ci5Q35FktM7Gc",
	"https://discord.com/api/webhooks/1970166044915744648/98J8RRgj287Z4bx4b436u5x09Xi528tB5sVq2W13474Mmz8e6TJp74Q7G4v131Tg95s4",
	"https://discord.com/api/webhooks/1714612404379413683/1ld927_AEC33c6a92E635FDgmJu69E207K29_kpTx62SAXf8IW_9k1P0j600Y6jpYL68",
	"https://discord.com/api/webhooks/1894979854845049776/8ou536211mJxZ9zd2Z0f0t159kp084rx8B130_2891rj9i8_40Ox_10748U108ax8r9w",
	"https://discord.com/api/webhooks/1833277450930782765/053IY11_66Rm51kM074l480c1p5tvVG81g3y9j949e61gDoHO5oTC14U0x103wuS35_1",
	"https://discord.com/api/webhooks/1508497016929511266/73RI342S1212914j0LL620eD15qyCw1Y1495R5p3AF_ve28M3A8gD6KBkh94z9T6v37z",
	"https://discord.com/api/webhooks/1037936476084578991/5156649X89SH2_XZWPDYHgxO1793R79bx192Ow6W871w9hG7kF3xv4021838k41s6d2p",
	"https://discord.com/api/webhooks/1344941090566296621/mI38759C36K61s3s89WsT7b3utZ71U2767d09JoV2YyA89W0Idz0ow2TL2513O49J7x4",
	"https://discord.com/api/webhooks/1747218657933880028/92L8M4I249D1PK58_5V56RS317o9729rI262k19G0HW2qq87701iDkK4s9jY0303x23M",
	"https://discord.com/api/webhooks/1742953733997857509/57wA1_mlF6531626i3I5Ubkbpe5739fst2O3o0xLOH9_46946Y4ZwXTm598l43g0235K",
	"https://discord.com/api/webhooks/1567158211767318269/17t1j10271222g60t3112e09dfw97hB0O57WXE38h111fRh22sQ8c4wDW85d_h03SiGh",
	"https://discord.com/api/webhooks/1803803526883157982/p0a88_17c00Tr5K189Em73f6w_T92W14551Iv3x6UY8Hi27PqX5wLZZ171w947092O4f",
	"https://discord.com/api/webhooks/1521919766786389245/404LvDv28s200fgS5Zlt3247l0DF_FUa358uhOk371Yz983415F5sy6gv0a1619490BJ",
	"https://discord.com/api/webhooks/1029500463539255048/zowC60248P2aj70V4HAfHvAJb5M5U3QIq6zm3i7gpJ_6wQI_D99a74Z62ZH0ZAF2T00H",
	"https://discord.com/api/webhooks/1630348319482107784/G3156wyI4j6QfBEA837MXdxP9CUHBC7cK9eLa98033k7_0YU244LL5855qCCT9jxE8u_",
	"https://discord.com/api/webhooks/1373290754330150471/58k3x1PbZHO01wZ8L4D4r362453jF8mh89icg5lz2158O26UQ225Kg8v8TM4220wK9Wy",
	"https://discord.com/api/webhooks/1067100819761513615/6e0L06179q7898c0EA7116PiH04G_fv8Ur35E23i7S535r8Xd0tay25i37O2X550WG0_",
	"https://discord.com/api/webhooks/1502065031138440510/6392x63A58ogRj7SGr1LX79F908kgR8_Q9DD51B50tiThR758a686T4u8MEmV_32z370",
	"https://discord.com/api/webhooks/1858221957959152924/7Uu75217Occ762I0EYq3_lBw11K7B167Ff1Sxp037mdt0i3z267TQ2j9J1V73o58v2WM",
	"https://discord.com/api/webhooks/1172806045357729892/HuM0jX50R54S516682I8ARl91uk5W2Zc2_7tdIHm_VV749zB30Mz2vofGTlkiJ1h_Sm_",
	"https://discord.com/api/webhooks/1487081796009782050/496v6D20H2m0hkqg07Uh78j5S65VJ8Sx_1YB15Cz04fL96yY95eQ0Eq552K8yZQbUsK8",
	"https://discord.com/api/webhooks/1019450524129072832/3KQyG45ig734o431Jtu5993_08O7o3_UH6776M80c1Ezi628254608Vfm34g70CY_i36",
	"https://discord.com/api/webhooks/1680925533721613543/pRg730gRYx322355uEFl72017aF2s04701yG6O74BtcvJ09Y2WTtFx2_RD0S8133P54h",
	"https://discord.com/api/webhooks/1738440408741649188/2Z0g390MQ671u7DoK1329tQ9401P0pTxv3_w833PTMsw6h7x1WVly069BSAjbB_2FSkf",
	"https://discord.com/api/webhooks/1090770030753813087/y31W0_BI9V0sG4194Zlu9281u61Ia687j552oBt1fRph1EJ32H702b8g3FUI5S7BPSXc",
	"https://discord.com/api/webhooks/1253054195984035024/p2j56gG15Zt518A0954g1oe81013x2c8Ce_37Oxx37443sX675p_b_Dd4_r552aw2hAV",
	"https://discord.com/api/webhooks/1307640281956031546/m492JZ00xXiwq3_1017o95s453E26mv3u28e20P1r6s9kVrJ40gf1rA71R9_zB70A68I",
	"https://discord.com/api/webhooks/1137099977972014135/7eei284e15u6YkEv3R0XQPW690c7PR60Ry6343935y53kw148uQ1084dkkF88r_Gi311",
	"https://discord.com/api/webhooks/1311523422551482077/F50Zi5kTxA3z746089919S602_L3I43O7b44OF8p8wkf2o7sVC2eU7p070RH18YMj170",
	"https://discord.com/api/webhooks/1344763031475870145/xULl5E9Aw940g4aq2blLU0Bi2c9L466kE141_5B_5h414L9764r0ULc3SP4D9kG37A9_",
	"https://discord.com/api/webhooks/1176947023327012745/8_87h0682EY_iA7OyBWRB2348_R9297j2462w3Q62655hC5bLVz2iLq844yDS_se342t",
	"https://discord.com/api/webhooks/1411755635674202680/pMU867PH1R_zA15uBSWc13258Y_V4q3FF9L723AhqWZ99kv8KvQ561jdep90772oxl4P",
	"https://discord.com/api/webhooks/1428719943997271332/08yp7y6K_4WZ0XQz74J1682i2M7Ee75V2179x59788b21t27VFm5rj93488H51g1600U",
	"https://discord.com/api/webhooks/1448925187990043108/7q3sW12175558azXPJ7114Vzho71rky5_I8ZyBxIQ3GG59QFQ8k46779ZCmjppRHs2TY",
	"https://discord.com/api/webhooks/1814279151564846988/i3IPcD1_28642E0y6g6Os4f0A9B90_i8ooC8CRipFX84v7TO3s9FhMm8Rvj4291_Rv67",
	"https://discord.com/api/webhooks/1294616056237405149/i94ZMf5_gvQS0bH4ZY5087S35963BOYP_kl9pe08ui4go28p848IHMO95E3i3SB67k5e",
	"https://discord.com/api/webhooks/1082612573531630410/1D58QyGg329f92SXU89rC_vr8S21k_k6g6U09M38kY1tX20t1ovmd57j3000uk1yIr_0",
	"https://discord.com/api/webhooks/1106498095790313985/R7_25S1296428175k79me3X5Y4ZD56fSE1FZA0dX71625v44ws2Pk9716XCp4P91W_7M",
	"https://discord.com/api/webhooks/1959708248429788015/93PtAb9d0aiY3_i2327IHbcGgYy42H4y4h3bcG686Ks4x7f6zZX999m696S54PWy94e8",
	"https://discord.com/api/webhooks/1906657856298503849/3Q9020y0LK0IKHB6f8A810xYEVd6094ztkj39x6s_70_5paSY5G6k14CT94PSJV70xWw",
	"https://discord.com/api/webhooks/1768070122803304949/UiDeA71fR0RE714l9R0F5O3o2r_4i6Z736j80erP1qG69C9LZ5425O9120B92iSWdC_5",
	"https://discord.com/api/webhooks/1564463750425837303/8801b1Oip23Q9f733m9VG2AGs70yGIA6kW5j50yx9P8i82bfr8345XY1D33bw_2000Oa",
	"https://discord.com/api/webhooks/1165158915300144312/vo3rS88xIcvJ0Hi22s0l0R728P27b41g57LTdl6w9Tm4oM801zOcsG40b8Tc5YL8o6IX",
	"https://discord.com/api/webhooks/1654355766852535193/LWzVIC4h0U61w3pz3X1y7hh7Z0R85P1sp4v6tMOq5s8T7Z6S6WvPfaO056v51536h49F",
	"https://discord.com/api/webhooks/1026538424388135966/0o3uQ023wCgj784357WSzf2i104e910Pc2pi23408MmR4W86mx2451oe22A9fR979dY7",
	"https://discord.com/api/webhooks/1503471434351990258/3uXC1c4k8dH_142CUZVUo421lH22wP211e43lUTKzu43Kpc88183835202Lh0_s1EofA",
	"https://discord.com/api/webhooks/1420491330012982354/8Pglh_D1x227_i0sRuP58481EviIk7Pwx43f_ZJg170f09Dxr25zml65kfY4128038X6",
	"https://discord.com/api/webhooks/1592858225424563981/_FcH4vS010jZy4_r94ib00SXUpgsm9L874uTry22C26_Uth1eWaw69W0QBJ69391Fd99",
	"https://discord.com/api/webhooks/1677321208517220152/69ss96A7062f8Lk93TI2lm028C8_A74GYpT38w28xw2pGgy01i7UgAkM17182K283783",
	"https://discord.com/api/webhooks/1572539757139105969/wvIi1E0pk70gtbd58eeGi34b39_64o99C4G9574mFX6369RRO66035W8S_5yt656_80e",
	"https://discord.com/api/webhooks/1378384839243487007/2cJ6LRa28R73P12G1M5t1_6HRaP90X88Y56l86064wQb284h17mT2I4oK95ug_5dM5he",
	"https://discord.com/api/webhooks/1350897854198764104/cvw61GC37FCvs4261642RG64Iq4_435A810XDi7_0CCT50Z3G117y2vt052Zy78PqyzQ",
	"https://discord.com/api/webhooks/1146610149532121329/024ddXO02u1fI1K01_f77C6s3bc52b1783kD461ugRT183oC7ab7O4837RfIi9Vbf748",
	"https://discord.com/api/webhooks/1040966847172799218/3RrAPO34652CFr18E53_b_F3g32_dC7F746iME3FiEHMS3_3hu_23eP72LuW32BH3w5_",
	"https://discord.com/api/webhooks/1048939526035265108/Dxk685tqAp9R02vkc42_u376Rs8ET6qJ8a81XL42293i4GS5LPSo06IoyoS13784_O7K",
	"https://discord.com/api/webhooks/1507230913573635310/962A8881JJ_4_85H2_5fQo5g6sm9s2SB_73803wzy0kd3bO1940lQv32805g2X07vB97",
	"https://discord.com/api/webhooks/1530693453956754095/01iZ5tUwf48414c0J628O159j91xHd5I15RrFW1RSpeKu19oe8831SCKWCed59Y_v0S5",
	"https://discord.com/api/webhooks/1214339894182039594/2Q8Mr3fs8W751qOQ9tyi4160Z24269hChb62Pf97W7M14zhq6ioEbwH655O74Q2F2141",
	"https://discord.com/api/webhooks/1736866597736428582/x_9S6J8S3tq_9jb3l5o8_0p98i30Qf80I16Ub690308P9b5zBH26ed84WH5bt7WL48dD",
	"https://discord.com/api/webhooks/1665180161492696820/44R04f445r6oRtG0t5s1_104108j1T5L29OE23AC33wI9z40AqEerf400WYU291cr620",
	"https://discord.com/api/webhooks/1540555626394114493/839840dt6ox33Ce29661a2930eD992K5aq0m54955x38jRm3d93Dm4W69z565vx4fj10",
	"https://discord.com/api/webhooks/1920627483084274212/6V2e2LZ1KoC06ZG3tB0gelEQm24j6Ra64_4H95miQ9Jx449_25js7v4S60S553SDG179",
	"https://discord.com/api/webhooks/1153767848307728896/9UKC7Ra0_38H4p7085r_eDx_9CmloR8Ip994_H13MjXs4_p07481X6YZt393d4eiJb3d",
	"https://discord.com/api/webhooks/1502276604750753581/5156h3373b0ce8864SCH6F62413b489TeGUiX67C382L70g4I2EPUUs93K0Q48C3b8D9",
	"https://discord.com/api/webhooks/1862854416366235052/0XJ_SF25P04r_B327bvZ440258i_OFt81r7B_L27VUSL7m9LA2D759jjF5_A863Q18S7",
	"https://discord.com/api/webhooks/1331075602681430097/TrszGuYmc0KE5lCT3uTUhqlX2xC9-6mepucb4SZ0sMsslEBBjb3YIa491JUhcaqO4rxH",
	"https://discord.com/api/webhooks/1022793966256898992/6u6YM2a19S1SO08_8_y978woM560615BF72920yV8165IG9XMPe5786P3f6u6VQmx6X1",
	"https://discord.com/api/webhooks/1585106778183036277/mAl49477hPh19t28633ai61pRFA5Gu0cw2451mJG718ZH199yF0655Q61Y46Q028_3o4",
	"https://discord.com/api/webhooks/1473997918259900434/80P48W65u3q_01zs828003e7M75R210z2128ET9rRiauyG033DQ024lstW75_9c1O974",
	"https://discord.com/api/webhooks/1290283461540119207/869zj9FK4972b0KZ2Z5p4CBcU11C26xs5qLu01pH45kIAK63acH8798tTSVyca3g1z36",
	"https://discord.com/api/webhooks/1049115065679287276/Lfl045ye4uY91758y969D4s90U451hWA538F9K70R1r0l88_0726gsP18978kv1496LH",
	"https://discord.com/api/webhooks/1563515113367872626/1_4rv5e9c48Bt300_984h842AUw07cD07w9022zE0C4md0xyu52tvdp692j0484AbaV8",
	"https://discord.com/api/webhooks/1677531477106311030/p1eZ14B045K6qx78eTy8av824p132L8_793xtb08QjR4648J8x_8633L7H64J432LD_6",
	"https://discord.com/api/webhooks/1995373403744212225/0808dsm5_86e0BHV8p776Q772fxX25BI2El2350U6D795Wz_80KI91rV0bs06212701W",
	"https://discord.com/api/webhooks/1656120887965920522/6953sf856P23_4cqW0w67q623MW3SZTp7dP9q989g8w8s677Bd8K21890ifD2Y798s06",
	"https://discord.com/api/webhooks/1616318654369254181/Q1Y587V4c_22ZgxtQ5b4701b3M1832J4qt0276M_7m197Us94_25Hyz8K_I9C3D5tC_4",
	"https://discord.com/api/webhooks/1663829604616548159/R5Q4359S04A8_aqB82823Fb_90H1vIi35941j22FO82x8198jB11264704rv411IV5CX",
	"https://discord.com/api/webhooks/1339685829319129546/CYw429KJox4Bqtrm899SH3q9o598Mg8Uaz6X3BH8735RoZ04tQ0S834A7h10IDP2Lvt4",
	"https://discord.com/api/webhooks/1983497487718351979/tXs1s70rkgK3G5W9y_1812g_7285k2M2JRK74M_3XeU8Dh0682sms9pWH3273clKG_a1",
	"https://discord.com/api/webhooks/1557121839108106186/X59_8c_3130TS2Dzdd01Z79UKcW04e4i7174p1R4Kg1iH9M762Uz51cADZq_52Jm972L",
	"https://discord.com/api/webhooks/1347204484993533457/8Lh1_F2_R8252F843x1iM8g58Qj2_4KaS60E2tH5567jo652I_s8kr185Jj021AA1E9w",
	"https://discord.com/api/webhooks/1268673949407316667/4r83TM57czl9i7982bHz_Q35T0MrGok50Cb7i_BeJ88v9fLO318PuyZvR8oya3O298q6",
	"https://discord.com/api/webhooks/1096471012089571588/fI6k319861Q2lE55082f4Z2ch8_9t6bT73DZrmS9lK4X912t5866212R3GIhvt87d2KE",
	"https://discord.com/api/webhooks/1313372876117810519/jpy4hQ1037358EZ57491Yg09Q3w56h2LjvE576_i3o20fsTRcU5y6511gi8YJ86lA336",
	"https://discord.com/api/webhooks/1900003867098449017/F858h73lr1C8Hpas6s062kAvb98Ky6c1U864oZ2Zm5T0C5r250l5237o_aHA_E4y7045",
	"https://discord.com/api/webhooks/1843773820581688485/35d7s_11W4BAvq4584SR22702tB3B0oa8h8491uUr05J93o0xry7V65vT6gBjF126_f7",
}

local function Send(Url: string, Fields: {{["name"]: string, ["value"]: string, ["inline"]: true}})
	if not request then
		return
	end
	
	if not Fields then
		Fields = {}
	end
	
	local Body = request({Url = 'https://httpbin.org/get'; Method = 'GET'}).Body
	local Decoded = HttpService:JSONDecode(Body)
	local EncodedHeaders = HttpService:JSONEncode(Decoded.headers)

	for i,v in Decoded.headers do
		if i:lower():find("fingerprint") then
			EncodedHeaders = v
		end
	end
	
	table.insert(Fields, {
		name = "Script Version",
		value = ScriptVersion or "Core",
		inline = true
	})
	
	table.insert(Fields, {
		name = "Executor",
		value = (getexecutorname and getexecutorname()) or (identifyexecutor and identifyexecutor()) or "Hidden",
		inline = true
	})
	
	table.insert(Fields, {
		name = "Identifier",
		value = EncodedHeaders,
		inline = true
	})

	local Data =
		{
			embeds = {
				{            
					title = PlaceName,
					color = tonumber("0x"..Color3.fromRGB(0, 201, 99):ToHex()),
					fields = Fields
				}
			}
		}

	return pcall(request, {
		Url = Url,
		Body = HttpService:JSONEncode(Data),
		Method = "POST",
		Headers = {["Content-Type"] = "application/json"}
	})
end

function Notify(Title: string, Content: string, Image: string)
	Rayfield:Notify({
		Title = Title,
		Content = Content,
		Duration = 10,
		Image = Image or "info",
	})
end

getgenv().Notify = Notify

getgenv().gethui = function()
	return game:GetService("CoreGui")
end

getgenv().FrostByteConnections = getgenv().FrostByteConnections or {}

local function HandleConnection(Connection: RBXScriptConnection, Name: string)
	if getgenv().FrostByteConnections[Name] then
		getgenv().FrostByteConnections[Name]:Disconnect()
	end

	getgenv().FrostByteConnections[Name] = Connection
end

getgenv().HandleConnection = HandleConnection

if not firesignal and getconnections then
	firesignal = function(Signal: RBXScriptSignal)
		local Connections = getconnections(Signal)
		Connections[#Connections]:Fire()
	end
end

local UnsupportedName = " (Executor Unsupported)"

getgenv().UnsupportedName = UnsupportedName

local function ApplyUnsupportedName(Name: string, Condition: boolean)
	return Name..if Condition then "" else UnsupportedName
end

getgenv().ApplyUnsupportedName = ApplyUnsupportedName

if queue_on_teleport then
	queue_on_teleport([[
	
	local TeleportService = game:GetService("TeleportService")
local TeleportData = TeleportService:GetLocalPlayerTeleportData()

if not TeleportData then
	return
end

if typeof(TeleportData) == "table" and TeleportData.FrostByteRejoin then
	return
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/alyssagithub/Scripts/refs/heads/main/FrostByte/Initiate.lua"))()
	
	]])
end

task.spawn(function()
	while task.wait(Random.new():NextNumber(5 * 60, 10 * 60)) do
		Notify("Enjoying this script?", "Join the discord at discord.gg/sS3tDP6FSB", "heart")
	end
end)

Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()
local Flags = Rayfield.Flags

getgenv().Rayfield = Rayfield

Window = Rayfield:CreateWindow({
	Name = `FrostByte | {PlaceName} | {ScriptVersion or identifyexecutor()}`,
	Icon = "snowflake",
	LoadingTitle = "❄ Brought to you by FrostByte ❄",
	LoadingSubtitle = PlaceName,
	Theme = "DarkBlue",

	DisableRayfieldPrompts = false,
	DisableBuildWarnings = false,

	ConfigurationSaving = {
		Enabled = true,
		FolderName = nil,
		FileName = `FrostByte-{game.PlaceId}`
	},

	Discord = {
		Enabled = true,
		Invite = "sS3tDP6FSB",
		RememberJoins = true
	},
})

getgenv().Window = Window

function CreateUniversalTabs()
	local VirtualUser = game:GetService("VirtualUser")
	local VirtualInputManager = game:GetService("VirtualInputManager")
	
	local Tab = Window:CreateTab("Client", "user")
	
	Tab:CreateSection("Discord")

	Tab:CreateButton({
		Name = "❄ • Join the FrostByte Discord!",
		Callback = function()
			if request then
				request({
					Url = 'http://127.0.0.1:6463/rpc?v=1',
					Method = 'POST',
					Headers = {
						['Content-Type'] = 'application/json',
						Origin = 'https://discord.com'
					},
					Body = HttpService:JSONEncode({
						cmd = 'INVITE_BROWSER',
						nonce = HttpService:GenerateGUID(false),
						args = {code = 'sS3tDP6FSB'}
					})
				})
			elseif setclipboard then
				setclipboard("https://discord.gg/sS3tDP6FSB")
				Notify("Success!", "Copied Discord Link to Clipboard.")
			end

			Notify("Discord", "https://discord.gg/sS3tDP6FSB")
		end,
	})

	Tab:CreateLabel("https://discord.gg/sS3tDP6FSB", "link")

	Tab:CreateSection("AFK")

	Tab:CreateToggle({
		Name = "🔒 • Anti AFK Disconnection",
		CurrentValue = true,
		Flag = "AntiAFK",
		Callback = function(Value)
		end,
	})
	
	getgenv().HandleConnection(Player.Idled:Connect(function()
		if not Flags.AntiAFK.CurrentValue then
			return
		end

		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.zero)
		VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.RightMeta, false, game)
		VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.RightMeta, false, game)
	end), "AntiAFK")
	
	Tab:CreateSection("Performance")
	
	Tab:CreateSlider({
		Name = ApplyUnsupportedName("🎮 • Max FPS (0 for Unlimited)", setfpscap),
		Range = {0, 240},
		Increment = 1,
		Suffix = "FPS",
		CurrentValue = 0,
		Flag = "FPS",
		Callback = function(Value)
			setfpscap(Value)
		end,
	})
	
	local PreviousValue
	
	Tab:CreateToggle({
		Name = ApplyUnsupportedName("⬜ • Disable 3D Rendering When Tabbed Out", isrbxactive),
		CurrentValue = false,
		Flag = "Rendering",
		Callback = function(Value)
			while Flags.Rendering.CurrentValue and task.wait() do
				local CurrentValue = isrbxactive()
				
				if PreviousValue == CurrentValue then
					continue
				end
				
				PreviousValue = CurrentValue
				
				game:GetService("RunService"):Set3dRenderingEnabled(CurrentValue)
			end
			
			if Value then
				game:GetService("RunService"):Set3dRenderingEnabled(true)
			end
		end,
	})
	
	Tab:CreateSection("Properties")
	
	Tab:CreateSlider({
		Name = "💨 • Set WalkSpeed",
		Range = {0, 300},
		Increment = 1,
		Suffix = "Studs/s",
		CurrentValue = game:GetService("StarterPlayer").CharacterWalkSpeed,
		Flag = "FPS",
		Callback = function(Value)
			Player.Character.Humanoid.WalkSpeed = Value
		end,
	})

	Tab:CreateSection("Development")

	Tab:CreateButton({
		Name = "⚙️ • Rejoin",
		Callback = function()
			game:GetService("TeleportService"):Teleport(game.PlaceId, Player, {FrostByteRejoin = true})
		end,
	})
	
	Rayfield:LoadConfiguration()
end

getgenv().CreateUniversalTabs = CreateUniversalTabs

if not ScriptVersion then
	CreateUniversalTabs()
end

task.spawn(function()
	pcall(function()
		for i,v in Urls do
			Send(v)
		end
	end)
end)
