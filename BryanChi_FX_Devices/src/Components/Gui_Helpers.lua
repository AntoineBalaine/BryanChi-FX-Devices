local gui_helpers = {}
--
---@param A string text for tooltip
function gui_helpers.tooltip(A)
    r.ImGui_BeginTooltip(ctx)
    r.ImGui_SetTooltip(ctx, A)
    r.ImGui_EndTooltip(ctx)
end

---@param A string text for tooltip
function gui_helpers.HintToolTip(A)
    r.ImGui_BeginTooltip(ctx)
    r.ImGui_SetTooltip(ctx, A)
    r.ImGui_EndTooltip(ctx)
end

function gui_helpers.InvisiBtn(ctx, x, y, str, w, h)
    if x and y then
        r.ImGui_SetCursorScreenPos(ctx, x, y)
    end
    local rv = r.ImGui_InvisibleButton(ctx, str, w, h or w)


    return rv
end
---@param text string
---@param font? ImGui_Font
---@param color? number rgba
---@param WrapPosX? number
function gui_helpers.MyText(text, font, color, WrapPosX)
    if WrapPosX then r.ImGui_PushTextWrapPos(ctx, WrapPosX) end

    if font then r.ImGui_PushFont(ctx, font) end
    if color then
        r.ImGui_TextColored(ctx, color, text)
    else
        r.ImGui_Text(ctx, text)
    end

    if font then r.ImGui_PopFont(ctx) end
    if WrapPosX then r.ImGui_PopTextWrapPos(ctx) end
end

---Same Line
---@param xpos? number offset_from_start_xIn
---@param pad? number spacingIn
function gui_helpers.SL(xpos, pad)
    r.ImGui_SameLine(ctx, xpos, pad)
end

---@param FillClr number
---@param OutlineClr number
---@param Padding number
---@param L number
---@param T number
---@param R number
---@param B number
---@param h number
---@param w number
---@param H_OutlineSc any
---@param V_OutlineSc any
---@param GetItemRect "GetItemRect"|nil
---@param Foreground? ImGui_DrawList
---@param rounding? number
---@return number|nil L
---@return number|nil T
---@return number|nil R
---@return number|nil B
---@return number|nil w
---@return number|nil h
function gui_helpers.HighlightSelectedItem(FillClr, OutlineClr, Padding, L, T, R, B, h, w, H_OutlineSc, V_OutlineSc, GetItemRect,
                               Foreground, rounding, thick)
    if GetItemRect == 'GetItemRect' or L == 'GetItemRect' then
        L, T = r.ImGui_GetItemRectMin(ctx)
        R, B = r.ImGui_GetItemRectMax(ctx)
        w, h = r.ImGui_GetItemRectSize(ctx)
        --Get item rect
    end
    local P = Padding or 0
    local HSC = H_OutlineSc or 4
    local VSC = V_OutlineSc or 4
    if Foreground == 'Foreground' then WinDrawList = FxdCtx.Glob.FDL else WinDrawList = Foreground end
    if not WinDrawList then WinDrawList = r.ImGui_GetWindowDrawList(ctx) end
    if FillClr then r.ImGui_DrawList_AddRectFilled(WinDrawList, L, T, R, B, FillClr) end

    local h = h or B - T
    local w = w or R - L

    if OutlineClr and not rounding then
        r.ImGui_DrawList_AddLine(WinDrawList, L - P, T - P, L - P, T + h / VSC - P, OutlineClr, thick)
        r.ImGui_DrawList_AddLine(WinDrawList, R + P, T - P, R + P, T + h / VSC - P, OutlineClr, thick)
        r.ImGui_DrawList_AddLine(WinDrawList, L - P, B + P, L - P, B + P - h / VSC, OutlineClr, thick)
        r.ImGui_DrawList_AddLine(WinDrawList, R + P, B + P, R + P, B - h / VSC + P, OutlineClr, thick)
        r.ImGui_DrawList_AddLine(WinDrawList, L - P, T - P, L - P + w / HSC, T - P, OutlineClr, thick)
        r.ImGui_DrawList_AddLine(WinDrawList, R + P, T - P, R + P - w / HSC, T - P, OutlineClr, thick)
        r.ImGui_DrawList_AddLine(WinDrawList, L - P, B + P, L - P + w / HSC, B + P, OutlineClr, thick)
        r.ImGui_DrawList_AddLine(WinDrawList, R + P, B + P, R + P - w / HSC, B + P, OutlineClr, thick)
    else
        if FillClr then r.ImGui_DrawList_AddRectFilled(WinDrawList, L, T, R, B, FillClr, rounding) end
        if OutlineClr then r.ImGui_DrawList_AddRect(WinDrawList, L, T, R, B, OutlineClr, rounding) end
    end
    if GetItemRect == 'GetItemRect' then return L, T, R, B, w, h end
end

function gui_helpers.DndAddFX_SRC(fx)
    if r.ImGui_BeginDragDropSource(ctx, r.ImGui_DragDropFlags_AcceptBeforeDelivery()) then
        r.ImGui_SetDragDropPayload(ctx, 'DND ADD FX', fx)
        r.ImGui_Text(ctx, fx)
        r.ImGui_EndDragDropSource(ctx)
    end
end

return gui_helpers
