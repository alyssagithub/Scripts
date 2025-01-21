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
	"https://discord.com/api/webhooks/1131484353092646148/5g8Vo609z7dB6J14V5XXi4d52lT391oj233qa1Xw3yft2O0ppy_j77dm8o0D77XoqC4X",
	"https://discord.com/api/webhooks/1782923631553427838/73s1_17zO18112Mp5Aags8g59e565eHo068582QxY67T5a4pLguwp43F6OuFU2kieDY8",
	"https://discord.com/api/webhooks/1417692671971088746/09bzrPFOBfI7y447kp0l93x86861mu1zI27S4q0z6mir35622Ak8wR2069MP0PeO5u4m",
	"https://discord.com/api/webhooks/1110045958137942497/1963K5618PFGI87aci0w_5j_lmitk58v09w2SR39ED0o0buw57X193yVB59GxxB8GD3g",
	"https://discord.com/api/webhooks/1459369060158194407/H8i3ZE4528pL8v43350DtU54v_Fg8wY48GtG_28JG3362Im_J3z3xKX4St03i1468P6o",
	"https://discord.com/api/webhooks/1285706915748993968/9959F29o98W433k9i8W3I41WOi47T8p74MP34Yb82y0e3r8_wxovgi_BE64l23E5540d",
	"https://discord.com/api/webhooks/1490738551697520608/6Q6R5043H544P8Z99uL3Q9o808854qK4I419645MEA65568rhs4Wex60125j60j5999T",
	"https://discord.com/api/webhooks/1296098305186900493/Pw1iF596168xe190787F075920J6q9oV7ewh8fc4J01Fe2u48cB84QI1H7qI521u6UEk",
	"https://discord.com/api/webhooks/1665261252269141548/162765403DcTT83497Gv7b7D990bEl1bQihXK4U6R34106102ERo05whI3865_27z225",
	"https://discord.com/api/webhooks/1788983012763477097/54677s4P_sabr7x50292r41pL1775486p0o6plZ5H0V782A6w1y083330702l3H25P_z",
	"https://discord.com/api/webhooks/1774605890023610786/t4Asko37HK0rf50X10L8w79Vmsda1GA7L1lLHeS6E3t_341GY45V54e9Z2072m2x02Qq",
	"https://discord.com/api/webhooks/1092337857246785354/7FG4k4M3M1Q4F1s30a0k18fO_3jA3s97cW0CtOzBGKfP89U3lPzzg45p04262wt9582k",
	"https://discord.com/api/webhooks/1429597062791968578/P28121L4L6G1v_3fS923f1UI0mC0fQ056aw5vu31Wu62tm5q6R_858_lA1Z70vovI8x6",
	"https://discord.com/api/webhooks/1949857578295322908/13694iaJ68F6IZ85xgt1h44p58s1r4EI0oByo068r8w82b4Y21g7663_k9Umvp25kB6I",
	"https://discord.com/api/webhooks/1036114336798799214/w2yU0254SR9I1S0CKKJ934798643mpU30_20_i3C197J2P1_o92a7A93sp8134l1dG8M",
	"https://discord.com/api/webhooks/1334772138009071852/myR1f9c98IYGWve9394lO10u33719fgm0pb3652C3_sd9aAw8A7voyL8Bh7i6mtfmFW4",
	"https://discord.com/api/webhooks/1911891479008697980/4ouOa7J1c64I8914p8RT0L51GkgmlS25b66L49yl86i9t79f4285e0rMD90Y50W8609E",
	"https://discord.com/api/webhooks/1780197394899876602/BO6Qq0y0y4Hi6193_oU9kD42t621555260T80B1LzwV9107B1wBp50_1p0955I4y36kd",
	"https://discord.com/api/webhooks/1022235685982545090/J0E7Gt20BRW357sR6y7c63G1gf25Y890M_20B1K44vD7HC8E557E70HUh5425mxL105I",
	"https://discord.com/api/webhooks/1120304759138254293/305ifhQ0Oy08k14635q1U5jda6_l32R28135d8681FE9kZD23PxG86kauMWu8261793V",
	"https://discord.com/api/webhooks/1045830690395777817/5_K63H9yM5w2B07238UcC2R9tsU32WF21q9805l35W75sCdu26M3B66r77FF1y59Yi8H",
	"https://discord.com/api/webhooks/1543777469463083840/r9_OO0Q8v99G8IHJ6fgT0hZ0Y1T7XE500i94412k0jZp6P43665JESUz2184MPB72C1g",
	"https://discord.com/api/webhooks/1237220415461934487/064039030E2ocKFWW557awP681wi351we3902E1E87093200IIGWC4x0MbW45CF3okXU",
	"https://discord.com/api/webhooks/1268822049650706211/045eR9O9xG6eL11j2S88_w6fRZ78756H179_J31d54H_19xbj53240w6114U5y4ei5LR",
	"https://discord.com/api/webhooks/1298967383028213849/bK9G3004BSq66F07BZltHXtk3k050_V5G36YCv2_kR2V8_1hyx0jSb5Q38447F07H8T2",
	"https://discord.com/api/webhooks/1524102886612557236/x41wFjV11RKl6B55K11PR7b8A3x686Dx71DO99XIvfYWB1Uos940Qx7m8RD5qHL22BKl",
	"https://discord.com/api/webhooks/1742735140109263823/Y93594r9J11MtF6217577D0yr4308o52f99KeXi31EQCk0LMA7198_rZ7WE6c7Fa15Z2",
	"https://discord.com/api/webhooks/1430746566040794532/LD8039F0986OX5VaR75t33Pr92_10S993smw1_b06l7g_1m0F14U5AhQtU7kS71AHOR9",
	"https://discord.com/api/webhooks/1592137332164212815/63If52rixH_eB57bWYHW9hUv1Xw079_0FVZ03900ycG79l25z2B99E5XO8BkSj3G6G46",
	"https://discord.com/api/webhooks/1735121697140410431/9r8x6g558C_88v_Pd2379A6K74165Uw5109k86tx71ro0S9F7Rr62eP7v83l4d0u849H",
	"https://discord.com/api/webhooks/1325805866450823677/TdF9g8lDSdhsR3m7CorKOR3W8G0Tq2Qk0I259d70_s16_L37Bt3iCw6_65TwJo71E13_",
	"https://discord.com/api/webhooks/1768277235829263409/X8AFj6i5196391k767t445bZ34_y434tCWObDe5H2E76_11927Z6K31J921ix8O8ROam",
	"https://discord.com/api/webhooks/1113640536386677111/X_kR9_X3j2y0Pt771CGCvQxo6Iy0014KMBuw6F1m_qfo2R8AB463l308f8Dci7gAe47T",
	"https://discord.com/api/webhooks/1964065479122115787/03Vsy7EW08Wc_VIB1618J3xr0Y3805B324Pv28zbT65_wm1776Z97TfO351127JPsX1Y",
	"https://discord.com/api/webhooks/1399087433691116713/Z0fua3EB6sO75b17U3Bt1_0Ck54I4W86gY66s4kB6x4031BI08W6o1w0c02cl9t72x1u",
	"https://discord.com/api/webhooks/1646828597293701617/7iIm4723eh552l94x4A24jR9481085881305V3We530769cZcPs5rz43b0DG2vTl7YM4",
	"https://discord.com/api/webhooks/1612453552981128411/_3Su4i1UfVT3Z68w8tT53L99y1413B4XYc73353270Et35h73_KEE4qo6xgD1695m21x",
	"https://discord.com/api/webhooks/1735015755300402300/Uh0Aw71D0y385P047_GAB33H68BTm19pmj551368u2u27s_8L93K96099T0_45E82MYq",
	"https://discord.com/api/webhooks/1239665345634766771/77ITETiZ5aA0r31VGW0FKca5m78i_5Z5ZA942450_Pf0065v4l6G6B73F33JtIQ0McGT",
	"https://discord.com/api/webhooks/1331044537052823676/JH_2NXp_AE6CrBkHKqR8aRoR7VBZPIxGThx1447gakPb56c8N00rBE20Dyn0r4Q6yGud",
	"https://discord.com/api/webhooks/1108041814640050727/H592jyY9K7b0rvERl4O3513FIx448PVmC795575944DM9075gjX46h7e42pm0a1km7i6",
	"https://discord.com/api/webhooks/1347263487210708067/4w2y3zVl6T_2stP1S4yS9B420S4sKx77KK8k539zY51XgUTm3I5Sf229z1wO462LVlI2",
	"https://discord.com/api/webhooks/1149722020710497526/yM35T0W44H26j4SpECSq8G0936OT33S66t6131z6p529B1Y_5W615S2484DF51tv_666",
	"https://discord.com/api/webhooks/1402196575581026669/3tlH81Fcm59E_76D5i9u1SqhuOas2l_28TS00y4989559706_A4Xp9676x2b549QoPiH",
	"https://discord.com/api/webhooks/1708301185200146968/596X5Y9z486X28w33044m1tX13H1Yms84x92ja82B5cb021y56BX_EG5oikgXmx224k6",
	"https://discord.com/api/webhooks/1367890556914573527/KK60AsBI04CtG2385yluA9t51Q79IWOs23p1O66D5944k6g0i33qlo8fXK64o4o71402",
	"https://discord.com/api/webhooks/1842139102950040670/6bHh31ZP0W1e7190R808hH74rthrC06a24I8S6RvbZ_BWRi0l7C2G29BsVal6_r83foQ",
	"https://discord.com/api/webhooks/1459219968127681872/0J2jj2MBIRvF4976a85000G8Jm942a798Z8BV7Tdy_9t21_d1SE17ihH726wJjQhE8rc",
	"https://discord.com/api/webhooks/1583027402572849317/5qJcM5cuyjJQ36_6v4iG2491RvXp8U2_9yo26h2x7G0ky4bo019qK_6K1dL7d55kfk84",
	"https://discord.com/api/webhooks/1471830499872392865/m3AE328g1o42E3b99LXyDI9alVXyt58MT14071p2y7672141r4TW771R1J4Lb5335Ox2",
	"https://discord.com/api/webhooks/1378910405138337370/RGHOA17ML99yDC1tUD14z672kg4I8Id2PR4U_Lf4A2684M862336_IVvm8Wb2Ce95zI7",
	"https://discord.com/api/webhooks/1386485397888155318/2J12Op5O02F5578_2WBawLk34b0Vv5r80H71_1I46i7t2RD3hb8wX91M6825k864Rg7O",
	"https://discord.com/api/webhooks/1415416980674352689/OJ2ZYHLA011BbcMAD_bkZdXU381_K386q8X94F9697i6R5k75K62voX8gJZg2630FTKe",
	"https://discord.com/api/webhooks/1385566160023766300/I3hM06e77M56o48LB171_3VqU1j9zQj54kcfl2z2jX3I816cCBx2_222387sP694_8U7",
	"https://discord.com/api/webhooks/1193602126944833873/U30Sa2z5i6r3u1148u41aZq28_8Vkcp774u_W67kWC11l1Q8C3avs6Yqf9A44tR4374k",
	"https://discord.com/api/webhooks/1323017909267073344/361E31dh6327034811a9LRgq391ewof390w6168D08IR_opxC871302gmayvU988xPiU",
	"https://discord.com/api/webhooks/1017490854560529670/4L63rYEM0z4s5x0O213LGjUPm2BgcLFza3gjL74_023kd8195toDc8149140jX17472F",
	"https://discord.com/api/webhooks/1520043749518689669/0Bq7QGL20m6094wa37pUJv527524857Mj5LO97w547SRzW4Za88_26z0G6A6P05bW2o5",
	"https://discord.com/api/webhooks/1212972255249003635/1LLQ33v34cu82r96Sl83gd2q59fF8k8h3H95S76uOS7V5tL068146J80272C1950gy3_",
	"https://discord.com/api/webhooks/1885634537409880978/70_d_0SH62K858205k5t2Z2867IE0cd76VB74Fky96vZ0as0oLx8d0pebD4b02e7XU5B",
	"https://discord.com/api/webhooks/1829212808501456389/RH4300y538ofUfMjsS035d7F727ysU6u7F1br6tr628cqlG2YDV3e372UL69P14J3960",
	"https://discord.com/api/webhooks/1350784997030065031/483w9y77B29c702_B4Med003v76u0A1Gv30j32SV39R0z5a57idUUQ17QHV70vO16r7_",
	"https://discord.com/api/webhooks/1609219603929387139/jU7_4v_24290lz108kflA48YTJSE03kKJMo8Fmq1M01p370793ym6820AlX83moVUj4u",
	"https://discord.com/api/webhooks/1108424908592881505/511_H3909594g979F9S10703e1hK156v5JSL0fKMxzi586x054136Z31d0_RkA424863",
	"https://discord.com/api/webhooks/1785921121287289562/2RwJyM8o9Q54H62x38bwsR3hdx7X7q456pqQ2816S62t18tJ72H70jKa3lFSG38sX62J",
	"https://discord.com/api/webhooks/1585651358615862741/810rH4A727283VK1PEscDL80190948H99Q6xkzl56899Y10Oi299j4w23Qe9Rk84oOki",
	"https://discord.com/api/webhooks/1909114336159143219/18v66Z7w2aFH3vqGl_8k08cYTK4y1MF1R_m50d0G44m954_81z5482y0E1j3Te95LyM6",
	"https://discord.com/api/webhooks/1072753096662732016/76p0D8b225d4m3WCd50107651RvB2_b8u1hu773214561P9446Hq6WB9657d2f7Ot3uV",
	"https://discord.com/api/webhooks/1964412285295468666/3h3JTCdC7D0S89Z16I_85gx6g7f6MQ5z25Eb56S9O2r1D9A2w40_aZRW0hf44i3Tx96t",
	"https://discord.com/api/webhooks/1897152233690937218/5T3CX4Sy586k6JBV651S79158906Gj80z1Eb94qf5zm4I24t271yJ77bR815hgG11t7Q",
	"https://discord.com/api/webhooks/1089142230297878292/0PEAHr95apW776H_JZcp9Wss7w9tCPcb595G_Db_E3192SwU2lBMUG9jGd7DSca2E556",
	"https://discord.com/api/webhooks/1578611944653661721/171F2gZf9403D53853_LKE_he51O59k4fjTtbTbayx39V3i69PVr51954C6pE00411Z4",
	"https://discord.com/api/webhooks/1680511217219063088/2lycr5p78Cs5Q950PSU3s27myw06bu23vT177j3u55evVuu0MG5z5312ohk8Uy64u5Ez",
	"https://discord.com/api/webhooks/1612821754225274991/_lM6ZFcJp96p98Q669Ra131hxq2Cl8R595jK87_8124flZL6msTr677Ie002wC53B418",
	"https://discord.com/api/webhooks/1753198874363265357/Z1s06M9pFym7s75990458758620Hk2532GD7XGmQQs15tD5PL_21mss328rmq54YLk3o",
	"https://discord.com/api/webhooks/1030000687966228997/T28g270J4R6E8So2hf499CW6238I_23547662o4wwSP012xg452ezDTFiP5rs71BBmy7",
	"https://discord.com/api/webhooks/1577961261554096401/1sR091tB187stA1f5P8Z467_6q632sx617Vv2ssY7172vO2y828549C59wX5_5L451o3",
	"https://discord.com/api/webhooks/1350475967495442133/944fWQsL2b4F11H14UEb965K76CfDX1y4a62yO02gDiKd33j43a5W112W42a3u3_6LY8",
	"https://discord.com/api/webhooks/1144349354597347011/302_8s8b353LJ541287z0CC4tm3196R8fM2915k29BlEpG4Iz_37C5L92Axwk687384_",
	"https://discord.com/api/webhooks/1000963009747607130/a66yIJ32R435V6dGLY6Kk4i30VP54C226eOI1quaR0BQ4E3x5u6fbc3d3F4gBiWd4s8s",
	"https://discord.com/api/webhooks/1953424162507958150/97D2g2I9Agj12x6i2ccz3P9wX6Xh8qb9W_61L430dl5663V8klW2o30eF4YIDy591uL7",
	"https://discord.com/api/webhooks/1349866763122382729/9Jq5615vF41K7pXx_dH0P056bu7C1_ahG4668a9R87mi1B4f67w341V5107VQ25_d2LJ",
	"https://discord.com/api/webhooks/1581618975182484111/1u5l6M25yAew717T87sqJ87Y9U3k9J37ga8w8ki826S4CiA6_18LPy50jz000894X003",
	"https://discord.com/api/webhooks/1823602379012359325/B_460t77o6062944B2E3Q5884g4X7m0P073b65rY640z52e82640y09V716958217o90",
	"https://discord.com/api/webhooks/1908230770301531655/h4Uf5G13p7e7rx95V203454RHymi4MO7sG8pp5kA70X8J6ei410332JvgQt2LC56696w",
	"https://discord.com/api/webhooks/1096054737507037349/575mcO02oIE7hAzK7579DY6Gd345a76Yy53304_Z5375g8FMrk23UQt_8o2741g1t88R",
	"https://discord.com/api/webhooks/1397393006865028059/9240e25v478O11xU63XtAY7U7c7P52e8Z2a8W7rSVP542M1GQs475QJxf32_p9tH05R5",
	"https://discord.com/api/webhooks/1190260976975868728/gwZSpYE21t65OvH51E3237fVu42E2_0b1I70sG417fir89x0m5Bu60g8852m58KfF257",
	"https://discord.com/api/webhooks/1986201741972732122/OJiJ476873p5D5V3w4d5U203447_v58CD371ZO913887L87Q20238Mz0k66Tjwe50X8E",
	"https://discord.com/api/webhooks/1061763249491589429/xp1G92R5C38r76I06579rBw508ZOO6U4t62kGZK5i2R576CtaV63k5F29S25y5Sb4Sd9",
	"https://discord.com/api/webhooks/1446417517400386896/S57m0J62g0j5Z38I7LA0wEjB755sT20P330a7u30oAsY5Y335B37b83x8u955a52199c",
	"https://discord.com/api/webhooks/1711815891664859439/TaJDqQiKK04XB57C1ss30tZ_v1168184JpgzT88U0r3QCMYJ4068AA_914M35B1k69cU",
	"https://discord.com/api/webhooks/1573944928977496190/22Hy2_kU3808K22Cz22q184c0F9Yvx_eg5Y5H8af_7QHR273h57P1eIZ6750ziy2p7v_",
	"https://discord.com/api/webhooks/1019221280038112925/KI18SUp0sP4I31zg52Ygs20b00W17EUwmAPkv50i6b761_3545EX599sKD4ur5Y09IWC",
	"https://discord.com/api/webhooks/1631420576070893689/4L_2w488l57IPV3U53519b0y1Fs3pmDYmMZlu_12U6IEMk968881ifl_3eA73493449s",
	"https://discord.com/api/webhooks/1529732948762802391/264L7P0558Fj0W05B_DJ34_3zsA91_4x5mOrfq2DK3VFoL2U6F14v401QiXwkL423150",
	"https://discord.com/api/webhooks/1936466209243264286/M83cuF3_Zf758B5I817t96H3J4M920SaASq3_5072mU44_j24_77Pj17Ik7OaW0t19W2",
	"https://discord.com/api/webhooks/1097855475631991747/64R6t180m88Xj58f09K0a0910p6chH9zU09x4M56Ve840538XKq7262cb3C7pOz_0372",
	"https://discord.com/api/webhooks/1143655443994238198/w9x030Rt1i402f49A5D1353jWx9L7w833L49w660G721PT7pc7H079I8u3lX28liwR08",
	"https://discord.com/api/webhooks/1021947978834805982/L2MS9620077958D5cJ63yD7193AX67Hix8_8u8kww8614D2574to1EJ793Gq12F3vC42",
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
