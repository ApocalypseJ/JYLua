------------------------------------------------------------------
---------------------周目成就系统使用以下代码---------------------
------------------------------------------------------------------

function SaveTableContent(file, obj)
	local szType = type(obj)
	if szType == "number" then
		file:write(obj)
	elseif szType == "string" then
		file:write(string.format("%q", obj))
	elseif szType == "table" then
		--把table的内容格式化写入文件
		file:write("{\n")
		for i, v in pairs(obj) do
			file:write("[")
			SaveTableContent(file, i)
			file:write("]=\n")
			SaveTableContent(file, v)
			file:write(", \n")
		end
		file:write("}\n")
	else
		error("undefined type"..szType)
	end
end

--将表格保存至文件
function SaveTable(t)
	local file = io.open(CC.Acvmts, "w")
	assert(file)
	file:write("Achievements = \n")
	SaveTableContent(file, t)
	file:close()
end

--增加周目
function AddZM()
	--执行成就文件
	dofile(CC.Acvmts)
	--秘武残章
	local sp
	local nd = 1+0.1*(JY.Base["难度"] - 1)
	if JY.Base["单通"] == 1 then
		nd = nd + 0.3
	end
	local rw = 50
	if JY.Base["畅想"] > 0 then
		if JY.Person[0]["畅想分阶"] <= 1 then
			rw = 70
		end
		if Achievements.rdsCpltd[JY.Base["畅想"]].n == 0 then
			rw = rw * 3
		end
	end
	local bonus = 0
	if JY.Person[104]["品德"] == 90 then
		bonus = 100
	elseif JY.Person[104]["品德"] == 100 then
	    bonus = 200
	end
	if JY.Person[674]["品德"] == 3 then
		bonus = bonus + 100
	elseif JY.Person[674]["品德"] == 1 or JY.Person[674]["品德"] == 120 then
	    bonus = bonus + 300
	end
	if JY.Person[124]["天1"] > 0 then
	   bonus = bonus + JY.Person[124]["天1"]*10
	end
	if JY.Person[123]["天1"] > 0 then
	   bonus = bonus + JY.Person[123]["天1"]*41
	end
	sp = rw * nd + bonus
	Achievements.sp = Achievements.sp + sp
	--周目+1
	if JY.Base["周目"] == Achievements.Round then
		Achievements.Round = Achievements.Round + 1
	end
	if JY.Base["畅想"] > 0 then 
		Achievements.rdsCpltd[JY.Base["畅想"]].n = Achievements.rdsCpltd[JY.Base["畅想"]].n + 1
		if JY.Base["难度"] >= Achievements.rdsCpltd[JY.Base["畅想"]].lvlReached2 then
			Achievements.rdsCpltd[JY.Base["畅想"]].lvlReached1 = JY.Base["周目"]
			Achievements.rdsCpltd[JY.Base["畅想"]].lvlReached2 = JY.Base["难度"]
		end
	end
	if JY.Base["特殊"] == 1 then
		Achievements.rdsCpltd[642].n = Achievements.rdsCpltd[642].n + 1
		if JY.Base["难度"] >= Achievements.rdsCpltd[642].lvlReached2 then
			Achievements.rdsCpltd[642].lvlReached1 = JY.Base["周目"]
			Achievements.rdsCpltd[642].lvlReached2 = JY.Base["难度"]
		end
	end	
	if JY.Person[124]["天1"] > 29 then
	    Achievements.rdsCpltd[92].n = Achievements.rdsCpltd[92].n + 1
		if JY.Base["难度"] >= Achievements.rdsCpltd[92].lvlReached2 then
			Achievements.rdsCpltd[92].lvlReached1 = JY.Base["周目"]
			Achievements.rdsCpltd[92].lvlReached2 = JY.Base["难度"]
		end 	
	end
	if JY.Person[124]["天1"] > 19 then
		Achievements.rdsCpltd[680].n = Achievements.rdsCpltd[680].n + 1
		if JY.Base["难度"] >= Achievements.rdsCpltd[680].lvlReached2 then
			Achievements.rdsCpltd[680].lvlReached1 = JY.Base["周目"]
			Achievements.rdsCpltd[680].lvlReached2 = JY.Base["难度"]
		end
	end	
	if JY.Person[124]["天1"] > 1 then
	    Achievements.rdsCpltd[679].n = Achievements.rdsCpltd[679].n + 1
		if JY.Base["难度"] >= Achievements.rdsCpltd[679].lvlReached2 then
			Achievements.rdsCpltd[679].lvlReached1 = JY.Base["周目"]
			Achievements.rdsCpltd[679].lvlReached2 = JY.Base["难度"]
		end 	
	end
	
	--记录通关人物信息
	local cType, cName, cNS, cChar, cTn, cTier
	local yin, yang, tg = NeiL(0)
	local fx = yin + yang
	local cWg={}
	local cTf={}
	local cTw={}
	local cZj1 = 0
	local cZj2 = 0
	local cSzjl = 0
	local cStf1, cStf2 = 0, 0
	if JY.Base["标准"] > 0 then
		cType = "标准"
		cChar = JY.Base["标准"] + 1677
		cName = ZJTF[JY.Base["标准"]]
		cTier = JY.Person[0]["阶"]
	elseif JY.Base["特殊"] > 0 then
		cType = "特殊"
		cName = JY.Person[0]["姓名"]
		cTier = JY.Person[0]["阶"]
	else
		cType = "畅想"
		cChar = JY.Base["畅想"]
		cName = JY.Person[0]["姓名"]
		cTier = JY.Person[JY.Base["畅想"]]["阶"]
	end
	if fx ~= 0 then 
	   cNS = "阴"..(-yin).."阳"..yang
	elseif fx == 0 then
	   cNS = "调和"..(yang+1)
	end
	for i = 1, 15 do
	cWg[i] = JY.Person[0]["武功"..i]
	end
	for i = 1, 4 do
	cTw[i] = JY.Person[0]["天赋外功"..i]
	end
	if JY.Base["畅想"] > 0 then
	for i = 1, 4 do
	cTf[i] = JY.Person[JY.Base["畅想"]]["天"..i]
	end
	end
	
	if JY.Person[124]["天1"] > 6 then
	   cZj1 = 1
	end

	if JY.Person[124]["天1"] > 19 then
	   cZj2 = 1
	end
	
	if JY.Person[124]["天1"] > 24 or JY.Person[674]["品德"] == 120 then
	   cSzjl = 1
	   cStf1 = JY.Person[125]["品德"]
	   cStf2 = JY.Person[125]["声望"]
	end	
	
	Achievements.pChar[1000] = {
	CharTi = cTier,
	CharAw1 = cZj1,
	CharAw2 = cZj2,
	CharAw3 = cSzjl,
	CharAw4 = cStf1,
	CharAw5 = cStf2,
	CharZj1 = JY.Person[0]["专1"],
	CharZj2 = JY.Person[0]["专2"],
	CharWg = cWg,
	CharTd = cChar,
	CharTf = cTf,
	CharTw = cTw,
	CharZn = JY.Person[0]["主运内功"],
	CharZq = JY.Person[0]["主运轻功"],
	CharHb = JY.Person[0]["左右互搏"],
	CharDz = JY.Person[0]["出战"],
	CharXs = JY.Person[0]["洗髓"],
	CharTn = JY.Person[0]["天赋内功"],
	CharHp = JY.Person[0]["生命最大值"],
	CharMp = JY.Person[0]["内力最大值"],
	CharAt = JY.Person[0]["攻击力"],
	CharDe = JY.Person[0]["防御力"],
	CharAg = JY.Person[0]["轻功"],
	CharQz = JY.Person[0]["拳掌功夫"],
	CharYj = JY.Person[0]["御剑能力"],
	CharSd = JY.Person[0]["耍刀技巧"],
	CharZf = JY.Person[0]["指法技巧"],
	CharQm = JY.Person[0]["特殊兵器"],
	CharWc = JY.Person[0]["武学常识"],
	CharZz = JY.Person[0]["资质"],
	}
	if JY.Base["标准"] > 0 then
	   Achievements.pChar[999][JY.Base["标准"]] = Achievements.pChar[999][JY.Base["标准"]] + 1
	end

	Achievements.pChar[#Achievements.pChar+1] = {
	DiffLevel = JY.Base["难度"],
	CharType = cType,
	CharName = cName,
	CharZZ = JY.Person[0]["资质"],
	CharNS = cNS,
	TimeCompleted = os.date()
	}
	SaveTable(Achievements)
	return sp
end

--查看通关过的人物
function pastReview()
	--执行成就文件
	if existFile(CC.Acvmts) then
		dofile(CC.Acvmts)
		while true do
			if JY.Restart == 1 then
				return
			end
			Cls()
			
			lib.LoadPNG(1, 1000 * 2 , 0, 0, 1)
			
			DrawString(360,50," 近期通关记录",C_GOLD,CC.DefaultFont)
			
			DrawString(CC.ScreenW - 148,CC.ScreenH - 40,"按ESC键退出",LimeGreen,CC.FontSmall)
			
			local n = 0
			
			for i = #Achievements.pChar, 1, -1 do
				n = n + 1
				if n > 5 then
					break
				end
				local nd = Achievements.pChar[i].DiffLevel
				local zz = tostring(Achievements.pChar[i].CharZZ.."资")
				local ns = Achievements.pChar[i].CharNS
				local tp = Achievements.pChar[i].CharType
				local nm = Achievements.pChar[i].CharName
				local dt = Achievements.pChar[i].TimeCompleted
				local ss = {"一", "二", "三", "四", "五", "六", "七"}
				DrawString(45,-10+110*n,string.format(ss[n],i),C_GOLD,CC.DefaultFont)
				DrawString(45,40+110*n,string.format("难%-d %-5s %-4s %-4s %-10s 通关时间 %s",nd, zz ,ns, tp, nm, dt),C_WHITE,CC.DefaultFont)
			end
			
			local keypress, ktype, mx, my = lib.GetKey()
			
			if keypress == VK_ESCAPE then
				break
			end
			ShowScreen()
			lib.Delay(CC.Frame)
		end
	end
end
