--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

-- Create the addon using AceAddon-3.0 and embed some libraries.
local AJM = LibStub( "AceAddon-3.0" ):NewAddon( 
	"JambaToon", 
	"JambaModule-1.0", 
	"AceConsole-3.0", 
	"AceEvent-3.0",
	"AceTimer-3.0"
)

-- Get the Jamba Utilities Library.
local JambaUtilities = LibStub:GetLibrary( "JambaUtilities-1.0" )
local JambaHelperSettings = LibStub:GetLibrary( "JambaHelperSettings-1.0" )
local LibBagUtils = LibStub:GetLibrary( "LibBagUtils-1.0" )
AJM.SharedMedia = LibStub( "LibSharedMedia-3.0" )

--  Constants and Locale for this module.
AJM.moduleName = "Jamba-Toon"
AJM.settingsDatabaseName = "JambaToonProfileDB"
AJM.chatCommand = "jamba-toon"
local L = LibStub( "AceLocale-3.0" ):GetLocale( AJM.moduleName )
AJM.parentDisplayName = L["Toon"]
AJM.parentDisplayNameToon = L["Toon"]
AJM.parentDisplayNameMerchant = L["Merchant"]
AJM.parentDisplayNameCurrency = L["Toon"]
AJM.moduleDisplayName = L["Toon: Warnings"]

AJM.globalCurrencyFramePrefix = "JambaToonCurrencyListFrame"

-- Settings - the values to store and their defaults for the settings database.
AJM.settings = {
	profile = {
		warnHitFirstTimeCombat = false,
		hitFirstTimeMessage = L["I'm Attacked!"],
		warnTargetNotMasterEnterCombat = false,
		warnTargetNotMasterMessage = L["Not Targeting!"],
		warnFocusNotMasterEnterCombat = false,
		warnFocusNotMasterMessage = L["Not Focus!"],
		warnWhenHealthDropsBelowX = true,
		warnWhenHealthDropsAmount = "60",
		warnHealthDropsMessage = L["Low Health!"],
		warnWhenManaDropsBelowX = true,
		warnWhenManaDropsAmount = "30",
		warnManaDropsMessage = L["Low Mana!"],
		warnBagsFull = true,
		bagsFullMessage = L["Bags Full!"],
		warningArea = JambaApi.DefaultWarningArea(),
		autoAcceptResurrectRequest = true,
		autoDenyDuels = true,
		autoDenyGuildInvites = true,
		requestArea = JambaApi.DefaultMessageArea(),
		autoRepair = true,
		autoRepairUseGuildFunds = true,
		merchantArea = JambaApi.DefaultMessageArea(),
		warnAfk = true,
		afkMessage = L["I am inactive!"],
		currGold = true,
		currGoldInGuildBank = false,
        currEmblemOfFrost = false,
        currEmblemOfTriumph = false,
        currEmblemOfConquest = false,
        currEmblemOfValor = false,
        currEmblemOfHeroism = false,
        currHonorPoints = false,
        currArenaPoints = false,
		currencyFrameAlpha = 1.0,
		currencyFramePoint = "CENTER",
		currencyFrameRelativePoint = "CENTER",
		currencyFrameXOffset = 0,
		currencyFrameYOffset = 0,
		currencyFrameBackgroundColourR = 1.0,
		currencyFrameBackgroundColourG = 1.0,
		currencyFrameBackgroundColourB = 1.0,
		currencyFrameBackgroundColourA = 1.0,
		currencyFrameBorderColourR = 1.0,
		currencyFrameBorderColourG = 1.0,
		currencyFrameBorderColourB = 1.0,
		currencyFrameBorderColourA = 1.0,		
		currencyBorderStyle = L["Blizzard Tooltip"],
		currencyBackgroundStyle = L["Blizzard Dialog Background"],
		currencyScale = 1,
		currencyNameWidth = 50,
		currencyPointsWidth = 30,
		currencyGoldWidth = 90,
		currencySpacingWidth = 3,
		currencyLockWindow = false,
		currOpenStartUpMaster = false,
	},
}

-- Configuration.
function AJM:GetConfiguration()
	local configuration = {
		name = AJM.moduleDisplayName,
		handler = AJM,
		type = 'group',
		args = {
			currency = {
				type = "input",
				name = L["Show Currency"],
				desc = L["Show the current toon the currency values for all members in the team."],
				usage = "/jamba-toon currency",
				get = false,
				set = "JambaToonRequestCurrency",
			},
			push = {
				type = "input",
				name = L["Push Settings"],
				desc = L["Push the toon settings to all characters in the team."],
				usage = "/jamba-toon push",
				get = false,
				set = "JambaSendSettings",
			},											
		},
	}
	return configuration
end

local function DebugMessage( ... )
	--AJM:Print( ... )
end

-------------------------------------------------------------------------------------------------------------
-- Command this module sends.
-------------------------------------------------------------------------------------------------------------

AJM.COMMAND_REQUEST_CURRENCY = "SendCurrency"
AJM.COMMAND_HERE_IS_CURRENCY = "HereIsCurrency"

-------------------------------------------------------------------------------------------------------------
-- Messages module sends.
-------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------
-- Settings Dialogs.
-------------------------------------------------------------------------------------------------------------

local function SettingsCreateMerchant( top )
	-- Get positions.
	local checkBoxHeight = JambaHelperSettings:GetCheckBoxHeight()
	local editBoxHeight = JambaHelperSettings:GetEditBoxHeight()
	local dropdownHeight = JambaHelperSettings:GetDropdownHeight()
	local labelHeight = JambaHelperSettings:GetLabelHeight()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( false )
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local halfWidth = (headingWidth - horizontalSpacing) / 2
	local thirdWidth = (headingWidth - (horizontalSpacing * 2)) / 3
	local column2left = left + halfWidth
	local left2 = left + thirdWidth
	local left3 = left + (thirdWidth * 2)
	local movingTop = top
	JambaHelperSettings:CreateHeading( AJM.settingsControlMerchant, L["Merchant"], movingTop, false )
	movingTop = movingTop - headingHeight
	AJM.settingsControlMerchant.checkBoxAutoRepair = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlMerchant, 
		headingWidth, 
		left, 
		movingTop, 
		L["Auto Repair"],
		AJM.SettingsToggleAutoRepair
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlMerchant.checkBoxAutoRepairUseGuildFunds = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlMerchant, 
		headingWidth, 
		left, 
		movingTop, 
		L["Auto Repair With Guild Funds"],
		AJM.SettingsToggleAutoRepairUseGuildFunds
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlMerchant.dropdownMerchantArea = JambaHelperSettings:CreateDropdown( 
		AJM.settingsControlMerchant, 
		headingWidth, 
		left, 
		movingTop, 
		L["Send Request Message Area"] 
	)
	AJM.settingsControlMerchant.dropdownMerchantArea:SetList( JambaApi.MessageAreaList() )
	AJM.settingsControlMerchant.dropdownMerchantArea:SetCallback( "OnValueChanged", AJM.SettingsSetMerchantArea )
	movingTop = movingTop - dropdownHeight - verticalSpacing				
	return movingTop	
end

local function SettingsCreateRequests( top )
	-- Get positions.
	local checkBoxHeight = JambaHelperSettings:GetCheckBoxHeight()
	local editBoxHeight = JambaHelperSettings:GetEditBoxHeight()
	local dropdownHeight = JambaHelperSettings:GetDropdownHeight()
	local labelHeight = JambaHelperSettings:GetLabelHeight()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( false )
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local halfWidth = (headingWidth - horizontalSpacing) / 2
	local thirdWidth = (headingWidth - (horizontalSpacing * 2)) / 3
	local column2left = left + halfWidth
	local left2 = left + thirdWidth
	local left3 = left + (thirdWidth * 2)
	local movingTop = top
	JambaHelperSettings:CreateHeading( AJM.settingsControlRequests, L["Requests"], movingTop, false )
	movingTop = movingTop - headingHeight
	AJM.settingsControlRequests.checkBoxAutoDenyDuels = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlRequests, 
		headingWidth, 
		left, 
		movingTop, 
		L["Auto Deny Duels"],
		AJM.SettingsToggleAutoDenyDuels
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlRequests.checkBoxAutoDenyGuildInvites = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlRequests, 
		headingWidth, 
		left, 
		movingTop, 
		L["Auto Deny Guild Invites"],
		AJM.SettingsToggleAutoDenyGuildInvites
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlRequests.checkBoxAutoAcceptResurrectRequest = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlRequests, 
		headingWidth, 
		left, 
		movingTop, 
		L["Auto Accept Resurrect Request"],
		AJM.SettingsToggleAutoAcceptResurrectRequests
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlRequests.dropdownRequestArea = JambaHelperSettings:CreateDropdown( 
		AJM.settingsControlRequests, 
		headingWidth, 
		left, 
		movingTop, 
		L["Send Request Message Area"] 
	)
	AJM.settingsControlRequests.dropdownRequestArea:SetList( JambaApi.MessageAreaList() )
	AJM.settingsControlRequests.dropdownRequestArea:SetCallback( "OnValueChanged", AJM.SettingsSetRequestArea )
	movingTop = movingTop - dropdownHeight - verticalSpacing			
	return movingTop	
end

local function SettingsCreateCurrency( top )
	-- Get positions.
	local checkBoxHeight = JambaHelperSettings:GetCheckBoxHeight()
	local sliderHeight = JambaHelperSettings:GetSliderHeight()
	local mediaHeight = JambaHelperSettings:GetMediaHeight()	
	local editBoxHeight = JambaHelperSettings:GetEditBoxHeight()
	local buttonHeight = JambaHelperSettings:GetButtonHeight()
	local dropdownHeight = JambaHelperSettings:GetDropdownHeight()
	local labelHeight = JambaHelperSettings:GetLabelHeight()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( true )
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local halfWidth = (headingWidth - horizontalSpacing) / 2
	local thirdWidth = (headingWidth - (horizontalSpacing * 2)) / 3
	local halfWidthSlider = (headingWidth - horizontalSpacing) / 2
	local column2left = left + halfWidthSlider
	local left2 = left + thirdWidth
	local left3 = left + (thirdWidth * 2)
	local movingTop = top
	JambaHelperSettings:CreateHeading( AJM.settingsControlCurrency, L["Currency Selection"], movingTop, true )
	movingTop = movingTop - headingHeight
	AJM.settingsControlCurrency.checkBoxCurrencyGold = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlCurrency, 
		headingWidth, 
		left, 
		movingTop, 
		L["Gold"],
		AJM.SettingsToggleCurrencyGold
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlCurrency.checkBoxCurrencyGoldInGuildBank = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlCurrency, 
		headingWidth, 
		left, 
		movingTop, 
		L["Include Gold In Guild Bank"],
		AJM.SettingsToggleCurrencyGoldInGuildBank
	)	
	movingTop = movingTop - checkBoxHeight		
	AJM.settingsControlCurrency.checkBoxCurrencyEmblemOfFrost = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlCurrency, 
		headingWidth, 
		left, 
		movingTop, 
		L["Emblem of Frost"]..L[" ("]..L["EoF"]..L[")"],
		AJM.SettingsToggleCurrencyEmblemOfFrost
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlCurrency.checkBoxCurrencyEmblemOfTriumph = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlCurrency, 
		headingWidth, 
		left, 
		movingTop, 
		L["Emblem of Triumph"]..L[" ("]..L["EoT"]..L[")"],
		AJM.SettingsToggleCurrencyEmblemOfTriumph
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlCurrency.checkBoxCurrencyEmblemOfConquest = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlCurrency, 
		headingWidth, 
		left, 
		movingTop, 
		L["Emblem of Conquest"]..L[" ("]..L["EoC"]..L[")"],
		AJM.SettingsToggleCurrencyEmblemOfConquest
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlCurrency.checkBoxCurrencyEmblemOfValor = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlCurrency, 
		headingWidth, 
		left, 
		movingTop, 
		L["Emblem of Valor"]..L[" ("]..L["EoV"]..L[")"],
		AJM.SettingsToggleCurrencyEmblemOfValor
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlCurrency.checkBoxCurrencyEmblemOfHeroism = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlCurrency, 
		headingWidth, 
		left, 
		movingTop, 
		L["Emblem of Heroism"]..L[" ("]..L["EoH"]..L[")"],
		AJM.SettingsToggleCurrencyEmblemOfHeroism
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlCurrency.checkBoxCurrencyHonorPoints = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlCurrency, 
		headingWidth, 
		left, 
		movingTop, 
		L["Honor Points"]..L[" ("]..L["HP"]..L[")"],
		AJM.SettingsToggleCurrencyHonorPoints
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlCurrency.checkBoxCurrencyArenaPoints = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlCurrency, 
		headingWidth, 
		left, 
		movingTop, 
		L["Arena Points"]..L[" ("]..L["AP"]..L[")"],
		AJM.SettingsToggleCurrencyArenaPoints
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlCurrency.currencyButtonShowList = JambaHelperSettings:CreateButton( 
		AJM.settingsControlCurrency, 
		headingWidth, 
		left, 
		movingTop, 
		L["Show Currency"], 
		AJM.JambaToonRequestCurrency
	)
	movingTop = movingTop - buttonHeight
	AJM.settingsControlCurrency.checkBoxCurrencyOpenStartUpMaster = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlCurrency, 
		headingWidth, 
		left, 
		movingTop, 
		L["Open Currency List On Start Up (Master Only)"],
		AJM.SettingsToggleCurrencyOpenStartUpMaster
	)	
	movingTop = movingTop - checkBoxHeight	
	-- Create appearance & layout.
	JambaHelperSettings:CreateHeading( AJM.settingsControlCurrency, L["Appearance & Layout"], movingTop, true )
	movingTop = movingTop - headingHeight
	AJM.settingsControlCurrency.checkBoxCurrencyLockWindow = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlCurrency, 
		headingWidth, 
		left, 
		movingTop, 
		L["Lock Currency List (enables mouse click-through)"],
		AJM.SettingsToggleCurrencyLockWindow
	)	
	movingTop = movingTop - checkBoxHeight		
	AJM.settingsControlCurrency.currencyScaleSlider = JambaHelperSettings:CreateSlider( 
		AJM.settingsControlCurrency, 
		headingWidth, 
		left, 
		movingTop, 
		L["Scale"]
	)
	AJM.settingsControlCurrency.currencyScaleSlider:SetSliderValues( 0.5, 2, 0.01 )
	AJM.settingsControlCurrency.currencyScaleSlider:SetCallback( "OnValueChanged", AJM.SettingsChangeScale )
	movingTop = movingTop - sliderHeight - verticalSpacing
	AJM.settingsControlCurrency.currencyTransparencySlider = JambaHelperSettings:CreateSlider( 
		AJM.settingsControlCurrency, 
		headingWidth, 
		left, 
		movingTop, 
		L["Transparency"]
	)
	AJM.settingsControlCurrency.currencyTransparencySlider:SetSliderValues( 0, 1, 0.01 )
	AJM.settingsControlCurrency.currencyTransparencySlider:SetCallback( "OnValueChanged", AJM.SettingsChangeTransparency )
	movingTop = movingTop - sliderHeight - verticalSpacing	
	AJM.settingsControlCurrency.currencyMediaBorder = JambaHelperSettings:CreateMediaBorder( 
		AJM.settingsControlCurrency, 
		halfWidthSlider, 
		left, 
		movingTop,
		L["Border Style"]
	)
	AJM.settingsControlCurrency.currencyMediaBorder:SetCallback( "OnValueChanged", AJM.SettingsChangeBorderStyle )
	AJM.settingsControlCurrency.currencyBorderColourPicker = JambaHelperSettings:CreateColourPicker(
		AJM.settingsControlCurrency,
		halfWidthSlider,
		column2left + 15,
		movingTop - 15,
		L["Border Colour"]
	)
	AJM.settingsControlCurrency.currencyBorderColourPicker:SetHasAlpha( true )
	AJM.settingsControlCurrency.currencyBorderColourPicker:SetCallback( "OnValueConfirmed", AJM.SettingsBorderColourPickerChanged )	
	movingTop = movingTop - mediaHeight - verticalSpacing
	AJM.settingsControlCurrency.currencyMediaBackground = JambaHelperSettings:CreateMediaBackground( 
		AJM.settingsControlCurrency, 
		halfWidthSlider, 
		left, 
		movingTop,
		L["Background"]
	)
	AJM.settingsControlCurrency.currencyMediaBackground:SetCallback( "OnValueChanged", AJM.SettingsChangeBackgroundStyle )
	AJM.settingsControlCurrency.currencyBackgroundColourPicker = JambaHelperSettings:CreateColourPicker(
		AJM.settingsControlCurrency,
		halfWidthSlider,
		column2left + 15,
		movingTop - 15,
		L["Background Colour"]
	)
	AJM.settingsControlCurrency.currencyBackgroundColourPicker:SetHasAlpha( true )
	AJM.settingsControlCurrency.currencyBackgroundColourPicker:SetCallback( "OnValueConfirmed", AJM.SettingsBackgroundColourPickerChanged )
	movingTop = movingTop - mediaHeight - verticalSpacing
	AJM.settingsControlCurrency.currencySliderSpaceForName = JambaHelperSettings:CreateSlider( 
		AJM.settingsControlCurrency, 
		headingWidth, 
		left, 
		movingTop, 
		L["Space For Name"]
	)
	AJM.settingsControlCurrency.currencySliderSpaceForName:SetSliderValues( 20, 200, 1 )
	AJM.settingsControlCurrency.currencySliderSpaceForName:SetCallback( "OnValueChanged", AJM.SettingsChangeSliderSpaceForName )
	movingTop = movingTop - sliderHeight - verticalSpacing
	AJM.settingsControlCurrency.currencySliderSpaceForGold = JambaHelperSettings:CreateSlider( 
		AJM.settingsControlCurrency, 
		headingWidth, 
		left, 
		movingTop, 
		L["Space For Gold"]
	)
	AJM.settingsControlCurrency.currencySliderSpaceForGold:SetSliderValues( 20, 200, 1 )
	AJM.settingsControlCurrency.currencySliderSpaceForGold:SetCallback( "OnValueChanged", AJM.SettingsChangeSliderSpaceForGold )
	movingTop = movingTop - sliderHeight - verticalSpacing
	AJM.settingsControlCurrency.currencySliderSpaceForPoints = JambaHelperSettings:CreateSlider( 
		AJM.settingsControlCurrency, 
		headingWidth, 
		left, 
		movingTop, 
		L["Space For Points"]
	)
	AJM.settingsControlCurrency.currencySliderSpaceForPoints:SetSliderValues( 20, 200, 1 )
	AJM.settingsControlCurrency.currencySliderSpaceForPoints:SetCallback( "OnValueChanged", AJM.SettingsChangeSliderSpaceForPoints )
	movingTop = movingTop - sliderHeight - verticalSpacing	
	AJM.settingsControlCurrency.currencySliderSpaceBetweenValues = JambaHelperSettings:CreateSlider( 
		AJM.settingsControlCurrency, 
		headingWidth, 
		left, 
		movingTop, 
		L["Space Between Values"]
	)
	AJM.settingsControlCurrency.currencySliderSpaceBetweenValues:SetSliderValues( 0, 20, 1 )
	AJM.settingsControlCurrency.currencySliderSpaceBetweenValues:SetCallback( "OnValueChanged", AJM.SettingsChangeSliderSpaceBetweenValues )
	movingTop = movingTop - sliderHeight - verticalSpacing	
	return movingTop	
end

local function SettingsCreateWarnings( top )
	-- Get positions.
	local checkBoxHeight = JambaHelperSettings:GetCheckBoxHeight()
	local editBoxHeight = JambaHelperSettings:GetEditBoxHeight()
	local dropdownHeight = JambaHelperSettings:GetDropdownHeight()
	local labelHeight = JambaHelperSettings:GetLabelHeight()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( true )
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local halfWidth = (headingWidth - horizontalSpacing) / 2
	local thirdWidth = (headingWidth - (horizontalSpacing * 2)) / 3
	local column2left = left + halfWidth
	local left2 = left + thirdWidth
	local left3 = left + (thirdWidth * 2)
	local movingTop = top
	JambaHelperSettings:CreateHeading( AJM.settingsControlWarnings, L["Combat"], movingTop, true )
	movingTop = movingTop - headingHeight
	AJM.settingsControlWarnings.checkBoxWarnHitFirstTimeCombat = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlWarnings, 
		headingWidth, 
		left, 
		movingTop, 
		L["Warn If Hit First Time In Combat (Slave)"],
		AJM.SettingsToggleWarnHitFirstTimeCombat
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlWarnings.editBoxHitFirstTimeMessage = JambaHelperSettings:CreateEditBox( AJM.settingsControlWarnings,
		headingWidth,
		left,
		movingTop,
		L["Hit First Time Message"]
	)	
	AJM.settingsControlWarnings.editBoxHitFirstTimeMessage:SetCallback( "OnEnterPressed", AJM.EditBoxChangedHitFirstTimeMessage )
	movingTop = movingTop - editBoxHeight
	AJM.settingsControlWarnings.checkBoxWarnTargetNotMasterEnterCombat = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlWarnings, 
		headingWidth, 
		left, 
		movingTop, 
		L["Warn If Target Not Master On Combat (Slave)"],
		AJM.SettingsToggleWarnTargetNotMasterEnterCombat
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlWarnings.editBoxWarnTargetNotMasterMessage = JambaHelperSettings:CreateEditBox( AJM.settingsControlWarnings,
		headingWidth,
		left,
		movingTop,
		L["Warn Target Not Master Message"]
	)	
	AJM.settingsControlWarnings.editBoxWarnTargetNotMasterMessage:SetCallback( "OnEnterPressed", AJM.EditBoxChangedWarnTargetNotMasterMessage )
	movingTop = movingTop - editBoxHeight	
	AJM.settingsControlWarnings.checkBoxWarnFocusNotMasterEnterCombat = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlWarnings, 
		headingWidth, 
		left, 
		movingTop, 
		L["Warn If Focus Not Master On Combat (Slave)"],
		AJM.SettingsToggleWarnFocusNotMasterEnterCombat
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlWarnings.editBoxWarnFocusNotMasterMessage = JambaHelperSettings:CreateEditBox( AJM.settingsControlWarnings,
		headingWidth,
		left,
		movingTop,
		L["Warn Focus Not Master Message"]
	)	
	AJM.settingsControlWarnings.editBoxWarnFocusNotMasterMessage:SetCallback( "OnEnterPressed", AJM.EditBoxChangedWarnFocusNotMasterMessage )
	movingTop = movingTop - editBoxHeight
	JambaHelperSettings:CreateHeading( AJM.settingsControlWarnings, L["Health / Mana"], movingTop, true )
	movingTop = movingTop - headingHeight	
	AJM.settingsControlWarnings.checkBoxWarnWhenHealthDropsBelowX = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlWarnings, 
		headingWidth, 
		left, 
		movingTop, 
		L["Warn If My Health Drops Below"],
		AJM.SettingsToggleWarnWhenHealthDropsBelowX
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlWarnings.editBoxWarnWhenHealthDropsAmount = JambaHelperSettings:CreateEditBox( AJM.settingsControlWarnings,
		headingWidth,
		left,
		movingTop,
		L["Health Amount - Percentage Allowed Before Warning"]
	)	
	AJM.settingsControlWarnings.editBoxWarnWhenHealthDropsAmount:SetCallback( "OnEnterPressed", AJM.EditBoxChangedWarnWhenHealthDropsAmount )
	movingTop = movingTop - editBoxHeight
	AJM.settingsControlWarnings.editBoxWarnHealthDropsMessage = JambaHelperSettings:CreateEditBox( AJM.settingsControlWarnings,
		headingWidth,
		left,
		movingTop,
		L["Warn Health Drop Message"]
	)	
	AJM.settingsControlWarnings.editBoxWarnHealthDropsMessage:SetCallback( "OnEnterPressed", AJM.EditBoxChangedWarnHealthDropsMessage )
	movingTop = movingTop - editBoxHeight
	AJM.settingsControlWarnings.checkBoxWarnWhenManaDropsBelowX = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlWarnings, 
		headingWidth, 
		left, 
		movingTop, 
		L["Warn If My Mana Drops Below"],
		AJM.SettingsToggleWarnWhenManaDropsBelowX
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlWarnings.editBoxWarnWhenManaDropsAmount = JambaHelperSettings:CreateEditBox( AJM.settingsControlWarnings,
		headingWidth,
		left,
		movingTop,
		L["Mana Amount - Percentage Allowed Before Warning"]
	)	
	AJM.settingsControlWarnings.editBoxWarnWhenManaDropsAmount:SetCallback( "OnEnterPressed", AJM.EditBoxChangedWarnWhenManaDropsAmount )
	movingTop = movingTop - editBoxHeight
	AJM.settingsControlWarnings.editBoxWarnManaDropsMessage = JambaHelperSettings:CreateEditBox( AJM.settingsControlWarnings,
		headingWidth,
		left,
		movingTop,
		L["Warn Mana Drop Message"]
	)	
	AJM.settingsControlWarnings.editBoxWarnManaDropsMessage:SetCallback( "OnEnterPressed", AJM.EditBoxChangedWarnManaDropsMessage )
	movingTop = movingTop - editBoxHeight
	JambaHelperSettings:CreateHeading( AJM.settingsControlWarnings, L["Bag Space"], movingTop, true )
	movingTop = movingTop - headingHeight
    AJM.settingsControlWarnings.checkBoxWarnBagsFull = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlWarnings, 
		headingWidth, 
		left, 
		movingTop, 
		L["Warn If All Regular Bags Are Full"],
		AJM.SettingsToggleWarnBagsFull
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlWarnings.editBoxBagsFullMessage = JambaHelperSettings:CreateEditBox( AJM.settingsControlWarnings,
		headingWidth,
		left,
		movingTop,
		L["Bags Full Message"]
	)	
	AJM.settingsControlWarnings.editBoxBagsFullMessage:SetCallback( "OnEnterPressed", AJM.EditBoxChangedBagsFullMessage )
	movingTop = movingTop - editBoxHeight
	JambaHelperSettings:CreateHeading( AJM.settingsControlWarnings, L["Inactive"], movingTop, true )
	movingTop = movingTop - headingHeight
    AJM.settingsControlWarnings.checkBoxWarnAfk = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlWarnings, 
		headingWidth, 
		left, 
		movingTop, 
		L["Warn If Toon Goes Inactive (PVP)"],
		AJM.SettingsToggleWarnAfk
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlWarnings.editBoxAfkMessage = JambaHelperSettings:CreateEditBox( AJM.settingsControlWarnings,
		headingWidth,
		left,
		movingTop,
		L["Inactive Message"]
	)	
	AJM.settingsControlWarnings.editBoxAfkMessage:SetCallback( "OnEnterPressed", AJM.EditBoxChangedAfkMessage )
	movingTop = movingTop - editBoxHeight
	AJM.settingsControlWarnings.dropdownWarningArea = JambaHelperSettings:CreateDropdown( 
		AJM.settingsControlWarnings, 
		headingWidth, 
		left, 
		movingTop, 
		L["Send Warning Area"] 
	)
	AJM.settingsControlWarnings.dropdownWarningArea:SetList( JambaApi.MessageAreaList() )
	AJM.settingsControlWarnings.dropdownWarningArea:SetCallback( "OnValueChanged", AJM.SettingsSetWarningArea )
	movingTop = movingTop - dropdownHeight - verticalSpacing		
	return movingTop	
end

local function SettingsCreate()
	AJM.settingsControlWarnings = {}
	AJM.settingsControlRequests = {}
	AJM.settingsControlMerchant = {}
    AJM.settingsControlCurrency = {}
	JambaHelperSettings:CreateSettings( 
		AJM.settingsControlWarnings, 
		AJM.moduleDisplayName, 
		AJM.parentDisplayNameToon, 
		AJM.SettingsPushSettingsClick 
	)
	JambaHelperSettings:CreateSettings( 
		AJM.settingsControlRequests, 
		L["Toon"]..L[": "]..L["Requests"], 
		AJM.parentDisplayNameToon, 
		AJM.SettingsPushSettingsClick 
	)
	JambaHelperSettings:CreateSettings( 
		AJM.settingsControlMerchant, 
		L["Toon"]..L[": "]..L["Merchant"], 
		AJM.parentDisplayNameMerchant, 
		AJM.SettingsPushSettingsClick 
	)
	JambaHelperSettings:CreateSettings( 
		AJM.settingsControlCurrency, 
		L["Toon"]..L[": "]..L["Currency"], 
		AJM.parentDisplayNameCurrency, 
		AJM.SettingsPushSettingsClick 
	)	
	local bottomOfWarnings = SettingsCreateWarnings( JambaHelperSettings:TopOfSettings() )
	AJM.settingsControlWarnings.widgetSettings.content:SetHeight( -bottomOfWarnings )
	local bottomOfRequests = SettingsCreateRequests( JambaHelperSettings:TopOfSettings() )
	AJM.settingsControlRequests.widgetSettings.content:SetHeight( -bottomOfRequests )
	local bottomOfMerchant = SettingsCreateMerchant( JambaHelperSettings:TopOfSettings() )
	AJM.settingsControlMerchant.widgetSettings.content:SetHeight( -bottomOfMerchant )
	local bottomOfCurrency = SettingsCreateCurrency( JambaHelperSettings:TopOfSettings() )
	AJM.settingsControlCurrency.widgetSettings.content:SetHeight( -bottomOfCurrency )	
	-- Help
	local helpTable = {}
	JambaHelperSettings:CreateHelp( AJM.settingsControlWarnings, helpTable, AJM:GetConfiguration() )		
end

-------------------------------------------------------------------------------------------------------------
-- Settings Populate.
-------------------------------------------------------------------------------------------------------------

function AJM:BeforeJambaProfileChanged()	
end

function AJM:OnJambaProfileChanged()	
	AJM:SettingsRefresh()
end

function AJM:SettingsRefresh()
	AJM.settingsControlWarnings.checkBoxWarnHitFirstTimeCombat:SetValue( AJM.db.warnHitFirstTimeCombat )
	AJM.settingsControlWarnings.editBoxHitFirstTimeMessage:SetText( AJM.db.hitFirstTimeMessage )
	AJM.settingsControlWarnings.checkBoxWarnTargetNotMasterEnterCombat:SetValue( AJM.db.warnTargetNotMasterEnterCombat )
	AJM.settingsControlWarnings.editBoxWarnTargetNotMasterMessage:SetText( AJM.db.warnTargetNotMasterMessage )
	AJM.settingsControlWarnings.checkBoxWarnFocusNotMasterEnterCombat:SetValue( AJM.db.warnFocusNotMasterEnterCombat )
	AJM.settingsControlWarnings.editBoxWarnFocusNotMasterMessage:SetText( AJM.db.warnFocusNotMasterMessage )
	AJM.settingsControlWarnings.checkBoxWarnWhenHealthDropsBelowX:SetValue( AJM.db.warnWhenHealthDropsBelowX )
	AJM.settingsControlWarnings.editBoxWarnWhenHealthDropsAmount:SetText( AJM.db.warnWhenHealthDropsAmount )
	AJM.settingsControlWarnings.editBoxWarnHealthDropsMessage:SetText( AJM.db.warnHealthDropsMessage )
	AJM.settingsControlWarnings.checkBoxWarnWhenManaDropsBelowX:SetValue( AJM.db.warnWhenManaDropsBelowX )
	AJM.settingsControlWarnings.editBoxWarnWhenManaDropsAmount:SetText( AJM.db.warnWhenManaDropsAmount )
	AJM.settingsControlWarnings.editBoxWarnManaDropsMessage:SetText( AJM.db.warnManaDropsMessage )
	AJM.settingsControlWarnings.checkBoxWarnBagsFull:SetValue( AJM.db.warnBagsFull )
	AJM.settingsControlWarnings.editBoxBagsFullMessage:SetText( AJM.db.bagsFullMessage )
	AJM.settingsControlWarnings.checkBoxWarnAfk:SetValue( AJM.db.warnAfk )
	AJM.settingsControlWarnings.editBoxAfkMessage:SetText( AJM.db.afkMessage )
	AJM.settingsControlWarnings.dropdownWarningArea:SetValue( AJM.db.warningArea )
	AJM.settingsControlRequests.checkBoxAutoAcceptResurrectRequest:SetValue( AJM.db.autoAcceptResurrectRequest )
	AJM.settingsControlRequests.checkBoxAutoDenyDuels:SetValue( AJM.db.autoDenyDuels )
	AJM.settingsControlRequests.checkBoxAutoDenyGuildInvites:SetValue( AJM.db.autoDenyGuildInvites )
	AJM.settingsControlRequests.dropdownRequestArea:SetValue( AJM.db.requestArea )
	AJM.settingsControlMerchant.checkBoxAutoRepair:SetValue( AJM.db.autoRepair )
	AJM.settingsControlMerchant.checkBoxAutoRepairUseGuildFunds:SetValue( AJM.db.autoRepairUseGuildFunds )
	AJM.settingsControlMerchant.dropdownMerchantArea:SetValue( AJM.db.merchantArea )
	AJM.settingsControlWarnings.editBoxHitFirstTimeMessage:SetDisabled( not AJM.db.warnHitFirstTimeCombat )
	AJM.settingsControlWarnings.editBoxWarnTargetNotMasterMessage:SetDisabled( not AJM.db.warnTargetNotMasterEnterCombat )
	AJM.settingsControlWarnings.editBoxWarnFocusNotMasterMessage:SetDisabled( not AJM.db.warnFocusNotMasterEnterCombat )
	AJM.settingsControlWarnings.editBoxWarnWhenHealthDropsAmount:SetDisabled( not AJM.db.warnWhenHealthDropsBelowX )
	AJM.settingsControlWarnings.editBoxWarnHealthDropsMessage:SetDisabled( not AJM.db.warnWhenHealthDropsBelowX )
	AJM.settingsControlWarnings.editBoxWarnWhenManaDropsAmount:SetDisabled( not AJM.db.warnWhenManaDropsBelowX )
	AJM.settingsControlWarnings.editBoxWarnManaDropsMessage:SetDisabled( not AJM.db.warnWhenManaDropsBelowX )
	AJM.settingsControlMerchant.checkBoxAutoRepairUseGuildFunds:SetDisabled( not AJM.db.autoRepair )
	AJM.settingsControlWarnings.editBoxBagsFullMessage:SetDisabled( not AJM.db.warnBagsFull )
	AJM.settingsControlWarnings.editBoxAfkMessage:SetDisabled( not AJM.db.warnAfk )
	AJM.settingsControlCurrency.checkBoxCurrencyGold:SetValue( AJM.db.currGold )
	AJM.settingsControlCurrency.checkBoxCurrencyGoldInGuildBank:SetValue( AJM.db.currGoldInGuildBank )
	AJM.settingsControlCurrency.checkBoxCurrencyGoldInGuildBank:SetDisabled( not AJM.db.currGold )
    AJM.settingsControlCurrency.checkBoxCurrencyEmblemOfFrost:SetValue( AJM.db.currEmblemOfFrost )
    AJM.settingsControlCurrency.checkBoxCurrencyEmblemOfTriumph:SetValue( AJM.db.currEmblemOfTriumph )
    AJM.settingsControlCurrency.checkBoxCurrencyEmblemOfConquest:SetValue( AJM.db.currEmblemOfConquest )
    AJM.settingsControlCurrency.checkBoxCurrencyEmblemOfValor:SetValue( AJM.db.currEmblemOfValor )
    AJM.settingsControlCurrency.checkBoxCurrencyEmblemOfHeroism:SetValue( AJM.db.currEmblemOfHeroism )
    AJM.settingsControlCurrency.checkBoxCurrencyHonorPoints:SetValue( AJM.db.currHonorPoints )
    AJM.settingsControlCurrency.checkBoxCurrencyArenaPoints:SetValue( AJM.db.currArenaPoints )
	AJM.settingsControlCurrency.checkBoxCurrencyOpenStartUpMaster:SetValue( AJM.db.currOpenStartUpMaster )
	AJM.settingsControlCurrency.currencyTransparencySlider:SetValue( AJM.db.currencyFrameAlpha )
	AJM.settingsControlCurrency.currencyScaleSlider:SetValue( AJM.db.currencyScale )
	AJM.settingsControlCurrency.currencyMediaBorder:SetValue( AJM.db.currencyBorderStyle )
	AJM.settingsControlCurrency.currencyMediaBackground:SetValue( AJM.db.currencyBackgroundStyle )
	AJM.settingsControlCurrency.currencyBackgroundColourPicker:SetColor( AJM.db.currencyFrameBackgroundColourR, AJM.db.currencyFrameBackgroundColourG, AJM.db.currencyFrameBackgroundColourB, AJM.db.currencyFrameBackgroundColourA )
	AJM.settingsControlCurrency.currencyBorderColourPicker:SetColor( AJM.db.currencyFrameBorderColourR, AJM.db.currencyFrameBorderColourG, AJM.db.currencyFrameBorderColourB, AJM.db.currencyFrameBorderColourA )
	AJM.settingsControlCurrency.currencySliderSpaceForName:SetValue( AJM.db.currencyNameWidth )
	AJM.settingsControlCurrency.currencySliderSpaceForGold:SetValue( AJM.db.currencyGoldWidth )
	AJM.settingsControlCurrency.currencySliderSpaceForPoints:SetValue( AJM.db.currencyPointsWidth )
	AJM.settingsControlCurrency.currencySliderSpaceBetweenValues:SetValue( AJM.db.currencySpacingWidth )
	AJM.settingsControlCurrency.checkBoxCurrencyLockWindow:SetValue( AJM.db.currencyLockWindow )
	if AJM.currencyListFrameCreated == true then
		AJM:CurrencyListSetColumnWidth()
		AJM:CurrencyListSetHeight()
		AJM:SettingsUpdateBorderStyle()
		AJM:CurrencyUpdateWindowLock()
		JambaToonCurrencyListFrame:SetScale( AJM.db.currencyScale )
	end
end

function AJM:SettingsPushSettingsClick( event )
	AJM:JambaSendSettings()
end

function AJM:SettingsToggleAutoRepair( event, checked )
	AJM.db.autoRepair = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAutoRepairUseGuildFunds( event, checked )
	AJM.db.autoRepairUseGuildFunds = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAutoDenyDuels( event, checked )
	AJM.db.autoDenyDuels = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAutoDenyGuildInvites( event, checked )
	AJM.db.autoDenyGuildInvites = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAutoAcceptResurrectRequests( event, checked )
	AJM.db.autoAcceptResurrectRequest = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleWarnHitFirstTimeCombat( event, checked )
	AJM.db.warnHitFirstTimeCombat = checked
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedHitFirstTimeMessage( event, text )
	AJM.db.hitFirstTimeMessage = text
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleWarnBagsFull( event, checked )
	AJM.db.warnBagsFull = checked
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedBagsFullMessage( event, text )
	AJM.db.bagsFullMessage = text
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleWarnAfk( event, checked )
	AJM.db.warnAfk = checked
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedAfkMessage( event, text )
	AJM.db.afkMessage = text
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleWarnTargetNotMasterEnterCombat( event, checked )
	AJM.db.warnTargetNotMasterEnterCombat = checked
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedWarnTargetNotMasterMessage( event, text )
	AJM.db.warnTargetNotMasterMessage = text
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleWarnFocusNotMasterEnterCombat( event, checked )
	AJM.db.warnFocusNotMasterEnterCombat = checked
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedWarnFocusNotMasterMessage( event, text )
	AJM.db.warnFocusNotMasterMessage = text
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleWarnWhenHealthDropsBelowX( event, checked )
	AJM.db.warnWhenHealthDropsBelowX = checked
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedWarnWhenHealthDropsAmount( event, text )
	local amount = tonumber( text )
	amount = JambaUtilities:FixValueToRange( amount, 0, 100 )
	AJM.db.warnWhenHealthDropsAmount = tostring( amount )
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedWarnHealthDropsMessage( event, text )
	AJM.db.warnHealthDropsMessage = text
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleWarnWhenManaDropsBelowX( event, checked )
	AJM.db.warnWhenManaDropsBelowX = checked
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedWarnWhenManaDropsAmount( event, text )
	local amount = tonumber( text )
	amount = JambaUtilities:FixValueToRange( amount, 0, 100 )
	AJM.db.warnWhenManaDropsAmount = tostring( amount )
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedWarnManaDropsMessage( event, text )
	AJM.db.warnManaDropsMessage = text
	AJM:SettingsRefresh()
end

function AJM:SettingsSetWarningArea( event, value )
	AJM.db.warningArea = value
	AJM:SettingsRefresh()
end

function AJM:SettingsSetRequestArea( event, value )
	AJM.db.requestArea = value
	AJM:SettingsRefresh()
end

function AJM:SettingsSetMerchantArea( event, value )
	AJM.db.merchantArea = value
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleCurrencyGold( event, checked )
	AJM.db.currGold = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleCurrencyGoldInGuildBank( event, checked )
	AJM.db.currGoldInGuildBank = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleCurrencyEmblemOfFrost( event, checked )
	AJM.db.currEmblemOfFrost = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleCurrencyEmblemOfTriumph( event, checked )
	AJM.db.currEmblemOfTriumph = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleCurrencyEmblemOfConquest( event, checked )
	AJM.db.currEmblemOfConquest = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleCurrencyEmblemOfValor( event, checked )
	AJM.db.currEmblemOfValor = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleCurrencyEmblemOfHeroism( event, checked )
	AJM.db.currEmblemOfHeroism = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleCurrencyHonorPoints( event, checked )
	AJM.db.currHonorPoints = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleCurrencyArenaPoints( event, checked )
	AJM.db.currArenaPoints = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleCurrencyOpenStartUpMaster( event, checked )
	AJM.db.currOpenStartUpMaster = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeScale( event, value )
	AJM.db.currencyScale = tonumber( value )
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeTransparency( event, value )
	AJM.db.currencyFrameAlpha = tonumber( value )
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeBorderStyle( event, value )
	AJM.db.currencyBorderStyle = value
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeBackgroundStyle( event, value )
	AJM.db.currencyBackgroundStyle = value
	AJM:SettingsRefresh()
end

function AJM:SettingsBackgroundColourPickerChanged( event, r, g, b, a )
	AJM.db.currencyFrameBackgroundColourR = r
	AJM.db.currencyFrameBackgroundColourG = g
	AJM.db.currencyFrameBackgroundColourB = b
	AJM.db.currencyFrameBackgroundColourA = a
	AJM:SettingsRefresh()
end

function AJM:SettingsBorderColourPickerChanged( event, r, g, b, a )
	AJM.db.currencyFrameBorderColourR = r
	AJM.db.currencyFrameBorderColourG = g
	AJM.db.currencyFrameBorderColourB = b
	AJM.db.currencyFrameBorderColourA = a
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeSliderSpaceForName( event, value )
	AJM.db.currencyNameWidth = tonumber( value )
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeSliderSpaceForGold( event, value )
	AJM.db.currencyGoldWidth = tonumber( value )
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeSliderSpaceForPoints( event, value )
	AJM.db.currencyPointsWidth = tonumber( value )
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeSliderSpaceBetweenValues( event, value )
	AJM.db.currencySpacingWidth = tonumber( value )
	AJM:SettingsRefresh()
end
		
function AJM:SettingsToggleCurrencyLockWindow( event, checked )
	AJM.db.currencyLockWindow = checked
	AJM:CurrencyUpdateWindowLock()
	AJM:SettingsRefresh()
end

-------------------------------------------------------------------------------------------------------------
-- Addon initialization, enabling and disabling.
-------------------------------------------------------------------------------------------------------------

-- Initialise the module.
function AJM:OnInitialize()
	--AJM.currencyTotalGold = 0
	AJM.currencyListFrameCreated = false
	AJM.currencyFrameCharacterInfo = {}
	AJM.currentCurrencyValues = {}
	-- Create the settings control.
	SettingsCreate()
	-- Initialise the JambaModule part of this module.
	AJM:JambaModuleInitialize( AJM.settingsControlWarnings.widgetSettings.frame )
	-- Populate the settings.
	AJM:SettingsRefresh()
	-- Create the currency list frame.
	AJM:CreateJambaToonCurrencyListFrame()
	-- Flag set when told the master about health falling below a certain percentage.
	AJM.toldMasterAboutHealth = false
	-- Flag set when told the master about mana falling below a certain percentage.
	AJM.toldMasterAboutMana = false
	-- Have been hit flag.
	AJM.haveBeenHit = false
	-- Bags full changed count.
	AJM.previousFreeBagSlotsCount = -1
end

-- Called when the addon is enabled.
function AJM:OnEnable()
	-- WoW events.
	AJM:RegisterEvent( "UNIT_COMBAT" )
	AJM:RegisterEvent( "PLAYER_REGEN_DISABLED" )
	AJM:RegisterEvent( "PLAYER_REGEN_ENABLED" )
	AJM:RegisterEvent( "UNIT_HEALTH" )
	AJM:RegisterEvent( "MERCHANT_SHOW" )
	AJM:RegisterEvent( "UNIT_MANA" )
	AJM:RegisterEvent( "RESURRECT_REQUEST" )
	AJM:RegisterEvent( "DUEL_REQUESTED" )
	AJM:RegisterEvent( "GUILD_INVITE_REQUEST" )
	AJM:RegisterEvent( "ITEM_PUSH" )
	AJM:RegisterEvent( "UI_ERROR_MESSAGE", "ITEM_PUSH" )
	AJM:RegisterEvent( "UNIT_AURA" )
	if AJM.db.currOpenStartUpMaster == true then
		if JambaApi.IsCharacterTheMaster( self.characterName ) == true then
			AJM:ScheduleTimer( "JambaToonRequestCurrency", 2 )
		end
	end
end

-- Called when the addon is disabled.
function AJM:OnDisable()
end

-- Settings received.
function AJM:JambaOnSettingsReceived( characterName, settings )	
	if characterName ~= AJM.characterName then
		-- Update the settings.
		AJM.db.warnHitFirstTimeCombat = settings.warnHitFirstTimeCombat
		AJM.db.hitFirstTimeMessage = settings.hitFirstTimeMessage
		AJM.db.warnTargetNotMasterEnterCombat = settings.warnTargetNotMasterEnterCombat
		AJM.db.warnTargetNotMasterMessage = settings.warnTargetNotMasterMessage
		AJM.db.warnFocusNotMasterEnterCombat = settings.warnFocusNotMasterEnterCombat
		AJM.db.warnFocusNotMasterMessage = settings.warnFocusNotMasterMessage
		AJM.db.warnWhenHealthDropsBelowX = settings.warnWhenHealthDropsBelowX
		AJM.db.warnWhenHealthDropsAmount = settings.warnWhenHealthDropsAmount
		AJM.db.warnHealthDropsMessage = settings.warnHealthDropsMessage
		AJM.db.warnWhenManaDropsBelowX = settings.warnWhenManaDropsBelowX
		AJM.db.warnWhenManaDropsAmount = settings.warnWhenManaDropsAmount
		AJM.db.warnManaDropsMessage = settings.warnManaDropsMessage
		AJM.db.warnBagsFull = settings.warnBagsFull
		AJM.db.bagsFullMessage = settings.bagsFullMessage
		AJM.db.warnAfk = settings.warnAfk
		AJM.db.afkMessage = settings.afkMessage		
		AJM.db.autoAcceptResurrectRequest = settings.autoAcceptResurrectRequest
		AJM.db.autoDenyDuels = settings.autoDenyDuels
		AJM.db.autoDenyGuildInvites = settings.autoDenyGuildInvites
		AJM.db.autoRepair = settings.autoRepair
		AJM.db.autoRepairUseGuildFunds = settings.autoRepairUseGuildFunds
		AJM.db.warningArea = settings.warningArea
		AJM.db.requestArea = settings.requestArea
		AJM.db.merchantArea = settings.merchantArea
		AJM.db.currGold = settings.currGold
		AJM.db.currGoldInGuildBank = settings.currGoldInGuildBank
        AJM.db.currEmblemOfFrost = settings.currEmblemOfFrost
        AJM.db.currEmblemOfTriumph = settings.currEmblemOfTriumph
        AJM.db.currEmblemOfConquest = settings.currEmblemOfConquest
        AJM.db.currEmblemOfValor = settings.currEmblemOfValor
        AJM.db.currEmblemOfHeroism = settings.currEmblemOfHeroism
        AJM.db.currHonorPoints = settings.currHonorPoints
        AJM.db.currArenaPoints = settings.currArenaPoints
		AJM.db.currOpenStartUpMaster = settings.currOpenStartUpMaster
		AJM.db.currencyScale = settings.currencyScale
		AJM.db.currencyFrameAlpha = settings.currencyFrameAlpha
		AJM.db.currencyFramePoint = settings.currencyFramePoint
		AJM.db.currencyFrameRelativePoint = settings.currencyFrameRelativePoint
		AJM.db.currencyFrameXOffset = settings.currencyFrameXOffset
		AJM.db.currencyFrameYOffset = settings.currencyFrameYOffset
		AJM.db.currencyFrameBackgroundColourR = settings.currencyFrameBackgroundColourR
		AJM.db.currencyFrameBackgroundColourG = settings.currencyFrameBackgroundColourG
		AJM.db.currencyFrameBackgroundColourB = settings.currencyFrameBackgroundColourB
		AJM.db.currencyFrameBackgroundColourA = settings.currencyFrameBackgroundColourA
		AJM.db.currencyFrameBorderColourR = settings.currencyFrameBorderColourR
		AJM.db.currencyFrameBorderColourG = settings.currencyFrameBorderColourG
		AJM.db.currencyFrameBorderColourB = settings.currencyFrameBorderColourB
		AJM.db.currencyFrameBorderColourA = settings.currencyFrameBorderColourA	
		AJM.db.currencyNameWidth = settings.currencyNameWidth
		AJM.db.currencyPointsWidth = settings.currencyPointsWidth
		AJM.db.currencyGoldWidth = settings.currencyGoldWidth
		AJM.db.currencySpacingWidth = settings.currencySpacingWidth
		AJM.db.currencyLockWindow = settings.currencyLockWindow
		-- Refresh the settings.
		AJM:SettingsRefresh()
		-- Tell the player.
		AJM:Print( L["Settings received from A."]( characterName ) )
	end
end

function AJM:UNIT_COMBAT( event, unitAffected, action )
	if AJM.db.warnHitFirstTimeCombat == false then
		return
	end
	if JambaApi.IsCharacterTheMaster( self.characterName ) == true then
		return
	end
	if InCombatLockdown() then
		if unitAffected == "player" and action ~= "HEAL" and not AJM.haveBeenHit then
			AJM.haveBeenHit = true
			AJM:JambaSendMessageToTeam( AJM.db.warningArea, AJM.db.hitFirstTimeMessage )
		end
	end
end

function AJM:GUILD_INVITE_REQUEST( event, inviter, guild, ... )
	if AJM.db.autoDenyGuildInvites == true then
		DeclineGuild()
		StaticPopup_Hide( "GUILD_INVITE" )
		AJM:JambaSendMessageToTeam( AJM.db.requestArea, L["I refused a guild invite to: X from: Y"]( guild, inviter ) )
	end
end

function AJM:DUEL_REQUESTED( event, challenger, ... )
	if AJM.db.autoDenyDuels == true then
		CancelDuel()
		StaticPopup_Hide( "DUEL_REQUESTED" )
		AJM:JambaSendMessageToTeam( AJM.db.requestArea, L["I refused a duel from: X"]( challenger ) )
	end
end

function AJM:RESURRECT_REQUEST( event, ... )
	if AJM.db.autoAcceptResurrectRequest == true then
		AcceptResurrect()
		StaticPopup_Hide( "RESURRECT")
		StaticPopup_Hide( "RESURRECT_NO_SICKNESS" )
		StaticPopup_Hide( "RESURRECT_NO_TIMER" )
		StaticPopup_Hide( "SKINNED" )
		StaticPopup_Hide( "SKINNED_REPOP" )
		StaticPopup_Hide( "DEATH" )
	end
end

function AJM:MERCHANT_SHOW( event, ... )	
	-- Does the user want to auto repair?
	if AJM.db.autoRepair == false then
		return
	end	
	-- Can this merchant repair?
	if CanMerchantRepair() == nil then 
		return
	end		
	-- How much to repair?
	local totalAmountSpentOnRepair = 0
	local repairCost = GetRepairAllCost()
	-- At least some cost...
	if repairCost > 0 then
		-- If allowed to use guild funds, then attempt to repair using guild funds.
		if AJM.db.autoRepairUseGuildFunds == true then
			if IsInGuild() and CanWithdrawGuildBankMoney() then
				RepairAllItems( 1 )
				totalAmountSpentOnRepair = totalAmountSpentOnRepair + repairCost
			end
		end
		-- After guild funds used, still need to repair?
		repairCost = GetRepairAllCost()
		-- At least some cost...
		if repairCost > 0 then
			-- How much money available?
			local moneyAvailable = GetMoney()
			-- More or equal money than cost?
			if moneyAvailable >= repairCost then
				-- Yes, repair.
				RepairAllItems()
				totalAmountSpentOnRepair = totalAmountSpentOnRepair + repairCost
			else
				-- Nope, tell the boss.
				 AJM:JambaSendMessageToTeam( AJM.db.merchantArea, L["I do not have enough money to repair all my items."] )
			end
		end
	end
	if totalAmountSpentOnRepair > 0 then
		-- Tell the boss how much that cost.
		local costString = JambaUtilities:FormatMoneyString( totalAmountSpentOnRepair )
		AJM:JambaSendMessageToTeam( AJM.db.merchantArea, L["Repairing cost me: X"]( costString ) )
	end
end

function AJM:UNIT_MANA( event, unitAffected, ... )
	if AJM.db.warnWhenManaDropsBelowX == false then
		return
	end
	if unitAffected ~= "player" then
		return
	end
	local powerType, powerTypeString = UnitPowerType( "player" )
	if powerTypeString ~= "MANA" then
		return
	end		
	local currentMana = (UnitMana( "player" ) / UnitManaMax( "player" ) * 100)
	if AJM.toldMasterAboutMana == true then
		if currentMana >= tonumber( AJM.db.warnWhenManaDropsAmount ) then
			AJM.toldMasterAboutMana = false
		end
	else
		if currentMana < tonumber( AJM.db.warnWhenManaDropsAmount ) then
			AJM.toldMasterAboutMana = true
			AJM:JambaSendMessageToTeam( AJM.db.warningArea, AJM.db.warnManaDropsMessage )
		end
	end
end

function AJM:UNIT_HEALTH( event, unitAffected, ... )
	if AJM.db.warnWhenHealthDropsBelowX == false then
		return
	end	
	if unitAffected ~= "player" then
		return
	end
	local currentHealth = (UnitHealth( "player" ) / UnitHealthMax( "player" ) * 100)
	if AJM.toldMasterAboutHealth == true then
		if currentHealth >= tonumber( AJM.db.warnWhenHealthDropsAmount ) then
			AJM.toldMasterAboutHealth = false
		end
	else
		if currentHealth < tonumber( AJM.db.warnWhenHealthDropsAmount ) then
			AJM.toldMasterAboutHealth = true
			AJM:JambaSendMessageToTeam( AJM.db.warningArea, AJM.db.warnHealthDropsMessage )
		end
	end
end

function AJM:PLAYER_REGEN_ENABLED( event, ... )
	AJM.haveBeenHit = false
end

function AJM:PLAYER_REGEN_DISABLED( event, ... )
	AJM.haveBeenHit = false
	if AJM.db.warnTargetNotMasterEnterCombat == true then
		if JambaApi.IsCharacterTheMaster( AJM.characterName ) == false then
			if UnitName( "target" ) ~= JambaApi.GetMasterName() then
				AJM:JambaSendMessageToTeam( AJM.db.warningArea, AJM.db.warnTargetNotMasterMessage )
			end
		end
	end
	if AJM.db.warnFocusNotMasterEnterCombat == true then
		if JambaApi.IsCharacterTheMaster( AJM.characterName ) == false then
			if UnitName( "focus" ) ~= JambaApi.GetMasterName() then
				AJM:JambaSendMessageToTeam( AJM.db.warningArea, AJM.db.warnFocusNotMasterMessage )
			end
		end
	end
end

function AJM:ITEM_PUSH( event, ... )
    if AJM.db.warnBagsFull == true then
		if UnitIsGhost( "player" ) == 1 then
			return
		end
		if UnitIsDead( "player" ) == 1 then
			return
		end
		local numberFreeSlots, numberTotalSlots = LibBagUtils:CountSlots( "BAGS", 0 )
		if numberFreeSlots == 0 then
			if AJM.previousFreeBagSlotsCount ~= numberFreeSlots then
				AJM:JambaSendMessageToTeam( AJM.db.warningArea, AJM.db.bagsFullMessage )
			end
		end
		AJM.previousFreeBagSlotsCount = numberFreeSlots
	end
end

function AJM:UNIT_AURA( event, ... )
	if AJM.db.warnAfk == true then
		if JambaUtilities:DoesThisCharacterHaveBuff( L["Inactive"] ) == true then
			AJM:JambaSendMessageToTeam( AJM.db.warningArea, AJM.db.afkMessage )
		end
	end
end

function AJM:CreateJambaToonCurrencyListFrame()
	-- The frame.
	local frame = CreateFrame( "Frame", "JambaToonCurrencyListWindowFrame", UIParent )
	frame.obj = AJM
	frame:SetFrameStrata( "BACKGROUND" )
	frame:SetToplevel( false )
	frame:SetClampedToScreen( true )
	frame:EnableMouse( true )
	frame:SetMovable( true )	
	frame:RegisterForDrag( "LeftButton" )
	frame:SetScript( "OnDragStart", 
		function( this ) 
			if IsAltKeyDown() == 1 then
				this:StartMoving() 
			end
		end )
	frame:SetScript( "OnDragStop", 
		function( this ) 
			this:StopMovingOrSizing() 
			point, relativeTo, relativePoint, xOffset, yOffset = this:GetPoint()
			AJM.db.currencyFramePoint = point
			AJM.db.currencyFrameRelativePoint = relativePoint
			AJM.db.currencyFrameXOffset = xOffset
			AJM.db.currencyFrameYOffset = yOffset
		end	)
	frame:SetWidth( 500 )
	frame:SetHeight( 200 )
	frame:ClearAllPoints()
	frame:SetPoint( AJM.db.currencyFramePoint, UIParent, AJM.db.currencyFrameRelativePoint, AJM.db.currencyFrameXOffset, AJM.db.currencyFrameYOffset )
	frame:SetBackdrop( {
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", 
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", 
		tile = true, tileSize = 10, edgeSize = 10, 
		insets = { left = 3, right = 3, top = 3, bottom = 3 }
	} )

	-- Create the title for the team list frame.
	local titleName = frame:CreateFontString( "JambaToonCurrencyListWindowFrameTitleText", "OVERLAY", "GameFontNormal" )
	titleName:SetPoint( "TOPLEFT", frame, "TOPLEFT", 3, -8 )
	titleName:SetTextColor( NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1.0 )
	titleName:SetText( L["Currency"] )
	titleName:SetWidth( 200 )
	titleName:SetJustifyH( "LEFT" )
	titleName:SetWordWrap( false )
	frame.titleName = titleName
	
	-- Create the headings.
	local left = 10
	local spacing = 50
	local width = 50
	local top = -30
	local parentFrame = frame
	local r = 1.0
	local g = 0.96
	local b = 0.41
	local a = 1.0
	-- Set the characters name font string.
	local frameCharacterName = AJM.globalCurrencyFramePrefix.."TitleCharacterName"
	local frameCharacterNameText = parentFrame:CreateFontString( frameCharacterName.."Text", "OVERLAY", "GameFontNormal" )
	frameCharacterNameText:SetText( L["Toon"] )
	frameCharacterNameText:SetTextColor( r, g, b, a )
	frameCharacterNameText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, top )
	frameCharacterNameText:SetWidth( width * 2.5 )
	frameCharacterNameText:SetJustifyH( "LEFT" )
	frame.characterNameText = frameCharacterNameText
	left = left + (spacing * 2)
	-- Set the Gold font string.
	local frameGold = AJM.globalCurrencyFramePrefix.."TitleGold"
	local frameGoldText = parentFrame:CreateFontString( frameGold.."Text", "OVERLAY", "GameFontNormal" )
	frameGoldText:SetText( L["Gold"] )
	frameGoldText:SetTextColor( r, g, b, a )
	frameGoldText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, top )
	frameGoldText:SetWidth( width )
	frameGoldText:SetJustifyH( "CENTER" )
	frame.GoldText = frameGoldText
	left = left + spacing	
	-- Set the EmblemOfFrost font string.
	local frameEmblemOfFrost = AJM.globalCurrencyFramePrefix.."TitleEmblemOfFrost"
	local frameEmblemOfFrostText = parentFrame:CreateFontString( frameEmblemOfFrost.."Text", "OVERLAY", "GameFontNormal" )
	frameEmblemOfFrostText:SetText( L["EoF"] )
	frameEmblemOfFrostText:SetTextColor( r, g, b, a )
	frameEmblemOfFrostText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, top )
	frameEmblemOfFrostText:SetWidth( width )
	frameEmblemOfFrostText:SetJustifyH( "CENTER" )
	frame.EmblemOfFrostText = frameEmblemOfFrostText
	left = left + spacing
	-- Set the EmblemOfTriumph font string.
	local frameEmblemOfTriumph = AJM.globalCurrencyFramePrefix.."TitleEmblemOfTriumph"
	local frameEmblemOfTriumphText = parentFrame:CreateFontString( frameEmblemOfTriumph.."Text", "OVERLAY", "GameFontNormal" )
	frameEmblemOfTriumphText:SetText( L["EoT"] )
	frameEmblemOfTriumphText:SetTextColor( r, g, b, a )
	frameEmblemOfTriumphText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, top )
	frameEmblemOfTriumphText:SetWidth( width )
	frameEmblemOfTriumphText:SetJustifyH( "CENTER" )
	frame.EmblemOfTriumphText = frameEmblemOfTriumphText
	left = left + spacing
	-- Set the EmblemOfConquest font string.
	local frameEmblemOfConquest = AJM.globalCurrencyFramePrefix.."TitleEmblemOfConquest"
	local frameEmblemOfConquestText = parentFrame:CreateFontString( frameEmblemOfConquest.."Text", "OVERLAY", "GameFontNormal" )
	frameEmblemOfConquestText:SetText( L["EoC"] )
	frameEmblemOfConquestText:SetTextColor( r, g, b, a )
	frameEmblemOfConquestText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, top )
	frameEmblemOfConquestText:SetWidth( width )
	frameEmblemOfConquestText:SetJustifyH( "CENTER" )
	frame.EmblemOfConquestText = frameEmblemOfConquestText
	left = left + spacing
	-- Set the EmblemOfValor font string.
	local frameEmblemOfValor = AJM.globalCurrencyFramePrefix.."TitleEmblemOfValor"
	local frameEmblemOfValorText = parentFrame:CreateFontString( frameEmblemOfValor.."Text", "OVERLAY", "GameFontNormal" )
	frameEmblemOfValorText:SetText( L["EoV"] )
	frameEmblemOfValorText:SetTextColor( r, g, b, a )
	frameEmblemOfValorText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, top )
	frameEmblemOfValorText:SetWidth( width )
	frameEmblemOfValorText:SetJustifyH( "CENTER" )
	frame.EmblemOfValorText = frameEmblemOfValorText
	left = left + spacing
	-- Set the EmblemOfHeroism font string.
	local frameEmblemOfHeroism = AJM.globalCurrencyFramePrefix.."TitleEmblemOfHeroism"
	local frameEmblemOfHeroismText = parentFrame:CreateFontString( frameEmblemOfHeroism.."Text", "OVERLAY", "GameFontNormal" )
	frameEmblemOfHeroismText:SetText( L["EoH"] )
	frameEmblemOfHeroismText:SetTextColor( r, g, b, a )
	frameEmblemOfHeroismText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, top )
	frameEmblemOfHeroismText:SetWidth( width )
	frameEmblemOfHeroismText:SetJustifyH( "CENTER" )
	frame.EmblemOfHeroismText = frameEmblemOfHeroismText
	left = left + spacing
	-- Set the HonorPoints font string.
	local frameHonorPoints = AJM.globalCurrencyFramePrefix.."TitleHonorPoints"
	local frameHonorPointsText = parentFrame:CreateFontString( frameHonorPoints.."Text", "OVERLAY", "GameFontNormal" )
	frameHonorPointsText:SetText( L["HP"] )
	frameHonorPointsText:SetTextColor( r, g, b, a )
	frameHonorPointsText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, top )
	frameHonorPointsText:SetWidth( width )
	frameHonorPointsText:SetJustifyH( "CENTER" )
	frame.HonorPointsText = frameHonorPointsText
	left = left + spacing
	-- Set the ArenaPoints font string.
	local frameArenaPoints = AJM.globalCurrencyFramePrefix.."TitleArenaPoints"
	local frameArenaPointsText = parentFrame:CreateFontString( frameArenaPoints.."Text", "OVERLAY", "GameFontNormal" )
	frameArenaPointsText:SetText( L["AP"] )
	frameArenaPointsText:SetTextColor( r, g, b, a )
	frameArenaPointsText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, top )
	frameArenaPointsText:SetWidth( width )
	frameArenaPointsText:SetJustifyH( "CENTER" )
	frame.ArenaPointsText = frameArenaPointsText
	left = left + spacing

	-- Set the Total Gold font string.
	left = 10
	top = -50

	--[[local frameTotalGoldTitle = AJM.globalCurrencyFramePrefix.."TitleTotalGold"
	local frameTotalGoldTitleText = parentFrame:CreateFontString( frameTotalGoldTitle.."Text", "OVERLAY", "GameFontNormal" )
	frameTotalGoldTitleText:SetText( L["Total"] )
	frameTotalGoldTitleText:SetTextColor( r, g, b, a )
	frameTotalGoldTitleText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, top )
	frameTotalGoldTitleText:SetWidth( width )
	frameTotalGoldTitleText:SetJustifyH( "LEFT" )
	frame.TotalGoldTitleText = frameTotalGoldTitleText]]--

	local frameTotalGoldGuildTitle = AJM.globalCurrencyFramePrefix.."TitleTotalGoldGuild"
	local frameTotalGoldGuildTitleText = parentFrame:CreateFontString( frameTotalGoldGuildTitle.."Text", "OVERLAY", "GameFontNormal" )
	frameTotalGoldGuildTitleText:SetText( L["Guild"] )
	frameTotalGoldGuildTitleText:SetTextColor( r, g, b, a )
	frameTotalGoldGuildTitleText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, top )
	frameTotalGoldGuildTitleText:SetWidth( width )
	frameTotalGoldGuildTitleText:SetJustifyH( "LEFT" )
	frame.TotalGoldGuildTitleText = frameTotalGoldGuildTitleText
	
	--[[local frameTotalGold = AJM.globalCurrencyFramePrefix.."TotalGold"
	local frameTotalGoldText = parentFrame:CreateFontString( frameTotalGold.."Text", "OVERLAY", "GameFontNormal" )
	frameTotalGoldText:SetText( "0" )
	frameTotalGoldText:SetTextColor( r, g, b, a )
	frameTotalGoldText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, top )
	frameTotalGoldText:SetWidth( width )
	frameTotalGoldText:SetJustifyH( "RIGHT" )
	frame.TotalGoldText = frameTotalGoldText]]--

	local frameTotalGoldGuild = AJM.globalCurrencyFramePrefix.."TotalGoldGuild"
	local frameTotalGoldGuildText = parentFrame:CreateFontString( frameTotalGoldGuild.."Text", "OVERLAY", "GameFontNormal" )
	frameTotalGoldGuildText:SetText( "0" )
	frameTotalGoldGuildText:SetTextColor( r, g, b, a )
	frameTotalGoldGuildText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, top )
	frameTotalGoldGuildText:SetWidth( width )
	frameTotalGoldGuildText:SetJustifyH( "RIGHT" )
	frame.TotalGoldGuildText = frameTotalGoldGuildText
	
	-- Set frame width.
	frame:SetWidth( left + 10 )
	
	-- Set transparency of the the frame (and all its children).
	frame:SetAlpha( AJM.db.currencyFrameAlpha )
	
	-- Set scale.
	frame:SetScale( AJM.db.currencyScale )
	
	-- Set the global frame reference for this frame.
	JambaToonCurrencyListFrame = frame
	
	-- Close.
	local closeButton = CreateFrame( "Button", AJM.globalCurrencyFramePrefix.."ButtonClose", frame, "UIPanelCloseButton" )
	closeButton:SetScript( "OnClick", function() JambaToonCurrencyListFrame:Hide() end )
	closeButton:SetPoint( "TOPRIGHT", frame, "TOPRIGHT", 0, 0 )	
	frame.closeButton = closeButton
	
	-- Update.
	local updateButton = CreateFrame( "Button", AJM.globalCurrencyFramePrefix.."ButtonUpdate", frame, "UIPanelButtonTemplate" )
	updateButton:SetScript( "OnClick", function() AJM:JambaToonRequestCurrency() end )
	updateButton:SetPoint( "TOPRIGHT", frame, "TOPRIGHT", -30, -4 )
	updateButton:SetHeight( 22 )
	updateButton:SetWidth( 55 )
	updateButton:SetText( L["Update"] )		
	frame.updateButton = updateButton
	
	AJM:CurrencyListSetHeight()
	AJM:SettingsUpdateBorderStyle()
	AJM:CurrencyUpdateWindowLock()
	JambaToonCurrencyListFrame:Hide()
	AJM.currencyListFrameCreated = true
end

function AJM:CurrencyUpdateWindowLock()
	if AJM.db.currencyLockWindow == false then
		JambaToonCurrencyListFrame:EnableMouse( true )
	else
		JambaToonCurrencyListFrame:EnableMouse( false )
	end
end

function AJM:SettingsUpdateBorderStyle()
	local borderStyle = AJM.SharedMedia:Fetch( "border", AJM.db.currencyBorderStyle )
	local backgroundStyle = AJM.SharedMedia:Fetch( "background", AJM.db.currencyBackgroundStyle )
	local frame = JambaToonCurrencyListFrame
	frame:SetBackdrop( {
		bgFile = backgroundStyle, 
		edgeFile = borderStyle, 
		tile = true, tileSize = frame:GetWidth(), edgeSize = 10, 
		insets = { left = 3, right = 3, top = 3, bottom = 3 }
	} )
	frame:SetBackdropColor( AJM.db.currencyFrameBackgroundColourR, AJM.db.currencyFrameBackgroundColourG, AJM.db.currencyFrameBackgroundColourB, AJM.db.currencyFrameBackgroundColourA )
	frame:SetBackdropBorderColor( AJM.db.currencyFrameBorderColourR, AJM.db.currencyFrameBorderColourG, AJM.db.currencyFrameBorderColourB, AJM.db.currencyFrameBorderColourA )
	frame:SetAlpha( AJM.db.currencyFrameAlpha )
end

function AJM:CurrencyListSetHeight()
	local additionalLines = 0
	local addHeight = 0
	if AJM.db.currGold == true then
		if AJM.db.currGoldInGuildBank == true then
			--[[additionalLines = 2
			addHeight = 7
		else]]--
			additionalLines = 1
			addHeight = 5
		end
	end
	JambaToonCurrencyListFrame:SetHeight( 56 + ((JambaApi.GetTeamListMaximumOrder() + additionalLines) * 15) + addHeight )
end

function AJM:CurrencyListSetColumnWidth()
	local nameWidth = AJM.db.currencyNameWidth
	local pointsWidth = AJM.db.currencyPointsWidth
	local goldWidth = AJM.db.currencyGoldWidth
	local spacingWidth = AJM.db.currencySpacingWidth
	local frameHorizontalSpacing = 10
	local numberOfPointsColumns = 0
	local parentFrame = JambaToonCurrencyListFrame
	local headingRowTopPoint = -30
	local left = frameHorizontalSpacing
	local haveGold = 0
	-- Heading rows.
	parentFrame.characterNameText:SetWidth( nameWidth )
	parentFrame.characterNameText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, headingRowTopPoint )
	left = left + nameWidth + spacingWidth
	if AJM.db.currGold == true then
		parentFrame.GoldText:SetWidth( goldWidth )
		parentFrame.GoldText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, headingRowTopPoint )
		left = left + goldWidth + (spacingWidth * 3)
		parentFrame.GoldText:Show()
		haveGold = 1
	else
		parentFrame.GoldText:Hide()
		haveGold = 0
	end
	if AJM.db.currEmblemOfFrost == true then
		parentFrame.EmblemOfFrostText:SetWidth( pointsWidth )
		parentFrame.EmblemOfFrostText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, headingRowTopPoint )
		left = left + pointsWidth + spacingWidth
		numberOfPointsColumns = numberOfPointsColumns + 1
		parentFrame.EmblemOfFrostText:Show()
	else
		parentFrame.EmblemOfFrostText:Hide()
	end
	if AJM.db.currEmblemOfTriumph == true then
		parentFrame.EmblemOfTriumphText:SetWidth( pointsWidth )
		parentFrame.EmblemOfTriumphText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, headingRowTopPoint )
		left = left + pointsWidth + spacingWidth
		numberOfPointsColumns = numberOfPointsColumns + 1
		parentFrame.EmblemOfTriumphText:Show()
	else
		parentFrame.EmblemOfTriumphText:Hide()
	end
	if AJM.db.currEmblemOfConquest == true then
		parentFrame.EmblemOfConquestText:SetWidth( pointsWidth )
		parentFrame.EmblemOfConquestText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, headingRowTopPoint )
		left = left + pointsWidth + spacingWidth
		numberOfPointsColumns = numberOfPointsColumns + 1
		parentFrame.EmblemOfConquestText:Show()
	else
		parentFrame.EmblemOfConquestText:Hide()
	end
	if AJM.db.currEmblemOfValor == true then
		parentFrame.EmblemOfValorText:SetWidth( pointsWidth )
		parentFrame.EmblemOfValorText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, headingRowTopPoint )
		left = left + pointsWidth + spacingWidth
		numberOfPointsColumns = numberOfPointsColumns + 1
		parentFrame.EmblemOfValorText:Show()
	else
		parentFrame.EmblemOfValorText:Hide()
	end
	if AJM.db.currEmblemOfHeroism == true then
		parentFrame.EmblemOfHeroismText:SetWidth( pointsWidth )
		parentFrame.EmblemOfHeroismText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, headingRowTopPoint )
		left = left + pointsWidth + spacingWidth
		numberOfPointsColumns = numberOfPointsColumns + 1
		parentFrame.EmblemOfHeroismText:Show()
	else
		parentFrame.EmblemOfHeroismText:Hide()
	end
	if AJM.db.currHonorPoints == true then
		parentFrame.HonorPointsText:SetWidth( pointsWidth )
		parentFrame.HonorPointsText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, headingRowTopPoint )
		left = left + pointsWidth + spacingWidth
		numberOfPointsColumns = numberOfPointsColumns + 1
		parentFrame.HonorPointsText:Show()
	else
		parentFrame.HonorPointsText:Hide()
	end
	if AJM.db.currArenaPoints == true then
		parentFrame.ArenaPointsText:SetWidth( pointsWidth )
		parentFrame.ArenaPointsText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, headingRowTopPoint )
		left = left + pointsWidth + spacingWidth
		numberOfPointsColumns = numberOfPointsColumns + 1
		parentFrame.ArenaPointsText:Show()
	else
		parentFrame.ArenaPointsText:Hide()
	end
	-- Character rows.
	for characterName, currencyFrameCharacterInfo in pairs( AJM.currencyFrameCharacterInfo ) do
		local left = frameHorizontalSpacing
		local characterRowTopPoint = currencyFrameCharacterInfo.characterRowTopPoint
		currencyFrameCharacterInfo.characterNameText:SetWidth( nameWidth )
		currencyFrameCharacterInfo.characterNameText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, characterRowTopPoint )
		left = left + nameWidth + spacingWidth
		if AJM.db.currGold == true then
			currencyFrameCharacterInfo.GoldText:SetWidth( goldWidth )
			currencyFrameCharacterInfo.GoldText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, characterRowTopPoint )
			left = left + goldWidth + (spacingWidth * 3)
			currencyFrameCharacterInfo.GoldText:Show()
		else
			currencyFrameCharacterInfo.GoldText:Hide()
		end
		if AJM.db.currEmblemOfFrost == true then
			currencyFrameCharacterInfo.EmblemOfFrostText:SetWidth( pointsWidth )
			currencyFrameCharacterInfo.EmblemOfFrostText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, characterRowTopPoint )
			left = left + pointsWidth + spacingWidth
			currencyFrameCharacterInfo.EmblemOfFrostText:Show()
		else
			currencyFrameCharacterInfo.EmblemOfFrostText:Hide()
		end
		if AJM.db.currEmblemOfTriumph == true then
			currencyFrameCharacterInfo.EmblemOfTriumphText:SetWidth( pointsWidth )
			currencyFrameCharacterInfo.EmblemOfTriumphText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, characterRowTopPoint )
			left = left + pointsWidth + spacingWidth
			currencyFrameCharacterInfo.EmblemOfTriumphText:Show()
		else
			currencyFrameCharacterInfo.EmblemOfTriumphText:Hide()
		end
		if AJM.db.currEmblemOfConquest == true then
			currencyFrameCharacterInfo.EmblemOfConquestText:SetWidth( pointsWidth )
			currencyFrameCharacterInfo.EmblemOfConquestText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, characterRowTopPoint )
			left = left + pointsWidth + spacingWidth
			currencyFrameCharacterInfo.EmblemOfConquestText:Show()
		else
			currencyFrameCharacterInfo.EmblemOfConquestText:Hide()
		end
		if AJM.db.currEmblemOfValor == true then
			currencyFrameCharacterInfo.EmblemOfValorText:SetWidth( pointsWidth )
			currencyFrameCharacterInfo.EmblemOfValorText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, characterRowTopPoint )
			left = left + pointsWidth + spacingWidth
			currencyFrameCharacterInfo.EmblemOfValorText:Show()
		else
			currencyFrameCharacterInfo.EmblemOfValorText:Hide()
		end
		if AJM.db.currEmblemOfHeroism == true then
			currencyFrameCharacterInfo.EmblemOfHeroismText:SetWidth( pointsWidth )
			currencyFrameCharacterInfo.EmblemOfHeroismText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, characterRowTopPoint )
			left = left + pointsWidth + spacingWidth
			currencyFrameCharacterInfo.EmblemOfHeroismText:Show()
		else
			currencyFrameCharacterInfo.EmblemOfHeroismText:Hide()
		end
		if AJM.db.currHonorPoints == true then
			currencyFrameCharacterInfo.HonorPointsText:SetWidth( pointsWidth )
			currencyFrameCharacterInfo.HonorPointsText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, characterRowTopPoint )
			left = left + pointsWidth + spacingWidth
			currencyFrameCharacterInfo.HonorPointsText:Show()
		else
			currencyFrameCharacterInfo.HonorPointsText:Hide()
		end
		if AJM.db.currArenaPoints == true then
			currencyFrameCharacterInfo.ArenaPointsText:SetWidth( pointsWidth )
			currencyFrameCharacterInfo.ArenaPointsText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, characterRowTopPoint )
			left = left + pointsWidth + spacingWidth
			currencyFrameCharacterInfo.ArenaPointsText:Show()
		else
			currencyFrameCharacterInfo.ArenaPointsText:Hide()
		end
	end
	-- Parent frame width and title.
	local finalParentWidth = frameHorizontalSpacing + nameWidth + spacingWidth + (haveGold * (goldWidth + (spacingWidth * 3))) + (numberOfPointsColumns * (pointsWidth + spacingWidth)) + frameHorizontalSpacing
	if finalParentWidth < 95 then
		finalParentWidth = 95
	end
	local widthOfCloseAndUpdateButtons = 70
	parentFrame.titleName:SetWidth( finalParentWidth - widthOfCloseAndUpdateButtons - frameHorizontalSpacing - frameHorizontalSpacing )
	parentFrame.titleName:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", frameHorizontalSpacing, -9 )
	if AJM.db.currGold == true then
		if numberOfPointsColumns > 1 then
			parentFrame.titleName:SetText( L["Jamba Currency"] )
		else
			parentFrame.titleName:SetText( L["Currency"] )
		end
	else
		if numberOfPointsColumns < 2 then
			parentFrame.titleName:SetText( "" )
		end
		if numberOfPointsColumns == 2 then
			parentFrame.titleName:SetText( L["Curr"] )
		end
		if (numberOfPointsColumns >= 3) and (numberOfPointsColumns <= 4) then
			parentFrame.titleName:SetText( L["Currency"] )
		end
		if numberOfPointsColumns > 4 then
			parentFrame.titleName:SetText( L["Jamba Currency"] )
		end
	end
	parentFrame:SetWidth( finalParentWidth )
	-- Total Gold.
	local nameLeft = frameHorizontalSpacing
	local goldLeft = frameHorizontalSpacing + nameWidth + spacingWidth
	local guildTop = -35 - ((JambaApi.GetTeamListMaximumOrder() + 1) * 15) - 5
	local goldTop = -35 - ((JambaApi.GetTeamListMaximumOrder() + 1) * 15) - 7	
	if AJM.db.currGold == true then
		if AJM.db.currGoldInGuildBank == true then
			parentFrame.TotalGoldGuildTitleText:SetWidth( nameWidth )
			parentFrame.TotalGoldGuildTitleText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", nameLeft, guildTop )
			parentFrame.TotalGoldGuildTitleText:Show()
			parentFrame.TotalGoldGuildText:SetWidth( goldWidth )
			parentFrame.TotalGoldGuildText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", goldLeft, guildTop )
			parentFrame.TotalGoldGuildText:Show()
			goldTop = -35 - ((JambaApi.GetTeamListMaximumOrder() + 2) * 15) - 5
		else
			parentFrame.TotalGoldGuildTitleText:Hide()
			parentFrame.TotalGoldGuildText:Hide()			
		end
		--[[parentFrame.TotalGoldTitleText:SetWidth( nameWidth )
		parentFrame.TotalGoldTitleText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", nameLeft, goldTop )
		parentFrame.TotalGoldTitleText:Show()
		parentFrame.TotalGoldText:SetWidth( goldWidth )
		parentFrame.TotalGoldText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", goldLeft, goldTop )
		parentFrame.TotalGoldText:Show()]]--
	else
		-- parentFrame.TotalGoldTitleText:Hide()
		-- parentFrame.TotalGoldText:Hide()
		parentFrame.TotalGoldGuildTitleText:Hide()
		parentFrame.TotalGoldGuildText:Hide()	
	end
end

function AJM:CreateJambaCurrencyFrameInfo( characterName, parentFrame )
	local left = 10
	local spacing = 50
	local width = 50
	local top = -35 + (-15 * JambaApi.GetPositionForCharacterName( characterName ))
	-- Create the table to hold the status bars for this character.
	AJM.currencyFrameCharacterInfo[characterName] = {}
	-- Get the character info table.
	local currencyFrameCharacterInfo = AJM.currencyFrameCharacterInfo[characterName]
	currencyFrameCharacterInfo.characterRowTopPoint = top
	-- Set the characters name font string.
	local frameCharacterName = AJM.globalCurrencyFramePrefix.."CharacterName"
	local frameCharacterNameText = parentFrame:CreateFontString( frameCharacterName.."Text", "OVERLAY", "GameFontNormal" )
	frameCharacterNameText:SetText( characterName )
	frameCharacterNameText:SetTextColor( 1.00, 1.00, 1.00, 1.00 )
	frameCharacterNameText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, top )
	frameCharacterNameText:SetWidth( width * 2.5 )
	frameCharacterNameText:SetJustifyH( "LEFT" )
	currencyFrameCharacterInfo.characterNameText = frameCharacterNameText
	left = left + (spacing * 2)
	-- Set the Gold font string.
	local frameGold = AJM.globalCurrencyFramePrefix.."Gold"
	local frameGoldText = parentFrame:CreateFontString( frameGold.."Text", "OVERLAY", "GameFontNormal" )
	frameGoldText:SetText( "0" )
	frameGoldText:SetTextColor( 1.00, 1.00, 1.00, 1.00 )
	frameGoldText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, top )
	frameGoldText:SetWidth( width )
	frameGoldText:SetJustifyH( "RIGHT" )
	currencyFrameCharacterInfo.GoldText = frameGoldText
	left = left + spacing	
	-- Set the EmblemOfFrost font string.
	local frameEmblemOfFrost = AJM.globalCurrencyFramePrefix.."EmblemOfFrost"
	local frameEmblemOfFrostText = parentFrame:CreateFontString( frameEmblemOfFrost.."Text", "OVERLAY", "GameFontNormal" )
	frameEmblemOfFrostText:SetText( "0" )
	frameEmblemOfFrostText:SetTextColor( 1.00, 1.00, 1.00, 1.00 )
	frameEmblemOfFrostText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, top )
	frameEmblemOfFrostText:SetWidth( width )
	frameEmblemOfFrostText:SetJustifyH( "CENTER" )
	currencyFrameCharacterInfo.EmblemOfFrostText = frameEmblemOfFrostText
	left = left + spacing
	-- Set the EmblemOfTriumph font string.
	local frameEmblemOfTriumph = AJM.globalCurrencyFramePrefix.."EmblemOfTriumph"
	local frameEmblemOfTriumphText = parentFrame:CreateFontString( frameEmblemOfTriumph.."Text", "OVERLAY", "GameFontNormal" )
	frameEmblemOfTriumphText:SetText( "0" )
	frameEmblemOfTriumphText:SetTextColor( 1.00, 1.00, 1.00, 1.00 )
	frameEmblemOfTriumphText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, top )
	frameEmblemOfTriumphText:SetWidth( width )
	frameEmblemOfTriumphText:SetJustifyH( "CENTER" )
	currencyFrameCharacterInfo.EmblemOfTriumphText = frameEmblemOfTriumphText
	left = left + spacing
	-- Set the EmblemOfConquest font string.
	local frameEmblemOfConquest = AJM.globalCurrencyFramePrefix.."EmblemOfConquest"
	local frameEmblemOfConquestText = parentFrame:CreateFontString( frameEmblemOfConquest.."Text", "OVERLAY", "GameFontNormal" )
	frameEmblemOfConquestText:SetText( "0" )
	frameEmblemOfConquestText:SetTextColor( 1.00, 1.00, 1.00, 1.00 )
	frameEmblemOfConquestText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, top )
	frameEmblemOfConquestText:SetWidth( width )
	frameEmblemOfConquestText:SetJustifyH( "CENTER" )
	currencyFrameCharacterInfo.EmblemOfConquestText = frameEmblemOfConquestText
	left = left + spacing
	-- Set the EmblemOfValor font string.
	local frameEmblemOfValor = AJM.globalCurrencyFramePrefix.."EmblemOfValor"
	local frameEmblemOfValorText = parentFrame:CreateFontString( frameEmblemOfValor.."Text", "OVERLAY", "GameFontNormal" )
	frameEmblemOfValorText:SetText( "0" )
	frameEmblemOfValorText:SetTextColor( 1.00, 1.00, 1.00, 1.00 )
	frameEmblemOfValorText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, top )
	frameEmblemOfValorText:SetWidth( width )
	frameEmblemOfValorText:SetJustifyH( "CENTER" )
	currencyFrameCharacterInfo.EmblemOfValorText = frameEmblemOfValorText
	left = left + spacing
	-- Set the EmblemOfHeroism font string.
	local frameEmblemOfHeroism = AJM.globalCurrencyFramePrefix.."EmblemOfHeroism"
	local frameEmblemOfHeroismText = parentFrame:CreateFontString( frameEmblemOfHeroism.."Text", "OVERLAY", "GameFontNormal" )
	frameEmblemOfHeroismText:SetText( "0" )
	frameEmblemOfHeroismText:SetTextColor( 1.00, 1.00, 1.00, 1.00 )
	frameEmblemOfHeroismText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, top )
	frameEmblemOfHeroismText:SetWidth( width )
	frameEmblemOfHeroismText:SetJustifyH( "CENTER" )
	currencyFrameCharacterInfo.EmblemOfHeroismText = frameEmblemOfHeroismText
	left = left + spacing
	-- Set the HonorPoints font string.
	local frameHonorPoints = AJM.globalCurrencyFramePrefix.."HonorPoints"
	local frameHonorPointsText = parentFrame:CreateFontString( frameHonorPoints.."Text", "OVERLAY", "GameFontNormal" )
	frameHonorPointsText:SetText( "0" )
	frameHonorPointsText:SetTextColor( 1.00, 1.00, 1.00, 1.00 )
	frameHonorPointsText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, top )
	frameHonorPointsText:SetWidth( width )
	frameHonorPointsText:SetJustifyH( "CENTER" )
	currencyFrameCharacterInfo.HonorPointsText = frameHonorPointsText
	left = left + spacing
	-- Set the ArenaPoints font string.
	local frameArenaPoints = AJM.globalCurrencyFramePrefix.."ArenaPoints"
	local frameArenaPointsText = parentFrame:CreateFontString( frameArenaPoints.."Text", "OVERLAY", "GameFontNormal" )
	frameArenaPointsText:SetText( "0" )
	frameArenaPointsText:SetTextColor( 1.00, 1.00, 1.00, 1.00 )
	frameArenaPointsText:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", left, top )
	frameArenaPointsText:SetWidth( width )
	frameArenaPointsText:SetJustifyH( "CENTER" )
	currencyFrameCharacterInfo.ArenaPointsText = frameArenaPointsText
	left = left + spacing
end

function AJM:JambaToonRequestCurrency()
	-- Colour red.
	local r = 1.0
	local g = 0.0
	local b = 0.0
	local a = 0.6
	for characterName, currencyFrameCharacterInfo in pairs( AJM.currencyFrameCharacterInfo ) do
		currencyFrameCharacterInfo.GoldText:SetTextColor( r, g, b, a )
		currencyFrameCharacterInfo.characterNameText:SetTextColor( r, g, b, a )
        currencyFrameCharacterInfo.EmblemOfFrostText:SetTextColor( r, g, b, a )
        currencyFrameCharacterInfo.EmblemOfTriumphText:SetTextColor( r, g, b, a )
        currencyFrameCharacterInfo.EmblemOfConquestText:SetTextColor( r, g, b, a )
        currencyFrameCharacterInfo.EmblemOfValorText:SetTextColor( r, g, b, a )
        currencyFrameCharacterInfo.EmblemOfHeroismText:SetTextColor( r, g, b, a )
        currencyFrameCharacterInfo.HonorPointsText:SetTextColor( r, g, b, a )
        currencyFrameCharacterInfo.ArenaPointsText:SetTextColor( r, g, b, a )
	end
	--[[AJM.currencyTotalGold = 0
	if AJM.db.currGoldInGuildBank == true then
		if IsInGuild() == 1 then
			AJM.currencyTotalGold = GetGuildBankMoney()
		end
	end]]--
	AJM:JambaSendCommandToTeam( AJM.COMMAND_REQUEST_CURRENCY, "" )
end

function AJM:DoSendCurrency( characterName, dummyValue )
	table.wipe( AJM.currentCurrencyValues )
	AJM.currentCurrencyValues.currGold = GetMoney()

    AJM.currentCurrencyValues.currEmblemOfFrost = 0
    AJM.currentCurrencyValues.currEmblemOfTriumph = 0
    AJM.currentCurrencyValues.currEmblemOfConquest = 0
    AJM.currentCurrencyValues.currEmblemOfValor = 0
    AJM.currentCurrencyValues.currEmblemOfHeroism = 0
    AJM.currentCurrencyValues.currHonorPoints = 0
    AJM.currentCurrencyValues.currArenaPoints = 0

    for index=1, GetCurrencyListSize() do 
        name, isHeader, isExpanded, isUnused, isWatched, count = GetCurrencyListInfo(index);
        if (name == "Emblem of Frost") then
            AJM.currentCurrencyValues.currEmblemOfFrost = count
        elseif (name == "Emblem of Triumph") then
            AJM.currentCurrencyValues.currEmblemOfTriumph = count
        elseif (name == "Emblem of Conquest") then
            AJM.currentCurrencyValues.currEmblemOfConquest = count
        elseif (name == "Emblem of Valor") then
            AJM.currentCurrencyValues.currEmblemOfValor = count
        elseif (name == "Emblem of Heroism") then
            AJM.currentCurrencyValues.currEmblemOfHeroism = count
        elseif (name == "Honor Points") then
            AJM.currentCurrencyValues.currHonorPoints = count
        elseif (name == "Arena Points") then
            AJM.currentCurrencyValues.currArenaPoints = count
        end
    end 

	AJM:JambaSendCommandToToon( characterName, AJM.COMMAND_HERE_IS_CURRENCY, AJM.currentCurrencyValues )
end

function AJM:DoShowToonsCurrency( characterName, currencyValues )
	local parentFrame = JambaToonCurrencyListFrame
	-- Get (or create and get) the character information.
	local currencyFrameCharacterInfo = AJM.currencyFrameCharacterInfo[characterName]
	if currencyFrameCharacterInfo == nil then
		AJM:CreateJambaCurrencyFrameInfo( characterName, parentFrame )
		currencyFrameCharacterInfo = AJM.currencyFrameCharacterInfo[characterName]
	end
	-- Colour white.
	local r = 1.0
	local g = 1.0
	local b = 1.0
	local a = 1.0
	currencyFrameCharacterInfo.GoldText:SetTextColor( r, g, b, a )
	currencyFrameCharacterInfo.characterNameText:SetTextColor( r, g, b, a )
    currencyFrameCharacterInfo.EmblemOfFrostText:SetTextColor( r, g, b, a )
    currencyFrameCharacterInfo.EmblemOfTriumphText:SetTextColor( r, g, b, a )
    currencyFrameCharacterInfo.EmblemOfConquestText:SetTextColor( r, g, b, a )
    currencyFrameCharacterInfo.EmblemOfValorText:SetTextColor( r, g, b, a )
    currencyFrameCharacterInfo.EmblemOfHeroismText:SetTextColor( r, g, b, a )
    currencyFrameCharacterInfo.HonorPointsText:SetTextColor( r, g, b, a )
    currencyFrameCharacterInfo.ArenaPointsText:SetTextColor( r, g, b, a )
	-- Information.
	currencyFrameCharacterInfo.GoldText:SetText( JambaUtilities:FormatMoneyString( currencyValues.currGold ) )
    currencyFrameCharacterInfo.EmblemOfFrostText:SetText( currencyValues.currEmblemOfFrost )
    currencyFrameCharacterInfo.EmblemOfTriumphText:SetText( currencyValues.currEmblemOfTriumph )
    currencyFrameCharacterInfo.EmblemOfConquestText:SetText( currencyValues.currEmblemOfConquest )
    currencyFrameCharacterInfo.EmblemOfValorText:SetText( currencyValues.currEmblemOfValor )
    currencyFrameCharacterInfo.EmblemOfHeroismText:SetText( currencyValues.currEmblemOfHeroism )
    currencyFrameCharacterInfo.HonorPointsText:SetText( currencyValues.currHonorPoints )
    currencyFrameCharacterInfo.ArenaPointsText:SetText( currencyValues.currArenaPoints )
	-- Total gold.
	--[[AJM.currencyTotalGold = AJM.currencyTotalGold + currencyValues.currGold
	parentFrame.TotalGoldText:SetText( JambaUtilities:FormatMoneyString( AJM.currencyTotalGold ) )--]]
	if IsInGuild() == 1 then
		parentFrame.TotalGoldGuildText:SetText( JambaUtilities:FormatMoneyString( GetGuildBankMoney() ) )
	end
	-- Update width of currrency list.
	AJM:CurrencyListSetColumnWidth()
	JambaToonCurrencyListFrame:Show()
end

-- A Jamba command has been recieved.
function AJM:JambaOnCommandReceived( characterName, commandName, ... )
	if commandName == AJM.COMMAND_REQUEST_CURRENCY then
		AJM:DoSendCurrency( characterName, ... )
	end
	if commandName == AJM.COMMAND_HERE_IS_CURRENCY then
		AJM:DoShowToonsCurrency( characterName, ... )
	end
end
