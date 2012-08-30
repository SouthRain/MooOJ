﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Moo.Authorization;
using Moo.DB;
using Moo.Text;
using Moo.Utility;
public partial class Problem_Compare : System.Web.UI.Page
{
    protected Problem problem;
    protected ProblemRevision revisionOld;
    protected ProblemRevision revisionNew;
    protected ProblemRevision revisionOldPrev;
    protected ProblemRevision revisionOldNext;
    protected ProblemRevision revisionNewPrev;
    protected ProblemRevision revisionNewNext;

    protected void Page_Load(object sender, EventArgs e)
    {
        using (MooDB db = new MooDB())
        {
            if (Request["revisionOld"] != null && Request["revisionNew"] != null)
            {
                CollectEntity(db, int.Parse(Request["revisionOld"]), int.Parse(Request["revisionNew"]));
            }
            
            if(revisionOld==null || revisionNew==null || problem==null){
                PageUtil.Redirect(Resources.Moo.FoundNothing, "~/");
                return;
            }

            revisionOldPrev = (from r in db.ProblemRevisions
                               where r.Problem.ID == problem.ID && r.ID < revisionOld.ID
                               orderby r.ID descending
                               select r).FirstOrDefault<ProblemRevision>();
            revisionNewPrev = (from r in db.ProblemRevisions
                               where r.Problem.ID == problem.ID && r.ID < revisionNew.ID
                               orderby r.ID descending
                               select r).FirstOrDefault<ProblemRevision>();
            revisionOldNext = (from r in db.ProblemRevisions
                               where r.Problem.ID == problem.ID && r.ID > revisionOld.ID
                               orderby r.ID
                               select r).FirstOrDefault<ProblemRevision>();
            revisionNewNext = (from r in db.ProblemRevisions
                               where r.Problem.ID == problem.ID && r.ID > revisionNew.ID
                               orderby r.ID
                               select r).FirstOrDefault<ProblemRevision>();

            if (problem.Hidden)
            {
                if (!Permission.Check("problem.hidden.read", false)) return;
            }
            else
            {
                if (!Permission.Check("problem.history.read", true)) return;
            }

            Page.DataBind();
        }
    }

    void CollectEntity(MooDB db, int oldID, int newID)
    {
        revisionOld = (from r in db.ProblemRevisions
                       where r.ID == oldID
                       select r).Single<ProblemRevision>();
        revisionNew = (from r in db.ProblemRevisions
                       where r.ID == newID
                       select r).Single<ProblemRevision>();
        if (revisionOld.ID > revisionNew.ID)
        {
            ProblemRevision tmp = revisionNew;
            revisionNew = revisionOld;
            revisionOld = tmp;
        }

        if (revisionOld.Problem.ID != revisionNew.Problem.ID)
        {
            throw new Exception("试图比较不同题目之间的版本");
        }

        problem = revisionNew.Problem;
    }
}