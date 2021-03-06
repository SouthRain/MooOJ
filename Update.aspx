﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="Update.aspx.cs" Inherits="Update" %>

<%@ Import Namespace="Moo.Authorization" %>
<asp:Content ContentPlaceHolderID="head" runat="Server">
    <title>更新主页</title>
</asp:Content>
<asp:Content ContentPlaceHolderID="main" runat="Server">
    <Moo:LinkBar runat="server" Title="主页">
        <Moo:LinkBarItem URL='<%#"~/?revision="+revision.ID %>' Text="主页" />
        <Moo:LinkBarItem URL='<%#"~/Update.aspx?revision="+revision.ID %>' Selected="true"
            Text="更新" />
        <Moo:LinkBarItem URL="~/History.aspx" Text="历史" />
    </Moo:LinkBar>
    <Moo:InfoBlock runat="server" Type="Alert" Visible='<%#!Permission.Check("homepage.update",false,false) %>'>
        <asp:Literal runat="server" Text="<%$Resources:Moo,NoEnoughPermission%>" />
    </Moo:InfoBlock>
    <Moo:InfoBlock runat="server" Type="Alert" Visible='<%#!isLatest %>'>
        您的更新基于主页的历史版本，如想基于最新版本，请<a runat="server" href="~/Update.aspx">点击这里</a>。
    </Moo:InfoBlock>
    <table class="detailTable">
        <tr>
            <th>
                标题
            </th>
            <td>
                <asp:TextBox ID="txtTitle" runat="server" Width="100%" Text='<%#revision.Title %>'></asp:TextBox>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtTitle" Display="Dynamic"
                    CssClass="validator">不能为空</asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator runat="server" ControlToValidate="txtTitle" ValidationExpression=".{1,40}"
                    Display="Dynamic" CssClass="validator">长度需在1~40位</asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <th>
                内容
            </th>
            <td>
                <Moo:WikiEditor ID="txtContent" runat="server" Text='<%#revision.Content %>' />
            </td>
        </tr>
        <tr>
            <th>
                原因
            </th>
            <td>
                <asp:TextBox ID="txtReason" runat="server" Width="100%"></asp:TextBox>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtReason" Display="Dynamic"
                    CssClass="validator">不能为空</asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator runat="server" ControlToValidate="txtReason" ValidationExpression=".{1,40}"
                    Display="Dynamic" CssClass="validator">长度需在1~40位之间</asp:RegularExpressionValidator>
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
                <asp:Button ID="btnSubmit" runat="server" Text="更新" OnClick="btnSubmit_Click" />
            </td>
        </tr>
    </table>
</asp:Content>
