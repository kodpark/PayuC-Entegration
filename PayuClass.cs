using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Security.Cryptography;
using System.Xml;
using System.Text;
using System.IO;

namespace PayuDirekOdemeTest
{
    public class PayuClass
    {
        public string signature = "";
        public string pos_id = "";
        public string hashsign = "";

        public PayuClass()
        {

        }

        public string PayuPay(string ReqId, string FirstName, string LastName, string Email, string Phone, string Product, decimal Amount)
        {            
            string post_data = GenerateXml(ReqId, FirstName, LastName, Email, Phone, Product, Amount);
            hashsign = ComputeHash(post_data+signature,new SHA256CryptoServiceProvider());
            var sonuc_xml = HttpPost("https://secure.payu.com.tr/openpayu/v2/order.xml","DOCUMENT="+HttpContext.Current.Server.UrlEncode(post_data));
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(sonuc_xml);
            string JSON = ConvertJson.XmlToJSON(doc);
            JSON = JSON.Replace(@"\", @"\\");
            return JSON;
        }

        private string GenerateXml(string ReqId, string FirstName, string LastName, string Email, string Phone, string Product, decimal Amount)
        {
            string xml = @"<?xml version=""1.0"" encoding=""UTF-8""?><OpenPayU xmlns=""http://www.openpayu.com/openpayu.xsd""><OrderCreateRequest><ReqId>{0}</ReqId><CustomerIp>{1}</CustomerIp><ExtOrderId>{2}</ExtOrderId><MerchantPosId>{13}</MerchantPosId><Description>{3}</Description><CurrencyCode>{4}</CurrencyCode><TotalAmount>{5}</TotalAmount><Buyer><FirstName>{6}</FirstName><LastName>{7}</LastName><CountryCode>{8}</CountryCode><Email>{9}</Email><PhoneNumber>{10}</PhoneNumber><PhoneNumber>{11}</PhoneNumber></Buyer><Products>{12}</Products><PayMethod>DEFAULT</PayMethod></OrderCreateRequest></OpenPayU>";
            string urunxml = @"<Product><Name>"+ Product +"</Name><UnitPrice>"+ Amount +"</UnitPrice><Quantity>1</Quantity></Product>";

            xml = String.Format(xml, ReqId, HttpContext.Current.Request.UserHostAddress, "11", "AZ", "TRY", Amount, FirstName, LastName, "tr", Email, Phone, "tr", urunxml, pos_id);
            return xml;
        }

        private  string HttpPost(string url, string post_data)
        {
            var req = System.Net.WebRequest.Create(url);
     
            req.ContentType = "application/x-www-form-urlencoded";
            req.Headers.Add("OpenPayu-Signature:sender="+pos_id+";signature=" + hashsign + ";algorithm=SHA256;content=DOCUMENT");
            req.Method = "POST";
            byte[] bytes = Encoding.UTF8.GetBytes(post_data);
            req.ContentLength = bytes.Length;
            System.IO.Stream os = req.GetRequestStream();
            os.Write(bytes, 0, bytes.Length);
            os.Close();
            System.Net.WebResponse resp = req.GetResponse();
            if (resp == null)
                return null;
            var sr = new StreamReader(resp.GetResponseStream());
            return sr.ReadToEnd().Trim();
        }
     
        public string ComputeHash(string input, HashAlgorithm algorithm)
        {
            Byte[] inputBytes = Encoding.UTF8.GetBytes(input);
            Byte[] hashedBytes = algorithm.ComputeHash(inputBytes);
            return BitConverter.ToString(hashedBytes).Replace("-","").ToLower();
        }
    }
}
