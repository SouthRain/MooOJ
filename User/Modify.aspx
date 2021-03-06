﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="Modify.aspx.cs" Inherits="User_Modify" %>

<%@ Import Namespace="Moo.Authorization" %>
<asp:Content ContentPlaceHolderID="head" runat="Server">
    <title>修改
        <%#HttpUtility.HtmlEncode(user.Name) %></title>
</asp:Content>
<asp:Content ContentPlaceHolderID="main" runat="Server">
    <Moo:LinkBar runat="server" Title="用户">
        <Moo:LinkBarItem URL='<%#"~/User/?id="+user.ID %>' Text="用户" />
        <Moo:LinkBarItem URL='<%#"~/User/Modify.aspx?id="+user.ID %>' Selected="true" Text="修改" />
        <Moo:LinkBarItem URL='<%#"~/Record/List.aspx?userID="+user.ID %>' Special="true"
            Text="记录" />
    </Moo:LinkBar>
    <Moo:InfoBlock runat="server" Type="Alert" Visible='<%#!canModify %>'>
        <asp:Literal runat="server" Text="<%$Resources:Moo,NoEnoughPermission%>" />
    </Moo:InfoBlock>
    <table class="detailTable">
        <tr>
            <th>
                名称
            </th>
            <td>
                <asp:TextBox ID="txtName" runat="server" Width="100%" Text='<%#user.Name %>' Enabled='<%#Permission.Check("user.name.modify",false,false) %>'></asp:TextBox>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtName" Display="Dynamic"
                    CssClass="validator">不能为空</asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator runat="server" ControlToValidate="txtName" ValidationExpression=".{1,20}"
                    Display="Dynamic" CssClass="validator">长度需在1~20位之间</asp:RegularExpressionValidator>
                <asp:CustomValidator ID="validateName" runat="server" ControlToValidate="txtName"
                    Display="Dynamic" CssClass="validator" OnServerValidate="validateName_ServerValidate">用户名已被抢注</asp:CustomValidator>
                <asp:Button ID="btnForceLogout" runat="server" CausesValidation="false" Text="强制登出"
                    OnClick="btnForceLogout_Click" />
            </td>
        </tr>
        <tr>
            <th>
                密码
            </th>
            <td>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Width="100%"></asp:TextBox>
                <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPassword" ValidationExpression=".{6,}"
                    Display="Dynamic" CssClass="validator">长度需大于6位</asp:RegularExpressionValidator>
                不想修改请留空
            </td>
        </tr>
        <tr>
            <th>
                确认密码
            </th>
            <td>
                <asp:TextBox ID="txtPassword2" runat="server" TextMode="Password" Width="100%"></asp:TextBox>
                <asp:CompareValidator runat="server" ControlToValidate="txtPassword2" ControlToCompare="txtPassword"
                    Display="Dynamic" CssClass="validator">两次输入的密码不匹配</asp:CompareValidator>
            </td>
        </tr>
        <tr>
            <th>
                角色
            </th>
            <td>
                <asp:ObjectDataSource ID="roleDataSource" runat="server" SelectMethod="GetRoles"
                    TypeName="Moo.Authorization.SiteRoles"></asp:ObjectDataSource>
                <asp:DropDownList ID="ddlRole" runat="server" AutoPostBack="True" DataSourceID="roleDataSource"
                    DataTextField="DisplayName" DataValueField="ID">
                </asp:DropDownList>
                <asp:CustomValidator ID="validateRole" runat="server" ValidateEmptyText="true" ControlToValidate="ddlRole"
                    Display="Dynamic" CssClass="validator" OnServerValidate="validateRole_ServerValidate">新角色不能高于原有角色</asp:CustomValidator>
            </td>
        </tr>
        <tr>
            <th>
                电子邮箱
            </th>
            <td>
                <b><span style="color: Red;">注意</span>：您的头像将会根据这个电子邮箱，从<a href="https://gravatar.com/">Gravatar</a>获取，详见<a
                    runat="server" href="~/Help/?id=15">快速入门-用户页的使用与用户之间的比较</a>。</b><br />
                <asp:TextBox ID="txtEmail" runat="server" Width="100%" Text='<%#user.Email %>'></asp:TextBox>
                <asp:RegularExpressionValidator runat="server" ControlToValidate="txtEmail" ValidationExpression=".+@.+\..+"
                    Display="Dynamic" CssClass="validator">格式错误</asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <th>
                简述
            </th>
            <td>
                <asp:TextBox ID="txtBriefDescription" runat="server" Width="100%" Text='<%#user.BriefDescription%>'></asp:TextBox>
                <asp:RegularExpressionValidator runat="server" ControlToValidate="txtBriefDescription"
                    ValidationExpression=".{0,40}" Display="Dynamic" CssClass="validator">长度需在0~40位</asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <th>
                描述
            </th>
            <td>
                <Moo:WikiEditor ID="txtDescription" runat="server" Text='<%#user.Description%>' />
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
                <asp:Button ID="btnSubmit" runat="server" Text="修改" OnClick="btnSubmit_Click" />
            </td>
        </tr>
    </table>
</asp:Content>
