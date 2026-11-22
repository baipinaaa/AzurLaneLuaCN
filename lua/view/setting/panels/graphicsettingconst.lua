GraphicSettingConst = {}
slot0 = GraphicSettingConst
slot0.PlayerGraphicLevelDorm = "dorm3d_graphics_settings_new"
slot0.PlayerGraphicLevelIsland = "island3d_graphics_settings_new"
slot0.SettingType = {
	toggle = 1,
	select = 2
}
slot0.SettingLevel = {
	High = 3,
	Mid = 2,
	Low = 1,
	Custom = 4
}
slot0.assetPath = {
	"Default_LowQualitySettings",
	"Default_MediumQualitySettings",
	"Default_HighQualitySettings",
	"Default_QualitySettings"
}
slot0.settings = {
	{
		tips = "grapihcs3d_setting_gpgpu_warning",
		playerPrefsname = "enableGPUDriver",
		settingType = 1,
		parameterId = 0,
		settingName = "grapihcs3d_setting_enable_gup_driver",
		isShow = 1,
		defaultValues = {
			0,
			0,
			1,
			0
		}
	},
	{
		parameterId = 3,
		settingType = 2,
		playerPrefsname = "gameOptions",
		settingName = "grapihcs3d_setting_global_illumination",
		isShow = 1,
		optionNames = {
			"grapihcs3d_setting_global_illumination_optionname0",
			"grapihcs3d_setting_global_illumination_optionname1",
			"grapihcs3d_setting_global_illumination_optionname2",
			"grapihcs3d_setting_global_illumination_optionname3"
		},
		options = {
			0,
			1,
			2,
			3
		},
		defaultValues = {
			2,
			2,
			2,
			2
		}
	},
	{
		parameterId = 12,
		settingType = 2,
		playerPrefsname = "bloomIntensity",
		settingName = "grapihcs3d_setting_bloom_intensity",
		isShow = 0,
		optionNames = {
			"grapihcs3d_setting_bloom_intensity_0",
			"grapihcs3d_setting_bloom_intensity_1",
			"grapihcs3d_setting_bloom_intensity_2",
			"grapihcs3d_setting_bloom_intensity_3"
		},
		options = {
			0,
			1,
			2,
			3
		},
		defaultValues = {
			3,
			3,
			3,
			3
		}
	},
	{
		parameterId = 2,
		settingType = 2,
		playerPrefsname = "resolution",
		settingName = "grapihcs3d_setting_resolution",
		isShow = 1,
		optionNames = {
			"grapihcs3d_setting_resolution_optionname0",
			"grapihcs3d_setting_resolution_optionname1",
			"grapihcs3d_setting_resolution_optionname2"
		},
		options = {
			1280,
			1920,
			2560
		},
		defaultValues = {
			1280,
			1920,
			2560,
			1920
		}
	},
	{
		parameterId = 1,
		settingType = 2,
		playerPrefsname = "renderingQuality",
		settingName = "grapihcs3d_setting_rendering_quality",
		isShow = 1,
		optionNames = {
			"grapihcs3d_setting_rendering_quality_optionname0",
			"grapihcs3d_setting_rendering_quality_optionname1"
		},
		options = {
			0,
			1
		},
		defaultValues = {
			0,
			0,
			0,
			0
		}
	},
	{
		parameterId = 4,
		settingType = 2,
		playerPrefsname = "shaderQuality",
		settingName = "grapihcs3d_setting_shader_quality",
		isShow = 1,
		optionNames = {
			"grapihcs3d_setting_shader_quality_optionname0",
			"grapihcs3d_setting_shader_quality_optionname1"
		},
		options = {
			0,
			1
		},
		defaultValues = {
			0,
			1,
			1,
			1
		}
	},
	{
		parameterId = 5,
		settingType = 1,
		playerPrefsname = "enableAdditionalLights",
		settingName = "grapihcs3d_setting_enable_additional_lights",
		isShow = 1,
		defaultValues = {
			0,
			1,
			1,
			1
		}
	},
	{
		parameterId = 6,
		settingType = 2,
		playerPrefsname = "shadowQuality",
		settingName = "grapihcs3d_setting_shadow_quality",
		isShow = 1,
		optionNames = {
			"grapihcs3d_setting_shadow_quality_optionname0",
			"grapihcs3d_setting_shadow_quality_optionname1",
			"grapihcs3d_setting_shadow_quality_optionname2",
			"grapihcs3d_setting_shadow_quality_optionname3"
		},
		options = {
			0,
			1,
			2,
			3
		},
		defaultValues = {
			0,
			2,
			3,
			2
		}
	},
	{
		parameterId = 7,
		settingType = 2,
		playerPrefsname = "shadowUpdateMode",
		settingName = "grapihcs3d_setting_shadow_update_mode",
		isShow = 1,
		optionNames = {
			"grapihcs3d_setting_shadow_update_mode_optionname0",
			"grapihcs3d_setting_shadow_update_mode_optionname1",
			"grapihcs3d_setting_shadow_update_mode_optionname2",
			"grapihcs3d_setting_shadow_update_mode_optionname3"
		},
		options = {
			0,
			1,
			2,
			3
		},
		defaultValues = {
			0,
			2,
			2,
			2
		}
	},
	{
		parameterId = 21,
		settingType = 2,
		playerPrefsname = "lodQuality",
		settingName = "Lod",
		isShow = 0,
		optionNames = {
			"关",
			"低",
			"中",
			"高"
		},
		options = {
			0,
			1,
			2,
			3
		},
		defaultValues = {
			3,
			3,
			3,
			3
		}
	},
	{
		parameterId = 18,
		settingType = 1,
		playerPrefsname = "enableAO",
		settingName = "AO",
		isShow = 0,
		defaultValues = {
			1,
			1,
			1,
			1
		}
	},
	{
		parameterId = 9,
		settingType = 1,
		playerPrefsname = "enablePostProcess",
		settingName = "grapihcs3d_setting_enable_post_process",
		isShow = 1,
		defaultValues = {
			1,
			1,
			1,
			1
		}
	},
	{
		parameterId = 8,
		settingType = 1,
		playerPrefsname = "enableReflection",
		settingName = "grapihcs3d_setting_enable_reflection",
		isShow = 1,
		defaultValues = {
			0,
			1,
			1,
			1
		}
	},
	{
		parentId = 12,
		parameterId = 10,
		settingType = 1,
		playerPrefsname = "enablePostAntialiasing",
		settingName = "grapihcs3d_setting_enable_post_antialiasing",
		isShow = 1,
		defaultValues = {
			0,
			0,
			0,
			1
		}
	},
	{
		parentId = 12,
		parameterId = 11,
		settingType = 1,
		playerPrefsname = "enableHDR",
		settingName = "grapihcs3d_setting_enable_hdr",
		isShow = 1,
		defaultValues = {
			1,
			1,
			1,
			1
		}
	},
	{
		parentId = 12,
		parameterId = 13,
		settingType = 1,
		playerPrefsname = "enableDOF",
		settingName = "grapihcs3d_setting_enable_dof",
		isShow = 1,
		defaultValues = {
			0,
			0,
			1,
			1
		}
	},
	{
		parentId = 12,
		parameterId = 14,
		settingType = 1,
		playerPrefsname = "enableDistort",
		settingName = "grapihcs3d_setting_enable_distort",
		isShow = 1,
		defaultValues = {
			0,
			0,
			1,
			1
		}
	},
	{
		parameterId = 15,
		settingType = 1,
		playerPrefsname = "enableFog",
		settingName = "雾",
		isShow = 0,
		defaultValues = {
			1,
			1,
			1,
			1
		}
	},
	{
		parameterId = 16,
		settingType = 1,
		playerPrefsname = "enableFlare",
		settingName = "grapihcs3d_setting_flare",
		isShow = 1,
		defaultValues = {
			1,
			1,
			1,
			1
		}
	},
	{
		parameterId = 17,
		settingType = 1,
		playerPrefsname = "enableLensFlare",
		settingName = "镜头炫光",
		isShow = 0,
		defaultValues = {
			1,
			1,
			1,
			1
		}
	},
	{
		parameterId = 19,
		settingType = 2,
		playerPrefsname = "characterQuality",
		settingName = "grapihcs3d_setting_character_quality",
		isShow = 1,
		optionNames = {
			"grapihcs3d_setting_character_quality_optionname0",
			"grapihcs3d_setting_character_quality_optionname1",
			"grapihcs3d_setting_character_quality_optionname2"
		},
		options = {
			0,
			1,
			2
		},
		defaultValues = {
			0,
			1,
			2,
			1
		}
	},
	{
		parameterId = 20,
		settingType = 2,
		playerPrefsname = "terrainLayerQuality",
		settingName = "grapihcs3d_setting_terrain_layer_quality",
		isShow = 1,
		optionNames = {
			"grapihcs3d_setting_terrain_layer_quality_optionname0",
			"grapihcs3d_setting_terrain_layer_quality_optionname1",
			"grapihcs3d_setting_terrain_layer_quality_optionname2"
		},
		options = {
			0,
			1,
			2
		},
		defaultValues = {
			0,
			1,
			2,
			1
		}
	}
}

slot0.InitDefautQuality = function(slot0)
	if PlayerPrefs.GetInt(slot0 and uv0.PlayerGraphicLevelIsland or uv0.PlayerGraphicLevelDorm, 0) == 0 then
		slot3 = DevicePerformanceUtil.GetDevicePerformanceLevel()

		if PLATFORM == PLATFORM_IPHONEPLAYER then
			slot6 = function(slot0)
				if tonumber(string.match(slot0, "iPhone(%d+)")) and slot2 >= 13 then
					return true
				end

				return false
			end

			if (function (slot0)
				if tonumber(string.match(slot0, "iPad(%d+)")) and slot2 >= 8 then
					return true
				end

				return false
			end)(SystemInfo.deviceModel or "") or slot6(slot4) then
				slot3 = DevicePerformanceLevel.High
			end
		end

		slot2 = slot3 == DevicePerformanceLevel.High and 3 or slot3 == DevicePerformanceLevel.Mid and 2 or 1

		if slot0 then
			PlayerPrefs.SetInt(slot1, 1)
		else
			PlayerPrefs.SetInt(slot1, slot2)
		end

		if not slot0 then
			Dorm3dRoomTemplateScene.FirstDefaultSetting = slot2
		end
	end
end

slot0.SettingQuality = function(slot0)
	if PlayerPrefs.GetInt(slot0 and uv0.PlayerGraphicLevelIsland or uv0.PlayerGraphicLevelDorm, 4) ~= 4 then
		for slot6, slot7 in ipairs(uv0.settings) do
			GraphicsInterface.Instance:SetQualitySettings(slot7.parameterId, slot7.defaultValues[slot2])
		end

		return
	end

	for slot6, slot7 in ipairs(uv0.settings) do
		slot8 = slot7.parameterId
		slot11 = slot7.defaultValues[4]

		if PlayerPrefs.GetInt(slot0 and slot7.playerPrefsname .. "island" or slot7.playerPrefsname, -1) ~= -1 then
			slot11 = slot10
		end

		GraphicsInterface.Instance:SetQualitySettings(slot8, slot11)
	end
end

slot0.ClearPlayerPrefs = function()
	if PlayerPrefs.GetInt("dorm3d_graphics_settings_changeed", 0) == 1 then
		return
	end

	PlayerPrefs.SetInt("dorm3d_graphics_settings_changeed", 1)

	for slot3, slot4 in ipairs(uv0.settings) do
		PlayerPrefs.DeleteKey(slot4.playerPrefsname)
	end
end

return slot0
