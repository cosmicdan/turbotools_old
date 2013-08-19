; Version: 3.0

Global Const $pZip_dll = @ScriptDir & '\pZip.dll'

; #FUNCTION# =====================================================================
; Name...........: _zip_FileInfo
; Description....: Get file information from all files in current archive.
; Syntax.........: _zip_FileInfo($sFile)
; Parameters.....: $sFile - The path of the archive.
; Return values..: The array that contains the following information.
;
;                      [0][0] = Number of entries
;                      [n][0] - nth Filename.
;                      [n][1] - nth Compressed Size
;                      [n][2] - nth Uncompressed Size
;                      [n][3] - nth Last Modification Date (YYYY/MM/DD HH:MM:SS)
;                      [n][4] - nth Crc32
;                      [n][5] - nth Compression Method (see information to _zip_AddFiles)
;                      [n][6] - nth Flag Encrypted
;
; Author.........: asdf8
; ================================================================================
Func _zip_FileInfo($sFile)
    Local $ret[1][7], $res, $tmp, $i, $j
    If Not $sFile Or Not FileExists($sFile) Then Return SetError(1, 0, $ret)
    $res = DllCall($pZip_dll, 'str', 'pZIP_FileInfo', 'str', $sFile)
    If Not IsArray($res) Then Return SetError(2, 0, $ret)
    If $res[0] Then
        $res = StringRegExp($res[0], '([^|]+)', 3)
        ReDim $ret[UBound($res) + 1][7]
        $ret[0][0] = UBound($res)
        $ret[0][1] = 'Compressed Size'
        $ret[0][2] = 'Uncompressed Size'
        $ret[0][3] = 'Date'
        $ret[0][4] = 'Crc32'
        $ret[0][5] = 'Compression Method'
        $ret[0][6] = 'Flag Encrypted'
        For $i = 1 To $ret[0][0]
            $tmp = StringSplit($res[$i - 1], '*', 2)
            For $j = 0 To 6
                $ret[$i][$j] = $tmp[$j]
            Next
        Next
    EndIf
    Return SetError(0, 0, $ret)
EndFunc


; #FUNCTION# =====================================================================
; Name...........: _zip_FindFile
; Description....: Find file in archive.
; Syntax.........: _zip_FindFile($sFile, $FindName[, $IncludingPath = 1])
; Parameters.....: $sFile - The path of the archive.
;                  $FindName - The filename to find.
;                  $IncludingPath - 0  search only for filename.
;                                   1  (default), search for path + filename.
; Return values..: Success    - The array file info.
;
;                      [0] - nth Filename.
;                      [1] - nth Compressed Size
;                      [2] - nth Uncompressed Size
;                      [3] - nth Last Modification Date (YYYY/MM/DD HH:MM:SS)
;                      [4] - nth Crc32
;                      [5] - nth Compression Method (see information to _zip_AddFiles)
;                      [6] - nth Flag Encrypted
;
;                  Failure    - (-1) if not found.
; Author.........: asdf8
; ================================================================================
Func _zip_FindFile($sFile, $FindName, $IncludingPath = 1)
    If Not $sFile Or Not FileExists($sFile) Or Not  $FindName Then Return SetError(1, 0, -1)
    Local $res = DllCall($pZip_dll, 'str', 'pZIP_FindFile', 'str', $sFile, 'str', $FindName, 'int', $IncludingPath)
    If Not IsArray($res) Then Return SetError(2, 0, -1)
    If $res[0] Then
        $res = StringSplit($res[0], '*', 2)
        Return SetError(0, 0, $res)
    Else
        Return SetError(0, 0, -1)
    EndIf
EndFunc


; #FUNCTION# =====================================================================
; Name...........: _zip_AddFiles
; Description....: Add files to archive.
; Syntax.........: _zip_AddFiles($sFile, $inpBaseDir[, $FileMask = ""[, $PathMask = ""[, $StoreRelPath = 1[, $Recursive = 1[, $CompressMethod = 8[, $Password = ""]]]]]])
; Parameters.....: $sFile        - The path of the archive.
;                  $inpBaseDir   - Input base directory.
;                  $FileMask     - File mask supports wildcards, e.g. "*.*" or "?file*.txt"
;                  $PathMask     - Path mask not supports wildcards, e.g. "Dir1" or "Dir1\Dir2\Dir3"
;                  $StoreRelPath - 0  Store Only filename.
;                                  1  (default), store path relative basedir.
;                  $Recursive    - 0  no recursive search.
;                                  1  (default), recursive file search.
;                  $CompressMethod - Compression Method:
;                                  0  - The file is stored (no compression)
;                                  1  - The file is Shrunk
;                                  2  - The file is Reduced with compression factor 1
;                                  3  - The file is Reduced with compression factor 2
;                                  4  - The file is Reduced with compression factor 3
;                                  5  - The file is Reduced with compression factor 4
;                                  6  - The file is Imploded
;                                  7  - Reserved for Tokenizing compression algorithm
;                                  8  - The file is Deflated
;                                  9  - Reserved for enhanced Deflating
;                                  10 - PKWARE Date Compression Library Imploding
;                  $Password - Set current archive password.
;
; Return values..: Number of added files.
;                  If failure repacking the encrypted file (wrong password) -  set error @error = 3.
; Author.........: asdf8
; ================================================================================
Func _zip_AddFiles($sFile, $inpBaseDir, $FileMask = "", $PathMask = "", $StoreRelPath = 1, $Recursive = 1, $CompressMethod = 8, $Password = "")
    If Not $sFile Or Not $inpBaseDir Or Not FileExists($inpBaseDir & "\")  Then Return SetError(1, 0, 0)
    If $PathMask Then
        If StringRight($PathMask, 1) = "\" Then $PathMask = StringTrimRight($PathMask, 1)
        If StringLeft($PathMask, 1) = "\" Then $PathMask = StringTrimLeft($PathMask, 1)
        If $PathMask Then $FileMask = $PathMask & "\" & $FileMask
    EndIf
    Local $res = DllCall($pZip_dll, 'int', 'pZIP_AddFiles', 'str', $sFile, 'str', $inpBaseDir, 'str', $FileMask, 'int', $StoreRelPath, 'int', $Recursive, 'int', $CompressMethod, 'str', $Password)
    If Not IsArray($res) Then Return SetError(2, 0, -1)
    If $res[0] < 0 Then
        Return SetError(3, 0, 0)
    Else
        Return SetError(0, 0, $res[0])
    EndIf
EndFunc


; #FUNCTION# =====================================================================
; Name...........: _zip_ExtractFiles
; Description....: Extract files from archive.
; Syntax.........: _zip_ExtractFiles($sFile, $OutputPath[, $FileMask = ""[, $PathMask = ""[, $IncludingPath = 1[, $Password = ""]]]])
; Parameters.....: $sFile         - The path of the archive.
;                  $OutputPath    - Output path.
;                  $FileMask      - File mask supports wildcards, e.g. "*.*" or "?file*.txt"
;                  $PathMask      - Path mask not supports wildcards, e.g. "Dir1" or "Dir1\Dir2\Dir3"
;                  $IncludingPath - 0  only filename is extracted.
;                                   1  (default), the complete filename (including path) is extracted.
;                  $Password      - Set current archive password.
;
; Return values..: Number of extracted files.
;                  If the encrypted files is not extracted (wrong password) - returns the number of extracted files and set error @error = 3.
; Author.........: asdf8
; ================================================================================
Func _zip_ExtractFiles($sFile, $OutputPath, $FileMask = "", $PathMask = "", $IncludingPath = 1, $Password = "")
    If Not $sFile Or Not FileExists($sFile) Or Not  $OutputPath Then Return SetError(1, 0, 0)
    If $PathMask Then
        If StringRight($PathMask, 1) = "\" Then $PathMask = StringTrimRight($PathMask, 1)
        If StringLeft($PathMask, 1) = "\" Then $PathMask = StringTrimLeft($PathMask, 1)
        If $PathMask Then $FileMask = $PathMask & "\" & $FileMask
    EndIf
    Local $res = DllCall($pZip_dll, 'int', 'pZIP_ExtractFiles', 'str', $sFile, 'str', $OutputPath, 'str', $FileMask, 'int', $IncludingPath, 'str', $Password)
    If Not IsArray($res) Then Return SetError(2, 0, 0)
    If $res[0] < 0 Then
        $res[0] = (-1) * ($res[0] + 1)
        Return SetError(3, 0, $res[0])
    Else
        Return SetError(0, 0, $res[0])
    EndIf
EndFunc
