﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="Compare.aspx.cs" Inherits="Solution_Compare" %>

<%@ Import Namespace="Moo.Text" %>
<asp:Content ContentPlaceHolderID="head" runat="Server">
    <title>比较
        <%#HttpUtility.HtmlEncode(problem.Name) %>
        的题解的不同版本</title>
</asp:Content>
<asp:Content ContentPlaceHolderID="main" runat="Server">
    <Moo:LinkBar runat="server" Title="题解">
        <Moo:LinkBarItem URL='<%#"~/Solution/?id="+problem.ID %>' Text="题解" />
        <Moo:LinkBarItem URL='<%#"~/Solution/Update.aspx?id="+problem.ID %>' Text="更新" />
        <Moo:LinkBarItem URL='<%#"~/Solution/History.aspx?id="+problem.ID %>' Text="历史" />
        <Moo:LinkBarItem URL='<%#"~/Solution/Compare.aspx?revisionOld="+revisionOld.ID+"&revisionNew="+revisionNew.ID %>'
            Selected="true" Text="比较" />
        <Moo:LinkBarItem URL='<%#"~/Record/Create.aspx?problemID="+problem.ID %>' Shortcut="true"
            Text="提交" />
        <Moo:LinkBarItem URL='<%#"~/Problem/?id="+problem.ID %>' Special="true" Text="题目" />
        <Moo:LinkBarItem URL='<%#"~/TestCase/List.aspx?id="+problem.ID %>' Special="true"
            Text="测试数据" />
        <Moo:LinkBarItem URL='<%#"~/Post/List.aspx?problemID="+problem.ID %>' Special="true"
            Text="帖子" />
        <Moo:LinkBarItem URL='<%#"~/Record/List.aspx?problemID="+problem.ID %>' Special="true"
            Text="记录" />
    </Moo:LinkBar>
    <fieldset id="fieldQuery" runat="server">
        <legend>查询</legend>
        <asp:Label runat="server">旧版本编号</asp:Label>
        <asp:TextBox ID="txtRevisionOld" runat="server" ValidationGroup="grpQuery" Text='<%#revisionOld.ID%>'></asp:TextBox>
        <asp:RequiredFieldValidator runat="server" ValidationGroup="grpQuery" ControlToValidate="txtRevisionOld"
            Display="Dynamic" CssClass="validator">不能为空</asp:RequiredFieldValidator>
        <asp:CompareValidator runat="server" ValidationGroup="grpQuery" ControlToValidate="txtRevisionOld"
            Operator="DataTypeCheck" Type="Integer" Display="Dynamic" CssClass="validator">需为整数</asp:CompareValidator>
        <asp:CustomValidator runat="server" ValidationGroup="grpQuery" ControlToValidate="txtRevisionOld"
            Display="Dynamic" CssClass="validator" OnServerValidate="ValidateRevisionID">无此版本</asp:CustomValidator>
        <asp:Label runat="server">新版本编号</asp:Label>
        <asp:TextBox ID="txtRevisionNew" runat="server" ValidationGroup="grpQuery" Text='<%#revisionNew.ID %>'></asp:TextBox>
        <asp:RequiredFieldValidator runat="server" ValidationGroup="grpQuery" ControlToValidate="txtRevisionNew"
            Display="Dynamic" CssClass="validator">不能为空</asp:RequiredFieldValidator>
        <asp:CompareValidator runat="server" ValidationGroup="grpQuery" ControlToValidate="txtRevisionNew"
            Operator="DataTypeCheck" Type="Integer" Display="Dynamic" CssClass="validator">需为整数</asp:CompareValidator>
        <asp:CustomValidator runat="server" ValidationGroup="grpQuery" ControlToValidate="txtRevisionNew"
            Display="Dynamic" CssClass="validator" OnServerValidate="ValidateRevisionID">无此版本</asp:CustomValidator>
        <asp:CustomValidator ID="validateSameProblem" runat="server" ValidationGroup="grpQuery"
            Display="Dynamic" CssClass="validator" OnServerValidate="validateSameProblem_ServerValidate">不是同一题目的版本</asp:CustomValidator>
        <asp:Button ID="btnQuery" ValidationGroup="grpQuery" runat="server" Text="查询" OnClick="btnQuery_Click" />
    </fieldset>
    <table style="width: 100%; border: none; table-layout: fixed;">
        <tr>
            <th style="padding: 10px; border: none; width: 50%; background: none;">
                <a runat="server" href='<%#"~/Solution/?revision="+revisionOld.ID %>'>旧版本</a> #<%#revisionOld.ID %><br />
                <a runat="server" href='<%#"~/Solution/Compare.aspx?revisionOld="+(revisionOldPrev==null?0:revisionOldPrev.ID)+"&revisionNew="+revisionOld.ID %>'
                    visible='<%#revisionOldPrev!=null %>' style="font-size: smaller;">&lt;&lt;与上一版本比较</a>
                <a runat="server" href='<%#"~/Solution/Compare.aspx?revisionOld="+revisionOld.ID+"&revisionNew="+(revisionOldNext==null?0:revisionOldNext.ID) %>'
                    visible='<%#revisionOldNext!=null && revisionOldNext.ID!=revisionNew.ID %>' style="font-size: smaller;">
                    与下一版本比较&gt;&gt;</a><br />
                <Moo:UserSign runat="server" UserID="<%#revisionOld.CreatedBy.ID %>" />
                <br />
                <%#HttpUtility.HtmlEncode(revisionOld.Reason) %>
            </th>
            <th style="padding: 10px; border: none; background: none;">
                <a runat="server" href='<%#"~/Solution/?revision="+revisionNew.ID %>'>新版本</a> #<%#revisionNew.ID %><br />
                <a runat="server" href='<%#"~/Solution/Compare.aspx?revisionOld="+(revisionNewPrev==null?0:revisionNewPrev.ID)+"&revisionNew="+revisionNew.ID %>'
                    visible='<%#revisionNewPrev!=null && revisionNewPrev.ID!=revisionOld.ID %>' style="font-size: smaller;">
                    &lt;&lt;与上一版本比较</a> <a runat="server" href='<%#"~/Solution/Compare.aspx?revisionOld="+revisionNew.ID+"&revisionNew="+(revisionNewNext==null?0:revisionNewNext.ID) %>'
                        visible='<%#revisionNewNext!=null %>' style="font-size: smaller;">与下一版本比较&gt;&gt;</a><br />
                <Moo:UserSign runat="server" UserID="<%#revisionNew.CreatedBy.ID %>" />
                <br />
                <%#HttpUtility.HtmlEncode(revisionNew.Reason) %>
            </th>
        </tr>
        <tr>
            <td style="padding: 10px; border: none; font-size: 14pt;" colspan="2">
                <pre><%#DiffGenerator.Generate(revisionOld.Content,revisionNew.Content)%></pre>
            </td>
        </tr>
    </table>
</asp:Content>
