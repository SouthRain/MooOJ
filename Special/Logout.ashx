﻿<%@ WebHandler Language="C#" Class="Special_Logout" %>

using System;
using System.Web;
using System.Web.Security;
using Moo.Authorization;
using Moo.Utility;
using Moo.DB;
public class Special_Logout : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        if (context.User.Identity.IsAuthenticated && ((SiteUser)context.User.Identity).Token.ToString() == context.Request["token"])
        {
            using (MooDB db = new MooDB())
            {
                Logger.Info(db, "登出");
            }
            FormsAuthentication.SignOut();
            SiteUsers.ByID.Remove(((SiteUser)context.User.Identity).ID);
        }

        PageUtil.Redirect("已登出", context.Request.UrlReferrer == null ? "~/" : context.Request.UrlReferrer.ToString());
    }

    public bool IsReusable
    {
        get
        {
            return true;
        }
    }

}