pg = pg or {}
slot0 = pg
slot0.FontMgr = singletonClass("FontMgr")
slot1 = slot0.FontMgr
slot1.FONT_NAME_IMPACT = "impact"

slot1.Init = function(slot0, slot1)
	print("initializing font manager...")

	slot2 = {}

	for slot6, slot7 in pairs({
		impact = "impact",
		remfont = "remfont",
		lvnumber = "lvnumber",
		heitibold = "ZhunYuan_Bold",
		crifont = "crifont",
		heiti = "zhunyuan",
		explofont = "explofont",
		bankgthd = "bankgthd",
		countnumber = "countnumber",
		weaponcountfont = "weaponcountfont",
		missfont = "missfont",
		treatfont = "treatfont",
		MStiffHei = "MStiffHei",
		chuanjiadanFont = "chuanjiadanFont",
		number = "number",
		sourcehanserifcn = "sourcehanserifcn-bold_0",
		weijichuanFont = "weijichuanFont"
	}) do
		table.insert(slot2, function (slot0)
			AssetBundleHelper.StoreAssetBundle("font/" .. uv0, true, false, function (slot0)
				uv0()
			end)
		end)
	end

	parallelAsync(slot2, function (slot0)
		uv0(slot0)
	end)
end
