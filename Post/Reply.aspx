﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="Reply.aspx.cs" Inherits="Post_Reply" %>

<%@ Import Namespace="Moo.Authorization" %>
<asp:Content ContentPlaceHolderID="head" runat="Server">
    <title>回复
        <%#HttpUtility.HtmlEncode(post.Name) %></title>
</asp:Content>
<asp:Content ContentPlaceHolderID="main" runat="Server">
    <Moo:LinkBar runat="server" Title="帖子">
        <Moo:LinkBarItem URL='<%#"~/Post/?id="+post.ID %>' Text="帖子" />
        <Moo:LinkBarItem URL='<%#"~/Post/Modify.aspx?id="+post.ID %>' Text="修改" />
        <Moo:LinkBarItem URL='<%#"~/Post/Reply.aspx?id="+post.ID %>' Selected="true" Text="回复" />
        <Moo:LinkBarItem URL='<%#"~/Problem/?id="+(post.Problem==null?0:post.Problem.ID) %>'
            Special="true" Hidden='<%#post.Problem==null %>' Text="题目" />
        <Moo:LinkBarItem URL='<%#"~/TestCase/List.aspx?id="+(post.Problem==null?0:post.Problem.ID) %>'
            Special="true" Hidden='<%#post.Problem==null %>' Text="测试数据" />
        <Moo:LinkBarItem URL='<%#"~/Solution/?id="+(post.Problem==null?0:post.Problem.ID) %>'
            Special="true" Hidden='<%#post.Problem==null %>' Text="题解" />
        <Moo:LinkBarItem URL='<%#"~/Record/List.aspx?problemID="+(post.Problem==null?0:post.Problem.ID) %>'
            Special="true" Hidden='<%#post.Problem==null %>' Text="记录" />
    </Moo:LinkBar>
    <Moo:InfoBlock runat="server" Type="Alert" Visible='<%#!canReply %>'>
        <asp:Literal runat="server" Text="<%$Resources:Moo,NoEnoughPermission%>" />
    </Moo:InfoBlock>
    <table class="detailTable">
        <tr>
            <th>
                内容
            </th>
            <td>
                <Moo:WikiEditor ID="txtContent" runat="server" Text='<%#initialContent %>' />
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
                <asp:Button ID="btnSubmit" runat="server" Text="创建" OnClick="btnSubmit_Click" />
            </td>
        </tr>
    </table>
</asp:Content>
