#include <Memory.au3>
#include <WinAPIMisc.au3>

Global Const $__g_Vector_IID_IUnknown = "{00000000-0000-0000-C000-000000000046}"
Global Const $__g_Vector_IID_IDispatch = "{00020400-0000-0000-C000-000000000046}"

Global Const $__g_Vector_DISPATCH_METHOD = 1
Global Const $__g_Vector_DISPATCH_PROPERTYGET = 2
Global Const $__g_Vector_DISPATCH_PROPERTYPUT = 4
Global Const $__g_Vector_DISPATCH_PROPERTYPUTREF = 8

Global Const $__g_Vector_S_OK = 0x00000000
Global Const $__g_Vector_E_NOTIMPL = 0x80004001
Global Const $__g_Vector_E_NOINTERFACE = 0x80004002
Global Const $__g_Vector_E_POINTER = 0x80004003
Global Const $__g_Vector_E_ABORT = 0x80004004
Global Const $__g_Vector_E_FAIL = 0x80004005
Global Const $__g_Vector_E_ACCESSDENIED = 0x80070005
Global Const $__g_Vector_E_HANDLE = 0x80070006
Global Const $__g_Vector_E_OUTOFMEMORY = 0x8007000E
Global Const $__g_Vector_E_INVALIDARG = 0x80070057
Global Const $__g_Vector_E_UNEXPECTED = 0x8000FFFF

Global Const $__g_Vector_DISP_E_UNKNOWNINTERFACE = 0x80020001
Global Const $__g_Vector_DISP_E_MEMBERNOTFOUND = 0x80020003
Global Const $__g_Vector_DISP_E_PARAMNOTFOUND = 0x80020004
Global Const $__g_Vector_DISP_E_TYPEMISMATCH = 0x80020005
Global Const $__g_Vector_DISP_E_UNKNOWNNAME = 0x80020006
Global Const $__g_Vector_DISP_E_NONAMEDARGS = 0x80020007
Global Const $__g_Vector_DISP_E_BADVARTYPE = 0x80020008
Global Const $__g_Vector_DISP_E_EXCEPTION = 0x80020009
Global Const $__g_Vector_DISP_E_OVERFLOW = 0x8002000A
Global Const $__g_Vector_DISP_E_BADINDEX = 0x8002000B
Global Const $__g_Vector_DISP_E_UNKNOWNLCID = 0x8002000C
Global Const $__g_Vector_DISP_E_ARRAYISLOCKED = 0x8002000D
Global Const $__g_Vector_DISP_E_BADPARAMCOUNT = 0x8002000E
Global Const $__g_Vector_DISP_E_PARAMNOTOPTIONAL = 0x8002000F
Global Const $__g_Vector_DISP_E_BADCALLEE = 0x80020010
Global Const $__g_Vector_DISP_E_NOTACOLLECTION = 0x80020011

Global Const $__g_Vector_tagVARIANT = "ushort vt;ushort r1;ushort r2;ushort r3;PTR data" & (@AutoItX64 ? "" : ";PTR data2")
Global Const $__g_Vector_cVARIANT = DllStructGetSize(DllStructCreate($__g_Vector_tagVARIANT))

Global Enum $__g_Vector_VT_EMPTY,$__g_Vector_VT_NULL,$__g_Vector_VT_I2,$__g_Vector_VT_I4,$__g_Vector_VT_R4,$__g_Vector_VT_R8,$__g_Vector_VT_CY,$__g_Vector_VT_DATE,$__g_Vector_VT_BSTR,$__g_Vector_VT_DISPATCH, _
    $__g_Vector_VT_ERROR,$__g_Vector_VT_BOOL,$__g_Vector_VT_VARIANT,$__g_Vector_VT_UNKNOWN,$__g_Vector_VT_DECIMAL,$__g_Vector_VT_I1=16,$__g_Vector_VT_UI1,$__g_Vector_VT_UI2,$__g_Vector_VT_UI4,$__g_Vector_VT_I8, _
    $__g_Vector_VT_UI8,$__g_Vector_VT_INT,$__g_Vector_VT_UINT,$__g_Vector_VT_VOID,$__g_Vector_VT_HRESULT,$__g_Vector_VT_PTR,$__g_Vector_VT_SAFEARRAY,$__g_Vector_VT_CARRAY,$__g_Vector_VT_USERDEFINED, _
    $__g_Vector_VT_LPSTR,$__g_Vector_VT_LPWSTR,$__g_Vector_VT_RECORD=36,$__g_Vector_VT_FILETIME=64,$__g_Vector_VT_BLOB,$__g_Vector_VT_STREAM,$__g_Vector_VT_STORAGE,$__g_Vector_VT_STREAMED_OBJECT, _
    $__g_Vector_VT_STORED_OBJECT,$__g_Vector_VT_BLOB_OBJECT,$__g_Vector_VT_CF,$__g_Vector_VT_CLSID,$__g_Vector_VT_BSTR_BLOB=0xfff,$__g_Vector_VT_VECTOR=0x1000, _
    $__g_Vector_VT_ARRAY=0x2000,$__g_Vector_VT_BYREF=0x4000,$__g_Vector_VT_RESERVED=0x8000,$__g_Vector_VT_ILLEGAL=0xffff,$__g_Vector_VT_ILLEGALMASKED=0xfff, _
    $__g_Vector_VT_TYPEMASK=0xfff

Global Const $__g_Vector_tagObject = "INT RefCount;INT cMethods;PTR Object;PTR Methods[7];UINT Size;UINT Capacity;PTR Data;"
Global Const $__g_Vector_tagDISPPARAMS = "ptr rgvargs;ptr rgdispidNamedArgs;dword cArgs;dword cNamedArgs;"

Func Vector()
    Local $tObject = DllStructCreate($__g_Vector_tagObject)

    Local Static $QueryInterface = DllCallbackRegister(__Vector_QueryInterface, "LONG", "ptr;ptr;ptr")
    DllStructSetData($tObject, "Methods", DllCallbackGetPtr($QueryInterface), 1)

    Local Static $AddRef = DllCallbackRegister(__Vector_AddRef, "dword", "PTR")
    DllStructSetData($tObject, "Methods", DllCallbackGetPtr($AddRef), 2)

    Local Static $Release = DllCallbackRegister(__Vector_Release, "dword", "PTR")
    DllStructSetData($tObject, "Methods", DllCallbackGetPtr($Release), 3)

    Local Static $GetTypeInfoCount = DllCallbackRegister(__Vector_GetTypeInfoCount, "long", "ptr;ptr")
    DllStructSetData($tObject, "Methods", DllCallbackGetPtr($GetTypeInfoCount), 4)

    Local Static $GetTypeInfo = DllCallbackRegister(__Vector_GetTypeInfo, "long", "ptr;uint;int;ptr")
    DllStructSetData($tObject, "Methods", DllCallbackGetPtr($GetTypeInfo), 5)

    Local Static $GetIDsOfNames = DllCallbackRegister(__Vector_GetIDsOfNames, "long", "ptr;ptr;ptr;uint;int;ptr")
    DllStructSetData($tObject, "Methods", DllCallbackGetPtr($GetIDsOfNames), 6)

    Local Static $Invoke = DllCallbackRegister(__Vector_Invoke, "long", "ptr;int;ptr;int;ushort;ptr;ptr;ptr;ptr")
    DllStructSetData($tObject, "Methods", DllCallbackGetPtr($Invoke), 7)

    DllStructSetData($tObject, "RefCount", 1) ; initial ref count is 1
    DllStructSetData($tObject, "cMethods", 7) ; number of interface methods

    $tObject = __Vector_DllStructAlloc($__g_Vector_tagObject, $tObject)

    DllStructSetData($tObject, "Object", DllStructGetPtr($tObject, "Methods")) ; Interface method pointers
    Return ObjCreateInterface(DllStructGetPtr($tObject, "Object"), $__g_Vector_IID_IDispatch, Default, True) ; pointer that's wrapped into object
EndFunc

#cs
# Queries a COM object for a pointer to one of its interface; identifying the interface by a reference to its interface identifier (IID). If the COM object implements the interface, then it returns a pointer to that interface after calling __Vector_AddRef on it.
# @internal
#ce
Func __Vector_QueryInterface($pSelf, $pRIID, $pObj)
    If $pObj=0 Then Return $__g_Vector_E_POINTER
    Local $sGUID=DllCall("ole32.dll", "int", "StringFromGUID2", "PTR", $pRIID, "wstr", "", "int", 40)[2]
    If (Not ($sGUID=$__g_Vector_IID_IDispatch)) And (Not ($sGUID=$__g_Vector_IID_IUnknown)) Then Return $__g_Vector_E_NOINTERFACE
    Local $tStruct = DllStructCreate("ptr", $pObj)
    DllStructSetData($tStruct, 1, $pSelf)
    __Vector_AddRef($pSelf)
    Return $__g_Vector_S_OK
EndFunc

#cs
# Increments the reference count for an interface pointer to a COM object. You should call this method whenever you make a copy of an interface pointer.
# @internal
#ce
Func __Vector_AddRef($pSelf)
    Local $tStruct = DllStructCreate("int Ref", $pSelf-8)
    $tStruct.Ref += 1
    Return $tStruct.Ref
EndFunc

#cs
# Decrements the reference count for an interface on a COM object.
# @internal
#ce
Func __Vector_Release($pSelf)
    Local $pObject = $pSelf-8
    Local $tObject = DllStructCreate($__g_Vector_tagObject, $pObject)
    $tObject.RefCount -= 1
    If $tObject.RefCount = 0 Then; initiate garbage collection
        ;releases all properties
        __Vector_resize($pObject, 0)
        __Vector_DllStructFree($tObject.Data)
        $tObject = Null
        __Vector_DllStructFree($pObject)
        If @error <> 0 And Not @Compiled Then ConsoleWriteError(StringFormat("ERROR: could not release object (%s)\n", $pSelf - 8))
        Return 0
    EndIf
    Return $tObject.RefCount
EndFunc

Global Enum $__g_Vector_Member_NULL, _
    $__g_Vector_Member_size, _
    $__g_Vector_Member_max_size, _
    $__g_Vector_Member_resize, _
    $__g_Vector_Member_capacity, _
    $__g_Vector_Member_empty, _
    $__g_Vector_Member_reserve, _
    $__g_Vector_Member_shrink_to_fit, _
    $__g_Vector_Member_at, _
    $__g_Vector_Member_front, _
    $__g_Vector_Member_back, _
    $__g_Vector_Member_data, _
    $__g_Vector_Member_assign, _
    $__g_Vector_Member_push_back, _
    $__g_Vector_Member_pop_back, _
    $__g_Vector_Member_insert, _
    $__g_Vector_Member_erase, _
    $__g_Vector_Member_swap, _
    $__g_Vector_Member_clear, _
    $__g_Vector_Member_NONE = -1

#cs
# Maps a single member and an optional set of argument names to a corresponding set of integer DISPIDs, which can be used on subsequent calls to __Vector_Invoke.
# @internal
#ce
Func __Vector_GetIDsOfNames($pSelf, $riid, $rgszNames, $cNames, $lcid, $rgDispId)
    Local $tDispId = DllStructCreate("long DispId;", $rgDispId)
    Local $pName = DllStructGetData(DllStructCreate("ptr", $rgszNames), 1)
    Local $sName = _WinAPI_GetString($pName, True)
    ;ConsoleWrite($sName&@CRLF);NOTE: for debugging

    Switch StringLower($sName)
        ;Capacity
        Case 'size'
            DllStructSetData($tDispId, "DispId", $__g_Vector_Member_size)
        Case 'max_size'
            DllStructSetData($tDispId, "DispId", $__g_Vector_Member_max_size)
        Case 'resize'
            DllStructSetData($tDispId, "DispId", $__g_Vector_Member_resize)
        Case 'capacity'
            DllStructSetData($tDispId, "DispId", $__g_Vector_Member_capacity)
        Case 'empty'
            DllStructSetData($tDispId, "DispId", $__g_Vector_Member_empty)
        Case 'reserve'
            DllStructSetData($tDispId, "DispId", $__g_Vector_Member_reserve)
        Case 'shrink_to_fit'
            DllStructSetData($tDispId, "DispId", $__g_Vector_Member_shrink_to_fit)

        ;Element access
        Case 'at'
            DllStructSetData($tDispId, "DispId", $__g_Vector_Member_at)
        Case 'front'
            DllStructSetData($tDispId, "DispId", $__g_Vector_Member_front)
        Case 'back'
            DllStructSetData($tDispId, "DispId", $__g_Vector_Member_back)
        Case 'data'
            DllStructSetData($tDispId, "DispId", $__g_Vector_Member_data)

        ;Modifiers
        Case 'assign'
            DllStructSetData($tDispId, "DispId", $__g_Vector_Member_assign)
        Case 'push_back'
            DllStructSetData($tDispId, "DispId", $__g_Vector_Member_push_back)
        Case 'pop_back'
            DllStructSetData($tDispId, "DispId", $__g_Vector_Member_pop_back)
        Case 'insert'
            DllStructSetData($tDispId, "DispId", $__g_Vector_Member_insert)
        Case 'erase'
            DllStructSetData($tDispId, "DispId", $__g_Vector_Member_erase)
        Case 'swap'
            DllStructSetData($tDispId, "DispId", $__g_Vector_Member_swap)
        Case 'clear'
            DllStructSetData($tDispId, "DispId", $__g_Vector_Member_clear)

        Case Else
            DllStructSetData($tDispId, "DispId", $__g_Vector_Member_NONE)
            Return $__g_Vector_DISP_E_UNKNOWNNAME
    EndSwitch
    Return $__g_Vector_S_OK
EndFunc

#cs
# Retrieves the type information for an object, which can then be used to get the type information for an interface.
# @internal
#ce
Func __Vector_GetTypeInfo($pSelf, $iTInfo, $lcid, $ppTInfo)
    If $iTInfo<>0 Then Return $__g_Vector_DISP_E_BADINDEX
    If $ppTInfo=0 Then Return $__g_Vector_E_INVALIDARG
    Return $__g_Vector_S_OK
EndFunc

#cs
# Retrieves the number of type information interfaces that an object provides (either 0 or 1).
# @internal
#ce
Func __Vector_GetTypeInfoCount($pSelf, $pctinfo)
    DllStructSetData(DllStructCreate("UINT",$pctinfo), 1, 0)
    Return $__g_Vector_S_OK
EndFunc

#cs
# Provides access to properties and methods exposed by an object.
# @internal
#ce
Func __Vector_Invoke($pSelf, $dispIdMember, $riid, $lcid, $wFlags, $pDispParams, $pVarResult, $pExcepInfo, $puArgErr)
    If $dispIdMember = -1 Then Return $__g_Vector_DISP_E_MEMBERNOTFOUND

    If $dispIdMember = 0 Then Return $__g_Vector_S_OK

    Switch $dispIdMember
        Case $__g_Vector_Member_size
            Return __Vector_Member_size($pSelf, $dispIdMember, $riid, $lcid, $wFlags, $pDispParams, $pVarResult, $pExcepInfo, $puArgErr)
        Case $__g_Vector_Member_max_size
            Return __Vector_Member_max_size($pSelf, $dispIdMember, $riid, $lcid, $wFlags, $pDispParams, $pVarResult, $pExcepInfo, $puArgErr)
        Case $__g_Vector_Member_resize
            Return __Vector_Member_resize($pSelf, $dispIdMember, $riid, $lcid, $wFlags, $pDispParams, $pVarResult, $pExcepInfo, $puArgErr)
        Case $__g_Vector_Member_capacity
            Return __Vector_Member_capacity($pSelf, $dispIdMember, $riid, $lcid, $wFlags, $pDispParams, $pVarResult, $pExcepInfo, $puArgErr)
        Case $__g_Vector_Member_empty
            Return __Vector_Member_empty($pSelf, $dispIdMember, $riid, $lcid, $wFlags, $pDispParams, $pVarResult, $pExcepInfo, $puArgErr)
        Case $__g_Vector_Member_reserve
            Return __Vector_Member_reserve($pSelf, $dispIdMember, $riid, $lcid, $wFlags, $pDispParams, $pVarResult, $pExcepInfo, $puArgErr)
        Case $__g_Vector_Member_shrink_to_fit
            Return __Vector_Member_shrink_to_fit($pSelf, $dispIdMember, $riid, $lcid, $wFlags, $pDispParams, $pVarResult, $pExcepInfo, $puArgErr)

        Case $__g_Vector_Member_at
            Return __Vector_Member_at($pSelf, $dispIdMember, $riid, $lcid, $wFlags, $pDispParams, $pVarResult, $pExcepInfo, $puArgErr)
        ;Case $__g_Vector_Member_front
        ;    Return __Vector_Member_front($pSelf, $dispIdMember, $riid, $lcid, $wFlags, $pDispParams, $pVarResult, $pExcepInfo, $puArgErr)
        ;Case $__g_Vector_Member_back
        ;    Return __Vector_Member_back($pSelf, $dispIdMember, $riid, $lcid, $wFlags, $pDispParams, $pVarResult, $pExcepInfo, $puArgErr)
        ;Case $__g_Vector_Member_data
        ;    Return __Vector_Member_data($pSelf, $dispIdMember, $riid, $lcid, $wFlags, $pDispParams, $pVarResult, $pExcepInfo, $puArgErr)

        ;Case $__g_Vector_Member_assign
        ;    Return __Vector_Member_assign($pSelf, $dispIdMember, $riid, $lcid, $wFlags, $pDispParams, $pVarResult, $pExcepInfo, $puArgErr)
        ;Case $__g_Vector_Member_push_back
        ;    Return __Vector_Member_push_back($pSelf, $dispIdMember, $riid, $lcid, $wFlags, $pDispParams, $pVarResult, $pExcepInfo, $puArgErr)
        ;Case $__g_Vector_Member_pop_back
        ;    Return __Vector_Member_pop_back($pSelf, $dispIdMember, $riid, $lcid, $wFlags, $pDispParams, $pVarResult, $pExcepInfo, $puArgErr)
        ;Case $__g_Vector_Member_insert
        ;    Return __Vector_Member_insert($pSelf, $dispIdMember, $riid, $lcid, $wFlags, $pDispParams, $pVarResult, $pExcepInfo, $puArgErr)
        ;Case $__g_Vector_Member_erase
        ;    Return __Vector_Member_erase($pSelf, $dispIdMember, $riid, $lcid, $wFlags, $pDispParams, $pVarResult, $pExcepInfo, $puArgErr)
        ;Case $__g_Vector_Member_swap
        ;    Return __Vector_Member_swap($pSelf, $dispIdMember, $riid, $lcid, $wFlags, $pDispParams, $pVarResult, $pExcepInfo, $puArgErr)
        ;Case $__g_Vector_Member_clear
        ;    Return __Vector_Member_clear($pSelf, $dispIdMember, $riid, $lcid, $wFlags, $pDispParams, $pVarResult, $pExcepInfo, $puArgErr)
        ;Case $__g_Vector_Member_NONE
        ;    ContinueCase
        Case Else
            Return $__g_Vector_DISP_E_MEMBERNOTFOUND
    EndSwitch
EndFunc

#cs
# Allocate DllStruct memory
# @internal
# @param string         $sStruct
# @param DllStruct|null $tStruct
# @return DllStruct
#ce
Func __Vector_DllStructAlloc($sStruct, $tStruct = Null)
    If Not IsDllStruct($tStruct) Then $tStruct = DllStructCreate($sStruct)
    If @error <> 0 Then Return SetError(@error, @extended, 0)
    Local $iStruct = DllStructGetSize($tStruct)
    Local $hStruct = _MemGlobalAlloc($iStruct, $GMEM_MOVEABLE)
    Local $pStruct = _MemGlobalLock($hStruct)
    _MemMoveMemory(DllStructGetPtr($tStruct), $pStruct, $iStruct)
    Return DllStructCreate($sStruct, $pStruct)
EndFunc

#cs
# Free DllStruct memory
# @internal
# @param ptr $pStruct
# @return bool
#ce
Func __Vector_DllStructFree($pStruct)
    If IsDllStruct($pStruct) Then $pStruct = DllStructGetPtr($pStruct)
    Local $aRet = DllCall("Kernel32.dll", "ptr", "GlobalHandle", "ptr", $pStruct)
    If @error <> 0 Or $aRet[0] = 0 Then Return SetError(@error, @extended, False)
    Local $hMemory = _MemGlobalFree($aRet[1])
    if $hMemory <> 0 Then SetError(-1, 0, False)
    Return True
EndFunc

Func __Vector_Flags_HasFlag($wFlags, $wFlag)
    Return BitAND($wFlags, $wFlag) = $wFlag
EndFunc

Func __Vector_Member_size($pSelf, $dispIdMember, $riid, $lcid, $wFlags, $pDispParams, $pVarResult, $pExcepInfo, $puArgErr)
    If Not __Vector_Flags_HasFlag($wFlags, $__g_Vector_DISPATCH_PROPERTYGET) Then Return $__g_Vector_DISP_E_EXCEPTION;TODO: create exception object?
    Local $tDispParams = DllStructCreate($__g_Vector_tagDISPPARAMS, $pDispParams)
    If $tDispParams.cArgs <> 0 Then Return $__g_Vector_DISP_E_BADPARAMCOUNT
    Local $pObject = $pSelf-8
    $tVariant = DllStructCreate($__g_Vector_tagVARIANT, $pVarResult)
    $tVariant.vt = $__g_Vector_VT_UI4
    DllStructSetData(DllStructCreate("UINT", DllStructGetPtr($tVariant, "data")), 1, __Vector_size($pObject))
    Return $__g_Vector_S_OK
EndFunc

Func __Vector_size($vObject)
    Local $tObject = IsDllStruct($vObject) ? $vObject : DllStructCreate($__g_Vector_tagObject, $vObject)
    Return $tObject.Size
EndFunc

Func __Vector_Member_resize($pSelf, $dispIdMember, $riid, $lcid, $wFlags, $pDispParams, $pVarResult, $pExcepInfo, $puArgErr)
    Local $pObject = $pSelf-8
    Local $tDispParams = DllStructCreate($__g_Vector_tagDISPPARAMS, $pDispParams)
    Local $cArgs = $tDispParams.cArgs
    If $cArgs <> 1 Then Return $__g_Vector_DISP_E_BADPARAMCOUNT
    Local $tVariant = DllStructCreate($__g_Vector_tagVARIANT, $tDispParams.rgvargs)
    If Not $tVariant.vt = $__g_Vector_VT_I4 Then
        $tuArgErr = DllStructCreate("UINT", $puArgErr)
        DllStructSetData($tuArgErr, 1, 1)
        Return $__g_Vector_DISP_E_TYPEMISMATCH
    EndIf
    Local $iNewSize = DllStructGetData(DllStructCreate('INT', DllStructGetPtr($tVariant, 'data')), 1)
    __Vector_resize($pObject, $iNewSize)
    Return $__g_Vector_S_OK
EndFunc

Func __Vector_resize($vObject, $iNewSize)
    Local $tObject = IsDllStruct($vObject) ? $vObject : DllStructCreate($__g_Vector_tagObject, $vObject)
    Local $iSize = $tObject.Size
    Local $tData = DllStructCreate(StringFormat("PTR[%d]", $iSize), $tObject.Data)
    If $iNewSize < $iSize Then
        For $i = $iSize To $iNewSize + 1 Step -1
            If __Vector_VariantClear(DllStructGetData($tData, 1, $i)) <> $__g_Vector_S_OK Then Return SetError(1, 0, Null)
            __Vector_DllStructFree(DllStructGetData($tData, 1, $i))
        Next
    ElseIf $iNewSize > $iSize Then
        If $iNewSize > $tObject.Capacity Then __Vector_reserve($vObject, $iNewSize);FIXME: check what the expected new capacity should be.
        ;If @error <> 0 Then Return $__g_Vector_DISP_E_EXCEPTION;TODO: create exception object?
        If @error <> 0 Then Return SetError(@error, @extended, Null)
        $tData = DllStructCreate(StringFormat("PTR[%d]", $iNewSize), $tObject.Data)
        For $i = $iSize + 1 To $iNewSize Step +1
            Local $tVARIANT = __Vector_DllStructAlloc($__g_Vector_tagVARIANT)
            __Vector_VariantInit($tVARIANT)
            DllStructSetData($tData, 1, DllStructGetPtr($tVARIANT), $i)
        Next
    EndIf
    $tObject.Size = $iNewSize
EndFunc

Func __Vector_Member_reserve($pSelf, $dispIdMember, $riid, $lcid, $wFlags, $pDispParams, $pVarResult, $pExcepInfo, $puArgErr)
    Local $pObject = $pSelf-8
    Local $tDispParams = DllStructCreate($__g_Vector_tagDISPPARAMS, $pDispParams)
    Local $cArgs = $tDispParams.cArgs
    If $cArgs <> 1 Then Return $__g_Vector_DISP_E_BADPARAMCOUNT
    Local $tVariant = DllStructCreate($__g_Vector_tagVARIANT, $tDispParams.rgvargs)
    If Not $tVariant.vt = $__g_Vector_VT_I4 Then
        $tuArgErr = DllStructCreate("UINT", $puArgErr)
        DllStructSetData($tuArgErr, 1, 1)
        Return $__g_Vector_DISP_E_TYPEMISMATCH
    EndIf
    Local $iNewCapacity = DllStructGetData(DllStructCreate('INT', DllStructGetPtr($tVariant, 'data')), 1)
    __Vector_reserve($pObject, $iNewCapacity)
    Return $__g_Vector_S_OK
EndFunc

Func __Vector_reserve($vObject, $iNewCapacity)
    Local $tObject = IsDllStruct($vObject) ? $vObject : DllStructCreate($__g_Vector_tagObject, $vObject)
    Local $iCapacity = $tObject.Capacity
    If $iNewCapacity < $iCapacity Then
        If $iNewCapacity < $tObject.Size Then __Vector_resize($vObject, $iNewCapacity)
        If @error <> 0 Then Return SetError(@error, @extended, Null)
    ElseIf $iNewCapacity = $iCapacity Then
        ;we change nothing
        Return Null
    EndIf
    $tData = __Vector_DllStructAlloc(StringFormat("PTR[%d]", $iNewCapacity))
    $pData = $tObject.Data
    If Not ($pData = 0) Then
        _MemMoveMemory($pData, DllStructGetPtr($tData), DllStructGetSize(DllStructCreate(StringFormat("PTR[%d]", $iNewCapacity < $iCapacity ? $iNewCapacity : $iCapacity))))
        __Vector_DllStructFree($pData)
    EndIf
    $tObject.Data = DllStructGetPtr($tData)
    $tObject.Capacity = $iNewCapacity
EndFunc

Func __Vector_VariantInit($pvarg)
    Return DllCall("OleAut32.dll", "NONE", "VariantInit", IsDllStruct($pvarg) ? "STRUCT*" : "PTR", $pvarg)[1]
EndFunc

Func __Vector_VariantClear($pVARIANT)
    Return DllCall("OleAut32.dll", "LONG", "VariantClear", "PTR", $pVARIANT)[0]
EndFunc

Func __Vector_VariantCopy()
    ;FIXME
EndFunc
