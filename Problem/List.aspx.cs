﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Moo.Utility;
using Moo.DB;
using Moo.Authorization;
public partial class Problem_List : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Permission.Check("problem.list", true)) return;
        if (!Page.IsPostBack)
        {
            using (MooDB db = new MooDB())
            {
                if (Request["name"] != null)
                {
                    ViewState["name"] = Request["name"];
                }

                grid.DataSource = GetDataToBind(db);
                Page.DataBind();
            }
        }
    }
    protected void grid_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        if (!Permission.Check("problem.delete", false)) e.Cancel = true;
        int problemID = (int)e.Keys[0];
        using (MooDB db = new MooDB())
        {
            Problem problem = (from p in db.Problems
                               where p.ID == problemID
                               select p).Single<Problem>();
            if (problem.Contest.Any())
            {
                PageUtil.Redirect("请先删除相关比赛。", "~/Problem/List.aspx");
                return;
            }
            db.Problems.DeleteObject(problem);
            db.SaveChanges();

            Logger.Warning(db, "删除题目#" + problem.ID);
        }

        grid.Rows[e.RowIndex].Visible = false;
    }

    IQueryable GetDataToBind(MooDB db)
    {
        int? currentUserID = User.Identity.IsAuthenticated ? (int?)((SiteUser)User.Identity).ID : null;
        string name = (string)ViewState["name"];

        IQueryable<Problem> query = db.Problems;
        if (name != null)
        {
            query = from p in query
                    where p.Name.Contains(name)
                    select p;
        }

        return from p in query
               let records = from r in db.Records
                             where r.User.ID == currentUserID && r.Problem.ID == p.ID
                                   && r.JudgeInfo != null && r.JudgeInfo.Score >= 0
                             select r
               let score = records.Any() ? (int?)records.Max(r => r.JudgeInfo.Score) : null
               let averageScore = p.SubmissionUser > 0 ? p.ScoreSum / (double?)p.SubmissionUser : null
               let testCases = from t in db.TestCases.OfType<TranditionalTestCase>()
                               where t.Problem.ID == p.ID
                               select t
               let fullScore = testCases.Any() ? (int?)testCases.Sum(t => t.Score) : null
               orderby p.ID descending
               select new
               {
                   ID = p.ID,
                   Name = p.Name,
                   Type = p.Type,
                   Score = score,
                   SubmissionCount = p.SubmissionCount,
                   SubmissionUser = p.SubmissionUser,
                   AverageScore = averageScore,
                   MaximumScore = p.MaximumScore,
                   FullScore = fullScore
               };
    }
    protected void grid_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        using (MooDB db = new MooDB())
        {
            grid.PageIndex = e.NewPageIndex;
            grid.DataSource = GetDataToBind(db);
            grid.DataBind();
        }
    }
    protected void btnQuery_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        Response.Redirect("~/Problem/List.aspx?name=" + HttpUtility.UrlEncode(txtName.Text), true);
    }
    protected void btnGoIn_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        Response.Redirect("~/Problem/?id=" + txtID.Text, true);
    }
    protected void ValidateProblemID(object sender, ServerValidateEventArgs e)
    {
        using (MooDB db = new MooDB())
        {
            int id = int.Parse(txtID.Text);
            e.IsValid = (from p in db.Problems
                         where p.ID == id
                         select p).Any();
        }
    }
}