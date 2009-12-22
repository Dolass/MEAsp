<SCRIPT Runat="Server" Language="VBScript">

' ---------------------------------------------------------------------------
'      $Source: /home/cvs/MeCMS/src/lang/object.lib.asp,v $
'      $Revision: 1.4 $
'      $Author: riceball $
' ---------------------------------------------------------------------------

Public Const ftString     = &H10
Public Const ftPassword   = &H12
Public Const ftMemo       = &H13
Public Const ftMemoRTF    = &H14

Public Const ftInteger  = &H20
Public Const ftFloat    = &H21
Public Const ftCurreny  = &H22
Public Const ftDateTime = &H23
Public Const ftDate     = &H24
Public Const ftTime     = &H25
Public Const ftBoolean  = &H26

Public Const ftURL      = &H30
Public Const ftEmailURL = &H31
Public Const ftImageURL = &H32
Public Const ftFlashURL = &H33
Public Const ftSoundURL = &H34

Public Const ftObject     = &H40
Public Const ftCollection = &H41 ' the collection object MUST have ClassName, Items(i), Add(Value) and Count !! the first i is 0!

' the object status constants
Public Const osInit   = 0
Public Const osLoaded = 1 ' already fetched from database

Class TMeMetaObject
    ' �����������ָʾ����һ��������� MetaInfo.
    Public  ClassName
    Private FFields

    Private Sub Class_Initialize()
        Set FFields = New TMeMetaFields
    End Sub

    Private Sub Class_Terminate()
        Set FFields = Nothing
    End Sub

    '�����б����
    Public Property Get Fields()
        Set Fields = FFields
    End Property

    '����ָ�������������Զ���
    Public Default Property Get FieldByName(ByRef aFieldName)
        Set FieldByName = FFields.FieldByName(aFieldName)
    End Property

    '�������ԣ������������Զ���
    Public Function AddField()
        Dim Result
        Set Result = New TMeMetaField
        if FFields.Add(Result) < 0 then
          Set Result = Nothing
        end if
        Set AddField = Result
    End Function

     '���ַ�������������������ԡ��ַ�����ʽ�� "������:��������[:Size:Validator:Constraints:Required:Confirmed:Filters],..." 
     '����֮���ö��š�,���ָ����������������������֮����ð�š�:���ָ�������֮�䲻���пո�,������ַ������������š�
     'ʾ���� "Id:ftString:32:true:false:""the Validator"":""the Constraints"":"the filters",Password:ftPassword:32:true:true"
    Public Sub AssignFieldsFromString(ByRef aText)
      Dim i, vFields
      vFields = Split(aText, ",")
      FFields.Clear
      For i = 0 to UBound(vFields)
        FFields.Append(vFields[i])
      Next
    End Sub

End Class

'MetaInfo �������ֶ��б���
Class TMeMetaFields
    Private FList

    Private Sub Class_Initialize()
      Set FList = New TMeList
    End Sub

    Private Sub Class_Terminate()
      Set FList = Nothing
    End Sub

    '�ֶ��б��������0��(Count-1)
    Public Default Property Get Items(ByRef Index)
      Set Items = FList(Index)
    End Property

    '�����ֶ��������ֶ����Զ���
    Public Property Get FieldByName(ByRef aFieldName)
        Dim i, Result
        For i = 0 to FList.Count - 1
          Set Result = FList(i)
          if Result.Name = aFieldName then Set FieldByName = Result : Exit Property
        Next 'i
        Set FieldByName = Nothing
    End Property

    Public Function IndexOf(ByRef aFieldName)
        Dim i
        For i = 0 to FList.Count - 1
          if FList(i).Name = aFieldName then IndexOf = i : Exit Function
        Next 'i
        IndexOf = -1
    End Function

    '���ַ�������һ�������ֶΣ��ֶ����������������֮����ð�š�:���ָ�����һ�����ֶ��������ŵ������ֶε����ԡ�
     'ʾ���� "Id:ftString:32:true:false:""the Validator"":""the Constraints"":""the filters"""
    Public Function Append(ByRef aText)
        Dim Result, vTemp
        vTemp = Split(aText, ":")
        if IndexOf(vTemp(0)) < 0 then
          Set Result = New TMeMetaField
          Result.Assign(vTemp)
          FList.Add(Result)
        else
          Set Result = Nothing
        end if
        Set Append = Result
    End Function

    '���Ը���
    Public Function Count()
      Count = FList.Count
    End Function

    '������е�����
    Public Sub Clear()
      FList.Clear()
    End Sub
End Class

'����comboBox ��ListBox��������ô���� ��Ϊ ftCollection ���ʹ���
Class TMeMetaField
    Private FItems(7)
    'Public Name, FieldType, Size
    'Public Required  'Boolean
    'Public Confirmed 'Boolean ������ֶ���Ҫ��������
    'Public Validator ' the js condition script.
    'Public Constraints ' the js condition script.
    'Public Filters ' the js filter value script.

    Private Sub Class_Initialize()
        Set FFields = New TMeMetaFields
    End Sub

    Private Sub Class_Terminate()
        Set FFields = Nothing
    End Sub

    Public Property Get Name()
        Name = FItems(0)
    End Property

    Public Property Let Name(ByRef aValue)
        FItems(0) = aValue
    End Property

    Public Property Get FieldType()
        FieldType = FItems(1)
    End Property

    Public Property Let FieldType(ByRef aValue)
        FItems(1) = CByte(aValue)
    End Property

    Public Property Get Size()
        Size = FItems(2)
    End Property

    Public Property Let Size(ByRef aValue)
        FItems(2) = CLng(aValue)
    End Property

    Public Property Get Required()
        Required = FItems(3)
    End Property

    Public Property Let Required(ByRef aValue)
        FItems(3) = CBool(aValue)
    End Property

    Public Property Get Confirmed()
        Confirmed = FItems(4)
    End Property

    Public Property Let Confirmed(ByRef aValue)
        FItems(4) = CBool(aValue)
    End Property

    Public Property Get Validator()
        Validator = FItems(5)
    End Property

    Public Property Let Validator(ByRef aValue)
        FItems(5) = aValue
    End Property

    Public Property Get Constraints()
        Constraints = FItems(6)
    End Property

    Public Property Let Constraints(ByRef aValue)
        FItems(6) = aValue
    End Property

    Public Property Get Filters()
        Filters = FItems(7)
    End Property

    Public Property Let Filters(ByRef aValue)
        FItems(7) = aValue
    End Property

    Public Sub Assign(ByRef aArray)
      Dim i, vArraySize
      vArraySize = UBound(aArray)
      For i = 0 to UBound(FItems)
        if i <= vArraySize then
          FItems(i) = Eval(aArray(i))
        else
          FItems(i) = Empty
        end if
      Next
    End Sub
End Class

'�������ֵ���Ƶ�������,ע������ĵ�һ��(0)Ϊ������
Public Function ArrayToObject(ByRef pArray)
    Dim i, vMetaObject, Result
    set Result = Eval("New "+pArray(0))
    if IsObject(Result) then
      Set vMetaObject = pObject.GetMetaObject
      For i = 1 to UBound(pArray)
        Select Case vMetaObject.Fields(i).FieldType
          Case ftCollection
            Execute("Result."+vMetaObject.Fields(i).Name + "=ArrayToCollection(pArray("+CStr(i)+"))")
          Case ftObject
            Execute("Set Result."+vMetaObject.Fields(i).Name + "=ArrayToObject(pArray("+CStr(i)+"))")
          Case else
            Execute("Result."+vMetaObject.Fields(i).Name + "=pArray("+CStr(i)+")")
        End Select
      Next 'i
      Set vMetaObject = Nothing
    end if
    Set ArrayToObject = Result
End Function

Public Function ObjectToArray(ByRef pObject)
    Dim i, Result, vMetaObject
    Set vMetaObject = pObject.GetMetaObject()
    Redim Result(vMetaObject.Count)
    if IsArray(Result) then
      Result(0) = vMetaObject.ClassName
      For i = 1 to UBound(Result)
        'Execute("Result("+i+")" + "=pObject."+vProps(i))
        Select Case vMetaObject.Fields(i).FieldType
          Case ftCollection
            Result(i) = CollectionToArray(Eval("pObject."+vMetaObject.Fields(i).Name))
          Case ftObject
            Result(i) = ObjectToArray(Eval("pObject."+vMetaObject.Fields(i).Name))
          Case else 
            Result(i) = Eval("pObject."+vMetaObject.Fields(i).Name)
        End Select
      Next 'i
    end if
    Set vMetaObject = Nothing
    ObjectToArray = Result
End Function

Public Function CollectionToArray(ByRef pObject)
    Dim i, Result
    Redim Result(pObject.Count)
    Result(0) = pObject.ClassName
    for i =1 to UBound(Result)
        Select Case VarType(pObject.Items(i-1))
          Case vbObject
            Result(i) = ObjectToArray(pObject.Items(i-1))
          Case else 
            Result(i) = pObject.Items(i-1)
        End Select
    next 'i
    CollectionToArray = Result
End Function

Public Function ArrayToCollection(ByRef pArray)
    Dim i, Result, vItem, s
    set Result = Eval("New "+pArray(0))
    if IsObject(Result) then
      For i = 1 to UBound(pArray)
        vItem = pArray(i)
        Select Case VarType(vItem)
          Case vbArray
            if IsClassName(vItem(0)) then 
              Execute("Result.Add(ArrayToObject(vItem))")
            else
              Execute("Result.Add(vItem)")
            end if
          Case else
            Execute("Result.Add(vItem)")
        End Select
      Next 'i
      Set vMetaObject = Nothing
    end if
    Set ArrayToCollection = Result
End Function

Public Function IsClassName(ByRef aString)
  Dim Result
  Result = (VarType(aString) = vbString)
  if Result then Result = (Len(aString) > 1)
  if Result then Result = (Mid(aString, 1, 1) = "T")
End Function

Public Function IsClass(aObject, ByRef aClassName)
  Dim Result
  Result = (VarType(aObject) = vbObject)
  if Result then 
    Result = False
    On Error Resume Next
    Result = (aObject.ClassName = aClassName)
    On Error Goto 0
  end if
End Function

Function MakeGlobalObjectId(ByRef pObject)
  MakeGlobalObjectId = MakeGlobalObjectIdBy(pObject.ClassName, pObject.ObjectId)
End Function

Function MakeGlobalObjectIdBy(ByRef pClassName, ByRef pId)
  MakeGlobalObjectIdBy = pClassName + ":" + pId
End Function

Function TypeCast(ByRef aValue, ByVal aType)
  Dim Result
  if not IsEmpty(aValue) then
    Select Case aType
      Case ftString, ftURL, ftPassword, ftMemo, ftMemoRTF, ftEmailURL, ftImageURL, ftFlashURL, ftSoundURL
        Result = CStr(aValue)
      Case ftInteger
        Result = CLng(aValue)
      Case ftFloat
        Result = CDbl(aValue)
      Case ftCurreny
        Result = CCur(aValue)
      Case ftDate, ftTime, ftDateTime
        Result = CDate(aValue)
      Case ftBoolean
        Result = CBool(aValue)
    End Select
  end if
  TypeCast = Result
End Function

</SCRIPT> 
