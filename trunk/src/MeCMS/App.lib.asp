<SCRIPT Runat="Server" Language="VBScript">

Public Const cActionRequestPostfix = "Request"
Private Const cLoginRequestAction = "LoginRequest"
Private Const cLoginAction = "Login"

Class TMeCMSApp
    Private FDatabase
    Private FConfigCollection
    Private FSession
    Private FUsers
    Private FActions
    Public LoginRetryTimeInterval  'seconds
    Public LoginRetryMaxCount

    Private Sub Class_Initialize()
        Dim SERVER_NAME, SERVER_PORT, SERVER_PORT_SECURE

        LoginRetryTimeInterval = 60
        LoginRetryMaxCount = 5

        Lib.Require("ApplicationCaches")
        Lib.Require("Security.Session")
        Lib.Require("MeDatabase")
        Lib.Require("MeCMS.Security.UserMgr")
        Lib.Require("MeCMS.ActionMgr")

        Set FDatabase    = New TMeDatabase
        Set FSession     = New TMeSession
        Set Lib.Database = FDatabase
        Set FUsers       = New TMeUserMgr
        Set FActions     = New TMeActionMgr
        Set FConfigCollection = Server.CreateObject(DictionaryObjectName)

        SERVER_NAME        = Request.ServerVariables("SERVER_NAME")
        SERVER_PORT        = Request.ServerVariables("SERVER_PORT")
        SERVER_PORT_SECURE = Request.ServerVariables("SERVER_PORT_SECURE")

        If SERVER_PORT_SECURE = 0 Then
            gServerRoot = "http://" & SERVER_NAME
        Else
            gServerRoot = "https://" & SERVER_NAME
        End If
        If SERVER_PORT <> 80 Then
            gServerRoot = gServerRoot & ":" & SERVER_PORT
        End If
        gServerRoot = gServerRoot & Left(SCRIPT_NAME, InStrRev(SCRIPT_NAME, "/"))

    End Sub

    Private Sub Class_Terminate()
        Set FSession  = Nothing
        Set FDatabase = Nothing
        Set FUsers    = Nothing
        Set FActions  = Nothing
        Set gCache    = Nothing
        Set FConfigCollection = Nothing
    End Sub

    Public Property Get Database()
        Set Database = FDatabase
    End Property

    Public Property Get Config()
        Set Config = FConfigCollection
    End Property

    Public Property Get Cache()
        On Error Resume Next
        Set Cache = gCache
        On Error Goto 0
    End Property

    Public Property Get Session()
        Set Session = FSession
    End Property

    Public Property Get Users()
        Set Users = FUsers
    End Property

    Public Property Get Actions()
        Set Actions = FActions
    End Property

    Public Sub Run()
      FDatabase.Open
      ' ����ǰ׼��
      Lib.Require("MeCMS.Init") ' ��̬װ�����г�ʼ�����̺����������ݿ��С�Ҳ���Բ�����

      ' * �������������ݲ�����̬װ�벻ͬ�����Ⲣ����
      ProcessRequest()
      '���к���
      Lib.Require("MeCMS.Terminate")
    End Sub

    ' * �������������ݲ�����̬װ�벻ͬ�����Ⲣ����
    Public Sub ProcessRequest()
      Dim vActionId, vCatId
      vActionId = Request(cActionIdURLParamName)
      if IsEmpty(vActionId) or vActionId = "" then 
        vActionId = "#"
      else
      end if
      vCatId = Request(cCatIdURLParamName)
      if IsEmpty(vCatId) or vCatId = "" then 
        vCatId = "#"
      else
      end if

      'if not (FUsers.Logined or (vActionId = cLoginRequestAction and vCatId = "#")) then
      'if Not FCurrentUser.HasPermission(vCatId, vActionId) then ' ���Է���ִ��actionǰ���ԣ���
      if not FUsers.Logined then
        ' * ����Ƿ��¼��û�������Ƿ���Login Action ������Ҫ���û���½������ͳ���ֱ�롣
        '������ָö�������ʾ���滹�Ƿ������ݣ�: ���ݷ��ص����� t=r��ʾrequest ��������, t=v��ʾ�ö����ǽ��档
        '����actions�����ִ���
        if FActions.ActionExists("#", cLoginAction) then
          vCatId = "#"
          vActionId = cLoginAction
        end if
      end if
      'end if

      if FActions.ActionExists(vCatId, vActionId) then FActions.Execute(vCatId, vActionId)
    End Sub

    ' check whether has the permission for the action.!
    Public Function HasRunPermissionForAction(ByRef aCatId, ByRef aActionId);
      Dim Result
      Result = True
      HasRunPermissionForAction = Result
    End Function
End Class

</SCRIPT>

