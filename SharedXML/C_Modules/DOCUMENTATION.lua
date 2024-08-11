--https://wow.gamepedia.com/ColorMixin
--===== Construction
CreateColor(r, g, b [, a]) -- Creates a new color with three or four values between 0 and 1.
CreateColorFromHexString(hexColor) -- Creates a new color from a string of eight hexademical characters as AARRGGBB.
CreateColorFromBytes(r, g, b, a) -- Creates a new color with four values between 0 and 255.
--===== Methods
--** Fundamental
ColorMixin:GetRGB() -- Returns three values between 0 and 1.
ColorMixin:GetRGBA() -- Returns three or four values between 0 and 1.
ColorMixin:GetRGBAsBytes() -- Returns three values between 0 and 255.
ColorMixin:GetRGBAAsBytes() -- Returns four values between 0 and 255.
ColorMixin:SetRGB(r, g, b) -- Changes the color using new values between 0 and 1, while setting alpha to nil.
ColorMixin:SetRGBA(r, g, b [,a ]) -- Changes the color and alpha using new values between 0 and 1.
--** String output
ColorMixin:GenerateHexColor() -- Returns ff followed by six hexadecimal characters representing the color (ignoring alpha).
ColorMixin:GenerateHexColorMarkup() -- Returns an escape sequence usable in front of text to set its color (ignoring alpha).
ColorMixin:WrapTextInColorCode(text) -- Wraps the text with |cAARRGGBB and |r escape sequences (ignoring alpha).
--** Calculation
ColorMixin:IsEqualTo(otherColor) -- Indicates if two colors have equal red, green, blue and alpha components.


--https://wow.gamepedia.com/API_C_ClassColor.GetClassColor
classColor = C_ClassColor:GetClassColor("className") e.g. "PRIEST"

--===== C_Texture
--https://wow.gamepedia.com/API_C_Texture.GetAtlasInfo
C_Texture.GetAtlasInfo(atlas)
C_Texture.GetAtlasTextCoord(atlas)
SetAtlas(texture, atlas, size)

--===== C_Timer
C_Timer:After(duration, callback)
C_Timer:NewTicker(duration, callback, iterations)

--===== C_PlayerInfo
C_PlayerInfo.GetGMLevel()
C_PlayerInfo.GetDMLevel()

--===== C_Profession
C_Profession:HasSecondPage()
C_Profession:GetProfessionIndex(buttonName)

--===== UTF-8
string.utf8len(s)
string.utf8sub(s, i, j)
string.utf8reverse(s)
string.utf8upper(s)
string.utf8lower(s)

--===== Events
RegisterEvent(event, callback, ...)

--===== FormattingUtil
SplitTextIntoLines(text, delimiter)
SplitTextIntoHeaderAndNonHeader(text)
FormatValueWithSign(value)
FormatLargeNumber(amount)
GetMoneyString(money, separateThousands)
FormatPercentage(percentage, roundToNearestInteger)
FormatFraction(numerator, denominator)
GetHighlightedNumberDifferenceString(baseString, newString)
FormatUnreadMailTooltip(tooltip, headerText, senders)

--===== FunctionUtil
ExecuteFrameScript(frame, scriptName, ...)
CallMethodOnNearestAncestor(self, methodName, ...)
GetValueOrCallFunction(tbl, key, ...)
GenerateClosure(f, ...)

--===== LinkUtil
ExtractHyperlinkString(linkString)
ExtractLinkData(link)
ExtractQuestRewardID(linkString)
GetItemInfoFromHyperlink(link)
GetAchievementInfoFromHyperlink(link)
EscChar(textString)

--===== MathUtil
Lerp(startValue, endValue, amount)
Clamp(value, min, max)
Saturate(value)
Wrap(value, max)
ClampDegrees(value)
ClampMod(value, mod)
NegateIf(value, condition)
PercentageBetween(value, startValue, endValue)
ClampedPercentageBetween(value, startValue, endValue)
DeltaLerp(startValue, endValue, amount, timeSec)
FrameDeltaLerp(startValue, endValue, amount)
RandomFloatInRange(minValue, maxValue)
Round(value)
round2(num, numDecimalPlaces)
Square(value)
CalculateDistanceSq(x1, y1, x2, y2)
CalculateDistance(x1, y1, x2, y2)
CalculateAngleBetween(x1, y1, x2, y2)

--===== TableUtil
ripairsiter(table, index)
ripairs(table)
tDeleteItem(tbl, item)
tIndexOf(tbl, item)
tContains(tbl, item)
tCompare(lhsTable, rhsTable, depth)
tInvert(tbl)
tFilter(tbl, pred, isIndexTable)
tAppendAll(table, addedArray)
tUnorderedRemove(tbl, index)
CopyTable(settings)
AccumulateIf(tbl, pred)
ContainsIf(tbl, pred)
FindInTableIf(tbl, pred)
SafePack(...)
SafeUnpack(tbl)

--===== TimeUtil
SecondsToMinutes(seconds)
MinutesToSeconds(minutes)
HasTimePassed(testTime, amountOfTime)
SecondsToClock(seconds, displayZeroHours)
SecondsToTime(seconds, noSeconds, notAbbreviated, maxCount, roundUp)
SecondsToTimeAbbrev(seconds)
FormatShortDate(day, month, year)

--===== UnitUtil
GetPlayerGuid()
IsPlayerGuid(guid)



--===== Mixin
Mixin(object, ...)
CreateFromMixins(...)

--===== MIXIN Rectangle see Rectangle.lua
CreateRectangle(left, right, top, bottom)
--===== MIXIN TabGroup see TabGroup.lua
CreateTabGroup(...)






































