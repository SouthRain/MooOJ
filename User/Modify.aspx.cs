﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Moo.DB;
using Moo.Authorization;
using Moo.Utility;
using Moo.Text;
public partial class User_Modify : System.Web.UI.Page
{
    protected bool canModify;

    protected User user;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Permission.Check("user.read", true)) return;

        if (!Page.IsPostBack)
        {
            using (MooDB db = new MooDB())
            {
                if (Request["id"] != null)
                {
                    int id = int.Parse(Request["id"]);
                    user = (from u in db.Users
                            where u.ID == id
                            select u).SingleOrDefault<User>();
                }

                if (user == null)
                {
                    PageUtil.Redirect(Resources.Moo.FoundNothing, "~/");
                    return;
                }

                if (!User.Identity.IsAuthenticated)
                {
                    canModify = false;
                }
                else
                {
                    SiteUser siteUser = (SiteUser)User.Identity;
                    canModify = siteUser.ID == user.ID
                        || Permission.Check("user.modify", false, false)
                            && siteUser.Role.Type < SiteRoles.ByID[user.Role.ID].Type;
                }

                ViewState["userID"] = user.ID;
                Page.DataBind();
                ddlRole.SelectedIndex = ddlRole.Items.IndexOf(ddlRole.Items.FindByValue(user.Role.ID.ToString()));
            }
        }
    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        if (!User.Identity.IsAuthenticated)
        {
            Permission.Check("i'm super man.", false);
            return;
        }

        int userID = (int)ViewState["userID"];
        using (MooDB db = new MooDB())
        {
            user = (from u in db.Users
                    where u.ID == userID
                    select u).Single<User>();

            SiteUser siteUser = (SiteUser)User.Identity;
            canModify = siteUser.ID == user.ID
                || Permission.Check("user.modify", false, false)
                    && siteUser.Role.Type < SiteRoles.ByID[user.Role.ID].Type;
            if (!canModify)
            {
                Permission.Check("i'm super man.", false);
                return;
            }

            if (Permission.Check("user.name.modify", false, false))
            {
                user.Name = txtName.Text;
            }

            if (txtPassword.Text.Length > 0)
            {
                user.Password = Converter.ToSHA256Hash(txtPassword.Text);
            }

            user.Role = SiteRoles.ByID[int.Parse(ddlRole.SelectedValue)].GetDBRole(db);
            user.Email = txtEmail.Text;
            user.BriefDescription = txtBriefDescription.Text;
            user.Description = txtDescription.Text;

            db.SaveChanges();

            //Refresh SiteUser
            if (SiteUsers.ByID.ContainsKey(user.ID))
            {
                siteUser = SiteUsers.ByID[user.ID];
                siteUser.Role = SiteRoles.ByID[user.Role.ID];
                siteUser.Name = user.Name;
            }

            Logger.Info(db, "修改用户#" + user.ID);
        }

        PageUtil.Redirect("修改成功", "~/User/?id=" + userID);
    }
    protected void btnForceLogout_Click(object sender, EventArgs e)
    {
        if (!Permission.Check("user.forcelogout", false)) return;

        int userID = (int)ViewState["userID"];
        SiteUsers.ByID.Remove(userID);
        using (MooDB db = new MooDB())
        {
            Logger.Info(db, "强制用户#" + userID + "登出");
        }
        PageUtil.Redirect("强制登出成功", "~/User/Modify.aspx?id=" + userID);
    }
    protected void validateRole_ServerValidate(object source, ServerValidateEventArgs args)
    {
        if (Permission.Check("user.role.modify", false, false))
        {
            args.IsValid = true;
        }
        else
        {
            int userID = (int)ViewState["userID"];
            using (MooDB db = new MooDB())
            {
                user = (from u in db.Users
                        where u.ID == userID
                        select u).Single<User>();
                args.IsValid = SiteRoles.ByID[int.Parse(ddlRole.SelectedValue)].Type >= SiteRoles.ByID[user.Role.ID].Type;
            }
        }
    }
    protected void validateName_ServerValidate(object source, ServerValidateEventArgs args)
    {
        int userID = (int)ViewState["userID"];
        using (MooDB db = new MooDB())
        {
            args.IsValid = !(from u in db.Users
                            where u.ID != userID && u.Name == txtName.Text
                            select u).Any();
        }
    }
}