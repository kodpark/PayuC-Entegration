using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using System.Collections.Generic;
using System.Web.Script.Services;
using System.IO;
using System.Text;

namespace PayuDirekOdemeTest
{
    /// <summary>
    /// Summary description for payupay
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]
    public class payupay : System.Web.Services.WebService
    {

        [WebMethod(true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public void PayuPay(string FirstName, string LastName, string Email, string Phone, string Product, decimal Amount)
        {
            PayuClass pc = new PayuClass();
            string sonuc = pc.PayuPay("2578", FirstName, LastName, Email, Phone, Product, Amount);
            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.AddHeader("content-disposition", "attachment; filename=export.json");
            Context.Response.AddHeader("content-length", sonuc.Length.ToString());
            Context.Response.Flush();
            Context.Response.Write(sonuc);
            //return sonuc;
        }
    }
}
