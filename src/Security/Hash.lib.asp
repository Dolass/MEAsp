<SCRIPT Runat="Server" Language="VBScript">

Lib.Require("util.math")

Public Function SimpleHash(pText)
    Dim i, vCount, vMax, Result
    vMax = 2 ^ 30
    Result = 0
    vCount = Len(pText)
    For i = 1 To vCount
        If Result > vMax Then
            Result = Result - vMax
            Result = Result * 2
            Result = Result Or 1
        Else
            Result = Result * 2
        End If
        Result = Result Xor AscW(Mid(pText, i, 1))
    Next
    If Result = 0 Then
        Result = 1
    End If
    SimpleHash = Result
End Function

' for english string only
Function SimpleDecodeEn(ByVal encryptedstring)
	Dim x, i, tmp
	encryptedstring = StrReverse(encryptedstring)
	For i = 1 To Len( encryptedstring )
		x = Mid( encryptedstring, i, 1 )
		tmp = tmp & Chr( Asc( x ) - 1 )
	Next
	SimpleDecodeEn = tmp
End Function

Function SimpleEncodeEn(ByVal string)
	Dim x, i, tmp
	For i = 1 To Len( string )
		x = Mid( string, i, 1 )
		tmp = tmp & Chr( Asc( x ) + 1 )
	Next
	tmp = StrReverse( tmp )
	SimpleEncodeEn = tmp
End Function


    '**************************************
    ' Name: CRC Checksum
    ' Description:Calculates the CRC for a given string.
    ' By: Leigh Bowers
    '
    ' Returns:A long representing the CRC checksum.
    '
    ' Assumes:Example Usage:
    'Response.Write "$" + Hex(CalculateCRC("http://www.curvesoftware.co.uk"))
    '
    
private function shr(plValue, pbBits)
    ' Shift bits to the right by <pbBits>
    shr = plValue \ cPower2Table(pbBits)'(2 ^ pbBits)
    'writeln (2 ^ pbBits)
    'writeln cPower2Table(pbBits)
End function

function CalculateCRC(psString)
    Dim sValues, alCRCTable, lCRC, sCRCTable
    Dim l
sCRCTable = "&h0,&h77073096,&hEE0E612C,&h990951BA,&h076DC419,&h706AF48F,&hE963A535,&h9E6495A3,&h0EDB8832,&h79DCB8A4,&hE0D5E91E,&h97D2D988,&h09B64C2B,&h7EB17CBD,&hE7B82D07,&h90BF1D91,&h1DB71064,&h6AB020F2,&hF3B97148,&h84BE41DE,&h1ADAD47D,&h6DDDE4EB,&hF4D4B551,&h83D385C7,&h136C9856,&h646BA8C0,&hFD62F97A,&h8A65C9EC,&h14015C4F,&h63066CD9,&hFA0F3D63,&h8D080DF5,&h3B6E20C8,&h4C69105E,&hD56041E4,&hA2677172,&h3C03E4D1,&h4B04D447," _
    		+ "&hD20D85FD,&hA50AB56B,&h35B5A8FA,&h42B2986C,&hDBBBC9D6,&hACBCF940,&h32D86CE3,&h45DF5C75,&hDCD60DCF,&hABD13D59,&h26D930AC,&h51DE003A,&hC8D75180,&hBFD06116,&h21B4F4B5,&h56B3C423,&hCFBA9599,&hB8BDA50F,&h2802B89E,&h5F058808,&hC60CD9B2,&hB10BE924,&h2F6F7C87,&h58684C11,&hC1611DAB,&hB6662D3D,&h76DC4190,&h01DB7106,&h98D220BC,&hEFD5102A,&h71B18589,&h06B6B51F,&h9FBFE4A5,&hE8B8D433,&h7807C9A2,&h0F00F934,&h9609A88E,&hE10E9818," _
    		+ "&h7F6A0DBB,&h086D3D2D,&h91646C97,&hE6635C01,&h6B6B51F4,&h1C6C6162,&h856530D8,&hF262004E,&h6C0695ED,&h1B01A57B,&h8208F4C1,&hF50FC457,&h65B0D9C6,&h12B7E950,&h8BBEB8EA,&hFCB9887C,&h62DD1DDF,&h15DA2D49,&h8CD37CF3,&hFBD44C65,&h4DB26158,&h3AB551CE,&hA3BC0074,&hD4BB30E2,&h4ADFA541,&h3DD895D7,&hA4D1C46D,&hD3D6F4FB,&h4369E96A,&h346ED9FC,&hAD678846,&hDA60B8D0,&h44042D73,&h33031DE5,&hAA0A4C5F,&hDD0D7CC9,&h5005713C,&h270241AA," _
    		+ "&hBE0B1010,&hC90C2086,&h5768B525,&h206F85B3,&hB966D409,&hCE61E49F,&h5EDEF90E,&h29D9C998,&hB0D09822,&hC7D7A8B4,&h59B33D17,&h2EB40D81,&hB7BD5C3B,&hC0BA6CAD,&hEDB88320,&h9ABFB3B6,&h03B6E20C,&h74B1D29A,&hEAD54739,&h9DD277AF,&h04DB2615,&h73DC1683,&hE3630B12,&h94643B84,&h0D6D6A3E,&h7A6A5AA8,&hE40ECF0B,&h9309FF9D,&h0A00AE27,&h7D079EB1,&hF00F9344,&h8708A3D2,&h1E01F268,&h6906C2FE,&hF762575D,&h806567CB,&h196C3671,&h6E6B06E7," _
    		+ "&hFED41B76,&h89D32BE0,&h10DA7A5A,&h67DD4ACC,&hF9B9DF6F,&h8EBEEFF9,&h17B7BE43,&h60B08ED5,&hD6D6A3E8,&hA1D1937E,&h38D8C2C4,&h4FDFF252,&hD1BB67F1,&hA6BC5767,&h3FB506DD,&h48B2364B,&hD80D2BDA,&hAF0A1B4C,&h36034AF6,&h41047A60,&hDF60EFC3,&hA867DF55,&h316E8EEF,&h4669BE79,&hCB61B38C,&hBC66831A,&h256FD2A0,&h5268E236,&hCC0C7795,&hBB0B4703,&h220216B9,&h5505262F,&hC5BA3BBE,&hB2BD0B28,&h2BB45A92,&h5CB36A04,&hC2D7FFA7,&hB5D0CF31," _
    		+ "&h2CD99E8B,&h5BDEAE1D,&h9B64C2B0,&hEC63F226,&h756AA39C,&h026D930A,&h9C0906A9,&hEB0E363F,&h72076785,&h05005713,&h95BF4A82,&hE2B87A14,&h7BB12BAE,&h0CB61B38,&h92D28E9B,&hE5D5BE0D,&h7CDCEFB7,&h0BDBDF21,&h86D3D2D4,&hF1D4E242,&h68DDB3F8,&h1FDA836E,&h81BE16CD,&hF6B9265B,&h6FB077E1,&h18B74777,&h88085AE6,&hFF0F6A70,&h66063BCA,&h11010B5C,&h8F659EFF,&hF862AE69,&h616BFFD3,&h166CCF45,&hA00AE278,&hD70DD2EE,&h4E048354,&h3903B3C2," _
    		+ "&hA7672661,&hD06016F7,&h4969474D,&h3E6E77DB,&hAED16A4A,&hD9D65ADC,&h40DF0B66,&h37D83BF0,&hA9BCAE53,&hDEBB9EC5,&h47B2CF7F,&h30B5FFE9,&hBDBDF21C,&hCABAC28A,&h53B39330,&h24B4A3A6,&hBAD03605,&hCDD70693,&h54DE5729,&h23D967BF,&hB3667A2E,&hC4614AB8,&h5D681B02,&h2A6F2B94,&hB40BBE37,&hC30C8EA1,&h5A05DF1B,&h2D02EF8D"
    	alCRCTable = Split(sCRCTable, ",")
    	lCRC = &hFFFFFFFF
    	For l = 1 To Len(psString)
    		lCRC = alCRCTable(((lCRC And &hFFFF) Xor Asc(Mid(psString, l, 1))) And &hFF) Xor shr(lCRC, 8)
    	Next ' l
    	lCRC = lCRC Xor &hFFFFFFFF
    	
    	CalculateCRC = lCRC
    End function
</SCRIPT>

