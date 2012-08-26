﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="Update.aspx.cs" Inherits="Problem_Update" %>

<%@ Import Namespace="Moo.Authorization" %>
<asp:Content ContentPlaceHolderID="head" runat="Server">
    <title>更新
        <%#HttpUtility.HtmlEncode(problem.Name) %></title>
</asp:Content>
<asp:Content ContentPlaceHolderID="main" runat="Server">
    <Moo:LinkBar runat="server" Title="题目">
        <Moo:LinkBarItem URL='<%#"~/Problem/?revision="+revision.ID %>' Text="题目" />
        <Moo:LinkBarItem URL='<%#"~/Problem/Modify.aspx?id="+problem.ID %>' Text="修改" />
        <Moo:LinkBarItem URL='<%#"~/Problem/Update.aspx?revision="+revision.ID %>' Selected="true" Text="更新" />
        <Moo:LinkBarItem URL='<%#"~/Problem/History.aspx?id="+problem.ID %>' Text="历史" />
        <Moo:LinkBarItem URL='<%#"~/Record/Create.aspx?problemID="+problem.ID %>' Shortcut="true" Text="提交" />
        <Moo:LinkBarItem URL='<%#"~/TestCase/List.aspx?id="+problem.ID %>' Special="true" Text="测试数据" />
        <Moo:LinkBarItem URL='<%#"~/Solution/?id="+problem.ID %>' Special="true" Text="题解" />
        <Moo:LinkBarItem URL='<%#"~/Post/List.aspx?problemID="+problem.ID %>' Special="true" Text="帖子" />
        <Moo:LinkBarItem URL='<%#"~/Record/List.aspx?problemID="+problem.ID %>' Special="true" Text="记录" />
    </Moo:LinkBar>
    <Moo:InfoBlock runat="server" Type="Alert" Visible='<%#!canUpdate %>'>
        您可能不具备完成此操作所必须的权限。
    </Moo:InfoBlock>
    <Moo:InfoBlock runat="server" Type="Alert" Visible='<%#revision.ID!=problem.LatestRevision.ID %>'>
        您现在的编辑基于
        <%#HttpUtility.HtmlEncode(problem.Name) %>
        的历史版本。如需基于最新版本编辑，请<a runat="server" href='<%#"~/Problem/Update.aspx?id="+problem.ID %>'>单击这里</a>。
    </Moo:InfoBlock>
    
    <table class="detailTable">
        <tr id="trPreview" runat="server" visible="false">
            <th>
                预览
            </th>
            <td>
                <div id="divPreview" runat="server">
                </div>
            </td>
        </tr>
        <tr>
            <th>
                内容
            </th>
            <td>
                <asp:TextBox ID="txtContent" runat="server" ViewStateMode="Disabled" TextMode="MultiLine"
                    Rows="20" Width="100%" Text='<%#canRead?revision.Content:"" %>'></asp:TextBox>
                <Moo:WikiSupported runat="server" />
            </td>
        </tr>
        <tr>
            <th>
                修改原因
            </th>
            <td>
                <asp:TextBox ID="txtReason" runat="server" ViewStateMode="Disabled" Width="100%"></asp:TextBox>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtReason" Display="Dynamic" CssClass="validator">不能为空</asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator runat="server" ControlToValidate="txtReason" Display="Dynamic"
                    ValidationExpression=".{1,100}" CssClass="validator">长度需在1~100之间</asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <th>
                验证码
            </th>
            <td>
                <Moo:Captcha runat="server" />
            </td>
        </tr>
        <tr>
            <td colspan="2" style="text-align: center;">
                <asp:Button ID="btnPreview" runat="server" ViewStateMode="Disabled" CausesValidation="false"
                    Text="预览" OnClick="btnPreview_Click" />
                <asp:Button ID="btnSubmit" runat="server" Text="更新" Enabled="false" OnClick="btnSubmit_Click" />
            </td>
        </tr>
    </table>
    
</asp:Content>