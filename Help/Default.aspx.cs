﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using Moo.Authorization;
using Moo.Utility;
public partial class Help_Default : System.Web.UI.Page
{
    protected string content;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Permission.Check("help.read", true)) return;

        if (!Page.IsPostBack)
        {
            if (Request["id"] != null)
            {
                int helpID = int.Parse(Request["id"]);
                string filePath = Server.MapPath("~/Help/" + helpID + ".txt");
                if (File.Exists(filePath))
                {
                    content = File.ReadAllText(filePath);
                }
                else
                {
                    PageUtil.Redirect("找不到相关内容", "~/");
                    return;
                }
            }

            if (content == null)
            {
                PageUtil.Redirect("找不到相关内容", "~/");
                return;
            }
            Page.DataBind();
        }
    }
}