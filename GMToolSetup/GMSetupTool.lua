-- GM Setup Tool - MoP 5.4.8
-- Uses only APIs confirmed available in 5.4.8:
--   SetTexture(r,g,b,a)  for solid colors  (NOT SetColorTexture - added 7.0)
--   SetBackdrop           on Frame only     (NOT on Button)
--   UIPanelButtonTemplate for clickable btns
--   SetBackdrop bgFile uses a real BLP path

local mainFrame
local statusText
local isRunning   = false
local QUEUE       = {}
local queueIndex  = 1
local elapsed_acc = 0
local totalCmds   = 0
local TIMER_DELAY = 0.20

-- Solid color texture helper - works in 5.4.8
local function SolidColor(parent, layer, r,g,b,a)
    local t = parent:CreateTexture(nil, layer or "BACKGROUND")
    t:SetTexture(r, g, b, a)
    return t
end

local function SendGMCommand(cmd) SendChatMessage(cmd, "SAY") end

local function StartQueue(cmds, label)
    if isRunning then print("|cFFFF4444GMSetupTool:|r Already running.") return end
    QUEUE=cmds; totalCmds=#cmds; queueIndex=1; isRunning=true; elapsed_acc=0
    if statusText then statusText:SetText("|cFFFFD700Running:|r "..label.."  (0/"..totalCmds..")") end
    print("|cFFFFD700GMSetupTool:|r "..label.." — "..totalCmds.." commands.")
end

local ticker = CreateFrame("Frame")
ticker:SetScript("OnUpdate", function(self, dt)
    if not isRunning then return end
    elapsed_acc = elapsed_acc + dt
    if elapsed_acc < TIMER_DELAY then return end
    elapsed_acc = 0
    if queueIndex > #QUEUE then
        isRunning = false
        if statusText then statusText:SetText("|cFF00FF00Done! "..totalCmds.." sent.|r") end
        print("|cFF00FF00GMSetupTool:|r Complete.")
        return
    end
    local cmd = QUEUE[queueIndex]
    SendGMCommand(cmd)
    if statusText then statusText:SetText("|cFFFFD700"..queueIndex.."/"..totalCmds..":|r "..cmd) end
    queueIndex = queueIndex + 1
end)

-- ============================================================
--  COMMAND GROUPS
-- ============================================================
local GROUPS = {
    { label="Riding Skills",          color={1,0.8,0.1},
      desc="All riding ranks + skill cap + Pandaria flying + Cloud Serpent",
      cmds={ ".learn 33388",".learn 33391",".learn 34090",".learn 34091",
             ".learn 90265",".learn 115913",".learn 130487",".learn 90267",".learn 54197",".setskill 762 600 600" } },
    { label="Primary Professions",    color={0.4,0.8,1},
      desc="Learn+max+recipes: Alchemy, BS, Enchant, Eng, Inscription, JC, LW, Tailoring",
      cmds={ ".learn 2259",".setskill 171 600 600",".learn all_recipes alchemy",
             ".learn 2018",".setskill 164 600 600",".learn all_recipes blacksmithing",
             ".learn 7411",".setskill 333 600 600",".learn all_recipes enchanting",
             ".learn 4036",".setskill 202 600 600",".learn all_recipes engineering",
             ".learn 45357",".setskill 773 600 600",".learn all_recipes inscription",
             ".learn 25229",".setskill 755 600 600",".learn all_recipes jewelcrafting",
             ".learn 2108",".setskill 165 600 600",".learn all_recipes leatherworking",
             ".learn 3908",".setskill 197 600 600",".learn all_recipes tailoring" } },
    { label="Gathering Professions",  color={0.4,1,0.4},
      desc="Herbalism, Mining, Skinning — learned and maxed to 600",
      cmds={ ".learn 2366",".setskill 182 600 600",".learn 2575",
             ".setskill 186 600 600",".learn 8613",".setskill 393 600 600" } },
    { label="Secondary Professions",  color={1,0.65,0.2},
      desc="Cooking, First Aid, Fishing, Archaeology — all ranks learned and maxed to 600",
      cmds={
        -- Cooking: Apprentice→Zen Master
        ".learn 2550",   -- Apprentice Cooking
        ".learn 3102",   -- Journeyman Cooking
        ".learn 3413",   -- Expert Cooking
        ".learn 18260",  -- Artisan Cooking
        ".learn 33359",  -- Master Cooking
        ".learn 51295",  -- Grand Master Cooking
        ".learn 88003",  -- Illustrious Grand Master Cooking
        ".learn 104232", -- Zen Master Cooking
        ".setskill 185 600 600",
        -- First Aid: Apprentice→Zen Master
        ".learn 3273",   -- Apprentice First Aid
        ".learn 3274",   -- Journeyman First Aid
        ".learn 7924",   -- Expert First Aid
        ".learn 10846",  -- Artisan First Aid
        ".learn 27028",  -- Master First Aid
        ".learn 45542",  -- Grand Master First Aid
        ".learn 74549",  -- Illustrious Grand Master First Aid
        ".learn 104242", -- Zen Master First Aid
        ".setskill 129 600 600",
        -- Fishing: Apprentice→Zen Master
        ".learn 131474", -- Fishing (base)
        ".learn 7620",   -- Apprentice Fishing
        ".learn 7731",   -- Journeyman Fishing
        ".learn 7732",   -- Expert Fishing
        ".learn 18248",  -- Artisan Fishing
        ".learn 33095",  -- Master Fishing
        ".learn 51294",  -- Grand Master Fishing
        ".learn 65293",  -- Illustrious Grand Master Fishing
        ".learn 88869",  -- Zen Master Fishing (alt ID)
        ".learn 110412", -- Zen Master Fishing
        ".setskill 356 600 600",
        -- Archaeology: Apprentice→Zen Master
        ".learn 78670",  -- Apprentice Archaeology
        ".learn 78672",  -- Journeyman Archaeology
        ".learn 78674",  -- Expert Archaeology
        ".learn 78676",  -- Artisan Archaeology
        ".learn 78678",  -- Master Archaeology
        ".learn 78680",  -- Grand Master Archaeology
        ".learn 88362",  -- Illustrious Archaeology
        ".learn 109063", -- Zen Master Archaeology
        ".setskill 794 600 600",
      } },
    { label="Weapon & Combat Skills", color={1,0.3,0.3},
      desc="All weapon skills + dual wield + defense maxed + .maxskill",
      cmds={ ".setskill 43 600 600",".setskill 55 600 600",".setskill 44 600 600",
             ".setskill 172 600 600",".setskill 54 600 600",".setskill 160 600 600",
             ".setskill 173 600 600",".setskill 136 600 600",".setskill 229 600 600",
             ".setskill 473 600 600",".setskill 162 600 600",".setskill 45 600 600",
             ".setskill 46 600 600",".setskill 226 600 600",".setskill 228 600 600",
             ".setskill 176 600 600",".setskill 118 600 600",".setskill 95 600 600",".maxskill" } },
    { label="Class Spells",           color={0.8,0.4,1},
      desc="All class-appropriate spells for current level",
      cmds={ ".learn all_myclass" } },
    { label="All Mounts",  color={0.9,0.75,0.5},
      desc="everything with the aura of mounted in the system",
      cmds={ ".learn 48778",".learn 34767",".learn 23161",".learn 148972",".learn 73630",".learn 23214",".learn 69826",".learn 66906",".learn 34769",".learn 73629",".learn 5784",".learn 148970",".learn 87840",".learn 69820",".learn 13819",".learn 66907",".learn 42363",".learn 42387",".learn 122708",".learn 136505",".learn 93326",".learn 1226760",".learn 148392",".learn 473744",".learn 1249659",".learn 1266866",".learn 133023",".learn 87090",".learn 1247598",".learn 148476",".learn 118737",".learn 60002",".learn 127164",".learn 1280068",".learn 1257516",".learn 46199",".learn 84751",".learn 97493",".learn 97560",".learn 32292",".learn 59571",".learn 107516",".learn 130965",".learn 44825",".learn 92155",".learn 127158",".learn 135416",".learn 136471",".learn 466983",".learn 98718",".learn 45177",".learn 68930",".learn 123992",".learn 163024",".learn 8394",".learn 127169",".learn 68057",".learn 71810",".learn 101821",".learn 121820",".learn 124408",".learn 132036",".learn 138641",".learn 138642",".learn 473741",".learn 17481",".learn 63642",".learn 64731",".learn 118089",".learn 129918",".learn 148428",".learn 163025",".learn 1247591",".learn 468",".learn 44317",".learn 63643",".learn 88746",".learn 102488",".learn 113120",".learn 126508",".learn 127170",".learn 127308",".learn 145133",".learn 1239372",".learn 36702",".learn 59570",".learn 61289",".learn 63844",".learn 64992",".learn 65917",".learn 66847",".learn 127216",".learn 132119",".learn 136164",".learn 139448",".learn 473478",".learn 1266345",".learn 22720",".learn 34898",".learn 54729",".learn 58819",".learn 59568",".learn 69395",".learn 80628",".learn 88718",".learn 98204",".learn 127156",".learn 129552",".learn 130985",".learn 138424",".learn 473739",".learn 1229672",".learn 1247597",".learn 458",".learn 10800",".learn 24576",".learn 25675",".learn 25858",".learn 26655",".learn 32243",".learn 32295",".learn 34068",".learn 39800",".learn 59976",".learn 62048",".learn 64681",".learn 64993",".learn 88748",".learn 88990",".learn 97501",".learn 102346",".learn 103195",".learn 104517",".learn 146622",".learn 388516",".learn 466977",".learn 1224643",".learn 1238816",".learn 1283471",".learn 10804",".learn 22717",".learn 23240",".learn 29059",".learn 32246",".learn 35712",".learn 64657",".learn 72808",".learn 88742",".learn 101573",".learn 103081",".learn 135418",".learn 140249",".learn 142641",".learn 1226983",".learn 3363",".learn 6899",".learn 10792",".learn 10796",".learn 23229",".learn 25863",".learn 25953",".learn 30829",".learn 41252",".learn 59569",".learn 59572",".learn 59799",".learn 59802",".learn 60021",".learn 63641",".learn 65637",".learn 66124",".learn 93644",".learn 101542",".learn 127174",".learn 127213",".learn 127274",".learn 127302",".learn 130138",".learn 140250",".learn 387308",".learn 394209",".learn 580",".learn 10789",".learn 16056",".learn 17454",".learn 22724",".learn 23225",".learn 23510",".learn 26656",".learn 32242",".learn 32289",".learn 32297",".learn 39798",".learn 42776",".learn 43927",".learn 44151",".learn 46980",".learn 59793",".learn 59797",".learn 59961",".learn 59996",".learn 61229",".learn 61470",".learn 61983",".learn 63639",".learn 65640",".learn 67336",".learn 68188",".learn 89520",".learn 104515",".learn 107517",".learn 107842",".learn 123182",".learn 127176",".learn 127286",".learn 127289",".learn 127290",".learn 129935",".learn 139407",".learn 142910",".learn 416158",".learn 423869",".learn 466980",".learn 471440",".learn 473487",".learn 1224596",".learn 6654",".learn 6777",".learn 10799",".learn 10803",".learn 15779",".learn 16081",".learn 17456",".learn 18990",".learn 23251",".learn 28828",".learn 35711",".learn 39317",".learn 39319",".learn 39910",".learn 41515",".learn 42668",".learn 47037",".learn 59573",".learn 59804",".learn 61294",".learn 61447",".learn 63796",".learn 64659",".learn 65643",".learn 65645",".learn 65646",".learn 88741",".learn 110039",".learn 120822",".learn 121836",".learn 121837",".learn 123886",".learn 127180",".learn 127287",".learn 130137",".learn 132117",".learn 146615",".learn 473745",".learn 1224647",".learn 1229670",".learn 471",".learn 6653",".learn 8395",".learn 8396",".learn 10795",".learn 16058",".learn 22718",".learn 22723",".learn 23241",".learn 23243",".learn 26054",".learn 32235",".learn 32239",".learn 32290",".learn 33631",".learn 33660",".learn 34795",".learn 34896",".learn 35018",".learn 35027",".learn 35028",".learn 35713",".learn 39801",".learn 40192",".learn 43883",".learn 49193",".learn 51960",".learn 58615",".learn 59567",".learn 59788",".learn 60025",".learn 60118",".learn 60140",".learn 61425",".learn 63956",".learn 63963",".learn 64761",".learn 64977",".learn 65439",".learn 66087",".learn 66088",".learn 88744",".learn 88749",".learn 96503",".learn 113199",".learn 126507",".learn 127165",".learn 127278",".learn 127293",".learn 127295",".learn 138640",".learn 148396",".learn 148417",".learn 348459",".learn 473743",".learn 1217476",".learn 1224645",".learn 1239204",".learn 459",".learn 581",".learn 10788",".learn 10798",".learn 15781",".learn 16083",".learn 17453",".learn 17464",".learn 18989",".learn 22719",".learn 22721",".learn 22722",".learn 23228",".learn 23247",".learn 24242",".learn 26056",".learn 30837",".learn 31700",".learn 32240",".learn 32420",".learn 33630",".learn 34406",".learn 34790",".learn 35025",".learn 39450",".learn 41513",".learn 41516",".learn 42777",".learn 48027",".learn 48954",".learn 50281",".learn 55531",".learn 60024",".learn 63232",".learn 63638",".learn 63640",".learn 65638",".learn 65642",".learn 66090",".learn 67466",".learn 68056",".learn 88335",".learn 88750",".learn 92231",".learn 92232",".learn 96499",".learn 97581",".learn 100332",".learn 101282",".learn 120043",".learn 123993",".learn 127154",".learn 127161",".learn 127177",".learn 127209",".learn 127220",".learn 136400",".learn 138643",".learn 372677",".learn 387323",".learn 1224646",".learn 6648",".learn 10873",".learn 16055",".learn 17455",".learn 18363",".learn 18992",".learn 23219",".learn 23239",".learn 23248",".learn 23252",".learn 24252",".learn 25859",".learn 32244",".learn 32296",".learn 35020",".learn 35710",".learn 35714",".learn 41514",".learn 43688",".learn 43810",".learn 49378",".learn 55164",".learn 59650",".learn 61230",".learn 61469",".learn 63635",".learn 64656",".learn 66123",".learn 88331",".learn 107844",".learn 121839",".learn 123160",".learn 124550",".learn 127272",".learn 127288",".learn 129932",".learn 129934",".learn 130086",".learn 136163",".learn 138425",".learn 139442",".learn 142266",".learn 148620",".learn 387319",".learn 389125",".learn 389128",".learn 463045",".learn 466948",".learn 1247596",".learn 1250045",".learn 578",".learn 6896",".learn 6897",".learn 6898",".learn 16059",".learn 16060",".learn 16084",".learn 17459",".learn 17462",".learn 23220",".learn 23221",".learn 23222",".learn 23223",".learn 23249",".learn 23509",".learn 26055",".learn 32245",".learn 34407",".learn 34897",".learn 34899",".learn 35022",".learn 39315",".learn 39318",".learn 39802",".learn 39949",".learn 40212",".learn 41518",".learn 43880",".learn 43899",".learn 43900",".learn 44744",".learn 44827",".learn 46197",".learn 50869",".learn 50870",".learn 54753",".learn 60114",".learn 60424",".learn 61467",".learn 64658",".learn 65641",".learn 66846",".learn 68187",".learn 68768",".learn 74918",".learn 90621",".learn 93623",".learn 96491",".learn 100333",".learn 120395",".learn 121838",".learn 127178",".learn 127271",".learn 132118",".learn 138423",".learn 138426",".learn 142478",".learn 148619",".learn 470",".learn 579",".learn 8980",".learn 10787",".learn 10790",".learn 10801",".learn 10802",".learn 10969",".learn 15780",".learn 16082",".learn 17229",".learn 17458",".learn 17460",".learn 17463",".learn 17465",".learn 18991",".learn 23227",".learn 23242",".learn 23246",".learn 23250",".learn 23338",".learn 32345",".learn 37015",".learn 39316",".learn 41517",".learn 42929",".learn 44153",".learn 46628",".learn 49379",".learn 55293",".learn 59791",".learn 60116",".learn 60136",".learn 61465",".learn 61996",".learn 63636",".learn 64927",".learn 65639",".learn 65644",".learn 68769",".learn 72807",".learn 86579",".learn 87091",".learn 97359",".learn 102349",".learn 102350",".learn 102514",".learn 103196",".learn 127310",".learn 440915",".learn 459486",".learn 1239240",".learn 472",".learn 10793",".learn 16080",".learn 17450",".learn 17461",".learn 23238",".learn 30174",".learn 31973",".learn 39803",".learn 42667",".learn 44655",".learn 44824",".learn 49322",".learn 49908",".learn 51412",".learn 59785",".learn 60119",".learn 61997",".learn 63637",".learn 66091",".learn 66122",".learn 79361",".learn 97390",".learn 101641",".learn 107845",".learn 134931",".learn 148618",".learn 163016",".learn 387311",".learn 387321",".learn 134359",".learn 139595",".learn 130895",".learn 155741",".learn 124659",".learn 98727",".learn 130092",".learn 148773",".learn 142878",".learn 1285724",".learn 48025",".learn 75387",".learn 130678",".learn 149801",".learn 446902",".learn 47977",".learn 147595",".learn 100568",".learn 134573",".learn 1285725",".learn 58983",".learn 61309",".learn 61444",".learn 73313",".learn 75207",".learn 103170",".learn 110051",".learn 130730",".learn 148626",".learn 153489",".learn 128971",".learn 1278947",".learn 60120",".learn 72286",".learn 74856",".learn 75973",".learn 142073",".learn 1272988",".learn 61442",".learn 75614",".learn 107203",".learn 61446",".learn 75596",".learn 459538",".learn 1284044",".learn 26332",".learn 121805",".learn 134854",".learn 387320",".learn 61451",".learn 71342" } },
    { label="All Reputations",        color={1,0.85,0.1},
      desc="Every faction Vanilla through MoP set to Exalted (42999)",
      cmds={ ".mod rep 72 42999",".mod rep 47 42999",".mod rep 54 42999",".mod rep 69 42999",".mod rep 930 42999",
             ".mod rep 76 42999",".mod rep 81 42999",".mod rep 68 42999",".mod rep 530 42999",".mod rep 911 42999",
             ".mod rep 21 42999",".mod rep 369 42999",".mod rep 470 42999",".mod rep 577 42999",
             ".mod rep 730 42999",".mod rep 729 42999",".mod rep 890 42999",".mod rep 889 42999",
             ".mod rep 509 42999",".mod rep 510 42999",".mod rep 529 42999",".mod rep 609 42999",
             ".mod rep 59 42999",".mod rep 576 42999",".mod rep 349 42999",".mod rep 589 42999",
             ".mod rep 809 42999",".mod rep 749 42999",".mod rep 270 42999",".mod rep 910 42999",".mod rep 909 42999",
             ".mod rep 946 42999",".mod rep 947 42999",".mod rep 942 42999",".mod rep 1011 42999",
             ".mod rep 935 42999",".mod rep 989 42999",".mod rep 932 42999",".mod rep 934 42999",
             ".mod rep 933 42999",".mod rep 978 42999",".mod rep 941 42999",".mod rep 970 42999",
             ".mod rep 1038 42999",".mod rep 1031 42999",".mod rep 1015 42999",".mod rep 922 42999",
             ".mod rep 967 42999",".mod rep 990 42999",".mod rep 1012 42999",".mod rep 1077 42999",
             ".mod rep 1037 42999",".mod rep 1052 42999",".mod rep 1106 42999",".mod rep 1090 42999",
             ".mod rep 1098 42999",".mod rep 1091 42999",".mod rep 1073 42999",".mod rep 1119 42999",
             ".mod rep 1105 42999",".mod rep 1104 42999",".mod rep 1159 42999",
             ".mod rep 1158 42999",".mod rep 1173 42999",".mod rep 1179 42999",".mod rep 1171 42999",
             ".mod rep 1204 42999",".mod rep 1177 42999",".mod rep 1178 42999",".mod rep 1190 42999",
             ".mod rep 1271 42999",".mod rep 1269 42999",".mod rep 1302 42999",".mod rep 1337 42999",
             ".mod rep 1317 42999",".mod rep 1345 42999",".mod rep 1307 42999",".mod rep 1299 42999",
             ".mod rep 1375 42999",".mod rep 1376 42999",".mod rep 1388 42999",".mod rep 1384 42999",
             ".mod rep 1359 42999",".mod rep 1380 42999",".mod rep 1358 42999",".mod rep 1279 42999",
             ".mod rep 1277 42999",".mod rep 1278 42999",".mod rep 1283 42999",".mod rep 1280 42999",
             ".mod rep 1281 42999",".mod rep 1282 42999",".mod rep 1284 42999",".mod rep 1285 42999",
             ".mod rep 1216 42999",".mod rep 1134 42999" } },  -- Shang Xi's Academy
    { label="Useful Spells",           color={0.9,0.5,1},
      desc="Useful utility spells: Goblin Grappling Hook, Heroic Leap, Shoot, Throw",
      cmds={ ".learn 46642", ".learn 32028", ".learn 74503", ".learn 44776", ".additem 5976", ".additem 96931", ".additem 34334", ".additem 19019", ".learn 107516" } },
}
local allCmds = {}
for i=1,#GROUPS do for _,c in ipairs(GROUPS[i].cmds) do allCmds[#allCmds+1]=c end end
GROUPS[#GROUPS+1] = { label="★ RUN ALL GROUPS", color={1,0.95,0.2}, runAll=true,
    desc="Every group in order ("..#allCmds.." total commands)", cmds=allCmds }

-- ============================================================
--  UI
-- ============================================================
local WIN_W = 440
local WIN_H = 580
local BTN_H = 28
local BTN_W = 410

local function BuildUI()
    -- ── Main window ──────────────────────────────────────────
    mainFrame = CreateFrame("Frame", "GMSetupToolFrame", UIParent)
    mainFrame:SetSize(WIN_W, WIN_H)
    mainFrame:SetPoint("CENTER")
    mainFrame:SetMovable(true)
    mainFrame:EnableMouse(true)
    mainFrame:RegisterForDrag("LeftButton")
    mainFrame:SetScript("OnDragStart", mainFrame.StartMoving)
    mainFrame:SetScript("OnDragStop",  mainFrame.StopMovingOrSizing)
    mainFrame:SetClampedToScreen(true)
    mainFrame:SetToplevel(true)
    mainFrame:SetFrameStrata("HIGH")
    mainFrame:Hide()

    -- Background: SetTexture(r,g,b,a) — the pre-Legion solid color API
    local bg = mainFrame:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(0.04, 0.04, 0.08, 0.97)

    -- Gold border line (top)
    local bTop = mainFrame:CreateTexture(nil, "BORDER")
    bTop:SetTexture(0.6, 0.5, 0.15, 1)
    bTop:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 0, 0)
    bTop:SetPoint("TOPRIGHT", mainFrame, "TOPRIGHT", 0, 0)
    bTop:SetHeight(2)

    local bBot = mainFrame:CreateTexture(nil, "BORDER")
    bBot:SetTexture(0.6, 0.5, 0.15, 1)
    bBot:SetPoint("BOTTOMLEFT", mainFrame, "BOTTOMLEFT", 0, 0)
    bBot:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT", 0, 0)
    bBot:SetHeight(2)

    local bL = mainFrame:CreateTexture(nil, "BORDER")
    bL:SetTexture(0.6, 0.5, 0.15, 1)
    bL:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 0, 0)
    bL:SetPoint("BOTTOMLEFT", mainFrame, "BOTTOMLEFT", 0, 0)
    bL:SetWidth(2)

    local bR = mainFrame:CreateTexture(nil, "BORDER")
    bR:SetTexture(0.6, 0.5, 0.15, 1)
    bR:SetPoint("TOPRIGHT", mainFrame, "TOPRIGHT", 0, 0)
    bR:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT", 0, 0)
    bR:SetWidth(2)

    -- Header bar
    local hdr = mainFrame:CreateTexture(nil, "ARTWORK")
    hdr:SetTexture(0.1, 0.07, 0.02, 1)
    hdr:SetPoint("TOPLEFT",  mainFrame, "TOPLEFT",  2, -2)
    hdr:SetPoint("TOPRIGHT", mainFrame, "TOPRIGHT", -2, -2)
    hdr:SetHeight(36)

    local title = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("LEFT", mainFrame, "LEFT", 12, 0)
    title:SetPoint("TOP",  mainFrame, "TOP",   0, -10)
    title:SetText("|cFFFFD700GM Setup Tool|r  |cFF888888MoP 5.4.8|r")

    -- Close button
    local cls = CreateFrame("Button", nil, mainFrame, "UIPanelCloseButton")
    cls:SetPoint("TOPRIGHT", mainFrame, "TOPRIGHT", 4, 4)
    cls:SetScript("OnClick", function() mainFrame:Hide() end)

    -- ── Utility strip (NOT part of Run All) ──────────────────
    -- Background for utility strip
    local utilBg = mainFrame:CreateTexture(nil, "ARTWORK")
    utilBg:SetTexture(0.06, 0.04, 0.08, 0.95)
    utilBg:SetPoint("BOTTOMLEFT",  mainFrame, "BOTTOMLEFT",  2,  34)
    utilBg:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT", -2, 34)
    utilBg:SetHeight(62)

    local utilSep = mainFrame:CreateTexture(nil, "OVERLAY")
    utilSep:SetTexture(0.4, 0.3, 0.6, 0.8)
    utilSep:SetHeight(1)
    utilSep:SetPoint("BOTTOMLEFT",  mainFrame, "BOTTOMLEFT",   6, 95)
    utilSep:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT",  -6, 95)

    local utilLabel = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    utilLabel:SetPoint("BOTTOMLEFT", mainFrame, "BOTTOMLEFT", 8, 90)
    utilLabel:SetTextColor(0.6, 0.5, 0.8)
    utilLabel:SetText("Utility (not in Run All):")

    -- Level 90 button
    local lvlBtn = CreateFrame("Button", nil, mainFrame, "UIPanelButtonTemplate")
    lvlBtn:SetSize(120, 22)
    lvlBtn:SetPoint("BOTTOMLEFT", mainFrame, "BOTTOMLEFT", 6, 62)
    lvlBtn:SetText("Level to 90")
    local lvlNorm = lvlBtn:GetNormalTexture()
    if lvlNorm then lvlNorm:SetVertexColor(0.8, 0.5, 1, 1) end
    lvlBtn:SetScript("OnEnter", function()
        if statusText then statusText:SetText(".char level 90 — sets current character to level 90") end
    end)
    lvlBtn:SetScript("OnLeave", function()
        if statusText then statusText:SetText("Ready.") end
    end)
    lvlBtn:SetScript("OnClick", function()
        SendGMCommand(".character level 90")
        if statusText then statusText:SetText("|cFF00FF00Sent: .character level 90|r") end
        print("|cFFFFD700GMSetupTool:|r Sent .character level 90")
    end)

    -- Teleport label + editbox + go button
    local teleLabel = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    teleLabel:SetPoint("BOTTOMLEFT", mainFrame, "BOTTOMLEFT", 134, 76)
    teleLabel:SetTextColor(0.6, 0.8, 1)
    teleLabel:SetText("Teleport to:")

    local teleBox = CreateFrame("EditBox", "GMSetupTeleBox", mainFrame, "InputBoxTemplate")
    teleBox:SetSize(160, 20)
    teleBox:SetPoint("BOTTOMLEFT", mainFrame, "BOTTOMLEFT", 134, 55)
    teleBox:SetAutoFocus(false)
    teleBox:SetMaxLetters(60)
    teleBox:SetText("location name")
    teleBox:SetScript("OnEditFocusGained", function(self)
        if self:GetText() == "location name" then self:SetText("") end
    end)
    teleBox:SetScript("OnEditFocusLost", function(self)
        if self:GetText() == "" then self:SetText("location name") end
    end)

    local teleBtn = CreateFrame("Button", nil, mainFrame, "UIPanelButtonTemplate")
    teleBtn:SetSize(70, 22)
    teleBtn:SetPoint("BOTTOMLEFT", mainFrame, "BOTTOMLEFT", 300, 53)
    teleBtn:SetText("Go!")
    local teleNorm = teleBtn:GetNormalTexture()
    if teleNorm then teleNorm:SetVertexColor(0.4, 0.8, 1, 1) end
    teleBtn:SetScript("OnEnter", function()
        if statusText then statusText:SetText(".tele <location> — teleports to named location") end
    end)
    teleBtn:SetScript("OnLeave", function()
        if statusText then statusText:SetText("Ready.") end
    end)
    teleBtn:SetScript("OnClick", function()
        local loc = teleBox:GetText()
        if loc == "" or loc == "location name" then
            print("|cFFFF4444GMSetupTool:|r Enter a location name first.")
            return
        end
        local cmd = ".tele " .. loc
        SendGMCommand(cmd)
        if statusText then statusText:SetText("|cFF00FF00Sent: " .. cmd .. "|r") end
        print("|cFFFFD700GMSetupTool:|r Sent " .. cmd)
    end)
    -- also trigger teleport on Enter key in the box
    teleBox:SetScript("OnEnterPressed", function(self)
        teleBtn:Click()
        self:ClearFocus()
    end)

    -- Status bar at bottom
    local sbarBg = mainFrame:CreateTexture(nil, "ARTWORK")
    sbarBg:SetTexture(0, 0, 0, 0.8)
    sbarBg:SetPoint("BOTTOMLEFT",  mainFrame, "BOTTOMLEFT",  2,  2)
    sbarBg:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT", -2, 2)
    sbarBg:SetHeight(30)

    statusText = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    statusText:SetPoint("BOTTOMLEFT",  mainFrame, "BOTTOMLEFT",  10, 9)
    statusText:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT", -90, 9)
    statusText:SetJustifyH("LEFT")
    statusText:SetTextColor(0.7, 0.7, 0.7)
    statusText:SetText("Ready.")

    local canBtn = CreateFrame("Button", nil, mainFrame, "UIPanelButtonTemplate")
    canBtn:SetSize(76, 20)
    canBtn:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT", -6, 6)
    canBtn:SetText("Cancel")
    canBtn:SetScript("OnClick", function()
        if isRunning then
            isRunning=false; QUEUE={}; queueIndex=1
            statusText:SetText("Cancelled.")
        end
    end)

    -- ── ScrollFrame (plain, no template) ─────────────────────
    -- Bottom edge raised to 100 to leave room for utility strip
    local sf = CreateFrame("ScrollFrame", "GMSetupScroll", mainFrame)
    sf:SetPoint("TOPLEFT",     mainFrame, "TOPLEFT",      4, -42)
    sf:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT", -18, 100)
    sf:EnableMouseWheel(true)

    local content = CreateFrame("Frame", "GMSetupContent", sf)
    content:SetWidth(BTN_W)

    -- Build buttons — absolute Y offsets only, no chaining
    local yOff = 4
    for i, grp in ipairs(GROUPS) do
        local r, g, b = grp.color[1], grp.color[2], grp.color[3]
        local hex = string.format("%02X%02X%02X",
            math.floor(r*255), math.floor(g*255), math.floor(b*255))

        if i == #GROUPS then
            -- separator line before RUN ALL
            local sep = content:CreateTexture(nil, "ARTWORK")
            sep:SetTexture(0.5, 0.4, 0.1, 0.6)
            sep:SetHeight(1)
            sep:SetPoint("TOPLEFT",  content, "TOPLEFT",  4, -(yOff+2))
            sep:SetPoint("TOPRIGHT", content, "TOPRIGHT", -4, -(yOff+2))
            yOff = yOff + 8
        end

        -- Use UIPanelButtonTemplate — confirmed working in 5.4.8
        local btn = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
        btn:SetSize(BTN_W, BTN_H)
        btn:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -yOff)

        -- Color-tint the normal texture to hint the group color
        local norm = btn:GetNormalTexture()
        if norm then norm:SetVertexColor(r*0.6+0.4, g*0.6+0.4, b*0.6+0.4, 1) end

        btn:SetText("|cFF"..hex..grp.label.."|r  |cFF888888("..#grp.cmds.." cmds)|r")
        btn:SetScript("OnEnter", function()
            statusText:SetText(grp.desc)
        end)
        btn:SetScript("OnLeave", function()
            statusText:SetText("Ready.")
        end)
        btn:SetScript("OnClick", function()
            if isRunning then print("|cFFFF4444GMSetupTool:|r Wait for queue.") return end
            StartQueue(grp.cmds, grp.label)
        end)

        yOff = yOff + BTN_H + 3
    end

    content:SetHeight(yOff + 8)
    sf:SetScrollChild(content)

    -- Plain slider for scrollbar
    local scrollH = WIN_H - 42 - 100
    local maxScroll = math.max(0, (yOff + 8) - scrollH)

    local sb = CreateFrame("Slider", "GMSetupSlider", mainFrame)
    sb:SetOrientation("VERTICAL")
    sb:SetPoint("TOPRIGHT",    mainFrame, "TOPRIGHT",    -2, -42)
    sb:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT", -2,  100)
    sb:SetWidth(14)
    sb:SetMinMaxValues(0, maxScroll)
    sb:SetValue(0)
    sb:SetValueStep(1)

    local sbBg = sb:CreateTexture(nil, "BACKGROUND")
    sbBg:SetAllPoints()
    sbBg:SetTexture(0.1, 0.1, 0.1, 0.8)

    local thumb = sb:CreateTexture(nil, "OVERLAY")
    thumb:SetTexture(0.5, 0.4, 0.15, 1)
    thumb:SetSize(10, 30)
    sb:SetThumbTexture(thumb)

    sb:SetScript("OnValueChanged", function(self, val)
        sf:SetVerticalScroll(val)
    end)
    sf:SetScript("OnMouseWheel", function(self, delta)
        local cur = sb:GetValue()
        local mn, mx = sb:GetMinMaxValues()
        sb:SetValue(math.max(mn, math.min(mx, cur - delta * (BTN_H + 3) * 3)))
    end)

    print("|cFFFFD700GMSetupTool:|r UI built — "..#GROUPS.." groups, "..#allCmds.." total commands.")
end

-- ============================================================
--  SLASH + BOOT
-- ============================================================
SLASH_GMSETUP1 = "/gmsetup"
SLASH_GMSETUP2 = "/gms"
SlashCmdList["GMSETUP"] = function()
    if not mainFrame then BuildUI() end
    if mainFrame:IsShown() then mainFrame:Hide() else mainFrame:Show() end
end

local boot = CreateFrame("Frame")
boot:RegisterEvent("PLAYER_LOGIN")
boot:SetScript("OnEvent", function(self)
    self:UnregisterAllEvents()
    BuildUI()
    print("|cFFFFD700GMSetupTool:|r Ready — /gmsetup to open")
end)

-- ============================================================
--  MINIMAP BUTTON
--  Small square using SetTexture for solid color background
-- ============================================================
local mmFrame = CreateFrame("Frame", "GMSetupMinimapFrame", UIParent)
mmFrame:SetSize(22, 22)
mmFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -2, -2)
mmFrame:SetFrameStrata("MEDIUM")
mmFrame:SetFrameLevel(8)
mmFrame:EnableMouse(true)
mmFrame:SetScript("OnMouseUp", function()
    if not mainFrame then BuildUI() end
    if mainFrame:IsShown() then mainFrame:Hide() else mainFrame:Show() end
end)

local mmBg = mmFrame:CreateTexture(nil, "BACKGROUND")
mmBg:SetAllPoints()
mmBg:SetTexture(0.1, 0.07, 0.02, 0.95)

local mmBorder = mmFrame:CreateTexture(nil, "BORDER")
mmBorder:SetAllPoints()
mmBorder:SetTexture("Interface\\Tooltips\\UI-Tooltip-Border")

local mmIc = mmFrame:CreateTexture(nil, "ARTWORK")
mmIc:SetSize(18, 18)
mmIc:SetPoint("CENTER")
mmIc:SetTexture("Interface\\Icons\\Spell_ChargePositive")
mmIc:SetTexCoord(0.08, 0.92, 0.08, 0.92)

mmFrame:SetScript("OnEnter", function()
    mmBg:SetTexture(0.25, 0.18, 0.04, 1)
    GameTooltip:SetOwner(mmFrame, "ANCHOR_LEFT")
    GameTooltip:SetText("|cFFFFD700GM Setup Tool|r")
    GameTooltip:AddLine("Click to open/close", 0.8, 0.8, 0.8)
    GameTooltip:AddLine("/gmsetup  or  /gms", 0.6, 0.6, 0.6)
    GameTooltip:Show()
end)
mmFrame:SetScript("OnLeave", function()
    mmBg:SetTexture(0.1, 0.07, 0.02, 0.95)
    GameTooltip:Hide()
end)
