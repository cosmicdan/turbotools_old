; Name...........: __ArrayAdd
; Description ...: Adds a specified value or row at the end of an existing 1D or 2D array.
; Syntax.........: __ArrayAdd(ByRef $avArray, $vValue [, $NestArray = True])
; Parameters ....: $avArray - Array to modify ByRef
;                  $vValue  - Value to add, can be a 1D array if $avArray = 2D and $NestArray = False
;                  $NestArray - Optional flag if False causes array passed as $vValue to be interpreted as a 1D array
;                               of values to place in a single new row of a 2D array.  Default = True, saves array as
;                               a single element.  This flag is ignored if $avArray is 1D or $vValue is not an array.
; Return values .: Success - Index of last added item
;                  Failure - -1, sets @error to 1, and sets @extended to specify failure (see code below)
; Author ........: Jos van der Zande <jdeb at autoitscript dot com>
; Modified.......: Ultima - code cleanup
;              ; PsaltyDS - Array and 2D $vValue inputs added
; Remarks .......: Each call to this function adds exactly one new row to $avArray.  To add more rows use _ArrayConcatenate.
; Related .......: _ArrayConcatenate, _ArrayDelete, _ArrayInsert, _ArrayPop, _ArrayPush
; Link ..........;
; Example .......; Yes
; ====================================================================================================

Func __ArrayAdd(ByRef $avArray, $vValue, $NestArray = True)
    Local $iBoundArray0, $iBoundArray1, $iBoundArray2, $iBoundValue1

    If IsArray($avArray) = 0 Then Return SetError(1, 0, -1); $avArray is not an array

    $iBoundArray0 = UBound($avArray, 0); No. of dimesions in array
    If $iBoundArray0 > 2 Then Return SetError(1, 1, -1); $avArray is more than 2D

    $iBoundArray1 = UBound($avArray, 1); Size of array in first dimension
    If $iBoundArray0 = 2 Then $iBoundArray2 = UBound($avArray, 2); Size of array in second dimension

    If ($iBoundArray0 = 1) Or (IsArray($vValue) = 0) Or $NestArray Then
; If input array is 1D, or $vValue is not an array, or $NestArray = True (default) then save $vValue literally
        If $iBoundArray0 = 1 Then
    ; Add to 1D array
            ReDim $avArray[$iBoundArray1 + 1]
            $avArray[$iBoundArray1] = $vValue
        Else
    ; Add to 2D array at [n][0]
            ReDim $avArray[$iBoundArray1 + 1][$iBoundArray2]
            $avArray[$iBoundArray1][0] = $vValue
        EndIf
    Else
; If input array is 2D, and $vValue is an array, and $NestArray = False,
;   then $vValue is a 1D array of values to add as a new row.
        If UBound($vValue, 0) <> 1 Then Return SetError(1, 2, -1); $vValue array is not 1D
        $iBoundValue1 = UBound($vValue, 1)
        If $iBoundArray2 < $iBoundValue1 Then Return SetError(1, 3, -1); $vValue array has too many elements
        ReDim $avArray[$iBoundArray1 + 1][$iBoundArray2]
        For $n = 0 To $iBoundValue1 - 1
            $avArray[$iBoundArray1][$n] = $vValue[$n]
        Next
    EndIf

; Return index of new last row in $avArray
    Return $iBoundArray1
EndFunc ;==>__ArrayAdd