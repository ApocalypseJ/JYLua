------------------------------------------------------------------
---------------------��Ŀ�ɾ�ϵͳʹ�����´���---------------------
------------------------------------------------------------------

function SaveTableContent(file, obj)
	local szType = type(obj)
	if szType == "number" then
		file:write(obj)
	elseif szType == "string" then
		file:write(string.format("%q", obj))
	elseif szType == "table" then
		--��table�����ݸ�ʽ��д���ļ�
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

--����񱣴����ļ�
function SaveTable(t)
	local file = io.open(CC.Acvmts, "w")
	assert(file)
	file:write("Achievements = \n")
	SaveTableContent(file, t)
	file:close()
end

--������Ŀ
function AddZM()
	--ִ�гɾ��ļ�
	dofile(CC.Acvmts)
	--�������
	local sp
	local nd = 1+0.1*(JY.Base["�Ѷ�"] - 1)
	if JY.Base["��ͨ"] == 1 then
		nd = nd + 0.3
	end
	local rw = 50
	if JY.Base["����"] > 0 then
		if JY.Person[0]["����ֽ�"] <= 1 then
			rw = 70
		end
		if Achievements.rdsCpltd[JY.Base["����"]].n == 0 then
			rw = rw * 3
		end
	end
	local bonus = 0
	if JY.Person[104]["Ʒ��"] == 90 then
		bonus = 100
	elseif JY.Person[104]["Ʒ��"] == 100 then
	    bonus = 200
	end
	if JY.Person[674]["Ʒ��"] == 3 then
		bonus = bonus + 100
	elseif JY.Person[674]["Ʒ��"] == 1 or JY.Person[674]["Ʒ��"] == 120 then
	    bonus = bonus + 300
	end
	if JY.Person[124]["��1"] > 0 then
	   bonus = bonus + JY.Person[124]["��1"]*10
	end
	if JY.Person[123]["��1"] > 0 then
	   bonus = bonus + JY.Person[123]["��1"]*41
	end
	sp = rw * nd + bonus
	Achievements.sp = Achievements.sp + sp
	--��Ŀ+1
	if JY.Base["��Ŀ"] == Achievements.Round then
		Achievements.Round = Achievements.Round + 1
	end
	if JY.Base["����"] > 0 then 
		Achievements.rdsCpltd[JY.Base["����"]].n = Achievements.rdsCpltd[JY.Base["����"]].n + 1
		if JY.Base["�Ѷ�"] >= Achievements.rdsCpltd[JY.Base["����"]].lvlReached2 then
			Achievements.rdsCpltd[JY.Base["����"]].lvlReached1 = JY.Base["��Ŀ"]
			Achievements.rdsCpltd[JY.Base["����"]].lvlReached2 = JY.Base["�Ѷ�"]
		end
	end
	if JY.Base["����"] == 1 then
		Achievements.rdsCpltd[642].n = Achievements.rdsCpltd[642].n + 1
		if JY.Base["�Ѷ�"] >= Achievements.rdsCpltd[642].lvlReached2 then
			Achievements.rdsCpltd[642].lvlReached1 = JY.Base["��Ŀ"]
			Achievements.rdsCpltd[642].lvlReached2 = JY.Base["�Ѷ�"]
		end
	end	
	if JY.Person[124]["��1"] > 29 then
	    Achievements.rdsCpltd[92].n = Achievements.rdsCpltd[92].n + 1
		if JY.Base["�Ѷ�"] >= Achievements.rdsCpltd[92].lvlReached2 then
			Achievements.rdsCpltd[92].lvlReached1 = JY.Base["��Ŀ"]
			Achievements.rdsCpltd[92].lvlReached2 = JY.Base["�Ѷ�"]
		end 	
	end
	if JY.Person[124]["��1"] > 19 then
		Achievements.rdsCpltd[680].n = Achievements.rdsCpltd[680].n + 1
		if JY.Base["�Ѷ�"] >= Achievements.rdsCpltd[680].lvlReached2 then
			Achievements.rdsCpltd[680].lvlReached1 = JY.Base["��Ŀ"]
			Achievements.rdsCpltd[680].lvlReached2 = JY.Base["�Ѷ�"]
		end
	end	
	if JY.Person[124]["��1"] > 1 then
	    Achievements.rdsCpltd[679].n = Achievements.rdsCpltd[679].n + 1
		if JY.Base["�Ѷ�"] >= Achievements.rdsCpltd[679].lvlReached2 then
			Achievements.rdsCpltd[679].lvlReached1 = JY.Base["��Ŀ"]
			Achievements.rdsCpltd[679].lvlReached2 = JY.Base["�Ѷ�"]
		end 	
	end
	
	--��¼ͨ��������Ϣ
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
	if JY.Base["��׼"] > 0 then
		cType = "��׼"
		cChar = JY.Base["��׼"] + 1677
		cName = ZJTF[JY.Base["��׼"]]
		cTier = JY.Person[0]["��"]
	elseif JY.Base["����"] > 0 then
		cType = "����"
		cName = JY.Person[0]["����"]
		cTier = JY.Person[0]["��"]
	else
		cType = "����"
		cChar = JY.Base["����"]
		cName = JY.Person[0]["����"]
		cTier = JY.Person[JY.Base["����"]]["��"]
	end
	if fx ~= 0 then 
	   cNS = "��"..(-yin).."��"..yang
	elseif fx == 0 then
	   cNS = "����"..(yang+1)
	end
	for i = 1, 15 do
	cWg[i] = JY.Person[0]["�书"..i]
	end
	for i = 1, 4 do
	cTw[i] = JY.Person[0]["�츳�⹦"..i]
	end
	if JY.Base["����"] > 0 then
	for i = 1, 4 do
	cTf[i] = JY.Person[JY.Base["����"]]["��"..i]
	end
	end
	
	if JY.Person[124]["��1"] > 6 then
	   cZj1 = 1
	end

	if JY.Person[124]["��1"] > 19 then
	   cZj2 = 1
	end
	
	if JY.Person[124]["��1"] > 24 or JY.Person[674]["Ʒ��"] == 120 then
	   cSzjl = 1
	   cStf1 = JY.Person[125]["Ʒ��"]
	   cStf2 = JY.Person[125]["����"]
	end	
	
	Achievements.pChar[1000] = {
	CharTi = cTier,
	CharAw1 = cZj1,
	CharAw2 = cZj2,
	CharAw3 = cSzjl,
	CharAw4 = cStf1,
	CharAw5 = cStf2,
	CharZj1 = JY.Person[0]["ר1"],
	CharZj2 = JY.Person[0]["ר2"],
	CharWg = cWg,
	CharTd = cChar,
	CharTf = cTf,
	CharTw = cTw,
	CharZn = JY.Person[0]["�����ڹ�"],
	CharZq = JY.Person[0]["�����Ṧ"],
	CharHb = JY.Person[0]["���һ���"],
	CharDz = JY.Person[0]["��ս"],
	CharXs = JY.Person[0]["ϴ��"],
	CharTn = JY.Person[0]["�츳�ڹ�"],
	CharHp = JY.Person[0]["�������ֵ"],
	CharMp = JY.Person[0]["�������ֵ"],
	CharAt = JY.Person[0]["������"],
	CharDe = JY.Person[0]["������"],
	CharAg = JY.Person[0]["�Ṧ"],
	CharQz = JY.Person[0]["ȭ�ƹ���"],
	CharYj = JY.Person[0]["��������"],
	CharSd = JY.Person[0]["ˣ������"],
	CharZf = JY.Person[0]["ָ������"],
	CharQm = JY.Person[0]["�������"],
	CharWc = JY.Person[0]["��ѧ��ʶ"],
	CharZz = JY.Person[0]["����"],
	}
	if JY.Base["��׼"] > 0 then
	   Achievements.pChar[999][JY.Base["��׼"]] = Achievements.pChar[999][JY.Base["��׼"]] + 1
	end

	Achievements.pChar[#Achievements.pChar+1] = {
	DiffLevel = JY.Base["�Ѷ�"],
	CharType = cType,
	CharName = cName,
	CharZZ = JY.Person[0]["����"],
	CharNS = cNS,
	TimeCompleted = os.date()
	}
	SaveTable(Achievements)
	return sp
end

--�鿴ͨ�ع�������
function pastReview()
	--ִ�гɾ��ļ�
	if existFile(CC.Acvmts) then
		dofile(CC.Acvmts)
		while true do
			if JY.Restart == 1 then
				return
			end
			Cls()
			
			lib.LoadPNG(1, 1000 * 2 , 0, 0, 1)
			
			DrawString(360,50," ����ͨ�ؼ�¼",C_GOLD,CC.DefaultFont)
			
			DrawString(CC.ScreenW - 148,CC.ScreenH - 40,"��ESC���˳�",LimeGreen,CC.FontSmall)
			
			local n = 0
			
			for i = #Achievements.pChar, 1, -1 do
				n = n + 1
				if n > 5 then
					break
				end
				local nd = Achievements.pChar[i].DiffLevel
				local zz = tostring(Achievements.pChar[i].CharZZ.."��")
				local ns = Achievements.pChar[i].CharNS
				local tp = Achievements.pChar[i].CharType
				local nm = Achievements.pChar[i].CharName
				local dt = Achievements.pChar[i].TimeCompleted
				local ss = {"һ", "��", "��", "��", "��", "��", "��"}
				DrawString(45,-10+110*n,string.format(ss[n],i),C_GOLD,CC.DefaultFont)
				DrawString(45,40+110*n,string.format("��%-d %-5s %-4s %-4s %-10s ͨ��ʱ�� %s",nd, zz ,ns, tp, nm, dt),C_WHITE,CC.DefaultFont)
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
